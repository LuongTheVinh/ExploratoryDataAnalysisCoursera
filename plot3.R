# Set URL and file name
url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
fileName = "household_power_consumption.txt"
# Set the two dates of interest
datesOfInterest = as.Date(c("2007-02-01", "2007-02-02"))

# Download data 
tempFile = tempfile()
download.file(url, tempFile)
dat <- read.table(unz(tempFile, fileName), header = TRUE, sep = ";", na.strings = "?")

# Transform Time and Date to the corresponding classes
dat$Time = strptime(paste(dat$Date, dat$Time, sep = " "), "%d/%m/%Y %H:%M:%S")
dat$Date = as.Date(dat$Date, "%d/%m/%Y")

# Subset into the two dates of interest
dat <- dat[dat$Date %in% datesOfInterest,]

# Plot Sub-Metering series to PNG file
plot(dat$Time, dat$Sub_metering_1, type = "l", bg = 'white', col= 'black',
     xlab = "", ylab = "Energy sub metering")
lines(dat$Time, dat$Sub_metering_2, col = 'red')
lines(dat$Time, dat$Sub_metering_3, col = 'blue')
legend('top', c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
      lty = 1, col=c('black', 'red', 'blue'), bty='n', cex=0.75)
dev.copy(png, filename = "plot3.png", width = 480, height = 480)
dev.off()