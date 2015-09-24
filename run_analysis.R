library(plyr)
library(reshape2)

activity_labels <- read.table("activity_labels.txt", header = FALSE)
names(activity_labels) <- c("activity_id", "activity")

features <- read.table("features.txt", header = FALSE)
names(features) <- c("feature_id", "feature")

setwd("train")

#identifies which subject it is
subject_train <- read.table("subject_train.txt", header = FALSE)
names(subject_train) <- c("subject")

#Each Column is a feature (561 of them)
x_train <- read.table("X_train.txt", header = FALSE)


#Identifies which activity it is
y_train <- read.table("Y_train.txt", header = FALSE)
names(y_train) <- c("activity_id")

train_activity <- join(y_train, activity_labels)

setwd("..")
setwd("test")

#identifies which subject it is
subject_test <- read.table("subject_test.txt", header = FALSE)
names(subject_test) <- c("subject")

#Each Column is a feature (561 of them)
x_test <- read.table("X_test.txt", header = FALSE)


#Identifies which activity it is
y_test <- read.table("Y_test.txt", header = FALSE)
names(y_test) <- c("activity_id")

test_activity <- join(y_test, activity_labels)


y_test <- NULL
y_train <- NULL
activity_labels <- NULL

train_activity_neat <- train_activity[,2]
test_activity_neat <- test_activity[,2]

train_merge <- cbind(subject_train, train_activity_neat, x_train)
test_merge <- cbind(subject_test, test_activity_neat, x_test)

test_col <- rep("Test", 2947)
test_col_df <- data.frame(test_col)
train_col <- rep("Train", 7352)
train_col_df <- data.frame(train_col)

test_merge <- cbind(test_col_df, test_merge)
train_merge <- cbind(train_col_df, train_merge)

#This section sets up and organizes the column names
features2 <- transform(features, feature = as.character(feature))
feature_names <- features2[["feature"]]
first_names <- c("test/train", "subject", "activity")
all_names <- c(first_names, feature_names)
names(train_merge) <- all_names
names(test_merge) <- all_names

tt_merge <- rbind(test_merge, train_merge)


filtered_names <- c()
for (i in all_names) {
        if(grepl("mean()", i) | grepl("std()", i)) {
                filtered_names <- c(filtered_names, i)
        }
}

applied_names <- c(first_names, filtered_names)



tt_merge_filtered <- tt_merge[applied_names]

tidydata <- ddply(tt_merge_filtered,.(subject,activity), numcolwise(mean))

write.table(tidydata, file = "tidydata.txt", row.names = FALSE)
