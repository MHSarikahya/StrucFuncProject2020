## Created on June 18, 2020 to analyze EPrime data for the Structure Function Project
##
## by Eric, editied by Mohammed

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

setwd("/Users/Mohammed/Documents/StructureFunction/DATA/Scanner_Behavior")

# setwd("C:/Users/M/Desktop/")

###
#### CHANGE THESE PATHS FOR THE RAW DATA FILES FROM EPRIME ####
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



####Import Data when on PC
# arithmetic <- read_delim("C:/Users/M/Desktop/AnsariEricLab/Data/EPRime_data/Arithmetic_ALL_NONunicode.txt",
#                          "\t", escape_double = FALSE, na = "NULL",
#                          trim_ws = TRUE)
# 
# vswm <- read_delim("C:/Users/M/Desktop/AnsariEricLab/Data/EPRime_data/DotMatrix_ALL_NONunicode.txt",
#                    "\t", escape_double = FALSE, na = "NULL",
#                    trim_ws = TRUE)
# 
# matching <- read_delim("C:/Users/M/Desktop/AnsariEricLab/Data/EPRime_data/Matching_ALL_NONunicode.txt",
#                        "\t", escape_double = FALSE, na = "NULL",
#                        trim_ws = TRUE)




# Trim to necessary variables in respective data frames.

arithmetic_r <- subset(arithmetic, select = c(ExperimentName, Subject, Session, SessionDate, SessionTime, Block, metablock, TaskType, Trial, Answer, Condition, Correct, 
                                              CorrectResponse, DifferenceCorrect, LeftNumber, RightNumber, Verification, Problem.ACC, Problem.CRESP, 
                                              Problem.RESP, Problem.RT, run))

vswm_r<- subset(vswm, select = c(ExperimentName, Subject, Session, SessionDate, SessionTime, metablock, metablock.Sample, TaskType, Trial, answer, bloc.Cycle, 
                                 bloc.Sample, CorrectResponse, NumberOfDots, ITIs, run, targetscreen.ACC, targetscreen.RESP, targetscreen.RT))

matching_r <- subset(matching, select = c(ExperimentName, Subject, Session, SessionDate, SessionTime, Block, metablock, TaskType, Trial, CorrectResponse, 
                                          ITIs, left_stim, right_stim, task.ACC, task.RESP, task.RT, run))


############## Order all sets by Subject

#### sort by Subject
arithmetic_r <- arithmetic_r[with(arithmetic_r, order(arithmetic_r$Subject)), ]
vswm_r <- vswm_r[with(vswm_r, order(vswm_r$Subject)), ]
matching_r <- matching_r[with(matching_r, order(matching_r$Subject)), ]


# Make a simple task column
arithmetic_r$Task <- "arithmetic"
vswm_r$Task <-  "vswm"
matching_r$Task <- "matching"

#### FILTER OUT SESSIONS/RUNS/PARTICIPANTS THAT ARE NOTED TO REMOVE BY ANNA ####


#### Arithmetic ####
arithmetic_r <- arithmetic_r %>%
  filter(!(ExperimentName == "Arithmetic_Run2" & Subject == 5 & Session == 2)) %>%
  filter(!(ExperimentName == "Arithmetic_Run1" & Subject == 6 & Session == 2)) %>%
  filter(!(ExperimentName == "Arithmetic_Run2" & Subject == 9 & Session == 2)) %>%
  filter(!(Subject == 15)) %>%
  filter(!(ExperimentName == "Arithmetic_Run1" & Subject == 17 & Session == 1)) %>%
  filter(!(ExperimentName == "Arithmetic_Run2" & Subject == 23 & Session == 1)) %>%
  filter(!(ExperimentName == "Arithmetic_Run2" & Subject == 29 & Session == 1)) %>% # Removed per Anna's Motion Notes
  filter(!(ExperimentName == "Arithmetic_Run1" & Subject == 33 & SessionDate ==	"05-14-2015")) %>%   # Removed because of low accuracy, other run was better
  filter(!(ExperimentName == "Arithmetic_Run1" & Subject == 36 & Session == 1)) %>%
  filter(!(ExperimentName == "Arithmetic_Run1" & Subject == 54 & Session == 2)) %>%
  filter(!(ExperimentName == "Arithmetic_Run2" & Subject == 61 & Session == 2)) %>%
  filter(!(ExperimentName == "Arithmetic_Run2" & Subject == 62 & Session == 2))

#### Dotmatrix ####
vswm_r <- vswm_r %>%
  filter(!(ExperimentName == "DotMatrixEASY_Run1" & Subject == 3 & Session == 2)) %>%
  filter(!(Subject == 15)) %>%
  filter(!(ExperimentName == "DotMatrixEASY_Run1" & Subject == 27 & Session == 2)) %>%
  filter(!(ExperimentName == "DotMatrixEASY_Run1" & Subject == 36 & Session == 1))


#### Matching ####
matching_r <- matching_r %>%
  filter(!(Subject == 15)) %>%
  filter(!(ExperimentName == "Matching_Run1" & Subject == 19 & Session == 2)) %>%
  filter(!(ExperimentName == "Matching_Run1" & Subject == 20 & Session == 1)) %>%
  filter(!(ExperimentName == "Matching_Run1" & Subject == 52 & Session == 1))

# Make a Task column for arithmetic_all
arithmetic_r <- arithmetic_r %>% 
  mutate(label = case_when(
    .$ExperimentName %in% c("Arithmetic_Run1") ~ "Run_A",
    .$ExperimentName %in% c("Arithmetic_Run2") ~ "Run_B",
  ))


############## Save all files in their long format
# write.csv(arithmetic_r, file = "arithmetic_long_07_2_20.csv", row.names=FALSE)
# write.csv(vswm_r, file = "vswm_long_07_2_20.csv", row.names=FALSE)
# write.csv(matching_r, file = "matching_long_07_2_20.csv", row.names=FALSE)


### Create separate data frames for each run based on Experiment Name Column
arithmetic_run1 <- subset(arithmetic_r, ExperimentName=="Arithmetic_Run1")
arithmetic_run2 <- subset(arithmetic_r, ExperimentName=="Arithmetic_Run2")
arithmetic_all <- subset(arithmetic_r, Task == "arithmetic")

############ REMINDER - Calcualate behavioral data separately for each Session ##################

#### Compute number of subjects per task, per run, and for both ####
n_arithmetic_run1 <- length(unique(arithmetic_run1$Subject)) # determine your n
n_arithmetic_run2 <- length(unique(arithmetic_run2$Subject)) # determine your n
n_arithmetic_all <- length(unique(arithmetic_all$Subject)) # determine your n


####################### CREATE DATA FRAME FOR RUN-LEVEL and TASK-LEVEL SUMMARY FILES

arithmetic_run1_summary <- data.frame(matrix(NA, nrow = n_arithmetic_run1, ncol = 1))
arithmetic_run2_summary <- data.frame(matrix(NA, nrow = n_arithmetic_run2, ncol = 1))
arithmetic_all_summary <- data.frame(matrix(NA, nrow = n_arithmetic_all, ncol = 1))

# Fill in Subject Identifier for each dataframe

# the three arithmetic summary data frames
names(arithmetic_run1_summary) <- "Subject"
arithmetic_run1_summary$Subject <- unique(arithmetic_run1$Subject)

names(arithmetic_run2_summary) <- "Subject"
arithmetic_run2_summary$Subject <- unique(arithmetic_run2$Subject)

names(arithmetic_all_summary) <- "Subject"
arithmetic_all_summary$Subject <- unique(arithmetic_all$Subject)
##########################################################
######### TAKE A MOMENT TO ASSESS MISSING DATA ###########
##########################################################

# Compare full subject list for each task and not who is missing a run.

setdiff(arithmetic_run1_summary$Subject, arithmetic_run2_summary$Subject)
setdiff(arithmetic_run2_summary$Subject, arithmetic_run1_summary$Subject)

# We only have 1 usable arithemtic run for subjects 3, 9, 24, 36

###################################################################
############## WRITE SESSION DATE AND TIME TO SUMMARY DATA ########
###################################################################

# Session Time per run
a1 <- aggregate(arithmetic_run1$SessionTime, by= list(arithmetic_run1$Subject, arithmetic_run1$SessionTime, arithmetic_run1$SessionDate), unique, na.rm=TRUE)
a1 <- a1[, 1:3]
names(a1) <- c("Subject", "SessionTime_arithmetic_run1", "SessionDate_arithmetic_run1")
arithmetic_run1_summary <- merge(arithmetic_run1_summary, a1)

a2 <- aggregate(arithmetic_run2$SessionTime, by= list(arithmetic_run2$Subject, arithmetic_run2$SessionTime, arithmetic_run2$SessionDate), unique, na.rm=TRUE)
a2 <- a2[, 1:3]
names(a2) <- c("Subject", "SessionTime_arithmetic_run2", "SessionDate_arithmetic_run2")
arithmetic_run2_summary <- merge(arithmetic_run2_summary, a2)

a3 <- aggregate(arithmetic_all$SessionTime, by= list(arithmetic_all$Subject, arithmetic_all$SessionTime, arithmetic_all$SessionDate, arithmetic_all$label), unique, na.rm=TRUE)
a3 <- a3[, 1:4]
names(a3) <- c("Subject", "SessionTime_arithmetic_all", "SessionDate_arithmetic_all", "Run")
arithmetic_all_summary <- merge(arithmetic_all_summary, a3)

############################
#### Accuracies and RTs ####
############################

#arithmetic_correct <- subset(arithmetic_r, Problem.ACC==1)
arithmetic_run1_correct <- subset(arithmetic_run1, Problem.ACC==1)
arithmetic_run2_correct <- subset(arithmetic_run2, Problem.ACC==1)
arithmetic_all_correct <- subset(arithmetic_all, Problem.ACC==1)


#Accuracy  
a1 <- aggregate(arithmetic_run1$Problem.ACC, by= list(arithmetic_run1$Subject, arithmetic_run1$Session, arithmetic_run1$SessionDate), mean, na.rm=TRUE)
names(a1) <- c("Subject", "Session_arithmetic_run1", "SessionDate_arithmetic_run1", "arithmetic_run1_acc_mean")
arithmetic_run1_summary <- merge(arithmetic_run1_summary, a1)

a2 <- aggregate(arithmetic_run2$Problem.ACC, by= list(arithmetic_run2$Subject, arithmetic_run2$Session, arithmetic_run2$SessionDate), mean, na.rm=TRUE)
names(a2) <- c("Subject", "Session_arithmetic_run2", "SessionDate_arithmetic_run2", "arithmetic_run2_acc_mean")
arithmetic_run2_summary <- merge(arithmetic_run2_summary, a2)

a3 <- aggregate(arithmetic_all$Problem.ACC, by= list(arithmetic_all$Subject, arithmetic_all$Session, arithmetic_all$SessionDate, arithmetic_all$label), mean, na.rm=TRUE)
names(a3) <- c("Subject", "Session_arithmetic_all", "SessionDate_arithmetic_all",  "Run", "arithmetic_all_acc_mean")
arithmetic_all_summary <- merge(arithmetic_all_summary, a3)
  # since Arithmetic All is both Arithmetic Run 1 and Arithmetic Run 2, it adds both as "seperate" runs

#RT
a1 <- aggregate(arithmetic_run1_correct$Problem.RT, by= list(arithmetic_run1_correct$Subject, arithmetic_run1_correct$Session, arithmetic_run1_correct$SessionDate), mean, na.rm=TRUE)
names(a1) <- c("Subject", "Session_arithmetic_run1", "SessionDate_arithmetic_run1", "arithmetic_run1_RT_mean")
arithmetic_run1_summary <- merge(arithmetic_run1_summary, a1)

a2 <- aggregate(arithmetic_run2_correct$Problem.RT, by= list(arithmetic_run2_correct$Subject, arithmetic_run2_correct$Session, arithmetic_run2_correct$SessionDate), mean, na.rm=TRUE)
names(a2) <- c("Subject", "Session_arithmetic_run2", "SessionDate_arithmetic_run2", "arithmetic_run2_RT_mean")
arithmetic_run2_summary <- merge(arithmetic_run2_summary, a2)

a3 <- aggregate(arithmetic_all_correct$Problem.RT, by= list(arithmetic_all_correct$Subject, arithmetic_all_correct$Session, arithmetic_all_correct$SessionDate, arithmetic_all_correct$label), mean, na.rm=TRUE)
names(a3) <- c("Subject", "Session_arithmetic_all", "SessionDate_arithmetic_all", "Run", "arithmetic_all_RT_mean")
arithmetic_all_summary <- merge(arithmetic_all_summary, a3)

#### sort by Subject
arithmetic_run1_summary <- arithmetic_run1_summary[with(arithmetic_run1_summary, order(arithmetic_run1_summary$Subject)), ]
arithmetic_run2_summary <- arithmetic_run2_summary[with(arithmetic_run2_summary, order(arithmetic_run2_summary$Subject)), ]
arithmetic_all_summary <- arithmetic_all_summary[with(arithmetic_all_summary, order(arithmetic_all_summary$Subject)), ]

#####################################
#### Accuracies and RTs by Problem Type (TaskType variable), by run

## Accuracy
a1 <- aggregate(arithmetic_run1$Problem.ACC, by= list(arithmetic_run1$Subject, arithmetic_run1$TaskType, arithmetic_run1$Session, arithmetic_run1$SessionDate), mean, na.rm=TRUE)
names(a1) <- c("Subject", "ProblemType", "Session_arithmetic_run1", "SessionDate_arithmetic_run1", "acc")
a1<- spread(a1, ProblemType, acc)
names(a1) <- c("Subject", "Session_arithmetic_run1", "SessionDate_arithmetic_run1", "arithmetic1_acc_mean_large", "arithmetic1_acc_mean_plus1", "arithmetic1_acc_mean_small")
arithmetic_run1_summary <- merge(arithmetic_run1_summary, a1)

a2 <- aggregate(arithmetic_run2$Problem.ACC, by= list(arithmetic_run2$Subject, arithmetic_run2$TaskType, arithmetic_run2$Session, arithmetic_run2$SessionDate), mean, na.rm=TRUE)
names(a2) <- c("Subject", "ProblemType", "Session_arithmetic_run2", "SessionDate_arithmetic_run2", "acc")
a2<- spread(a2, ProblemType, acc)
names(a2) <- c("Subject", "Session_arithmetic_run2", "SessionDate_arithmetic_run2", "arithmetic2_acc_mean_large", "arithmetic2_acc_mean_plus1", "arithmetic2_acc_mean_small")
arithmetic_run2_summary <- merge(arithmetic_run2_summary, a2)

a3 <- aggregate(arithmetic_all$Problem.ACC, by= list(arithmetic_all$Subject, arithmetic_all$TaskType, arithmetic_all$Session, arithmetic_all$SessionDate, arithmetic_all$label), mean, na.rm=TRUE)
names(a3) <- c("Subject", "ProblemType", "Session_arithmetic_all", "SessionDate_arithmetic_all", "Run", "acc")
a3<- spread(a3, ProblemType, acc)
names(a3) <- c("Subject", "Session_arithmetic_all", "SessionDate_arithmetic_all", "Run", "arithmetic_all_acc_mean_large", "arithmetic_all_acc_mean_plus1", "arithmetic_all_acc_mean_small")
arithmetic_all_summary <- merge(arithmetic_all_summary, a3)

## RT
b1 <- aggregate(arithmetic_run1_correct$Problem.RT, by= list(arithmetic_run1_correct$Subject, arithmetic_run1_correct$TaskType, arithmetic_run1_correct$Session, arithmetic_run1_correct$SessionDate), mean, na.rm=TRUE)
names(b1) <- c("Subject", "ProblemType", "Session_arithmetic_run1", "SessionDate_arithmetic_run1", "RT")
b1<- (spread(b1, ProblemType, RT))
names(b1) <- c("Subject", "Session_arithmetic_run1", "SessionDate_arithmetic_run1", "arithmetic1_RT_mean_large", "arithmetic1_RT_mean_plus1", "arithmetic1_RT_mean_small")
arithmetic_run1_summary <- merge(arithmetic_run1_summary, b1)

b2 <- aggregate(arithmetic_run2_correct$Problem.RT, by= list(arithmetic_run2_correct$Subject, arithmetic_run2_correct$TaskType, arithmetic_run2_correct$Session, arithmetic_run2_correct$SessionDate), mean, na.rm=TRUE)
names(b2) <- c("Subject", "ProblemType", "Session_arithmetic_run1", "SessionDate_arithmetic_run2", "RT")
b2<- spread(b2, ProblemType, RT)
names(b2) <- c("Subject", "Session_arithmetic_run2", "SessionDate_arithmetic_run2", "arithmetic2_RT_mean_large", "arithmetic2_RT_mean_plus1", "arithmetic2_RT_mean_small")
arithmetic_run2_summary <- merge(arithmetic_run2_summary, b2)

b3 <- aggregate(arithmetic_all_correct$Problem.RT, by= list(arithmetic_all_correct$Subject, arithmetic_all_correct$TaskType, arithmetic_all_correct$Session, arithmetic_all_correct$SessionDate,  arithmetic_all_correct$label), mean, na.rm=TRUE)
names(b3) <- c("Subject", "ProblemType", "Session_arithmetic_all", "SessionDate_arithmetic_all", "Run", "RT")
b3<- spread(b3, ProblemType, RT)
names(b3) <- c("Subject", "Session_arithmetic_all", "SessionDate_arithmetic_all", "Run", "arithmetic_all_RT_mean_large", "arithmetic_all_RT_mean_plus1", "arithmetic_all_RT_mean_small")
arithmetic_all_summary <- merge(arithmetic_all_summary, b3)


####################################################
#### Count of passive errors or "errors of omission"

omission_arithmetic <- function(m){
  a <- length(m$Problem.RT[m$Problem.RT==0]) 
}

# create variable and add to temporary summary

omission_error_arithmetic1 <- ddply(arithmetic_run1, .(arithmetic_run1$Subject, arithmetic_run1$Session, arithmetic_run1$SessionDate), .fun= omission_arithmetic)
names(omission_error_arithmetic1) <- c("Subject", "Session_arithmetic_run1", "SessionDate_arithmetic_run1", "omission_error_arithmetic1")
arithmetic_run1_summary <- merge(arithmetic_run1_summary, omission_error_arithmetic1)

omission_error_arithmetic2 <- ddply(arithmetic_run2, .(arithmetic_run2$Subject, arithmetic_run2$Session, arithmetic_run2$SessionDate), .fun= omission_arithmetic)
names(omission_error_arithmetic2) <- c("Subject", "Session_arithmetic_run2","SessionDate_arithmetic_run2", "omission_error_arithmetic2")
arithmetic_run2_summary <- merge(arithmetic_run2_summary, omission_error_arithmetic2)

omission_error_arithmetic_all <- ddply(arithmetic_all, .(arithmetic_all$Subject, arithmetic_all$Session, arithmetic_all$SessionDate,arithmetic_all$label), .fun= omission_arithmetic)
names(omission_error_arithmetic_all) <- c("Subject", "Session_arithmetic_all","SessionDate_arithmetic_all", "Run", "omission_error_arithmetic_all")
arithmetic_all_summary <- merge(arithmetic_all_summary, omission_error_arithmetic_all)

####### Count trial numbers

#Accuracy
count_1 <- arithmetic_run1 %>%
  group_by(Subject, Session, SessionDate) %>%
  summarize(arithmetic_run1_count = length(Problem.ACC))
names(count_1) <- c("Subject", "Session_arithmetic_run1", "SessionDate_arithmetic_run1", "arithmetic_run1_count")   #had to add this, it was throwing off the coloums
arithmetic_run1_summary<- merge(arithmetic_run1_summary, count_1)

count_2 <- arithmetic_run2 %>%
  group_by(Subject, Session, SessionDate) %>%
  summarize(arithmetic_run2_count = length(Problem.ACC))
names(count_2) <- c("Subject", "Session_arithmetic_run2", "SessionDate_arithmetic_run2", "arithmetic_run2_count")   #had to add this, it was throwing off the coloums
arithmetic_run2_summary<- merge(arithmetic_run2_summary, count_2)

count_all <- arithmetic_all %>%
  group_by(Subject, Session, SessionDate, label) %>%
  summarize(arithmetic_all_count = length(Problem.ACC))
names(count_all) <- c("Subject", "Session_arithmetic_all", "SessionDate_arithmetic_all", "Run", "arithmetic_all_count")   #had to add this, it was throwing off the coloums
arithmetic_all_summary<- merge(arithmetic_all_summary, count_all)

count_1_by_trialtype <- arithmetic_run1 %>%
  group_by(Subject, Session, SessionDate, TaskType) %>%
  summarize(arithmetic_run1_count_pt = length(Problem.ACC))
count_1_by_trialtype <- spread(count_1_by_trialtype, TaskType, arithmetic_run1_count_pt)
names(count_1_by_trialtype) <- c("Subject", "Session_arithmetic_run1", "SessionDate_arithmetic_run1", "arithmetic1_large_count", "arithmetic1_plus1_count", "arithmetic1_small_count")
arithmetic_run1_summary<- merge(arithmetic_run1_summary, count_1_by_trialtype)

count_2_by_trialtype <- arithmetic_run2 %>%
  group_by(Subject, Session, SessionDate, TaskType) %>%
  summarize(arithmetic_run2_count_pt = length(Problem.ACC))
count_2_by_trialtype <- spread(count_2_by_trialtype, TaskType, arithmetic_run2_count_pt)
names(count_2_by_trialtype) <- c("Subject", "Session_arithmetic_run2", "SessionDate_arithmetic_run2", "arithmetic2_large_count", "arithmetic2_plus1_count", "arithmetic2_small_count")
arithmetic_run2_summary<- merge(arithmetic_run2_summary, count_2_by_trialtype)

count_all_by_trialtype <- arithmetic_all %>%
  group_by(Subject, Session, SessionDate, TaskType, label) %>%
  summarize(arithmetic_all_count_pt = length(Problem.ACC))
count_all_by_trialtype <- spread(count_all_by_trialtype, TaskType, arithmetic_all_count_pt)
names(count_all_by_trialtype) <- c("Subject", "Session_arithmetic_all", "SessionDate_arithmetic_all", "Run", "arithmetic_all_large_count", "arithmetic_all_plus1_count", "arithmetic_all_small_count")
arithmetic_all_summary<- merge(arithmetic_all_summary, count_all_by_trialtype)


#### sort by Subject
arithmetic_run1_summary <- arithmetic_run1_summary[with(arithmetic_run1_summary, order(arithmetic_run1_summary$Subject)), ]
arithmetic_run2_summary <- arithmetic_run2_summary[with(arithmetic_run2_summary, order(arithmetic_run2_summary$Subject)), ]
arithmetic_all_summary <- arithmetic_all_summary[with(arithmetic_all_summary, order(arithmetic_all_summary$Subject)), ]


#### Seperate by Run A/B
arithmetic_all_summary <- arithmetic_all_summary %>%
pivot_wider(names_from = "Run", values_from = c( "SessionDate_arithmetic_all", "Session_arithmetic_all", "SessionTime_arithmetic_all", "arithmetic_all_acc_mean", "arithmetic_all_RT_mean", "arithmetic_all_acc_mean_large", "arithmetic_all_acc_mean_plus1", "arithmetic_all_acc_mean_small", "arithmetic_all_RT_mean_large",  "arithmetic_all_RT_mean_plus1",
                                                 "arithmetic_all_RT_mean_small", "omission_error_arithmetic_all", "arithmetic_all_count", "arithmetic_all_large_count", "arithmetic_all_plus1_count", "arithmetic_all_small_count"
                                                ))
                                              

##########################################################
############# Visuo-spatial Working Memory  ##############
##########################################################

# Determine the n
n_vswm <- length(unique(vswm_r$Subject)) # determine your n

# Create data frame
vswm_summary <- data.frame(matrix(NA, nrow = n_vswm, ncol = 1))

# summary data frames
names(vswm_summary) <- "Subject"
vswm_summary$Subject <- unique(vswm_r$Subject)

# Write Session Date and Time to Summary Data Frame
b <- aggregate(vswm_r$SessionTime, by= list(vswm_r$Subject, vswm_r$Session, vswm_r$SessionDate, vswm_r$SessionTime), unique, na.rm=TRUE)
b <- b[, 1:4]
names(b) <- c("Subject", "Session_vswm", "SessionDate_vswm", "SessionTime_vswm")
vswm_summary <- merge(vswm_summary, b)

##### Create Correct-Only Sets for RT analysis
vswm_correct <- subset(vswm_r, targetscreen.ACC==1)

###############################
#### Overall Accuracies and RTs

# DECIDE WHICH SESSION TO USE BY CROSS-REFERENCING ACCURACY RATE AND MOVEMENT DATA
#   SUBJECT 58 Session 1 = 23.9% outliers, Session 2 = 13.7% outliers; both high accuracy; use session 2
#   SUBJECT 59 Session 1 = 4.3% outliers, Session 2 = 1.7% outliers; both high accuracy; use session 2 because lower movement
#   SUBJECT 63 Session 1 = 16.2% outliers, Session 2 = 7.7% outliers; both low accuracy; use session 2 because lower movement and higher accuracy

## Accuracy
vswm_acc <- vswm_r %>%
  filter(!(Subject == 58 & Session == 1)) %>%
  filter(!(Subject == 59 & Session == 1)) %>%
  filter(!(Subject == 63 & Session == 1)) %>%
  group_by(Subject, Session, SessionDate, SessionTime) %>%
  summarize(vswm_acc_mean = mean(targetscreen.ACC), vswm_count= length(targetscreen.ACC))
names(vswm_acc) <- c("Subject", "Session_vswm", "SessionDate_vswm", "SessionTime_vswm", "vswm_acc_mean", "vswm_count")

vswm_summary <- merge(vswm_summary, vswm_acc)
vswm_summary <- vswm_summary[with(vswm_summary, order(vswm_summary$Subject)), ]

## Reaction Time
vswm_RT <- vswm_correct %>%
  filter(!(Subject == 58 & Session == 1)) %>%
  filter(!(Subject == 59 & Session == 1)) %>%
  filter(!(Subject == 63 & Session == 1)) %>%
  group_by(Subject, Session, SessionDate, SessionTime) %>%
  summarize(vswm_RT_correct_mean = mean(targetscreen.RT))
names(vswm_RT) <- c("Subject", "Session_vswm", "SessionDate_vswm", "SessionTime_vswm", "vswm_RT_correct_mean")

vswm_summary <- merge(vswm_summary, vswm_RT)
vswm_summary <- vswm_summary[with(vswm_summary, order(vswm_summary$Subject)), ]


#### Accuracies and RTs by Problem Type (TaskType)

## Accuracy
vswm_problemtype_acc <- vswm_r %>%
  filter(!(Subject == 58 & Session == 1)) %>%
  filter(!(Subject == 59 & Session == 1)) %>%
  filter(!(Subject == 63 & Session == 1)) %>%
  group_by(Subject, Session, SessionDate, SessionTime, TaskType) %>%
  summarize(vswm_acc_mean = mean(targetscreen.ACC))
vswm_problemtype_acc<- spread(vswm_problemtype_acc, TaskType, vswm_acc_mean)
names(vswm_problemtype_acc) <- c("Subject", "Session_vswm", "SessionDate_vswm", "SessionTime_vswm", "vswm_acc_mean_CON2", "vswm_acc_mean_CON4", "vswm_acc_mean_STM2", "vswm_acc_mean_STM4")

vswm_summary <- merge(vswm_summary, vswm_problemtype_acc)
vswm_summary <- vswm_summary[with(vswm_summary, order(vswm_summary$Subject)), ]


## Reaction Time
vswm_problemtype_RT <- vswm_correct %>%
  filter(!(Subject == 58 & Session == 1)) %>%
  filter(!(Subject == 59 & Session == 1)) %>%
  filter(!(Subject == 63 & Session == 1)) %>%
  group_by(Subject, Session, SessionDate, SessionTime, TaskType) %>%
  summarize(vswm_RT_mean = mean(targetscreen.RT))
vswm_problemtype_RT<- spread(vswm_problemtype_RT, TaskType, vswm_RT_mean)
names(vswm_problemtype_RT) <- c("Subject", "Session_vswm", "SessionDate_vswm", "SessionTime_vswm", "vswm_RT_mean_CON2", "vswm_RT_mean_CON4", "vswm_RT_mean_STM2", "vswm_RT_mean_STM4")

vswm_summary <- merge(vswm_summary, vswm_problemtype_RT)
vswm_summary <- vswm_summary[with(vswm_summary, order(vswm_summary$Subject)), ]


#### Count of passive errors or "errors of omission"

omission_vswm <- function(m){
  a <- length(m$targetscreen.RT[m$targetscreen.RT==0]) 
}

# create variable and add to temporary summary
omission_error_vswm <- ddply(vswm_r, .(vswm_r$Subject, vswm_r$Session, vswm_r$SessionDate, vswm_r$SessionTime), .fun= omission_vswm)
names(omission_error_vswm) <- c("Subject", "Session_vswm","SessionDate_vswm", "SessionTime_vswm", "omission_error_vswm")
vswm_summary <- merge(vswm_summary, omission_error_vswm)



###### Count trial numbers by trial type

count_vswm_by_trialtype <- vswm_r %>%
  group_by(Subject, Session, SessionDate, SessionTime, TaskType) %>%
  summarize(vswm_count_ts = length(targetscreen.ACC))
count_vswm_by_trialtype <- spread(count_vswm_by_trialtype, TaskType, vswm_count_ts)
names(count_vswm_by_trialtype) <- c("Subject", "Session_vswm", "SessionDate_vswm", "SessionTime_vswm", "vswm_RT_mean_CON2_count", "vswm_RT_mean_CON4_count", "vswm_RT_mean_STM2_count", "vswm_RT_mean_STM4_count")

vswm_summary<- merge(vswm_summary, count_vswm_by_trialtype)
vswm_summary <- vswm_summary[with(vswm_summary, order(vswm_summary$Subject)), ]


##########################################################
###################    MATCHING   ########################
##########################################################
# DECIDE WHICH SESSION TO USE BY CROSS-REFERENCING ACCURACY RATE AND MOVEMENT DATA
#   SUBJECT 53 Session 1 = 12.1% outliers, Session 2 = 17.2% outliers; both good accuracy; use session 2 since higher accuracy

# Determine the n
n_matching <- length(unique(matching_r$Subject)) # determine your n

# Create data frame
matching_summary <- data.frame(matrix(NA, nrow = n_matching, ncol = 1))


# matching data frames
names(matching_summary) <- "Subject"
matching_summary$Subject <- unique(matching_r$Subject)

c <- aggregate(matching_r$SessionTime, by= list(matching_r$Subject, matching_r$SessionTime, matching_r$SessionDate), unique, na.rm=TRUE)
c <- c[, 1:3]
names(c) <- c("Subject", "SessionTime_matching", "SessionDate_matching")
matching_summary <- merge(matching_summary, c)

matching_summary <- matching_summary[with(matching_summary, order(matching_summary$Subject)), ]


##### Create Correct-Only Sets for RT analysis
matching_correct <- subset(matching_r, task.ACC==1)  #change task_all to task.ACC

###############################
#### Overall Accuracies and RTs


## Accuracy
matching_acc <- matching_r %>%
  filter(!(Subject == 53 & Session == 1)) %>%
  group_by(Subject, Session, SessionDate, SessionTime) %>%
  summarize(matching_acc_mean = mean(task.ACC), matching_count = length(task.ACC))
names(matching_acc) <- c("Subject", "Session_matching", "SessionDate_matching", "SessionTime_matching", "matching_acc_mean", "matching_count_acc")
matching_summary <- merge(matching_summary, matching_acc)

matching_summary <- matching_summary[with(matching_summary, order(matching_summary$Subject)), ]


## Reaction Time

matching_RT <- matching_correct %>%
  filter(!(Subject == 53 & Session == 1)) %>%
  group_by(Subject, Session, SessionDate, SessionTime) %>%
  summarize(matching_RT_mean = mean(task.RT))
names(matching_RT) <- c("Subject", "Session_matching", "SessionDate_matching", "SessionTime_matching", "matching_RT_mean")
matching_summary <- merge(matching_summary, matching_RT)

matching_summary <- matching_summary[with(matching_summary, order(matching_summary$Subject)), ]

#####################################
#### Accuracies and RTs by Problem Type (TaskType)

## Accuracy
matching_PT_acc <- matching_r %>%
  filter(!(Subject == 53 & Session == 1)) %>%
  group_by(Subject, Session, SessionDate, SessionTime, TaskType) %>%
  summarize(matching_acc_mean = mean(task.ACC))
matching_PT_acc<- spread(matching_PT_acc, TaskType, matching_acc_mean)
names(matching_PT_acc) <- c("Subject", "Session_matching", "SessionDate_matching", "SessionTime_matching", "matching_acc_mean_number", "matching_acc_mean_shape")
matching_summary <- merge(matching_summary, matching_PT_acc)

matching_summary <- matching_summary[with(matching_summary, order(matching_summary$Subject)), ]



## Reaction Time
matching_PT_RT <- matching_correct %>%
  filter(!(Subject == 53 & Session == 1)) %>%
  group_by(Subject, Session, SessionDate, SessionTime, TaskType) %>%
  summarize(matching_PT_RT_mean = mean(task.RT))
matching_PT_RT<- spread(matching_PT_RT, TaskType, matching_PT_RT_mean)
names(matching_PT_RT) <- c("Subject", "Session_matching", "SessionDate_matching", "SessionTime_matching", "matching_RT_mean_number", "matching_RT_mean_shape")
matching_summary <- merge(matching_summary, matching_PT_RT)

matching_summary <- matching_summary[with(matching_summary, order(matching_summary$Subject)), ]


####################################################
#### Count of passive errors or "errors of omission" or PASSIVE ERRORS

omission_matching <- function(m){
  a <- length(m$task.RT[m$task.RT==0]) 
}

# create variable and add to temporary summary
omission_error_for_matching <- ddply(matching_r, .(matching_r$Subject, matching_r$Session, matching_r$SessionDate), .fun= omission_matching)
names(omission_error_for_matching) <- c("Subject", "Session_matching", "SessionDate_matching", "omission_error_matching")
matching_summary <- merge(matching_summary, omission_error_for_matching)


###### Count trial numbers

#Accuracy

count_matching_by_trialtype <- matching_r %>%
  group_by(Subject, Session, SessionDate, TaskType) %>%
  summarize(matching_count_ts = length(task.ACC))
count_matching_by_trialtype <- spread(count_matching_by_trialtype, TaskType, matching_count_ts)
names(count_matching_by_trialtype) <- c("Subject", "Session_matching", "SessionDate_matching", "NumberMatching_count", "ShapeMatching_count")
matching_summary<- merge(matching_summary, count_matching_by_trialtype)


# Sort Subjects

vswm_summary <- vswm_summary[with(vswm_summary, order(vswm_summary$Subject)), ]
matching_summary <- matching_summary[with(matching_summary, order(matching_summary$Subject)), ]



#####################
#### Write Files ####
#####################

## CHANGE THE NAME OF THE DATA FILES HERE

#### Write files to dataset
write.csv(arithmetic_run1_summary, file = "arithmetic_run1_summary_07_2_20.csv", row.names=FALSE)
write.csv(arithmetic_run2_summary, file = "arithmetic_run2_summary_07_2_20.csv", row.names=FALSE)
write.csv(arithmetic_all_summary, file = "arithmetic_all_summary_07_2_20.csv", row.names=FALSE)

write.csv(vswm_summary, file = "vswm_summary_07_2_20.csv", row.names=FALSE)

write.csv(matching_summary, file = "matching_summary_07_2_20.csv", row.names=FALSE)

## CHANGE THE VARIABLE NAMES ON THE LEFT WITH THE DATA AND THE VARIABLE ON THE RIGHT AS WELL

# ### MERGE ALL SUMMARY DATA
SF_MRI_task_behaviors_07_2_20 <- merge(arithmetic_run1_summary, arithmetic_run2_summary, all = TRUE)

SF_MRI_task_behaviors_07_2_20 <- merge(SF_MRI_task_behaviors_07_2_20, arithmetic_all_summary, all = TRUE)

SF_MRI_task_behaviors_07_2_20 <- merge(SF_MRI_task_behaviors_07_2_20 , vswm_summary, all = TRUE)

SF_MRI_task_behaviors_07_2_20  <- merge(SF_MRI_task_behaviors_07_2_20 , matching_summary, all = TRUE)

# ## CHANGE THE NAME OF YOUR FINAL DATA OUTPUT FILE
write.csv(SF_MRI_task_behaviors_07_2_20 , file = "SF_MRI_task_behaviors_07_2_20.csv", row.names=FALSE)
