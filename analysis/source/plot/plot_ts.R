pacman::p_load(tidyverse, here)

data_path <- here("output", "estimation", "baseline", "freq_table.csv")
out_path <- here("output", "estimation", "baseline", "hist.png")

# Set plotting theme
theme_set(
  theme_minimal() +
    theme(
      panel.grid.minor = element_blank(), 
      panel.grid.major.x = element_blank()
    )
)

df <- read_csv(data_path)

plot <- df %>% 
  ggplot(aes(sum, count)) +
  geom_histogram(stat = "identity") +
  labs(x = "", y = "")


ggsave(plot = plot, filename = out_path, h = 5, w = 6)


