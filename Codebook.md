Codebook for the UCI data on Human Activity Recognition Using Smartphones
=========================================================================

This will describe the Tidy Data set in detail along with the process used to create the data. This R code will transform the UCI Data on Human Activity Recognition Using Smartphones into a Tidy Data Set. More information on the data set can be obtained from http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones and 

## The Study Design and Input Data

The study design for the original data cab be found at:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The input data set used can be found at:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

## The Transformation Process

#### Step 1 - Preparation
* Read all test and train observations and identifier files (subjects, activities, column names)
* Add the identifiers to the observations
* Select the columns that will be used in next steps
* Combine subjects, activities and observations into one data frame

#### Step 2 - Combine all observations
* Combine training and test data sets into one large data set
* Merge in the Activity Label to provide a proper header name and remove the ID column

#### Step 3 - Regroup and calculate means
* Change the data grouping of the observations to compute the mean for each combination of subject and activity

#### Step 4 - Clean up column names
* Perform some edits on the column names to improve readability

#### Step 5 - Write the new data into a file
* The new data is written into the file "tidydata.csv"

