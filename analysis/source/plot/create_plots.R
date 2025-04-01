pacman::p_load(tidyverse, here)

here::i_am("base.Rproj")

main <- function() {
  
  design_path <- here("analysis", "source", "lib", "designs_to_run.csv")
  
  # Import list of designs as a character vector by pulling the first column
  designs <- read_csv(design_path, show_col_types = FALSE, col_names = FALSE) %>% pull(1)
  data_folder <- here("analysis", "output", "simulation")
  out_folder <- here("analysis", "output", "plot")
  
  # importing datastore folder:
  datastore_folder <- here("datastore")
  
  for(design in designs){
    data_path <- here(data_folder, design)
    out_path <- here(out_folder, design)
    
    raw_data_path <- paste0(datastore_folder, "/", design, ".csv")
    
    # If out_path doesn't exist, create it
    dir.create(out_path, showWarnings = FALSE)
    
    plot_hist(data_path, out_path, "sum", "freq_table.csv", "hist.png", "blue")
    plot_hist(data_path, out_path, "sum", "freq_table.csv", "hist_red.png", "red")
    
    illustrate_lln(raw_data_path, out_path, "sum", paste0("lln_plot", ".png"))
  }
}

plot_hist <- function(data_path, out_path, var_name, in_file, out_file, fillcolor, height = 5, width = 6){
    # Set plotting theme
    theme_set(
      theme_minimal() +
        theme(
          panel.grid.minor = element_blank(), 
          panel.grid.major.x = element_blank()
        )
    )
    df <- read_csv(here(data_path, in_file),show_col_types = FALSE)
    plot <- df %>% 
      ggplot(aes(.data[[var_name]], count)) +
      geom_histogram(stat = "identity", fill=fillcolor) +
      labs(x = "", y = "")
  
    ggsave(plot = plot, filename = here(out_path, out_file), h = height, w = width)
  
}

illustrate_lln <- function(data_path, out_path, var_name, out_file, height = 5, width = 6) {
  # Set plotting theme
  theme_set(
    theme_minimal() +
      theme(
        panel.grid.minor = element_blank(),
        panel.grid.major.x = element_blank()
      )
  )
  # data cleaning
  df <- read_csv(data_path,show_col_types = FALSE) %>%
    mutate("total" = `first die` + `second die`, "sum" = total)
  for (i in 1:nrow(df)) {
    if (i != 1) {
      df$sum[i] = (df$sum[i - 1] + df$total[i])
    }
  }
  df$sum_by_roll = df$sum / df$roll
  
  #plot
  plot <- df %>%
    ggplot(aes(x = roll, y = sum_by_roll)) +
    geom_point()

  ggsave(plot = plot, filename = here(out_path, out_file), h = height, w = width)
  }



main()