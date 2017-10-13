# Getting and Cleaning Data Course Project

The purpose of this project is to demonstrate the ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. It will be graded by peers on a series of yes/no questions related to the project. It will be required to submit: 

1. A tidy data set as described below. 

2. A link to a Github repository with the script for performing the analysis.

3. A code book that describes the variables, the data, and any transformations or work that performed to clean up the data called CodeBook.md. It should also be included a README.md in the repo with the scripts. This repo explains how all of the scripts work and how they are connected.


One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained [here](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).


Here are the data for the project: [data.](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)


You should create one R script called run_analysis.R that does the following.

> Merges the training and the test sets to create one data set.

Using the *__read.table__* function to read the data, with *__col.names__* parameter the data is loaded with the specified column names, useful for requirements on point 4. The following code loads the subject data for the test and train sets, then merges the two set with *__rbind__* function.

```R
    # load subject data 
    subjectDataTest <-  read.table("test/subject_test.txt", col.names = c("SubjectId"))
    subjectDataTrain <-  read.table("train/subject_train.txt", col.names = c("SubjectId"))
    # merge test and train subject data
    subjectData <- rbind(subjectDataTest, subjectDataTrain)
```

The same applies to read the activity data.

```R
    # load activity data
    activityDataTest <- read.table("test/y_test.txt", col.names = c("ActivityId"))
    activityDataTrain <- read.table("train/y_train.txt", col.names = c("ActivityId"))
    # merge test and train activity data
    activityData <- rbind(activityDataTest, activityDataTrain)
```

For the feature data, first load the feature names to use them as the column names on feature data.

```R
    # load feature names
    featureNames <- read.table("features.txt", col.names = c("FeatureId", "Feature"))
```

Loading the feature data, using the *__featureNames__* variable as the column names, then the data is merged with *__rbind__*.

```R
    # load feature data 
    featureDataTest <-  read.table(file = "test/X_test.txt", sep = "", col.names = featureNames$Feature, check.names = FALSE)
    featureDataTrain <-  read.table(file = "train/X_train.txt", sep = "", col.names = featureNames$Feature, check.names = FALSE)
    featureData <-  rbind(featureDataTest, featureDataTrain)
```

Finally all the data is merged as one data set through *__cbind__* function.

```R
    # merging all data together
    mergedData = cbind(subjectData, activityData, featureData)
```

> Extracts only the measurements on the mean and standard deviation for each measurement.

Subsetting the merged data using *__grepl__* to select only the column names including the texts *mean* and *std*. Since the data were loaded using initial column names, these are included in the regular expression  *__"mean|std|Activity|Subject|Feature"__*.

```R
    # subsetting the column names including mean and std data
    tidyData <- mergedData[, grepl("mean|std|Activity|Subject|Feature", names(mergedData), ignore.case = TRUE)]
```

> Uses descriptive activity names to name the activities in the data set.

Loading the activity names and then usgin the *__merge__* function to combine the data sets by de *__ActivityId__* column. Additionaly the merged data set is passed throug the *__select__* function to include all the columns but *__ActivityId__*.

```R
    # merging data sets to match activity id's with activity names
    tidyData <-  merge(tidyData, activityLabels, by = "ActivityId", all = FALSE) %>% select(-ActivityId)
```

> Appropriately labels the data set with descriptive variable names.

All the data is loaded with descriptive variable names using the *__col.names__* parameter when reading the files with *__read.table__*.

> From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

The data is grouped by *_SubjectId_* and *__Activity__* and then summarized to apply the *__mean__* function to all the columns.

```R
    # grouping and summarizing data
    summarizedData <- group_by(tidyData, SubjectId, Activity) %>% summarise_all(funs(mean))
```

Finally the data set is written to a file named *__tidy_data.txt__*.

```R
    # writing to a file
    write.table(summarizedData, file = "tidy_data.txt", row.names = FALSE)
```

# Running the script

To run the data analysis just source the script *__run_analysis.R__* and execute the following function:

```R
    run_analysis()
```

This will create a file named *__tidy_data.txt__* on the current working directory.

# Reading the tidy data set

To read the tidy data set use the following code:

```R
    read.table("tidy_data.txt", check.names = FALSE, , header = TRUE)
```