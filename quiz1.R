# Randy Armknecht
# 
# Coursera - Getting and Cleaning Data
#
# Workbook
setwd("C:/Users/ranarm01/Documents/Github/Coursera-DataScience-3")

# Quiz 1
library(dplyr)
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv", "quiz1_data.csv")
raw <- read.csv("quiz1_data.csv")
df <- tbl_df(raw)

#question 1
df %>% select(VAL) %>% filter(VAL==24)
# 53

# question 2
# tidy data has one variable per column

# question 3
library(xlsx)

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx", "quiz1_data2.xlsx", mode="wb")

cols <- 7:15
rows <- 18:23
dat <- read.xlsx("quiz1_data2.xlsx", colIndex=cols, rowIndex=rows, sheetIndex=1)
sum(dat$Zip*dat$Ext,na.rm=T) 
# 36534720

# question 4
library(XML)

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml", "quiz1_data3.xml")
doc <- xmlTreeParse("quiz1_data3.xml", useInternal=TRUE)
rootNode <- xmlRoot(doc)
zips <- list(xpathSApply(rootNode,"//zipcode", xmlValue))
names(zips) <- c("zipcode")
zdf <- as_data_frame(lz)
filter(zdf, zipcode=="21231")
# 127

# question 5
library(data.table)
library(rbenchmark)

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv", "quiz1_data4.csv")
DT <- fread("quiz1_data4.csv")
#mean(DT$pwgtp15,by=DT$SEX)
#rowMeans(DT)[DT$SEX==1]; rowMeans(DT)[DT$SEX==2]

testf = function()
  mean(DT[DT$SEX==1,]$pwgtp15)
mean(DT[DT$SEX==2,]$pwgtp15)

benchmark(tapply(DT$pwgtp15,DT$SEX,mean))
benchmark(sapply(split(DT$pwgtp15,DT$SEX),mean))
benchmark(testf())
benchmark(DT[,mean(pwgtp15),by=SEX])

# sapply is fastest