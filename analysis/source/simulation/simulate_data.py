import random
import pandas as pd
import csv
import random
import os

rng = np.random.default_rng(19095)
random.seed(19095)

#Script to be run
def main():
    outpath='../../datastore/marginal/simulation/' 
    designpath='simulation/designs/'

    sim_designs = []
    with open('simulation/designs_to_run.csv', newline='') as inputfile:
        for row in csv.reader(inputfile):
            sim_designs.append(row[0])

    for cur_design in sim_designs:
        create_data(designpath, outpath, cur_design)
    return None

#Main function
def create_data(outpath):
    
    df = []

    for i in range(sample_size):
        first_die = random.randint(1, no_faces)
        second_die = random.randint(1, no_faces)

        cur_roll = { "white": white, "black": black }
        df.append(cur_roll)

    df.to_csv(outpath + cur_design + '.csv', index=False)    
 
### Execute
if __name__=="__main__":
    main()

