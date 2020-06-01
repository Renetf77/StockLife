library(XML)
library(plyr)

ler.BMF.BVBG = function(dt){
  stopifnot(is(dt, "Date"), length(dt) == 1)
  url = format(dt, "ftp://ftp.bmf.com.br/IPN/TRS/BVBG.086.01/PR%y%m%d.zip")
  
  filename = format(dt, "Arquivos/PR%y%m%d.zip")             
  
  if(!file.exists(filename)) {
    download.file(url, filename, mode= "wb")
  }
  
  files = unzip(filename, exdir = "Arquivos")
  last.file = max(files)
  
  xml = xmlParse(last.file)
  
  file.remove(files)
  
  root = xmlRoot(xml)
  BizFileHdr = xmlChildren(root)[[1]]
  Xchg = xmlChildren(BizFileHdr)[[1]]
  BizGrps = xmlElementsByTagName(Xchg, "BizGrp", recursive = FALSE)
  
  from.node.to.data.frame = function(b) {
    #lendo node
    doc = xmlElementsByTagName(b, "Document", recursive = FALSE)[[1]]
    PricRpt = xmlChildren(doc)[[1]]
    TckrSymb = xmlValue(xmlElementsByTagName(PricRpt, "TckrSymb", recursive = TRUE))
    FinInstrmAttrbts = xmlElementsByTagName(PricRpt, "FinInstrmAttrbts", recursive = FALSE)[[1]]
    #criando data frame
    df = as.data.frame(t(getChildrenStrings(FinInstrmAttrbts)), stringsAsFactors =  F)
    df$TckrSymb = TckrSymb
  
    return(df)
  }
  
  #from.node.to.data.frame(BizGrps[[1500]])
  
  # #Criar o data.frame principal
  # dados = data.frame()
  # #passar por todos os bizgrps
  # for(i in 1:length(BizGrps)){
  #   #para cada um: criar um data frame
  #   b = BizGrps[[i]]
  #   df = from.node.to.data.frame(b)
  #   #juntar cp, p daya frame principal
  #   dados = rbind.fill(dados, df)
  # }
  
  dados = ldply(.data = BizGrps, .fun = from.node.to.data.frame)
  
  dados[, ".id"] = NULL
  
  non.numerics = c("TckrSymb", "MktDataStrmId", "AdjstdQtStin", "PvsAdjstdQtStin")
  numerics = colnames(dados)[!colnames(dados) %in% non.numerics]
  
  for(col in numerics){
    dados[,col] = as.numeric(dados[,col])
  }
  
  dados$DtRef = dt

  return(dados)
}

tempo = system.time(te <- ler.BMF.BVBG(as.Date("2020-05-29")), TRUE)
print(tempo)
View(te[grepl("E", te$MktDataStrmId),])