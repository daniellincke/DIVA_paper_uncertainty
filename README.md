DIVA_paper_subsidence

This repository contains the data and the scripts used to create results, figures and tables in the paper "Unravelling the importance of uncertainties in global-scale coastal flood risk assessments under sea level rise" by J. Rohmer et al. published in Water (DOI-link to follow).

The Repository is organized as follows:

 - subdirectory DIVA_INPUT:
   * subdirectory data: input data used.
     cls_input_surges_ERWIN_relative_to_geoid_R1.csv etc coaintains the extrem water levels (at coastline segment level). RX indicates the R value for the GEV maxima used in the fitting method (see paper).
     cz_input_34_merit_gpw4.csv, cz_input_34_merit_landscan.csv: input data for the coastline segments merit denotes the DEM used, gpw4, grump, kandsan the population data used.
   * subdirectory scen: the sea-level rise scenarios used (at coastline segment level). 
     rlsr_ERWIN_LOW2_RCP26.csv etc. - LOW, MED, HIG indicates ice-sheet component, RCP26, RCP45 and RCP85 indicate the RCP (see paper) 

 - subdirectory SENSITIVITY:
 
 - file inseaption.properties:
   * the DIVA configuration file used to produce the results

        
