﻿/*
Deployment script for HotelAppDB_1

This code was generated by a tool.
Changes to this file may cause incorrect behavior and will be lost if
the code is regenerated.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "HotelAppDB_1"
:setvar DefaultFilePrefix "HotelAppDB_1"
:setvar DefaultDataPath "C:\Users\joris\AppData\Local\Microsoft\VisualStudio\SSDT\HotelApp"
:setvar DefaultLogPath "C:\Users\joris\AppData\Local\Microsoft\VisualStudio\SSDT\HotelApp"

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
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ARITHABORT ON,
                CONCAT_NULL_YIELDS_NULL ON,
                CURSOR_DEFAULT LOCAL 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET PAGE_VERIFY NONE,
                DISABLE_BROKER 
            WITH ROLLBACK IMMEDIATE;
    END


GO
ALTER DATABASE [$(DatabaseName)]
    SET TARGET_RECOVERY_TIME = 0 SECONDS 
    WITH ROLLBACK IMMEDIATE;


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET QUERY_STORE (CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 367)) 
            WITH ROLLBACK IMMEDIATE;
    END


GO
PRINT N'Creating Table [dbo].[Bookings]...';


GO
CREATE TABLE [dbo].[Bookings] (
    [Id]        INT           IDENTITY (1, 1) NOT NULL,
    [RoomId]    INT           NOT NULL,
    [GuestId]   INT           NOT NULL,
    [StartDate] DATETIME2 (7) NOT NULL,
    [EndDate]   DATETIME2 (7) NOT NULL,
    [CheckedIn] BIT           NOT NULL,
    [TotalCost] MONEY         NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Creating Table [dbo].[Guests]...';


GO
CREATE TABLE [dbo].[Guests] (
    [Id]        INT           IDENTITY (1, 1) NOT NULL,
    [FirstName] NVARCHAR (50) NOT NULL,
    [LastName]  NVARCHAR (50) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Creating Table [dbo].[Rooms]...';


GO
CREATE TABLE [dbo].[Rooms] (
    [Id]         INT          IDENTITY (1, 1) NOT NULL,
    [RoomNumber] VARCHAR (10) NOT NULL,
    [RoomTypeId] INT          NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Creating Table [dbo].[RoomTypes]...';


GO
CREATE TABLE [dbo].[RoomTypes] (
    [Id]          INT             IDENTITY (1, 1) NOT NULL,
    [Title]       NVARCHAR (50)   NOT NULL,
    [Description] NVARCHAR (2000) NOT NULL,
    [Price]       MONEY           NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[Bookings]...';


GO
ALTER TABLE [dbo].[Bookings]
    ADD DEFAULT 0 FOR [CheckedIn];


GO
PRINT N'Creating Foreign Key [dbo].[FK_Bookings_Rooms]...';


GO
ALTER TABLE [dbo].[Bookings] WITH NOCHECK
    ADD CONSTRAINT [FK_Bookings_Rooms] FOREIGN KEY ([RoomId]) REFERENCES [dbo].[Rooms] ([Id]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_Bookings_Guests]...';


GO
ALTER TABLE [dbo].[Bookings] WITH NOCHECK
    ADD CONSTRAINT [FK_Bookings_Guests] FOREIGN KEY ([GuestId]) REFERENCES [dbo].[Guests] ([Id]);


GO
PRINT N'Creating Foreign Key [dbo].[FK_Rooms_RoomTypes]...';


GO
ALTER TABLE [dbo].[Rooms] WITH NOCHECK
    ADD CONSTRAINT [FK_Rooms_RoomTypes] FOREIGN KEY ([RoomTypeId]) REFERENCES [dbo].[RoomTypes] ([Id]);


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
PRINT N'Checking existing data against newly created constraints';


GO
USE [$(DatabaseName)];


GO
ALTER TABLE [dbo].[Bookings] WITH CHECK CHECK CONSTRAINT [FK_Bookings_Rooms];

ALTER TABLE [dbo].[Bookings] WITH CHECK CHECK CONSTRAINT [FK_Bookings_Guests];

ALTER TABLE [dbo].[Rooms] WITH CHECK CHECK CONSTRAINT [FK_Rooms_RoomTypes];


GO
PRINT N'Update complete.';


GO