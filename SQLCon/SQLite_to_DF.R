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

getDataXTS = function(stock){
  res = getDataSQL(paste0("Select DtRef, 
                 TckrSYmb, 
                 FrstPric, 
                 MinPric, 
                 MaxPric, 
                 LastPric, 
                 RglrTraddCtrcts, 
                 OscnPctg,
                 RglrTxsQty, 
                 NtlRglrVol, 
                 IntlRglrVol  
                 from ", stock, ";"))
  
  res$DtRef = as.Date(res$DtRef, "%Y-%m-%d", origin = "1970-01-01")
  res = res[order(res$DtRef),]
  dates = as.Date(as.character(res$DtRef),"%Y-%m-%d")
  data = res[,3:8]
  colnames(data) = c("Open", "Low", "High", "Close", "Volume","Variation")
  
  Stock = xts(data, dates)
  
  return(Stock)
  
}