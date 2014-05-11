# Set file paths
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
fileName_pm25EmissionsData <- "summarySCC_PM25.rds"
fileName_sourceClassifCodeTab <- "Source_Classification_Code.rds"

# Download data
tempFile <- tempfile()
download.file(url, tempFile)
dat_pm25Emissions <- readRDS(unzip(tempFile, fileName_pm25EmissionsData))
dat_sourceClassifCodeTab <- readRDS(unzip(tempFile, fileName_sourceClassifCodeTab))
 
# Identify Coal Combustion-related emission sources
dat_sourceClassifCodeTab$matchCoal <-
      (grepl('coal', as.character(dat_sourceClassifCodeTab$Short.Name), ignore.case = TRUE) +
      grepl('coal', as.character(dat_sourceClassifCodeTab$EI.Sector), ignore.case = TRUE) +
      grepl('coal', as.character(dat_sourceClassifCodeTab$SCC.Level.One), ignore.case = TRUE) +
      grepl('coal', as.character(dat_sourceClassifCodeTab$SCC.Level.Two), ignore.case = TRUE) +
      grepl('coal', as.character(dat_sourceClassifCodeTab$SCC.Level.Three), ignore.case = TRUE) +
      grepl('coal', as.character(dat_sourceClassifCodeTab$SCC.Level.Four), ignore.case = TRUE)) > 0
dat_sourceClassifCodeTab$matchComb <-
      (grepl('comb', as.character(dat_sourceClassifCodeTab$Short.Name), ignore.case = TRUE) +
      grepl('comb', as.character(dat_sourceClassifCodeTab$EI.Sector), ignore.case = TRUE) +
      grepl('comb', as.character(dat_sourceClassifCodeTab$SCC.Level.One), ignore.case = TRUE) +
      grepl('comb', as.character(dat_sourceClassifCodeTab$SCC.Level.Two), ignore.case = TRUE) +
      grepl('comb', as.character(dat_sourceClassifCodeTab$SCC.Level.Three), ignore.case = TRUE) +
      grepl('comb', as.character(dat_sourceClassifCodeTab$SCC.Level.Four), ignore.case = TRUE)) > 0
dat_sourceClassifCodeTab$matchCoalComb <- dat_sourceClassifCodeTab$matchCoal & 
      dat_sourceClassifCodeTab$matchComb
scc_coalComb <- dat_sourceClassifCodeTab$SCC[dat_sourceClassifCodeTab$matchCoalComb]

# Subset into PM 2.5 Emissions from Coal Combustion-related sources
dat <- dat_pm25Emissions[dat_pm25Emissions$SCC %in% scc_coalComb,][, c(4, 6)]

# Sum PM 2.5 Emissions by year
library(reshape2)
dat_melt <- melt(dat, id = "year")
dat_cast <- dcast(dat_melt, year ~ variable, sum)

# Plot to PNG file
library(ggplot2)
ggplot(dat_cast, aes(as.factor(year), Emissions / 1e3)) + 
      geom_bar(fill = 'orange') +
      theme(plot.title = element_text(size = rel(1))) +
      ggtitle(expression(paste("Total PM"[2.5],
      " Emissions in the United States, 1999-2008 from Coal Combustion-related sources"))) +
      xlab("Year") + ylab(expression(paste("Total PM"[2.5], " Emissions (thousand tons)")))
dev.copy(png, filename = "plot4.png", width = 600)
dev.off()