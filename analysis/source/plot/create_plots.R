pacman::p_load(tidyverse, here)

here::i_am("analysis.Rproj")

main <- function() {
  data_folder <- here("output", "estimation", "baseline")
  out_folder <- here("output", "plot", "baseline") 
  folders <- c(data_folder, out_folder)
  
  # If folders don't exist, create them
  walk(folders, dir.create) 
  
  data_path <- here(data_folder, "freq_table.csv")
  out_path <- here(out_folder, "hist.png")
  
  plot_hist(data_path, out_path, "sum")
  
}

plot_hist <- function(data_path, out_path, var_name, height = 5, width = 6){
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
      ggplot(aes(.data[[var_name]], count)) +
      geom_histogram(stat = "identity") +
      labs(x = "", y = "")
  
    ggsave(plot = plot, filename = out_path, h = height, w = width)
  
}


main()


