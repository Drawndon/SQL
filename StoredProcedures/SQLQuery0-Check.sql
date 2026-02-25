--SQLQuery0-Check.sql
USE PV_521_Import;

SET	DATEFIRST	1;

EXEC	sp_InsertScheduleStacionar N'PV_521', N'%ADO.NET%', N'Олег', N'2026-01-21';
EXEC	sp_SelectScheduleFor N'PV_521';