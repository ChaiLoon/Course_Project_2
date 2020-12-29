## Question1
## Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? Using the base plotting system, make a plot showing the total PM2.5 emission from all sources for each of the years 
## 1999, 2002, 2005, and 2008.

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

# Evaluate total emission for year 1999, 2002, 2005 and 2008.
totalEmissionByYear <- tapply(NEI$Emissions, NEI$year, sum)

# Constructing plot1
plot(names(totalEmissionByYear), totalEmissionByYear, type="l", xlab="Year", ylab= expression("Total"~ PM[2.5] ~ "Emissions (tons)"), main= expression("Total US" ~ PM[2.5] ~ "Emissions by Year") )

# Save plot1 as png file
dev.copy(device = png, filename="plot1.png", width=480, height=480)
dev.off()