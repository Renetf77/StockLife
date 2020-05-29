#Exemplos de códigos para não perder referências

#config::is_active("default")

'conn = DBI::dbConnect(
  odbc::odbc(),
  dsn = "ibratec",
  database = "ibratec",
  encoding = "latin1"
)' 

'conn = DBI::dbConnect(
  odbc::odbc(),
  driver = "MySQL ODBC 8.0 ANSI Driver",
  server = "192.168.0.15",
  port = "3306",
  database = "ibratec",
  uid = "rene.francisco",
  pwd = ""),
  encoding = "latin1"'

#{driver = "MySQL ODBC 8.0 ANSI Driver";host = config$dbserver;port = config$dbport;database = config$DB;uid = config$user;pwd = config$password}
