library(data.table)
library(dplyr)

features <- fread("UCI HAR Dataset/features.txt", col.names = c("featureId", "featureName"), header = FALSE)
activity <- fread("UCI HAR Dataset/activity_labels.txt", col.names = c("activityId", "activityLabel"), header = FALSE)

# remove/update invalid characters
featureNames <- gsub("\\(\\)", "", features$featureName)
featureNames <- gsub("[,-]", ".", featureNames)
featureNames <- gsub("^t", "TimeDomain", featureNames)
featureNames <- gsub("^f", "FrequencyDomain", featureNames)
# join with feature id to get unique names
featureNames <- paste(features$featureId, featureNames, sep="_")

mergeDataset <- function(type) {
  subject <- fread(sprintf("UCI HAR Dataset/%s/subject_%s.txt", type, type), col.names = c("subjectId"), header = FALSE)
  xTrain <- fread(sprintf("UCI HAR Dataset/%s/X_%s.txt", type, type), header = FALSE, col.names = featureNames, check.names = FALSE)
  yTrain <- fread(sprintf("UCI HAR Dataset/%s/y_%s.txt", type, type), header = FALSE, col.names = c("activityId"))
  yTrainWithName <- merge(yTrain, activity, by=c("activityId"), sort=FALSE)
  obsSeq <- seq(1:128)
  body.acc.x <- fread(sprintf("UCI HAR Dataset/%s/Inertial Signals/body_acc_x_%s.txt", type, type), header = FALSE, col.names = sprintf("bodyAccX_%s",obsSeq))
  body.acc.y <- fread(sprintf("UCI HAR Dataset/%s/Inertial Signals/body_acc_y_%s.txt", type, type), header = FALSE, col.names = sprintf("bodyAccY_%s",obsSeq))
  body.acc.z <- fread(sprintf("UCI HAR Dataset/%s/Inertial Signals/body_acc_z_%s.txt", type, type), header = FALSE, col.names = sprintf("bodyAccZ_%s",obsSeq))
  body.gyro.x <- fread(sprintf("UCI HAR Dataset/%s/Inertial Signals/body_gyro_x_%s.txt", type, type), header = FALSE, col.names = sprintf("bodyGyroX_%s",obsSeq))
  body.gyro.y <- fread(sprintf("UCI HAR Dataset/%s/Inertial Signals/body_gyro_y_%s.txt", type, type), header = FALSE, col.names = sprintf("bodyGyroY_%s",obsSeq))
  body.gyro.z <- fread(sprintf("UCI HAR Dataset/%s/Inertial Signals/body_gyro_z_%s.txt", type, type), header = FALSE, col.names = sprintf("bodyGyroZ_%s",obsSeq))
  total.acc.x <- fread(sprintf("UCI HAR Dataset/%s/Inertial Signals/total_acc_x_%s.txt", type, type), header = FALSE, col.names = sprintf("totalAccX_%s",obsSeq))
  total.acc.y <- fread(sprintf("UCI HAR Dataset/%s/Inertial Signals/total_acc_y_%s.txt", type, type), header = FALSE, col.names = sprintf("totalAccY_%s",obsSeq))
  total.acc.z <- fread(sprintf("UCI HAR Dataset/%s/Inertial Signals/total_acc_z_%s.txt", type, type), header = FALSE, col.names = sprintf("totalAccZ_%s",obsSeq))

  tbl_df(data.table(xTrain, yTrainWithName, subject, body.acc.x, body.acc.y, body.acc.z, body.gyro.x, body.gyro.y, body.gyro.z, total.acc.x, total.acc.y, total.acc.z))
}
# 1. Merges the training and the test dataset
tbl <- mergeDataset("train") %>% bind_rows(mergeDataset("test"))

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
names <- names(tbl)
meanStdVariables <- names[grep(pattern = "mean|std|activityLabel|subject", x = names(tbl), ignore.case = TRUE)]
tblMeanStd <- tbl[meanStdVariables] 

# 3. Uses descriptive activity names to name the activities in the data set
# The final dataset was merged with activity_labels.txt and the name stored on variable "activityLabel"

# 4. Appropriately labels the data set with descriptive variable names.
# It was done by replacing the prefix 't' with TimeDomain and 'f' with FrequencyDomain

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
tblMean <- tbl %>%
group_by(activityId, activityLabel, subjectId) %>% 
summarize_all(funs(mean))

write.table(tblMean, row.name = FALSE)
