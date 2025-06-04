* * * * * * * * * * * * * * * * * * * * * * * * * * *
*        JOINT ANALYSIS - Volume & Duration         *
* * * * * * * * * * * * * * * * * * * * * * * * * * *;

%include '/udd/hpzfa/review/PA/hpfs.doloop.sas';
%include '/udd/hpzfa/review/PA/nhs.doloop.sas';
%include '/udd/hpzfa/review/PA/nhs2.doloop.sas';

data pooldata;
set nhs1data hpfsdata nhs2data;
run;

proc printto print='OUTPUT_Joint' new;

proc rank data=pooldata out=pooldata group=3;
var   actcon  percdur;
ranks actt    percdurt;
run;

proc sort; by actt; run;
proc means n nmiss min p25 median mean p75 max;
by actt;
var actcon;
run;

proc sort; by percdurt; run;
proc means n nmiss min p25 median mean p75 max;
by percdurt;
var percdur;
run;


data pooldata;
set pooldata end=_end_;

%indic3(vbl=aheiq, prefix=aheiq, min=1, max=3, reflev=0, missing=., usemiss=1);   

if actt=0 and percdurt=0 then do;
  Joint1=0; Joint2=0; Joint3=0; Joint4=0; Joint5=0; Joint6=0; Joint7=0; Joint8=0; end;
else if actt=0 and percdurt=1 then do;
  Joint1=1; Joint2=0; Joint3=0; Joint4=0; Joint5=0; Joint6=0; Joint7=0; Joint8=0; end;
else if actt=0 and percdurt=2 then do;
  Joint1=0; Joint2=1; Joint3=0; Joint4=0; Joint5=0; Joint6=0; Joint7=0; Joint8=0; end;

else if actt=1 and percdurt=0 then do;
  Joint1=0; Joint2=0; Joint3=1; Joint4=0; Joint5=0; Joint6=0; Joint7=0; Joint8=0; end;
else if actt=1 and percdurt=1 then do;
  Joint1=0; Joint2=0; Joint3=0; Joint4=1; Joint5=0; Joint6=0; Joint7=0; Joint8=0; end;
else if actt=1 and percdurt=2 then do;
  Joint1=0; Joint2=0; Joint3=0; Joint4=0; Joint5=1; Joint6=0; Joint7=0; Joint8=0; end;

else if actt=2 and percdurt=0 then do;
  Joint1=0; Joint2=0; Joint3=0; Joint4=0; Joint5=0; Joint6=1; Joint7=0; Joint8=0; end;
else if actt=2 and percdurt=1 then do;
  Joint1=0; Joint2=0; Joint3=0; Joint4=0; Joint5=0; Joint6=0; Joint7=1; Joint8=0; end;
else if actt=2 and percdurt=2 then do;
  Joint1=0; Joint2=0; Joint3=0; Joint4=0; Joint5=0; Joint6=0; Joint7=0; Joint8=1; end;

run;


%let cov1=white &phmsstatus_ cafh cvdfh dbfh &smkpy_ &alcc_ &aheiq_ &bmicat_ mvit  regaspa  regibuia ;
%let cov2=white &phmsstatus_ cafh cvdfh dbfh &smkpy_ &alcc_ &aheiq_          mvit  regaspa  regibuia ;

%mphreg9(data=pooldata, event=chrv, qret=irt86 irt88 irt90 irt92 irt94 irt96 irt98 irt00 irt02 irt04 irt06 irt08 irt10 irt12 irt14 irt16 irt18,
         timevar=t86 t88 t90 t92 t94 t96 t98 t00 t02 t04 t06 t08 t10 t12 t14 t16 t18,
         id=id, labels=f,
         tvar=interval_b,
         agevar=agemos,
         strata=agemos interval_b cohort, 
         cutoff=cutoff,
         dtdx=dt_chr, dtdth=dtdth, outdat=result,
         model1 =Joint1 Joint2 Joint3 Joint4 Joint5 Joint6 Joint7 Joint8 &cov2);         
         run;

data result;
   set result;
   
   ind_var=substr(variable,1,4);
   if ind_var='Join';
   RR=put(HazardRatio,4.2)|| ' (' ||put(LCL,4.2)|| ', ' ||put(UCL,4.2)|| ')';
   keep variable RR ProbChisq Estimate StdErr;  
   run;

ODS CSV FILE="Table_joint.csv"; 
proc print data=result;
run;
ODS CSV CLOSE;
