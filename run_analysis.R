library(utils)
library(dplyr)
library(tidyr)


# Function to a file from the web 
downloadFile <- function(fileUrl, file) {
        # Make sure there is a directory for storing downloaded files
        if (!file.exists("./data")) {
                dir.create("./data")
        }
        
        # Fetch the file to the data directory
        filename <- paste0("./data/", file)
        if (!file.exists(filename)) {
                download.file(fileUrl, filename)
                dateDownloaded <- date()
        }
}

# Function to read a dataset
# This function looks for training or test datasets as selected by the set parameter.
# ColClasses identifies the columns that should be brought in from the file and how to interpret
# data in the column. 
# FeatureNames contains the column names to use for the metrics.
readDataset <- function(set, colClasses, featureNames) {
        # Get filenames
        subjectFilename <- gsub("\\{set}", set, "./data/UCI HAR Dataset/{set}/subject_{set}.txt")
        activityFilename <- gsub("\\{set}", set, "./data/UCI HAR Dataset/{set}/y_{set}.txt")
        metricFilename <- gsub("\\{set}", set, "./data/UCI HAR Dataset/{set}/X_{set}.txt")
        
        # Read the list of subjects
        subjects <- read.table(subjectFilename,
                               col.names = c("subject"),
                               as.is = TRUE)

        # Read the list of activities
        activities <- read.table(activityFilename,
                                 colClasses = c("factor"),
                                 col.names = c("activity"),
                                 as.is = TRUE)
        
        # Read the metrics
        metrics <- read.table(metricFilename,
                              colClasses = colClasses,
                              col.names = featureNames)

        # Combine
        cbind(metrics, subjects, activities)
}


# Download the dataset
downloadFile("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "Dataset.zip")

# Unzip the file
unzip("./data/Dataset.zip", exdir = "./data")

# Read the features to use as the column names
featureNames <- read.table("./data/UCI HAR Dataset/features.txt", sep = " ", colClasses = c("NULL", NA))[,1]

# Clean up the names because they are pretty ugly. Want to make something nice for my column headings
featureNames = gsub("Acc", "-accelerometer-", featureNames)
featureNames = gsub("Gyro", "-gyroscope-", featureNames)
featureNames = gsub("^t", "time-", featureNames)
featureNames = gsub("^f", "fourier-", featureNames)
featureNames = gsub("Mag", "magnitude", featureNames)
featureNames = gsub("-mean\\()", "-mean", featureNames)
featureNames = gsub("-std\\()", "-standardDeviation", featureNames)
featureNames = gsub("Body", "body", featureNames)
featureNames = gsub("Gravity", "gravity", featureNames)
featureNames = gsub("Jerk", "jerk-", featureNames)

# The BodyBody dimensions appears to be a bug
featureNames = gsub("bodybody", "body", featureNames)
featureNames = gsub("--", "-", featureNames)
featureNames = gsub("\\()", "", featureNames)


# Read the activity labels to use as meaningful names
activityNames <- read.table("./data/UCI HAR Dataset/activity_labels.txt",
                            sep = " ",
                            col.names = c("activity", "activityName"),
                            colClasses = c("factor", "factor"))

# Make activity labels lower case because I like that for features
activityNames[,2] <- tolower(activityNames[,2])


# Make an array of classes that can be used to filter columns to only load means and standard deviations.
# The filters will be used when loading data to improve efficiency.
# Discarding the "magnitude" columns because they can be derived from the X, Y and Z columns. Part of 
# being tidy is eliminating metrics that can be derived from other metrics.
desiredColumns <- grepl("-mean|-standardDeviation", featureNames) & !grepl("magnitude", featureNames)
colClasses <- rep("NULL", length(featureNames))
colClasses[desiredColumns] <- NA



# Read the test dataset
testDataset <- readDataset("test", colClasses, featureNames)

# Read the training dataset
trainingDataset <- readDataset("train", colClasses, featureNames)

# Merge the datasets
fullDataset <- rbind(testDataset, trainingDataset)


# Label the activities
fullDataset <- fullDataset %>%
        inner_join(activityNames, by = "activity", copy = TRUE)

# Trim columns that we don't need
# Convert variable columns to a single "variable" column
# Set group_by criteria to the subject, activity and variable.
# Compute the averages by calling summarize
summaryDataset <- fullDataset %>%
        select(-matches("activity$"), -matches("test")) %>%
        gather(variable, value,  time.body.accelerometer.mean.X:fourier.body.gyroscope.meanFreq.Z) %>%
        group_by(subject, activityName, variable) %>%
        summarize(mean(value)) %>%
        arrange(as.numeric(subject), activityName, variable)

colnames(summaryDataset) <- c("subject", "activity", "variable", "value")

# Reorganize to separate domain, location, sensor, measurement and direction
summaryDataset$variable <- gsub("\\.jerk", "Jerk", summaryDataset$variable)
summaryDataset$variable <- gsub("\\.meanFreq", "Frequency.mean", summaryDataset$variable)
summaryDataset <- summaryDataset %>%
        separate(variable, into = c("domain", "location", "sensor", "measurement", "direction"), sep = "\\.") %>%
        spread(measurement, value)

# Write the resulting file
write.table(summaryDataset, file = "summaryDataset.txt", row.name = FALSE)
