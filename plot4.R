## plot4.R, 6/4/2015
##
## Works with the "Individual household electric power consumption Data Set" from the UC
## Irvine Machine Learning Repository.
##
## Example:
##  setwd("R/course/Project-EDA/")         # enter the directory with project data
##  source("plot4.R")
##
## Output:
##  the plot4.png file written in the current working directory along with a local subset
##  file named tidydt.rds
##
## Caveats:
##  runs only on platforms where the "sed" utility is installed (Unix/Linux/Mac)

# Files
ifile       <- "household_power_consumption.txt"
ofile       <- "plot4.png"
sfile       <- "tidydt.rds"

# Prerequisity
count <- length(dir(pattern = paste(ifile, sfile, sep = "|")))
if (count == 0) {
    stop("Unable to find the data files, please check your working directory.")
}

if (!require(data.table)) {
    stop("Unable to load the data.table package")
}

# The dataset has 2,075,259 rows and 9 columns. We will only be using data from the dates
# 2007-02-01 and 2007-02-02, reducing the row count to 2,880 by leveraging the preprocessing
# feature of fread.
# Saving resources - the subset file takes precedence if found locally.
if (!file.exists(sfile)) {
    preprocess  <- "sed -r '1p;\\%^[12]/2/2007%!d'"
    dt          <- fread(paste(preprocess, ifile), na.strings = "?")
    saveRDS(dt, sfile)
    rm(preprocess)
} else {
    dt      <- readRDS(sfile)
}

# Dates and times are read as character, let's convert them accordingly
dt          <- dt[, Date:=as.IDate(Date, "%d/%m/%Y")]
dt          <- dt[, Time:=as.ITime(Time, "%H:%M:%S")]
datetime    <- as.POSIXct(dt$Date) + dt$Time

# Generate the plot
png(ofile, bg = "transparent")
par(mfrow = c(2, 2))

with(dt, {
    plot(datetime, Global_active_power, type = "l", xlab = "",
         ylab = "Global Active Power")
    plot(datetime, Voltage, type = "l")
    plot(datetime, Sub_metering_1, type = "l", xlab = "", ylab = "Energy sub metering")
        lines(datetime, Sub_metering_2, col = "red")
        lines(datetime, Sub_metering_3, col = "blue")
        legend("topright", col = c("black", "red", "blue"), lty = 1, bty = "n",
               legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
    plot(datetime, Global_reactive_power, type = "l")
})
dev.off()

# Cleanup
rm(ifile, ofile, sfile, count, datetime, dt)
detach(package:data.table)