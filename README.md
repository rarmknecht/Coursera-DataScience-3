# Project - Getting and Cleaning Data
---

The code assumes that the data for the project has been downloaded from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip and unzipped in the working directory.

---

The "run_analysis.R" script runs in the following manner:

    1. Loads and merges train and test data for X, Y, and Subject
    2. Labels the X columns by using the included features.txt file
    3. Selects only columns that contain mean() or std() using grepl()
    4. Uses a data.frame selection trick to merge the label names
    5. Names the rest of the columns that have not already been named
    6. Melts the data using reshape2 to prepare for dcast
    7. dcast is called to apply mean() to all columns that are considered variables
    8. Writes the final file to: "tidy.data.txt"

<em>Note that the code is heavily commented to guide a user</em>
