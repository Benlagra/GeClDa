
## Features

library(stringr)

collect.Group.Data <- function(group){

       ## Collects the scattered data of a given group in one single table.

       file.subjects <- paste('UCI HAR Dataset/', group, '/', 'subject_', group, '.txt', sep='')
       
       file.X <- paste('UCI HAR Dataset/', group, '/', 'X_', group, '.txt', sep='')
       
       file.Y <- paste('UCI HAR Dataset/', group, '/', 'y_', group, '.txt', sep='')
       
       data.subjects <- read.table(file.subjects, colClasses = 'integer', 
                     col.names = 'subject_id' )
                     
       data.X <- read.table(file.X, colClasses = 'numeric')
       
       data.Y <- read.table(file.Y, colClasses = 'integer', col.names = 'Activity')
       
       group.Col = rep(group, length(data.subjects[,1]))
       
       data_group = data.frame(data.subjects, Group = group.Col, data.Y, data.X)
}

merge.Group.Data <- function(){

       data_test <- collect.Group.Data('test')
       data_train <- collect.Group.Data('train')
       
       
       data <- rbind.data.frame(data_test, data_train)
}

get.Relevent.Indices <- function(){

       fileName  = 'UCI HAR Dataset/features.txt'
       classes   <- c('integer', 'character')
       cnames    <- c('index'  , 'feat')
       data_feat <- read.table(fileName, colClasses = classes, col.names= cnames)
       
       good_mean <- grep('mean\\(\\)', data_feat$feat )
       good_std  <- grep('std\\(\\)' , data_feat$feat )
       
       mean_d    <- data_feat[good_mean, ]
       std_d     <- data_feat[good_std,  ]
       
       mean_d[,2] <- str_replace(mean_d[,2], '-mean\\(\\)', '')
       std_d[,2]  <- str_replace(std_d[,2] , '-std\\(\\)' , '')
       
       feat_id    <-  data.frame(Feature = mean_d[, 2], mean_id = mean_d[, 1], 
                            std_id = std_d[, 1], stringsAsFactors=F)
       
       feat_id
}

get.Activity.Names <- function(){

       fileName  = 'UCI HAR Dataset/activity_labels.txt'
       classes   <- c('integer', 'character')
       cnames    <- c('index'  , 'Name')
       data_activ <- read.table(fileName, colClasses = classes, col.names= cnames)
       
       data_activ

}

extract.Mean.Std <- function(){

       indices <- get.Relevent.Indices()
       data <- merge.Group.Data()
       
       
       data.Mean.Std <- data.frame(data[,c(1,2,3)], data[,c(3+indices[,2], 3+indices[,3])])
       
       
       colnames(data.Mean.Std) <- c('Subject_id', 'Group', 'Activity', indices[,1], indices[,1] )
       
       data.Mean.Std

}

label.Activity <- function(data){

       fileName  = 'UCI HAR Dataset/activity_labels.txt'
       classes   <- c('integer', 'character')
       cnames    <- c('index'  , 'Name')
       data.activ <- read.table(fileName, colClasses = classes, col.names= cnames)
       
       col.Labels <- str_replace(data.activ[data$Activity, 2], '_', ' ')
       data <- data.frame(data[,c(1,2)], col.Labels, data[,4:ncol(data)])
       
       colnames(data) <- c('Subject_id', 'Group', 'Activity', indices[,1], indices[,1] )
       
       data <- data[order(data$Subject_id),]
       
       data
       
}

subject.activity.means <- function(data){

       dataa <- aggregate(data[,4:length(data)], by=list(Subject_id=data$Subject_id, Group=data$Group, Activity=data$Activity), mean)
       
       dataa <- dataa[order(dataa$Subject_id),]
}
