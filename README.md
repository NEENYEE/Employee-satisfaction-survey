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
  - 1. I know what is expected of me at work
  - 2. At work, I have the opportunity to do what I do best every day
  - 3. In the last seven days, I have received recognition or praise for doing good work
  - 4. My supervisor, or someone at work, seems to care about me as a person
  - 5. The mission or purpose of our organization makes me feel my job is important
  - 6. I have a best friend at work
  - 7. This last year, I have had opportunities at work to learn and grow
  - 8. My supervisor holds employees accountable for performance
  - 9. My department is inclusive and demonstrates support of a diverse workforce
  - 10. Overall I am satisfied with my job.

- Overall, the most agreed question was 'I know what is expected of me at work' with agreement rate of 92.3%; while the most disagree question was 'I have a best friend at work' with a rate of 41.6%
- Directors agreed most Q1 and diagreed with Q6
- Managers agreed most with Q1 and diagreed with Q6
- Staff agreed most with Q3 and disagreed with Q5
- Supervisors agreed most with Q1 and disagreed with Q3
- Others agreed most with Q1 and disagreed with Q3

- Q1 was the most agreed across all departments while Q6 was the most disagreed.


## Recommendations
Based on the survey results, here are some recommendations to address the key findings:

**Clarify Expectations and Communication:**

Since "I know what is expected of me at work" received the highest agreement rate, it indicates that clear expectations contribute to employee satisfaction. Continue to emphasize transparent communication of roles, responsibilities, and objectives to ensure alignment across all levels of the organization.

**Promote Social Connections and Collaboration:**

Given that "I have a best friend at work" had the highest disagreement rate, consider initiatives to foster social connections and build a supportive work environment. Encourage team-building activities, mentorship programs, and cross-functional collaboration to facilitate meaningful relationships among employees.

**Recognition and Feedback Mechanisms:**

Enhance recognition and feedback mechanisms to acknowledge employees' contributions and achievements. Implement regular performance evaluations, peer recognition programs, and opportunities for constructive feedback to reinforce positive behaviors and boost morale.

**Invest in Learning and Development:**

Address the discrepancy in agreement rates for "This last year, I have had opportunities at work to learn and grow" across different roles. Provide access to training programs, skill development workshops, and career advancement opportunities tailored to the specific needs and career aspirations of employees in each role.

**Cultivate Inclusive and Supportive Work Environments:**

Focus on promoting diversity, equity, and inclusion within departments by fostering a culture of respect, acceptance, and support for all employees. Offer diversity training, create affinity groups, and establish policies and practices that promote inclusivity and demonstrate organizational commitment to diversity.

**Continuous Feedback and Improvement:**

Regularly solicit feedback from employees through surveys, focus groups, or one-on-one meetings to gauge satisfaction levels and identify areas for improvement. Use this feedback to drive continuous improvement initiatives and ensure that employee voices are heard and valued.
By addressing these recommendations, organizations can create a positive work environment where employees feel valued, supported, and motivated to contribute their best efforts, ultimately leading to higher levels of job satisfaction and overall organizational success.






