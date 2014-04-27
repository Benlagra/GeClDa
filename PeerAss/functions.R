
## This file contains the main functions used in the run_script code.
## For detailed description of the functions, please refer to the README.md file

library('stringr')

###################################################################################

get.Data.Directory <- function(directory = '.'){
       
       data.Directory <- paste(directory, '/UCI HAR Dataset/', sep = '')
       if (!file.exists(data.Directory)){
              stop('\n
                   !!! The directory you entered does not contain the data folder ! \n
                   !!! Please enter a correct directory !')
       }
       else{
              message('\n
                      Your directory indeed contains the data folder !
                      ===========================================')
       }
       
       data.Directory
       }

###################################################################################

get.Activity.Names <- function(directory= './UCI HAR Dataset/'){
       
       fileName  <- paste(directory, 'activity_labels.txt', sep='')
       classes   <- c('integer', 'character')
       cnames    <- c('index'  , 'name')
       data_activ <- read.table(fileName, colClasses = classes, col.names= cnames)
       
       data_activ[,2] <- tolower(data_activ[,2])
       
       data_activ
       
}

###################################################################################

get.Features.List <- function(directory= './UCI HAR Dataset/'){
       
       fileName  <- paste(directory, 'features.txt', sep='')
       classes   <- c('integer', 'character')
       cnames    <- c('index'  , 'feature')
       data_feat <- read.table(fileName, colClasses = classes, col.names= cnames)
       
       data_feat
       
}

##################################################################################

###################################################################################

collect.Group.Data <- function(group, directory = './UCI HAR Dataset/'){
       
       ## Collects the scattered data of a given group in one single table.
       
       ## File names of the three files per group
       file.Subjects <- paste(directory, group, '/', 'subject_', group, '.txt', sep='')
       
       file.X <- paste(directory, group, '/', 'X_', group, '.txt', sep='')
       
       file.Y <- paste(directory, group, '/', 'y_', group, '.txt', sep='')
       
       ## Reading each file into tables
       message(paste('
                     Reading the data for group "', group, '" 
                     ==================================', sep=''
       )
       )
       
       data.Subjects <- read.table(file.Subjects, colClasses = 'integer',
                                   col.names = 'Subject_id' )
       
       data.X <- read.table(file.X, colClasses = 'numeric')
       
       data.Y <- read.table(file.Y, colClasses = 'integer', col.names = 'Activity')
       
       ## Binding all four columns to one unique data frame
       data_group <- cbind(data.Subjects, data.Y, data.X)
       
       nrow_group <- as.character(nrow(data_group))
       ncol_group <- as.character(ncol(data_group)-2)
       
       message(paste('
                     Data frame for group "', group, '" created.
                     It contains ', nrow_group, ' observations, 2 categorical 
                     variables, and ', ncol_group , ' numerical variables.
                     ======================================', sep=''
       )
       )
       
       data_group
       
}

###################################################################################

merge.Groups.Data <- function(directory= './UCI HAR Dataset/'){
       
       ## First calls previous function for each group
       data_test <- collect.Group.Data('test', directory)
       data_train <- collect.Group.Data('train', directory)
       
       ## Then bind them by rows. No need for merge function here.
       data <- rbind(data_test, data_train)
       
       message('\n
               Data from groups "train" and "test" were merged.
               ================================================')
       
       data
}

##################################################################################

get.Relevent.Indices <- function(features, patterns = character(), directory = './UCI HAR Dataset/'){
       
       good <- lapply(patterns, grep, features$feature)
       
       ## The next two lines are only needed when number of indices for different
       ## patterns do not match. We take then the maximum number of indices. This part of the function is not yet perfectionned
       max.Length <- max(sapply(good, length))
       temp <- sapply(1:length(good), function(x) length(good[[x]]) <<- max.Length)
       
       good <- data.frame(Reduce(cbind, good), stringsAsFactors = FALSE)
       
       ## Throws an error if the patterns match no feature in the list of               features
       if (ncol(good) < length(patterns) | nrow(good) == 0){ 
              pattern = patterns[ncol(good) + 1]
              stop(paste('\n
                         The pattern "', pattern, '"" matched no feature in the list !
                         =========================================================', 
                         sep = ''))
       }
       
       message('\n
               The patterns you entered matched some features in the list.
               ===========================================================')
       
       ## Otherwise, continue
       feat_id <- str_replace(features[good[,1], 2], patterns[1], '')
       
       feat_id <- data.frame(feat_id, good, stringsAsFactors = FALSE)
       
       colnames(feat_id) <- c('Feature', patterns)
       
       feat_id
       
}

###################################################################################

extract <- function(data, indices){
       
       ## Indices should at least have 2 columns, the first one for the name of 
       ## the features we are looking for, and the remaining ones are indices
       ## in the features list for the matched patterns we are looking for.
       
       extracted.Data <- data[, c(1,2)]
       
       if (ncol(indices) >2){
              
              temp <- sapply(colnames(indices[,2:ncol(indices)]), function(x) extracted.Data <<- cbind(extracted.Data, data[, 2+indices[!is.na(indices[,x]),x]]))
       }
       else{
              # Only possibility for ncol(indices) is 1 since if it is zero
              # the program stops because the pattern looked for matches no feature.
              extracted.Data <- cbind(extracted.Data, data[, 2+indices[!is.na(indices[,2]),2]])     
       }
       
       pattern <- gsub('[[:punct:]]', '', c(names(indices)[2:length(indices)]))
       
       message(paste('\
                     Data for the pattern "', pattern, '" extracted.
                     ==========================================', sep=''))
       extracted.Data
}

####################################################################################

label.All.Variables <- function(data, data_activity, indices){
       
       ## Removing underscore from activity names in the activity column of the data
       col.Labels <- str_replace(data_activity[data[,2], 2], '_', ' ')
       
       ## Reconstruct the data frame
       data <- cbind(data[,c(1)], Activity = col.Labels, data[,3:ncol(data)])
       
       
       str.names <-c('subject id', 'activity')
       
       
       temp <-sapply(1:(length(indices)-1), function(x) str.names <<- c(str.names, paste(indices[,1], gsub('[[:punct:]]', '', names(indices)[x+1]), sep='-')))
       
       colnames(data) <- str.names
       
       data <- data[order(data[,1], data[,2]),]
       
       message('\n
               Activities described by explicit names and columns labeled.
               ==========================================================')
       
       data
       
}

###################################################################################

subject.activity.Average <- function(data){
       
       dataa <- aggregate(data[,3:length(data)], by=list('subject id'=data[,1], activity = data[,2]), mean)
       
       dataa <- dataa[order(dataa[,1]),]
       
       message('\n
               Averages for each subject and activity calculated.
               =================================================')
       
       dataa
}

###################################################################################

write.Tidy.Set <- function(data, indices){
       
       ## function which will be called for each element in the pattern
       melting <- function(x){
              
              
              ## Select the range of columns to subset from the large extracted data
              index <- which(colnames(indices) == x)
              range <- 3+ seq((index-2)*nrow(indices),(index-1)*nrow(indices)-1)
              
              ## Clean column names from punctuation and pattern names
              vec <- as.character(gsub(paste('-',gsub('[[:punct:]]', '', x), sep=''), '', colnames(data[, c(range)])))
              vec <- gsub('[[:punct:]]', ' ', vec)
              
              ## Subset the relevent data
              dataa <- data[, c(1, 2, range)]
              
              ## Round the numbers up to 4 digits
              dataa[,3:length(dataa)] <- round(dataa[, 3:length(dataa)], digits = 4)
              
              # Rename the columns
              colnames(dataa) <- c('subject id', 'activity', vec)
              
              meltdata <- melt(dataa, id=c('subject id', 'activity'))
              
              names(meltdata)[3:4] <- c('signal name', gsub('[[:punct:]]', '', x))
              
              meltdata
              
       }
       
       melt.merge <-  melting(names(indices)[2])
       
       
       if(length(indices) > 2){
              temp <- lapply(names(indices)[3:ncol(indices)], function(x){
                     melt.merge <<- merge(melt.merge, melting(x), sort=F)})
              
       }
       
              ## Ordering according to subjects then to observables
              melt.merge <- melt.merge[order(melt.merge[,1], melt.merge[,3]),
                                       ]
              write.csv(melt.merge, './tidy_set.txt', row.names=F)
       
       message('\n
               Tidy data set output in the working directory.
               ==============================================')
       
}
