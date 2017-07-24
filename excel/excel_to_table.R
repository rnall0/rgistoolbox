library(readxl)
library(RSQLite)
library(sqldf)

sd2016<-read_excel("data/excel_data.xlsx") #read excel file

db<-dbConnect(SQLite(), dbname = "Output.sqlite") #connect to db
dbWriteTable(conn=db, name = "TableNamexls", value = sd2016) #write entire table to SQLite #, append=TRUE)
dbDisconnect(db) #disconnect
