source("CaptDados/GetData.R")
source("SQLCon/SQLite_Conn.R")

for (i in 1:180) {
  dt = as.Date("2019-12-31") + i
  
  te <- ler.BMF.BVBG(dt)
  
  if(class(te)=="data.frame"){
    te = te[grepl("E", te$MktDataStrmId),]
    grava.BMF.BVBG(te)
  }
}

gc()
print("fim")


