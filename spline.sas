* * * * * * * * * * * * * * * * * * * *
*       SPLINE ANALYSIS - Volume      *
* * * * * * * * * * * * * * * * * * * *;

%include '/udd/hpzfa/review/PA/hpfs.doloop.sas';
%include '/udd/hpzfa/review/PA/nhs.doloop.sas';
%include '/udd/hpzfa/review/PA/nhs2.doloop.sas';

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
             	case=chrv,
		model=cox,
		time=pt_chr,
		strata=agemos interval_b cohort,
 		adj=&cov2,
                  refval=min,
                  select=3,
                  nk=5,
                  lpct=5, hpct=95,	
                  outplot=jpeg,	
                  displayx=T,
                  plot=2,
		pictname=spline.chr.jpeg,          	                 
                  hlabel=%quote(Volume, MET-hours/week), vlabel=%quote(HR), 
                  header1=%quote(Physical activity volume and risk of major chronic diseases),
		axordv=0.5 to 1.0 by .1);
run;
