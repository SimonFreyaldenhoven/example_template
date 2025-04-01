import random
import pandas as pd
import csv
import os

random.seed(19095)

#Script to be run
def main():
    outpath='../datastore/' 
    designpath='source/simulation/designs/'

    sim_designs = []
    with open('source/lib/designs_to_run.csv', newline='') as inputfile:
        for row in csv.reader(inputfile):
            sim_designs.append(row[0])

    for cur_design in sim_designs:
        create_data(designpath, outpath, cur_design)
    return None

#Main function
def create_data(designpath, outpath, cur_design):
    
    param = pd.read_csv(designpath + cur_design + '.csv', 
                        header=None, index_col=0).squeeze("columns").to_dict()
    data = []

    for i in range(param['sample_size']):
        first_die = random.randint(1, param['no_faces'])
        second_die = random.randint(1, param['no_faces'])

        cur_roll = { "roll": i+1, "first die": first_die, "second die": second_die }
        data.append(cur_roll)

    df= pd.DataFrame(data)
    df.to_csv(outpath + cur_design + '.csv', index=False)    
 
### Execute
if __name__=="__main__":
    main()

