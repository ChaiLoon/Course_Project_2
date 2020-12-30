## Question6
## Compare emissions from motor vehicle sources in Baltimore City 
## with emissions from motor vehicle sources 
## in Los Angeles County, California (fips == "06037"). 
## Which city has seen greater changes over time in motor vehicle emissions?

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

# Fetch type ON-ROAD data from Baltimore City & Los Angeles County, California
motorVehicleSource <- subset(NEI, (fips == "24510" | fips == "06037")& type=="ON-ROAD")

# Replace the fips number from the data with the county's names
motorVehicleSource <- transform(motorVehicleSource, region = ifelse(fips == "24510", "Baltimore City", "Los Angeles County"))

# Evaluate the total emission from motor vehicle by year and region 
totalMVEmissionByRegionYear<-motorVehicleSource  %>% select (year, region, Emissions) %>%
                                group_by(year, region) %>%
                                summarise_all(funs(sum))

# To better show change over time, create a plot normalized to 1999 levels
BaltimoreEmissions1999 <- subset(totalMVEmissionByRegionYear, year ==1999 & region =="Baltimore City")$Emissions

LACEmissions1999 <- subset(totalMVEmissionByRegionYear, year== 1999 & region == "Los Angeles County")$Emissions

totalMVEmissionByRegionYearNorm <- transform(totalMVEmissionByRegionYear, 
                                            EmissionsNorm = ifelse(region ==
                                                                        "Baltimore City",
                                                                        Emissions / BaltimoreEmissions1999,
                                                                        Emissions / LACEmissions1999))

# Constructing the plot
plot<- qplot(year, EmissionsNorm, data=totalMVEmissionByRegionYearNorm, geom="line", color=region) +
  ggtitle(expression("Total" ~ PM[2.5] ~ "Motor Vehicle Emissions Normalized to 1999 Levels")) + 
  xlab("Year") +
  ylab(expression("Normalized" ~ PM[2.5] ~ "Emissions"))

# Save plot6 as png file
print(plot)
dev.copy(device = png, filename = "plot6.png", width = 480, height= 480)
dev.off()