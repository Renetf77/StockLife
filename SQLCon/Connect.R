require("DBI")
require("plyr")
require("dbplyr")
require("pool")
require("bizdays")
require("config")
require("odbc")

config = config::get(file = "SQLCon/config.yml", config = Sys.getenv("R_CONFIG_ACTIVE", "production"))

conn = DBI::dbConnect(
  odbc::odbc(),
  driver = "MySQL ODBC 8.0 ANSI Driver",
  server = config$dbserver,
  port = config$dbport,
  database = config$DB,
  uid = config$user,
  pwd = config$password,
  encoding = "latin1"
) 

email = dbGetQuery(conn, 
         "select * from email")

email$DT_Inclusao = as.Date(email$DT_Inclusao, tz = "UTC", "%Y-%m-%d")
email$DT_Alteracao = as.Date(email$DT_Alteracao, tz = "UTC", "%Y-%m-%d")

View(email)

dbDisconnect(conn)




