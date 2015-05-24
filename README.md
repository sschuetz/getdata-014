# Getting and Cleaning Data Course Project

## Prerequisites
The R-Script "run_analysis.R" makes usage of the following libraries:

* dplyr
* tidyr
* stringi

You can install these libraries with the following commands:

* `install.packages("stringi")`
* `install.packages("dplyr")`
* `install.packages("tidyr")`

## Description "run_analysis.R"
This R-Script checks for the relevant dataset-files in the current working directory.
If there are missing parts, it will download and extract the whole ZIP-File from the
location https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
and store it as Dataset.zip in the current working directory; after that it will extract
the relevant files.
The rest of the script does the main ETL ( extract, transform, load) work on the datasets.
With the final dataset "step5Dataset" the result gets saved into the file "tidyDataset.txt".



