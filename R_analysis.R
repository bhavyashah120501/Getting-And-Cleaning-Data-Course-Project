if(!file.exists('dataset.zip')){
  download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",'dataset.zip')
}
unzip('dataset.zip')

X_test <- read.table("UCI HAR DataSet/test/X_test.txt")
Y_test <- read.table("UCI HAR DataSet/test/y_test.txt")
subject_test <- read.table("UCI HAR DataSet/test/subject_test.txt")
X_train <- read.table("UCI HAR DataSet/train/X_train.txt")
Y_train <- read.table("UCI HAR DataSet/train/y_train.txt")
subject_train <- read.table("UCI HAR DataSet/train/subject_train.txt")

library(dplyr)
test_dataset <- tbl_df(data.frame(subject_test,X_test,Y_test))
train_dataset<- tbl_df(data.frame(subject_train,X_train,Y_train))
View(test_dataset)
View(train_dataset)
features <- read.table("UCI HAR DataSet/features.txt")
activity <- read.table("UCI HAR DataSet/activity_labels.txt")
str(activity)
total_dataset <- rbind(test_dataset,train_dataset)
colnames(total_dataset) <- c("Subject" , features$V2 , "Activity")
total_dataset$Activity <- factor(total_dataset$Activity,labels=activity$V2)

library(stringr)

detectmean <- colnames(total_dataset)[str_detect(colnames(total_dataset),'([mean()|std()])')]
MeanStd <- select(total_dataset , detectmean)
library(reshape2)

meltedData <- melt(MeanStd , id.vars = c("Subject","Activity"))
casted <- dcast(meltedData,Subject+Activity ~ variable,fun.aggregate = mean)
write.table(casted,'final.txt')