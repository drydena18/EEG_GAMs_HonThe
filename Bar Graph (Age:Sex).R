library(tidyverse)
library(dplyr)
library(ggplot2)
library("plotly")

Phenotypic = read.csv('/Users/drydenarseneau/Desktop/GAMs_EEG_Development_HBN/Matched_EIDAGE/Matched_EIDAGE_Release_10.1.csv')

highlighted_data <- subset(Phenotypic, Use. %in% c("Yes", "Maybe"))

Bar <- ggplot(highlighted_data, aes(x = factor(Age.Rounded), fill = factor(Sex..1...F..0...M.)))+
  geom_bar() +
  labs(x = "Age", y = "Count", title = "Highlighted Ages by Sex") +
  scale_fill_manual(values = c("0" = "blue", "1" = "pink"), name = "Sex", labels = c("Male", "Female" )) +
  theme_minimal()

interactive_plot <- ggplotly(Bar)

interactive_plot

list(highlighted_data$EID)

mean(highlighted_data$Age)

extracted <- highlighted_data %>%
  select(Age, Sex..1...F..0...M.)

age_stats <- extracted %>%
  group_by(Sex..1...F..0...M.) %>%
  summarize(
    Mean_Age = mean(Age, na.rm = TRUE),
    SD_Age = sd(Age, na.rm = TRUE)
  )
    
print(age_stats)
  
