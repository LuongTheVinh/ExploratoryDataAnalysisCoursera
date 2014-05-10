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

# Partition graphics screen into 2 x 2 quadrants, to be filled column-wise
par(mfcol = c(2, 2), mar = c(4, 4, 1, 2))

# Plot Global Active Power series
plot(dat$Time, dat$Global_active_power, type = "l", bg = 'white', col= 'black',
     xlab = "", ylab = "Global Active Power")

# Plot Sub-Metering series
plot(dat$Time, dat$Sub_metering_1, type = "l", bg = 'white', col= 'black',
     xlab = "", ylab = "Energy sub metering")
lines(dat$Time, dat$Sub_metering_2, col = 'red')
lines(dat$Time, dat$Sub_metering_3, col = 'blue')
legend('top', c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       lty = 1, col=c('black', 'red', 'blue'), bty='n', cex=0.75)

# Plot Voltage series
plot(dat$Time, dat$Voltage, type = "l", bg = 'white', col= 'black',
     xlab = "datetime", ylab = "Voltage")

# Plot Global Reactive Power series
plot(dat$Time, dat$Global_reactive_power, type = "l", bg = 'white', col= 'black',
     xlab = "datetime", ylab = "Global reactive power")

# Copy to PGN file
dev.copy(png, filename = "plot4.png", width = 480, height = 480)
dev.off()