# Set file paths
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
fileName_pm25EmissionsData <- "summarySCC_PM25.rds"
fileName_sourceClassifCodeTab <- "Source_Classification_Code.rds"

# Download data
tempFile <- tempfile()
download.file(url, tempFile)
dat_pm25Emissions <- readRDS(unzip(tempFile, fileName_pm25EmissionsData))
dat_sourceClassifCodeTab <- readRDS(unzip(tempFile, fileName_sourceClassifCodeTab))

# Subset into PM 2.5 Emissions from Motor Vehicle sources ("ON-ROAD")
# in Baltimore, MD and Los Angeles, CA
dat <- dat_pm25Emissions[dat_pm25Emissions$fips %in% c("06037", "24510"),]
dat$fips <- as.factor(dat$fips)
levels(dat$fips) <- c("Los Angeles, CA", "Baltimore, MD")
dat <- dat[dat$type == "ON-ROAD",][, c(1, 4, 6)]

# Sum PM 2.5 Emissions by year and index 1999 = 100
library(reshape2)
dat_melt <- melt(dat, id = c("fips", "year"))
dat_cast <- dcast(dat_melt, fips + year ~ variable, sum)
dat_cast$Emissions[1:4] <- dat_cast$Emissions[1:4] / dat_cast$Emissions[1] * 100
dat_cast$Emissions[5:8] <- dat_cast$Emissions[5:8] / dat_cast$Emissions[5] * 100

# Plot to PNG file
library(ggplot2)
ggplot(dat_cast, aes(as.factor(year), Emissions)) + 
      geom_bar(fill = 'orange') +
      facet_grid(fips ~ .) +
      theme(plot.title = element_text(size = rel(1.5))) +
      ggtitle(expression(paste("Total PM"[2.5],
      " Emissions from Motor Vehicle sources (index: 1999 = 100)"))) +
      xlab("Year") + ylab(expression(paste("Total PM"[2.5], " Emissions (tons)")))
dev.copy(png, filename = "plot6.png", width = 600)
dev.off()