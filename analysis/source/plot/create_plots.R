pacman::p_load(tidyverse, here)

here::i_am("analysis.Rproj")

main <- function() {
  
  design_path <- here("source", "designs_to_run.csv")
  
  # Import list of designs as a character vector by pulling the first column
  designs <- read_csv(design_path, show_col_types = FALSE, col_names = FALSE) %>% pull(1)
  data_folder <- here("output", "simulation")
  out_folder <- here("output", "plot") 
  
  for(design in designs){
    data_path <- here(data_folder, design)
    out_path <- here(out_folder, design)
    
    # If out_path doesn't exist, create it
    dir.create(out_path, showWarnings = FALSE)
    
    plot_hist(data_path, out_path, "sum", "freq_table.csv", "hist.png")
  }
  
}

plot_hist <- function(data_path, out_path, var_name, in_file, out_file, height = 5, width = 6){
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
      geom_histogram(stat = "identity", fill="blue") +
      labs(x = "", y = "")
  
    ggsave(plot = plot, filename = here(out_path, out_file), h = height, w = width)
  
}


main()


