#typeof(te$DtRef)
for(i in 1:length(te)){
  print(colnames(te[i]))
  print(class(te[[i]]))
}
#install.packages("RSQLite")
require("DBI")
#require("odbc")
require("RSQLite")

conn = dbConnect(
  dbDriver("SQLite"),
  "DB/StockLife.db"
) 

dbListTables(conn)

nrow(te)
ncol(te)

index <- nrow(dbReadTable(conn,'teste'))
rownames(te) <- 1:nrow(te) +index
rownames(te)
str(te)

dbDataType(conn, 1)

dbRemoveTable(conn, "teste")
dbCreateTable(conn, "teste", te)
dbReadTable(conn, "teste")
dbWriteTable(conn = conn, name = "teste", value = te, append = T, overwrite = F, row.names= T )

dbDisconnect(conn)

#tail(c(1,2,3), 1)
