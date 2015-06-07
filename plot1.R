## plot1.R, 6/4/2015
##
## Works with the "Individual household electric power consumption Data Set" from the UC
## Irvine Machine Learning Repository.
##
## Example:
##  setwd("R/course/Project-EDA/")         # enter the directory with project data
##  source("plot1.R")
##
## Output:
##  the plot1.png file written in the current working directory along with a local subset
##  file named tidydt.rds
##
## Caveats:
##  runs only on platforms where the "sed" utility is installed (Unix/Linux/Mac)

# Files
ifile       <- "household_power_consumption.txt"
ofile       <- "plot1.png"
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
    dt          <- readRDS(sfile)
}

# Generate the plot
png(ofile, bg = "transparent")
hist(dt$Global_active_power, col = "red", main = "Global active power",
     xlab = "Global active power (kilowatts)")
dev.off()

# Cleanup
rm(ifile, ofile, sfile, count, dt)
detach(package:data.table)