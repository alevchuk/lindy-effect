#!/usr/bin/env Rscript

inputFileLocalPath <- "lindy-gldt.csv"
if ( ! file.exists(inputFileLocalPath) ) {
        download.file("https://raw.githubusercontent.com/FabioLolix/LinuxTimeline/28e13cc8f406546a701b6e5c197ee20da58b5d66/gldt.csv", destfile=inputFileLocalPath)
}
inputData <- read.csv(inputFileLocalPath, header=F, stringsAsFactors=F)

# name columns
colnames(inputData) <- c('Type', 'Name', NA, 'Parent', 'Start', 'Stop')

# drop unused columns
inputData <- inputData[,-which(colnames(inputData) %in% NA)]

# drop unused rows
inputData <- inputData[inputData$Type == 'N', ]

# Convert to date type
for ( col in c("Start", "Stop") ) {
        # to convert to a data type we need year, month, and day
        # year only entries would case a conversion error
        year_only_rows <- grep("^[0-9]{4}$", inputData[,col])
        inputData[year_only_rows, col] <-
                paste(inputData[year_only_rows, col], ".1.1", sep="")

        # to convert to a data type we need year, month, and day
        # year.month only entries would case a conversion error
        month_only_rows <- grep("^[0-9]{4}\\.[0-9]+$", inputData[,col])
        inputData[month_only_rows, col] <-
                paste(inputData[month_only_rows, col], ".1", sep="")

        # some entries have day as "0"
        # this would cause a conversion error
        inputData[,col] <- sub("^([0-9]{4}\\.[0-9]+)\\.0+$", "\\1.1", inputData[,col])

        # Convert
        inputData[,col] <- as.Date(inputData[,col], "%Y.%m.%d")
}


getSurvivorsAt <- function(df, atTimePoints) {
        lapply(
                atTimePoints,
                function(atTimePoint) {
                        subset <- df[df$Start <= atTimePoint & (atTimePoint < df$Stop | is.na(df$Stop)),]
                        subset$currentTime <- rep(atTimePoint, nrow(subset))
                        subset$ageInDays <- subset$currentTime - subset$Start
                        subset$futureLifeInDays <- subset$Stop - subset$currentTime
                        subset
                }
        )
}


# Print ranges
data.frame(
        "Start Range"=range(inputData$Start, na.rm=T),
        "Stop Range"=range(inputData$Stop, na.rm=T),
        row.names=c("min", "max")
)

# Run the experiment up to the time point where
# we can still know if the survivors will live
# twice their current age
dataGoesUpTo = range(inputData$Stop, na.rm=T)[[2]]
experimentRangeStart = range(inputData$Start, na.rm=T)[[1]]
experimentRangeStop = experimentRangeStart + abs(difftime(experimentRangeStart, dataGoesUpTo) / 2)

# Distros that survived at the time data was collected
# are counted as dead the the end of data range.
inputData$Stop[is.na(inputData$Stop)] <- dataGoesUpTo

timePoints <- seq(experimentRangeStart, experimentRangeStop, by="month")

survivors <- getSurvivorsAt(inputData, timePoints)

# flatten to a single data frame
experimentResults <- survivors[[1]]
for (t in 2:length(timePoints)) {
        experimentResults <- rbind(experimentResults, survivors[[t]])
}

# At each time point, mark the youngest and the
# the oldest distro among the survivors at that time.
experimentResults[, "status"] <- NA
for (t in timePoints) {
        survivor_positions <- experimentResults$currentTime == t
        survivors <- experimentResults[survivor_positions, ]

        if (nrow(survivors) > 0) {
                youngest_age <- min(survivors$ageInDays,  na.rm=T)
                youngest <- survivors[survivors$ageInDays == youngest_age, ][1, ]
                experimentResults[rownames(youngest),]$status <- "youngest"

                oldest_age <- max(survivors$ageInDays,  na.rm=T)
                oldest <- survivors[survivors$ageInDays == oldest_age, ][1, ]
                experimentResults[rownames(oldest),]$status <- "oldest"
        }
}


cat("\nYoungest survivors:\n")
print(unique(experimentResults[
      which(experimentResults$status == "youngest"),
      c("Type", "Name", "Parent", "Start", "Stop")
      ]))
cat("\n\n")

cat("\nOldest survivors:\n")
print(unique(experimentResults[
      which(experimentResults$status == "oldest"),
      c("Type", "Name", "Parent", "Start", "Stop")
      ]))
cat("\n\n")


# plot only the youngest and the oldest
experimentResults <- experimentResults[which(!is.na(experimentResults$status)), ]

col <- rep("black", nrow(experimentResults))
col[which(experimentResults$status == "youngest")] <- "green"
col[which(experimentResults$status == "oldest")] <- "orange"

pdf(file="lindy-age-life-scatter-plot.pdf")
plot(
     experimentResults$ageInDays,
     experimentResults$futureLifeInDays,
     xlab="Age (in days)",
     ylab="Future Life (in days)",
     col=col
)


# At each time point, grab the oldest
# distro among the survivors at that time,
# and check if it will survive the double
# of it's current age
experimentResults$willLive2x <- (experimentResults$futureLifeInDays > experimentResults$ageInDays)
experimentResultsForOldest <- experimentResults[
        experimentResults$status == "oldest",
        c("currentTime", "Name", "ageInDays", "futureLifeInDays", "willLive2x")
      ]
print(experimentResultsForOldest)

cat("\n")
cat("Using lindy effect to predict which Linux distro will live 2x of it's current age\n")
cat("At each time point, we take the oldest repo among survivors and bet that it will live 2x of it's current age\n")
cat("then we count the time points when we were correct and calculate what percentage of time we were correct.\n")

correct <- sum(experimentResultsForOldest$willLive2x)
total <- nrow(experimentResultsForOldest)
cat(paste("Time points when correct:", correct, "\n"))
cat(paste("Time points total:", total, "\n"))
cat(paste("Ratio:", correct / total, "\n"))
cat(paste("Lindy effect is correct ", signif((correct / total) * 100, 3), "% of the time\n", sep=""))
cat("\n")
