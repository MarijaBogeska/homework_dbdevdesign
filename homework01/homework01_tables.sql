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
-- READ DATA
SELECT * FROM gradeDetails;
