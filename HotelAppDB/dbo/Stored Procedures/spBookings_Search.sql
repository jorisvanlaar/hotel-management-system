CREATE PROCEDURE [dbo].[spBookings_Search]
	@lastName nvarchar(50),
	@startDate date
AS
begin
	set nocount on;

	SELECT [b].[Id], [b].[RoomId], [b].[GuestId], [b].[StartDate], [b].[EndDate], [b].[CheckedIn], [b].[TotalCost], 
			[g].[FirstName], [g].[LastName], 
			[r].[RoomNumber], [r].[RoomTypeId], 
			[rt].[Title], [rt].[Description], [rt].[Price]
	from dbo.Bookings b
	inner join dbo.Guests g on b.GuestId = g.Id
	inner join dbo.Rooms r on b.RoomId = r.Id
	inner join dbo.RoomTypes rt on r.RoomTypeId = rt.Id
	where g.LastName = @lastName and b.StartDate = @startDate
end

