source("CaptDados/GetData.R")
source("SQLCon/SQLite_Conn.R")

for (i in 1:180) {
  dt = as.Date("2019-12-31") + i
  print(dt)
}



#te <- ler.BMF.BVBG(as.Date("2020-06-04"))

#te = te[grepl("E", te$MktDataStrmId),]

#grava.BMF.BVBG(te)