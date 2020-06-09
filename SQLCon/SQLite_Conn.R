require("DBI")
require("RSQLite")

grava.BMF.BVBG = function(te) {
  conn = dbConnect(
    dbDriver("SQLite"),
    "DB/StockLife.db"
    #pooling = T,
    #synchronous = NULL
  ) 
  
for(i in te$TckrSymb){
  print(i)
  if(!dbExistsTable(conn, i)){
    
    dbCreateTable(conn, i, c(OpnIntrst        ="REAL",
                             MaxTradLmt       ="REAL",
                             MinTradLmt       ="REAL",
                             TckrSymb         ="TEXT",
                             MktDataStrmId    ="TEXT",
                             NtlFinVol        ="REAL",
                             IntlFinVol       ="REAL",
                             FinInstrmQty     ="REAL",
                             BestBidPric      ="REAL",
                             BestAskPric      ="REAL",
                             FrstPric         ="REAL",
                             MinPric          ="REAL",
                             MaxPric          ="REAL",
                             TradAvrgPric     ="REAL",
                             LastPric         ="REAL",
                             RglrTxsQty       ="REAL",
                             RglrTraddCtrcts  ="REAL",
                             NtlRglrVol       ="REAL",
                             IntlRglrVol      ="REAL",
                             OscnPctg         ="REAL",
                             AdjstdQt         ="REAL",
                             AdjstdQtStin     ="TEXT",
                             PrvsAdjstdQt     ="REAL",
                             PrvsAdjstdQtStin ="REAL",
                             VartnPts         ="REAL",
                             AdjstdValCtrct   ="REAL",
                             EqvtVal          ="REAL",
                             AdjstdQtTax      ="REAL",
                             PrvsAdjstdQtTax  ="REAL",
                             DtRef            ="DATETIME"))
  }

  #index <- nrow(dbReadTable(conn, i))
  #rownames(te) <- 1:nrow(te) +index
    
  dbWriteTable(conn = conn, name = i, value = te[grepl(paste0("\\<",i,"\\>"), te$TckrSymb),], append = T, overwrite = F, row.names= F )
}
  print("FIM INSERÇÃO")
  dbDisconnect(conn)
}


