library("broom")
library("rgl")
library("tidyverse")
library("ggplot2")
library("dplyr")
library("boot")
library("Hmisc")
library("patchwork")
library("car")

matched <- read.csv("/Users/drydenarseneau/Desktop/GAMs_EEG_Development_HBN/Matched_EIDAGE/Matched_EIDAGE_Release_10.csv")
matched.1 <- read.csv("/Users/drydenarseneau/Desktop/GAMs_EEG_Development_HBN/Matched_EIDAGE/Matched_EIDAGE_Release_10.1.csv")

matched_participants <- intersect(matched$EID, matched.1$EID)

matched_data <- matched %>%
  filter(EID %in% matched_participants) %>%
  select(EID, Age, Sex, EHQ_Total, Use)

write.csv(matched_data, "/Users/drydenarseneau/Desktop/GAMs_EEG_Development_HBN/Matched_EIDAGE/Matched_EIDAGE_Release_10.2.csv", row.names = FALSE)
