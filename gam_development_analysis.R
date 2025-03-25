# COMPLETE GAM ANALYSIS SCRIPT - UPDATED FOR CURRENT GRATIA VERSION

# 0. SET THESE VARIABLES ---------------------------------------------------
age_col <- "Age"              # Name of age column
outcome_col <- "V1"           # Name of outcome column
group_col <- "Sex"            # Name of group column (e.g., Sex)
age_limit <- 17               # Age cutoff filter
plot_title <- "Development Trajectory" # Plot title
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
raw_data <- read_csv("/Users/drydena18/Library/CloudStorage/OneDrive-OntarioTechUniversity/EEG_GAMs/Prepocessed_data/wPLI/between_group/broad/par_l_ant_r_pli_age.csv")

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

# Calculate derivatives using current gratia syntax
deriv_data <- gratia::derivatives(gam_model,
                                  select = "s(age)",
                                  n = 100,
                                  eps = 1e-07,
                                  interval = "simultaneous")

# Print structure for verification
message("Derivatives object structure:")
print(str(deriv_data))

# Process derivatives for current gratia output
process_derivatives <- function(deriv_obj) {
  # Rename columns to standard names if needed
  if(".derivative" %in% names(deriv_obj)) {
    deriv_obj <- deriv_obj %>%
      rename(derivative = .derivative,
             se = .se,
             lower = .lower_ci,
             upper = .upper_ci,
             data = age)
  }
  
  # Verify we have the required columns
  required_cols <- c("derivative", "se", "lower", "upper", "data")
  if(!all(required_cols %in% names(deriv_obj))) {
    stop("Missing required columns in derivatives output. Found: ", 
         paste(names(deriv_obj), collapse = ", "))
  }
  
  return(deriv_obj)
}

# Process the derivatives
deriv_processed <- process_derivatives(deriv_data)

# 5. SIGNIFICANCE TESTING (UPDATED) ----------------------------------------

# Updated function to handle cases with no significant regions
find_sig_regions <- function(deriv_obj) {
  sig_data <- deriv_obj %>%
    mutate(sig = ifelse(lower * upper > 0 &  # Same sign
                          abs(lower) > 1e-10 &  # Not too small
                          abs(upper) > 1e-10, 
                        1, 0)) %>%
    filter(sig == 1)
  
  if(nrow(sig_data) == 0) {
    message("No significant regions found in derivatives")
    return(NULL)
  }
  
  sig_data %>%
    summarize(min_age = min(data),
              max_age = max(data))
}

# Get significant ranges (returns NULL if none found)
sig_ranges <- find_sig_regions(deriv_processed)

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
  theme(plot.title = element_text(size = 14, face = "bold", hjust = 0.5),
        axis.title = element_text(size = 12),
        panel.grid.minor = element_blank())

# Add significance markers only if ranges were found
if(!is.null(sig_ranges)) {
  main_plot <- main_plot +
    geom_vline(xintercept = c(sig_ranges$min_age, sig_ranges$max_age),
               linetype = "dashed",
               color = "red",
               alpha = 0.7,
               linewidth = 1) +
    annotate("text",
             x = mean(c(sig_ranges$min_age, sig_ranges$max_age)),
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
