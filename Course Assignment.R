if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")
unzip(zipfile="./data/Dataset.zip",exdir="./data")

# Read tables:
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
sub_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
sub_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

features <- read.table('./data/UCI HAR Dataset/features.txt')

activityLabels = read.table('./data/UCI HAR Dataset/activity_labels.txt')


# Assign Names to columns
colnames(x_train) <- features[,2] 
colnames(y_train) <-"activityId"
colnames(sub_train) <- "subjectId"

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(sub_test) <- "subjectId"

colnames(activityLabels) <- c('activityId','activityType')


#merge tables
mrg_train <- cbind(y_train, sub_train, x_train)
mrg_test <- cbind(y_test, sub_test, x_test)
setall <- rbind(mrg_train, mrg_test)


#extract
colNames <- colnames(setall)
                     
meanstd <- (grepl("activityId" , colNames) | 
                                        grepl("subjectId" , colNames) | 
                                        grepl("mean.." , colNames) | 
                                        grepl("std.." , colNames) 
                     )


subsetall <- setall[ , meanstd == TRUE]

activitynames <- merge(subsetall, activityLabels,
                              by='activityId',
                              all.x=TRUE)


tidy <- aggregate(. ~subjectId + activityId, activitynames, mean)
tidy <- tidy[order(tidy$subjectId, tidy$activityId),]

write.table(tidy, "tidy.txt", row.name=FALSE)