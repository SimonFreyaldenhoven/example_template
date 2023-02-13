"""
run_script

Runs and times each individual script in pipeline.

args
    file_name (str), name of script with file extension
    folder (str), name of folder in which file_name is located
    absolute_path (str), name of path to the source folder
    program (str), command that is executed in terminal (ex. python3, Rscript)
returns
    None
"""
def run_script(file_name, folder="", absolute_path = os.path.dirname(__file__), program = "python3", timelog = True):

    tic = timer()

    full_path = os.path.join(absolute_path, folder, file_name)

    if program=="stata":  # TO DO: allow for relative paths in do files
        command = ["path/to/stata", "/e", "do", full_path]
    elif program == "Rscript" or program == "python3": 
        command = [program, full_path]
        
    subprocess.call(command) 

    toc = timer()

    # Print elapsed time
    elapsed = (toc - tic) / 60
    print('{0} minutes to run {1}.'.format(elapsed, file_name))  

    if timelog: write_time_log(elapsed, script = file_name)

    return None

"""
write_time_log

Notes the current date and time and writes the run time of a script to .txt file, 
generates a new time log file if none exists in the /source/ folder, otherwise writes 
to existing file.

args
    elapsed (flt), time elapsed (calculated in run_script())
    script (str), name of file that was run
    log_name (str), desired name of time log txt file
    absolute_path (str), name of path to the source folder
returns
    None
"""
def write_time_log(elapsed, script, log_name = "time_log.txt", absolute_path = os.path.dirname(__file__)):

    now = datetime.now()
    now_str = now.strftime("%Y/%m/%d %H:%M:%S") 
 
    log_path = os.path.join(absolute_path, log_name)
    opt = 'a' if(os.path.exists(log_path)) else 'w'
    with open(log_path, opt) as f:
        f.write("On {0} it took {1} minutes to run {2}.\n".format(now_str, elapsed, script))
    
    return None