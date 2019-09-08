#!/usr/bin/env Rscript

mydata <- read.csv("gldt.csv", header = FALSE)

# name columns
colnames(mydata) <- c('Type', 'Name', NA, 'Parent', 'Start', 'Stop', NA, 'Description')

# drop unused columns
mydata <- mydata[,-which(colnames(mydata) %in% NA)]

# drop unused rows
mydata <- mydata[mydata$Type == 'N', ]

tail(mydata)
