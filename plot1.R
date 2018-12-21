##############################################################################################
#                   golbal variables used in the script and load sqldf library               #
##############################################################################################

downloadUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
downloadFileName <- "powerdata.zip"
dataFileName <- "household_power_consumption.txt"
outputFile <- "plot1.png"

library(sqldf)

###############################################################################
#  download zip file if the data file and zip file do not already exist       #
#  in working directory. If data file does not exist then unzip the zip file  #                                                       #
###############################################################################

if(!file.exists(dataFileName))  {
  if(!file.exists(downloadFileName))  {
    download.file(downloadUrl,downloadFileName,method = "curl")
  }
  unzip(downloadFileName)
}

############################################################################################
#   Use sqldf to only load data related to the two dates in February in df dataframe.      #
#   This should address the issue of of having enough availble memory to load dataset.     #
#   Replace "?"s with NA and convert class of "Date" column to Date                        #
############################################################################################

fileCon <- file(dataFileName)

df <- sqldf("select * from fileCon where Date == '1/2/2007' OR Date == '2/2/2007'",
            file.format = list(header = TRUE, sep = ";"))

df[ df == "?" ] <- NA

df$Date <- as.Date(df$Date,"%d/%m/%Y")

####################################
#   Create plot and save to file   #
####################################

hist(df$Global_active_power,col = "red",main = "Global Active Power",xlab = "Global Active Power (kilowatts)")
dev.copy(png,file=outputFile)
dev.off()