#typeof(te$DtRef)
for(i in 1:length(te)){
  print(colnames(te[i]))
  print(class(te[[i]]))
}

require("DBI")
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

#nrow(te)
#ncol(te)

index <- nrow(dbReadTable(conn,'teste'))
rownames(te) <- 1:nrow(te) +index
rownames(te)
str(te)

dbDataType(conn, 1)

#dbCreateTable(conn, "teste", te)
#dbReadTable(conn, "teste")
dbWriteTable(conn = conn, name = "teste", value = te, overwrite = T, row.names= T )

dbDisconnect(conn)

#tail(c(1,2,3), 1)
