# Again. Files corrupted. This script combines the EID + Age file to the different connections, allowing the code to work for the future. Basically, df2 files didn't have EID or Age, which are needed for GAMs. This script gives the wPLI (df2) the EID and Age (df1).

df1 <- read.csv("/Users/drydena18/Desktop/Par_Num_Age_Cluster.csv")
df2 <- read.csv("/Users/drydena18/Library/CloudStorage/OneDrive-OntarioTechUniversity/EEG_GAMs/Prepocessed_data/wPLI/between_group/gama/ant_r_ant_l_gama.csv", header = FALSE)

duplicates <- df2[duplicated(df2), ]

combined_df <- cbind(df1, df2)

head(combined_df)

names(combined_df)[names(combined_df) == "Sex..1...F..0...M."] <- "Sex"


write.csv(combined_df, "/Users/drydena18/Library/CloudStorage/OneDrive-OntarioTechUniversity/EEG_GAMs/Prepocessed_data/wPLI/between_group/gama/ant_r_ant_l_gama_age.csv")

