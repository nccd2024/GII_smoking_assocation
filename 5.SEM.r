library(haven)
library(lavaan)
library(psych)
library(semTools)
library(semPlot)
library(Hmisc)
library(openxlsx)



set.seed(20231124)


model1<- '
GIIMODEL =~ 
GII0XX+GII1XX+
GII2XX+GII4XX

SES =~ OCCUPATION_FARMER
+HIGH_SCHOOL_GRADUATED
+LAST_YEAR_INCOME_GR_50K
+MARRIAGE_YES
+INSURE_YES

SMK =~ SMOKING

SES ~ A*GIIMODEL+AGE
SMK ~ C*GIIMODEL+B*SES+AGE
DEATH ~ F*GIIMODEL+D*SMK+E*SES+AGE

GIIMODEL~~GIIMODEL
SMK~~SMK
SES~~SES
DEATH~~DEATH


IDESMK :=A*B
TOTALSMK :=A*B+C
DSMK :=(1-IDESMK/TOTALSMK)*100
MSMK :=IDESMK/TOTALSMK*100

IDEOUTCOME :=TOTALSMK*D
TOTALOUTCOME :=TOTALSMK*D+A*E+F
DOUTCOME :=(1-IDEOUTCOME/TOTALOUTCOME)*100
MOUTCOME :=IDEOUTCOME/TOTALOUTCOME*100
'

setwd('Outputfilefold')


##############################female
female<-read_sas("demo.sas7bdat")
names(female)<-toupper(names(female))

fit1<-sem(model1,data=female)
#negative SE
#lavaan::standardizedsolution(fit)


cairo_pdf(file=paste("SEM female DEATH",".pdf"),width=200,height=200)
semPaths(fit1,edge.label.cex = 0.8,
         curvePivot=F,
         whatLabels = "std",
         layout="tree",
         edge.color = "darkgreen",
         color="lightblue")
dev.off()

saveRDS(fit1,"femalefit1.rds")

p1<-parameterestimates(fit1,boot.ci.type = "bca.simple")
p1$mark<-"SEM1 female overall"
pp1<-as.data.frame(fitMeasures(fit1,c("chisq","df","gfi","agfi","cfi","nfi","rmsea","srmr","tli","aic"))) 
new<-c("SEM1 female")
pp1<-rbind(pp1,new)

px<-rbind(p1,p11 )
ppx<-cbind(pp1)


wb<-createWorkbook()
addWorksheet(wb,"Parameter")
writeData(wb,"Parameter",px)
saveWorkbook(wb,"SEM.xlsx",overwrite = T)

addWorksheet(wb,"fitMeasures")
writeData(wb,"fitMeasures",ppx)
saveWorkbook(wb,"SEM.xlsx",overwrite = T)