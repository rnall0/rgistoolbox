library(RSQLite)
library(sqldf)
library(devtools)
library(bigrquery)

db<-dbConnect(SQLite(), dbname = "Output.sqlite") #Connect to SQLite 
query<-dbSendQuery(db, "select * from TableName") #construct query
system.time(ecr<-dbFetch(query, n = -1)) #fetch query
dbDisconnect(db) #disconnect

project<-"project-name" #set project name variable

insert_upload_job(project, "Dataset", "TableName", ecr) #insert dataframe to BigQuery table
