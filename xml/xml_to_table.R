library(XML)
library(RSQLite)
library(sqldf)

system.time(doc<-xmlParse("data/xml_data.xml", useInternalNodes = TRUE)) #load xml file
els <- getNodeSet(doc, "//Table1") #identify index of nodes

colm<-xmlToDataFrame(els[1]) #create dummy dataframe
colm<-colm[0,] #remove all rows, only keeping column names
db<-dbConnect(SQLite(), dbname = "Output.sqlite") #create SQLite database
dbWriteTable(conn = db, name = "TableName", value = colm) #write empty table to SQLite for proper columns
dbDisconnect(db) #disconnect from SQLit


counter<-0 #counter setup for the iteration
tot<-length(els) #get total number of nodes/elements
system.time(for (i in 1:length(els)){
  node_gather.df<-xmlToDataFrame(els[i])
  db<-dbConnect(SQLite(), dbname = "Output.sqlite")
  dbWriteTable(conn=db, name = "TableName", value = node_gather.df, append=TRUE)
  dbDisconnect(db)
  counter <<- counter + 1;
  message(paste(counter, "of", tot))
}) #iterate through each node, convert to a data frame, connect to SQLite, append dataframe to SQLite table, disconnect from SQLite, print a tracking number

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
