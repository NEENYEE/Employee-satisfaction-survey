CREATE DATABASE survey;

USE survey;

CREATE TABLE employee_survey (
Response_ID INT,
Status VARCHAR(20),
Department VARCHAR(50),
Director INT,
Manager INT,
Supervisor INT,
Staff INT,
Question VARCHAR(100),
Response INT,
Response_text VARCHAR(50)
);

ALTER TABLE employee_survey
MODIFY COLUMN Director BINARY;

ALTER TABLE employee_survey
MODIFY COLUMN Manager BINARY;

ALTER TABLE employee_survey
MODIFY COLUMN Supervisor BINARY;

ALTER TABLE employee_survey
MODIFY COLUMN staff BINARY;

SELECT *
FROM employee_survey;

-- Overall completion rate-----
SELECT 
ROUND(COUNT(Status)/(SELECT COUNT(*) FROM employee_survey) * 100, 2)AS Completion_rate,
COUNT(status), 
status
FROM employee_survey
GROUP BY STATUS;

-- Completion rate by dept-----
SELECT 
    ROUND(COUNT(status) / SUM(COUNT(*)) OVER (PARTITION BY department) * 100, 2) AS Percentage,
    COUNT(status) AS Count,
    status,
    department
FROM employee_survey
GROUP BY Status, department;

-- completion rate by role
-- percentage
SELECT status,
    ROUND(SUM(CASE WHEN Director = 1 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS Director,
    ROUND(SUM(CASE WHEN Manager = 1 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS Manager,
    ROUND(SUM(CASE WHEN Supervisor = 1 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS Supervisor,
    ROUND(SUM(CASE WHEN Staff = 1 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS Staff,
    ROUND(SUM(CASE WHEN Director = 0 AND Manager = 0 AND Supervisor = 0 AND Staff = 0 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS Others
FROM employee_survey
GROUP BY Status;

-- count
SELECT 
    Status,
    SUM(Director) AS Director_Count,
    SUM(Manager) AS Manager_Count,
    SUM(Supervisor) AS Supervisor_Count,
    SUM(Staff) AS Staff_Count,
    SUM(CASE WHEN Director = 0 AND Manager = 0 AND Supervisor = 0 AND Staff = 0 THEN 1 ELSE 0 END) AS Others_count
FROM employee_survey
GROUP BY Status;

-- overall response count
SELECT 
    Question,
    SUM(CASE WHEN Response = 0 THEN 1 ELSE 0 END) AS NotApp_Count,
    SUM(CASE WHEN Response = 1 THEN 1 ELSE 0 END) AS StronglyDisagree_Count,
    SUM(CASE WHEN Response = 2 THEN 1 ELSE 0 END) AS Disagree_Count,
    SUM(CASE WHEN Response = 3 THEN 1 ELSE 0 END) AS Agree_Count,
    SUM(CASE WHEN Response = 4 THEN 1 ELSE 0 END) AS StronglyAgree_4_Count
FROM employee_survey
WHERE status = 'complete'
GROUP BY Question;


-- Percentage responses-------------------------------------------

SELECT 
    Question,
    ROUND(SUM(CASE WHEN Response = 0 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS NotApp_Percentage,
    ROUND(SUM(CASE WHEN Response = 1 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS StronglyDisagree_Percentage,
    ROUND(SUM(CASE WHEN Response = 2 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS Disagree_Percentage,
    ROUND(SUM(CASE WHEN Response = 3 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS Agree_Percentage,
    ROUND(SUM(CASE WHEN Response = 4 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS StronglyAgree_Percentage
FROM employee_survey
WHERE Status = 'complete'
GROUP BY Question;


-- Which survey questions did respondents agree with or disagree with most?-----------------

WITH Total_Responses AS (
    SELECT 
        Question,
        ROUND(SUM(CASE WHEN Response IN (3, 4) THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS Total_Agreed_Percentage,
        ROUND(SUM(CASE WHEN Response IN (1, 2) THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS Total_Disagreed_Percentage
    FROM employee_survey
    WHERE Status = 'complete'
    GROUP BY Question
)
SELECT 
    (SELECT 
        Question
    FROM Total_Responses
    ORDER BY Total_Agreed_Percentage DESC
    LIMIT 1) AS Most_Agreed_Question,
    (SELECT 
        Question
    FROM Total_Responses
    ORDER BY Total_Disagreed_Percentage DESC
    LIMIT 1) AS Most_Disagreed_Question;


-- any patterns or trends by department ?----------

WITH dept_responses AS (
    SELECT 
        Question,
        Department,
        ROUND(SUM(CASE WHEN Response IN (3, 4) THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS Total_Agreed_Percentage,
        ROUND(SUM(CASE WHEN Response IN (1, 2) THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS Total_Disagreed_Percentage
    FROM employee_survey
    WHERE Status = 'complete'
    GROUP BY Question, Department
)
SELECT 
    Department,
    (SELECT 
        Question
    FROM dept_responses AS dr
    WHERE dr.Department = drr.Department
    ORDER BY Total_Agreed_Percentage DESC
    LIMIT 1) AS Most_Agreed_Question,
    (SELECT 
        Question
    FROM dept_responses AS dr
    WHERE dr.Department = drr.Department
    ORDER BY Total_Disagreed_Percentage DESC
    LIMIT 1) AS Most_Disagreed_Question
FROM dept_responses AS drr
GROUP BY Department;


-- any patterns or trends by role?----------

-- DIRECTOR
WITH director_survey_results AS (
    SELECT 
        Department,
        Director,
        Question,
        ROUND(SUM(CASE WHEN Response IN (3, 4) THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS Total_Agreed_Percentage,
        ROUND(SUM(CASE WHEN Response IN (1, 2) THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS Total_Disagreed_Percentage
    FROM employee_survey
    WHERE Director = 1 AND Status = 'complete'
    GROUP BY Department, Director, Question
)
SELECT 
 Director,
    (SELECT 
        Question
    FROM director_survey_results AS agreed
    ORDER BY Total_Agreed_Percentage DESC
    LIMIT 1) AS Most_Agreed_Question,
    
    (SELECT 
        Question
    FROM director_survey_results AS disagreed
    ORDER BY Total_Disagreed_Percentage DESC
    LIMIT 1) AS Most_Disagreed_Question
    
FROM director_survey_results AS results
GROUP BY Director;


-- MANAGER
WITH Manager_survey_results AS (
    SELECT 
        Department,
        Manager,
        Question,
        ROUND(SUM(CASE WHEN Response IN (3, 4) THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS Total_Agreed_Percentage,
        ROUND(SUM(CASE WHEN Response IN (1, 2) THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS Total_Disagreed_Percentage
    FROM employee_survey
    WHERE Manager = 1 AND Status = 'complete'
    GROUP BY Department, Manager, Question
)
SELECT 
    Manager,
    (SELECT 
        Question
    FROM Manager_survey_results AS agreed
    ORDER BY Total_Agreed_Percentage DESC
    LIMIT 1) AS Most_Agreed_Question,
    
    (SELECT 
        Question
    FROM Manager_survey_results AS disagreed

    ORDER BY Total_Disagreed_Percentage DESC
    LIMIT 1) AS Most_Disagreed_Question
    
FROM Manager_survey_results AS results
GROUP BY Manager;

-- SUPERVISOR
WITH Supervisor_survey_results AS (
    SELECT 
        Department,
        Supervisor,
        Question,
        ROUND(SUM(CASE WHEN Response IN (3, 4) THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS Total_Agreed_Percentage,
        ROUND(SUM(CASE WHEN Response IN (1, 2) THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS Total_Disagreed_Percentage
    FROM employee_survey
    WHERE Supervisor = 1 AND Status = 'complete'
    GROUP BY Department, Supervisor, Question
)
SELECT 
    Supervisor,
    (SELECT 
        Question
    FROM Supervisor_survey_results AS agreed
    ORDER BY Total_Agreed_Percentage DESC
    LIMIT 1) AS Most_Agreed_Question,
    
    (SELECT 
        Question
    FROM Supervisor_survey_results AS disagreed

    ORDER BY Total_Disagreed_Percentage DESC
    LIMIT 1) AS Most_Disagreed_Question
    
FROM Supervisor_survey_results AS results
GROUP BY Supervisor;

-- STAFF
WITH Staff_survey_results AS (
    SELECT 
        Department,
        Staff,
        Question,
        ROUND(SUM(CASE WHEN Response IN (3, 4) THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS Total_Agreed_Percentage,
        ROUND(SUM(CASE WHEN Response IN (1, 2) THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS Total_Disagreed_Percentage
    FROM employee_survey
    WHERE Staff = 1 AND Status = 'complete'
    GROUP BY Department, Supervisor, Question
)
SELECT 
    Staff,
    (SELECT 
        Question
    FROM Staff_survey_results AS agreed
    ORDER BY Total_Agreed_Percentage DESC
    LIMIT 1) AS Most_Agreed_Question,
    
    (SELECT 
        Question
    FROM Staff_survey_results AS disagreed

    ORDER BY Total_Disagreed_Percentage DESC
    LIMIT 1) AS Most_Disagreed_Question
    
FROM Staff_survey_results AS results
GROUP BY Staff;

-- NO ROLE IDENTIFIED

WITH Others_survey_results AS (
    SELECT 
        Department,
        "Others",
        Question,
        ROUND(SUM(CASE WHEN Response IN (3, 4) THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS Total_Agreed_Percentage,
        ROUND(SUM(CASE WHEN Response IN (1, 2) THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS Total_Disagreed_Percentage
    FROM employee_survey
    WHERE Staff = 0 AND Manager = 0 AND Supervisor = 0 AND Director = 0 AND Status = 'complete'
    GROUP BY Department, "Others", Question
)
SELECT 
    "Others",
    (SELECT 
        Question
    FROM NoRole_survey_results AS agreed
    ORDER BY Total_Agreed_Percentage DESC
    LIMIT 1) AS Most_Agreed_Question,
    
    (SELECT 
        Question
    FROM NoRole_survey_results AS disagreed
    ORDER BY Total_Disagreed_Percentage DESC
    LIMIT 1) AS Most_Disagreed_Question
    
FROM NoRole_survey_results AS results
GROUP BY "Others";
