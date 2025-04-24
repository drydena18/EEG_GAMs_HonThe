data <- read.csv("/Users/drydena18/Library/CloudStorage/OneDrive-OntarioTechUniversity/EEG_GAMs/Prepocessed_data/wPLI/within_group/alpha/occ_r_alpha_age.csv")

library(dplyr)

data <- data %>%
  mutate(Age = floor(Age))

data <- data %>%
  filter(Age < 17)

Bar <- ggplot(data, aes(x = factor(Age), fill = factor(Sex)))+
  geom_bar() +
  labs(x = "Age", y = "Participants", title = "Participant Sex/Age Distribution") +
  scale_fill_manual(values = c("0" = "blue", "1" = "pink"), name = "Sex", labels = c("Male", "Female" )) +
  theme_minimal()



Bar

mean(data$Age)

library(psych)
desc_stats <- describe(data)
print(desc_stats)
