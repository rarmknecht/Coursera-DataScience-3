# Randy Armknecht
# 
# Coursera - Getting and Cleaning Data
#
# Workbook
# Windows
#setwd("C:/Users/ranarm01/Documents/Github/Coursera-DataScience-3")
# Linux
setwd("/mnt/truecrypt11/coding/Coursera-DataScience-3")

library(dplyr)

# Project

# 1. Merges the training and the test sets to create one data set.

# 1.1 - Merging X Dataset
df.train.x <- tbl_df(read.table("UCI HAR Dataset/train/X_train.txt"))
df.test.x <- tbl_df(read.table("UCI HAR Dataset/test/X_test.txt"))
df.x <- rbind(df.train.x, df.test.x)

# 1.2 - Merging Y Dataset (note that 'y' is lowercase in these filenames)
df.train.y <- tbl_df(read.table("UCI HAR Dataset/train/y_train.txt"))
df.test.y <- tbl_df(read.table("UCI HAR Dataset/test/y_test.txt"))
df.y <- rbind(df.train.y, df.test.y)

# 1.3 - Merging Subject Dataset
df.train.subject <- tbl_df(read.table("UCI HAR Dataset/train/subject_train.txt"))
df.test.subject <- tbl_df(read.table("UCI HAR Dataset/test/subject_test.txt"))
df.subject <- rbind(df.train.subject, df.test.subject)

# 1.4 - Clear Memory of the unmerged datasets
rm("df.train.x","df.train.y","df.test.x","df.test.y","df.train.subject","df.test.subject")

# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 

# 2.1 - Load the column names from 'features.txt' 
#       (V1 = Column #, V2 = Column Name)
features <- tbl_df(read.table("UCI HAR Dataset/features.txt"))
df.features <- filter(features,grepl("mean\\(\\)|std\\(\\)", V2))

# 2.2 - Name all the columns in our combined X dataset
names(df.x) <- features$V2

# 2.3 - Filter based on the column # (V1) of items that matched mean/std in step 2.1
df.x <- df.x[,df.features$V1]

# 3. Uses descriptive activity names to name the activities in the data set

# 3.1 - Load the activity names that match up with the Y dataset values
labels <- tbl_df(read.table("UCI HAR Dataset/activity_labels.txt"))

# 3.2 - Set column names for my y variable datasets
names(labels) <- c("activity_id", "activity")
names(df.y) <- c("activity_id")

# 3.3 - Convert df.y from dyplr back to data.frame, and then dynamically filter/combine with labels
df.y <- data.frame(df.y)
df.y <- tbl_df(labels[df.y[,1],2])

# 4. Appropriately labels the data set with descriptive variable names. 

# 4.1 - Label the X columns
#
#   This was done in step 2.2

# 4.2 - Label the Y columns
#
#   This was done in step 3.2

# 4.3 - Label the Subject columns
names(df.subject) <- c("subject")

# 5. From the data set in step 4, creates a second, independent tidy data set with 
#    the average of each variable for each activity and each subject.
#

# 5.1 - Bind my 3 data pieces together
df.clean <- cbind(df.subject, df.y, df.x)

# 5.2 - Write my clean/merged data to disk
write.table(df.clean, "clean_data.txt")

# 5.3 - Prepare clean data for melting
library(reshape2)
tidy.id_labels <- c("subject", "activity")
tidy.data_labels <- setdiff(names(df.clean), tidy.id_labels)
tidy.melted <- melt(df.clean, id = tidy.id_labels, measure.vars = tidy.data_labels)

# 5.4 - Use dcast from Reshape2 on the melted data to mass apply mean() function
tidy.data <- dcast(tidy.melted, subject + activity ~ variable, mean)

# 5.5 - Write the Tidy Data file to disk
write.table(tidy.data, "tidy.data.txt", row.name=FALSE)
