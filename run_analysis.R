library(dplyr)
library(tidyr)
library(stringi)

datasetURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
destFilename <- "Dataset.zip"
datasetFilenames <-
  c("UCI HAR Dataset/activity_labels.txt", 
    "UCI HAR Dataset/features.txt", 
    "UCI HAR Dataset/features_info.txt",  
    "UCI HAR Dataset/test/subject_test.txt", 
    "UCI HAR Dataset/test/X_test.txt", 
    "UCI HAR Dataset/test/y_test.txt",
    "UCI HAR Dataset/train/subject_train.txt", 
    "UCI HAR Dataset/train/X_train.txt", 
    "UCI HAR Dataset/train/y_train.txt")

if(FALSE %in% file.exists(datasetFilenames)) {
  if(!file.exists(destFilename)) {
    download.file(datasetURL, destfile = destfileName, method = "curl")
  }
  unzip("Dataset.zip", files = datasetFilenames, overwrite = TRUE)
}

replace_name <- function(s) {
  result <- s
  if(stri_startswith_fixed(s, "f") || stri_startswith_fixed(s, "t")) {
    result <- paste("avg(", s, ")", sep = "")
  }
  result
}

activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", 
                              sep = " ", header = FALSE, col.names = c("id", "activity"))
activity_labels <- tbl_df(activity_labels)

features <- read.table("UCI HAR Dataset/features.txt", 
                       sep = " ", header = FALSE, col.names = c("id", "description"))
features$description <- as.character(features$description)
features_index <- grep("mean()|std()", features$description)
##

x_test <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE)
x_test <- select(x_test, features_index)
names(x_test) <- features$description[features_index]
x_test <- tbl_df(x_test)

y_test <- read.table("UCI HAR Dataset/test/y_test.txt",header = FALSE, col.names = c("activityID"))
y_test <- mutate(y_test, activity_label = activity_labels[activityID,]$activity)

subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE, col.names = c("subject"))

test <- cbind(x_test, y_test)
test <- cbind(test, subject_test)

##

##

x_train <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE)
x_train <- select(x_train, features_index)
names(x_train) <- features$description[features_index]
x_train <- tbl_df(x_train)

y_train <- read.table("UCI HAR Dataset/train/y_train.txt",header = FALSE, col.names = c("activityID"))
y_train <- mutate(y_train, activity_label = activity_labels[activityID,]$activity)

subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE, col.names = c("subject"))

train <- cbind(x_train, y_train)
train <- cbind(train, subject_train)

##

workingDataset <- tbl_df(union(test, train))

step5Dataset <- workingDataset %>% group_by(subject, activity_label) %>% summarise_each(funs(mean)) %>% select(-activityID)
names(step5Dataset) <- lapply(names(step5Dataset), replace_name)
write.table(step5Dataset, file = "tidyDataset.txt", row.names = FALSE, append = FALSE)

##
