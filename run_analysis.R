library(dplyr)

# Read the data
X_train = read.fwf("UCI HAR Dataset/train/X_train.txt", rep(16,561))
y_train = read.fwf("UCI HAR Dataset/train/y_train.txt",1)
subject_train = read.fwf("UCI HAR Dataset/train/subject_train.txt",1)

X_test = read.fwf("UCI HAR Dataset/test/X_test.txt", rep(16,561))
y_test = read.fwf("UCI HAR Dataset/test/y_test.txt",1)
subject_test = read.fwf("UCI HAR Dataset/test/subject_test.txt",1)

features = read.csv("UCI HAR Dataset/features.txt", sep=" ", header=FALSE, stringsAsFactors=FALSE)
activity_labels = read.csv("UCI HAR Dataset/activity_labels.txt", sep=" ", header=FALSE, stringsAsFactors=FALSE)

# Process training data
data_train = X_train
colnames(data_train) = features$V2
y_train_2 = merge(y_train, activity_labels, by.x="V1", by.y="V1", sort=FALSE)
data_train = cbind(data_train, activity=y_train_2$V2, subject=subject_train$V1)

# Process test data
data_test = X_test
colnames(data_test) = features$V2
y_test_2 = merge(y_test, activity_labels, by.x="V1", by.y="V1", sort=FALSE)
data_test = cbind(data_test, activity=y_test_2$V2, subject=subject_test$V1)

# Merge the training and test data
# The 'data0' dataframe contains all the original data
data0 = rbind(data_train, data_test)

# Subset the data
# The 'data1' dataframe contains only the variables with mean and std in their name,
# plus the activity and subject variables as required for the first dataset
data1 = data0[,grep("mean|std|activity|subject", colnames(data0))]

# Summarize the data
# The 'data2' dataframe contains the summarized variables as required for the 
# second dataset
data2 = data1 %>% group_by(activity,subject) %>% summarise_each(funs(mean))

# Output cleaned data
write.table(data2, "result.txt", row.name=FALSE)
