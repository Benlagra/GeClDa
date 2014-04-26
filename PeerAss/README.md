Getting and cleaning data project
=================================

You will find here the required script and codebook for the [*Getting and cleaning data course project*](https://class.coursera.org/getdata-002/human_grading/view/courses/972080/assessments/3/submissions).

The following repository contains:

* `run_analysis.R` : the main script performing the analysis of the provided data according to the project requirements.
* `functions.R` : a script containing the functions called in the main script. This keeps the main script short and clean.
* `Code_book.md`: the code book for the data. It describes the raw data as well as the tidy data set.
* `README.md`: this is the file you are reading. It contains essentially information about the main script, the functions in `functions.R` and how to use them.

## Requirements of the projects

The main script should do the following

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive activity names. 
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Requirements to use the scripts

Make sure that:

+ `functions.R` and `run_script.R` stay in the same folder.
+ The package [`stringr`](http://cran.r-project.org/package=stringr) is installed. A call to this package is included in `functions.R`.
+ Your working directory *contains* the unzipped data folder named 'UCI HAR Dataset', although I allow the user of the code to specify the location of that folder (`line 7` of the main script) if it is not in the working directory..

## The main script `run_analysis.R`

### What you can, and can't, do with it

I wrote the script so that I can do more than what was asked in the assignment. In particular, you can extract more than the mean and the standard deviation measurements by changing a single line. In order to clarify this, and the use of what I call a *`pattern`*, let me briefly remind the structure of the raw data.

We can classify the raw data, i.e. the data contined in the unzipped folder before any analysis, into two sets:

+ **Set 1 : signals**

       This set contains the raw or processed ( by application of filters, Fourier transform ... etc ) signals measured in the time or the frequency domains during the experiment. There are 33 such quantities  like *tBodyAcc-XYZ, tGravityAcc-XYZ, fBodyAccJerk-XYZ* .. etc.
       
       From these signals, another set of variables has been derived using additional transformations (17 in total) integrating out the time or the frequency variables. This second set is labeled by the transformation that was performed on the signals of set 1 and its elements are called the **features**.
       
+ **Set 2: features**

       For exemple, features containing the pattern *mean()* are all resulting from an average ove time or frequency of signals in set 1. 
       
So back to what you can do with my code, you can specify a character vector named `patterns` (line 12 of the main script) whose elements are the data you would like to extract. For exemple, `patterns=c('-mean\\(\\)', '-min\\(\\)')` will extract all data in set 2 about the *mean* and the *min* measurements. Similarily, `patterns=c('tBodyAcc')` will extract all the data in set 2 (mean, std, min ... etc) which are related to the signal `tBodyAcc` in set 1.

With the present version of the code, you can not use a `pattern` with mixed data from set 1 and 2. For exemple `patterns = c('-mean\\(\\)', 'tBodyAcc')` will result in an error.

For the purpose of the assignment, I take `patterns = c(''-mean\\(\\)', ''-std\\(\\)')`. But feel free to play with it yourself.

### How to use it and what to get from it

If you want to check the tidy data output according to the assignment brief, just run it as it is. If you are curious, you can extract more data than asked in the brief by changing the content of `patterns`. Then, just continue from `line 43` and you don't need to collect and merge the data of the groups again.

The output tidy data set consists of **as many text files in CSV format as there are elements in `pattern`** of the averaged, for each subject and each activity, extracted data, according to the 5th task of the assignment. I output thus **two files**, one for the *mean* variables and one for *std* variables. I think this is better for clarity even though the two variables are related with each other. 

A larger text file is output as well, containing both *mean* and *std* variables before the average for each subject and each activity was performed. 


## Descriptions and usage of the functions used in `run_analysis.R`

I wrote the functions in `functions.R` to tackle each of the individual tasks of the project. My intention was to have a clean main script and to help my peers to follow the required tasks one after the other in blocks.

These functions are : 

+ `get.Data.Directory(directory = './')`

       Given a directory, by default or by the user, the function checks that it        contains the unzipped data folder whose unchanged name should be `UCI HAR Dataset/` and returns its path. The default value of `directory` is the working directory. If the data folder is not present, the script stops and prints an explicit message.
       
+ `get.Features.List(directory = './UCI HAR Dataset/')`

       Reads the file `features.txt` in the data folder and outputs a `data.frame` with two columns (index, feature) and 561 rows containing all the features' names and their index. This function can be called once after `get.Data.Directory()`
       
+ `get.Activity.Names(directory= './UCI HAR Dataset/')`

       Reads the file `activity_labels.txt` in the data folder and returns a `data.frame` with two columns (index, name) and 6 rows for the six different activities.

+ `collect.Group.Data(group, directory = './UCI HAR Dataset/')`
       
       Given a group of subjects name `group` (character) and the path to the data folder (by default `'./UCI HAR Dataset/'`), the function merges the three files, respectively of the subjects, the activities, and the set of variables, contained in the sub-folder named after the group. The output is a `data.frame` which contains 3 categorical variables (Subject_id, Group, and Activity) and 561 numerical variables corresponding to all the features. The number of rows depends on the group. Notice that **I choose to keep the information about the group in which the subject belongs, by adding one column**, so that the data between the two groups in the experiment can still be compared from the final tidy data set.
       
+ `merge.Groups.Data(directory = './UCI HAR Dataset/')`

       Merges the data of groups 'train' and 'test' after calling the two previous functions as required in the 1st task of the project. This function is actually not used in the present main script. I prefered to use the previous two functions and `rbind` their outcomes to go step by step.
       
 

+ `get.Relevent.Indices(features, patterns = character(), directory = './UCI HAR Dataset/')`

       Given the `features` data.frame obtained from `get.Features.List()`, the vector of patterns, and the data folder path, the functions outputs the indices of features whose name partially matches the patterns in `list`. 
       
       Exemple: if you are looking for the mean data, you should enter `patterns <- c('-mean\\(\\)')` since this is the pattern contained in all the mean data features. `patterns <- c('-min\\(\\)', '-max\\(\\)')` will return the indices of the features corresponding to the `min` and `max` data. The double backslash is important whenever your pattern includes the parantheses.
       
       When the pattern is focused on set 2 above, the output of the function is a `data.frame` with 33 rows (corresponding to the 33 signals), a column `Feature` for features' names, and as many additional columns as there are matching patterns in `patterns` (eg. two colums if you are looking for mean and std data). If a single pattern matches no feature's name, the program stops with an explicit error message.
       
+ `extract(data, indices)`

       This function addresses the 2nd task of the brief by choosing `paterns <- c('-min\\(\\)', '-std\\(\\)')` in the previous function.

       Given the `data.frame` of indices, obtained by using the last function or entered by the user, the function extracts the relevent columns from the large `data.frame` of the merged data and outputs the corresponding reduced `data.frame`. This containss 3 categorical columns (Subject_id, Group, Activity) and 33 numerical columns for each pattern looked for in the previous function. Eg: if `patterns=c('-mean\\(\\)', '-std\\(\\)')`, the data frame output will contain 69 = 3 + 33 + 33 columns.
       
       
       Notice that if you want to enter the indices yourself without using the previous function, `indices` should be a `data.frame` with at least a character column for features' names and an integer column for indices. The function returns only the data for which the index is not `NA`.
       
       
+ `label.All.Variables(data, data_activity, indices)`

       This function addresses the 3rd and 4th task of the brief.

       Given the `data` obtained from the function `extract()`, the data.frame `data_activity` obtained from `get.Activity.Names()` and the data.frame `indices` corresponding to the relevent data we are looking for, this function replaces the integer values of the activities and labels all the columns data with descriptive names.  
       
+ `subject.activity.means(data)`

       This function addresses the 5th task of the brief.
       
       It calculates the average of each variable for each subject and each activity using the function `aggregate`, then orders the data set by the subjects id. 
       
+ `write.Tidy.Data(data, indices)`

       writes the data into separate text files, in CSV format, for different patterns. So if we are looking for the mean and std data, the output of the function is two text files, one for the mean data and another for the std data.
       
       Numerical values are rounded to 4 digits for the clarity of the text file.




