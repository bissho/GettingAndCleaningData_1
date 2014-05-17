# First assigment for course "Getting and Cleaning Data"

#1. Merges the training and the test sets to create one data set.
dataTest=read.table("./UCI HAR Dataset/test/X_test.txt", sep="", header=F,strip.white=T,fill=T)
activityTest=read.table("./UCI HAR Dataset/test/y_test.txt", sep="", header=F,strip.white=T,fill=T)
dataTrain=read.table("./UCI HAR Dataset/train/X_train.txt", sep="", header=F)
activityTrain=read.table("./UCI HAR Dataset/train/y_train.txt", sep="", header=F)
dataLabels=read.table("./UCI HAR Dataset/features.txt", sep="", header=F)
dataAll=rbind(dataTest,dataTrain)
names(dataAll)=dataLabels[,2]
activityAll=c(activityTest[,1],activityTrain[,1])

#2. Extracts only the measurements on the mean and standard deviation for each measurement. 
indexes=grep(names(dataAll),pattern=".*mean.*")
indexes=c(indexes,grep(names(dataAll),pattern=".*std.*"))
indexes=sort(indexes)
dataAll=dataAll[,indexes]
#Add activity
dataAll$activity=activityAll

#length(indexes)
#dim(dataAll)

#3. Uses descriptive activity names to name the activities in the data set
#done in previous steps

#4. Appropriately labels the data set with descriptive activity names. 
activityLabels=read.table("./UCI HAR Dataset/activity_labels.txt", sep="", header=F,strip.white=T,fill=T)
dataAll$activity=activityLabels[dataAll$activity,2]

#5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
#str(dataAll$activity)
dataAll2=data.frame(activity=levels(dataAll$activity))
#dim(dataAll)
for (i in 1:(dim(dataAll)[2]-1)) {
  name=names(dataAll)[i]
  dataAll2[,name]=tapply(dataAll[,1],dataAll$activity,mean,simplify=T)
}
write.table(dataAll2,file="./tidyDataSet.txt",sep=" ")
dataAll2