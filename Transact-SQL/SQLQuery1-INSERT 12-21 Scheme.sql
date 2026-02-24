--SQLQuery1-INSERT 12-21 Scheme.sql

USE PV_521_Import;
SET DATEFIRST 1;

DECLARE @group                 AS INT      = (SELECT group_id          FROM Groups      WHERE group_name = N'PV_521');
DECLARE @base_cpp        AS SMALLINT = (SELECT discipline_id     FROM Disciplines WHERE discipline_name = N'Процедурное программирование на языке C++');
DECLARE @hardware         AS SMALLINT = (SELECT discipline_id     FROM Disciplines WHERE discipline_name = 'Hardware-PC');
DECLARE @number_of_lessons_cpp AS TINYINT  = (SELECT number_of_lessons FROM Disciplines WHERE discipline_id = @base_cpp);
DECLARE @number_of_lessons_hw  AS TINYINT  = (SELECT number_of_lessons FROM Disciplines WHERE discipline_id = @hardware);
DECLARE @teacher_cpp           AS INT      = (SELECT teacher_id        FROM Teachers    WHERE last_name = N'Ковтун');
DECLARE @teacher_hw            AS INT      = (SELECT teacher_id        FROM Teachers    WHERE last_name = N'Свищев');
DECLARE @start_date            AS DATE     = N'2025-01-20';
DECLARE @start_time            AS TIME     = (SELECT start_time        FROM Groups      WHERE group_id = @group);

PRINT(@group);
DECLARE @base_cpp_name AS NVARCHAR(150)	= (SELECT discipline_name FROM Disciplines WHERE discipline_id = @base_cpp);
PRINT(@base_cpp_name);
DECLARE @hardware_name AS NVARCHAR(150)	= (SELECT discipline_name FROM Disciplines WHERE discipline_id = @hardware);
PRINT(@hardware_name);
PRINT(FORMATMESSAGE(N'Количество занятий по C++: %i', @number_of_lessons_cpp));
PRINT(FORMATMESSAGE(N'Количество занятий по Hardware-PC: %i', @number_of_lessons_hw));
DECLARE @teacher_cpp_last_name AS NVARCHAR(24)	= (SELECT last_name FROM Teachers WHERE teacher_id = @teacher_cpp);
PRINT(@teacher_cpp_last_name);
DECLARE @teacher_hw_last_name AS NVARCHAR(24)	= (SELECT last_name FROM Teachers WHERE teacher_id = @teacher_hw);
PRINT(@teacher_hw_last_name);
PRINT(N'Дата начала: %i' + CAST(@start_date AS NVARCHAR(10)));
PRINT(N'Время начала: ' + CAST(@start_time AS NVARCHAR(5)));

DECLARE @date          AS DATE    = @start_date;
DECLARE @lesson_number AS TINYINT = 1;
DECLARE @time          AS TIME = @start_time;

WHILE @lesson_number < @number_of_lessons_cpp + @number_of_lessons_hw
BEGIN
	DECLARE @week_number AS TINYINT = DATEPART(WEEK, @date);
	DECLARE @day AS TINYINT = DATEPART(WEEKDAY, @date);
    SET @time = @start_time;
	PRINT(FORMATMESSAGE(N'%i %s %s %s', @lesson_number, CAST(@date AS VARCHAR(24)), DATENAME(WEEKDAY, @date), CAST(@time AS VARCHAR(24))));
	--IF NOT EXISTS (SELECT lesson_id FROM Schedule WHERE [date] = @date AND [time] = @time AND [group] = @group)
	--	INSERT Schedule VALUES (@group, IIF(@day = 1, @hardware, IIF(@day = 5, @base_cpp, IIF(@week_number % 2 = 0 AND @day = 3, @base_cpp, @hardware))), IIF(@day = 1, @teacher_hw, IIF(@day = 5, @teacher_cpp, IIF(@week_number % 2 = 0 AND @day = 3, @teacher_cpp, @teacher_hw))), @date, @time, IIF(@date < GETDATE(), 1, 0));
	SET @lesson_number = @lesson_number + 1;
	SET @time = DATEADD(MINUTE, 95, @start_time);

	PRINT(FORMATMESSAGE(N'%i %s %s %s', @lesson_number, CAST(@date AS VARCHAR(24)), DATENAME(WEEKDAY, @date), CAST(@time AS VARCHAR(24))));
	--IF NOT EXISTS (SELECT lesson_id FROM Schedule WHERE [date] = @date AND [time] = @time AND [group] = @group)
	--	INSERT Schedule VALUES (@group, IIF(@day = 1, @hardware, IIF(@day = 5, @base_cpp, IIF(@week_number % 2 = 0 AND @day = 3, @base_cpp, @hardware))), IIF(@day = 1, @teacher_hw, IIF(@day = 5, @teacher_cpp, IIF(@week_number % 2 = 0 AND @day = 3, @teacher_cpp, @teacher_hw))), @date, @time, IIF(@date < GETDATE(), 1, 0));
	SET @lesson_number = @lesson_number + 1;

	PRINT(FORMATMESSAGE(N'Номер недели: %i', @week_number));
	PRINT(FORMATMESSAGE(N'День: %i', @day));
	SET @date = DATEADD(DAY, IIF(@day = 5, 3, 2), @date);
END