# Set file paths
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
fileName_pm25EmissionsData <- "summarySCC_PM25.rds"
fileName_sourceClassifCodeTab <- "Source_Classification_Code.rds"

# Download data
tempFile <- tempfile()
download.file(url, tempFile)
dat_pm25Emissions <- readRDS(unzip(tempFile, fileName_pm25EmissionsData))
dat_sourceClassifCodeTab <- readRDS(unzip(tempFile, fileName_sourceClassifCodeTab))

# Summarise Total United States PM 2.5 emissions by year
pm25EmissionsByYear <- tapply(dat_pm25Emissions$Emissions, dat_pm25Emissions$year, sum)

# Plot to PNG file
par(mar = c(5, 5, 4, 1))
barplot(pm25EmissionsByYear / 1e6,
      main = expression(paste("Total PM"[2.5], " Emissions in the United States, 1999-2008")),
      xlab = "Year",
      ylab = expression(paste("Total PM"[2.5], " Emissions (million tons)")), col = 'orange')
dev.copy(png, filename = "plot1.png", width = 600)
dev.off()