* * * * * * * * * * * * * * * * * * * *
*       SPLINE ANALYSIS - Volume      *
* * * * * * * * * * * * * * * * * * * *;

%include '/udd/hpzfa/review/PA/second/canc/hpfs.doloop.sas';
%include '/udd/hpzfa/review/PA/second/canc/nhs.doloop.sas';
%include '/udd/hpzfa/review/PA/second/canc/nhs2.doloop.sas';

data pooldata;
set nhs1data hpfsdata nhs2data end=_end_;
%indic3(vbl=aheiq, prefix=aheiq, min=1, max=3, reflev=0, missing=., usemiss=1);   
run;

proc printto print='OUTPUT_Spline' new;

/***  MACRO ***/
%let cov1=white &phmsstatus_ cafh cvdfh dbfh &smkpy_ &alcc_ &aheiq_ &bmicat_ mvit  regaspa  regibuia ;
%let cov2=white &phmsstatus_ cafh cvdfh dbfh &smkpy_ &alcc_ &aheiq_          mvit  regaspa  regibuia ;

%LGTPHCURV9 (data=pooldata, 
		exposure=actcon,
             	case=tot_cancerv,
		model=cox,
		time=pt_totcancer,
		strata=agemos interval_b cohort,
 		adj=&cov2,
                  refval=min,
                  select=3,
                  nk=5,
                  lpct=5, hpct=95,	
                  outplot=jpeg,	
                  displayx=T,
                  plot=2,
		pictname=spline.can.jpeg,          	                 
                  hlabel=%quote(Volume, MET-hour/week), vlabel=%quote(HR), 
                  header1=%quote(Physical activity volume and risk of cancer),
		axordv=0.5 to 1.0 by .1);
run;
