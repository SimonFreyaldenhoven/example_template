if(!require(pacman)) install.packages("pacman")

pacman::p_load(dplyr, readr, stringr, here, data.table, ggplot2, purrr)


here::i_am("Freyaldenhoven_Shin_Measuring_Fairness.Rproj")

# set up paths
chmda_path <- here("datastore", "measuring", "data", "chmda_data.csv")
hmda_mcd_path <- here("datastore", "measuring", "data", "hmda_mcdash_data.csv")
outpath <- here("analysis", "output", "figures", "fico")


# Read in datasets
chmda <- fread(chmda_path)
hmda_mcd <- read_csv(hmda_mcd_path) %>% 
  filter(loan_type_hmda==1) # restrict to conventional loans only to match chmda data

race_cats <- c("White", "Black")

# Create plots ------------------------------------------------------------

# set theme

theme_set(
  theme_minimal() + 
    theme(
      panel.grid.minor = element_blank(),
      legend.position = "bottom",
      plot.title = element_text(hjust = 0.5),
      axis.text = element_text(size = 13),
      legend.text = element_text(size = 13),
      axis.ticks.length.x = unit(.1, "cm"),
      axis.ticks.x = element_line(size = 0.2, color = "black"),
      axis.line = element_line(size = .5, color = "grey50"),
      panel.grid.major.x = element_blank(),
      panel.background = element_rect(fill = "#FFFFFF", color = "#FFFFFF"),
      plot.background = element_rect(fill = "#FFFFFF", color = "#FFFFFF"))
)

format_plot <- function(plot, size = 1.2, alpha = 0.8, ylabel, xlabel = "Credit Score"){
  plot +
    geom_point(size = size, alpha = alpha) +
    scale_color_manual(values = c("#4477AA", "#CC6677")) +
    labs(x = xlabel, y = ylabel, color = "")
}

## Denial, default (both by race), frequency plot data -------


# Note that this is just for conventional loans -- need to pull all loan types for CHMDA data

denial_rate_plot_data <- chmda %>% 
  filter(
    between(applicant_credit_score, 580, 800),
    race %in% race_cats
  ) %>% 
  group_by(applicant_credit_score, race) %>% 
  summarize(
    denial_rate = mean(aus_denied), 
    credit_score = mean(applicant_credit_score)
  )

default_rate_plot_data <- hmda_mcd %>% 
  filter(
    between(fico_orig, 580, 800), 
    race %in% race_cats
  ) %>% 
  group_by(fico_orig, race) %>% 
  summarize(
    default_rate = mean(default_90d_3y)
  ) %>% 
  rename(credit_score = fico_orig)
  
freq_plot_data <- chmda %>% 
  filter(
    aus_denied == 0,
    between(applicant_credit_score, 580, 800) 
    ) %>% 
  group_by(applicant_credit_score) %>% 
  count() %>% 
  ungroup()

interest_rate_plot_data <- hmda_mcd %>% 
  filter(
    !is.na(cur_int_rate),
    between(fico_orig, 580, 800), 
    race %in% race_cats
  ) %>% 
  group_by(fico_orig, race) %>% 
  summarize(
    int_rate = mean(cur_int_rate)
  ) %>% 
  rename(credit_score = fico_orig)


# Write plot data to csv so we can plot using different software if needed
dfs <- list(freq_plot_data, denial_rate_plot_data, default_rate_plot_data, interest_rate_plot_data)
names(dfs) <- c("freq_plot_data", "denial_rate_plot_data", "default_rate_plot_data", "interest_rate_plot_data")

walk2(
  dfs, names(dfs),
  function(data, name) write_csv(data, here(outpath, "plot_data", str_glue("{name}.csv")))
)

# Make all plots -----
denial_rate_plot <- denial_rate_plot_data %>% 
  ggplot(aes(credit_score, denial_rate, color = race)) %>% 
  format_plot(ylabel = "Denial Rate")

default_rate_plot <- default_rate_plot_data %>% 
  ggplot(aes(credit_score, default_rate, color = race)) %>% 
  format_plot(ylabel = "Default Rate")

freq_plot <- freq_plot_data %>% 
  ggplot(aes(applicant_credit_score, n)) %>% 
  format_plot(ylabel = "Frequency of accepted applications")

interest_rate_plot <- interest_rate_plot_data %>% 
  ggplot(aes(credit_score, int_rate, color = race)) %>% 
  format_plot(ylabel = "Interest Rate")


# Export plots made here in ggplot -------
plots <- list(freq_plot, denial_rate_plot, default_rate_plot, interest_rate_plot)
names(plots) <- c("freq_plot", "denial_rate_plot", "default_rate_plot", "interest_rate_plot")

walk2(
  plots, names(plots),
  function(plot, name) ggsave(plot = plot, filename = here(outpath, str_glue("{name}.png")), 
                              height = 6, width = 6.5)
)


# Interest rate missingness --------------------------------------------

hmda_mcd %>% 
  mutate(is_na_interest = is.na(cur_int_rate)) %>% 
  group_by(orig_year) %>% 
  count(is_na_interest) %>% 
  write_csv(here("analysis", "output", "data", "interest_rate_count_missing_by_year.csv"))

hmda_mcd %>% 
  mutate(is_na_interest = is.na(cur_int_rate)) %>% 
  group_by(orig_year) %>% 
  summarize(prop_missing = mean(is_na_interest)) %>% 
  write_csv(here("analysis", "output", "data", "interest_rate_prop_missing_by_year.csv"))
