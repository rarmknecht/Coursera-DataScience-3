# Randy Armknecht
# 
# Coursera - Getting and Cleaning Data
#
# Workbook
# Windows
setwd("C:/Users/ranarm01/Documents/Github/Coursera-DataScience-3")
# Linux
#setwd("/mnt/truecrypt11/coding/Coursera-DataScience-3")

library(dplyr)

# Quiz 4

# Question 1
# Apply strsplit() to split all the names of the data frame on the characters "wgtp". 
# What is the value of the 123 element of the resulting list
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv","q4data1.csv")
raw <- read.csv("q4data1.csv")
df <- tbl_df(raw)
df
names(df)
result <- strsplit(names(df),"wgtp")
result[[123]] # ""   "15"

# Question 2
# Remove the commas from the GDP numbers in millions of dollars and average them. What is the average? 
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv", "q4data2.csv")
df <- tbl_df(read.csv("q4data2.csv"))
names(df)
names(df) <- c("short", "rank", "na1", "country", "gdp", "na2", "na3", "na4", "na5", "na6")
df.tmp <- df %>% select(short, country, gdp) %>% filter(grepl("[0-9,]+",gdp))
df.gdp <- filter(df.tmp, row_number() <= 190)
removeCommas <- function(x){as.integer(gsub(" ","",gsub(",","",x)))}
df.gdp$Ngdp <- sapply(df.gdp$gdp, removeCommas)
mean(df.gdp$Ngdp)  #377652.4

# Question 3
df.q3 <- df %>% select(country) %>% filter(grepl("United",country))
df.q3
# grep("^United",countryNames), 3

# Question 4
# How many fiscial years end in June?
q4d3 <- "q4data3.csv"
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv", q4d3)
df <- tbl_df(read.csv(q4d3))
df %>% mutate(short=CountryCode) %>% full_join(df.gdp) %>% select(short,Special.Notes) %>% filter(grepl("end: June",Special.Notes))
# 13  ... Source: local data frame [13 x 2]

# Question 5
library(quantmod)
amzn = getSymbols("AMZN",auto.assign=FALSE)
sampleTimes = index(amzn) 
dim(amzn['2012'])  # 250 values collected
df <- tbl_df(data.frame(weekdays(index(amzn['2012']))))
names(df) <- c("dayofweek")
filter(df,dayofweek == "Monday")  # 47 are Monday