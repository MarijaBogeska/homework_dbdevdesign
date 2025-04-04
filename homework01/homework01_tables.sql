-- ENUM FOR GENDER
CREATE TYPE gender AS ENUM ('male','female');
--  ENUM FOR ACHIEVEMENTS
CREATE TYPE achievementLevels AS ENUM ('basic','proficient','advanced');
-- CREATE STUDENT TABLE
CREATE TABLE student (
id SERIAL PRIMARY KEY,
firstName VARCHAR(20),
lastName VARCHAR(30),
dateOfBirth DATE,
enrolledDate DATE,
gender gender,
nationalIdNumber INTEGER,
studentCardNumber INTEGER
);
-- CREATE TEACHER TABLE
CREATE TABLE teacher (
id SERIAL PRIMARY KEY,
firstName VARCHAR(20),
lastName VARCHAR(30),
dateOfBirth DATE,
academicRank VARCHAR(20),
hireDate DATE
);
-- CREATE COURSE 
CREATE TABLE course(
id SERIAL PRIMARY KEY,
name VARCHAR(60),
credit INTEGER,
academicYear DATE,
semestar INTEGER
);
-- CREATE GRADE
CREATE TABLE grade(
id SERIAL PRIMARY KEY,
studentId INTEGER REFERENCES student(id),
courseId INTEGER REFERENCES course(id),
teacherId INTEGER REFERENCES teacher(id),
grade SMALLINT,
comment VARCHAR(100),
createdDate DATE
);
-- CREATE ACHIEVEMENT TYPE
CREATE TABLE achievementType (
id SERIAL PRIMARY KEY,
name achievementLevels,
description VARCHAR(200),
participationRate INTEGER
);
-- CREATE GRADE DETAILS
CREATE TABLE gradeDetails(
id SERIAL PRIMARY KEY,
gradeId INTEGER REFERENCES grade(id),
achievementTypeId INTEGER REFERENCES achievementType(id),
achievementPoints INTEGER,
achievementMaxPoints INTEGER,
achievementDate DATE
);
-- INSERT DATA IN STUDENT
INSERT INTO student (firstName, lastName, dateOfBirth, enrolledDate, gender, nationalIdNumber, studentCardNumber)
VALUES 
	('John', 'Doe', '2002-05-15', '2021-09-01', 'male', 123456789, 987654321);
-- INSERT DATA IN TEACHER
INSERT INTO teacher (firstName, lastName, dateOfBirth, academicRank, hireDate) 
VALUES 
('Alice', 'Johnson', '1980-04-25', 'Professor', '2010-08-15');
-- INSERT DATA IN COURSE
INSERT INTO course (name, credit, academicYear, semestar)
VALUES 
('Introduction to Programming', 6, '2024-09-01', 1),
('Data Structures and Algorithms', 6, '2024-09-01', 3),
('Database Systems', 5, '2025-02-01', 4),
('Web Development', 5, '2025-02-01', 4),
('Operating Systems', 6, '2024-09-01', 3),
('Artificial Intelligence', 6, '2025-09-01', 5);
-- INSERT DATA IN GRADE
INSERT INTO grade (studentId, courseId, teacherId, grade, comment, createdDate)
VALUES
(1, 1, 1, 10, 'Excellent performance', '2025-01-15');
-- INSERT DATA IN ACHIEVEMENT TYPE
INSERT INTO achievementType (name, description, participationRate)
VALUES
('basic', 'Basic level achievement, shows initial understanding', 60),
('proficient', 'Proficient level achievement, demonstrates solid skills', 80),
('advanced', 'Advanced level achievement, shows exceptional performance', 95);
-- INSERT DATA IN GRADE DEATILS
INSERT INTO gradeDetails (gradeId, achievementTypeId, achievementPoints, achievementMaxPoints, achievementDate)
VALUES
(1, 3, 45, 50, '2025-01-20');
-- READ DATA
SELECT * FROM gradeDetails;
