source("CaptDados/GetData.R")
source("SQLCon/SQLite_Conn.R")

te <- ler.BMF.BVBG(as.Date("2020-06-04"))

te = te[grepl("E", te$MktDataStrmId),]

grava.BMF.BVBG(te)