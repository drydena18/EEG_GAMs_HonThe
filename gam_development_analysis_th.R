# COMPLETE GAM ANALYSIS SCRIPT - UPDATED FOR CURRENT GRATIA VERSION

# 0. SET THESE VARIABLES ---------------------------------------------------
age_col <- "Age"              # Name of age column
outcome_col <- "V1"           # Name of outcome column
group_col <- "Sex"            # Name of group column (e.g., Sex)
age_limit <- 17               # Age cutoff filter
plot_title <- "Gamma Right Frontal-Left Frontal" # Plot title
output_prefix <- "analysis_"  # Prefix for output files

# 1. LOAD REQUIRED PACKAGES ---------------------------------------------------
library(mgcv)       # For GAM modeling
library(gratia)     # For derivatives
library(ggplot2)    # For plotting
library(ggeffects)  # For plot_model
library(sjPlot)     # For theme_sjplot
library(mgcViz)     # For visualization
library(see)        # For theme_base
library(dplyr)      # For data manipulation
library(readr)      # For reading data files

# 2. LOAD AND PREPARE DATA ---------------------------------------------------
raw_data <- read_csv("/Users/drydena18/Library/CloudStorage/OneDrive-OntarioTechUniversity/EEG_GAMs/Prepocessed_data/wPLI/between_group/gama/ant_r_ant_l_gama_age.csv")

# Clean column names if needed
names(raw_data)[names(raw_data) == "Sex..1...F..0...M."] <- "Sex"

# Filter and prepare data
filt_data <- raw_data %>%
  rename(age = !!age_col,
         outcome = !!outcome_col,
         group = !!group_col) %>%
  filter(age < age_limit) %>%
  select(age, group, outcome) %>%
  na.omit()

# 3. GAM MODELING -----------------------------------------------------------

# Run GAM model
gam_model <- gam(outcome ~ s(age) + group, 
                 data = filt_data, 
                 method = "REML")

# Model diagnostics
model_summary <- summary(gam_model)
print(model_summary)

# Visual diagnostics
appraise(gam_model)
set.seed(123)
gam.check(gam_model)

# 4. DERIVATIVE ANALYSIS (UPDATED FOR GRATIA 0.8+) --------------------------

gam_age_bis <- mgcv::gam(outcome ~ s(age), data = filt_data, method = "REML")
summary(gam_age_bis)

###-assumption checks
appraise(gam_age_bis)       
set.seed(123)
gam.check(gam_age_bis)

#predictive check 
set.seed(123)
vgam_bis<- getViz(gam_age_bis, nsim = 100, post = TRUE, unconditional = TRUE)  
check0D(vgam_bis, type = "y") 

deriv_m2 <- gratia::derivatives(gam_model, term= "s(age)", n = 100, eps = 1e-07, level = .95, interval = "simultaneous", unconditional = TRUE, n_sim = 10000)
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
deriv_range_age_for_plotting_m2 <- range(deriv1_sig_table_m2[ which(deriv1_sig_table_m2$sig == 1), "age"])
deriv_range_age_for_plotting_m2

# 6. VISUALIZATION (UPDATED) ----------------------------------------------

# Create base plot
main_plot <- plot_model(gam_model, 
                        type = "pred", 
                        terms = "age",
                        ci.lvl = 0.95,
                        colors = "steelblue",
                        line.size = 1.5) +
  geom_point(data = filt_data,
             aes(x = age, y = outcome),
             color = "steelblue",
             alpha = 0.6,
             size = 2) +
  labs(title = plot_title,
       x = "Age (years)",
       y = "wPLI") +
  theme_minimal() +
  theme(plot.title = element_text(size = 16, face = "bold", hjust = 0.5),
        axis.title = element_text(size = 15),
        axis.text.y = element_text(size = 12),
        axis.text.x = element_text(size = 12),
        panel.grid.minor = element_blank())

# Add significance markers only if ranges were found
if(!is.null(deriv_range_age_for_plotting_m2)) {
  main_plot <- main_plot +
    geom_vline(xintercept = c(deriv_range_age_for_plotting_m2$min_age, deriv_range_age_for_plotting_m2$max_age),
               linetype = "dashed",
               color = "red",
               alpha = 0.7,
               linewidth = 1) +
    annotate("text",
             x = mean(c(deriv_range_age_for_plotting_m2$min_age, deriv_range_age_for_plotting_m2$max_age)),
             y = max(filt_data$outcome) * 0.9,
             label = "Significant Change",
             color = "red",
             size = 5)
}

# 7. SAVE OUTPUTS ----------------------------------------------------------

# Save plot
ggsave(paste0(output_prefix, "plot.png"), 
       plot = main_plot,
       width = 8, 
       height = 6,
       dpi = 300)

# Save model summary
sink(paste0(output_prefix, "model_summary.txt"))
print(summary(gam_model))
sink()

# Save derivatives
# write_csv(deriv_processed, paste0(output_prefix, "derivatives.csv"))

# Display plot
print(main_plot)

