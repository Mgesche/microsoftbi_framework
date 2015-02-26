If you want to disable all constraints in the database just run this code:

-- disable all constraints
EXEC sp_msforeachtable "ALTER TABLE ? NOCHECK CONSTRAINT all"
To switch them back on, run: (the print is optional of course and it is just listing the tables)

-- enable all constraints
exec sp_msforeachtable @command1="print '?'", @command2="ALTER TABLE ? WITH CHECK CHECK CONSTRAINT all"

pour une seule table

-- Disable all table constraints

ALTER TABLE MyTable NOCHECK CONSTRAINT ALL

-- Enable all table constraints

ALTER TABLE MyTable CHECK CONSTRAINT ALL

-- Disable single constraint

ALTER TABLE MyTable NOCHECK CONSTRAINT MyConstraint

-- Enable single constraint

ALTER TABLE MyTable CHECK CONSTRAINT MyConstraint