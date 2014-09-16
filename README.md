---
title: "README.md"
author: "Ben Haley"
date: "Monday, September 15, 2014"
output: html_document
---

This project converts experimental data from the project described in <http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones> to a summarized tidy dataset. The original data is available at <https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>. The result is provided in this project as summaryDataset.txt. This dataset and the transformations required are described in CodeBook.md. The transformation routines are provided in run_analysis.R. 

To reproduce the transformation, execute the R code in run_analysis.R. This code will do the following:

- Create a `data` directory to hold the original data

- Download the original datafile to the `data` directory

- unzip the original datafile to the `data` directory

- load the data

- transform data as described in CodeBook.R

- save the result to summaryDataset.txt



The dataset includes the following files:
=========================================

- 'README.md' : this file

- 'CodeBook.md': Codebook describing the original dataset, transformations to the input data and the resulting dataset.

- 'run_analysis.R': Code that performs the transformations.

- 'summaryDataset.txt': Final dataset.
