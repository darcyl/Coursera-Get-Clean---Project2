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
