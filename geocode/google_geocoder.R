#Limit requests to 2500 per day per Google TOS

library(plyr)
library(httr)
library(rjson)
path<-"X:\\path\\to\\data\\geocode.csv"
delim<-","
initial <- read.delim(path, sep=delim, quote=NULL, header=T, colClasses="character")
#cat("Import Data Successful\n")
#cat("----------------------------------------------\n")


#cat("Getting column names....\n")
#cat("----------------------------------------------\n")
print(colnames(initial))
#cat("----------------------------------------------\n")
id<-initial[[as.integer(1)]]
fulladdr<-initial[[as.integer(3)]]
city<-initial[[as.integer(4)]]
state<-initial[[as.integer(5)]]
zip<-initial[[as.integer(6)]]
#cat("Indices defined....\n")
#cat("----------------------------------------------\n")

counter<-0
total<-nrow(initial)

#trim <- function (x) gsub("^\\s+|\\s+$", "", x)
#initial$FULLADDR<-trim(initial$FULLADDR)
#initial$CITY<- trim(initial$CITY)
#initial$STATE<-trim(initial$STATE)
#initial$ZIP<-trim(initial$ZIP)

#cat ("Loading DSTK function....\n")
#cat("----------------------------------------------\n")
counter<-0
total<-nrow(initial)
geo.google <- function(addr){ # single address geocode with google
  require(httr)
  require(rjson)
  url      <- "http://maps.googleapis.com/maps/api/geocode/json" #localhost:8082
  response <- GET(url,query=list(sensor="FALSE",address=addr))
  json <- tryCatch(fromJSON(content(response,type="text")), error=function(uc) NA)
  cat(paste ('"', addr, '"\n', sep = ""))
  counter <<- counter + 1;
  message(paste(counter, "of", total))
  loc  <- tryCatch((json['results'][[1]][[1]]$geometry$location), error=function(j) NA)
  return(tryCatch((c(address=addr,long=loc$lng, lat= loc$lat)), error=function(e) NA))
}


#ptm<-proc.time()
result.matrix <- do.call(rbind,lapply(as.character(paste(fulladdr, city, state, zip)),  geo.google ))
result_df<-data.frame(result.matrix)
#elapse<-proc.time() - ptm
#minutes<-elapse[[3]] / 60
#hours<-minutes / 60
#cat("----------------------------------------------\n")
#cat(paste("Time Elapsed: ", hours, " hours\n"))
#cat("----------------------------------------------\n")

cat("Computing descriptive statistics....\n")
freq<-sum(is.na(result_df$long))
cat("----------------------------------------------\n")
cat(paste("Sum of NAs in table:", freq, "\n"))
cat("----------------------------------------------\n")

cat ("Geocoding finished....\n")
cat("----------------------------------------------\n")

result_df$ID<- initial$ID
merge_tog<-data.frame(merge(initial, result_df, by="ID", all=FALSE))
cat ("IDs brought back....\n")
cat("----------------------------------------------\n")

#good_subset<-merge_tog[!is.na(merge_tog$address), ]
#good_subset$LATITUDE<-good_subset$lat
#good_subset$LONGITUDE<-good_subset$long
good_subset$lat<-NULL
good_subset$long<-NULL
good_subset$address<-NULL
good_subset$PROVIDER<-"Google"
cat ("Writing good table to directory....\n")
#write.table(good_subset, "good.txt", sep="|", row.names = FALSE, quote = FALSE, append = TRUE, col.names = FALSE)
write.csv(merge_tog, "X:\\path\\to\\data\\good.csv", row.names = FALSE, quote = FALSE)
cat("----------------------------------------------\n")

needs_work<-merge_tog[is.na(merge_tog$address), ]
needs_work$lat<-NULL
needs_work$long<-NULL
needs_work$address<-NULL
cat("Writing intermediate table to directory....\n")
write.table(needs_work, "needs_work.txt", sep="|", row.names = F, quote = FALSE)
cat("----------------------------------------------\n")

cat("--------------CHECK OUTPUT FILES--------------\n")
