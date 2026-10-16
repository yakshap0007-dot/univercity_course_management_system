CREATE DATABASE IF NOT EXISTS university_data_transformer;
USE university_data_transformer;

DROP TABLE IF EXISTS Enrollments;
DROP TABLE IF EXISTS Courses;
DROP TABLE IF EXISTS Instructors;
DROP TABLE IF EXISTS Students;
DROP TABLE IF EXISTS Departments;

CREATE TABLE Departments (
 DepartmentID INT PRIMARY KEY,
 DepartmentName VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Students (
 StudentID INT PRIMARY KEY,
 FirstName VARCHAR(50) NOT NULL,
 LastName VARCHAR(50) NOT NULL,
 Email VARCHAR(120) UNIQUE,
 BirthDate DATE,
 EnrollmentDate DATE NOT NULL
);

CREATE TABLE Courses (
 CourseID INT PRIMARY KEY,
 CourseName VARCHAR(100) NOT NULL,
 DepartmentID INT NOT NULL,
 Credits INT NOT NULL,
 FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

CREATE TABLE Instructors (
 InstructorID INT PRIMARY KEY,
 FirstName VARCHAR(50) NOT NULL,
 LastName VARCHAR(50) NOT NULL,
 Email VARCHAR(120) UNIQUE,
 DepartmentID INT NOT NULL,
 Salary DECIMAL(10,2) NOT NULL,
 FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

CREATE TABLE Enrollments (
 EnrollmentID INT PRIMARY KEY,
 StudentID INT NOT NULL,
 CourseID INT NOT NULL,
 EnrollmentDate DATE NOT NULL,
 FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
 FOREIGN KEY (CourseID) REFERENCES Courses(CourseID),
 UNIQUE (StudentID, CourseID)
);

INSERT INTO Departments VALUES
(1,'Computer Science'),(2,'Mathematics'),(3,'Information Technology');

INSERT INTO Students VALUES
(1,'John','Doe','john.doe@email.com','2000-01-15','2022-08-01'),
(2,'Jane','Smith','jane.smith@email.com','1999-05-25','2021-08-01'),
(3,'Amit','Shah','amit.shah@email.com','2002-03-12','2023-07-15'),
(4,'Priya','Patel','priya.patel@email.com','2001-11-09','2024-08-01'),
(5,'Ravi','Mehta','ravi.mehta@email.com','2000-06-20','2020-08-01'),
(6,'Sara','Khan','sara.khan@email.com','2003-02-18','2025-08-01');

INSERT INTO Courses VALUES
(101,'Introduction to SQL',1,3),(102,'Data Structures',1,4),
(103,'Database Systems',1,4),(104,'Calculus',2,4),
(105,'Linear Algebra',2,3),(106,'Statistics',2,3),
(107,'Web Development',3,3);

INSERT INTO Instructors VALUES
(1,'Alice','Johnson','alice.johnson@univ.com',1,72000),
(2,'Bob','Lee','bob.lee@univ.com',2,68000),
(3,'Meera','Desai','meera.desai@univ.com',1,81000),
(4,'Karan','Patel','karan.patel@univ.com',3,65000);

INSERT INTO Enrollments VALUES
(1,1,101,'2022-08-01'),(2,2,102,'2021-08-01'),
(3,1,102,'2022-08-02'),(4,3,101,'2023-07-15'),
(5,3,103,'2023-07-16'),(6,4,104,'2024-08-01'),
(7,5,105,'2020-08-01'),(8,2,101,'2021-08-03'),
(9,6,107,'2025-08-01'),(10,4,105,'2024-08-02'),
(11,5,101,'2020-08-02'),(12,6,102,'2025-08-02');

-- Check all five tables
SELECT * FROM Students;
SELECT * FROM Courses;
SELECT * FROM Instructors;
SELECT * FROM Enrollments;
SELECT * FROM Departments;

-- 1. CRUD operations (example on Departments; use the same pattern for other tables)
INSERT INTO Departments VALUES (99,'Temporary Department');
SELECT * FROM Departments WHERE DepartmentID=99;
UPDATE Departments SET DepartmentName='Updated Temporary Department' WHERE DepartmentID=99;
DELETE FROM Departments WHERE DepartmentID=99;

-- 2. Students enrolled after 2022
SELECT * FROM Students WHERE EnrollmentDate >= '2023-01-01';

-- 3. Mathematics courses, maximum five
SELECT c.CourseID,c.CourseName,c.Credits
FROM Courses c JOIN Departments d ON c.DepartmentID=d.DepartmentID
WHERE d.DepartmentName='Mathematics' ORDER BY c.CourseID LIMIT 5;

-- 4. Courses with more than five enrolled students
SELECT c.CourseID,c.CourseName,COUNT(e.StudentID) AS StudentCount
FROM Courses c JOIN Enrollments e ON c.CourseID=e.CourseID
GROUP BY c.CourseID,c.CourseName HAVING COUNT(e.StudentID)>5;

-- 5. Students taking BOTH Introduction to SQL and Data Structures
SELECT s.StudentID,s.FirstName,s.LastName
FROM Students s JOIN Enrollments e ON s.StudentID=e.StudentID
JOIN Courses c ON e.CourseID=c.CourseID
WHERE c.CourseName IN ('Introduction to SQL','Data Structures')
GROUP BY s.StudentID,s.FirstName,s.LastName
HAVING COUNT(DISTINCT c.CourseName)=2;

-- 6. Students taking EITHER Introduction to SQL or Data Structures
SELECT DISTINCT s.StudentID,s.FirstName,s.LastName,c.CourseName
FROM Students s JOIN Enrollments e ON s.StudentID=e.StudentID
JOIN Courses c ON e.CourseID=c.CourseID
WHERE c.CourseName IN ('Introduction to SQL','Data Structures');

-- 7. Average credits
SELECT AVG(Credits) AS AverageCourseCredits FROM Courses;

-- 8. Highest salary in Computer Science
SELECT MAX(i.Salary) AS MaximumSalary
FROM Instructors i JOIN Departments d ON i.DepartmentID=d.DepartmentID
WHERE d.DepartmentName='Computer Science';

-- 9. Student count by department based on course enrollments
SELECT d.DepartmentID,d.DepartmentName,COUNT(DISTINCT e.StudentID) AS StudentCount
FROM Departments d LEFT JOIN Courses c ON d.DepartmentID=c.DepartmentID
LEFT JOIN Enrollments e ON c.CourseID=e.CourseID
GROUP BY d.DepartmentID,d.DepartmentName;

-- 10. INNER JOIN: students and courses
SELECT s.StudentID,s.FirstName,s.LastName,c.CourseName,e.EnrollmentDate
FROM Students s JOIN Enrollments e ON s.StudentID=e.StudentID
JOIN Courses c ON e.CourseID=c.CourseID;

-- 11. LEFT JOIN: all students, including those without courses
SELECT s.StudentID,s.FirstName,s.LastName,c.CourseName
FROM Students s LEFT JOIN Enrollments e ON s.StudentID=e.StudentID
LEFT JOIN Courses c ON e.CourseID=c.CourseID ORDER BY s.StudentID;

-- 12. Students enrolled in courses with more than 10 students
SELECT DISTINCT s.StudentID,s.FirstName,s.LastName
FROM Students s WHERE s.StudentID IN (
 SELECT e.StudentID FROM Enrollments e WHERE e.CourseID IN (
  SELECT CourseID FROM Enrollments GROUP BY CourseID HAVING COUNT(*)>10
 )
);

-- 13. Extract enrollment year
SELECT StudentID,FirstName,LastName,EnrollmentDate,YEAR(EnrollmentDate) AS EnrollmentYear
FROM Students;

-- 14. Concatenate instructor first and last names
SELECT InstructorID,CONCAT(FirstName,' ',LastName) AS InstructorFullName
FROM Instructors;

-- 15. Running total of enrollments
SELECT EnrollmentID,StudentID,CourseID,EnrollmentDate,
 COUNT(*) OVER (ORDER BY EnrollmentDate,EnrollmentID
 ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningEnrollmentTotal
FROM Enrollments;

-- 16. Senior if enrolled more than four years ago; otherwise Junior
SELECT StudentID,FirstName,LastName,EnrollmentDate,
 CASE WHEN EnrollmentDate < DATE_SUB(CURDATE(),INTERVAL 4 YEAR)
 THEN 'Senior' ELSE 'Junior' END AS StudentLevel
FROM Students;
