##
## Script to clean, merge and summarize the UCI Data on Human Activity Recognition Using Smartphones into a 
## smaller data set of averages. For more information on the input data see
## http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
## For more information on the output data see CodeBook.md
## For more information how to use this script see README.md
##

##
## reads data, subjects and activities, selects relevant values and merges these into one dataframe
##
## directory: directory where data resides
## type: "test" or "train"
##
readRelevantValuesWithSubjectsAndActivities <- function(directory, type, nrows=-1) {
    ## read values, subjects and activities and add names to the columns
    path <- paste0(directory, "/", type, "/")
    values <- read.table(paste0(path, "X_", type, ".txt"), nrows=nrows)
    subjects <- read.table(paste0(path, "/subject_", type, ".txt"), nrows=nrows)
    activities <- read.table(paste0(path, "/y_", type, ".txt"), nrows=nrows)
    valueLabels <- as.vector(read.table(paste0(directory, "/features.txt"))[,2])
    names(values) <- valueLabels
    names(subjects) <- c("SubjectId");
    names(activities) <- c("ActivityId");
    
    ## select the relevant labels (having -mean() or -std())
    valueLabels <- valueLabels[grep("-(m|s)(ean|td)\\(\\)", valueLabels)]
    
    ## use the relevant labels to select the relevant value columns
    values <- values[, valueLabels]
    
    ## combine subjects, activities and values into one data frame
    cbind(subjects, activities, values)
}

##
## cleans up column names
##
getCleanColumnNames <- function(colNames) {
    colNames = sub("-std\\()", "StdDev", colNames)
    colNames = sub("-mean\\()", "Mean", colNames)
    colNames = sub("^f", "Freq", colNames)
    colNames = sub("^t", "Time", colNames)
    
    colNames
}

## make sure we have the necessary libraries
library(reshape2)


## test existence of the data directory
dataDir <- "UCI HAR Dataset"
if (!file.exists(dataDir)) {
    stop(paste0("Data directory '", dataDir, "' does not exist. Stop."))    
}

# read test data
testData <- readRelevantValuesWithSubjectsAndActivities(dataDir, "test")
trainData <- readRelevantValuesWithSubjectsAndActivities(dataDir, "train")

## merge the data sets
mergedData = rbind(testData, trainData)

## read the activity labels and merge them to a new Activity column. Drop the ActivityID column
activityLabels <- read.table(paste0(dataDir, "/activity_labels.txt"))
names(activityLabels) = c("ActivityId", "Activity")
mergedData <- merge(mergedData, activityLabels, sort=FALSE)
mergedData$ActivityId = NULL

## compute the average of each variable for each activity and each subject by using melt() and dcast()
meltedData = melt(mergedData, id.vars = c("SubjectId", "Activity"))
tidyData = dcast(meltedData, SubjectId + Activity ~ variable, mean)

## clean up the column names
names(tidyData) = getCleanColumnNames(names(tidyData))

## write the tidy data set to disk
write.csv(tidyData, "tidydata.csv", row.names=FALSE)