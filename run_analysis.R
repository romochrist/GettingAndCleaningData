run_analysis <- function() {
    require(dplyr)
    # load activity labels
    activityLabels <- read.table("activity_labels.txt", col.names = c("ActivityId", "Activity"))
    # load feature names
    featureNames <- read.table("features.txt", col.names = c("FeatureId", "Feature"))
    
    # load subject data 
    subjectDataTest <-  read.table("test/subject_test.txt", col.names = c("SubjectId"))
    subjectDataTrain <-  read.table("train/subject_train.txt", col.names = c("SubjectId"))
    # merge test and train subject data
    subjectData <- rbind(subjectDataTest, subjectDataTrain)
    
    # load activity data
    activityDataTest <- read.table("test/y_test.txt", col.names = c("ActivityId"))
    activityDataTrain <- read.table("train/y_train.txt", col.names = c("ActivityId"))
    # merge test and train activity data
    activityData <- rbind(activityDataTest, activityDataTrain)
    
    # load feature data 
    featureDataTest <-  read.table(file = "test/X_test.txt", sep = "", col.names = featureNames$Feature, check.names = FALSE)
    featureDataTrain <-  read.table(file = "train/X_train.txt", sep = "", col.names = featureNames$Feature, check.names = FALSE)
    featureData <-  rbind(featureDataTest, featureDataTrain)
    
    # merging all data together
    mergedData = cbind(subjectData, activityData, featureData)
    
    # subsetting the column names including mean and std data
    tidyData <- mergedData[, grepl("mean|std|Activity|Subject|Feature", names(mergedData), ignore.case = TRUE)]
    
    # merging data sets to match activity id's with activity names
    tidyData <-  merge(tidyData, activityLabels, by = "ActivityId", all = FALSE) %>% select(-ActivityId)
    
    # grouping and summarizing data
    summarizedData <- group_by(tidyData, SubjectId, Activity) %>% summarise_all(funs(mean))
    
    # writing to a file
    write.table(summarizedData, file = "tidy_data.txt", row.names = FALSE)
}