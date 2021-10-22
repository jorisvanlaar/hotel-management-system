CREATE PROCEDURE [dbo].[spRooms_GetAvailableRooms]
	@startDate date,
	@endDate date,
	@roomTypeId int
AS
begin
	set nocount on;

	select r.*			
	from dbo.Rooms r										
	inner join dbo.RoomTypes t on r.RoomTypeId = t.Id
	where r.RoomTypeId = @roomTypeId 
	and r.Id not in (
	select b.RoomId
	from dbo.Bookings b
	where (@startDate < b.StartDate and @endDate > b.EndDate)		
		or (b.StartDate <= @startDate and @startDate < b.EndDate)	
		or (b.StartDate <= @endDate and @endDate < b.EndDate)	
	);
end
