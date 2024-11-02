libname temp "datafileflod";
%let outfile=outputfilefold;


/*******************distribution of GII***********************************/
proc sql noprint;
create table gii as select distinct provid ,georegion,rural_urban,mean_avgincom, GII 
from temp.demo;
quit;

proc means data=gii mean min max std n;
var gii;
ods output summary=summary;
run;

proc npar1way wilcoxon data=gii;
class georegion;
var gii;
ods output KruskalWallisTest=K_test;
run;

/*-------------------correlation of GII and Disposable income per capita-------------*/
proc corr data=gii  spearman;
var gii mean_avgincom;
by rural_urban;
ODS OUTPUT spearmancorr=spearmancorr;
run;

goptions reset=all;
options orientation=landscape ;
ods listing gpath="&outfile.\"  ;
ods graphics on / reset=index imagename="GII avgincom corr" width=800px height=800px imagefmt=pdf;
proc sgplot data=gii noautolegend  nowall noborder;
scatter x=gii y=mean_avgincom/group=rural_urban markerattrs=(symbol=squarefilled) name='a';
reg x=gii y=mean_avgincom/group=rural_urban nomarkers lineattrs=(pattern=solid);
yaxis label='Disposable income per capita, 1000 RMB Yuan' values=(0 to 80 by 20);
xaxis label='GII'  labelattrs=(weight=bold) values=(0 to 10 by 2);
inset (	 " p value for Spearman test"="=<0.01")
		/  TITLE=' ' TEXTATTRS=(Color=black  Size=9  Style=Italic) position=topright;
keylegend 'a'/location=inside position=top noborder;
run;
ods listing close;
ods graphics off;



/*-------------------------GII plots by province -----------------------*/
data provname;
length provname $64;
input provid provname $;
cards;
1 PROV1
2 PROV2
3 PROV3
;;
run;

proc sql noprint;
	create table tab as select distinct
		a.provid,d.provname,a.rural_urban,	a.gii,a.mean_avgincom
		from demo a left join provname d on a.provid=d.provid ;
quit;

proc sql noprint;
	create table giifigure as select distinct
		a.provid,
		a.provname,
		a.gii as rural_gii,a.mean_avgincom as rural_avgincom,
		b.gii as urban_gii,b.mean_avgincom as urban_avgincom
		from tab(where=(rural_urban='Rural')) a 
		left join tab(where=(rural_urban='Urban')) b on a.provname=b.provname
		order by a.gii;
quit;


proc template;
	define statgraph gii;
		begingraph;
			entrytitle "";
				layout overlay/cycleattrs=true
					xaxisopts=(label=' ')
					yaxisopts=(offsetmin=0 
								label='GII'
								linearopts=(tickvaluesequence=(start=0 end=10 increment=2) viewmin=0 viewmax=10)) 
					y2axisopts=(offsetmin=0 
								label='Disposable income per capita, 1000 RMB Yuan'
								linearopts=(tickvaluesequence=(start=0 end=100 increment=20) viewmin=0 viewmax=100)) ;

					barchart x=provname y=rural_avgincom/stat=mean name="Rural"
														legendlabel="Rural" fillattrs=(color=orange transparency=0.6) outlineattrs=(color=orange)
														discreteoffset=-0.3 barwidth=0.5 yaxis=y2 ;
					barchart x=provname y=urban_avgincom/stat=mean name="Urban"
														legendlabel="Urban" fillattrs=(color=green  transparency=0.6)  outlineattrs=(color=green)
														discreteoffset=0 barwidth=0.5 yaxis=y2;
					discretelegend "Rural" "Urban"/title=""	 location=inside halign=right valign=top border=no;

					scatterplot  x=provname y=rural_gii/  yaxis=y markerattrs=(symbol=circlefilled) discreteoffset=-0.3 markerattrs=(color=orange) ;
					scatterplot  x=provname y=urban_gii/  yaxis=y markerattrs=(symbol=circlefilled)  discreteoffset=0.1 markerattrs=(color=green);
			endlayout;
		endgraph;
	end;
run;

goptions reset=all;
options orientation=landscape ;
ods listing gpath="&outfile.\"  ;
ods graphics on / reset=index imagename="Figure1 GII barplot by province" width=1000px height=800px imagefmt=pdf;
proc sgrender data=giifigure template=gii;run;
ods listing close;
ods graphics off;



