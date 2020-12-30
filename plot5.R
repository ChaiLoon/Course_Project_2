## Question5
## How have emissions from motor vehicle sources changed from 
## 1999–2008 in Baltimore City?

# Load required libraries
library(dplyr)
library(ggplot2)

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

# Fetch BaltimoreCity's and ON-ROAD data
mvBaltimoreCity <- subset(NEI, fips == "24510" & type == "ON-ROAD")

# Evaluate the total emission from motor vehicle sources by year
totalMVEmissionBCByYear <- mvBaltimoreCity %>% select(year, Emissions) %>%
                                            group_by(year) %>%
                                            summarise_all(funs(sum))

# Constructing the plot
plot<- qplot(year, Emissions, data=totalMVEmissionBCByYear, geom = "line" ) +
    ggtitle(expression("Baltimore City" ~ PM[2.5] ~ "Motor Vehicles Emissions By Year"))+
    xlab("Year") +
    ylab(expression("Total" ~ PM[2.5] ~ "Emissions (tons)"))

# Save plot5 as png file
print(plot)
dev.copy(device = png, filename = "plot5.png", width = 480, height= 480)
dev.off()