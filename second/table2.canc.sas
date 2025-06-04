* * * * * * * * * * * * * * * * * * * * * * * *
*           Long-term PA - CANCER  Cox        *
* * * * * * * * * * * * * * * * * * * * * * * *;

%include '/udd/hpzfa/review/PA/second/canc/hpfs.doloop.sas';
%include '/udd/hpzfa/review/PA/second/canc/nhs.doloop.sas';
%include '/udd/hpzfa/review/PA/second/canc/nhs2.doloop.sas';

data pooldata;
set nhs1data hpfsdata nhs2data;
run;

proc datasets;
delete nhs1data nhs2data hpfsdata;
run;

proc rank data=pooldata out=pooldata group=4;
var   percdur;
ranks percdurquar;
run;

data pooldata;
set pooldata end=_end_;
sustain10=sustain/5;  /* per 5-cycle = 10-year */
percdur50=percdur/0.5;  /* per 50% increment */
%indic3(vbl=aheiq, prefix=aheiq, min=1, max=3, reflev=0, missing=., usemiss=1);   
%indic3(vbl=sustainq, prefix=sustainq, min=1, max=3, reflev=0, missing=., usemiss=0);   
%indic3(vbl=actq, prefix=actq, min=1, max=3, reflev=0, missing=., usemiss=0);   
%indic3(vbl=percdurquar, prefix=percdurquar, min=1, max=3, reflev=0, missing=., usemiss=0);
run;

/****** MEDIAN *******/
%macro median(var, quantvar, quantcont);
proc sort data=pooldata; by cohort &quantvar; run;
proc means data=pooldata n nmiss median p25 p75;
     var &var;
     by cohort &quantvar;
     output out=median MEDIAN=&quantcont;
run;
data median; set median; keep cohort &quantvar &quantcont; run; proc sort; by cohort &quantvar; run;
data pooldata; merge pooldata median; by cohort &quantvar; run;
%mend;

%median(actcon, actq, act_med);

data pooldata;
set pooldata;
act_med15=act_med/15;
run;


proc printto print='OUTPUT_Main_Pool' new;

/***  MACRO ***/
%let cov1=white &phmsstatus_ cafh cvdfh dbfh &smkpy_ &alcc_ &aheiq_ &bmicat_ mvit  regaspa  regibuia ;
%let cov2=white &phmsstatus_ cafh cvdfh dbfh &smkpy_ &alcc_ &aheiq_          mvit  regaspa  regibuia ;

%mphreg9(data=pooldata, event=tot_cancerv, qret=irt86 irt88 irt90 irt92 irt94 irt96 irt98 irt00 irt02 irt04 irt06 irt08 irt10 irt12 irt14 irt16 irt18,
         timevar=t86 t88 t90 t92 t94 t96 t98 t00 t02 t04 t06 t08 t10 t12 t14 t16 t18,
         id=id, labels=f,
         tvar=interval_b,
         agevar=agemos,
         strata=agemos interval_b cohort, 
         cutoff=cutoff,
         dtdx=dt_totcancer, dtdth=dtdth, outdat=result,
         model1 =&actq_  ,
         model2 =&actq_  &cov2  ,
         model3 =&actq_  &cov1  ,
         model4 =act_med15  ,
         model5 =act_med15  &cov2  ,
         model6 =act_med15  &cov1  ,
         model7 =&sustainq_  ,
         model8 =&sustainq_  &cov2  ,
         model9 =&sustainq_  &cov1  ,
         model10 =sustain10,
         model11 =sustain10   &cov2  ,
         model12 =sustain10   &cov1  ,
         model13 =&percdurquar_  ,
         model14 =&percdurquar_  &cov2  ,
         model15 =&percdurquar_  &cov1  ,
         model16 =percdur50,
         model17 =percdur50   &cov2  ,
         model18 =percdur50   &cov1  );          
         run;
 
data result;
   length model $ 50. ; 
   set result;
   
   ind_var=substr(variable,1,3);
   if ind_var in ('sus', 'per', 'act');
   RR=put(HazardRatio,4.2)|| ' (' ||put(LCL,4.2)|| ', ' ||put(UCL,4.2)|| ')';
   
   if modelno in (1,4,7,10,13,16) then model='age';
   if modelno in (2,5,8,11,14,17) then model='full';
   if modelno in (3,6,9,12,15,18) then model='bmi';

   keep variable model RR ProbChisq Estimate StdErr;  
   run;

ODS CSV FILE="Table_pool.csv"; 
proc print data=result;
run;
ODS CSV CLOSE;

endsas;
