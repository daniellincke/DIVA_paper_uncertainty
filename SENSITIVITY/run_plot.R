#####################################
## Plot of GSA results             ##
## of the manuscript               ##
## Reproduction of Figs. 3 & 4     ##
#
# Author: 	Jeremy ROHMER
# Institute: BRGM
# E-mail: j.rohmer@brgm.fr
# Date: 	February 2021
#####################################
library(ggplot2)
library(RColorBrewer)

rm(list=ls())

#### PARAMETERS
tps<-seq(2020,2100,by=5) ### TIME VECTOR
Noms<-c("rGEV","RSLR", "DF","A:GDPr","SUBS","POP","SSP","RCP") ### NAMES OF INPUTS

#### LOAD RESULTS CALCULATED FOR THE MANUSCRIPT
load("./SENSI_RESULTS/Cost_Sensi_WEIGHT_final.RData")

#### FILTER small computation error (<1e-5)
SS[(SS<0)]<-0
SS[(SS>1)]<-1

#### FORMATTING
df<-data.frame(Year=rep(tps[1:17],8),
		   S=c(SS[1:17,1],SS[1:17,2],SS[1:17,3],SS[1:17,4],SS[1:17,5],SS[1:17,6],SS[1:17,7],SS[1:17,8]),
		   Var=c(
			rep(Noms[1],length(tps[1:17])),rep(Noms[2],length(tps[1:17])),rep(Noms[3],length(tps[1:17])),rep(Noms[4],length(tps[1:17])),
			rep(Noms[5],length(tps[1:17])),rep(Noms[6],length(tps[1:17])),rep(Noms[7],length(tps[1:17])),rep(Noms[8],length(tps[1:17]))
		        )
		)

#### PLOT
p<-ggplot(df, aes(x = Year, y = S, fill = Var)) +
  geom_area(position = "fill", colour = "black", size = .5, alpha = 0.8) 
p <- p+ scale_fill_manual(values=rev(brewer.pal(8, "Set1")))

#### PLOT FORMATTING
p<-p+ggtitle("")+theme_classic()
p <- p+ theme(
		axis.title.x = element_text(size=14, face="bold"),
		axis.title.y = element_text(size=14, face="bold"),
		axis.text.y= element_text(size=14),
		axis.text.x= element_text(size=14),
		axis.ticks = element_line(size = 1),
		legend.title=element_blank()
		)
p
