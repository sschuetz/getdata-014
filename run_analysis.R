library(dplyr)
library(tidyr)

datasetURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
destFilename <- "Dataset.zip"
datasetFilenames <-
  c("UCI HAR Dataset/activity_labels.txt", "UCI HAR Dataset/features.txt", 
    "UCI HAR Dataset/features_info.txt", "UCI HAR Dataset/README.txt", 
    "UCI HAR Dataset/test/", "UCI HAR Dataset/test/Inertial Signals/", 
    "UCI HAR Dataset/test/Inertial Signals/body_acc_x_test.txt", 
    "UCI HAR Dataset/test/Inertial Signals/body_acc_y_test.txt", 
    "UCI HAR Dataset/test/Inertial Signals/body_acc_z_test.txt", 
    "UCI HAR Dataset/test/Inertial Signals/body_gyro_x_test.txt", 
    "UCI HAR Dataset/test/Inertial Signals/body_gyro_y_test.txt", 
    "UCI HAR Dataset/test/Inertial Signals/body_gyro_z_test.txt", 
    "UCI HAR Dataset/test/Inertial Signals/total_acc_x_test.txt", 
    "UCI HAR Dataset/test/Inertial Signals/total_acc_y_test.txt", 
    "UCI HAR Dataset/test/Inertial Signals/total_acc_z_test.txt", 
    "UCI HAR Dataset/test/subject_test.txt", "UCI HAR Dataset/test/X_test.txt", 
    "UCI HAR Dataset/test/y_test.txt", "UCI HAR Dataset/train/", 
    "UCI HAR Dataset/train/Inertial Signals/", "UCI HAR Dataset/train/Inertial Signals/body_acc_x_train.txt", 
    "UCI HAR Dataset/train/Inertial Signals/body_acc_y_train.txt", 
    "UCI HAR Dataset/train/Inertial Signals/body_acc_z_train.txt", 
    "UCI HAR Dataset/train/Inertial Signals/body_gyro_x_train.txt", 
    "UCI HAR Dataset/train/Inertial Signals/body_gyro_y_train.txt", 
    "UCI HAR Dataset/train/Inertial Signals/body_gyro_z_train.txt", 
    "UCI HAR Dataset/train/Inertial Signals/total_acc_x_train.txt", 
    "UCI HAR Dataset/train/Inertial Signals/total_acc_y_train.txt", 
    "UCI HAR Dataset/train/Inertial Signals/total_acc_z_train.txt", 
    "UCI HAR Dataset/train/subject_train.txt", "UCI HAR Dataset/train/X_train.txt", 
    "UCI HAR Dataset/train/y_train.txt")


download_and_unzip_dataset <- function () {
  if(!file.exists(destFilename) || !(unzip(destFilename, list = TRUE)$Name == datasetFilenames)) {
    download.file(datasetURL, destfile = destfileName, method = "curl")
  }
  unzip(destFilename, overwrite = TRUE)
}

if(FALSE %in% file.exists(datasetFilenames)) {
  stop("missing files")
}

activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", 
                              sep = " ", header = FALSE, col.names = c("id", "activity"))
activity_labels <- tbl_df(activity_labels)

features <- read.table("UCI HAR Dataset/features.txt", 
                       sep = " ", header = FALSE, col.names = c("id", "description"))
features <- tbl_df(features)

##

x_test <- read.table("UCI HAR Dataset/test/X_test.txt", 
                     header = FALSE ,col.names = features$description)
x_test <- tbl_df(x_test)

y_test <- read.table("UCI HAR Dataset/test/y_test.txt",header = FALSE, col.names = c("activityID"))
y_test <- mutate(y_test, activity_label = activity_labels[activityID,]$activity)

subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE, col.names = c("subject"))

test <- cbind(x_test, y_test)
test <- cbind(test, subject_test)

##

##

x_train <- read.table("UCI HAR Dataset/train/X_train.txt", 
                     header = FALSE ,col.names = features$description)
x_train <- tbl_df(x_train)

y_train <- read.table("UCI HAR Dataset/train/y_train.txt",header = FALSE, col.names = c("activityID"))
y_train <- mutate(y_train, activity_label = activity_labels[activityID,]$activity)

subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE, col.names = c("subject"))

train <- cbind(x_train, y_train)
train <- cbind(train, subject_train)

##

workingDataset <- union(test, train)
workingDataset <- tbl_df(workingDataset)



