# If it does not exist, download the data from the website
# and extract it
getData <- function() {
  if (!dir.exists("data")){
    dir.create("data")
  }
  
  setwd("data")
  
  if (!file.exists("UCI_HAR_Dataset.zip")){
    download.file(url="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",destfile = "UCI_HAR_Dataset.zip")
  }
  
  if (!dir.exists("UCI HAR Dataset")){
    unzip("UCI_HAR_Dataset.zip")
  }
  
  setwd("..")
  
}

library(data.table,quietly = TRUE)
library(dplyr,quietly = TRUE)
# Load the descriptive names for the features
loadFeatures <- function(){
  setwd("data\\UCI HAR Dataset")
  features <<- fread("features.txt")
  features$V2 <<- gsub(",","&",gsub("[(][)]","",features$V2))
  features[grep("(bandsEnergy)",features$V2)] <<- mutate(features[grep("(bandsEnergy)",features$V2)],V2 = paste(V2,V1,sep="_"))
  setwd("../../")
}

# Load the descriptive names for the activities
loadActivities <- function(){
  setwd("data\\UCI HAR Dataset")
  activities <<- fread("activity_labels.txt")
  names(activities) <<- c("ActivityId","ActivityName")
  setwd("../../")
}

# Load teh Training Data set, update the column names with 
# the features list and join the activities
loadTrainData <- function() {
  setwd("data\\UCI HAR Dataset\\train")
  y_train <<- fread("y_train.txt")
  sub_train <<- fread("subject_train.txt")
  X_train <<- fread("X_train.txt")
  
  if (is.null(features)){
    loadFeatures()
  }
  if(is.null(activities)){
    loadActivities()
  }
  
  
  # Join them together
  names(X_train) <- features$V2
  #select only columns with mean and std in name
  dt <- select(X_train,matches("(mean|std)"))
  #add observation Type
  dt <- mutate(dt,ObsType = "Train")
  dt <- cbind(sub_train,y_train,dt)
  names(dt)[1:2] <- c("SubjectId","ActivityId")
  
  dt <- full_join(activities,dt)
  
  train<<-dt
  
  setwd("../../../")
}


# Load the Test DataSet, update the column names with 
# the features list and join the activities
loadTestData <- function() {
  setwd("data\\UCI HAR Dataset\\test")
  y_test <<- fread("y_test.txt")
  sub_test <<- fread("subject_test.txt")
  X_test <<- fread("X_test.txt")
  
  if (is.null(features)){
    loadFeatures()
  }
  if(is.null(activities)){
    loadActivities()
  }
  
  # Join them together
  names(X_test) <- features$V2
  #select only columns with mean and std in name
  dt <- select(X_test,matches("(mean|std)"))
  #add observation Type
  dt <- mutate(dt,ObsType = "Test")
  dt <- cbind(sub_test,y_test,dt)
  names(dt)[1:2] <- c("SubjectId","ActivityId")
  
  dt <- full_join(activities,dt)
  
  test <<- dt
  
  setwd("../../../")
}

# Merge the cleaned Test and Train datasets in to a single
# dataset
mergeData <- function(){
  activityData <<- rbind(train,test)
}

# Create a secondary dataset with the averages
summarizeData <- function(){
  activityDataAvgSummary <<- activityData %>% group_by(ActivityId,ActivityName,SubjectId,ObsType) %>% summarize_all(mean)
  
}

## All Inits
getData()
loadFeatures()
loadActivities()

loadTrainData()
loadTestData()

mergeData()
summarizeData()