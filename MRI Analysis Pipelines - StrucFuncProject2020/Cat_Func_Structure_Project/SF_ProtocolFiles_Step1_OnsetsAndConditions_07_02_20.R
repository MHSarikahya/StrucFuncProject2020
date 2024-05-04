## Created on Jul 2nd, 2020 to create protocol files for SF MRI processing ####
##
## by Eric & Mo

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

setwd("/Users/Mohammed/Documents/StructureFunction/Code/MRI_Behavioral")


##############################################
############## MATCHING ######################
##############################################

# Import Data from tab-delimited text file. "NULL" as empty values.

matching <- read_delim("/Users/Mohammed/Documents/StructureFunction/DATA/EPRime_data/Matching_ALL_NONunicode.txt",
                       "\t", escape_double = FALSE, na = "NULL",
                       trim_ws = TRUE)

View(matching)

matching_r <- subset(matching, select = c(ExperimentName, Subject, Session, SessionDate, SessionTime, Block, metablock, TaskType, Trial, CorrectResponse, 
                                          ITIs, left_stim, right_stim, task.ACC, task.RESP, task.RT, run, Startline.OnsetTime,
                                          task.OnsetTime))

View(matching_r)


#### sort by Subject
matching_r <- matching_r[with(matching_r, order(matching_r$Subject)), ]

View(matching_r)

#### Creat conditions column for Face, Shape, Number, and Incorrect
matching_r$condition <- NA

matching_r$condition[matching_r$TaskType == "NumberMatching"] <- "number"
matching_r$condition[matching_r$TaskType == "ShapeMatching"] <- "shape"
matching_r$condition[matching_r$task.ACC == 0] <- "incorrect"

View(matching_r)

matching_r$Task <- "matching"

### Create separate data frames for each run based on Experiment Name Column
write.csv(matching_r, file = "SF_matching_long_07_09_20_WithConditions_forOnsetFiles.csv", row.names=FALSE)



##############################################
############## ARITHMETIC ####################
##############################################

# Import Data from tab-delimited text file. "NULL" as empty values.

arithmetic<- read_delim("/Users/eric/GoogleDrive/6_LSM/MRI_Data/fMRI_Merged_EPrime/LSM_Arithmetic_Merged_6_29_20_nu.txt", 
                       "\t", escape_double = FALSE, na = "NULL", 
                       trim_ws = TRUE)

View(arithmetic)

arithmetic_r <- subset(arithmetic, select = c(ExperimentName, Subject, Session, SessionDate, SessionTime, Block, metablock, TaskType, Trial, Answer, Condition, Correct, 
                                              CorrectResponse, DifferenceCorrect, LeftNumber, RightNumber, Verification, Problem.ACC, Problem.CRESP, 
                                              Problem.RESP, Problem.RT, run, StartFixation.OnsetTime, Problem.OnsetTime))

View(arithmetic_r)

#### sort by Subject
arithmetic_r <- arithmetic_r[with(arithmetic_r, order(arithmetic_r$Subject)), ]

View(arithmetic_r)

#### Creat conditions column for Face, Shape, Number, and Incorrect
arithmetic_r$condition <- NA

arithmetic_r$condition[arithmetic_r$Condition == "S"] <- "small"
arithmetic_r$condition[arithmetic_r$Condition== "L"] <- "large"
arithmetic_r$condition[arithmetic_r$Condition== "Plus1"] <- "plus1"
arithmetic_r$condition[arithmetic_r$Problem.ACC == 0] <- "incorrect"

View(arithmetic_r)

arithmetic_r$Task <- "arithmetic"

### Create separate data frames for each run based on Experiment Name Column
write.csv(arithmetic_r, file = "arithmetic_long_06_29_20_WithConditions_forOnsetFiles.csv", row.names=FALSE)


##############################################
################## VSWM ######################
##############################################


# Import Data from tab-delimited text file. "NULL" as empty values.

vswm<- read_delim("/Users/eric/GoogleDrive/6_LSM/MRI_Data/fMRI_Merged_EPrime/LSM_VSWM_Merged_6_29_20_nu.txt", 
                        "\t", escape_double = FALSE, na = "NULL", 
                        trim_ws = TRUE)

View(vswm)

vswm_r<- subset(vswm, select = c(ExperimentName, Subject, Session, SessionDate, SessionTime, metablock, metablock.Sample, TaskType, Trial, answer, bloc.Cycle, 
                                 bloc.Sample, CorrectResponse, NumberOfDots, ITIs, run, targetscreen.ACC, targetscreen.RESP, targetscreen.RT, targetscreen.OnsetTime, 
                                 StartFixation.OnsetTime, run))

View(vswm_r)

#### sort by Subject
vswm_r <- vswm_r[with(vswm_r, order(vswm_r$Subject)), ]

View(vswm_r)

#### Creat conditions column for Face, Shape, Number, and Incorrect
vswm_r$condition <- NA

vswm_r$condition[vswm_r$TaskType == "CON3"] <- "con3"
vswm_r$condition[vswm_r$TaskType == "CON5"] <- "con5"
vswm_r$condition[vswm_r$TaskType == "STM3"] <- "stm3"
vswm_r$condition[vswm_r$TaskType == "STM5"] <- "stm5"
vswm_r$condition[vswm_r$targetscreen.ACC == 0] <- "incorrect"

View(vswm_r)

vswm_r$Task <- "vswm"

### Create separate data frames for each run based on Experiment Name Column
write.csv(vswm_r, file = "vswm_long_06_29_20_WithConditions_forOnsetFiles.csv", row.names=FALSE)


