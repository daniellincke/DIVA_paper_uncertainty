##############################################
## R SCRIPT FOR GSA                         ##
## with DIVA RESULTS                        ##
## using RF MODEL (see APPENDIX A)          ##
## and LOCAL SOBOL INDICES (see APPENDIX B) ##
#
# Author: 	Jeremy ROHMER
# Institute: BRGM
# E-mail: j.rohmer@brgm.fr
# Date: 	February 2021
##############################################
library(ranger) ### LOAD LIBRARY FOR RF MODEL TRAINING

rm(list=ls())

##########################################################
#### LOAD FILES

#### LOAD OUTPUT OF "run.read.R"
#### formatted DIVA results
load("./DIVA.RData")

#### LOAD SENSITIVITY FUNCTION
source("./UTILS/sensitivity.R")

#### LOAD DATA FROM Riahi et al. (2017): Figure 6
carbon<-read.table("./DATA/carbon_intensity.txt")
energy<-read.table("./DATA/energy_intensity.txt")

##########################################################
#### PARAMETERS

#### VECTOR OF TIME STEPS
tps<-seq(2020,2100,by=5)
nt<-length(tps)

#### NUMBER OF MONTE-CARLO SIMULATIONS FOR GSA
n <- 1000 ### FOR TEST: 1000; FOR THE STUDY: 50000

#### COLUMN POSITION OF OUPUTS
ff<-1:nt

#### NUMBER OF INPUTS
d<-8

#### MATRIX OF GSA RESULTS
SS<-matrix(0,nt,d)

#### LIST TO SAVE PREDICTION AND RF MODEL
rf<-pred<-Xpred<-list()

#### ESTIMATION CHOICE
ttt<-1 ### 1: EAD, 2: AC
www<-2 ### 1: ALL SCENARIOS LIKELY; 2: DIFFERENT LIKELIHOOD WEIGHTS

#### LIKELYHOOD WEIGHT
Prob<-list()
if(www==1){
	Prob[["rGEV"]]<-c(1/3,1/3,1/3)
	Prob[["MSL"]]<-c(0.05,0.9,0.05)
	Prob[["DF"]]<-c(1/2,1/2)
	Prob[["GDPr"]]<-c(1/2,1/2)
	Prob[["SUBS"]]<-c(1/2,1/2)
	Prob[["POP"]]<-c(1/2,1/2)
	Prob[["SSP"]]<-c(1/5,1/5,1/5,1/5,1/5)
}else{
	Prob[["rGEV"]]<-c(1/6,1/6,2/3)
	Prob[["MSL"]]<-c(0.05,0.9,0.05)
	Prob[["DF"]]<-c(3/4,1/4)
	Prob[["GDPr"]]<-c(1/2,1/2)
	Prob[["SUBS"]]<-c(1/4,3/4)
	Prob[["POP"]]<-c(1/2,1/2)
	Prob[["SSP"]]<-c(1/5,1/5,1/5,1/5,1/5)
}

##########################################################
#### FORMATING INPUTS
if (ttt==1){ OUTf<-OUT1} ### ANALYSE EAD
if (ttt==2){ OUTf<-OUT2} ### ANALYSE AC

OUTf$RCP<-OUTf$SSP<-""
QUI<-unique(OUTf$RCP_SSP)
for (i in 1:length(QUI)){
	filtre<-which(OUTf$RCP_SSP==QUI[i])
	OUTf$RCP[filtre]<-strsplit(as.character(QUI[i]),'_')[[1]][1]
	OUTf$SSP[filtre]<-strsplit(as.character(QUI[i]),'_')[[1]][2]
}
OUTf<-OUTf[,-20]### remove colum RCP_SSP

##########################################################
#### COMPUTATION

for (t in 1:nt){ ### LOOP on TIME STEP

	print(tps[t])### PRINT TIME STEP

	#### FORMATING THE TRAINING DATA FOR RF MODEL SET UP
	OUT<-data.frame(OUTf[,t],OUTf[,-ff])
	NOMS<-names(OUTf)[((ff[length(ff)]+1):length(OUTf))]
	names(OUT)<-c("y",NOMS)

	#### TRAIN RF MODEL
	rf[[t]]<-ranger(y~.,data=OUT,importance="none",num.trees = 1000,mtry=8)

	#### SAMPLE THE INPUT VARIABLES
	MSL<-sample(1:3,n,replace=T,prob=Prob[["MSL"]])
	SSP=sample(unique(OUTf$SSP),n,replace=T,prob=Prob[["SSP"]])
	DF<-sample(c(1,1.5),n,replace=T,prob=Prob[["DF"]])
	GDPr<-sample(c(2.8,3.8),n,replace=T,prob=Prob[["GDPr"]])
	SUBS<-sample(c(0,1),n,replace=T,prob=Prob[["SUBS"]])
	rGEV<-sample(c("GEV1","GEV2","GEV5"),n,replace=T,prob=Prob[["rGEV"]])
	POP<-sample(unique(OUTf$POP),n,replace=T,prob=Prob[["POP"]])

	#### FORMATING THE INPUT MATRIX
	X1 <- data.frame(rGEV,MSL,DF,GDPr,SUBS,POP,SSP)#,MODEL)

	#### FORMATING FOR PREDICTION
	Xpred0<-data.frame(X1)
	names(Xpred0)<-names(X1)
	Xpred[[t]]<-Xpred0 ### SAVE

	#### CONDITIONAL SAMPLING OF PROBABILITY(RCP | SSP)
	if (www==2){
		for (j in 1:n){

			for (k in 1:5){

				if (Xpred0$SSP[j]==unique(OUTf$SSP)[k]){
	
					P.RCP<-1/(carbon[k,]*energy[k,])
					P.RCP<-(P.RCP)/(sum(P.RCP))

					Xpred[[t]]$RCP[j]<-sample(unique(OUTf$RCP),1,prob=P.RCP)
				}

			}

		}
	}else{
		Xpred[[t]]$RCP<-sample(unique(OUTf$RCP),n,replace=T)
	}
	Prob[[8]]<-table(Xpred[[t]]$RCP)/sum(table(Xpred[[t]]$RCP))

	#### DO PREDICTIONS with RF MODEL
	pred[[t]]<- predict(rf[[t]],data=Xpred[[t]])$predictions

	#### COMPUTE SENSITIVITY MEASURES
	for (j in 1:(ncol(X1)+1)){
		SS[t,j]<-sensiS(y=pred[[t]],x=Xpred[[t]][,j],prob=Prob[[j]])
	}

}## END LOOP TIME STEP t

##########################################################
#### SAVE
save(SS,file="./SENSI_RESULTS/SENSI_DIVA.RData")

