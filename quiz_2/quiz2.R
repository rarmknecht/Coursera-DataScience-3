# Randy Armknecht
# 
# Coursera - Getting and Cleaning Data
#
# Workbook
setwd("C:/Users/ranarm01/Documents/Github/Coursera-DataScience-3")


# Quiz 2
# Question 1
library(httr)
library(dplyr)
oauth_endpoints("github")
myapp <- oauth_app("github", "2c73c964ea87ebb7dddd", "snipped!")
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)
gtoken <- config(token = github_token)
req <- GET("https://api.github.com/users/jtleek/repos", gtoken)
stop_for_status(req)

vals <- lapply(content(req), "[", c("name"))
vals
content(req)[[5]]

# 2013-11-07T13:25:07Z

# Question 2
library(sqldf)
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv", "quiz2_data2.csv")
acs <- read.csv("quiz2_data2.csv")
# sqldf("select pwgtp1 from acs where AGEP < 50")

# Question 3
unique(acs$AGEP)
#sqldf("select distinct AGEP from acs")

# Question 4
con = url("http://biostat.jhsph.edu/~jleek/contact.html")
htmlCode <- readLines(con)
close(con)
nchar(htmlCode[10])
nchar(htmlCode[20])
nchar(htmlCode[30])
nchar(htmlCode[100])
# 45 31 7 25

# Question 5
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for", "quiz2_data5.fxf")
raw <- read.fwf("quiz2_data5.fxf", skip=4, widths=c(10,9,4,9,4,9,4,9,4), colClasses=c("character", "numeric",
                                                                                      "numeric","numeric",
                                                                                      "numeric","numeric",
                                                                                      "numeric","numeric",
                                                                                      "numeric"))
tbl_df(raw) %>% select(V4) %>% sum
# 32426.7