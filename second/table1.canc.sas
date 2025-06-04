%include '/udd/hpzfa/review/PA/second/canc/hpfs.doloop.sas';
%include '/udd/hpzfa/review/PA/second/canc/nhs.doloop.sas';
%include '/udd/hpzfa/review/PA/second/canc/nhs2.doloop.sas';

proc printto print='OUTPUT_Descrip_Pool' new;

data pooldata;
set nhs1data hpfsdata nhs2data;
run;

proc rank data=pooldata out=pooldata group=4;
var   percdur;
ranks percdurquar;
run;

/****** Follow-up time ******/ 
proc sort data=pooldata; by id; run;
data fup;
     set pooldata;
     by id;
     if first.id then fup_all=0;
     fup_all+pt_totcancer;
     if last.id then output;
     keep id fup_all cohort;
     run;

data fupyear; set fup; 
fupyear_all=fup_all/12; 
run;

proc means n nmiss min mean std median max q1 q3; 
var fupyear_all; 
class cohort; run;


/****** Cases number   ******/
proc freq data=pooldata;
tables cohort*tot_cancerv;
run;


/****** Descriptive statistics for exposures ******/

proc sort data=pooldata; by actq; run;
proc means nmiss min max mean median p25 p75 qrange;
     by actq;
     var actcon;
run;

proc sort data=pooldata; by actsimq; run;
proc means nmiss min max mean median p25 p75 qrange;
     by actsimq;
     var actsim;
run;

proc sort data=pooldata; by sustainq; run;
proc means nmiss min max mean median p25 p75 qrange;
     by sustainq;
     var sustain;
run;

proc sort data=pooldata; by percdurquar; run;
proc means nmiss min max mean median p25 p75 qrange;
     by percdurquar;
     var percdur;
run;

proc sort data=pooldata; by percdurq; run;
proc means nmiss min max mean median p25 p75 qrange;
     by percdurq;
     var percdur;
run;

%pre_pm(data=pooldata, out=table, timevar=interval_b,
        irt= irt86 irt88 irt90 irt92 irt94 irt96 irt98 irt00 irt02 irt04 irt06 irt08 irt10 irt12 irt14 irt16 irt18, 
        cutoff= cutoff, dtdx=dt_totcancer, dtdth=dtdth,
        case=tot_cancerv, var=actq);
%pm(data=table, case=tot_cancerv, exposure=actq, ref=0);

%pre_pm(data=pooldata, out=table, timevar=interval_b,
        irt= irt86 irt88 irt90 irt92 irt94 irt96 irt98 irt00 irt02 irt04 irt06 irt08 irt10 irt12 irt14 irt16 irt18, 
        cutoff= cutoff, dtdx=dt_totcancer, dtdth=dtdth,
        case=tot_cancerv, var=sustainq);
%pm(data=table, case=tot_cancerv, exposure=sustainq, ref=0);

%pre_pm(data=pooldata, out=table, timevar=interval_b,
        irt= irt86 irt88 irt90 irt92 irt94 irt96 irt98 irt00 irt02 irt04 irt06 irt08 irt10 irt12 irt14 irt16 irt18, 
        cutoff= cutoff, dtdx=dt_totcancer, dtdth=dtdth,
        case=tot_cancerv, var=percdurquar);
%pm(data=table, case=tot_cancerv, exposure=percdurquar, ref=0);

