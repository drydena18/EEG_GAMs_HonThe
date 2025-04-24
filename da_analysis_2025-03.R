## use ALT + O (windows) or opt + comd + o (mac) to collapse sections
library(haven)
library("tidyverse")
library("mgcv")                 ## main GAM package 
library("mgcViz")              ## GAM visualization tools
library("gratia")              ## GAM visualization tools
library("itsadug")             ## GAM visualization tools
library("sjPlot")
library("visreg")
library(ggthemes)
library(see)
library(ggplot2)
library("ggeffects")

###################################   CLEANING DATA  #######################################################################

data_mat <- read.csv("/Users/drydena18/Library/CloudStorage/OneDrive-OntarioTechUniversity/EEG_GAMs/Prepocessed_data/wPLI/CombinedMatrix_bb.csv", header = FALSE)
colnames(data_mat) <- c(
  "Occipital_Right_Occipital_Right",          "Occipital_Right_Occipital_Left",
  "Occipital_Right_Parietal_Right",           "Occipital_Right_Parietal_Left",
  "Occipital_Right_Temporal_Right",           "Occipital_Right_Temporal_Left",
  "Occipital_Right_Frontal_Right",            "Occipital_Right_Frontal_Left",
  "Occipital_Left_Occipital_Left",            "Occipital_Left_Parietal_Right",
  "Occipital_Left_Parietal_Left",             "Occipital_Left_Temporal_Right",
  "Occipital_Left_Temporal_Left",             "Occipital_Left_Frontal_Right",
  "Occipital_Left_Frontal_Left",              "Parietal_Right_Parietal_Right",
  "Parietal_Right_Parietal_Left",             "Parietal_Right_Temporal_Right",
  "Parietal_Right_Temporal_Left",             "Parietal_Right_Frontal_Right",
  "Parietal_Right_Frontal_Left",              "Parietal_Left_Parietal_Left",
  "Parietal_Left_Temporal_Right",             "Parietal_Left_Temporal_Left",
  "Parietal_Left_Frontal_Right",              "Parietal_Left_Frontal_Left",
  "Temporal_Right_Temporal_Right",            "Temporal_Right_Temporal_Left",
  "Temporal_Right_Frontal_Right",             "Temporal_Right_Frontal_Left",
  "Temporal_Left_Temporal_Left",              "Temporal_Left_Frontal_Right",
  "Temporal_Left_Frontal_Left",               "Frontal_Right_Frontal_Right",
  "Frontal_Right_Frontal_Left",               "Frontal_Left_Frontal_Left"
)
data_age <- read.csv("1_raw_data/HBN_wpli_age.csv")
#36 = different connections.
#within = within column networks. 
# selwithin = [1,9,16,22,27,31,34,36];
#between =  2 3 4 5 6 7 8 10 11  12 13 14  15 17 18 19 20 21  23 24 25 26 28 29 30 32 33 35

data<-cbind(data_age,data_mat)

data<-data %>% 
  filter(Age < 17)

##--------------------------------- Set data types ---------------------------------------------------------------
glimpse(data)
data$sex <- factor(data$Sex..1...F..0...M., levels = c(1,0), labels = c("female","male"))

str(data)
names(data)

##--------------------------------- Missing check ---------------------------------------------------------------
data$EID[duplicated(data$EID)] 

##--- Columns with Missing values
colSums(is.na(data))

data<-data %>% 
  select(sex, everything()) #quick rearrange so that sex is not at the end of the file - helps with my loop
  
##--------------------------------- Run models ---------------------------------------------------------------
options(scipen = 999)

library(gridExtra)
library(rlang)
mods <- list()
i = 1
for (col in 5:ncol(data)) {  #col 5 is the start of the pli data
  dv = colnames(data)[col]
  set.seed(123)
  mod <- mgcv::gam(eval(sym(dv)) ~ s(Age) + sex, data = data, method = "REML") #https://stackoverflow.com/questions/55132771/standard-eval-with-ggplot2-without-aes-string
  mods[[i]] <- mod
  names(mods)[i] <- print(dv) #rename the list elements to track
  i = i + 1
}

#quick check that the first model is correct
mod_test<-mgcv::gam(Occipital_Right_Occipital_Right ~ s(Age) + sex, data = data, method = "REML")
summary(mod_test)
summary(mods[["Occipital_Right_Occipital_Right"]])

summary_output <- map(mods, summary)
tables <- map(mods, tab_model) #create tables

#keep only the models where age is significant
library(purrr)
signif_mod<-keep(summary_output, function(x) x[["s.pv"]] < 0.05)

#save a list of the gam models that were significant - to create the plots
signif_list<-mods[names(mods)%in%names(signif_mod)]

# 4. DERIVATIVE ANALYSIS (UPDATED FOR GRATIA 0.8+) --------------------------

deriv <- list()
i = 1
for (col in 1:length(signif_list)) {  
  deriv_m2 <- gratia::derivatives(signif_list[[col]], term= "s(Age)", n = 116, eps = 1e-07, level = .95, interval = "simultaneous", unconditional = TRUE, n_sim = 10000)
  too_small <- function(x) abs(x) < 10^-15
  
  clip_on_siggratia <- function(ci){
    #This function returns a ci object with a sig (1) non sig variable (0) 
    #if confidence interval includes zero
    # signs of x and y will be different, -x * +y  < 0
    # or if both high and low are extremly close to zero
    not_sig <- ci$.lower_ci * ci$.upper_ci < 0 |
      (too_small(ci$.lower_ci) & too_small(ci$.upper_ci)) ####dealing with the float of R
    ci$sig <- 1
    ci$sig[not_sig] <- 0
    return(ci)
  }
  deriv1_sig_table_m2 <- clip_on_siggratia(deriv_m2)
  deriv1_sig_table_m2$mean_dff_clip <- 0
  deriv_range_age_for_plotting_m2 <- range(deriv1_sig_table_m2[ which(deriv1_sig_table_m2$sig == 1), "Age"])
  deriv_range_age_for_plotting_m2
  deriv[[col]] <- deriv1_sig_table_m2
  names(deriv)[col] <- print(names(signif_list)[col])  #rename the list elements to track
}
warnings()

# Plotting significant models
for (col in 1:length(signif_list)) {  
  cat("\n\n")
  cat("##",  print(names(signif_list)[col]), "\n\n")
  set.seed(123)
  print(summary(signif_list[[col]]))
  
  # Process the title: replace 1st and 3rd '_' with space, 2nd with em-dash
  raw_title <- names(signif_list)[col]
  title_parts <- strsplit(raw_title, "_")[[1]]
  
  # Replace underscores conditionally
  if (length(title_parts) >= 4 &&
     identical(title_parts[1:2], title_parts[3:4])) {
    processed_title <- paste(title_parts[1:2], collapse = " ")
  } else {
  if (length(title_parts) >= 3) {
    processed_title <- paste0(
      title_parts[1], " ",  # 1st underscore → space
      title_parts[2], "—",  # 2nd underscore → em-dash
      title_parts[3],       # 3rd part
      if (length(title_parts) > 3) paste0(" ", paste(title_parts[4:length(title_parts)], collapse = " "))  # any remaining with spaces
    )
  } else {
    # Fallback if fewer than 3 parts
    processed_title <- gsub("_", " ", raw_title)
  }
}
  
  P <- plot_model(signif_list[[col]], type = "pred", terms = "Age") + 
    geom_line(color = "blue", linewidth = 1.5) +  # Set GAM line color to blue
    #geom_ribbon(aes(ymin = ci$.lower_ci, ymax = ci$.upper_ci), fill = "lightblue", alpha = 0.3) + 
    labs(title = processed_title,
         y = "wPLI") + 
    theme_base() + 
    theme(plot.background = element_blank()) + 
    theme(plot.title = element_text(size = 30, hjust = .5, face = "bold"), 
          legend.title = element_blank(), 
          legend.position = "none", 
          axis.text.y = element_text(size = 20, color = "black"), 
          axis.title = element_text(size = 20, color = "black"), 
          legend.text = element_text(size = 20, face = "bold"), 
          axis.text.x = element_text(size = 20, color = "black"), 
          panel.border = element_blank(), 
          axis.line = element_line()) +
            ylim(0,.11) +
    scale_x_continuous(limits = c(5, 17), breaks = seq(5, 17, 2))
  
  if (length(P$layers) >= 2) {
    P$layers[[2]]$aes_params$fill <- "black"  # Change color here
    P$layers[[2]]$aes_params$alpha <- 0.3         # Adjust alpha
  }
  
  # Add scatter plot of the raw data
  P <- P + 
    geom_point(data = data, aes(x = Age, y = eval(sym(names(signif_list)[col]))), color = "lightblue", alpha = .5, size = 2) +
    theme_base() +
    theme(plot.background = element_blank()) +
    theme(plot.title = element_text(size = 16, face = "bold", hjust = 0.5),
          axis.title = element_text(size = 15),
          axis.text.y = element_text(size = 12),
          axis.text.x = element_text(size = 12),
          panel.grid.minor = element_blank())
  
  print(P)
}

## Another way of running this from Gams course with Simpson:
# library("gridGraphics")
# for (col in 1:length(signif_list)) {  
#   fds <- derivatives(signif_list[[col]], type = "central", unconditional = TRUE,
#                      interval = "simultaneous") #<<
#   print(signif_list[[col]] |>                     # take the model, and
#     smooth_estimates(select = "s(Age)") |>         # evaluate the smooth
#     add_sizer(derivatives = fds, type = "sizer") |> # add change indicator
#     draw(title = print(names(signif_list)[col])))
# }