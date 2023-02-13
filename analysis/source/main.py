import os
import subprocess
from timeit import default_timer as timer
from datetime import datetime
from lib.pyHelper import run_script, write_time_log

def main():

    #run_script("intuition.m", "illustration", program= "matlab")

    run_script("simulate_data.py", "simulation")
    
    run_script("summary_stats.py", "estimation")
    
    #run_script("plot_ts.R", "plot", program= "Rscript")
        
    return None
    


if __name__=="__main__":
    main()
