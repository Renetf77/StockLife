#install.packages("quantmod")
library(quantmod)
#install.packages("TTR")
library(TTR)

source("SQLCon/SQLite_to_DF.R")

res = getDataSQL("Select DtRef, TckrSYmb, FrstPric, MinPric, MaxPric, LastPric, RglrTxsQty, RglrTraddCtrcts, NtlRglrVol, IntlRglrVol  from PETR4;")

res$DtRef = as.Date(res$DtRef, "%Y-%m-%d", origin = "1970-01-01")
res = res[order(res$DtRef),]

dates = as.Date(as.character(res$DtRef),"%Y-%m-%d")
data = res[,3:6]
colnames(data) = c("Open", "Low", "High", "Close")

startdate = as.Date("2017-01-01")
enddate = as.Date("2018-09-19")

getSymbols(c("PETR4.SA"), src = "yahoo", from = startdate, to = enddate)

PETR4.SA = xts(data, dates)
PETR4.SA = window(PETR4.SA, start = startdate, end = enddate)

chartSeries(PETR4.SA, TA = NULL)
addMACD()

index(PETR4.SA)

