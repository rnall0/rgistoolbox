kml.text <- readLines("kmz/GreenMap/doc.kml")


re<-"description"
desc <- grep(re,kml.text)

re2 <- "Placemark id="  
plmark <- grep(re2,kml.text)  




kml.plmarks <- matrix(0,length(desc),2,dimnames=list(c(),c("ID","desc")))

for(i in 1:length(desc)){  
  #get url
  sub.desc <- desc[i]  
  temp1 <- kml.text[sub.desc]
  descurl <- unlist(strsplit(temp1,"src="))
  descurl <- unlist(strsplit(descurl[2],">"))
  descurl <- gsub("\"","",descurl[1])
  #get id
  sub.ID <- plmark[i]
  ID <- unlist(strsplit(kml.text[sub.ID],"="))
  ID <- gsub(">","",ID[2])
  ID <- gsub("\"","",ID)
  
  kml.plmarks[i,] <- matrix(c(ID,descurl),ncol=2)
}

kml.plmarks<-as.data.frame(kml.plmarks)
