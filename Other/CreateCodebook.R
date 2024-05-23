
Codebook <- read.csv("/Users/annalangener/projects/QualitativeVis/Skimina_new_manual.csv")[-1]

c1 <- data.frame(Code = Codebook$source, Level= Codebook$level_source)
c2 <- data.frame(Code = Codebook$target, Level= Codebook$level_target)

Codebook <- rbind(c1,c2)
Codebook <- Codebook[!duplicated(Codebook),]
Codebook <- Codebook[Codebook$Level != 4,]

write.csv(Codebook,"Codebook_Skiminiaetal.csv")
