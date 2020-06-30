require("RCurl")
require("jsonlite")
#install.packages("jsonlite")

#Dados públicos de produtos listados e de balcão
ler.Pub.B3 = function(dt,filenameroot="TradeInformationConsolidated"){
  #dt="2020-06-29"
  print(dt)
  dt=as.Date(dt,"%Y-%m-%d")
  #filenameroot="teste"
  url = paste0("https://arquivos.b3.com.br/api/download/requestname?fileName=",filenameroot,"&date=",format(dt, "%Y-%m-%d"),"&recaptchaToken=")
  pfilename=paste0(filenameroot,"File_",format(dt, "%Y%m%d"),"_1.csv")
  path=paste0("Arquivos/Dados_publicos_B3/",filenameroot,"/")
  
  if(!file.exists(paste0(path,pfilename))){
    result = tryCatch({json = fromJSON(url)
      res <- TRUE},
      error = function(e) return(FALSE))
    
    if(!result){
      return(FALSE)
    }
    
    newurl = paste0("https://arquivos.b3.com.br/api/download/?token=",json$token)
    
    filename=paste0(path,json$file$name,json$file$extension)
    
    if(!dir.exists(path)){
      dir.create(path)
    }
    
    if(!file.exists(filename)){
      print(filename)
      result = tryCatch({download.file(newurl,filename)
        res <- TRUE},
        error = function(e) return(FALSE))
      Sys.sleep(1)
    }
  }
}