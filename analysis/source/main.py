from lib.pyHelper import run_script

def main():

    run_script("lowdim_figures.m", "illustration", program= "matlab", fresh_run=1) 

    run_script("simulate_data.py", "simulation")
    run_script("summary_stats.py", "simulation")

    run_script("auto.do", "application", program = "stata")
    
    run_script("create_plots.R", "plot", program = "Rscript")

	run_script("note.tex", "../products/paper", program = "pdflatex")


        
    return None
    


if __name__=="__main__":
    main()
