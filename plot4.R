## Question4
## Across the United States, how have emissions from coal combustion-related 
## sources changed from 1999–2008?

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

# Fetch CoalCombustion-related source's data
CoalCombustion_SCC0 <- subset(SCC, EI.Sector %in% c("Fuel Comb - Comm/Instutional - Coal",
                                                    "Fuel Comb - Electric Generation - Coal",
                                                    "Fuel Comb - Industrial Boilers, ICEs - Coal"))

# Make comparison to Short.Name that matching both Comb and Coal
CoalCombustion_SCC1 <- subset(SCC, grepl("Comb", Short.Name) &
                                grepl("Coal", Short.Name))
            
print(paste("Number of subsetted lines via EI.Sector: ", nrow(CoalCombustion_SCC0)))
print(paste("Number of subsetted lines via Short.Name: ", nrow(CoalCombustion_SCC1)))

# Set the differences

diff_first <- setdiff(CoalCombustion_SCC0$SCC, CoalCombustion_SCC1$SCC)
diff_sec <- setdiff(CoalCombustion_SCC1$SCC, CoalCombustion_SCC0$SCC)

print(paste("Number of setdiff (data via EI.Sector & Short.Name): ", length(diff_first)))
print(paste("Number of setdiff (data via Short.Name & EI.Sector): ", length(diff_sec)))

# Union of SCCs through EI.Sector & Short.Name
CoalCombustion_SCC_Codes <- union(CoalCombustion_SCC0$SCC, CoalCombustion_SCC1$SCC)
print(paste("Number of SCCs:", length(CoalCombustion_SCC_Codes)))

# Fetch NEI data from SCCs
CoalCombustion <- subset(NEI,SCC %in% CoalCombustion_SCC_Codes)

# Evaluate total emission by type and year
totalCoalCombustionByYear <- CoalCombustion %>% select(year, type, Emissions) %>%
                                               group_by(year, type) %>%
                                               summarise_all(funs(sum))

# Constructing the plot
plot<-qplot(year, Emissions, data = totalCoalCombustionByYear, color = type, geom = "line") + 
  stat_summary(fun.y = "sum", fun.ymin = "sum", fun.ymax = "sum", color = "orange", aes(shape="total"), geom="line") +
  ggtitle(expression("Coal Combustion" ~ PM[2.5] ~ "Emissions by Source Type and Year")) + 
  xlab("Year") + 
  ylab(expression  ("Total" ~ PM[2.5] ~ "Emissions (tons)"))

# Constructing the plot
plot<-qplot(year, Emissions, data = totalCoalCombustionByYear, color = type, geom = "line") + 
  stat_summary(fun.y = "sum", aes(year, Emissions, color = "Total"), geom="line") +
  ggtitle(expression("Coal Combustion" ~ PM[2.5] ~ "Emissions by Source Type and Year")) + 
  xlab("Year") + 
  ylab(expression  ("Total" ~ PM[2.5] ~ "Emissions (tons)"))

# Save plot4 as png file
print(plot)
dev.copy(device = png, filename="plot4.png", width=480, height=480)
dev.off()