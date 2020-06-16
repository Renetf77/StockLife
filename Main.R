source("CaptDados/GetData.R")
source("SQLCon/SQLite_Conn.R")

conn = dbConnect(
  dbDriver("SQLite"),
  "DB/stocks.sqlite3"
) 

i = "MarketDays"

SQLFinished = paste0("SELECT Dt FROM ", i, " WHERE Dt='", dt, "' AND Finished = '0';")
res = dbGetQuery(conn, SQLFinished)

for (i in res$Dt) {
  dt = as.Date(i, "%Y-%m-%d", origin = "1970-01-01")
  print(dt)
  te <- ler.BMF.BVBG(dt)
  
  if(class(te)=="data.frame"){
    te = te[grepl("E", te$MktDataStrmId),]
    #te = te[order(te$TckrSymb)]
    grava.BMF.BVBG(te)
  }
}

dbDisconnect(conn)
print("FIM")


  



