#####################################
## Post-processing of DIVA results ##
#
# Author: 	Jeremy ROHMER
# Institute: BRGM
# E-mail: j.rohmer@brgm.fr
# Date: 	February 2021
#####################################
rm(list=ls())

#### LOAD RAW RESULTS of DIVA
dat<-read.csv("./DATA/global_output.csv",sep=';',header=T)

#### LOAD SCENARIOS
cas<-read.csv("./DATA/cases.csv",sep=';',header=F)

#### TIME VECTOR
tps<-seq(1995,2100,by=5)
nt<-length(tps)

#### NUMBER OF CASES
n<-nrow(cas)/nt

#### LOOP ON RESULTS
X<-matrix("",n,9)
Y1<-Y2<-matrix(0,n,nt)

for (i in 1:n){

	print(i)

	ou<-(1+nt*(i-1)):(nt*i)
	Y1[i,]<-dat$seafloodcost[ou] ## EAD
	Y2[i,]<-dat$seadike_cost[ou]+dat$seadike_maintenance_cost[ou] ## AC

}

#### FORMATTING THE INPUT
ff<-which(dat$time==2100)
X<-cas[ff,]
X0<-data.frame(rGEV=X[,1],MSL=X[,2],RCP_SSP=paste(X[,3],"_",X[,4],sep=''),DF=X[,5],GDPr=X[,6],SUBS=X[,7],POP=X[,8])

#### CONVERT TO NUMERICS
X0$MSL<-as.numeric(X0$MSL)

X0$DF<-as.numeric(X0$DF)
X0$DF[which(X0$DF==1)]<-1
X0$DF[which(X0$DF==2)]<-1.5

X0$GDPr<-as.numeric(X0$GDPr)
X0$GDPr[which(X0$GDPr==1)]<-2.8
X0$GDPr[which(X0$GDPr==2)]<-3.8

X0$SUBS<-as.numeric(X0$SUBS)
X0$SUBS[which(X0$SUBS==1)]<-0
X0$SUBS[which(X0$SUBS==2)]<-1

#### FORMATTING THE FULL DATA.FRAME
#### RESTRICT THE TIME INTERVAL FROM 2020 to 2100
OUT1<-data.frame(Damage=Y1[,6:nt],X0) ## EAD
OUT2<-data.frame(Dike=Y2[,6:nt],X0) ## AC

#### SAVE
save(OUT1,OUT2,file="DIVA.RData")
