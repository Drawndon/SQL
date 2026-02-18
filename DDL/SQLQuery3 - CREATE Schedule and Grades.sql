--SQLQuery3 - CREATE Schedule and Grades.sql

--USE PV_521_DDL;

--CREATE TABLE Exams
--(
--	student			INT,
--	discipline		SMALLINT,
--	grade			TINYINT		CONSTRAINT	CK_Grade	CHECK	(grade > 0 AND grade <= 12),
--	PRIMARY KEY(student, discipline),
--	CONSTRAINT		FK_SDR_Student		FOREIGN KEY	(student)		REFERENCES	Students(student_id),
--	CONSTRAINT		FK_SDR_Discipline	FOREIGN KEY	(discipline)	REFERENCES	Disciplines(discipline_id)
--)

--CREATE TABLE Schedule
--(
--	lesson_id		INT				PRIMARY KEY,
--	[date]			DATE			NOT NULL,
--	[time]			TIME(7)			NOT NULL,
--	[subject]		VARCHAR(256)	NULL,
--	[status]		BIT				NOT NULL,
--	[group]			INT				NOT NULL
--	CONSTRAINT		FK_GScR_Group		FOREIGN KEY	REFERENCES Groups(group_id),
--	discipline		SMALLINT		NOT NULL
--	CONSTRAINT		FK_DScR_Discipline		FOREIGN KEY REFERENCES Disciplines(discipline_id),
--	teacher			INT				NOT NULL	
--	CONSTRAINT		FK_TScR_Teacher		FOREIGN KEY REFERENCES Teachers(teacher_id)
--)


--CREATE TABLE HomeWorks
--(
--	lesson		INT		PRIMARY KEY --(Ошибочно), (--Так правильно -- CONSTRAINT	FK_HW_Group		FOREIGN KEY REFERENCES	Groups(group_id),
--	[group]		INT
--	CONSTRAINT	FK_HWGR_Group		FOREIGN KEY	REFERENCES	Groups(group_id),
--	task		BINARY(1000)	NOT NULL,
--	comment		NVARCHAR(1024),
--	CONSTRAINT	CK_TASK_OR_COMMENT	CHECK	(task IS NOT NULL or comment IS NOT NULL),
--	PRIMARY KEY([group], lesson),
--	deadline	INT				NOT NULL,

--)

--CREATE TABLE Grades
--(
--	student		INT,
--	lesson		INT,
--	PRIMARY KEY(student, lesson),
--	CONSTRAINT	FK_ScStR_Student		FOREIGN KEY (student)	REFERENCES	Students(student_id),
--	CONSTRAINT	FK_ScStR_Schedule		FOREIGN KEY	(lesson)	REFERENCES	Schedule(lesson_id),
--	grade1		TINYINT CONSTRAINT		CK_Grade1	CHECK	(grade1 > 0 AND grade1 <= 12),
--	grade2		TINYINT	CONSTRAINT		CK_Grade2	CHECK	(grade2 > 0 AND	grade2 <= 12)
--)

CREATE TABLE ResultsHW
(
	student		INT							CONSTRAINT		FK_StRHWR_Student	FOREIGN KEY REFERENCES Students(student_id),
	[group]		INT,
	lesson		INT,
	CONSTRAINT		FK_GRHWR_Group			FOREIGN KEY ([group], lesson)		REFERENCES HomeWorks([group], lesson),
	result		BINARY(1000)	NOT NULL,
	report		INT				NOT NULL,
	grade		INT				NOT NULL,
	PRIMARY KEY(student, [group], lesson)
);
--DROP TABLE HomeWorks;

