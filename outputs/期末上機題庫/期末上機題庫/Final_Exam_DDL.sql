## Department (DeptId, Name) #0
CREATE TABLE Department (
    DeptId  VARCHAR(2),
    Name  CHAR(20) NOT NULL,
    PRIMARY KEY (DeptId) );

## Professor (ProfId, Name, DeptId) #1
CREATE TABLE Professor (
    ProfId  INTEGER,
    Name  CHAR(20) NOT NULL,
    DeptId VARCHAR(2),
    PRIMARY KEY (ProfId),
    FOREIGN KEY (DeptId) REFERENCES Department(DeptId));

## Student (Id, Name, Addr, Status) #2
CREATE TABLE Student (
    StdId  INTEGER,
    Name  CHAR(20) NOT NULL,
    Address  CHAR(50),
    Status  VARCHAR(1), -- e.g., 'A','B','C','D'
    PRIMARY KEY (StdId) );


## Course (DeptId, CrsCode, CrsName, Descr) #2
CREATE TABLE Course (
    CrsCode VARCHAR(4),
    CrsName CHAR(20),
    DeptId VARCHAR(2),
    Descr CHAR(100),
    PRIMARY KEY (CrsCode),
    UNIQUE (DeptId, CrsName),   -- candidate key
    FOREIGN KEY (DeptId) REFERENCES Department(DeptId));


## Teaching (ProfId, CrsCode, Semester) #3
CREATE TABLE Teaching (
    ProfId   INTEGER,
    CrsCode   VARCHAR (4),
    Semester   VARCHAR (5), -- e.g., '2025A' for Spring 2025
    PRIMARY KEY (CrsCode, Semester),
    FOREIGN KEY (CrsCode) REFERENCES Course (CrsCode),
    FOREIGN KEY (ProfId) REFERENCES Professor (ProfId) );

## Transcript (StudId, CrsCode, Semester, Grade) #4
CREATE TABLE Transcript (
    StudId  INTEGER,
    CrsCode  VARCHAR(4),
    Semester   VARCHAR (5), -- e.g., '2025A' for Spring 2025
    Grade  CHAR(1), -- 預設NULL
    PRIMARY KEY (StudId, CrsCode, Semester),
    FOREIGN KEY (StudId) REFERENCES Student (StdId),
    FOREIGN KEY (CrsCode) REFERENCES Course (CrsCode),
    FOREIGN KEY (CrsCode, Semester) REFERENCES Teaching(CrsCode, Semester) );

