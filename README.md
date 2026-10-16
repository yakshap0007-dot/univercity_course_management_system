# univercity_course_management_system
University Data Transformer
About the Project

University Data Transformer is a beginner-friendly SQL project. It uses sample university data about students, courses, instructors, enrollments, and departments. It shows how SQL can organise data, connect tables, count records, calculate values, and prepare information for reports.

Objectives
- Create and manage database tables.
- Practise CRUD: Create, Read, Update, and Delete.
- Filter students and courses.
- Count enrolled students and calculate average credits or maximum salary.
- Combine data using INNER JOIN and LEFT JOIN.
- Use subqueries, date functions, string functions, window functions, and CASE.
- 
Tables
1. Students: StudentID, FirstName, LastName, Email, BirthDate, EnrollmentDate.
2. Courses: CourseID, CourseName, DepartmentID, Credits.
3. Instructors: InstructorID, FirstName, LastName, Email, DepartmentID, Salary.
4. Enrollments: EnrollmentID, StudentID, CourseID, EnrollmentDate.
5. Departments: DepartmentID, DepartmentName.

SQL Topics Covered
- CRUD operations
- WHERE, ORDER BY, LIMIT
- COUNT(), AVG(), MAX(), GROUP BY, HAVING
- INNER JOIN and LEFT JOIN
- Subqueries
- YEAR() and DATE_SUB()
- CONCAT()
- Window function COUNT() OVER()
- CASE expressions
- 
Requirements
- MySQL 8.0 or later
- MySQL Workbench or another MySQL client

Important: The script drops and recreates the project tables at the start. Do not run it where you have important data to keep.
Assumptions
- “Enrolled after 2022” means on or after 1 January 2023.
- Department student counts are based on students enrolled in courses belonging to that department.
- “Both courses” means students enrolled in both Introduction to SQL and Data Structures.
- “More than 10 students” means more than 10 enrollment records for a course.
- A student is labelled Senior when their enrollment date is more than four years before today's date; otherwise, they are labelled Junior.
- The sample records are for learning and demonstration.

Files
- university_data_transformer.sql — database setup, sample data, and SQL queries.
- README.md — project description and run instructions.

Learning Outcomes
This project helps students practise relational tables, joins, filtering, grouping, subqueries, and date, string, and window functions.

Author
yaksha patel

Purpose
Created for educational and SQL practice purposes.
