Code book
=========

This code book describes the raw data and the final tidy set obtained by using the main script `run_analysis.R`

It is organised as follows

+ Introduction on the experiment and origin of the data
+ Structure of the raw data
       * test
+ Structure of the tidy data

### Introduction on the experiment and origin of the data
The experiment is a study of how the signals of the acceloerometer and gyroscope embedded in a smartphone (Samsung Galaxy S II)  can help to recognize the kind of activity a person is doing. This can be of crucial help for companies like Fitbit and Nike who develop wearable devices with advanced algorithms.

The experiment has been carried with 30 subjects doing 6 different activities (laying, sitting, standing, walking, walking downstairs, walking upstairs). The obtained dataset has been randomly partitioned into two groups: the *training* group with 70% of the subjects and the *test* group with 30% of the subjects.

### Structure of the raw data

The raw data have been obtained [from here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip )

The unzipped folder contains two directories, one for each of the groups (training and test), as well 4 text files:

+ activity_label.txt: contains the integer code used for each activity.
       
+ features_info.txt: contains the integer code for the sigals measured during the experiment and the variables derived from those signals.
       
+ features.txt: contains the integer code for each of the variables defined in the previous file.
       
+ README.txt: contains information about the content of the data folder. Refer to this file for more detailed information.

Each group folder contains a folder of the raw *Inertial signals* and 3 files:

+ A file for the subjects identifiers

+ A file for activities codes during the experiment

+ A file for all 561 features (see below) obtained from the experiment
       

We can classify the raw data, i.e. the data contained in the unzipped folder before any analysis, into two sets:

+ **Set 1 : signals**

       This set contains the raw or processed ( by application of filters, Fourier transform ... etc ) **signals** measured in the time (prefixed with 't') or the frequency (prefixed with 'f') domains during the experiment. There are 33 such quantities  like *tBodyAcc-XYZ, tGravityAcc-XYZ, fBodyAccJerk-XYZ* .. etc. Their units are standard gravity unit 'g' or angular velocity (radian/second ) unit. Please refer to the README.txt in the data folder for more details.
       
+ **Set 2: features**

       From these signals, another set of variables has been derived using additional transformations (17 in total) integrating out the time or the frequency variables. This second set is labeled by the transformation that was performed on the signals of set 1 and its elements are called the **features**.

       For exemple, features containing the pattern *mean()* are all resulting from an average over time or frequency of signals in set 1. 
       
I consider an **observational unit** as formed of a single subject and a single activity.
       
#### Doing some maths

+ There are 2947 rows in the data files of the test group and 7352 rows the training group. Given that we have only 30 subjects and 6 different activities, this means that the same activity has been measured for the same person multiple times.

+ There are 33 different signals and 17 different transformations on them. This gives indeed 561 features, which is the number of columns in the files of features X_'name of group'.txt

+ There are no missing values in the subjects, activities or data files.



### Structure of the tidy data

The tidy set has been constructed in the spirit of [tidy data principle](https://github.com/jtleek/datasharing) and in particular the ones laid in [this paper](http://vita.had.co.nz/papers/tidy-data.pdf) by Hadley Wickham.

It has been obtained using the script `run_analysis.R`, which should be in the same folder as the present document, by follwoing the assignment brief:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive activity names. 
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.


```
##    subject.id group           activity signal.name    mean     std
## 1           1 train             laying  tBodyAcc X  0.2216 -0.9281
## 2           1 train            sitting  tBodyAcc X  0.2612 -0.9772
## 3           1 train           standing  tBodyAcc X  0.2789 -0.9958
## 4           1 train            walking  tBodyAcc X  0.2773 -0.2837
## 5           1 train walking downstairs  tBodyAcc X  0.2892  0.0300
## 6           1 train   walking upstairs  tBodyAcc X  0.2555 -0.3547
## 7           1 train             laying  tBodyAcc Y -0.0405 -0.8368
## 8           1 train            sitting  tBodyAcc Y -0.0013 -0.9226
## 9           1 train           standing  tBodyAcc Y -0.0161 -0.9732
## 10          1 train            walking  tBodyAcc Y -0.0174  0.1145
```


