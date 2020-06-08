require("DBI")
require("RSQLite")

grava.BMF.BVBG = function(te) {
  conn = dbConnect(
    dbDriver("SQLite"),
    "DB/StockLife.db"
  ) 
  
  index <- nrow(dbReadTable(conn,'teste'))
  rownames(te) <- 1:nrow(te) +index
  
  dbWriteTable(conn = conn, name = "teste", value = te, append = T, overwrite = F, row.names= T )
  
  dbDisconnect(conn)
}


