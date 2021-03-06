#setting the locale to US to correct my portuguese weekdays
Sys.setlocale("LC_ALL","English")

# Downloads the data set files
if(!file.exists("./data")){dir.create("./data")}
fileUrl<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileUrl,destfile="./data/Dataset.zip",method="auto")

# Extracts the dataset files
unzip(zipfile="./data/Dataset.zip",exdir="./data")

# Creates a path variable for the unzipped folder
dataPath <- file.path("./data")

#Read file to table
householdpower  <- read.table(file.path(dataPath, "household_power_consumption.txt" ), sep = ";", header = TRUE)

#Convert date
householdpower$Date <- as.Date(householdpower$Date, format="%d/%m/%Y")

#Clean data
householdpower<-householdpower[!(householdpower$Global_active_power=="?"),]   
householdpower<-householdpower[!(householdpower$Sub_metering_1=="?"),]
householdpower<-householdpower[!(householdpower$Sub_metering_2=="?"),]
householdpower<-householdpower[!(householdpower$Sub_metering_3=="?"),]
householdpower<-householdpower[!(householdpower$Voltage=="?"),]
householdpower<-householdpower[!(householdpower$Global_reactive_power=="?"),]

#subset 2 days
subsethhp <- householdpower[(householdpower$Date=="2007-02-01") | (householdpower$Date=="2007-02-02"),]

#convert numeric variables
subsethhp$Global_active_power <- as.numeric(as.character(subsethhp$Global_active_power))
subsethhp$Sub_metering_1 <- as.numeric(as.character(subsethhp$Sub_metering_1))
subsethhp$Sub_metering_2 <- as.numeric(as.character(subsethhp$Sub_metering_2))
subsethhp$Sub_metering_3 <- as.numeric(as.character(subsethhp$Sub_metering_3))

#Convert timestamp
subsethhp <- transform(subsethhp, timestamp=as.POSIXct(paste(Date, Time)), "%d/%m/%Y %H:%M:%S")

par(cex=.85,cex.axis=.85,cex.lab=.85)

#creates line graph
plot(subsethhp$timestamp,subsethhp$Sub_metering_1, type="l", xlab="", ylab="Energy sub metering")
lines(subsethhp$timestamp,subsethhp$Sub_metering_2,col="red")
lines(subsethhp$timestamp,subsethhp$Sub_metering_3,col="blue")
axis(2,at=c(0,10,20,30))
legend("topright",lty=c(1,1,1),col=c("black","red","blue"),
       legend=c("Sub_metering_1      ","Sub_metering_2      ","Sub_metering_3      "))

#Creates png file on the working directory
dev.copy(png, file = "plot3.png" , width=480, height=480)
dev.off()