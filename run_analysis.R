# This function executes the 5th processing step
createProcessedTidiedDataFile <- function(data) {
    # Step 5 From the data set in step 4, create a second, independent tidy data set wtih the avg
    # of each variable for each activity and each subject
    averagedData = aggregate(data, by=list(data$Subject, data$Activity), mean)
    
    # clean up the columns and column names
    averagedData$Subject <- averagedData$Group.1
    averagedData$Activity <- averagedData$Group.2
    averagedData <- averagedData[,!names(averagedData) %in% c("Group.1", "Group.2")]
    names(averagedData)[!(names(averagedData) %in% c("Activity", "Subject"))] <- paste("mean_", names(averagedData)[!(names(averagedData) %in% c("Activity", "Subject"))], sep="") #ugly but it works
    
    write.table(averagedData, file="processedData.txt", row.name=FALSE)
}

# This function executes the first 4 steps in processing the data
getMergedData <- function() {
    
    columnNames <- getColumnNames()
    
    # Step 1: Merge the training and test sets to create one dataset
    mergedData <- createMergedDataset(columnNames)
    
    # Step 2: Extract only the measurements on the mean and stdev for each measurement
    extractedData <- extractData(mergedData)
    
    # NOTE: Step 3 and 4 has been handled at the time both test and train sets were imported
    
    return(extractedData)
}

# Creates the merged data set
createMergedDataset <- function(columnNames) {
    activities <- getActivities()
    
    testData <- getTestData(activities, columnNames)
    trainData <- getTrainData(activities, columnNames)
    mergedData <- rbind(testData, trainData)
    
    return (mergedData)
}

# Extract mean and std columns from data
extractData <- function(mergedData) {
    otherColumns <- c("Subject", "Activity")
    meanColumns <- colnames(mergedData)[grep("mean[(][)]", colnames(mergedData))]
    stdColumns <- colnames(mergedData)[grep("std[(][)]", colnames(mergedData))]
    return (mergedData[,c(otherColumns,meanColumns,stdColumns)])
}

# Load list of features and return the list of column names
getColumnNames <- function() {
    features <- read.table("features.txt")
    return (features$V2)
}

# Load the activities to later be mapped to readable text
getActivities <- function() {
    activities <- read.table("activity_labels.txt")
    colnames(activities) <- c("id", "name")
    return (activities)
}

# Load the test data files, map the activity names and subjects
getTestData <- function(activities, columnNames) {
    library(plyr)
    
    # load each file into memory
    testLabels <- read.table("test/y_test.txt")
    testSet <- read.table("test/x_test.txt")
    testSubjects <- read.table("test/subject_test.txt")
    
    # change the column names for later processing
    colnames(testLabels) = c("id")
    colnames(testSet) = columnNames
    colnames(testSubjects) = c("Subject")
    
    # Step 3: Use descriptive activity names to name the activities in the data set
    # map the testLabels against the activities to give them plain text names
    testLabels <- join(testLabels, activities, by="id")
    
    # add activity to the data set and set column name to Activity
    testSet <- cbind(testLabels$name, testSet)
    names(testSet)[names(testSet)=="testLabels$name"] <- "Activity"
    
    # add subjects to the data set
    testSet <- cbind(testSubjects, testSet)
    
    return (testSet)
}

# Load the train data files, map the activity names and subjects
getTrainData <- function(activities, columnNames) {
    library(plyr)
    
    # load each file into memory
    trainLabels <- read.table("train/y_train.txt")
    trainSet <- read.table("train/x_train.txt")
    trainSubjects <- read.table("train/subject_train.txt")
    
    # change the column names for later processing
    colnames(trainLabels) = c("id")
    colnames(trainSet) = columnNames
    colnames(trainSubjects) = c("Subject")
    
    # Step 3: Use descriptive activity names to name the activities in the data set
    # map the testLabels against the activities to give them plain text names
    #trainLabels <- merge(trainLabels, activities, by.x="V1", by.y="id", sort=FALSE)
    trainLabels <- join(trainLabels, activities, by="id")
    
    # add activity to the data set and set column name to Activity
    trainSet <- cbind(trainLabels$name, trainSet)
    names(trainSet)[names(trainSet)=="trainLabels$name"] <- "Activity"
    
    # add subjects to the data set
    trainSet <- cbind(trainSubjects, trainSet)
    
    return (trainSet)
}