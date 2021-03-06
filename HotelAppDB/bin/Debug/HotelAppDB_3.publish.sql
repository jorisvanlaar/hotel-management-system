/*
Deployment script for HotelAppDB

This code was generated by a tool.
Changes to this file may cause incorrect behavior and will be lost if
the code is regenerated.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "HotelAppDB"
:setvar DefaultFilePrefix "HotelAppDB"
:setvar DefaultDataPath "C:\Users\joris\AppData\Local\Microsoft\Microsoft SQL Server Local DB\Instances\MSSQLLocalDB\"
:setvar DefaultLogPath "C:\Users\joris\AppData\Local\Microsoft\Microsoft SQL Server Local DB\Instances\MSSQLLocalDB\"

GO
:on error exit
GO
/*
Detect SQLCMD mode and disable script execution if SQLCMD mode is not supported.
To re-enable the script after enabling SQLCMD mode, execute the following:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'SQLCMD mode must be enabled to successfully execute this script.';
        SET NOEXEC ON;
    END


GO
USE [$(DatabaseName)];


GO
PRINT N'Creating Procedure [dbo].[spRoomTypes_GetAvailableTypes]...';


GO
-- 4a. STAP 1: OPBREKEN VAN EEN COMPLEXE QUERY IN APRTE KLEINE, BEHAPBARE QUERIES.
--     Eerst maken we aparte queries aan en proberen die werkend te krijgen, in stap 2 voegen we die dan samen.

-- 4b. Linken van de Rooms en RoomTypes tabellen, zodat we een samengestelde tabel hebben met alle kamers erin.
--select r.*, t.*
--from dbo.Rooms r
--inner join dbo.RoomTypes t on r.RoomTypeId = t.Id


--4c. Teruggeven van bookings die clashen met de gewenste @startDate en @endDate.
---- Zodoende weten we of een kamer met een bepaalde 'RoomId' wel/niet beschikbaar is.
---- Deze query geeft dus eigenlijk een lijst van niet-beschikbare kamers terug.
---- Als er dus geen enkele record voor een bepaalde 'RoomId' wordt teruggegeven,
---- dan weten we dat die kamer beschikbaar is voor de gewenste data.
--declare @startDate date;
--declare @endDate date;

--set @startDate = '12/10/19';
--set @endDate = '12/15/19';

--select *
--from dbo.Bookings b
--where (@startDate < b.StartDate and @endDate > b.EndDate)		-- 4d. Een bestaande booking valt compleet binnen de gewenste data.
--	or (b.StartDate <= @startDate and @startDate < b.EndDate)	-- 4e. De gewenste startdatum ligt tussen de start- en einddatum van een bestaande booking. 
--																--     We houden hierbij rekening met het feit dat iemand wel kan inchecken 
																--     op dezelfde endDate van een bestaande booking.
--	or (b.StartDate <= @endDate and @endDate < b.EndDate)		-- 4f. De gewenste einddatum ligt tussen de start-en einddatum van een bestaande booking.


-- 5. STAP 2: COMBINEREN VAN DE APARTE QUERIES TOT 1 QUERY. 
--    Maar nu moeten we beide queries combineren tot 1 query, 
--    waarbij we kijken of het 'Id' van een kamer uit de samengestelde tabel met alle kamers,
--    NIET overeenkomt met het 'RoomId' van een kamer uit de lijst van niet-beschikbare kamers voor een gewenste start- en einddatum.
--    Zodoende krijgen we dan een lijst met beschikbare kamers terug:

--declare @startDate date;
--declare @endDate date;

--set @startDate = '12/11/19';
--set @endDate = '12/15/19';

--select r.*, t.*
--from dbo.Rooms r
--inner join dbo.RoomTypes t on r.RoomTypeId = t.Id
--where r.Id not in (
--select b.RoomId
--from dbo.Bookings b
--where (@startDate < b.StartDate and @endDate > b.EndDate)		
--	or (b.StartDate <= @startDate and @startDate < b.EndDate)	
--	or (b.StartDate <= @endDate and @endDate < b.EndDate)	
--)

CREATE PROCEDURE [dbo].[spRoomTypes_GetAvailableTypes]
	@startDate date,	
	@endDate date
AS
begin
	set nocount on;										-- Dit betekent dat we niet willen dat er een aparte entry wordt gereturned
														-- die zegt hoeveel records zijn gewijzigd (onnodig extra data).

-- 6a. STAP 3: ALLEEN RELEVANTE DATA RETURNEN, EN DUPLICATE DATA VERMIJDEN MBV GROUPING.
--select r.*, t.*										-- 6b. De data van de 'Rooms' hebben we niet nodig.
select t.Id, t.Title, t.Description, t.Price			-- 6c. Alleen maar de 'RoomTypes' data opvragen, die we nodig hebben voor ons 'RoomTypeModel' Model,
from dbo.Rooms r										--     waarin we de data uiteindelijk gaan vatten in onze C# code.
inner join dbo.RoomTypes t on r.RoomTypeId = t.Id
where r.Id not in (
select b.RoomId
from dbo.Bookings b
where (@startDate < b.StartDate and @endDate > b.EndDate)		
	or (b.StartDate <= @startDate and @startDate < b.EndDate)	
	or (b.StartDate <= @endDate and @endDate < b.EndDate)	
)
group by t.Id, t.Title, t.Description, t.Price				-- 6d. En die groupen op die 4 kolommen, 
															--     zodat we alleen maar unieke records terukrijgen (en dus geen duplicates).
end															

-- 7. Top! Onze stored procedure is nu klaar!
--    Het enigste wat we nu nog moeten doen is onze database weer te publishen,
--    zodat we deze stored procedure daadwerkelijk in de database hebben, om hem te kunnen callen:
--    Solution Explorer > Publish Profiles > dubbelklik 'HotelAppDB.publish.xml' > 'Publish'.
GO
/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/

if not exists (select 1 from dbo.RoomTypes)                                        
begin
insert into dbo.RoomTypes(Title, Description, Price)    
values('King Size Bed', 'A room with a king-size bed and a window.', 100),
('Two Queen Size Beds', 'A room with two queen-sized beds and a window.', 115),
('Executive Suite', 'Two rooms, each with a king-size bed and a window.', 205)
end

if not exists (select 1 from dbo.Rooms)
begin
declare @roomId1 int;
declare @roomId2 int;
declare @roomId3 int;

select @roomId1 = Id from dbo.RoomTypes where Title = 'King Size Bed';
select @roomId2 = Id from dbo.RoomTypes where Title = 'Two Queen Size Beds';
select @roomId3 = Id from dbo.RoomTypes where Title = 'Executive Suite';

insert into dbo.Rooms(RoomNumber, RoomTypeId)
values('101', @roomId1),
('102', @roomId1),          
('103', @roomId1),
('201', @roomId2),
('202', @roomId2),
('301', @roomId3);
end
GO

GO
PRINT N'Update complete.';


GO
