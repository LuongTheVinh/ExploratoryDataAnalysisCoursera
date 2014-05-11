# Set file paths
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
fileName_pm25EmissionsData <- "summarySCC_PM25.rds"
fileName_sourceClassifCodeTab <- "Source_Classification_Code.rds"

# Download data
tempFile <- tempfile()
download.file(url, tempFile)
dat_pm25Emissions <- readRDS(unzip(tempFile, fileName_pm25EmissionsData))
dat_sourceClassifCodeTab <- readRDS(unzip(tempFile, fileName_sourceClassifCodeTab))
 
# Subset into PM 2.5 Emissions from Motor Vehicle sources ("ON-ROAD") in Baltimore, MD
dat <- dat_pm25Emissions[dat_pm25Emissions$fips == 24510,]
dat <- dat[dat$type == "ON-ROAD",][, c(4, 6)]

# Sum PM 2.5 Emissions by year
library(reshape2)
dat_melt <- melt(dat, id = "year")
dat_cast <- dcast(dat_melt, year ~ variable, sum)

# Plot to PNG file
library(ggplot2)
ggplot(dat_cast, aes(as.factor(year), Emissions)) + 
      geom_bar(fill = 'orange') +
      theme(plot.title = element_text(size = rel(1))) +
      ggtitle(expression(paste("Total PM"[2.5],
      " Emissions in Baltimore, MD, 1999-2008 from Motor Vehicle sources"))) +
      xlab("Year") + ylab(expression(paste("Total PM"[2.5], " Emissions (tons)")))
dev.copy(png, filename = "plot5.png", width = 600)
dev.off()