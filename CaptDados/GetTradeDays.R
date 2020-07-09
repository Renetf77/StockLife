require("DBI")
require("odbc")
require("RSQLite")
require("RCurl")

ins.market.days = function() {
  conn = dbConnect(
    dbDriver("SQLite"),
    "DB/stocks.sqlite3"
  ) 
  
  i = "MarketDays"
  if(!dbExistsTable(conn, i)){
    SQLStatement = paste("CREATE TABLE", i,
                         "(Dt DATETIME PRIMARY KEY DESC,
                           Finished INTEGER DEFAULT (0) );")
    
    dbExecute(conn, SQLStatement)
    
  } 
  
  files = list.files("Arquivos/BVBG.086.01/")
  pdates = as.Date(gsub(".zip","",gsub("PR", "",files)), "%y%m%d")
  adates = dbGetQuery(conn, paste("SELECT Dt FROM", i, "ORDER BY Dt DESC"))
  adates = as.Date(adates$Dt, "%Y-%m-%d", origin = "1970-01-01")
  rdates = setdiff(pdates,adates)
  
  for(dt in rdates){
    dt = as.Date(dt, origin = "1970-01-01")
    print(paste("Iniciando rotina para o dia",dt))

    SQLStatement = paste0("INSERT INTO ", i,
                         " (Dt) VALUES ('", as.Date(dt, "%Y-%m-%d"), "');")
    dbExecute(conn, SQLStatement)

  }

  dbDisconnect(conn) 
}


