require("DBI")
require("odbc")
require("RSQLite")

getDataSQL = function(sql){
  conn = dbConnect(
    dbDriver("SQLite"),
    "DB/stocks.sqlite3"
  ) 
  
  res = dbGetQuery(conn, sql)
  
  dbDisconnect(conn)
  
  return(res)
}