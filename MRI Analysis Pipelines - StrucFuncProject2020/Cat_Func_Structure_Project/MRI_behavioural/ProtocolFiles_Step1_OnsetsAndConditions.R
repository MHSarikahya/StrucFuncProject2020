## Created on Feb 9th, 2020 to create protocol files for LSM MRI processing ####
##
## by Eric

## gets rid of scientific notation
options(scipen=9999)


# Load Packages not native to R
library(Hmisc)
library(plyr)
library(dplyr)
library(readr)
library(tidyr)
library(magrittr)
library(rlang)

###


#### Set working directory and pull the data into data frames ####

### CHANGE THIS TO WHERE YOU WANT TO SAVE YOUR FRESH NEW DATA FILES

setwd("/Users/eric/GoogleDrive/6_LSM/March_CheckIn/Processing_MRI_data")

# Import Data from tab-delimited text file. "NULL" as empty values.

matching <- read_delim("/Users/eric/GoogleDrive/6_LSM/March_CheckIn/Matching_Merged.txt", 
                       "\t", escape_double = FALSE, na = "NA", 
                       trim_ws = TRUE)

View(matching)

matching_r <- subset(matching, select = c(ExperimentName, Subject, Session, SessionDate, SessionTime, Block, metablock, TaskType, Trial, CorrectResponse, 
                                          ITIs, left_stim, right_stim, task.ACC, task.RESP, task.RT, task1.ACC, task1.RESP, task1.RT, run, FaceL, FaceR, Startline.OnsetTime,
                                          task.OnsetTime, task1.OnsetTime))

View(matching_r)

## Combine matching task and task.1 columns into "task_all" column ######

matching_r$task_all.ACC <- NA
matching_r$task_all.RT <- NA
matching_r$task_all.RESP <- NA
matching_r$task_all.OnsetTime <- NA

matching_r_rows<- nrow(matching_r)

for(row in 1:matching_r_rows) { 
  
  if (is.na(matching_r$task.ACC[row])) {matching_r$task_all.ACC[row] <- matching_r$task1.ACC[row]}  else {matching_r$task_all.ACC[row] <- matching_r$task.ACC[row]}
  if (is.na(matching_r$task.RT[row])) {matching_r$task_all.RT[row] <- matching_r$task1.RT[row]}  else {matching_r$task_all.RT[row] <- matching_r$task.RT[row]}
  if (is.na(matching_r$task.RESP[row])) {matching_r$task_all.RESP[row] <- matching_r$task1.RESP[row]}  else {matching_r$task_all.RESP[row] <- matching_r$task.RESP[row]}
  if (is.na(matching_r$task.OnsetTime[row])) {matching_r$task_all.OnsetTime[row] <- matching_r$task1.OnsetTime[row]}  else {matching_r$task_all.OnsetTime[row] <- matching_r$task.OnsetTime[row]}
  
}

#### sort by Subject
matching_r <- matching_r[with(matching_r, order(matching_r$Subject)), ]

View(matching_r)

#### Creat conditions column for Face, Shape, Number, and Incorrect
matching_r$condition <- NA

matching_r$condition[matching_r$TaskType == "NumberMatching"] <- "number"
matching_r$condition[matching_r$TaskType == "FaceMatching"] <- "face"
matching_r$condition[matching_r$TaskType == "ShapeMatching"] <- "shape"
matching_r$condition[matching_r$task_all.ACC == 0] <- "incorrect"

View(matching_r)

matching_r$Task <- "matching"

### Create separate data frames for each run based on Experiment Name Column
write.csv(matching_r, file = "matching_long_02_09_20_WithConditions_forDesignMatrices.csv", row.names=FALSE)
