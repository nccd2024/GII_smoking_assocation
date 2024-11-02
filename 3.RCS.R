
library(data.table)
library(haven) 
library(rms)
library(survminer)
library(ggplot2)
library(ggsci)
library(scales)
library(dplyr)
library(ggpubr)
library(lattice)
library(foreign)
library(survival)
library(SparseM)
library(Hmisc)
library(splines)


setwd("Outputfilefold")
all<-data.frame(read_sas("demo.sas7bdat"))

female<-subset(all,Female==1)
female<-as.data.frame(female)

male<-subset(all,Female==0)
male<-as.data.frame(male)


######################################female
  
  rcs_plot<-function(indata,behavior)
  { f<-paste0(behavior, "~rcs(gii,5)+Age+rural")
    fit<-lrm(as.formula(f),data=indata)
    aa<-anova(fit)
    linear.p<-ifelse((round(signif(aa[2,3],3),digits=3))==0,"<0.001",round(signif(aa[2,3],3),digits=3))
    obs.number<-paste(fit$stats[1])
    event.number<-paste(fit$freq[2])
    Pre<-Predict(fit,gii,fun=exp,type="predictions",ref.zero = T,conf.int = 0.95,digits = 2)
    
    return(list(Pre=Pre,obs.number=obs.number,event.number=event.number,linear.p=linear.p))
  }
  
  
  options(datadist='dd')
  dd<-datadist(female) 
  dd$limits$gii[2]<-1.2
  result1_female<-rcs_plot(indata=female,behavior="smoking")
  
  options(datadist='dd')
  dd<-datadist(male) 
  dd$limits$gii[2]<-1.2
  result1_male<-rcs_plot(indata=male,behavior="smoking")
  
  sink("p nonlinear.txt")
  rbind(result1_female$linear.p,result1_male$linear.p) 
  sink()

  
  
  n0<-paste0("Number of women: ", result1_female$obs.number)
  n1<-paste0(" Smoking(solid line) ", result1_female$event.number)
  n1x<-paste0(" Smoking(solid line) ", result1_male$event.number)
  
  
  p<-ggplot(female,aes(x=gii))+
    geom_histogram(data=female,aes(x=gii,y=rescale(..density..,c(0,4)), fill="#0099B4FF"),binwidth =0.01,alpha=0.3,show.legend="F")+
 
    geom_line(data=result1_female$Pre,aes(x=gii,yhat),alpha=1,lwd=0.5,linetype=1,color="#0099B4FF",show.legend="F")+
    geom_line(data=result1_male$Pre,aes(x=gii,yhat),alpha=1,lwd=0.5,linetype=1,color="#FDAF91FF",show.legend="F")+
   
    geom_ribbon(data=result1_female$Pre,aes(ymin=lower,ymax=upper,fill="#FDAF91FF"),alpha=0.3,show.legend="F")+ 
    geom_ribbon(data=result1_male$Pre,aes(ymin=lower,ymax=upper,fill="#0099B4FF"),alpha=0.3,show.legend="F")+

    theme_bw()+
    theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())+
    coord_cartesian(xlim=c(0,5),ylim=c(0,6))+
    geom_hline(yintercept=1,linetype=1,size=0.5)+
    
    annotate('text',x=1,y=5.6, label=n0,  size=4,color='#0099B4FF',hjust=0)+
    annotate('text',x=1.1,y=5.4, label=n1,  size=4,color='#0099B4FF',hjust=0)+
    annotate('text',x=1.1,y=4.8, label=n1x,  size=4,color='#FDAF91FF',hjust=0)+
    
    annotate('text',x=2,y=4.4, label="p for non-linearity <0.001",  size=4,color='black',hjust=0)+
    
    annotate('text',x=1.2+0.1,y=0.6,label="0.12",  size=4,color='black', fontface="bold")+
    annotate(geom = "segment", x=1.2, y=0.6, xend=1.2, yend= 0.95, size=0.9, color="black", arrow=arrow(length = unit(2,"mm")))+
    
    labs(title=NULL, x="GII",y="OR (95%CI)")+
    theme(axis.title.x = element_text(size=10, color="black",face="bold", margin = margin(t=20)), 
          axis.title.y = element_text(size=10, color="black",face="bold", margin = margin(r=20)),
          axis.text.x=element_text(size=10, color="black"), axis.text.y=element_text(size=10, color="black"),
          axis.title.y.right = element_text(size=10, color="black",face="bold", margin = margin(l=20)))
  
  
pdf(file="RCS.pdf",width = 12 , height = 10)
  p
dev.off()
  
  
  











