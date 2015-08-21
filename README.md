## Introduction

This assignment uses data from [this URL](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) (last accessed 8/21/15).

## Script usage

The first four steps of processing this data can be accomplished by using the *getMergedData()* function:

1. Both the test and train data sets were merged.
2. The mean() and std() estimated varibles were isolated from the merged data set.
3. The Activity numbers were mapped to their respective names, then merged into the data set.
4. The Subjects were merged into the data set.

The final steps of aggregating the data and writing to the file can be accomplished by using the *createProcessedTidiedDataFile()* function:

5. Each of the variables remaining in the data set were aggregated as an average by both Activity and Subject.
6. The data set was written to "processedData.txt"


### Example

Ensure the working directory is pointing to the root of the original dataset, where files such as "activity_labels.txt" and "features.txt" can be found.

Code:

mergedData <- getMergedData()   
createProcessedTidiedDataFile(mergedData)


## Script function description

The script was broken up into several components that each accomplish their own purpose.

The first functions to observe are *getTestData()* and *getTrainData()*. Both of these functions are responsible for loading the multiple files for each data set and merging them into a single data frame, for each type(test/train) respectively. The output from each of these will be the y_*.txt, x_*.txt, subject_*.txt, activity_labels.txt and features.txt files combined together. Note that features.txt provides the name of the columns for the data in x_*.txt. The comments in each function should sufficiently describe what is being done.

*getColumnNames()* simply leads the features.txt file and returns a vector of each name value. This is later *pivoted* in both *getTestData()* and *getTrainData()* by setting the column names to this vector.

*getActivities()* simply loads the lookup table that is provided in "activity_labels.txt", and names the columns "id" and "name" for later merging. The output of this function is later used in both *getTestData()* and *getTrainData()* to transform the numeric ids provided in y_*.txt into its text-equivalent, for readability.

*createMergedDataset()* is the entry point for processing Steps 1, 3 and 4. This loads the activity lookup through *getActivities()*, loads the test and train data through the *getTestData()* and *getTrainData()* functions described above. It then uses rbind to combine the two sets into one, and returns the value.

*extractData()* is responsible for taking the full data set and extracting only the mean() and std() fields, as described in Step 2.

*getMergedData()* is the entry point to accomplish all of Steps 1-4. This function simply calls *getColumnNames()*, *createMergedDataset()*, and *extractData()*, in order, and returns the result.

*createProcessedTidiedDataFile()* is the function that accomplishes Steps 5-6. This function will aggregate all the Subject and Activity data points by their mean. As a result of this grouping, some additional clean-up needs to be done on the column names. Each column(except for Subject and Activity) is then prefixed with the name "mean_" to recognize the change in representation. Finally, the data frame is written to a file named "processedData.txt"