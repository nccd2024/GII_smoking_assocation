libname temp "datafileflod";
%let outfile=outputfilefold;


%let covar=age rural mean_avgincom 
Occupation_Farmer
High_school_graduated
Last_year_income_gr_50k
marriage_yes
insure_yes
Hx_HTN
Hx_DM
Hx_CVD
tc_grp20_1 tc_grp20_2 tc_grp20_3 tc_grp20_4 tc_grp20_5 
sbp_grp20_1 sbp_grp20_2 sbp_grp20_3 sbp_grp20_4 sbp_grp20_5 
dbp_grp20_1 dbp_grp20_2 dbp_grp20_3 dbp_grp20_4 dbp_grp20_5 
glu_grp20_1 glu_grp20_2 glu_grp20_3 glu_grp20_4 glu_grp20_5 
bmi_grp20_1 bmi_grp20_2 bmi_grp20_3 bmi_grp20_4 bmi_grp20_5 ;



proc glimmix data=temp.demo  method=laplace maxopt=200;
  class provid rural_urban;
  model smoking(event='1')=gii0xx gii1xx gii2xx gii4xx &covar./solution dist=binary link=logit ddfm=bw cl;
  random  intercept/solution  subject=provid type=chol CL;
  ods  output ParameterEstimates=model_result2;
   weight wi;
run;
quit;

data model_result2;
set model_result2;
     if effect~='Intercept' then 
       do;
         OR=exp(Estimate);
         L_95=exp(Estimate-1.96*stderr);
         H_95=exp(Estimate+1.96*stderr);
       end;
run;

