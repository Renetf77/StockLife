require("DBI")
require("odbc")
require("RSQLite")

grava.BMF.BVBG = function(te) {
  conn = dbConnect(
    dbDriver("SQLite"),
    "DB/stocks.sqlite3"
  ) 
  
  i = "MarketDays"
  dt = as.Date(te$DtRef, "%Y-%m-%d", origin = "1970-01-01")
  SQLRunning = paste0("SELECT * FROM ", i, " WHERE Dt='", dt, "';")
  res = dbGetQuery(conn, SQLRunning)
  
  if(res$Running[1]==1){
    delete = 1
  } else {  
    delete = 0
    dbExecute(conn, paste0("UPDATE ", i, " SET Running = '1' WHERE DtRef = '", as.Date(dt, "%Y-%m-%d", origin = "1970-01-01"), "';"))
  }
  
  for(i in te$TckrSymb){
    print(i)
    if(!dbExistsTable(conn, i)){
      SQLStatement = paste("CREATE TABLE", i,
                             "(OpnIntrst        REAL,
                               MaxTradLmt       REAL,
                               MinTradLmt       REAL,
                               TckrSymb         TEXT,
                               MktDataStrmId    TEXT,
                               NtlFinVol        REAL,
                               IntlFinVol       REAL,
                               FinInstrmQty     REAL,
                               BestBidPric      REAL,
                               BestAskPric      REAL,
                               FrstPric         REAL,
                               MinPric          REAL,
                               MaxPric          REAL,
                               TradAvrgPric     REAL,
                               LastPric         REAL,
                               RglrTxsQty       REAL,
                               RglrTraddCtrcts  REAL,
                               NtlRglrVol       REAL,
                               IntlRglrVol      REAL,
                               OscnPctg         REAL,
                               AdjstdQt         REAL,
                               AdjstdQtStin     TEXT,
                               PrvsAdjstdQt     REAL,
                               PrvsAdjstdQtStin REAL,
                               VartnPts         REAL,
                               AdjstdValCtrct   REAL,
                               EqvtVal          REAL,
                               AdjstdQtTax      REAL,
                               PrvsAdjstdQtTax  REAL,
                               DtRef            DATETIME PRIMARY KEY DESC);")
      
      dbExecute(conn, SQLStatement)
    }
    
    if(delete==1){
      dbExecute(conn, paste0("DELETE FROM ", i, " WHERE DtRef = '", as.Date(dt, "%Y-%m-%d", origin = "1970-01-01"), "';"))
    } 
    dbWriteTable(conn = conn, name = i, value = te[grepl(paste0("\\<",i,"\\>"), te$TckrSymb),], append = T, overwrite = F, row.names= F )
    
  }
  dbExecute(conn, paste0("UPDATE ", i, " SET Running = '0', Finished = '1' WHERE DtRef = '", as.Date(dt, "%Y-%m-%d", origin = "1970-01-01"), "';"))
  print("FIM INSERÇÃO")
  dbDisconnect(conn)
}


