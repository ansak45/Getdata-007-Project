# run_analysis.R
# Getting and Cleaning Data - project assignment
# Use this R script to produce 'tidy_data.txt' - uploaded
# following is the body of the script which is submitted on github
#
# set working directory to adirectory which has the UCI HAR Dataset Directory
setwd("Course-Getting-and-Cleaning-Data/project")
# 
# The following analysis extracts/format the data from test first and then training and merges the results together 
# Then it takes mean and writes out out the tidy data set to a file.  This file was uploaded as part of the submission.
# 
library(reshape2)
library (data.table)

# Load: activity labels 
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2] 

# Load: data column names 
features <- read.table("./UCI HAR Dataset/features.txt")[,2] 

# Extract only the measurements on the mean and standard deviation for each measurement. 
extract_features <- grepl("mean|std", features) 

# Load and process X_test & y_test data. 
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt") 
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt") 
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt") 
names(X_test) = features 

# Extract only the measurements on the mean and standard deviation for each measurement. 
X_test = X_test[,extract_features] 

# Load activity labels 
y_test[,2] = activity_labels[y_test[,1]] 
names(y_test) = c("Activity_ID", "Activity_Label") 
names(subject_test) = "subject" 

# Bind data 
test_data <- cbind(as.data.table(subject_test), y_test, X_test) 

# Load and process X_train & y_train data. 
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt") 
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt") 

subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt") 
names(X_train) = features 

# Extract only the measurements on the mean and standard deviation for each measurement. 
X_train = X_train[,extract_features] 

# Load activity data 
y_train[,2] = activity_labels[y_train[,1]] 
names(y_train) = c("Activity_ID", "Activity_Label") 
names(subject_train) = "subject" 

# Bind data 
train_data <- cbind(as.data.table(subject_train), y_train, X_train) 


# Merge test and train data 
data = rbind(test_data, train_data) 

id_labels   = c("subject", "Activity_ID", "Activity_Label") 
data_labels = setdiff(colnames(data), id_labels) 
melt_data      = melt(data, id = id_labels, measure.vars = data_labels) 


# Apply mean function to dataset using dcast function 
tidy_data   = dcast(melt_data, subject + Activity_Label ~ variable, mean) 
##++++++++++++++++++ Write out the Tidy data Set to a file
write.table(tidy_data, file = "tidy_data.txt", row.name=FALSE )
##