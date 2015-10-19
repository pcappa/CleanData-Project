###############################################################################################################
#
#  This R program tidy's the data for an exercise type device.  It pulls together the training and test files
#  and organizes the information into a single table, the computes the mean for each of the activities for
#  each subject.  The tydied data is then written to the disc in a file called "tidy_data.txt".
#
#  I am completely aware that there are more efficient ways to use memory and I have elected to make the
#  code more readable for the benefit of the reviewers.
#
###############################################################################################################

require(reshape2)
require(plyr)


###############################################################################################################
#
#  Setup the constants for the file system.
#
###############################################################################################################

setwd("~\Courses\\Johns Hopkins Data Analytics\\03 Getting and Cleaning Data\\Project")
home.dir <- ".\\UCI HAR Dataset"
sep <- "\\"

#  These are the file names of the files to be used.

activity.file <- paste(home.dir,sep,"activity_labels.txt",sep="")
features.file <- paste(home.dir,sep,"features.txt",sep="")
x.test.file <- paste(home.dir,sep,"test\\X_test.txt",sep="")
y.test.file <- paste(home.dir,sep,"test\\y_test.txt",sep="")
subject.test.file <- paste(home.dir,sep,"test\\subject_test.txt",sep="")

x.train.file <- paste(home.dir,sep,"train\\X_train.txt",sep="")
y.train.file <- paste(home.dir,sep,"train\\y_train.txt",sep="")
subject.train.file <- paste(home.dir,sep,"train\\subject_train.txt",sep="")

tidy.file <- paste(home.dir, sep, "tidy.txt", sep="")

###############################################################################################################
#
# Define the functions to be used in this exercise.
#
###############################################################################################################


# Read in the "X" data, reduce the number of columns to data containing the mean() and std() data. Next,
# assign the column names to the features for the devices.  Finally, massage the column names by eliminating 
# parentesis and converting dashes to periods.

df.x <- function(filename, features) {
    x <- read.table(filename)
    names(x) <- features$feature
    x <- x[,grep("*-mean\\(\\)*|*-std\\(\\)*", features$feature, value=FALSE)]
    names(x) <- gsub("\\(\\)", "", names(x))
    names(x) <- gsub("-", ".", names(x))
    x
}


# Read in the "Y" data and assign the column name "Activity.ID"

df.y <- function(filename) {
    y <- read.table(filename, col.names=c("activity.ID"))
    y
}

# Read in the "subject" data and assign the column name "subject"

df.subject <- function(filename) {
    subject <- read.table(filename, col.names=c("subject"))
    subject
}


###############################################################################################################
#
# Get the activity labels and assign readable/logical names to each column.
#
###############################################################################################################

activity <- read.table(activity.file)
names(activity) <- c("activity.ID", "activity")


# Get the features and assign logiacl names to each column.

features <- read.table(features.file)
names(features) <- c("feature.ID", "feature")


###############################################################################################################
#
# Create two data frames, test & train.  These data frames contain the subject, activity data, and
# acceleraometer information.  Next we combine the test and train tables.  Then, we join the combined table
# with the activity table, to bring in the text for the activity.
#
###############################################################################################################

test <- cbind(df.subject(subject.test.file), df.y(y.test.file), df.x(x.test.file, features))
train <- cbind(df.subject(subject.train.file), df.y(y.train.file), df.x(x.train.file, features))
combined <- rbind(train, test)
joined <- join(activity, combined, by=c("activity.ID", "activity.ID"))


###############################################################################################################
#
# The final preparation step is to melt the table by subject and activity, so we can create the mean for 
# each activity.
#
###############################################################################################################

melted <- melt(joined, id = c("subject", "activity"))
dcasted <- dcast(melted, subject + activity ~ variable, mean)
tidy.data <- dcasted[order(dcasted$subject, dcasted$activity.ID),]


###############################################################################################################
#
#  Save the tidied data.
#
###############################################################################################################

write.table(tidy.data, "tidy.txt", row.names = FALSE, quote = FALSE)