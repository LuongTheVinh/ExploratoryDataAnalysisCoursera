# Set file paths
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
fileName_pm25EmissionsData <- "summarySCC_PM25.rds"
fileName_sourceClassifCodeTab <- "Source_Classification_Code.rds"

# Download data
tempFile <- tempfile()
download.file(url, tempFile)
dat_pm25Emissions <- readRDS(unzip(tempFile, fileName_pm25EmissionsData))
dat_sourceClassifCodeTab <- readRDS(unzip(tempFile, fileName_sourceClassifCodeTab))

# Summarise Baltimore, MD's PM 2.5 emissions by year
dat_pm25Emissions_BaltimoreMD = dat_pm25Emissions[dat_pm25Emissions$fips == 24510,]
pm25EmissionsByYear_BaltimoreMD <- tapply(dat_pm25Emissions_BaltimoreMD$Emissions,
      dat_pm25Emissions_BaltimoreMD$year, sum)

# Plot to PNG file
par(mar = c(5, 5, 4, 1))
barplot(pm25EmissionsByYear_BaltimoreMD / 1e3,
        main = expression(paste("Total PM"[2.5], " Emissions in Baltimore, MD, 1999-2008")),
        xlab = "Year",
        ylab = expression(paste("Total PM"[2.5], " Emissions (thousand tons)")), col = 'orange')
dev.copy(png, filename = "plot2.png", width = 600)
dev.off()