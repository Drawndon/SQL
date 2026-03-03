--SQLQuery0-Check Java_326.sql

USE PV_521_Import;
SET DATEFIRST 1;

EXEC sp_SelectScheduleFor N'Java_326';
PRINT dbo.GetNextLearningDay(N'Java_326');