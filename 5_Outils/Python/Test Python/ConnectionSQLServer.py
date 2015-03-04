import pyodbc

dsn = 'sqlserverdatasource'
user = '<username>'
password = '<password>'
database = '<dbname>'

con_string = 'DSN=%s;UID=%s;PWD=%s;DATABASE=%s;' % (dsn, user, password, database)
conn = pyodbc.connect(con_string)