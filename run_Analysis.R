
library(dplyr)


filename <- "UCI HAR DATASET"
filepath <- getwd()

##reading in files from train folder
xtrain = read.table(file.path(filepath,filename, "train", "X_train.txt"),header = FALSE)
ytrain = read.table(file.path(filepath,filename, "train", "y_train.txt"),header = FALSE)
subject_train = read.table(file.path(filepath, filename, "train", "subject_train.txt"),header = FALSE)

##reading data from test folder
xtest = read.table(file.path(filepath,filename, "test", "X_test.txt"),header = FALSE)
ytest = read.table(file.path(filepath,filename, "test", "y_test.txt"),header = FALSE)
subject_test = read.table(file.path(filepath,filename, "test", "subject_test.txt"),header = FALSE)

##reading data on features 
features = read.table(file.path(filepath,filename, "features.txt"),header = FALSE)

##reading activity data
activityLabels = read.table(file.path(filepath,filename, "activity_labels.txt"),header = FALSE)

##giving each data set appropriate column names

colnames(ytrain) = "activityId"
colnames(ytest) = "activityId"
colnames(subject_train) = "subjectId"
colnames(subject_test) = "subjectId"
colnames(xtrain) = features[,2]
colnames(xtest) = features[,2]
colnames(activityLabels)=c("activityId", "activity type")

##merge training and test sets 
X <- rbind(xtrain, xtest)
Y <- rbind(ytrain, ytest)
Subject <- rbind(subject_train, subject_test)
Merged_Data <- cbind(Subject, Y, X)

colNames <- colnames(Merged_Data)
##need only the columns which have mean or std_deviation information
mean_stdev <- (grepl("activityId", colNames) | grepl("subjectId", colNames) | grepl("mean..", colNames) | grepl("std..", colNames))
setForMeanAndStd <- Merged_Data[ , mean_stdev == TRUE]

##get the average for each variable for each subject and each activity
setWithActivityNames = merge(setForMeanAndStd, activityLabels, by='activityId', all.x=TRUE)
total_mean <- setWithActivityNames %>% group_by(activityId, subjectId) %>% summarize_each(funs(mean))

write.table(total_mean, file = "./UCI HAR Dataset/tidydata.txt", row.names = FALSE)