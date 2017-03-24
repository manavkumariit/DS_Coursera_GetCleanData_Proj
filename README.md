# Getting and Cleaning Data - Course project

## Project Instructions

A full description of the Data:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Solution Instructions

Either Knit the CodeBook.Rmd OR execute the script run_analysis.R which will take care of all the 4 steps above. The scripts contain various functions for different tasks:

1. Loading the data
2. Setting up the names for the features and activities
3. Loading the Training and Test Data Sets
4. Combining the Training and Test Data Sets
5. Summarizing the Final Dataset

The function names are self explainatory.

The "Init" section at the end of the script takes care of all the steps in order.

The Final Data is loaded to activityData.

A summary data, as required in Step 4 is loaded to activityDataAvgSummary
