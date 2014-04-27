source('functions.R')

## First check that the directory contains the data.
## By default, it is assumed that the data folder is in the currect working
## directory. You can change this if this is not the case

directory <- getwd()
data.Directory = get.Data.Directory(directory)

## character vector of the patterns we are looking for in the feature list
## For instance, we are looking for '-mean()' and '-std()'
patterns = c('-mean\\(\\)', '-std\\(\\)')

## Read the feature list from the correct file
features = get.Features.List(data.Directory)

## Read the activity labels file
activity.Names = get.Activity.Names(data.Directory)


# 01. Merge the training and test sets to create one data set.
## Collecting each group's data

data_train <- collect.Group.Data('train', data.Directory)
data_test  <- collect.Group.Data('test', data.Directory)

## Merge groups data
## It is sufficient to use rbind since both groups' data have the same format

data <- rbind(data_test, data_train)

              message('\n
                      Data from groups "train" and "test" were merged.
                     ================================================')

## Previous operations could all be done with a single command using function 
## merge.Group.Data() in 'functions.R' as
## data <- merge.Groups.Data(data.Directory)

# 02. Extracts only the measurements determined by the patterns vector above

## First get the relevent indices for the mean and the std variables
indices = get.Relevent.Indices(features, patterns, data.Directory)

## Then subset the data according to those indices
## At this stage, the extracted data should contain 3 categorical variables,
## 33 numerical variables for mean and 33 numerical variables for std
data.Extracted = extract(data, indices)


# 03. Use descriptive activity names to name the activities in the data set
# 04. Appropriately label the data set with descriptive names

data.Extracted.Labeled <- label.All.Variables(data.Extracted, activity.Names, indices)

## Write file of merged data with all the labeling to a txt file in CSV format
write.csv(data.Extracted.Labeled, './Merged_data.txt', row.names = FALSE)

# 05. Create tidy data set with the average of each variable for each activity and ## each subject

data.Extracted.Averaged <- subject.activity.average(data.Extracted.Labeled)

## create tidy set and export it to a text file in CSV format
write.Tidy.Set(data.Extracted.Averaged, indices)

