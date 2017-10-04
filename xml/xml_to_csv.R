#-------------------------Data.table Method-------------------#

system.time(doc<-xmlParse("data/2017/test.xml", useInternalNodes = TRUE))

d = xmlRoot(doc)
size = xmlSize(d)

names = NULL
system.time(for(i in 1:size){
  v = getChildrenStrings(d[[i]])
  names = unique(c(names, names(v)))
})
#data.table method
m = data.table(matrix(NA,nc=length(names), nr=size))
setnames(m, names)

for (n in names) mode(m[[n]]) = "character"


system.time(for(i in 1:size){
  v = getChildrenStrings(d[[i]])
  m[i, names(v):= as.list(v), with=FALSE]
})

for (n in names) m[, n:= type.convert(m[[n]], as.is=TRUE), with=FALSE]

out<-as.data.frame(m)
out = out[-1,]
out$element<-NULL

#for first ONLY
#write.csv(out, "data/2017/csv/test.csv", row.names = FALSE, na="", quote = TRUE)

write.table(out, "data/2017/csv/ECrash2017.csv", row.names=F, na="", append = TRUE, quote= TRUE, sep = ",", col.names = FALSE)
