from lib.pyHelper import run_script

def main():

    #run_script("intuition.m", "illustration", program= "matlab") #Not yet supported
    #For future reference, the line below works if run from within \illustration.
    #Note that relative paths may need to be updated within matlab
    #subprocess.call("matlab -batch lowdim_figures")

    run_script("simulate_data.py", "simulation")
    
    run_script("summary_stats.py", "estimation")
    
    run_script("create_plots.R", "plot", program = "Rscript")
        
    return None
    


if __name__=="__main__":
    main()
