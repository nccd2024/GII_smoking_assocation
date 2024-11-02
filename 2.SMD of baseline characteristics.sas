libname temp "datafileflod";
%include "stddiff_from_cleveland_clinic.sas";/*download from https://lerner.ccf.org/quantitative-health/documents/stddiff.sas*/
%let outfile=outputfilefold;



%let charvar_table=
rural
laborforce
Occupation_Farmer
High_school_graduated
Last_year_income_gr_50k
marriage_yes
insure_yes
Hx_HTN
Hx_DM
Hx_CVD;

%let numvar_table=age mean_avgincom;

%stddiff( inds =temp.demo , 
			groupvar =female , 
			numvars = &numvar_table., 
			charvars = &charvar_table.,  
			wtvar = wi,
	   		stdfmt = 8.5,
			outds =_stddiff);





