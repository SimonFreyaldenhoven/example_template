import os
import csv
import random
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import csv

rng = np.random.default_rng(19095)


#Script to be run
def main():
    outpath='output/simulations/summary_stats/' 
    datapath='../datastore/marginal/simulations/'

    mean_by_year(tba)
      
    return None


def explore(datapath, designpath, cur_design, outpath):
    plt.clf()
    cur_outfolder=outpath + cur_design + '/' 
    if not os.path.exists(outpath+cur_design):
        os.makedirs(outpath+cur_design)
        
    cur_data=pd.read_csv(datapath+cur_design+'.csv')
    param = pd.read_csv(designpath + cur_design + '.csv', 
                        header=None, index_col=0, squeeze=True).to_dict()     
    
    partition_sizes=cur_data.groupby('zip_code').size()
    
    # Plot histogram of number of applications in each partition  
    plt.hist(partition_sizes, 
             bins=np.arange(partition_sizes.min(), partition_sizes.max()+1)-0.5)
    plt.savefig(cur_outfolder+'partition_sizes.png')
    plt.close()
    
    # Plot histogram of number of applications submitted by each applicant
    application_distr=cur_data.groupby('id').size()
    plt.hist(application_distr, 
             bins=np.arange(application_distr.min(), application_distr.max()+1)-0.5)
    plt.savefig(cur_outfolder+'application_distr.png')
    plt.close()
    
    writer=open(cur_outfolder+"summary_stats.txt","w")
    print('Overall approval rate:', "%0.4f" % np.mean(cur_data['approval']), '\n', file=writer)
    writer.close()
    
    #Technically over applicants, not applications, but equivalent in limit.
    # Plot histogram of default_prob, X, and eta parameters by group (minority/majority)
    hist_by_group(cur_data, 'default_prob', 'minority', cur_outfolder)  
    hist_by_group(cur_data, 'X', 'minority', cur_outfolder)  
    hist_by_group(cur_data, 'eta', 'minority', cur_outfolder)  
    
    hist_around_cutoff(cur_data, 'minority', cur_outfolder, param)  
    
    # Record summary stats
    writer=open(cur_outfolder+"summary_stats.txt","a")
    group_bydemographic=cur_data.groupby('minority')
    for demographic in group_bydemographic:
        print("Default rate (infeasible):", "%0.4f" %np.nanmean(demographic[1].default), 
              'for Minority equal to ', "%0.0f" %np.mean(demographic[1].minority), file=writer)
        print("Default rate on originated loans:", "%0.4f" %np.nanmean(demographic[1].default_observed), 
              'for Minority equal to ', "%0.0f" %np.mean(demographic[1].minority), file=writer)
        print('Approval rate:', "%0.4f" %np.nanmean(demographic[1]['approval']),
              'for Minority equal to ', "%0.0f" %np.mean(demographic[1].minority),'\n', file=writer)
    
    true_cross_apps = cur_data[cur_data.groupby(['id'])['id'].transform('size') > 1]
    
    print( len(pd.unique(cur_data['id'])), 'Total applicants with ',
          len(cur_data), 'applications', '\n',file=writer)
    print("Of those: ",len(pd.unique(true_cross_apps['id'])), 'Crossapplicants with ', 
          len(true_cross_apps), 'applications', '\n',file=writer)
    
    
    true_marginals=true_cross_apps.groupby('id').filter(lambda x: (x['approval'].sum()>0) and (x['approval'].sum()<x['approval'].count()))
    print("Of those: ",len(pd.unique(true_marginals['id'])), 'Marginal applicants with ', 
          len(true_marginals), 'applications', '\n',file=writer)
    
    group_bydemographic=true_marginals.groupby('minority')
    for demographic in group_bydemographic:
        print("Default rate on originated loans among marginal applicants:", "%0.4f" %np.nanmean(demographic[1].default_observed), 
              'for Minority equal to ', "%0.0f" %np.mean(demographic[1].minority), file=writer)
        print('Approval rate among marginal applicants:', "%0.4f" %np.nanmean(demographic[1]['approval']),
              'for Minority equal to ', "%0.0f" %np.mean(demographic[1].minority),'\n', file=writer)
        
    # Plot histogram of default probability by minority status, restricted to marginal applicants
    hist_by_group(true_marginals, 'default_prob', 'minority', cur_outfolder, 'marginal')  
    
def hist_by_group(cur_data, variable_name, group_var, cur_outfolder, note=''):
        grouped=cur_data.groupby(group_var)
        for group in grouped:
            plt.hist(group[1][variable_name], alpha=0.3)
            
        plt.savefig(cur_outfolder+'hist_' + variable_name + '_by_' + group_var + note + '.png')
        plt.close()
        
def hist_around_cutoff(cur_data, group_var, cur_outfolder, param, note=''):
        
        cur_data=cur_data[(cur_data['default_prob'] > param['approval_cutoff']-param['approval_range']) & (cur_data['default_prob'] < param['approval_cutoff']+param['approval_range'])]
        grouped=cur_data.groupby(group_var)
        for group in grouped:
            plt.hist(group[1]['default_prob'], alpha=0.3)
            
        plt.savefig(cur_outfolder+'hist_default_around_cutoff_by_' + group_var + note + '.png')
        plt.close()
    
    
    
### Execute
if __name__=="__main__":
    main()
