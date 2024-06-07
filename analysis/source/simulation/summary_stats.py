import os
import csv
import random
import numpy as np
import pandas as pd
#import matplotlib.pyplot as plt
import csv


#Script to be run
def main():
    outpath='../output/simulation/' 
    datapath='../../datastore/'

    sim_designs = []
    with open('lib/designs_to_run.csv', newline='') as inputfile:
        for row in csv.reader(inputfile):
            sim_designs.append(row[0])

    for cur_design in sim_designs:
        cur_data=pd.read_csv(datapath+cur_design+'.csv')
        create_freq_table_sum(cur_data, outpath, cur_design)
        save_mean_samplesize(cur_data, outpath, cur_design)
        
    return None

def create_freq_table_sum(cur_data, outpath, cur_design):

    if not os.path.exists(outpath+cur_design):
        os.makedirs(outpath+cur_design)
       
    cur_data['sum'] = cur_data['first die'] + cur_data['second die']   
    freq_table=pd.crosstab(index=cur_data["sum"], columns="count")   
    
    freq_table.to_csv(outpath + cur_design + '/freq_table.csv', index=True)    
    
    return None

def save_mean_samplesize(cur_data, outpath, cur_design):
    
    mean_sum = np.mean(cur_data['first die'] + cur_data['second die'])
    
    with open(f'{outpath}/{cur_design}/mean_sum.txt', 'w') as f:
        print("{:.2f}".format(mean_sum), file=f)
        
    with open(f'{outpath}/{cur_design}/sample_size.txt', 'w') as f:
        print("{:.0f}".format(len(cur_data)), file=f)
    
    return None
    
### Execute
if __name__=="__main__":
    main()
