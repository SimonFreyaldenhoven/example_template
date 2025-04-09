import os, time
import subprocess
from timeit import default_timer as timer
from datetime import datetime
from pathlib import Path

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
def run_script(script, folder, absolute_path = os.getcwd(), program = "python", timelog = True, fresh_run=0):

    full_path = os.path.join(absolute_path, folder, script)
    products_loc=os.path.join(Path(absolute_path).parent.parent, 'products')

    print(f'full_path: {full_path}')
    
    if program == "Rscript" or program == "python": 
        command = [program, full_path]

    elif program == "stata":  
        if os.path.isfile(absolute_path + '\lib\path_to_stata.txt'):
            with open(absolute_path +'\lib\path_to_stata.txt') as f:
                path_to_stata = f.read()
            #path_to_stata = "/applications/stata17/stata-mp" #Should look similar to this
            command = [path_to_stata, "do", full_path]
        else:
            print('Stata not found. Skipping this script in 20 seconds.')
            print('To Fix: add a file path_to_stata.txt to \lib\ that contains the path to your Stata Application')
            print('Examples may be:')
            print('/applications/stata17/stata-mp on UNIX')
            print('C:/Program Files/Stata17/StataMP-64 on WIndows')
            time.sleep(20)

    elif program == 'matlab':
        command = program + f" -batch run('{full_path}')"


    if program != "pdflatex":

        print(f'command: {command}')

        tic = timer()
        p = subprocess.run(command, capture_output = True) 
        toc = timer()
    else: #traverse to products folder
        tic = timer()
        full_path = os.path.join(products_loc, folder, script)
        os.chdir(os.path.join(products_loc, folder))
        command = program +' '+ script
        p = subprocess.run(command)
        p = subprocess.run('bibtex ' + script[:-4]) # remove .tex file extension 
        p = subprocess.run(command) 
        p = subprocess.run(command)
        os.chdir(absolute_path)
        toc = timer()
        
    elapsed = round((toc - tic) / 60, 3)

    print(f"{elapsed} minutes to run {script}")

    if timelog: write_time_log(elapsed, script = script, process = p, fresh_run=fresh_run)

    return None


"""
write_time_log

Notes the current date and time and writes the run time of a script to .txt file, 
generates a new time log file if none exists in the /source/ folder, otherwise writes 
to existing file.

args
    elapsed (flt), time elapsed (calculated in run_script())
    script (str), name of file that was run
    process (CompletedProcess object), from subprocess library contains attributes returncode and stderr which captures the errors from 
    log_name (str), desired name of time log txt file
    absolute_path (str), name of path to the source folder
returns
    None
"""
def write_time_log(elapsed, script, process, log_name = "time_log.txt", absolute_path = os.getcwd(), fresh_run=0):

    # # sam comment
    # print(f'os.getcwd(): {os.getcwd()}')
    # print(f'Path(absolute_path): {Path(absolute_path)}')
    # print(f'Path(absolute_path).parents[0]: {Path(absolute_path).parents[0]}')

    now = datetime.now()
    now_str = now.strftime("%Y/%m/%d %H:%M:%S") 

    log_path=os.path.join( str(Path(absolute_path).parents[0]), 'output/', log_name)
    opt = 'a' if(fresh_run==0) else 'w'
    
    # Get return status and error message of process
    failed = process.returncode > 0
    error_msg = process.stderr

    if(failed):
        message = f"{script} ran for {elapsed} minutes but failed. Error: {error_msg}"
    else:
        message = f"{script} ran successfully in {elapsed} minutes."

    # # sam comment
    # print(f'log_path: {log_path}')
    # print(f'type(log_path): {type(log_path)}')

    sam_log_path = Path('H:\\Resources\\Simon_Git_Test\\analysis\\output\\time_log.txt')

    # with open(log_path, opt) as log:
    with open(sam_log_path, opt) as log:
        log.write(f"On {now_str}, {message}\n\n")

    return None
