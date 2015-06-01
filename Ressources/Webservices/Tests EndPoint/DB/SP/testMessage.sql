IF object_id(N'Webservices.testMessage', N'P') IS NOT NULL
    DROP PROCEDURE Webservices.testMessage
GO

CREATE PROCEDURE Webservices.testMessage
(@msg nvarchar(256))
AS BEGIN
   select @msg as 'message'
END 