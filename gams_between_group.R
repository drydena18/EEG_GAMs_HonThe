library(mgcv)
library(itsadug)
library(mgcViz)
library(sjPlot)
library(gratia)
library(dplyr)

occ_r_occ_l <- read.csv("/Users/drydena18/Library/CloudStorage/OneDrive-OntarioTechUniversity/EEG_GAMs/Prepocessed_data/wPLI/between_group/gama/occ_r_occ_l_gama_age.csv")
occ_r_par_r <- read.csv("/Users/drydena18/Library/CloudStorage/OneDrive-OntarioTechUniversity/EEG_GAMs/Prepocessed_data/wPLI/between_group/gama/occ_r_par_r_gama_age.csv")
occ_r_par_l <- read.csv("/Users/drydena18/Library/CloudStorage/OneDrive-OntarioTechUniversity/EEG_GAMs/Prepocessed_data/wPLI/between_group/gama/occ_r_par_l_gama_age.csv")
occ_r_pos_r <- read.csv("/Users/drydena18/Library/CloudStorage/OneDrive-OntarioTechUniversity/EEG_GAMs/Prepocessed_data/wPLI/between_group/gama/occ_r_pos_r_gama_age.csv")
occ_r_pos_l <- read.csv("/Users/drydena18/Library/CloudStorage/OneDrive-OntarioTechUniversity/EEG_GAMs/Prepocessed_data/wPLI/between_group/gama/occ_r_pos_l_gama_age.csv")
occ_r_ant_r <- read.csv("/Users/drydena18/Library/CloudStorage/OneDrive-OntarioTechUniversity/EEG_GAMs/Prepocessed_data/wPLI/between_group/gama/occ_r_ant_r_gama_age.csv")
occ_r_ant_l <- read.csv("/Users/drydena18/Library/CloudStorage/OneDrive-OntarioTechUniversity/EEG_GAMs/Prepocessed_data/wPLI/between_group/gama/occ_r_ant_l_gama_age.csv")
occ_l_par_r <- read.csv("/Users/drydena18/Library/CloudStorage/OneDrive-OntarioTechUniversity/EEG_GAMs/Prepocessed_data/wPLI/between_group/gama/occ_l_par_r_gama_age.csv")
occ_l_par_l <- read.csv("/Users/drydena18/Library/CloudStorage/OneDrive-OntarioTechUniversity/EEG_GAMs/Prepocessed_data/wPLI/between_group/gama/occ_l_par_l_gama_age.csv")
occ_l_pos_r <- read.csv("/Users/drydena18/Library/CloudStorage/OneDrive-OntarioTechUniversity/EEG_GAMs/Prepocessed_data/wPLI/between_group/gama/occ_l_pos_r_gama_age.csv")
occ_l_pos_l <- read.csv("/Users/drydena18/Library/CloudStorage/OneDrive-OntarioTechUniversity/EEG_GAMs/Prepocessed_data/wPLI/between_group/gama/occ_l_pos_l_gama_age.csv")
occ_l_ant_r <- read.csv("/Users/drydena18/Library/CloudStorage/OneDrive-OntarioTechUniversity/EEG_GAMs/Prepocessed_data/wPLI/between_group/gama/occ_l_ant_r_gama_age.csv")
occ_l_ant_l <- read.csv("/Users/drydena18/Library/CloudStorage/OneDrive-OntarioTechUniversity/EEG_GAMs/Prepocessed_data/wPLI/between_group/gama/occ_l_ant_l_gama_age.csv")
par_r_par_l <- read.csv("/Users/drydena18/Library/CloudStorage/OneDrive-OntarioTechUniversity/EEG_GAMs/Prepocessed_data/wPLI/between_group/gama/par_r_par_l_gama_age.csv")
par_r_pos_r <- read.csv("/Users/drydena18/Library/CloudStorage/OneDrive-OntarioTechUniversity/EEG_GAMs/Prepocessed_data/wPLI/between_group/gama/par_r_pos_r_gama_age.csv")
par_r_pos_l <- read.csv("/Users/drydena18/Library/CloudStorage/OneDrive-OntarioTechUniversity/EEG_GAMs/Prepocessed_data/wPLI/between_group/gama/par_r_pos_l_gama_age.csv")
par_r_ant_r <- read.csv("/Users/drydena18/Library/CloudStorage/OneDrive-OntarioTechUniversity/EEG_GAMs/Prepocessed_data/wPLI/between_group/gama/par_r_ant_r_gama_age.csv")
par_r_ant_l <- read.csv("/Users/drydena18/Library/CloudStorage/OneDrive-OntarioTechUniversity/EEG_GAMs/Prepocessed_data/wPLI/between_group/gama/par_r_ant_l_gama_age.csv")
par_l_pos_r <- read.csv("/Users/drydena18/Library/CloudStorage/OneDrive-OntarioTechUniversity/EEG_GAMs/Prepocessed_data/wPLI/between_group/gama/par_l_pos_r_gama_age.csv")
par_l_pos_l <- read.csv("/Users/drydena18/Library/CloudStorage/OneDrive-OntarioTechUniversity/EEG_GAMs/Prepocessed_data/wPLI/between_group/gama/par_l_pos_l_gama_age.csv")
par_l_ant_r <- read.csv("/Users/drydena18/Library/CloudStorage/OneDrive-OntarioTechUniversity/EEG_GAMs/Prepocessed_data/wPLI/between_group/gama/par_l_ant_r_gama_age.csv")
par_l_ant_l <- read.csv("/Users/drydena18/Library/CloudStorage/OneDrive-OntarioTechUniversity/EEG_GAMs/Prepocessed_data/wPLI/between_group/gama/par_l_ant_l_gama_age.csv")
pos_r_pos_l <- read.csv("/Users/drydena18/Library/CloudStorage/OneDrive-OntarioTechUniversity/EEG_GAMs/Prepocessed_data/wPLI/between_group/gama/pos_r_pos_l_gama_age.csv")
pos_r_ant_r <- read.csv("/Users/drydena18/Library/CloudStorage/OneDrive-OntarioTechUniversity/EEG_GAMs/Prepocessed_data/wPLI/between_group/gama/pos_r_ant_r_gama_age.csv")
pos_r_ant_l <- read.csv("/Users/drydena18/Library/CloudStorage/OneDrive-OntarioTechUniversity/EEG_GAMs/Prepocessed_data/wPLI/between_group/gama/pos_r_ant_l_gama_age.csv")
pos_l_ant_r <- read.csv("/Users/drydena18/Library/CloudStorage/OneDrive-OntarioTechUniversity/EEG_GAMs/Prepocessed_data/wPLI/between_group/gama/pos_l_ant_r_gama_age.csv")
pos_l_ant_l <- read.csv("/Users/drydena18/Library/CloudStorage/OneDrive-OntarioTechUniversity/EEG_GAMs/Prepocessed_data/wPLI/between_group/gama/pos_l_ant_l_gama_age.csv")
ant_r_ant_l <- read.csv("/Users/drydena18/Library/CloudStorage/OneDrive-OntarioTechUniversity/EEG_GAMs/Prepocessed_data/wPLI/between_group/gama/ant_r_ant_l_gama_age.csv")

#---------occ_r_occ_l-------

filt_occ_r_occ_l <- occ_r_occ_l %>%
  filter(Age < 17)
gam_occ_r_occ_l <- mgcv::gam(V1 ~ s(Age) + Sex, data = filt_occ_r_occ_l, method = "REML")

set.seed(123)
gam.check(gam_occ_r_occ_l)
summary(gam_occ_r_occ_l)

plot_model(gam_occ_r_occ_l, type = "pred", terms = "Age") +
  labs(
    title = "Right Occipital + Left Occipital",
    y = "wPLI"
  )

#-------occ_r_par_r------

filt_occ_r_par_r <- occ_r_par_r %>%
  filter(Age < 17)
gam_occ_r_par_r <- mgcv::gam(V1 ~ s(Age) + Sex, data = filt_occ_r_par_r, method = "REML")

set.seed(123)
gam.check(gam_occ_r_par_r)
summary(gam_occ_r_par_r)

plot_model(gam_occ_r_par_r, type = "pred", terms = "Age") +
  labs(
    title = "Right Occipital + Right Parietal",
    y = "wPLI"
  )

#---------occ_r_par_l-------

filt_occ_r_par_l <- occ_r_par_l %>%
  filter(Age < 17)
gam_occ_r_par_l <- mgcv::gam(V1 ~ s(Age) + Sex, data = filt_occ_r_par_l, method = "REML")

set.seed(123)
gam.check(gam_occ_r_par_l)
summary(gam_occ_r_par_l)

plot_model(gam_occ_r_par_l, type = "pred", terms = "Age") +
  labs(
    title = "Right Occipital + Left Parietal",
    y = "wPLI"
  )

#----------occ_r_pos_r-----------

filt_occ_r_pos_r <- occ_r_pos_r %>%
  filter(Age < 17)
gam_occ_r_pos_r <- mgcv::gam(V1 ~ s(Age) + Sex, data = filt_occ_r_pos_r, method = "REML")

set.seed(123)
gam.check(gam_occ_r_pos_r)
summary(gam_occ_r_pos_r)

plot_model(gam_occ_r_pos_r, type = "pred", terms = "Age") +
  labs(
    title = "Right Occipital + Right Temporal",
    y = "wPLI"
  )

#----------occ_r_pos_l--------

filt_occ_r_pos_l <- occ_r_pos_l %>%
  filter(Age < 17)
gam_occ_r_pos_l <- mgcv::gam(V1 ~ s(Age) + Sex, data = filt_occ_r_pos_l, method = "REML")

set.seed(123)
gam.check(gam_occ_r_pos_l)
summary(gam_occ_r_pos_l)

plot_model(gam_occ_r_pos_l, type = "pred", terms = "Age") +
  labs(
    title = "Right Occipital + Left Temporal",
    y = "wPLI"
  )

#---------occ_r_ant_r------

filt_occ_r_ant_r <- occ_r_ant_r %>%
  filter(Age < 17)
gam_occ_r_ant_r <- mgcv::gam(V1 ~ s(Age) + Sex, data = filt_occ_r_ant_r, method = "REML")

set.seed(123)
gam.check(gam_occ_r_ant_r)
summary(gam_occ_r_ant_r)

plot_model(gam_occ_r_ant_r, type = "pred", terms = "Age") +
  labs(
    title = "Right Occipital + Right Frontal",
    y = "wPLI"
  )

#--------occ_r_ant_l------

filt_occ_r_ant_l <- occ_r_ant_l %>%
  filter(Age < 17)
gam_occ_r_ant_l <- mgcv::gam(V1 ~ s(Age) + Sex, data = filt_occ_r_ant_l, method = "REML")

set.seed(123)
gam.check(gam_occ_r_ant_l)
summary(gam_occ_r_ant_l)

plot_model(gam_occ_r_ant_l, type = "pred", terms = "Age") +
  labs(
    title = "Right Occipital + Left Frontal",
    y = "wPLI"
  )

#-------occ_l_par_r------

filt_occ_l_par_r <- occ_l_par_r %>%
  filter(Age < 17)
gam_occ_l_par_r <- mgcv::gam(V1 ~ s(Age) + Sex, data = filt_occ_l_par_r, method = "REML")

set.seed(123)
gam.check(gam_occ_l_par_r)
summary(gam_occ_l_par_r)

plot_model(gam_occ_l_par_r, type = "pred", terms = "Age") +
  labs(
    title = "Left Occipital + Right Parietal",
    y = "wPLI"
  )

#--------occ_l_par_l------

filt_occ_l_par_l <- occ_l_par_l %>%
  filter(Age < 17)
gam_occ_l_par_l <- mgcv::gam(V1 ~ s(Age) + Sex, data = filt_occ_l_par_l, method = "REML")

set.seed(123)
gam.check(gam_occ_l_par_l)
summary(gam_occ_l_par_l)

plot_model(gam_occ_l_par_l, type = "pred", terms = "Age") +
  labs(
    title = "Left Occipital + Left Parietal",
    y = "wPLI"
  )

#---------occ_l_pos_r------

filt_occ_l_pos_r <- occ_l_pos_r %>%
  filter(Age < 17)
gam_occ_l_pos_r <- mgcv::gam(V1 ~ s(Age) + Sex, data = filt_occ_l_pos_r, method = "REML")

set.seed(123)
gam.check(gam_occ_l_pos_r)
summary(gam_occ_l_pos_r)

plot_model(gam_occ_l_pos_r, type = "pred", terms = "Age") +
  labs(
    title = "Left Occipital + Right Temporal",
    y = "wPLI"
  )

#-------occ_l_pos_l-------

filt_occ_l_pos_l <- occ_l_pos_l %>%
  filter(Age < 17)
gam_occ_l_pos_l <- mgcv::gam(V1 ~ s(Age) + Sex, data = filt_occ_l_pos_l, method = "REML")

set.seed(123)
gam.check(gam_occ_l_pos_l)
summary(gam_occ_l_pos_l)

plot_model(gam_occ_l_pos_l, type = "pred", terms = "Age") +
  labs(
    title = "Left Occipital + Left Temporal",
    y = "wPLI"
  )

#---------occ_l_ant_r-----

filt_occ_l_ant_r <- occ_l_ant_r %>%
  filter(Age < 17)
gam_occ_l_ant_r <- mgcv::gam(V1 ~ s(Age) + Sex, data = filt_occ_l_ant_r, method = "REML")

set.seed(123)
gam.check(gam_occ_l_ant_r)
summary(gam_occ_l_ant_r)

plot_model(gam_occ_l_ant_r, type = "pred", terms = "Age") +
  labs(
    title = "Left Occipital + Right Frontal",
    y = "wPLI"
  )

#--------occ_l_ant_l------

filt_occ_l_ant_l <- occ_l_ant_l %>%
  filter(Age < 17)
gam_occ_l_ant_l <- mgcv::gam(V1 ~ s(Age) + Sex, data = filt_occ_l_ant_l, method = "REML")

set.seed(123)
gam.check(gam_occ_l_ant_l)
summary(gam_occ_l_ant_l)

plot_model(gam_occ_l_ant_l, type = "pred", terms = "Age") +
  labs(
    title = "Left Occipital + Left Frontal",
    y = "wPLI"
  )

#-------par_r_par_l------

filt_par_r_par_l <- par_r_par_l %>%
  filter(Age < 17)
gam_par_r_par_l <- mgcv::gam(V1 ~ s(Age) + Sex, data = filt_par_r_par_l, method = "REML")

set.seed(123)
gam.check(gam_par_r_par_l)
summary(gam_par_r_par_l)

plot_model(gam_par_r_par_l, type = "pred", terms = "Age") +
  labs(
    title = "Right Parietal + Left Parietal",
    y = "wPLI"
  )

#Significant

#-------par_r_pos_r--------

filt_par_r_pos_r <- par_r_pos_r %>%
  filter(Age < 17)
gam_par_r_pos_r <- mgcv::gam(V1 ~ s(Age) + Sex, data = filt_par_r_pos_r, method = "REML")

set.seed(123)
gam.check(gam_par_r_pos_r)
summary(gam_par_r_pos_r)

plot_model(gam_par_r_pos_r, type = "pred", terms = "Age") +
  labs(
    title = "Right Parietal + Right Temporal",
    y = "wPLI"
  )

#Significant

#-------par_r_pos_l-------

filt_par_r_pos_l <- par_r_pos_l %>%
  filter(Age < 17)
gam_par_r_pos_l <- mgcv::gam(V1 ~ s(Age) + Sex, data = filt_par_r_pos_l, method = "REML")

set.seed(123)
gam.check(gam_par_r_pos_l)
summary(gam_par_r_pos_l)

plot_model(gam_par_r_pos_l, type = "pred", terms = "Age") +
  labs(
    title = "Right Parietal + Left Temporal",
    y = "wPLI"
  )

#---------par_r_ant_r-------

filt_par_r_ant_r <- par_r_ant_r %>%
  filter(Age < 17)
gam_par_r_ant_r <- mgcv::gam(V1 ~ s(Age) + Sex, data = filt_par_r_ant_r, method = "REML")

set.seed(123)
gam.check(gam_par_r_ant_r)
summary(gam_par_r_ant_r)

plot_model(gam_par_r_ant_r, type = "pred", terms = "Age") +
  labs(
    title = "Right Parietal + Right Frontal",
    y = "wPLI"
  )

#Significant

#---------par_r_ant_l-------

filt_par_r_ant_l <- par_r_ant_l %>%
  filter(Age < 17)
gam_par_r_ant_l <- mgcv::gam(V1 ~ s(Age) + Sex, data = filt_par_r_ant_l, method = "REML")

set.seed(123)
gam.check(gam_par_r_ant_l)
summary(gam_par_r_ant_l)

plot_model(gam_par_r_ant_l, type = "pred", terms = "Age") +
  labs(
    title = "Right Parietal + Left Frontal",
    y = "wPLI"
  )

#------par_l_pos_r-------

filt_par_l_pos_r <- par_l_pos_r %>%
  filter(Age < 17)
gam_par_l_pos_r <- mgcv::gam(V1 ~ s(Age) + Sex, data = filt_par_l_pos_r, method = "REML")

set.seed(123)
gam.check(gam_par_l_pos_r)
summary(gam_par_l_pos_r)

plot_model(gam_par_l_pos_r, type = "pred", terms = "Age") +
  labs(
    title = "Left Parietal + Right Temporal",
    y = "wPLI"
  )

#-----par_l_pos_l-------

filt_par_l_pos_l <- par_l_pos_l %>%
  filter(Age < 17)
gam_par_l_pos_l <- mgcv::gam(V1 ~ s(Age) + Sex, data = filt_par_l_pos_l, method = "REML")

set.seed(123)
gam.check(gam_par_l_pos_l)
summary(gam_par_l_pos_l)

plot_model(gam_par_l_pos_l, type = "pred", terms = "Age") +
  labs(
    title = "Left Parietal + Left Temporal",
    y = "wPLI"
  )

#-------par_l_ant_r--------

filt_par_l_ant_r <- par_l_ant_r %>%
  filter(Age < 17)
gam_par_l_ant_r <- mgcv::gam(V1 ~ s(Age) + Sex, data = filt_par_l_ant_r, method = "REML")

set.seed(123)
gam.check(gam_par_l_ant_r)
summary(gam_par_l_ant_r)

plot_model(gam_par_l_ant_r, type = "pred", terms = "Age") +
  labs(
    title = "Left Parietal + Right Frontal",
    y = "wPLI"
  )

#-------par_l_ant_l-------

filt_par_l_ant_l <- par_l_ant_l %>%
  filter(Age < 17)
gam_par_l_ant_l <- mgcv::gam(V1 ~ s(Age) + Sex, data = filt_par_l_ant_l, method = "REML")

set.seed(123)
gam.check(gam_par_l_ant_l)
summary(gam_par_l_ant_l)

plot_model(gam_par_l_ant_l, type = "pred", terms = "Age") +
  labs(
    title = "Left Parietal + Left Frontal",
    y = "wPLI"
  )

#-------pos_r_pos_l--------

filt_pos_r_pos_l <- pos_r_pos_l %>%
  filter(Age < 17)
gam_pos_r_pos_l <- mgcv::gam(V1 ~ s(Age) + Sex, data = filt_pos_r_pos_l, method = "REML")

set.seed(123)
gam.check(gam_pos_r_pos_l)
summary(gam_pos_r_pos_l)

plot_model(gam_pos_r_pos_l, type = "pred", terms = "Age") +
  labs(
    title = "Right Temporal + Left Temporal",
    y = "wPLI"
  )

#--------pos_r_ant_r-------

filt_pos_r_ant_r <- pos_r_ant_r %>%
  filter(Age < 17)
gam_pos_r_ant_r <- mgcv::gam(V1 ~ s(Age) + Sex, data = filt_pos_r_ant_r, method = "REML")

set.seed(123)
gam.check(gam_pos_r_ant_r)
summary(gam_pos_r_ant_r)

plot_model(gam_pos_r_ant_r, type = "pred", terms = "Age") +
  labs(
    title = "Right Temporal + Right Frontal",
    y = "wPLI"
  )

#--------pos_r_ant_l-------

filt_pos_r_ant_l <- pos_r_ant_l %>%
  filter(Age < 17)
gam_pos_r_ant_l <- mgcv::gam(V1 ~ s(Age) + Sex, data = filt_pos_r_ant_l, method = "REML")

set.seed(123)
gam.check(gam_pos_r_ant_l)
summary(gam_pos_r_ant_l)

plot_model(gam_pos_r_ant_l, type = "pred", terms = "Age") +
  labs(
    title = "Right Temporal + Left Frontal",
    y = "wPLI"
  )

#-------pos_l_ant_r-------

filt_pos_l_ant_r <- pos_l_ant_r %>%
  filter(Age < 17)
gam_pos_l_ant_r <- mgcv::gam(V1 ~ s(Age) + Sex, data = filt_pos_l_ant_r, method = "REML")

set.seed(123)
gam.check(gam_pos_l_ant_r)
summary(gam_pos_l_ant_r)

plot_model(gam_pos_l_ant_r, type = "pred", terms = "Age") +
  labs(
    title = "Left Temporal + Right Frontal",
    y = "wPLI"
  )

#--------pos_l_ant_l-------

filt_pos_l_ant_l <- pos_l_ant_l %>%
  filter(Age < 17)
gam_pos_l_ant_l <- mgcv::gam(V1 ~ s(Age) + Sex, data = filt_pos_l_ant_l, method = "REML")

set.seed(123)
gam.check(gam_pos_l_ant_l)
summary(gam_pos_l_ant_l)

plot_model(gam_pos_l_ant_l, type = "pred", terms = "Age") +
  labs(
    title = "Left Temporal + Left Frontal",
    y = "wPLI"
  )

##-------ant_r_ant_l-------

filt_ant_r_ant_l <- ant_r_ant_l %>%
  filter(Age < 17)
gam_ant_r_ant_l <- mgcv::gam(V1 ~ s(Age) + Sex, data = filt_ant_r_ant_l, method = "REML")

set.seed(123)
gam.check(gam_ant_r_ant_l)
summary(gam_ant_r_ant_l)

plot_model(gam_ant_r_ant_l, type = "pred", terms = "Age") +
  labs(
    title = "Right Frontal + Left Frontal",
    y = "wPLI"
  )

