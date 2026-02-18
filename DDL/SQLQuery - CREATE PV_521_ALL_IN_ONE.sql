--SQLQuery - CREATE PV_521_ALL_IN_ONE.sql

--CREATE DATABASE PV_521_ALL_IN_ONE
--ON
--(
--	NAME		=	PV_521_ALL_IN_ONE,
--	FILENAME	=	'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\PV_521_ALL_IN_ONE.mdf',
--	SIZE		=	8 MB,
--	MAXSIZE		=	500 MB,
--	FILEGROWTH	=	8 MB
--)
--LOG ON
--(
--	NAME		=	PV_521_ALL_IN_ONE_log,
--	FILENAME	=	'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\PV_521_ALL_IN_ONE.ldf',
--	SIZE		=	8 MB,
--	MAXSIZE		=	500 MB,
--	FILEGROWTH	=	8 MB
--);
USE PV_521_ALL_IN_ONE;

CREATE TABLE Directions
(
	direction_id		TINYINT			PRIMARY KEY,
	direction_name		NVARCHAR(150)	NOT NULL,
)

CREATE TABLE Groups
(
	group_id		INT			PRIMARY KEY,
	group_name		NVARCHAR(24)	NOT NULL,
	direction		TINYINT			NOT NULL		--описание поля
	CONSTRAINT		FK_Groups_Direction	FOREIGN KEY REFERENCES	Directions(direction_id)
--	CONSTRAINT		FK_Имя_ВнешнегоКлюча	FOREIGN KEY REFERENCES	Таблица(первичный_ключ_внешней_таблицы)
)

CREATE TABLE Students
(
	student_id		INT				PRIMARY KEY IDENTITY(1,1), --IDENTITY - Autoincrement
	last_name		NVARCHAR(50)	NOT NULL,
	first_name		NVARCHAR(50)	NOT NULL,
	middle_name		NVARCHAR(50)	NULL,
	birth_dat		DATE			NOT NULL,
	--group - это ключевое слово языка Transact-SQL. Ключевые слова можно использовать для именования полей,
	-- но в таком случае их нужно брать в квадратные скобки.
	[group]			INT				NOT NULL
	CONSTRAINT		FK_Students_Group	FOREIGN KEY REFERENCES Groups(group_id)
)

CREATE TABLE Teachers
(
	teacher_id		INT				PRIMARY KEY,
	last_name		NVARCHAR(50)	NOT NULL,
	first_name		NVARCHAR(50)	NOT NULL,
	middle_name		NVARCHAR(50)	NULL,
	birth_date		DATE			NOT NULL
)

CREATE TABLE Disciplines
(
	discipline_id		SMALLINT		PRIMARY KEY,
	discipline_name		NVARCHAR(256)	NOT NULL,
	number_of_lessons	TINYINT			NOT NULL,
)

CREATE TABLE DisciplinesDirectionsRelation
(
	discipline			SMALLINT,
	direction			TINYINT,
	PRIMARY KEY(discipline, direction),
	CONSTRAINT FK_DDR_Discipline	FOREIGN KEY (discipline)	REFERENCES Disciplines(discipline_id),
	CONSTRAINT FK_DDR_Direction		FOREIGN KEY (direction)		REFERENCES Directions(direction_id)
)

CREATE TABLE TeachersDisciplinesRelation
(
	teacher			INT,
	discipline		SMALLINT,
	PRIMARY KEY(teacher, discipline),
	CONSTRAINT		FK_TDR_Teacher		FOREIGN KEY	(teacher)		REFERENCES	Teachers(teacher_id),
	CONSTRAINT		FK_TDR_Discipline	FOREIGN KEY	(discipline)	REFERENCES	Disciplines(discipline_id)
)

CREATE TABLE RequiredDisciplines
(
	discipline				SMALLINT,
	required_discipline		SMALLINT,
	PRIMARY KEY(discipline, required_discipline),
	CONSTRAINT	FK_RDiscplines_Discipline	FOREIGN KEY (discipline)				REFERENCES	Disciplines(discipline_id),
	CONSTRAINT	FK_RDisciplines_Required	FOREIGN KEY (required_discipline)		REFERENCES	Disciplines(discipline_id)
)

CREATE TABLE DependentDiscplines
(
	discipline				SMALLINT,
	dependent_discipline	SMALLINT,
	PRIMARY KEY(discipline, dependent_discipline),
	CONSTRAINT	FK_DD_Discipline	FOREIGN KEY (discipline)				REFERENCES	Disciplines(discipline_id),
	CONSTRAINT	FK_DD_Dependent		FOREIGN KEY (dependent_discipline)		REFERENCES Disciplines(discipline_id)
)

CREATE TABLE Schedule
(
	lesson_id		INT				PRIMARY KEY,
	[date]			DATE			NOT NULL,
	[time]			TIME(0)			NOT NULL,
	[group]			INT				NOT NULL
	CONSTRAINT		FK_Schedule_Group			FOREIGN KEY	REFERENCES Groups(group_id),
	discipline		SMALLINT		NOT NULL
	CONSTRAINT		FK_Schedule_Discipline		FOREIGN KEY REFERENCES Disciplines(discipline_id),
	teacher			INT				NOT NULL	
	CONSTRAINT		FK_Schedule_Teacher			FOREIGN KEY REFERENCES Teachers(teacher_id),
	[subject]		NVARCHAR(256),
	spent			BIT				NOT NULL
)

CREATE TABLE Grades
(
	student		INT			CONSTRAINT	FK_Grade_Student		FOREIGN KEY REFERENCES	Students(student_id),
	lesson		INT			CONSTRAINT	FK_Grade_Schedule		FOREIGN KEY	REFERENCES	Schedule(lesson_id),
	PRIMARY KEY(student, lesson),
	grade_1		TINYINT		CONSTRAINT		CK_Grade_1		CHECK	(grade_1 > 0 AND grade_1 <= 12),
	grade_2		TINYINT		CONSTRAINT		CK_Grade_2		CHECK	(grade_2 > 0 AND grade_2 <= 12)
)

CREATE TABLE Exams
(
	student			INT			CONSTRAINT		FK_Exam_Student		FOREIGN KEY	REFERENCES	Students(student_id),
	discipline		SMALLINT	CONSTRAINT		FK_Exam_Discipline	FOREIGN KEY	REFERENCES	Disciplines(discipline_id),
	grade			TINYINT		CONSTRAINT		CK_Exam_Grade		CHECK	(grade > 0 AND grade <= 12)	
)


CREATE TABLE HomeWorks
(
	[group]		INT				CONSTRAINT	FK_HW_Group		FOREIGN KEY	REFERENCES	Groups(group_id),
	lesson		INT				CONSTRAINT	FK_HW_Schedule	FOREIGN KEY REFERENCES	Schedule(lesson_id),
	[data]		VARBINARY(MAX),
	comment		NVARCHAR(1024),
	CONSTRAINT	CK_DATA_OR_COMMENT	CHECK	([data] IS NOT NULL OR comment IS NOT NULL),
	PRIMARY KEY ([group], lesson)
)

CREATE TABLE ResultsHW
(
	student		INT				CONSTRAINT		FK_RHW_Student		FOREIGN KEY		REFERENCES Students(student_id),
	[group]		INT,				--CONSTRAINT		FK_RHW_Group		FOREIGN KEY		REFERENCES Groups(group_id),
	lesson		INT,				--CONSTRAINT		FK_RHW_Schedule		FOREIGN KEY 	REFERENCES Schedule(lesson_id),
	result		VARBINARY(MAX),
	comment		NVARCHAR(1024),
	grade		TINYINT			CONSTRAINT		CK_HW_Grade	CHECK	(grade > 0 AND grade <= 12),
	CONSTRAINT	FK_RH_HW		FOREIGN KEY	([group], lesson)		REFERENCES	HomeWorks([group], lesson),
	CONSTRAINT	CK_RESULT_OR_COMMENT	CHECK	(result IS NOT NULL OR comment IS NOT NULL),
	PRIMARY KEY(student, [group], lesson)
)

CREATE TABLE EducationForm
(
	[group]		INT				CONSTRAINT	FK_EF_Group		FOREIGN KEY	REFERENCES	Groups(group_id),
	form		VARCHAR(20) NOT NULL CHECK	(form in ('Stationary', 'SemiStationary', 'Annual'))
);