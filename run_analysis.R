fileZip <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

##library("downloader")
download(fileZip, dest= paste(getwd(), "/dataset.zip", sep = ""), mode="wb")

unzip(paste(getwd(), "/dataset.zip", sep = ""), exdir = paste(getwd(), "/dest", sep = ""))

filenames <- paste(getwd(), "/dest/UCI HAR Dataset", sep="")

dfx <- data.frame()
dfsub <- data.frame()
dfy <- data.frame()
dfmain <- data.frame()

for(i in 1:length(filenames)){
  
  if(filenames[i] == "features.txt"){
    colsubpath <- paste(getwd(),"/dest/UCI HAR Dataset/features.txt", sep="")
    col_names <- read.table(colsubpath)
    col_names_vect <- as.character(col_names[, 2])
  } else if(filenames[i] == "activity_labels.txt"){
    colactsubpath <- paste(getwd(),"/dest/UCI HAR Dataset/activity_labels.txt", sep ="")
    col_names_act <- read.table(colactsubpath)
    col_names_act_vect <- as.character(col_names_act[, 2])
  } else  if (filenames[i] == "test") {
    testFile <- paste(getwd(),"/dest/UCI HAR Dataset/test", sep="")
    for(j in 1:length(testFile)){  
      if(testFile[j] == "subject_test.txt"){
        testsubpath <- paste(getwd(),"/dest/UCI HAR Dataset/test/subject_test.txt", sep="")
        testfilessub <- read.table(testsubpath, header = TRUE)
      } else if (testFile[j] == "X_test.txt"){
        testsubpath <- paste(getwd(),"/dest/UCI HAR Dataset/test/X_test.txt"
        testfilesx <- read.table(testsubpath, header = TRUE) 
      } else if(testFile[j] == "y_test.txt"){
        testsubpath <- paste(getwd(),"/dest/UCI HAR Dataset/test/y_test.txt", sep="")
        testfilesy <- read.table(testsubpath, header = TRUE)
      }
    }
  } else if (filenames[i] == "train"){
    trainFile <- paste(getwd(),"/dest/UCI HAR Dataset/train", sep = "")
    for(z in 1:length(trainFile)){
      if(trainFile[z] == "subject_train.txt"){
        trainsubpath <- paste(getwd(),"/dest/UCI HAR Dataset/train/subject_train.txt", sep="")
        trainfilessub <- read.table(trainsubpath, header = TRUE)
      } else if (trainFile[z] == "X_train.txt"){
        trainsubpath <- paste(getwd(),"/dest/UCI HAR Dataset/train/X_train.txt", sep = "")
        trainfilesx <- read.table(trainsubpath, header = TRUE)
      } else if(trainFile[z] == "y_train.txt"){
        trainsubpath <- paste(getwd(),"/dest/UCI HAR Dataset/train/y_train.txt", sep = "")
        trainfilesy <- read.table(trainsubpath, header = TRUE)
      } 
    }
  }
  
}

names(testfilesx) <- col_names_vect

names(trainfilesx) <- col_names_vect

dfx <- rbind(trainfilesx, testfilesx)

names(testfilessub) <- "subject"

names(trainfilessub) <- "subject"

dfsub <- rbind(trainfilessub, testfilessub)

names(testfilesy) <- "activity"

names(trainfilesy) <- "activity"

dfy <- rbind(trainfilesy, testfilesy)

dfmain <- cbind(dfx, dfsub, dfy)

##mean and std for reqd cols

keep_cols <- c(grep("mean()", colnames(dfmain), fixed = TRUE), grep("std()", colnames(dfmain), fixed = TRUE), grep("subject", colnames(dfmain), fixed = TRUE), grep("activity", colnames(dfmain), fixed = TRUE))

dfmain_tidy <- dfmain[, keep_cols]

##descriptive activity names toactivity col in data set

dfmain_tidy$activity[dfmain_tidy$activity == "1"] <- "WALKING"
dfmain_tidy$activity[dfmain_tidy$activity == "2"] <- "WALKING_UPSTAIRS"
dfmain_tidy$activity[dfmain_tidy$activity == "3"] <- "WALKING_DOWNSTAIRS"
dfmain_tidy$activity[dfmain_tidy$activity == "4"] <- "SITTING"
dfmain_tidy$activity[dfmain_tidy$activity == "5"] <- "STANDING"
dfmain_tidy$activity[dfmain_tidy$activity == "6"] <- "LAYING"

##average of each variable for each activity and each subject
##library(dplyr)
##library(plyr)
  
dfmain_tidy2 <- dfmain_tidy %>% group_by(subject, activity) %>% summarise_each(funs(mean))


##write
##write.table(dfmain_tidy2, file = paste(getwd(), "/tidydataset.txt", sep = ""), append = FALSE, quote = TRUE, sep = " ", row.names = FALSE, col.names = TRUE)
