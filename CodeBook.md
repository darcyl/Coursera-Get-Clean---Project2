---
title: "CodeBook.md"
author: "Darcy Lewis"
date: "Sunday, July 20, 2014"
description: documentation for Project 2 in Geting & Cleaning Data 

Contents: 
Part 1 - Columns in data set (measure_summary.txt)
Part 2 - All steps from source data to creation of the measure_summary.txt output file
---
##Part 1 - Columns in data set (measure_summary.txt)
*SubjectId -A unique identifier for a subject (person) participating in the program collecting data.  1-30
*ActivityName - One of 6 possible values for the activity being performed when measurements were being collected: WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING or LAYING

*79 measurements

Of the 561 measurements gathered/present in the original data source only those taking a mean or standard deviation were retained.  Multiple measurements were available in the original data for each subject and activity.  This data set has summarized the multiple measurements (by taking the mean) for a given subject and activity.  From the original documentation, below is a description of the measures (features) included in this data set.
---
```{r}
Feature Selection 
The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

tBodyAcc-XYZ
tGravityAcc-XYZ
tBodyAccJerk-XYZ
tBodyGyro-XYZ
tBodyGyroJerk-XYZ
tBodyAccMag
tGravityAccMag
tBodyAccJerkMag
tBodyGyroMag
tBodyGyroJerkMag
fBodyAcc-XYZ
fBodyAccJerk-XYZ
fBodyGyro-XYZ
fBodyAccMag
fBodyAccJerkMag
fBodyGyroMag
fBodyGyroJerkMag

The set of variables that were estimated from these signals are: 

mean(): Mean value
std(): Standard deviation
```
Part 2 - All steps from source data to creation of the measure_summary.txt output file
---
```{r}
setwd("C:/Users/Darcy/Documents/Coursera/GetAndClean/Project2")
## 1
## load the test and train data sets to R
testresults<-read.table("UCI HAR Dataset/test/X_test.txt")
trainresults<-read.table("UCI HAR Dataset/train/X_train.txt")
## 2
## load the activity corresponding to each row and the names of the activities
testactivity<-read.table("test/y_test.txt")
trainactivity<-read.table("train/y_train.txt")
activitynames<-read.table("activity_labels.txt", stringsAsFactors=FALSE)
colnames(activitynames)<-c("activityid","activityname")
## 3
## load the subject corresponding to each row 
testsubjects<-read.table("test/subject_test.txt")
trainsubjects<-read.table("train/subject_train.txt")
## 4
## load the features file (column headings) for the data
## and apply the headings to both the train and test data sets
heading<-read.table("features.txt")
colnames(testresults)<-heading[,2]
colnames(trainresults)<-heading[,2]
## 5
## append a column to each of the dataframes to identify the 
## original source of the data.
## append subject identifier to each row
## merge the two dataframes into a single dataframe (results) 
testresults$measuresrc<-"test"
trainresults$measuresrc<-"train"
testresults$subject<-testsubjects[,1]
trainresults$subject<-trainsubjects[,1]
## 6
## Append a new column with the activity id to the respective set of data
testresults$activityid<-testactivity[,1]
trainresults$activityid<-trainactivity[,1]
## 7
## combine the test and training data sets into single set of data
results<-rbind(testresults, trainresults)
## 7
## recreate the dataframe with only those columns containing
## a mean (-mean) or standard deviation (-std) measure and
## the new columns added above
results<-results[,grepl("mean|std|measuresrc|activityid|subject",colnames(results))]
## 8
## add column name to results with the descriptive name for the activity
results<-merge(results,activitynames,by.x="activityid",by.y="activityid",all=TRUE)
columns<-colnames(results)
measures<-columns[grepl("-mean|-std",colnames(results))]
results$subject<-factor(results$subject)
results$activityname<-factor(results$activityname)
## 9
## derive mean by subject id and activity for all std and mean measures
agg<-aggregate(results[,2:80],list(results$subject,results$activityname),mean)
## 10
## Update factor column names in tidy dataset
colnames(agg)[1:2]<-c("SubjectId","Activity")
## 11
## create file containing summarized tidy data
write.csv(agg,file="measure_summary.txt")
```
