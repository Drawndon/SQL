--SQLQuery5-SELECT COUNT DISCIPLINES.sql
--2. Для каждого преподавателя вывести количество дисциплин, котороые он может вести

USE PV_521_Import;

SELECT
		[Преподаватель]			=	FORMATMESSAGE(N'%s %s %s', last_name, first_name, middle_name),
		[Количество дисциплин]	=	COUNT(discipline)
FROM Teachers, TeachersDisciplinesRelation
WHERE teacher_id = teacher
GROUP BY last_name, first_name, middle_name
ORDER BY [Количество дисциплин] DESC;



