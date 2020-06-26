#install.packages("quantmod")
library(quantmod)
#install.packages("TTR")
library(TTR)

source("SQLCon/SQLite_to_DF.R")

Ticker = "PETR4"

res = getDataSQL(paste0("Select DtRef, 
                 TckrSYmb, 
                 FrstPric, 
                 MinPric, 
                 MaxPric, 
                 LastPric, 
                 RglrTxsQty, 
                 RglrTraddCtrcts, 
                 NtlRglrVol, 
                 IntlRglrVol  
                 from ", Ticker, ";"))

res$DtRef = as.Date(res$DtRef, "%Y-%m-%d", origin = "1970-01-01")
res = res[order(res$DtRef),]
dates = as.Date(as.character(res$DtRef),"%Y-%m-%d")
data = res[,3:6]
colnames(data) = c("Open", "Low", "High", "Close")

startdate = as.Date(res[1,1])
enddate = as.Date(res[length(res$DtRef),1])

PETR4 = xts(data, dates)
PETR4 = window(PETR4, start = startdate, end = enddate - 1)

getSymbols(c(paste0(Ticker,".SA")), src = "yahoo", from = startdate, to = enddate)

chartSeries(PETR4.SA, TA = NULL)
addMACD()

index(PETR4.SA)

