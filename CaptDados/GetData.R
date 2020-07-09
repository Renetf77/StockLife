require(XML)
require(plyr)
require(doParallel)

ler.BMF.BVBG = function(dt){
  stopifnot(is(dt, "Date"), length(dt) == 1)

  filename = format(dt, "Arquivos/BVBG.086.01/PR%y%m%d.zip")             
  
  files = unzip(filename, exdir = "Arquivos")
  last.file = max(files)
  
  xml = xmlParse(last.file)
  
  file.remove(files)
  
  root = xmlRoot(xml)
  BizFileHdr = xmlChildren(root)[[1]]
  Xchg = xmlChildren(BizFileHdr)[[1]]
  BizGrps = xmlElementsByTagName(Xchg, "BizGrp", recursive = FALSE)
  
  from.node.to.data.frame = function(b, adt) {
    #lendo node
    doc = xmlElementsByTagName(b, "Document", recursive = FALSE)[[1]]
    PricRpt = xmlChildren(doc)[[1]]
    Dt = xmlValue(xmlElementsByTagName(PricRpt, "Dt", recursive = TRUE))[[1]]
    TckrSymb = xmlValue(xmlElementsByTagName(PricRpt, "TckrSymb", recursive = TRUE))[[1]]
    FinInstrmAttrbts = xmlElementsByTagName(PricRpt, "FinInstrmAttrbts", recursive = FALSE)[[1]]
    #criando data frame
    df = as.data.frame(t(getChildrenStrings(FinInstrmAttrbts)), stringsAsFactors =  F)
    #print(TckrSymb)
    #print(Dt)
    df$Dt = as.Date(Dt, "%Y-%m-%d")
    df$TckrSymb = TckrSymb
    
    df = df[grepl("^[A-Z]{4}[1-9][0-9]{0,1}[FB]{0,1}$",df$TckrSymb),] # ELIMINANDO OPÇÕES
    df = df[grepl(adt, df$Dt),] # Eliminando registro de ajuste para a data seguinte.

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
  
  dados = ldply(.data = BizGrps, .fun = from.node.to.data.frame, adt = dt, .id = NULL, .parallel = F)
  
  dados[, "Dt"] = NULL
  
  non.numerics = c("TckrSymb", "MktDataStrmId", "AdjstdQtStin", "PvsAdjstdQtStin")
  numerics = colnames(dados)[!colnames(dados) %in% non.numerics]
  
  for(col in numerics){
    dados[,col] = as.numeric(dados[,col])
  }
  
  dados$DtRef = as.Date(dt, "%Y-%m-%d")

  return(dados)
}


