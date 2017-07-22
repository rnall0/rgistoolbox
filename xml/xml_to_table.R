library(XML)
library(RSQLite)
library(sqldf)

system.time(doc<-xmlParse("data/xml_data.xml", useInternalNodes = TRUE))
els <- getNodeSet(doc, "//Table1")

colm<-xmlToDataFrame(els[1])
colm<-colm[0,]
db<-dbConnect(SQLite(), dbname = "Output.sqlite")
dbWriteTable(conn = db, name = "TableName", value = colm)
dbDisconnect(db)


counter<-0
tot<-length(els)
system.time(for (i in 1:length(els)){
  node_gather.df<-xmlToDataFrame(els[i])
  db<-dbConnect(SQLite(), dbname = "Output.sqlite")
  dbWriteTable(conn=db, name = "TableName", value = node_gather.df, append=TRUE)
  dbDisconnect(db)
  counter <<- counter + 1;
  message(paste(counter, "of", tot))
})

# counter<-0
# tot<-length(els)
# nodelist<-list()
# system.time(for (i in 1:length(els)){
#   node_gather.df<-xmlToDataFrame(els[i])
#   counter <<- counter + 1;
#   message(paste(counter, "of", tot))
#   nodelist[[i]] <- node_gather.df
# })

#nodecombine<-do.call(rbind,nodelist)
