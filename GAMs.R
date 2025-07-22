# Runs GAMs one-by-one for each connection. Don't use this one.

library(mgcv)
library(itsadug)
library(mgcViz)
library(sjPlot)
library(gratia)
library(dplyr)

Occ_R <- read.csv("/Users/drydena18/Library/CloudStorage/OneDrive-OntarioTechUniversity/EEG_GAMs/Prepocessed_data/wPLI/within_group/gama/occ_r_gama_age.csv")
Occ_L <- read.csv("/Users/drydena18/Library/CloudStorage/OneDrive-OntarioTechUniversity/EEG_GAMs/Prepocessed_data/wPLI/within_group/gama/occ_l_gama_age.csv")
Par_R <- read.csv("/Users/drydena18/Library/CloudStorage/OneDrive-OntarioTechUniversity/EEG_GAMs/Prepocessed_data/wPLI/within_group/gama/par_r_gama_age.csv")
Par_L <- read.csv("/Users/drydena18/Library/CloudStorage/OneDrive-OntarioTechUniversity/EEG_GAMs/Prepocessed_data/wPLI/within_group/gama/par_l_gama_age.csv")
Pos_R <- read.csv("/Users/drydena18/Library/CloudStorage/OneDrive-OntarioTechUniversity/EEG_GAMs/Prepocessed_data/wPLI/within_group/gama/pos_r_gama_age.csv")
Pos_L <- read.csv("/Users/drydena18/Library/CloudStorage/OneDrive-OntarioTechUniversity/EEG_GAMs/Prepocessed_data/wPLI/within_group/gama/pos_l_gama_age.csv")
Ant_R <- read.csv("/Users/drydena18/Library/CloudStorage/OneDrive-OntarioTechUniversity/EEG_GAMs/Prepocessed_data/wPLI/within_group/gama/ant_r_gama_age.csv")
Ant_L <- read.csv("/Users/drydena18/Library/CloudStorage/OneDrive-OntarioTechUniversity/EEG_GAMs/Prepocessed_data/wPLI/within_group/gama/ant_l_gama_age.csv")

#------gam_occ_r-----

names(Occ_R)
filt_occ_r <- Occ_R %>%
  filter(Age < 17)
gam_occ_r <- mgcv::gam(V1 ~ s(Age) + Sex, data = filt_occ_r, method = "REML")

set.seed(123)
gam.check(gam_occ_r)
summary(gam_occ_r)

plot_model(gam_occ_r, type = "pred", terms = "Age") +
  labs(
    title = "Right Occipital",
    y = "wPLI"
  )
plot_model(gam_occ_r, type = "pred", terms = "Sex..1...F..0...M.")

#No sig

#------gam_occ_l-----

names(Occ_L)[names(Occ_L) == "Sex..1...F..0...M."] <- "Sex"
filt_occ_l <- Occ_L %>%
  filter(Age < 17)
gam_occ_l <- mgcv::gam(V1 ~ s(Age) + Sex, data = filt_occ_l, method = "REML")

set.seed(123)
gam.check(gam_occ_l)
summary(gam_occ_l)

plot_model(gam_occ_l, type = "pred", terms = "Age") +
  labs(
    title = "Left Occipital",
    y = "wPLI"
  )
plot_model(gam_occ_l, type = "pred", terms = "Sex..1...F..0...M.")

#No sig

#----------Gam_Par_R------

names(Par_R)[names(Par_R) == "Sex..1...F..0...M."] <- "Sex"
filt_par_r <- Par_R %>%
  filter(Age < 17)
gam_par_r <- mgcv::gam(V1 ~ s(Age) + Sex, data = filt_par_r, method = "REML")

set.seed(123)
gam.check(gam_par_r)
summary(gam_par_r)

plot_model(gam_par_r, type = "pred", terms = "Age") +
  labs(
    title = "Right Parietal",
    y = "wPLI"
  )
plot_model(gam_par_r, type = "pred", terms = "Sex..1...F..0...M.")

#Significant

#-------gam_par_l------

names(Par_L)[names(Par_L) == "Sex..1...F..0...M."] <- "Sex"
filt_par_l <- Par_L %>%
  filter(Age < 17)
gam_par_l <- mgcv::gam(V1 ~ s(Age) + Sex, data = filt_par_l, method = "REML")

set.seed(123)
gam.check(gam_par_l)
summary(gam_par_l)

plot_model(gam_par_l, type = "pred", terms = "Age") +
  labs(
    title = "Left Parietal",
    y = "wPLI"
  )
plot_model(gam_par_l, type = "pred", terms = "Sex..1...F..0...M.")

#No Sig

#--------gam_pos_r------

names(Pos_R)[names(Pos_R) == "Sex..1...F..0...M."] <- "Sex"
filt_pos_r <- Pos_R %>%
  filter(Age < 17)
gam_pos_r <- mgcv::gam(V1 ~ s(Age) + Sex, data = filt_pos_r, method = "REML")

set.seed(123)
gam.check(gam_pos_r)
summary(gam_pos_r)

plot_model(gam_pos_r, type = "pred", terms = "Age") +
  labs(
    title = "Right Temporal",
    y = "wPLI"
  )
plot_model(gam_pos_r, type = "pred", terms = "Sex..1...F..0...M.")

#No sig
#Significant when filtered

#-------gam_pos_l------

names(Pos_L)[names(Pos_L) == "Sex..1...F..0...M."] <- "Sex"
filt_pos_l <- Pos_L %>%
  filter(Age < 17)
gam_pos_l <- mgcv::gam(V1 ~ s(Age) + Sex, data = filt_pos_l, method = "REML")

set.seed(123)
gam.check(gam_pos_l)
summary(gam_pos_l)

plot_model(gam_pos_l, type = "pred", terms = "Age") +
  labs(
    title = "Left Temporal",
    y = "wPLI"
  )
plot_model(gam_pos_l, type = "pred", terms = "Sex..1...F..0...M.")

#No sig


#-------gam_ant_r------

names(Ant_R)[names(Ant_R) == "Sex..1...F..0...M."] <- "Sex"
filt_ant_r <- Ant_R %>%
  filter(Age < 17)
gam_ant_r <- mgcv::gam(V1 ~ s(Age) + Sex, data = filt_ant_r, method = "REML")

set.seed(123)
gam.check(gam_ant_r)
summary(gam_ant_r)

plot_model(gam_ant_r, type = "pred", terms = "Age") +
  labs(
    title = "Right Frontal",
    y = "wPLI"
  )
plot_model(gam_ant_r, type = "pred", terms = "Sex..1...F..0...M.")

#No sig

#-------gam_ant_l-------

names(Ant_L)[names(Ant_L) == "Sex..1...F..0...M."] <- "Sex"
filt_ant_l <- Ant_L %>%
  filter(Age < 17)
gam_ant_l <- mgcv::gam(V1 ~ s(Age, k = 10) + Sex, data = filt_ant_l, method = "REML")

set.seed(123)
gam.check(gam_ant_l)
summary(gam_ant_l)

plot_model(gam_ant_l, type = "pred", terms = "Age") +
  labs(
    title = "Left Frontal",
    y = "wPLI"
  )
plot_model(gam_ant_l, type = "pred", terms = "Sex")

#No sig

#plot_model(gam_ant_l, type = "pred", terms = c("Age", "Sex..1...F..0...M."))

# plot_diff(gam_ant_l, view = "Age", comp = list(sex = c("male", "female")))

#draw(gam_ant_l, residuals = TRUE)
