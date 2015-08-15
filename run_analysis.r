##load the tables into R
activity_labels <- read.table(file="activity_labels.txt")
features <- read.table(file="features.txt")
testsub <- read.table(file="./test/subject_test.txt")
testx <- read.table(file="./test/X_test.txt")
testy <- read.table(file="./test/y_test.txt")
trainsub <- read.table(file="./train/subject_train.txt")
trainx <- read.table(file="./train/X_train.txt")
trainy <- read.table(file="./train/y_train.txt")

## add column names to the test and train "x" sets
colnames(testx) <- features$V2
colnames(trainx) <- features$V2

##get only the columns related to mean and standard deviation measures
test_names <- names(testx)
train_names <- names(trainx)
test_relevant_col_id <- c(grep("-mean()",test_names, fixed = TRUE),grep("-std()",test_names, fixed = TRUE))
train_relevant_col_id <- c(grep("-mean()",train_names, fixed = TRUE),grep("-std()",train_names, fixed = TRUE))
test_relevant_col_id <- sort(test_relevant_col_id)
train_relevant_col_id <- sort(train_relevant_col_id)
testx_ex <- testx[,test_relevant_col_id]
trainx_ex <- trainx[,train_relevant_col_id]

## get activity names vs. id for test and train "y" sets
testy <- merge(testy, activity_labels, by = "V1")
trainy <- merge(trainy, activity_labels, by = "V1")

## add column names to the test and train "y" sets
colnames(testy) <- c("activity_id","activity")
colnames(trainy) <- c("activity_id","activity")

## add column names to the test and train "subject" sets
colnames(testsub) <- "subject_id"
colnames(trainsub) <- "subject_id"

## merge the "x" and "y" sets for both train and test sets
test <- cbind(testsub, testy[-1], testx_ex)
train <- cbind(trainsub, trainy[-1], trainx_ex)

## merge the train and the test sets
base <- rbind(test, train)

###create the table with the mean for each column by subect and activity
base$subject_id <- as.factor(base$subject_id)
subject <- levels(base$subject_id)
activity <- levels(base$activity)
final <- base[NULL,]
for (i in subject){
  sub <- base[base$subject_id == i,]
  for (j in activity){
    act <-sub[sub$activity == j,]
    m<- sapply(act, mean, na.rm=TRUE)
    final <- rbind(final,m)
    final[nrow(final),1:2] <- c(i,j)
  }
}

##rename the columns
names <- names(base)
for (x in 3:length(names)) {
  names[x] <- paste("mean(",names[x],")",sep="")
}
colnames(final) <- names

##write the table for submission
write.table(final, file="final.txt", row.names = FALSE)
