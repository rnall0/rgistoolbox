#no libraries needed
#this example is getting 'href' nodes (style urls) with associated ids

kml.text <- readLines("file.kml")

re<-"href"
href <- grep(re,kml.text)

re2 <- "Style id="  
style <- grep(re2,kml.text)  

kml.styles <- matrix(0,length(href),2,dimnames=list(c(),c("ID","href")))

for(i in 1:length(href)){  
  #get url
  sub.href <- href[i]  
  temp1 <- kml.text[sub.href]
  hrefurl <- unlist(strsplit(temp1,"href>"))
  hrefurl <-gsub("</", "", hrefurl[2])
  #get id
  sub.ID <- style[i]
  ID <- unlist(strsplit(kml.text[sub.ID],"="))
  ID <- gsub(">","",ID[2])
  ID <- gsub("\"","",ID)
  
  kml.styles[i,] <- matrix(c(ID,hrefurl),ncol=2)
}

kml.styles<-as.data.frame(kml.styles)
