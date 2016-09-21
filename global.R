# Authors:
# Carlos García @ cm.garsua@gmail.com
# Adam Alpire @ am.rivero13@gmail.com
names<- read.csv("./data/Nombres.csv",sep=";",header=F,stringsAsFactors = F)
arrests <- read.csv("./data/arrestsUSA2010.csv", sep=";")
arrests[is.na(arrests)] <- 0
arr2=data.frame(t(arrests))
colors <-random_colors(length(arrests)-2)
names(colors)<- colnames(arrests[,3:length(arrests)])
colors<- substr(colors,1,nchar(colors)-2)