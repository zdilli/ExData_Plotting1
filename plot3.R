## Script to generate Plot 1 of Programming Assignment 1
# Class: Exploratory Data Analysis, Date: 11 May 2014

# Read in the data
# (Looking at the data file, there is a single header line and the separator character 
# is ";".  The assignment specified that ? is used for NA.)
# Note that data file must be in the same directory as this script and
# must be named "household_power_consumption.txt"

indat <- read.table("household_power_consumption.txt",header=TRUE, 
                    sep=";",na.strings="?")

# Transform date 
indat$Date <- as.Date(as.character(indat$Date),format="%d/%m/%Y")

# Subset data with date
ssvec <- (indat$Date=="2007-02-01" | indat$Date=="2007-02-02")
indat_relevant <- subset(indat,ssvec)
rm(indat) # clean up memory
rm(ssvec)

# Transform time
timepre <- as.character(indat_relevant$Time)
timeconvert <- strptime(timepre,format="%H:%M:%S",tz="")
timeconvert <- as.POSIXct(timeconvert)
timeonly <- as.numeric(timeconvert - trunc(timeconvert,"day"))
indat_relevant$Time <- timeonly
rm(timepre) # clean up memory
rm(timeconvert)
rm(timeonly)

# will initially plot vs. number of seconds in the 
# x-axis, so create that vector.  There are 86400 seconds 
# in a day, so add 0 to the timestamps of the first day
# and 86400 to those of the second day.
indat_relevant$PlotTime <- indat_relevant$Time + 
    as.numeric(indat_relevant$Date=="2007-02-02")*86400

# Create plot device and plot.  Leave the x-axis blank initially,
# then mark it in the appropriate transition points.
png(filename="plot3.png")

plot(indat_relevant$PlotTime,indat_relevant$Sub_metering_1,type="l",
     xlab="",ylab="Energy sub metering",col="black",xaxt='n')
lines(indat_relevant$PlotTime,indat_relevant$Sub_metering_2,
      type="l",col="red")
lines(indat_relevant$PlotTime,indat_relevant$Sub_metering_3,
      type="l",col="blue")

legend("topright",
       legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
       lwd=c(1,1,1),col=c("black","red","blue"))
axis(1,c(0,86400,2*86400),c("Thu","Fri","Sat"))

dev.off()