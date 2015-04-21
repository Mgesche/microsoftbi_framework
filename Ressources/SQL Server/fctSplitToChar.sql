USE [BotanicDW_MEC]
GO

/****** Object:  UserDefinedFunction [dbo].[fctSplitToChar]    Script Date: 04/21/2015 14:40:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fctSplitToChar](
@DelimitedText VARCHAR(MAX), -- liste CSV
@QuoteChar CHAR(1) -- caractère de délimitation
) RETURNS @Items TABLE (Item varchar(20))
as
BEGIN
DECLARE @Item VARCHAR(20)
WHILE CHARINDEX(@QuoteChar, @DelimitedText, 0) <> 0 BEGIN
SELECT @Item=SUBSTRING(@DelimitedText,1,CHARINDEX(@QuoteChar,@DelimitedText, 0)-1),
@DelimitedText=SUBSTRING(@DelimitedText,CHARINDEX(@QuoteChar,@DelimitedText, 0) + LEN(@QuoteChar), LEN(@DelimitedText))
IF LEN(RTRIM(@Item)) > 0
INSERT INTO @Items SELECT @Item
END
 -- Dernier item de la liste
 IF LEN(RTRIM(@DelimitedText)) > 0
INSERT INTO @Items SELECT @DelimitedText
RETURN
END


GO


