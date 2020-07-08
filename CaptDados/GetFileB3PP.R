#Baixar dados da pesquisa de pregao
#http://www.b3.com.br/pt_br/market-data-e-indices/servicos-de-dados/market-data/historico/boletins-diarios/pesquisa-por-pregao/pesquisa-por-pregao/
#PP = Pesquisa de pregão
require("RCurl")


ler.B3.PP = function(dt, tipo = "PR"){
  stopifnot(is(dt, "Date"), length(dt) == 1)
  #dt = as.Date("2020-06-11", "%Y-%m-%d")
  dt = as.Date(dt, "%Y-%m-%d")
  #tipo = "PR"
  filename = format(dt, "PR%y%m%d.zip")
  destroot = "Arquivos/BVBG.086.01"
  file = paste0(destroot,"/",filename)
  
  print(dt)
  if(!file.exists(file)){
    
    baseurl = "http://www.b3.com.br/pesquisapregao/download?filelist="
    url = paste0(baseurl, filename)
    
    destfile = "Arquivos/BVBG.086.01/tmpB3PP.zip"
    
    result = TRUE
    result = tryCatch({download.file(url,destfile)
      res <- TRUE},
      error = function(e) return(FALSE))

    if(!result){
      return(NA)
    } else {
      unzip(destfile, exdir = destroot)
      file.remove(destfile)
    }

  }
  
}
