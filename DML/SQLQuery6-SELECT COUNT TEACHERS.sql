--SQLQuery6-SELECT COUNT TEACHERS.sql
--3. Для каждой дисциплины вывести количество преподавателей, которые могут вести эту дисциплину

USE PV_521_Import;

SELECT
		discipline_name AS N'Дисциплина',
		COUNT(teacher) AS N'Количество преподавателей'
FROM Disciplines, TeachersDisciplinesRelation
WHERE discipline_id = discipline
GROUP BY discipline_name
ORDER BY COUNT(teacher) DESC;