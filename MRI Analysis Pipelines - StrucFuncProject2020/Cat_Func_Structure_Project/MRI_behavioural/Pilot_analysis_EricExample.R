## Created on Feb 12th, 2020 to analyze pilot data for the Working With Numbers Project
##
## by Eric D. Wilkey

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


##########################################################
############### NUMBER COMPARISON TASK ###################
##########################################################


setwd("/Users/eric/OneDrive - The University of Western Ontario/1_WorkingWithNumbers/Working_With_Numbers_OSF/Measures/NumberComparison/data/pilot_data/all_trials")

file_list <- list.files()

for (file in file_list){
  
  # if the merged dataset doesn't exist, create it
  if (!exists("dataset")){
    dataset <- read.table(file, header=TRUE, sep=",")
  }
  
  # if the merged dataset does exist, append to it
  if (exists("dataset")){
    temp_dataset <-read.table(file, header=TRUE, sep=",")
    dataset<-rbind(dataset, temp_dataset)
    rm(temp_dataset)
  }
  
}

# move dataset to specific variable
dataset_nc <- dataset

# clear function variables
rm(dataset, temp_dataset, file, file_list)

#sort by Subject
dataset_nc <- dataset_nc[with(dataset_nc, order(dataset_nc$subject)), ]
View(dataset_nc)

# Make a simple task column
dataset_nc$task <- "number_comparison"

#save file in its their long format
setwd("/Users/eric/OneDrive - The University of Western Ontario/Data/pilot_data")
write.csv(dataset_nc, file = "number_comparison_long_02_17_20.csv", row.names=FALSE)

# compute number of subjects
nc_n <- length(unique(dataset_nc$subject))

# create dataframe for summary data
nc_summary <- data.frame(matrix(NA, nrow = nc_n, ncol = 1))

# Fill in Subject Identifier for each dataframe
names(nc_summary) <- "subject"
nc_summary$subject <- unique(dataset_nc$subject)

# get rid of practice trials
nc_main <- subset(dataset_nc, trial_type=="main")

##### Create Correct-Only Sets for RT analysis
nc_correct <- subset(nc_main, correct==1)
nc_correct$rt <- as.numeric(nc_correct$rt)

# create mean accuracy variable
acc_mean_by_subject <- nc_main %>% 
  group_by(subject) %>% 
  summarize(nc_acc_mean = mean(correct))

nc_summary <- merge(nc_summary, acc_mean_by_subject)

# create mean rt variable (correct only trials, removing outliers)

# trim trials with rt's greater than 3 SD's away from participant means
trimRT.3 <- function(m){
  sdev <- sd(m$rt)
  rt_low <- mean(m$rt) - (3*sdev)
  rt_high <- mean(m$rt) + (3*sdev)
  mean_trimmed <- mean(m$rt[m$rt < rt_high & m$rt > rt_low])
  high <- length(m$rt[m$rt >= rt_high])
  low <- length(m$rt[m$rt <= rt_low])
  return(c(mean_trimmed[[1]], low[[1]], high[[1]], rt_low[[1]], rt_high[[1]]))
  
}

mean.RT.3 <- ddply(nc_correct, .(nc_correct$subject), .fun= trimRT.3)

#### 7, 8, 9, 10 #### write to temporary summary dataframe
nc_summary$nc_meanRT_3trim <- mean.RT.3[,2]
nc_summary$nc_meanRT_3trim_lowcount <- mean.RT.3[,3]
nc_summary$nc_meanRT_3trim_highcount <- mean.RT.3[,4]
nc_summary$nc_meanRT_3trim_lowlevel <- mean.RT.3[,5]
nc_summary$nc_meanRT_3trim_highlevel <- mean.RT.3[,6]

# create invers efficiency score
nc_summary$IE <- nc_summary$meanRT_3trim/nc_summary$nc_acc_mean

# create error of omission variable

#### Count of passive errors or "errors of omission"

omission <- function(m){
  a <- length(m$rt[m$rt=='[]']) 
}

# create variable and add to temporary summary
omission_error_nc <- ddply(dataset_nc, .(dataset_nc$subject), .fun= omission)
names(omission_error_nc) <- c("subject", "nc_omission_error")
nc_summary <- merge(nc_summary, omission_error_nc)

# save summary data to file
write.csv(nc_summary, file = "nc_summary_02_17_20_pilot.csv", row.names=FALSE)

##########################################################
############### Inhibition Letters #######################
##########################################################

# clear function variables
rm(dataset, tem_dataset, file, file_list)

setwd("/Users/eric/OneDrive - The University of Western Ontario/1_WorkingWithNumbers/Working_With_Numbers_OSF/Measures/Inhibition/ModalityConflict_Letter/data/pilot_data/all_trials")

file_list <- list.files()

for (file in file_list){
  
  # if the merged dataset doesn't exist, create it
  if (!exists("dataset")){
    dataset <- read.table(file, header=TRUE, sep=",")
  }
  
  # if the merged dataset does exist, append to it
  if (exists("dataset")){
    temp_dataset <-read.table(file, header=TRUE, sep=",")
    dataset<-rbind(dataset, temp_dataset)
    rm(temp_dataset)
  }
  
}

# move dataset to specific variable
dataset_ic_l<- dataset

#sort by Subject
dataset_ic_l <- dataset_ic_l[with(dataset_ic_l, order(dataset_ic_l$subject)), ]
View(dataset_ic_l)

# Make a simple task column
dataset_ic_l$task <- "ic_letters"

#save file in its their long format
setwd("/Users/eric/OneDrive - The University of Western Ontario/Data/pilot_data")
write.csv(dataset_ic_l, file = "ic_letters_long_02_17_20.csv", row.names=FALSE)

# compute number of subjects
ic_l_n <- length(unique(dataset_ic_l$subject))

# create dataframe for summary data
ic_l_summary <- data.frame(matrix(NA, nrow = ic_l_n, ncol = 1))

# Fill in Subject Identifier for each dataframe
names(ic_l_summary) <- "subject"
ic_l_summary$subject <- unique(dataset_ic_l$subject)

# get rid of practice trials
ic_l_main <- subset(dataset_ic_l, trial_type=="main")

##### Create Correct-Only Sets for RT analysis
ic_l_correct <- subset(ic_l_main, correct==1)
ic_l_correct$rt <- as.numeric(ic_l_correct$rt)

# create mean accuracy variable
acc_mean_by_subject <- ic_l_main %>% 
  group_by(subject) %>% 
  summarize(ic_l_acc_mean = mean(correct))

ic_l_summary <- merge(ic_l_summary, acc_mean_by_subject)

# create CONgruent and INcongruent mean accuracy variable
acc_mean_by_subject_congruencysplit <- ic_l_main %>% 
  group_by(subject, congruency) %>%
  summarize(ic_l_acc_mean = mean(correct))

acc_mean_by_subject_congruencysplit<- spread(acc_mean_by_subject_congruencysplit, congruency, ic_l_acc_mean)
names(acc_mean_by_subject_congruencysplit) <- c("subject", "ic_l_acc_mean_IN", "ic_l_acc_mean_CON")

ic_l_summary <- merge(ic_l_summary, acc_mean_by_subject_congruencysplit)


# create mean rt variable (correct only trials, removing outliers)

##### Create Correct-Only Sets for RT analysis SPLIT BY CONGRUENCY
ic_l_correct_IN <- subset(ic_l_correct, congruency==0)
ic_l_correct_IN$rt <- as.numeric(ic_l_correct_IN$rt)

ic_l_correct_CON <- subset(ic_l_correct, congruency==1)
ic_l_correct_CON$rt <- as.numeric(ic_l_correct_CON$rt)


# ALL TRIALS
# trim trials with rt's greater than 3 SD's away from participant means
trimRT.3 <- function(m){
  sdev <- sd(m$rt)
  rt_low <- mean(m$rt) - (3*sdev)
  rt_high <- mean(m$rt) + (3*sdev)
  mean_trimmed <- mean(m$rt[m$rt < rt_high & m$rt > rt_low])
  high <- length(m$rt[m$rt >= rt_high])
  low <- length(m$rt[m$rt <= rt_low])
  return(c(mean_trimmed[[1]], low[[1]], high[[1]], rt_low[[1]], rt_high[[1]]))
  
}

mean.RT.3.ic <- ddply(ic_l_correct, .(ic_l_correct$subject), .fun= trimRT.3)

#### 7, 8, 9, 10 #### write to temporary summary dataframe
ic_l_summary$ic_l_meanRT_3trim <- mean.RT.3.ic[,2]
ic_l_summary$ic_l_meanRT_3trim_lowcount <- mean.RT.3.ic[,3]
ic_l_summary$ic_l_meanRT_3trim_highcount <- mean.RT.3.ic[,4]
ic_l_summary$ic_l_meanRT_3trim_lowlevel <- mean.RT.3.ic[,5]
ic_l_summary$ic_l_meanRT_3trim_highlevel <- mean.RT.3.ic[,6]


# CONGRUENT
# trim trials with rt's greater than 3 SD's away from participant means
trimRT.3 <- function(m){
  sdev <- sd(m$rt)
  rt_low <- mean(m$rt) - (3*sdev)
  rt_high <- mean(m$rt) + (3*sdev)
  mean_trimmed <- mean(m$rt[m$rt < rt_high & m$rt > rt_low])
  high <- length(m$rt[m$rt >= rt_high])
  low <- length(m$rt[m$rt <= rt_low])
  return(c(mean_trimmed[[1]], low[[1]], high[[1]], rt_low[[1]], rt_high[[1]]))
  
}

mean.RT.3.ic.CON <- ddply(ic_l_correct_CON, .(ic_l_correct_CON$subject), .fun= trimRT.3)

#### 7, 8, 9, 10 #### write to temporary summary dataframe
ic_l_summary$ic_l_meanRT_3trim_CON <- mean.RT.3.ic.CON[,2]
ic_l_summary$ic_l_meanRT_3trim_lowcount_CON <- mean.RT.3.ic.CON[,3]
ic_l_summary$ic_l_meanRT_3trim_highcount_CON <- mean.RT.3.ic.CON[,4]
ic_l_summary$ic_l_meanRT_3trim_lowlevel_CON <- mean.RT.3.ic.CON[,5]
ic_l_summary$ic_l_meanRT_3trim_highlevel_CON <- mean.RT.3.ic.CON[,6]

# INcongruent
# trim trials with rt's greater than 3 SD's away from participant means
trimRT.3 <- function(m){
  sdev <- sd(m$rt)
  rt_low <- mean(m$rt) - (3*sdev)
  rt_high <- mean(m$rt) + (3*sdev)
  mean_trimmed <- mean(m$rt[m$rt < rt_high & m$rt > rt_low])
  high <- length(m$rt[m$rt >= rt_high])
  low <- length(m$rt[m$rt <= rt_low])
  return(c(mean_trimmed[[1]], low[[1]], high[[1]], rt_low[[1]], rt_high[[1]]))
  
}

mean.RT.3.ic.IN <- ddply(ic_l_correct_IN, .(ic_l_correct_IN$subject), .fun= trimRT.3)

#### 7, 8, 9, 10 #### write to temporary summary dataframe
ic_l_summary$ic_l_meanRT_3trim_IN <- mean.RT.3.ic.IN[,2]
ic_l_summary$ic_l_meanRT_3trim_lowcount_IN <- mean.RT.3.ic.IN[,3]
ic_l_summary$ic_l_meanRT_3trim_highcount_IN <- mean.RT.3.ic.IN[,4]
ic_l_summary$ic_l_meanRT_3trim_lowlevel_IN <- mean.RT.3.ic.IN[,5]
ic_l_summary$ic_l_meanRT_3trim_highlevel_IN <- mean.RT.3.ic.IN[,6]

# create inverse efficiency score
### ALL TRIALS
ic_l_summary$IE <- ic_l_summary$ic_l_meanRT_3trim/ic_l_summary$ic_l_acc_mean

### CONGRUENT TRIALS
ic_l_summary$IE_CON <- ic_l_summary$ic_l_meanRT_3trim_CON/ic_l_summary$ic_l_acc_mean_CON

### INCONGRUENT TRIALS
# create invers efficiency score
ic_l_summary$IE_IN <- ic_l_summary$ic_l_meanRT_3trim_IN/ic_l_summary$ic_l_acc_mean_IN

# create error of omission variable

#### Count of passive errors or "errors of omission"

omission <- function(m){
  a <- length(m$rt[m$rt=='[]']) 
}


#### ERRORS OF OMISSION #####

# ALL TRIALS
# create variable and add to temporary summary
omission_error_ic_l <- ddply(dataset_ic_l, .(dataset_ic_l$subject), .fun= omission)
names(omission_error_ic_l) <- c("subject", "ic_l_omission_error")

ic_l_summary <- merge(ic_l_summary, omission_error_ic_l)

# SPLIT BY CONGRUENCY
# create variable and add to temporary summary
omission_error_ic_l_congruencysplit <- ddply(dataset_ic_l, .(dataset_ic_l$subject, dataset_ic_l$congruency), .fun= omission)
names(omission_error_ic_l_congruencysplit) <- c("subject", "congruency", "omission_error_ic_l")

omission_error_ic_l_congruencysplit <- spread(omission_error_ic_l_congruencysplit, congruency, omission_error_ic_l)
names(omission_error_ic_l_congruencysplit) <- c("subject", "ic_l_omission_error_IN", "ic_l_omission_error_CON")

ic_l_summary <- merge(ic_l_summary, omission_error_ic_l_congruencysplit)


# save summary data to file
write.csv(ic_l_summary, file = "ic_l_summary_02_17_20_pilot.csv", row.names=FALSE)



### MERGE ALL SUMMARY DATA
WWN_Pilot_2_17_20 <- nc_summary
WWN_Pilot_2_17_20 <- merge(WWN_Pilot_2_17_20, ic_l_summary, all = TRUE)


### SAVE OVERALL SUMMARY FILE
MRI_task_behaviors_02_06_20 <- merge(MRI_task_behaviors_02_06_20, arithmetic_2_summary, all = TRUE)

