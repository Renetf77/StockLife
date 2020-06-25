source("CaptDados/GetData.R")
source("SQLCon/SQLite_Conn.R")
source("CaptDados/GetTradeDays.R")

get.market.days()

conn = dbConnect(
  dbDriver("SQLite"),
  "DB/stocks.sqlite3"
) 

i = "MarketDays"

SQLFinished = paste0("SELECT Dt FROM ", i, " WHERE Finished = '0';")
res = dbGetQuery(conn, SQLFinished)

for (i in res$Dt) {
  #i = "2018-03-12"
  dt = as.Date(i, "%Y-%m-%d", origin = "1970-01-01")
  print(dt)
  te <- ler.BMF.BVBG(dt)
  te <- te[order(te$TckrSymb),]
  #View(te)
  if(class(te)=="data.frame"){
    te = te[grepl("E", te$MktDataStrmId),]
    #te = te[order(te$TckrSymb)]
    grava.BMF.BVBG(te)
    #remove(list=ls())
    #gc(reset=TRUE)
  }
}

dbDisconnect(conn)
print("FIM")


  



