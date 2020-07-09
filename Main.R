source("CaptDados/GetData.R")
source("SQLCon/SQLite_Conn.R")
source("CaptDados/GetTradeDays.R")
source("SQLCon/SQLite_to_DF.R")
source("CaptDados/GetDadosPublicosB3.R")
source("CaptDados/GetFileB3PP.R")


for(i in 1:30){
  dt = as.Date(Sys.Date()) - i
  ler.B3.PP(dt)
}

ins.market.days()

i = "MarketDays"
SQLFinished = paste0("SELECT Dt FROM ", i, " WHERE Finished = '0';")
res = getDataSQL(SQLFinished)

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

print("FIM")


  



