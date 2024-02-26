## Employee Survey-Responses Analysis
![image](https://github.com/NEENYEE/Employee-satisfaction-survey/assets/101926233/d5612f53-4801-49b4-b955-0dfef5cd41d4)


## Overview

Welcome to the analysis of the Employee Survey Responses dataset! This dataset contains responses from an employee engagement survey conducted by Pierce County, WA, 
voluntarily completed by government employees. Our goal is to gain insights into employee perceptions, satisfaction, and engagement within the organization. In this analysis, we'll explore the dataset to uncover patterns, correlations, and trends in employee responses. Through statistical analysis and visualization, we'll delve into various aspects of the employee experience, including job satisfaction, work environment, leadership effectiveness, and organizational culture. By extracting key insights from the data, we aim to inform decision-making and organizational strategies to foster a positive workplace environment and drive organizational performance. Let's embark on this journey together to explore the survey responses and work towards enhancing employee engagement and satisfaction within Pierce County, WA.

## Problem Statement

Question 1: Identifying Agreement and Disagreement
One of the primary objectives of this analysis is to identify the survey questions with which respondents most strongly agreed or disagreed. By understanding the questions that received high levels of agreement or disagreement, we can gain insights into areas of consensus or contention within the organization, and prioritize actions to address them effectively.

Question 2: Exploring Patterns by Department or Role
Another key aspect of our analysis is to uncover any patterns or trends based on departmental or role-specific responses. By examining responses across different departments and roles, we aim to identify any disparities or commonalities in employee perceptions and experiences. This will allow us to tailor interventions and initiatives to address specific needs and challenges within different segments of the organization.

Question 3: Enhancing Employee Satisfaction
As employers, it's crucial to proactively address areas of concern and prioritize initiatives to improve employee satisfaction. Based on the survey results, we will explore potential steps and strategies that organizations can undertake to enhance employee satisfaction and engagement. By implementing targeted interventions informed by the survey findings, organizations can create a more positive and fulfilling work environment, leading to higher levels of employee retention, productivity, and overall organizational success.

## Data Source

The dataset was provided by Digitaley drive as an integral part of my capstone project [data source](https://docs.google.com/spreadsheets/d/1nbhfp2ModgqDAPveYQG9CknRw2PYJQxbOTs3xSKOB8E/edit#gid=61186505). The dataset consists of one table made up of one table (14,710 column and 10 rows.

## Tools
In this analysis, I utilized a combination of Power BI, Power Query, and SQL to effectively explore, transform, and analyze the Employee Survey Responses dataset. Power BI served as the primary visualization tool, enabling the creation of interactive dashboards and reports to visually represent key insights derived from the data. Power Query played a crucial role in data preparation, allowing for seamless data cleansing, transformation, and integration tasks to ensure the dataset's quality and consistency. Additionally, SQL was leveraged for advanced data manipulation and querying capabilities, providing flexibility in extracting specific subsets of data and performing complex analyses. Together, these tools facilitated a comprehensive analysis of the survey responses, enabling the extraction of actionable insights to inform decision-making and organizational strategies.

## Data Cleaning and Transformation
In this analysis of the Employee Survey Responses dataset, the data cleaning process involved identifying and addressing various issues such as missing values, duplicates, outliers, and inconsistencies. Missing values were handled through imputation or removal, duplicates were identified and removed to maintain data integrity.
- Empty rows in the response column were replace with "-1" for the sake of identity and better manipulation using sql.
- Trimmed the question column
- Find and relace for question 7 in the question column
- removed duplicate rows
- Respondents who didnt identify under any role were replaced with 'others' as their role.

## Data Analysis

In the data analysis process, SQL was employed as a powerful tool to manipulate and extract insights from the Employee Survey Responses dataset. SQL's capabilities were leveraged to perform various data manipulation tasks, including filtering, aggregating, and joining data, allowing for a comprehensive analysis of the survey responses.

One notable technique utilized in SQL was the use of Common Table Expressions (CTEs) to organize and structure complex queries. CTEs enabled the creation of temporary result sets that could be referenced multiple times within a single query, enhancing code readability and simplifying complex data transformations. For instance, CTEs were employed to find out Wwich survey questions respondents agreed with or disagreed with the most?

```sql
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
```

CTEs were also utilized to find out trends by department

```sql
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
```

 ## Key insights
 
 - 99.08% of 14,710 respondents completed the survey.
 - The survey was carried out across 21 departments.
 - Respondents who identified as 'others' were the most responsdents with a count of 10,560.
 - The survey consisted of Questions namely:
 - 
