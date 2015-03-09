# Randy Armknecht
# 
# Coursera - Getting and Cleaning Data
#
# Workbook
setwd("C:/Users/ranarm01/Documents/Github/Coursera-DataScience-3")

# Quiz 3
library(dplyr)

# Question 1
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv", "quiz3_data1.csv")

raw <- read.csv("quiz3_data1.csv")
df <- tbl_df(raw)
rm("raw")

# filter to households on greater than 10 acres who sold more than $10,000 worth of agriculture products
# Code Book: https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf
# ACR == 3 : House on ten or more acres
# AGS == 6 : Sale of Agricultural products 10,000+

agricultureLogical <- raw[(raw$ACR == 3 & raw$AGS == 6),]
# 125, 238, 262

# Question 2
library(jpeg)
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg", "quiz3_data2.jpg", mode="wb")
data <- readJPEG("quiz3_data2.jpg", native=TRUE)
quantile(data, probs=c(0.3,0.5,0.8))
# -15259150 -10575416 

# Question 3
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv", "quiz3_data3.csv")
df.gdp <- tbl_df(read.csv("quiz3_data3.csv", skip=9, 
                          col.names=c("ccode", "rank","x2","economy", "gdp_in_mil","x5"),
                          colClasses=c("character","numeric","character","character","character","character")))

df.gdp
df.new <- select(df.gdp, ccode, rank, economy, gdp_in_mil)
df.new <- filter(df.new, rank > 0)
df.new

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv", "quiz3_data3b.csv")
df.edu <- tbl_df(read.csv("quiz3_data3b.csv"))

df.edu <- mutate(df.edu, ccode = CountryCode)
df.edu

intersect(names(df.new), names(df.edu))
df.m <- tbl_df(merge(df.new, df.edu))
df.m$gdp_in_mil <- as.numeric(df.m$gdp_in_mil)
df.m$rank <- as.numeric(df.m$rank)

df.m

q3.ans <- df.m %>% arrange(desc(rank))
# 189 matches, 13th country is St. Kitts and Nevis 

# Question 4
df.q4a <- df.m %>% select(ccode, rank, economy, gdp_in_mil, Income.Group) %>% filter(Income.Group == "High income: OECD") %>% select(rank)
df.q4b <- df.m %>% select(ccode, rank, economy, gdp_in_mil, Income.Group) %>% filter(Income.Group == "High income: nonOECD") %>% select(rank)
mean(df.q4a$rank)
mean(df.q4b$rank)
# 32.96667, 91.91304

# Question 5
df.m$quantile <- with(df.m, cut(rank, 
                                breaks=quantile(rank, probs=seq(0,1, by=0.2)), 
                                include.lowest=TRUE))
df.m$quantile <- as.numeric(df.m$quantile)
select(df.m, rank, economy, Income.Group, quantile)
table(df.m$quantile, df.m$Income.Group)
# 5 Countries