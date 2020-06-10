source("CaptDados/GetData.R")
source("SQLCon/SQLite_Conn.R")

for (i in 1:180) {
  dt = as.Date("2019-12-31", "%Y-%m-%d") + i
  print(dt)
  te <- ler.BMF.BVBG(dt)
  
  if(class(te)=="data.frame"){
    te = te[grepl("E", te$MktDataStrmId),]
    #te = te[order(te$TckrSymb)]
    grava.BMF.BVBG(te)
  }
}

print("FIM")
  



