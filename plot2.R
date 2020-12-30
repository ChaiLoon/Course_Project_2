## Question2
## Have total emissions from PM2.5 decreased in the
## Baltimore City, Maryland (fips == "24510") 
## from 1999 to 2008? Use the base plotting system to make a plot answering this question.

# Load required libraries
library(dplyr)

# Initialise variables for subdirectory, zipfilename and zipfilepath
subDirectory <- "./data/"
zipFileName <- "exdata_data_NEI_data.zip"
zipFilePath <- paste0(subDirectory,zipFileName)
dataURL<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"

# Create subDirectory if doesn't exists.
if(!file.exists("data")) {
    dir.create("data")
}

# Dowload the zipFile of data if doesn't exists in the subDirectory
if(!file.exists(zipFilePath)){
    download.file(dataURL, zipFilePath, method="curl")
}

# Unzip the data zip file.
if (file.exists(zipFilePath)){
    unzip(zipFilePath, exdir = "./data")
}

# Initialise variables for the file path
summarySCC_PM25File <- "./data/summarySCC_PM25.rds"
SCCFile <- "./data/Source_Classification_Code.rds"

# Read rds files
NEI <- readRDS(summarySCC_PM25File)
SCC <- readRDS(SCCFile)

# Fetch BaltimoreCity's data
BaltimoreCity <- subset(NEI, fips=="24510")

# Evaluate total emission in Baltimorecity for year 1999, 2002, 2005 and 2008.
totalEmissionofBCByYear <- tapply(BaltimoreCity$Emissions, BaltimoreCity$year, sum)

# Constructing the plot
plot(names(totalEmissionofBCByYear), totalEmissionofBCByYear, type="l", xlab="Year",
    ylab= expression("Total" ~ PM[2.5] ~ "Emissions (tons)"),
    main= expression("Total Baltimore City" ~ PM[2.5] ~ "Emissions by Year"))

# Save plot2 as png file
dev.copy(device = png, filename="plot2.png", width=480, height=480)
dev.off()