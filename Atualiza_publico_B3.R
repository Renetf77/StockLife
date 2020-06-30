source("CaptDados/GetDadosPublicosB3.R")

options=c("TradeInformationConsolidated",
          "InstrumentsConsolidated",
          "OTCInstrumentsConsolidated",
          "MarginScenarioLiquidAssets",
          "EconomicIndicatorPrice",
          "OTCTradeInformationConsolidated",
          "TradeInformationConsolidatedAfterHours",
          "LendingOpenPosition",
          "DerivativesOpenPosition",
          "LoanBalance")

for(i in 1:30){
  dt = as.Date(Sys.Date()) - i
  for(filenameroot in options){
    ler.Pub.B3(dt,filenameroot)
  }
  
}