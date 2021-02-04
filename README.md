DIVA_paper_uncertainty

This repository contains the data and the scripts used to create results, figures and tables in the paper "Unravelling the importance of uncertainties in global-scale coastal flood risk assessments under sea level rise" by J. Rohmer et al. published in Water (DOI-link to follow).

The Repository is organized as follows:

 - subdirectory DIVA_INPUT:
   * subdirectory data: input data used.
     cls_input_surges_ERWIN_relative_to_geoid_R1.csv etc coaintains the extrem water levels (at coastline segment level). RX indicates the R value for the GEV maxima used in the fitting method (see paper).
     cz_input_34_merit_gpw4.csv, cz_input_34_merit_landscan.csv: input data for the coastline segments merit denotes the DEM used, gpw4, grump, kandsan the population data used.
   * subdirectory data/gis: a shapefile of the global coastline, divided into the DIVA-segments
   * subdirectory scen: the sea-level rise scenarios used (at coastline segment level). 
     rlsr_ERWIN_LOW2_RCP26.csv etc. - LOW, MED, HIG indicates ice-sheet component, RCP26, RCP45 and RCP85 indicate the RCP (see paper) 

 - subdirectory SENSITIVITY: The directory “SENSITIVITY” includes all data and R scripts to reproduce the results of the sensitivity analysis. The R scripts are self-contained and can be run provided that the DIVA results “global_output.csv” is included in “SENSITIVITY/DATA” sub-directory. The analysis was performed using R version 3.6.1 (2019-07-05) on an i386-w64-mingw32 platform.

1) A "DATA" sub-directory containing:
    • the results of the DIVA simulations "global_output.csv"
    • the definition of the different input scenarios "cases.csv"
    • the data extracted from Fig. 6 of Riahi et al. (2017): carbon_intensity.txt & energy_intensity.txt
2) A "UTILS" sub-directory including the R function to compute the local Sobol indices (see Appendix B of the manuscript)
3) A "SENSI_RESULTS" sub-directory including the GSA results (RData format) used in the manuscript
4) The R script "run_read.R" for reading the DIVA results and formatting it for performing the analysis
5) The R script "run_RF_sensitivity.R" for performing Global Sensitivity Analysis from DIVA RESULTS (formatted using run_read.R) using RF models (see APPENDIX A of the manuscrit)
and local Sobol indices (see Appendix B of the manuscrit)
6) The R script "run_plot.R" for reproducing Figs. 3 and 4 using the files in "RESULTS"

 - file inseaption.properties:
   * the DIVA configuration file used to produce the results

        
