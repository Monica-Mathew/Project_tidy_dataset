library(dplyr) #loading the package dplyr

features <- read.table("UCI HAR Dataset/features.txt", col.names = c("N","functions"))
names(features)

# data is being read
activities<-read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subjecttest<-read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
xtest<-read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
ytest<-read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subjecttrain<-read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
xtrain<-read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
ytrain<-read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

#Merging the test and train datasets
new_x<-rbind(xtrain, xtest)
new_y<-rbind(ytrain, ytest)
new_subject<-rbind(subjecttrain, subjecttest)
merged_data<-cbind(new_subject, new_y, new_x)


#filtering out the mean and standard deviation
tidydata<-merged_Data %>% select(subject, code, contains("mean"), contains("std")) #pipe op: %>%

#uses apt labels for the activities
tidydata$code<-activities[tidydata$code, 2]
names(tidydata)[2] = "activity"
names(tidydata)<-gsub("Acc", "Accelerometer", names(tidydata))
names(tidydata)<-gsub("Gyro", "Gyroscope", names(tidydata))
names(tidydata)<-gsub("BodyBody", "Body", names(tidydata))
names(tidydata)<-gsub("Mag", "Magnitude", names(tidydata))
names(tidydata)<-gsub("^t", "Time", names(tidydata))
names(tidydata)<-gsub("^f", "Frequency", names(tidydata))
names(tidydata)<-gsub("tBody", "TimeBody", names(tidydata))
names(tidydata)<-gsub("-mean()", "Mean", names(tidydata), ignore.case = TRUE)
names(tidydata)<-gsub("-std()", "STD", names(tidydata), ignore.case = TRUE)
names(tidydata)<-gsub("-freq()", "Frequency", names(tidydata), ignore.case = TRUE)
names(tidydata)<-gsub("angle", "Angle", names(tidydata))
names(tidydata)<-gsub("gravity", "Gravity", names(tidydata))

#independent tidy data set with the average of each variable for each activity and each subject
finaltidydata <- tidydata %>%
  group_by(subject, activity) %>%
  summarise_all(list(mean))
write.table(finaltidydata, "finaltidydata.txt", row.name=FALSE)

str(finaltidydata)
finaltidydata
