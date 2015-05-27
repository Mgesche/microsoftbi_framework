DELETE FROM Version.Audit_Info;

create table Trig_Test (
	tt varchar(50)
);

ALTER table Trig_Test 
ADD TT2 int

CREATE NONCLUSTERED INDEX [TTID] ON [dbo].[Trig_Test] 
(
	[tt] ASC
)WITH (STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

DROP INDEX [dbo].[Trig_Test].[TTID]

DROP table Trig_Test

select *
from Version.Audit_Info
order by audit_id