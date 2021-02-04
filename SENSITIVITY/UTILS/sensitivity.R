#####################################
## FUNCTION FOR GSA                ##
## with LOCAL SOBOL INDICES        ##
## see APPENDIX B                  ##
#
# Author: 	Jeremy ROHMER
# Institute: BRGM
# E-mail: j.rohmer@brgm.fr
# Date: 	February 2021
#####################################
sensiS<-function(y,x,prob){

		SS<-NULL
		SSf<-0
		U<-sort(unique(x))
		for (i in 1:length(U)){
			ff<-which(x==U[i])
			SS[i] <- (1-var(y[ff])/var(y))
			SSf<-SSf+prob[i]*SS[i]
		}
	return(SSf)
}