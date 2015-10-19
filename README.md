# Purpose
This document describes the steps performed in the run_analysis.R script.

This R program tidy's the data for an exercise type device.  It pulls together the training and test files and organizes the information into a single table, the computes the mean for each of the activities for each subject.  The tydied data is then written to the disc in a file called "tidy_data.txt". 

I am completely aware that there are more efficient ways to use memory and I have elected to make the code more readable for the benefit of the reviewers.

# The Script
The following steps detail the process of converting the reading, maniuplating, and create the final output.

## Step 1: Define Constants
The first order of business is to setup the constants for the file system.  These define the filenames, home directories, separators, etc.  These are done to make the script configurable by putting all of this information in a single location within the script.

## Step 2: Define Internal Functions
There are three functions defined within this script.

### df.x(filename, features)
This function reads the "X" data from the file specified in "filename" parameter, then assign the column names to as specified in the "features" parameter.  Next the function reduces the number of columns to data containing the mean() and std() data.   Finally, the column names are massaged by eliminating parentesis and converting dashes to periods.

The output is a dataframe.

###df.y(filename) 
Read in the activity data from the file specified in the "filename" parameter. Then assign the column name "Activity.ID".

The output is a dataframe.


###df.subject(filename) 
Read in the subject data from the file specified in the "filename" parameter. Then assign the column name "subject".

The output is a dataframe.


## Step 3: Get Activity Labels
Read the activity labels from the file and assign readable/logical names to each column.


## Step 4: Get Features
Read the features file and assign logical names to each column.  Then reduce to the features we are looking for

## Step 5: Build One Table
Start by creating two dataframes, "test" & "train".  These dataframes contain the subject, activity data, and acceleraometer information.  Next combine the test and train dataframes.  Finally join the combined table with the activity table, to bring in the text for the activity.

Each stage of the data is retained for the purpose of making the code readable to the reviewer.  "Test
is the test data, "train" is the train data, "combined" is the combined test and train data, "joined
is the joined data.

## Step 6: Perform the Mean Calculation
This step takes performs the mean calculation on each of the feature columns by using the melt an dcast functions.  

melted <- melt(joined, id = c("subject", "activity"))
dcasted <- dcast(melted, subject + activity ~ variable, mean)
tidy.data <- dcasted[order(dcasted$subject, dcasted$activity.ID),]

## Step 7: Write File
The final step is to save the tidied data into a file names "tidy.txt".
