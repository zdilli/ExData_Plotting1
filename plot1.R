## Script to generate Plot 1 of Programming Assignment 1
# Class: Exploratory Data Analysis, Date: 11 May 2014

# Read in the data
# (Looking at the data file, there is a single header line and the separator character 
# is ";".  The assignment specified that ? is used for NA.)
# Note that data file must be in the same directory as this script and
# must be named "household_power_consumption.txt"

indat <- read.table("household_power_consumption.txt",header=TRUE, 
                    sep=";",na.strings="?")

# Transform data
indat$Date <- as.Date(as.character(indat$Date),format="%d/%m/%Y")
timepre <- as.character(indat$Time)
timeconvert <- strptime(timepre,format="%H:%M:%S",tz="")
timeconvert <- as.POSIXct(timeconvert)
timeonly <- timeconvert - trunc(timeconvert,"day")
indat$Time <- timeonly
rm(timepre) # clean up memory
rm(timeconvert)
rm(timeonly)

# Subset data
ssvec <- (indat$Date=="2007-02-01" | indat$Date=="2007-02-02")
indat_relevant <- subset(indat,ssvec)
rm(indat) # Clean up memory
rm(ssvec)

# Create plot device and plot
png(filename="plot1.png")

hist(indat_relevant$Global_active_power,
     main = "Global Active Power",
     xlab="Global Active Power (kilowatts)",col="red")

dev.off()