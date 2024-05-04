## Created on June 12, 2020 to analyze EPrime data for the March Funding Check-in; MRI behavioral data of LSM project ####
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

# First,export all of the data from e-merge with all subjects as a tab-delimited text file. To do this, go to File > Export > select other from the dropdown 
# menu > enter "NA" for the null values > make sure the "unicode box is not selected" > then export as .txt and make sure you write ".txt" at the end of 
# your filename.



#### Set working directory and pull the data into data frames ####

### CHANGE THIS TO WHERE YOU WANT TO SAVE YOUR FRESH NEW DATA FILES

setwd("/Users/Mohammed/Documents/StructureFunction/DATA/EPRime_data")

###
### CHANGE THESE PATHS FOR THE RAW DATA FILES FROM EPRIME
###

# Import Data from tab-delimited text file. "NULL" as empty values.

arithmetic <- read_delim("/Users/Mohammed/Documents/StructureFunction/DATA/EPRime_data/Arithmetic_ALL_NONunicode.txt", 
                      "\t", escape_double = FALSE, na = "NULL", 
                      trim_ws = TRUE)

vswm <- read_delim("/Users/Mohammed/Documents/StructureFunction/DATA/EPRime_data/DotMatrix_ALL_NONunicode.txt", 
                         "\t", escape_double = FALSE, na = "NULL", 
                         trim_ws = TRUE)

matching <- read_delim("/Users/Mohammed/Documents/StructureFunction/DATA/EPRime_data/Matching_ALL_NONunicode.txt", 
                         "\t", escape_double = FALSE, na = "NULL", 
                         trim_ws = TRUE)

# Visually check the data.
View(arithmetic)
View(vswm)
View(matching)

# Trim to necessary variables in respective data frames.

arithmetic_r <- subset(arithmetic, select = c(ExperimentName, Subject, Session, SessionDate, SessionTime, Block, metablock, TaskType, Trial, Answer, Condition, Correct, 
                                          CorrectResponse, DifferenceCorrect, LeftNumber, RightNumber, Verification, Problem.ACC, Problem.CRESP, 
                                          Problem.RESP, Problem.RT, run))

vswm_r<- subset(vswm, select = c(ExperimentName, Subject, Session, SessionDate, SessionTime, metablock, metablock.Sample, TaskType, Trial, answer, bloc.Cycle, 
                                        bloc.Sample, CorrectResponse, NumberOfDots, ITIs, run, targetscreen.ACC, targetscreen.RESP, targetscreen.RT))

matching_r <- subset(matching, select = c(ExperimentName, Subject, Session, SessionDate, SessionTime, Block, metablock, TaskType, Trial, CorrectResponse, 
                                                  ITIs, left_stim, right_stim, task.ACC, task.RESP, task.RT, run))

# Visually check the data.
View(arithmetic_r)
View(vswm_r)
View(matching_r)


############## Order all sets by Subject

#### sort by Subject
arithmetic_r <- arithmetic_r[with(arithmetic_r, order(arithmetic_r$Subject)), ]
vswm_r <- vswm_r[with(vswm_r, order(vswm_r$Subject)), ]
matching_r <- matching_r[with(matching_r, order(matching_r$Subject)), ]


# Make a simple task column
arithmetic_r$Task <- "arithmetic"
vswm_r$Task <-  "vswm"
matching_r$Task <- "matching"


#### SELECT RUNS FROM EACH PARTICIPANT WHERE WE HAVE MORE THAN ONE RUN

### EXAMPLE CODE ####
# SUBJECT x has 3 arithmetic runs. Based on Anna's notes, use second 2 runs.
# matching_r <- matching_r %>%
#  filter(Subject != 53, Session == 1)

## 


# ## Combine matching task and task.1 columns into "task_all" column ######
# 
# matching_r$task_all.ACC <- NA
# matching_r$task_all.RT <- NA
# matching_r$task_all.RESP <- NA
# 
# matching_r_rows<- nrow(matching_r)
# for(row in 1:matching_r_rows) { 
#   
# if (is.na(matching_r$task.ACC[row])) {matching_r$task_all.ACC[row] <- matching_r$task1.ACC[row]}  else {matching_r$task_all.ACC[row] <- matching_r$task.ACC[row]}
# if (is.na(matching_r$task.RT[row])) {matching_r$task_all.RT[row] <- matching_r$task1.RT[row]}  else {matching_r$task_all.RT[row] <- matching_r$task.RT[row]}
# if (is.na(matching_r$task.RESP[row])) {matching_r$task_all.RESP[row] <- matching_r$task1.RESP[row]}  else {matching_r$task_all.RESP[row] <- matching_r$task.RESP[row]}
# 
# }
# 
# # Check the new columns.
# View(matching_r)

### CHANGE THE NAME OF THE OUTPUT FILES HERE

############## Save all files in their long format
write.csv(arithmetic_r, file = "arithmetic_long_06_12_20_practice.csv", row.names=FALSE)
write.csv(vswm_r, file = "vswm_long_06_12_20_practice.csv", row.names=FALSE)
write.csv(matching_r, file = "matching_long_06_12_20_practice.csv", row.names=FALSE)

### Create separate data frames for each run based on Experiment Name Column
arithmetic_1 <- subset(arithmetic_r, ExperimentName=="Arithmetic_Run1")
arithmetic_2 <- subset(arithmetic_r, ExperimentName=="Arithmetic_Run2")


############ REMINDER - Calcualate behavioral data separately for each Session ##################

#### Compute number of subjects per task, per run, and for both ####
n_arithmetic <- length(unique(arithmetic_r$Subject)) # determine your n
n_arithmetic_1 <- length(unique(arithmetic_1$Subject)) # determine your n
n_arithmetic_2 <- length(unique(arithmetic_2$Subject)) # determine your n

n_vswm <- length(unique(vswm$Subject)) # determine your n

n_matching <- length(unique(matching$Subject)) # determine your n


####################### CREATE DATA FRAME FOR RUN-LEVEL and TASK-LEVEL SUMMARY FILES

arithmetic_summary <- data.frame(matrix(NA, nrow = n_arithmetic, ncol = 1))
vswm_summary <- data.frame(matrix(NA, nrow = n_vswm, ncol = 1))
matching_summary <- data.frame(matrix(NA, nrow = n_matching, ncol = 1))

arithmetic_1_summary <- data.frame(matrix(NA, nrow = n_arithmetic_1, ncol = 1))
arithmetic_2_summary <- data.frame(matrix(NA, nrow = n_arithmetic_2, ncol = 1))


# Fill in Subject Identifier for each dataframe

# the three arithmetic summary data frames
names(arithmetic_summary) <- "Subject"
arithmetic_summary$Subject <- unique(arithmetic_r$Subject)

names(arithmetic_1_summary) <- "Subject"
arithmetic_1_summary$Subject <- unique(arithmetic_1$Subject)

names(arithmetic_2_summary) <- "Subject"
arithmetic_2_summary$Subject <- unique(arithmetic_2$Subject)

# summary data frames
names(vswm_summary) <- "Subject"
vswm_summary$Subject <- unique(vswm_r$Subject)

# matching data frames
names(matching_summary) <- "Subject"
matching_summary$Subject <- unique(matching_r$Subject)


##########################################################
######### TAKE A MOMENT TO ASSESS MISSING DATA ###########
##########################################################

# Compare full subject list for each task and not who is missing a run.

setdiff(arithmetic_summary$Subject, arithmetic_1_summary$Subject)
setdiff(arithmetic_summary$Subject, arithmetic_2_summary$Subject)



##########################################################
############## WRITE SUBJECTS TO SUMMARY DATA ############
##########################################################

# Session Date per run
a <- aggregate(arithmetic_r$SessionDate, by= list(arithmetic_r$Subject), unique, na.rm=TRUE)
names(a) <- c("Subject", "SessionDate_arithmetic")
arithmetic_summary <- merge(arithmetic_summary, a)

a1 <- aggregate(arithmetic_1$SessionDate, by= list(arithmetic_1$Subject), unique, na.rm=TRUE)
names(a1) <- c("Subject", "SessionDate_arithmetic")
arithmetic_1_summary <- merge(arithmetic_1_summary, a1)

a2 <- aggregate(arithmetic_2$SessionDate, by= list(arithmetic_2$Subject), unique, na.rm=TRUE)
names(a2) <- c("Subject", "SessionDate_arithmetic")
arithmetic_2_summary <- merge(arithmetic_2_summary, a2)

b <- aggregate(vswm_r$SessionDate, by= list(vswm_r$Subject), unique, na.rm=TRUE)
names(b) <- c("Subject", "SessionDate_vswm")
vswm_summary <- merge(vswm_summary, b)

b1 <- aggregate(vswm_1$SessionDate, by= list(vswm_1$Subject), unique, na.rm=TRUE)
names(b1) <- c("Subject", "SessionDate_vswm")
vswm_1_summary <- merge(vswm_1_summary, b1)

b2 <- aggregate(vswm_2$SessionDate, by= list(vswm_2$Subject), unique, na.rm=TRUE)
names(b2) <- c("Subject", "SessionDate_vswm")
vswm_2_summary <- merge(vswm_2_summary, b2)

c <- aggregate(matching_r$SessionDate, by= list(matching_r$Subject), unique, na.rm=TRUE)
names(c) <- c("Subject", "SessionDate_matching")
matching_summary <- merge(matching_summary, c)

c1 <- aggregate(matching_1$SessionDate, by= list(matching_1$Subject), unique, na.rm=TRUE)
names(c1) <- c("Subject", "SessionDate_matching")
matching_1_summary <- merge(matching_1_summary, c1)

c2 <- aggregate(matching_2$SessionDate, by= list(matching_2$Subject), unique, na.rm=TRUE)
names(c2) <- c("Subject", "SessionDate_matching")
matching_2_summary <- merge(matching_2_summary, c2)

##########################################################
################## ARITHMETIC  ###########################
##########################################################


##### Create Correct-Only Sets for RT analysis
arithmetic_correct <- subset(arithmetic_r, Problem.ACC==1)
arithmetic_1_correct <- subset(arithmetic_1, Problem.ACC==1)
arithmetic_2_correct <- subset(arithmetic_2, Problem.ACC==1)

###############################
#### Overall Accuracies and RTs

#Accuracy
a <- aggregate(arithmetic_r$Problem.ACC, by= list(arithmetic_r$Subject), mean, na.rm=TRUE)
names(a) <- c("Subject", "arithmetic_acc_mean")
arithmetic_summary <- merge(arithmetic_summary, a)

a1 <- aggregate(arithmetic_1$Problem.ACC, by= list(arithmetic_1$Subject), mean, na.rm=TRUE)
names(a1) <- c("Subject", "arithmetic1_acc_mean")
arithmetic_1_summary <- merge(arithmetic_1_summary, a1)

a2 <- aggregate(arithmetic_2$Problem.ACC, by= list(arithmetic_2$Subject), mean, na.rm=TRUE)
names(a2) <- c("Subject", "arithmetic2_acc_mean")
arithmetic_2_summary <- merge(arithmetic_2_summary, a2)

#RT
b <- aggregate(arithmetic_correct$Problem.RT, by= list(arithmetic_correct$Subject), mean, na.rm=TRUE)
names(b) <- c("Subject", "arithmetic_RT_mean")
arithmetic_summary <- merge(arithmetic_summary, b)

b1 <- aggregate(arithmetic_1_correct$Problem.RT, by= list(arithmetic_1_correct$Subject), mean, na.rm=TRUE)
names(b1) <- c("Subject", "arithmetic1_RT_mean")
arithmetic_1_summary <- merge(arithmetic_1_summary, b1)

b2 <- aggregate(arithmetic_2_correct$Problem.RT, by= list(arithmetic_2_correct$Subject), mean, na.rm=TRUE)
names(b2) <- c("Subject", "arithmetic2_RT_mean")
arithmetic_2_summary <- merge(arithmetic_2_summary, b2)


#####################################
#### Accuracies and RTs by Problem Type (TaskType variable), by run
a <- aggregate(arithmetic_r$Problem.ACC, by= list(arithmetic_r$Subject, arithmetic_r$TaskType), mean, na.rm=TRUE)
names(a) <- c("Subject", "ProblemType", "acc")
a<- spread(a, ProblemType, acc)
names(a) <- c("Subject", "arithmetic_acc_mean_large", "arithmetic_acc_mean_plus1", "arithmetic_acc_mean_small")
arithmetic_summary <- merge(arithmetic_summary, a)

a1 <- aggregate(arithmetic_1$Problem.ACC, by= list(arithmetic_1$Subject, arithmetic_1$TaskType), mean, na.rm=TRUE)
names(a1) <- c("Subject", "ProblemType", "acc")
a1<- spread(a1, ProblemType, acc)
names(a1) <- c("Subject", "arithmetic1_acc_mean_large", "arithmetic1_acc_mean_plus1", "arithmetic1_acc_mean_small")
arithmetic_1_summary <- merge(arithmetic_1_summary, a1)

a2 <- aggregate(arithmetic_2$Problem.ACC, by= list(arithmetic_2$Subject, arithmetic_2$TaskType), mean, na.rm=TRUE)
names(a2) <- c("Subject", "ProblemType", "acc")
a2<- spread(a2, ProblemType, acc)
names(a2) <- c("Subject", "arithmetic2_acc_mean_large", "arithmetic2_acc_mean_plus1", "arithmetic2_acc_mean_small")
arithmetic_2_summary <- merge(arithmetic_2_summary, a2)

b <- aggregate(arithmetic_correct$Problem.RT, by= list(arithmetic_correct$Subject, arithmetic_correct$TaskType), mean, na.rm=TRUE)
names(b) <- c("Subject", "ProblemType", "RT")
b<- spread(b, ProblemType, RT)
names(b) <- c("Subject", "arithmetic_RT_mean_large", "arithmetic_RT_mean_plus1", "arithmetic_RT_mean_small")
arithmetic_summary <- merge(arithmetic_summary, b)

b1 <- aggregate(arithmetic_1_correct$Problem.RT, by= list(arithmetic_1_correct$Subject, arithmetic_1_correct$TaskType), mean, na.rm=TRUE)
names(b1) <- c("Subject", "ProblemType", "RT")
b1<- spread(b1, ProblemType, RT)
names(b1) <- c("Subject", "arithmetic1_RT_mean_large", "arithmetic1_RT_mean_plus1", "arithmetic1_RT_mean_small")
arithmetic_1_summary <- merge(arithmetic_1_summary, b1)

b2 <- aggregate(arithmetic_2_correct$Problem.RT, by= list(arithmetic_2_correct$Subject, arithmetic_2_correct$TaskType), mean, na.rm=TRUE)
names(b2) <- c("Subject", "ProblemType", "RT")
b2<- spread(b2, ProblemType, RT)
names(b2) <- c("Subject", "arithmetic2_RT_mean_large", "arithmetic2_RT_mean_plus1", "arithmetic2_RT_mean_small")
arithmetic_2_summary <- merge(arithmetic_2_summary, b2)


####################################################
#### Count of passive errors or "errors of omission"

omission_arithmetic <- function(m){
  a <- length(m$Problem.RT[m$Problem.RT==0]) 
}

# create variable and add to temporary summary
omission_error_arithmetic <- ddply(arithmetic_r, .(arithmetic_r$Subject), .fun= omission_arithmetic)
names(omission_error_arithmetic) <- c("Subject", "omission_error_arithmetic")
arithmetic_summary <- merge(arithmetic_summary, omission_error_arithmetic)

omission_error_arithmetic1 <- ddply(arithmetic_1, .(arithmetic_1$Subject), .fun= omission_arithmetic)
names(omission_error_arithmetic1) <- c("Subject", "omission_error_arithmetic1")
arithmetic_1_summary <- merge(arithmetic_1_summary, omission_error_arithmetic1)

omission_error_arithmetic2 <- ddply(arithmetic_2, .(arithmetic_2$Subject), .fun= omission_arithmetic)
names(omission_error_arithmetic2) <- c("Subject", "omission_error_arithmetic2")
arithmetic_2_summary <- merge(arithmetic_2_summary, omission_error_arithmetic2)

##########################################################
############# Visuo-spatial Working Memory  ##############
##########################################################


##### Create Correct-Only Sets for RT analysis
vswm_correct <- subset(vswm_r, targetscreen.ACC==1)
vswm_1_correct <- subset(vswm_1, targetscreen.ACC==1)
vswm_2_correct <- subset(vswm_2, targetscreen.ACC==1)

###############################
#### Overall Accuracies and RTs

a <- aggregate(vswm_r$targetscreen.ACC, by= list(vswm_r$Subject), mean, na.rm=TRUE)
names(a) <- c("Subject", "vswm_acc_mean")
vswm_summary <- merge(vswm_summary, a)

a1 <- aggregate(vswm_1$targetscreen.ACC, by= list(vswm_1$Subject), mean, na.rm=TRUE)
names(a1) <- c("Subject", "vswm1_acc_mean")
vswm_1_summary <- merge(vswm_1_summary, a1)

a2 <- aggregate(vswm_2$targetscreen.ACC, by= list(vswm_2$Subject), mean, na.rm=TRUE)
names(a2) <- c("Subject", "vswm2_acc_mean")
vswm_2_summary <- merge(vswm_2_summary, a2)

b <- aggregate(vswm_correct$targetscreen.RT, by= list(vswm_correct$Subject), mean, na.rm=TRUE)
names(b) <- c("Subject", "vswm_RT_mean")
vswm_summary <- merge(vswm_summary, b)

b1 <- aggregate(vswm_1_correct$targetscreen.RT, by= list(vswm_1_correct$Subject), mean, na.rm=TRUE)
names(b1) <- c("Subject", "vswm1_RT_mean")
vswm_1_summary <- merge(vswm_1_summary, b1)

b2 <- aggregate(vswm_2_correct$targetscreen.RT, by= list(vswm_2_correct$Subject), mean, na.rm=TRUE)
names(b2) <- c("Subject", "vswm2_RT_mean")
vswm_2_summary <- merge(vswm_2_summary, b2)


#####################################
#### Accuracies and RTs by Problem Type (TaskType)
a <- aggregate(vswm_r$targetscreen.ACC, by= list(vswm_r$Subject, vswm_r$TaskType), mean, na.rm=TRUE)
names(a) <- c("Subject", "ProblemType", "acc")
a<- spread(a, ProblemType, acc)
names(a) <- c("Subject", "vswm_acc_mean_CON3", "vswm_acc_mean_CON5", "vswm_acc_mean_STM3", "vswm_acc_mean_STM5")
vswm_summary <- merge(vswm_summary, a)

a1 <- aggregate(vswm_1$targetscreen.ACC, by= list(vswm_1$Subject, vswm_1$TaskType), mean, na.rm=TRUE)
names(a1) <- c("Subject", "ProblemType", "acc")
a1<- spread(a1, ProblemType, acc)
names(a1) <- c("Subject", "vswm1_acc_mean_CON3", "vswm1_acc_mean_CON5", "vswm1_acc_mean_STM3", "vswm1_acc_mean_STM5")
vswm_1_summary <- merge(vswm_1_summary, a1)

a2 <- aggregate(vswm_2$targetscreen.ACC, by= list(vswm_2$Subject, vswm_2$TaskType), mean, na.rm=TRUE)
names(a2) <- c("Subject", "ProblemType", "acc")
a2<- spread(a2, ProblemType, acc)
names(a2) <- c("Subject", "vswm2_acc_mean_CON3", "vswm2_acc_mean_CON5", "vswm2_acc_mean_STM3", "vswm2_acc_mean_STM5")
vswm_2_summary <- merge(vswm_2_summary, a2)

b <- aggregate(vswm_correct$targetscreen.RT, by= list(vswm_correct$Subject, vswm_correct$TaskType), mean, na.rm=TRUE)
names(b) <- c("Subject", "ProblemType", "RT")
b<- spread(b, ProblemType, RT)
names(b) <- c("Subject", "vswm_RT_mean_CON3", "vswm_RT_mean_CON5", "vswm_RT_mean_STM3", "vswm_RT_mean_STM5")
vswm_summary <- merge(vswm_summary, b)

b1 <- aggregate(vswm_1_correct$targetscreen.RT, by= list(vswm_1_correct$Subject, vswm_1_correct$TaskType), mean)
names(b1) <- c("Subject", "ProblemType", "RT")
b1<- spread(b1, ProblemType, RT)
names(b1) <- c("Subject", "vswm1_RT_mean_CON3", "vswm1_RT_mean_CON5", "vswm1_RT_mean_STM3", "vswm1_RT_mean_STM5")
vswm_1_summary <- merge(vswm_1_summary, b1)

b2 <- aggregate(vswm_2_correct$targetscreen.RT, by= list(vswm_2_correct$Subject, vswm_2_correct$TaskType), mean, na.rm=TRUE)
names(b2) <- c("Subject", "ProblemType", "RT")
b2<- spread(b2, ProblemType, RT)
names(b2) <- c("Subject", "vswm2_RT_mean_CON3", "vswm2_RT_mean_CON5", "vswm2_RT_mean_STM3", "vswm2_RT_mean_STM5")
vswm_2_summary <- merge(vswm_2_summary, b2)


####################################################
#### Count of passive errors or "errors of omission"

omission_vswm <- function(m){
  a <- length(m$targetscreen.RT[m$targetscreen.RT==0]) 
}

# create variable and add to temporary summary
omission_error_vswm <- ddply(vswm_r, .(vswm_r$Subject), .fun= omission_vswm)
names(omission_error_vswm) <- c("Subject", "omission_error_vswm")
vswm_summary <- merge(vswm_summary, omission_error_vswm)

omission_error_vswm1 <- ddply(vswm_1, .(vswm_1$Subject), .fun= omission_vswm)
names(omission_error_vswm1) <- c("Subject", "omission_error_vswm1")
vswm_1_summary <- merge(vswm_1_summary, omission_error_vswm1)

omission_error_vswm2 <- ddply(vswm_2, .(vswm_2$Subject), .fun= omission_vswm)
names(omission_error_vswm2) <- c("Subject", "omission_error_vswm2")
vswm_2_summary <- merge(vswm_2_summary, omission_error_vswm2)

##########################################################
###################    MATCHING   ########################
##########################################################


##### Create Correct-Only Sets for RT analysis
matching_correct <- subset(matching_r, task_all.ACC==1)
matching_1_correct <- subset(matching_1, task_all.ACC==1)
matching_2_correct <- subset(matching_2, task_all.ACC==1)


###############################
#### Overall Accuracies and RTs

a <- aggregate(matching_r$task_all.ACC, by= list(matching_r$Subject), mean, na.rm=TRUE)
names(a) <- c("Subject", "matching_acc_mean")
matching_summary <- merge(matching_summary, a)

a1 <- aggregate(matching_1$task_all.ACC, by= list(matching_1$Subject), mean, na.rm=TRUE)
names(a1) <- c("Subject", "matching1_acc_mean")
matching_1_summary <- merge(matching_1_summary, a1)

a2 <- aggregate(matching_2$task_all.ACC, by= list(matching_2$Subject), mean, na.rm=TRUE)
names(a2) <- c("Subject", "matching2_acc_mean")
matching_2_summary <- merge(matching_2_summary, a2)

b <- aggregate(matching_correct$task_all.RT, by= list(matching_correct$Subject), mean, na.rm=TRUE)
names(b) <- c("Subject", "matching_RT_mean")
matching_summary <- merge(matching_summary, b)

b1 <- aggregate(matching_1_correct$task_all.RT, by= list(matching_1_correct$Subject), mean, na.rm=TRUE)
names(b1) <- c("Subject", "matching1_RT_mean")
matching_1_summary <- merge(matching_1_summary, b1)

b2 <- aggregate(matching_2_correct$task_all.RT, by= list(matching_2_correct$Subject), mean, na.rm=TRUE)
names(b2) <- c("Subject", "matching2_RT_mean")
matching_2_summary <- merge(matching_2_summary, b2)

#####################################
#### Accuracies and RTs by Problem Type (TaskType)
a <- aggregate(matching_r$task_all.ACC, by= list(matching_r$Subject, matching_r$TaskType), mean, na.rm=TRUE)
names(a) <- c("Subject", "ProblemType", "acc")
a<- spread(a, ProblemType, acc)
names(a) <- c("Subject", "matching_acc_mean_face", "matching_acc_mean_number", "matching_acc_mean_shape")
matching_summary <- merge(matching_summary, a)

a1 <- aggregate(matching_1$task_all.ACC, by= list(matching_1$Subject, matching_1$TaskType), mean, na.rm=TRUE)
names(a1) <- c("Subject", "ProblemType", "acc")
a1<- spread(a1, ProblemType, acc)
names(a1) <- c("Subject", "matching1_acc_mean_face", "matching1_acc_mean_number", "matching1_acc_mean_shape")
matching_1_summary <- merge(matching_1_summary, a1)

a2 <- aggregate(matching_2$task_all.ACC, by= list(matching_2$Subject, matching_2$TaskType), mean, na.rm=TRUE)
names(a2) <- c("Subject", "ProblemType", "acc")
a2<- spread(a2, ProblemType, acc)
names(a2) <- c("Subject", "matching2_acc_mean_face", "matching2_acc_mean_number", "matching2_acc_mean_shape")
matching_2_summary <- merge(matching_2_summary, a2)

b <- aggregate(matching_correct$task_all.RT, by= list(matching_correct$Subject, matching_correct$TaskType), mean, na.rm=TRUE)
names(b) <- c("Subject", "ProblemType", "RT")
b<- spread(b, ProblemType, RT)
names(b) <- c("Subject", "matching_RT_mean_face", "matching_RT_mean_number", "matching_RT_mean_shape")
matching_summary <- merge(matching_summary, b)

b1 <- aggregate(matching_1_correct$task_all.RT, by= list(matching_1_correct$Subject, matching_1_correct$TaskType), mean, na.rm=TRUE)
names(b1) <- c("Subject", "ProblemType", "RT")
b1<- spread(b1, ProblemType, RT)
names(b1) <- c("Subject", "matching1_RT_mean_face", "matching1_RT_mean_number", "matching1_RT_mean_shape")
matching_1_summary <- merge(matching_1_summary, b1)

b2 <- aggregate(matching_2_correct$task_all.RT, by= list(matching_2_correct$Subject, matching_2_correct$TaskType), mean, na.rm=TRUE)
names(b2) <- c("Subject", "ProblemType", "RT")
b2<- spread(b2, ProblemType, RT)
names(b2) <- c("Subject", "matching2_RT_mean_face", "matching2_RT_mean_number", "matching2_RT_mean_shape")
matching_2_summary <- merge(matching_2_summary, b2)

####################################################
#### Count of passive errors or "errors of omission" or PASSIVE ERRORS

omission_matching <- function(m){
  a <- length(m$task_all.RT[m$task_all.RT==0]) 
}

# create variable and add to temporary summary
omission_error_matching <- ddply(matching_r, .(matching_r$Subject), .fun= omission_matching)
names(omission_error_matching) <- c("Subject", "omission_error_matching")
matching_summary <- merge(matching_summary, omission_error_matching)

# create variable and add to temporary summary
omission_error_matching1 <- ddply(matching_1, .(matching_1$Subject), .fun= omission_matching)
names(omission_error_matching1) <- c("Subject", "omission_error_matching1")
matching_1_summary <- merge(matching_1_summary, omission_error_matching1)

# create variable and add to temporary summary
omission_error_matching2 <- ddply(matching_2, .(matching_2$Subject), .fun= omission_matching)
names(omission_error_matching2) <- c("Subject", "omission_error_matching2")
matching_2_summary <- merge(matching_2_summary, omission_error_matching2)


####################################################
#### Accuracy and RT by Face Difficulty Level

#### Add Column about Matching Difficulty Level ####
matching_r_face <- subset(matching_r, TaskType == 'FaceMatching')
matching_1_face <- subset(matching_1, TaskType == 'FaceMatching')
matching_2_face <- subset(matching_2, TaskType == 'FaceMatching')


# Initialize face type variable
matching_r_face$FaceType <- NA
matching_1_face$FaceType <- NA
matching_2_face$FaceType <- NA

matching_r_rows<- nrow(matching_r_face)
matching_1_rows<- nrow(matching_1_face)
matching_2_rows<- nrow(matching_2_face)

for(row in 1:matching_r_rows) { 
  
  if ((matching_r_face$FaceL[row]== 'Base') & (matching_r_face$FaceR[row]== 'Small')) {matching_r_face$FaceType[row] <- 'Small'}
  if ((matching_r_face$FaceL[row]== 'Small') & (matching_r_face$FaceR[row]== 'Base')) {matching_r_face$FaceType[row] <- 'Small'}
  if ((matching_r_face$FaceL[row]== 'Base') & (matching_r_face$FaceR[row]== 'Large')) {matching_r_face$FaceType[row] <- 'Large'}
  if ((matching_r_face$FaceL[row]== 'Large') & (matching_r_face$FaceR[row]== 'Base')) {matching_r_face$FaceType[row] <- 'Large'}
  if (matching_r_face$left_stim[row]== matching_r_face$right_stim[row]) {matching_r_face$FaceType[row] <- 'Match'}
  
}

for(row in 1:matching_1_rows) { 
  
  if ((matching_1_face$FaceL[row]== 'Base') & (matching_1_face$FaceR[row]== 'Small')) {matching_1_face$FaceType[row] <- 'Small'}
  if ((matching_1_face$FaceL[row]== 'Small') & (matching_1_face$FaceR[row]== 'Base')) {matching_1_face$FaceType[row] <- 'Small'}
  if ((matching_1_face$FaceL[row]== 'Base') & (matching_1_face$FaceR[row]== 'Large')) {matching_1_face$FaceType[row] <- 'Large'}
  if ((matching_1_face$FaceL[row]== 'Large') & (matching_1_face$FaceR[row]== 'Base')) {matching_1_face$FaceType[row] <- 'Large'}
  if (matching_1_face$left_stim[row]== matching_1_face$right_stim[row]) {matching_1_face$FaceType[row] <- 'Match'}
  
}


for(row in 1:matching_2_rows) { 
  
  if ((matching_2_face$FaceL[row]== 'Base') & (matching_2_face$FaceR[row]== 'Small')) {matching_2_face$FaceType[row] <- 'Small'}
  if ((matching_2_face$FaceL[row]== 'Small') & (matching_2_face$FaceR[row]== 'Base')) {matching_2_face$FaceType[row] <- 'Small'}
  if ((matching_2_face$FaceL[row]== 'Base') & (matching_2_face$FaceR[row]== 'Large')) {matching_2_face$FaceType[row] <- 'Large'}
  if ((matching_2_face$FaceL[row]== 'Large') & (matching_2_face$FaceR[row]== 'Base')) {matching_2_face$FaceType[row] <- 'Large'}
  if (matching_2_face$left_stim[row]== matching_2_face$right_stim[row]) {matching_2_face$FaceType[row] <- 'Match'}
  
}


## Make a set that is correct only for RT of Face Type

matching_r_face_correct <- subset(matching_r_face, task_all.ACC==1)
matching_1_face_correct <- subset(matching_1_face, task_all.ACC==1)
matching_2_face_correct <- subset(matching_2_face, task_all.ACC==1)

#####################################

#### Accuracies and RTs by Problem Type (TaskType)
a <- aggregate(matching_r_face$task_all.ACC, by= list(matching_r_face$Subject, matching_r_face$FaceType), mean, na.rm=TRUE)
names(a) <- c("Subject", "FaceType", "acc")
a<- spread(a, FaceType, acc)
names(a) <- c("Subject", "matching_acc_mean_FaceLarge", "matching_acc_mean_FaceMatched", "matching_acc_mean_FaceSmall")
matching_summary <- merge(matching_summary, a)

a1 <- aggregate(matching_1_face$task_all.ACC, by= list(matching_1_face$Subject, matching_1_face$FaceType), mean, na.rm=TRUE)
names(a1) <- c("Subject", "FaceType", "acc")
a1<- spread(a1, FaceType, acc)
names(a1) <- c("Subject", "matching1_acc_mean_FaceLarge", "matching1_acc_mean_FaceMatched", "matching1_acc_mean_FaceSmall")
matching_1_summary <- merge(matching_1_summary, a1)

a2 <- aggregate(matching_2_face$task_all.ACC, by= list(matching_2_face$Subject, matching_2_face$FaceType), mean, na.rm=TRUE)
names(a2) <- c("Subject", "FaceType", "acc")
a2<- spread(a2, FaceType, acc)
names(a2) <- c("Subject", "matching2_acc_mean_FaceLarge", "matching2_acc_mean_FaceMatched", "matching2_acc_mean_FaceSmall")
matching_2_summary <- merge(matching_2_summary, a2)

b <- aggregate(matching_r_face_correct$task_all.RT, by= list(matching_r_face_correct$Subject, matching_r_face_correct$FaceType), mean, na.rm=TRUE)
names(b) <- c("Subject", "FaceType", "RT")
b<- spread(b, FaceType, RT)
names(b) <- c("Subject", "matching_RT_mean_FaceLarge", "matching_RT_mean_FaceMatched", "matching_RT_mean_FaceSmall")
matching_summary <- merge(matching_summary, b)

b1 <- aggregate(matching_1_face_correct$task_all.RT, by= list(matching_1_face_correct$Subject, matching_1_face_correct$FaceType), mean, na.rm=TRUE)
names(b1) <- c("Subject", "FaceType", "RT")
b1<- spread(b1, FaceType, RT)
names(b1) <- c("Subject", "matching1_RT_mean_FaceLarge", "matching1_RT_mean_FaceMatched", "matching1_RT_mean_FaceSmall")
matching_1_summary <- merge(matching_1_summary, b1)

b2 <- aggregate(matching_2_face_correct$task_all.RT, by= list(matching_2_face_correct$Subject, matching_2_face_correct$FaceType), mean, na.rm=TRUE)
names(b2) <- c("Subject", "FaceType", "RT")
b2<- spread(b2, FaceType, RT)
names(b2) <- c("Subject", "matching2_RT_mean_FaceLarge", "matching2_RT_mean_FaceMatched", "matching2_RT_mean_FaceSmall")
matching_2_summary <- merge(matching_2_summary, b2)


#####################
#### Write Files ####
#####################

## CHANGE THE NAME OF THE DATA FILES HERE

#### Write files to dataset
write.csv(arithmetic_summary, file = "arithmetic_summary_02_06_20.csv", row.names=FALSE)
write.csv(arithmetic_1_summary, file = "arithmetic_1_summary_02_06_20.csv", row.names=FALSE)
write.csv(arithmetic_2_summary, file = "arithmetic_2_summary_02_06_20.csv", row.names=FALSE)

write.csv(vswm_summary, file = "vswm_summary_02_06_20.csv", row.names=FALSE)
write.csv(vswm_1_summary, file = "vswm_1_summary_02_06_20.csv", row.names=FALSE)
write.csv(vswm_2_summary, file = "vswm_2_summary_02_06_20.csv", row.names=FALSE)

write.csv(matching_summary, file = "matching_summary_02_06_20.csv", row.names=FALSE)
write.csv(matching_1_summary, file = "matching_1_summary_02_06_20.csv", row.names=FALSE)
write.csv(matching_2_summary, file = "matching_2_summary_02_06_20.csv", row.names=FALSE)

## CHANGE THE VARIABLE NAMES ON THE LEFT WITH THE DATA AND THE VARIABLE ON THE RIGHT AS WELL

### MERGE ALL SUMMARY DATA
MRI_task_behaviors_02_06_20 <- merge(arithmetic_summary, arithmetic_1_summary, all = TRUE)
MRI_task_behaviors_02_06_20 <- merge(MRI_task_behaviors_02_06_20, arithmetic_2_summary, all = TRUE)
MRI_task_behaviors_02_06_20 <- merge(MRI_task_behaviors_02_06_20, vswm_summary, all = TRUE)
MRI_task_behaviors_02_06_20 <- merge(MRI_task_behaviors_02_06_20, vswm_1_summary, all = TRUE)
MRI_task_behaviors_02_06_20 <- merge(MRI_task_behaviors_02_06_20, vswm_2_summary, all = TRUE)
MRI_task_behaviors_02_06_20 <- merge(MRI_task_behaviors_02_06_20, matching_summary, all = TRUE)
MRI_task_behaviors_02_06_20 <- merge(MRI_task_behaviors_02_06_20, matching_1_summary, all = TRUE)
MRI_task_behaviors_02_06_20 <- merge(MRI_task_behaviors_02_06_20, matching_2_summary, all = TRUE)

## CHANGE THE NAME OF YOUR FINAL DATA OUTPUT FILE
write.csv(MRI_task_behaviors_02_06_20, file = "MRI_task_behaviors_02_06_20.csv", row.names=FALSE)
