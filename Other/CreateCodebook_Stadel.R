library(tidyr)


Data <- read.csv("/Users/annalangener/Nextcloud/Shared/Testing Methods to Capture Social Context/Qualitative context/3. Coding/QualitativeCoding_Activies/Visualized Tree.csv")[c(1,2,5,6)]

Source <- Data[,c(1,3)]
Target <- Data[,c(2,4)]

colnames(Source) <- c("Code","Level")
colnames(Target) <- c("Code","Level")

Data <- rbind(Source, Target)

Data <- unique(Data)

#Data <- Data[Data$Level != 4,]
             
write.csv(Data,"/Users/annalangener/Nextcloud/Shared/Testing Methods to Capture Social Context/Qualitative context/3. Coding/QualitativeCoding_Activies/Overview_Codes.csv")
