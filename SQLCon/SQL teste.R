#install.packages("odbc")
library(DBI)
library(dplyr)
library(dbplyr)
library(odbc)
con <- dbConnect(odbc::odbc(), "MT_Ibratec_preDW")
show(con)
dbListTables(conn = con, name = "MT_Ibratec_preDW", schema_name = "dbo")
dbListFields(conn = con, name = "ItensEstoque", schema_name = "dbo")

q1 <- tbl(con, "ItensEstoque")
q1 %>%  select (CodItem)
show_query(q1)
View(q1)

#https://dbplyr.tidyverse.org/articles/dbplyr.html
#https://db.rstudio.com/getting-started/database-queries/

dbDisconnect(con)
