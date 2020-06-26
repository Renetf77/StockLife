#install.packages("quantmod")
require(quantmod)
#install.packages("TTR")
require(TTR)
require("DBI")
require("RSQLite")

source("SQLCon/SQLite_to_DF.R")

Ticker = "SLCE3"

SDB = getDataXTS(Ticker)

startdate = as.Date(start(SDB))
enddate = as.Date(end(SDB))

SDB = window(SDB, start = startdate, end = enddate - 1)

SY = getSymbols(c(paste0(Ticker,".SA")), src = "yahoo", from = startdate, to = enddate, auto.assign = F)

#SY <- eval(paste0(Ticker,".SA"))
chartSeries(SY, TA = NULL)
chartSeries(SDB, TA = NULL)
addMACD()

View(SDB)
#plot(Cl(SDB))

#coredata(SDB)
#periodicity(SDB)
#to.weekly(SDB)
#nweeks(SDB)
#nmonths(SDB)
#nyears(SDB)
#start(SDB)
#end(SDB)

#SDB["last"] - PETR4.SA["last"]
