
setwd("D:/Performance/9. Science/9. Data Science/Exploratory Data analysis/Project/")

setwd("D:/")

path <- getwd()
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
f <- "Dataset.zip"
if (!file.exists(path)) {
    dir.create(path)
}
download.file(url, file.path(path, f))
executable <- file.path("C:", "Program Files", "7-Zip", "7z.exe")
parameters <- "x"
cmd <- paste(paste0("\"", executable, "\""), parameters, paste0("\"", file.path(path, f), "\""))
system(cmd)
pathIn <- file.path(path, "Electric power consumption Dataset")

list.files(getwd(), recursive = F)

library(data.table)
library(ggplot2)
library(dplyr)

# RAM usage calculation = 
# A one-minute sampling rate over a period of almost 4 years # * 9 variables * 8 bytes/numeric
# / 2^20 byes/MB -> result is around 

((60*24*356*4) * 9 * 8)/ (2^20)

# Load data till 1/3/2007
data_test <- data.table(read.table("./household_power_consumption.txt", 
                                   header = TRUE, 
                                   fill = FALSE, 
                                   sep = ";", 
                                   stringsAsFactors=FALSE,
                                   dec = ".")) 

data_test$Date <- as.Date(data_test$Date, "%d/%m/%Y") 
data_test[order(data_test$Date),]
data_dates <- filter(data_test, Date >= "2007-02-01" & Date <= "2007-02-02")
data_dates$Global_active_power <- as.numeric(data_dates$Global_active_power)

rm(data_test)

data_dates$Time <- strptime(paste(data_dates$Date, data_dates$Time, sep = " "), "%Y-%m-%d %H:%M:%S")

png('Plot2.png', width = 480, height = 480)
plot(data_dates$Time, data_dates$Global_active_power, type = "l", 
     xlab = "", ylab = "Global Active Power (kilowatts)")
dev.off()
