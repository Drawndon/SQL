--SQLQuery0-Check PV_319.sql

USE PV_521_Import;
SET DATEFIRST 1;

EXEC sp_SelectScheduleFor N'PV_319';
PRINT dbo.GetNextLearningDay(N'PV_319');