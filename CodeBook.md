---
title: "Human Activity Recognition Using Smartphones Dataset"
author: "Ben Haley"
date: "Monday, September 15, 2014"
output: html_document
---

This project creates a tidy dataset from the original dataset to address the following issues:
- Features and data were in separate files
- Activity descriptions were separate from the data 
- Feature names encoded multiple pieces of information susch as the sensor and direction
- test and training data were separated

The original information was contained in 6 data files and 2 dimension files (activity_labels.txt and features.txt). This project combines those files into a single dataset.

The project requirements were to write code that:
- Merges the training and the test sets to create one data set.
- Extracts only the measurements on the mean and standard deviation for each measurement. 
- Uses descriptive activity names to name the activities in the data set
- Appropriately labels the data set with descriptive variable names. 
- From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Since only the mean and standard deviation are of interest, only those columns are extracted from the metric files. This is accomplished by loading the list of features, expanding the names to make them more readable and then selecting the interesting columns using the following criteria:
- Columns that contained mean or std were included except,
- Magnitude columns (contain Mag) were excluded because they can be computed from the directional (XYZ) components,

The following transformations are then applied:
- Load the selected columns from test and training datasets
- Add subject identifiers to the dataset
- Replace activity identifiers with meaningful labels
- Gathered the features into a column
- Summarize data by subject, activity and feature
- Sort the data by subject, activity and feature
- Split the feature into its components
- Convert mean and standard deviation from a variable and value to 2 values to make it easier to work with the mean and standard deviation.

The final set of columns are:
- subject: indicates the person that participated in the experiment.
- activity: identifies whether the subject was `walking`, `walking_upstairs`, `walking_downstairs`, `sitting`, `standaing`, or `laying`.
- domain: indicates whether the values are in the `time` or `frequency (Fourier)` domain.
- location: was the sensor on the `body` or measuring `gravity`.
- sensor: was the sensor an `accelerometer`, change in accelerometer `accelerometerJerk`, `gyroscope`, change in gyroscope `gyroscopeJerk` or the frequency component of each value.
- direction: was the measured direction along the X, Y or Z axis.
- mean: mean of the mean values from a series of experiments.
- standardDeviation: mean of the standard deviation values from a series of experiments.
