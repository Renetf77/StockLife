require("DBI")
require("odbc")
require("RSQLite")

grava.BMF.BVBG = function(te) {
  conn = dbConnect(
    dbDriver("SQLite"),
    "DB/stocks.sqlite3"
  ) 
  
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
    #dbBegin(conn)
    dbWriteTable(conn = conn, name = i, value = te[grepl(paste0("\\<",i,"\\>"), te$TckrSymb),], append = T, overwrite = F, row.names= F )
    #dbCommit(conn)
  }
  print("FIM INSERÇÃO")
  dbDisconnect(conn)
}


