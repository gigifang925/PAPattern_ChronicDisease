%include '/udd/hpzfa/review/PA/lag/hpfs.doloop8.sas';
%include '/udd/hpzfa/review/PA/lag/nhs.doloop8.sas';
%include '/udd/hpzfa/review/PA/lag/nhs2.doloop8.sas';

data pooldata;
set nhs1data hpfsdata nhs2data end=_end_;
%indic3(vbl=aheiq, prefix=aheiq, min=1, max=3, reflev=0, missing=., usemiss=1);   
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

%median(actsim, actsimq, act_med);

data pooldata;
set pooldata;   
   act_med15=act_med/15;
run;


/***  MACRO ***/
%let cov1=white &phmsstatus_ cafh cvdfh dbfh &smkpy_ &alcc_ &aheiq_ &bmicat_ mvit  regaspa  regibuia ;
%let cov2=white &phmsstatus_ cafh cvdfh dbfh &smkpy_ &alcc_ &aheiq_          mvit  regaspa  regibuia ;

%mphreg9(data=pooldata, event=chrv, qret=irt94 irt96 irt98 irt00 irt02 irt04 irt06 irt08 irt10 irt12 irt14 irt16 irt18,
         timevar=t94 t96 t98 t00 t02 t04 t06 t08 t10 t12 t14 t16 t18,
         id=id, labels=f,
         tvar=interval_b,
         agevar=agemos,
         strata=agemos interval_b cohort, 
         cutoff=cutoff,
         dtdx=dt_chr, dtdth=dtdth, outdat=result,
       	model1 =act_med15  ,
         model2 =act_med15   &cov2  ,
         model3 =act_med15   &cov1 );

