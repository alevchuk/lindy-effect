#!/usr/bin/env Rscript

mydata <- read.csv("gldt.csv", header=F, stringsAsFactors=F)

# name columns
colnames(mydata) <- c('Type', 'Name', NA, 'Parent', 'Start', 'Stop')

# drop unused columns
mydata <- mydata[,-which(colnames(mydata) %in% NA)]

# drop unused rows
mydata <- mydata[mydata$Type == 'N', ]

# Convert to date type
for ( col in c("Start", "Stop") ) {
	# to covert to a data type we need year, month, and day
	# year only entries would case a conversion error
	year_only_rows <- grep("^[0-9]{4}$", mydata[,col])
	mydata[year_only_rows, col] <-
		paste(mydata[year_only_rows, col], ".1.1", sep="")

	# to covert to a data type we need year, month, and day
	# year.month only entries would case a conversion error
	month_only_rows <- grep("^[0-9]{4}\\.[0-9]+$", mydata[,col])
	mydata[month_only_rows, col] <-
		paste(mydata[month_only_rows, col], ".1", sep="")

	# some entires have day as "0"
	# this would case a conversion error
	mydata[,col] <- sub("^([0-9]{4}\\.[0-9]+)\\.0+$", "\\1.1", mydata[,col])

	# Convert
	mydata[,col] <- as.Date(mydata[,col], "%Y.%m.%d")
}

# Print ranges
data.frame(
	"Start Range"=range(mydata$Start, na.rm=T),
     	"Stop Range"=range(mydata$Stop, na.rm=T),
	row.names=c("min", "max")
)
