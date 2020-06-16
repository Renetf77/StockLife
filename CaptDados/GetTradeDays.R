require("DBI")
require("odbc")
require("RSQLite")
require("RCurl")

get.market.days = function() {
  conn = dbConnect(
    dbDriver("SQLite"),
    "DB/stocks.sqlite3"
  ) 
  
  i = "MarketDays"
  if(!dbExistsTable(conn, i)){
    SQLStatement = paste("CREATE TABLE", i,
                         "(Dt DATETIME PRIMARY KEY DESC,
                           Running INTEGER DEFAULT (0),
                           Finished INTEGER DEFAULT (0) );")
    
    dbExecute(conn, SQLStatement)
    
  } 
  
  baseurl = "ftp://ftp.bmf.com.br/IPN/TRS/BVBG.086.01/"
  filesurl = getURL(baseurl, ftp.use.epsv = FALSE, ftplistonly = TRUE, crlf = TRUE)
  files = strsplit(filesurl, "\r\n")[[1]]
  pdates = as.Date(substr(files, 3, 8), "%y%m%d", origin = "1970-01-01")
  adates = dbGetQuery(conn, paste("SELECT Dt FROM", i, "ORDER BY Dt DESC"))
  adates = as.Date(adates$Dt, "%Y-%m-%d", origin = "1970-01-01")
  rdates = setdiff(pdates,adates)
  print(rdates)
  for(dt in rdates){
    dt = as.Date(dt, origin = "1970-01-01")
    print(paste("Iniciando rotina para o dia",dt))
    url = format(dt, paste0(baseurl,"PR%y%m%d.zip"))
    filename = format(dt, "Arquivos/PR%y%m%d.zip") 
    
    result = TRUE
    if(!file.exists(filename)){
      result = tryCatch({download.file(url, filename, mode= "wb")
          res <- TRUE},
          error = function(e) return(FALSE))
    }
    
    SQLStatement = paste0("SELECT * FROM ", i, " WHERE Dt='", dt, "';")
    res = dbGetQuery(conn, SQLStatement)
    rowcount = nrow(res)
    #print(rowcount)
    
    if(result && rowcount == 0) {
      SQLStatement = paste0("INSERT INTO ", i,
                           " (Dt) VALUES ('", as.Date(dt, "%Y-%m-%d"), "');")
      #print(SQLStatement)
      dbExecute(conn, SQLStatement)
    }
  }

  dbDisconnect(conn) 
}

get.market.days()
