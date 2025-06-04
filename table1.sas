%include '/udd/hpzfa/review/PA/hpfs.doloop.sas';
%include '/udd/hpzfa/review/PA/nhs.doloop.sas';
%include '/udd/hpzfa/review/PA/nhs2.doloop.sas';

proc printto print='OUTPUT_Descrip_Pool' new;

data pooldata;
set nhs1data hpfsdata nhs2data;
if sex=1 then female=1; else female=0;
run;

data nhsdata;
set nhs1data nhs2data;  
run;

%table1(data=pooldata,
        agegroup =  agegp,
        exposure =  attain,
        varlist  =  agecon female white bmicon alcocon aheiconv &smkst_ packy mvit regaspa regibuia cafh cvdfh dbfh &phmsstatus_,                                                  
        noadj    =  agecon,     
        cat      =  female white &smkst_ mvit regaspa regibuia cafh cvdfh dbfh &phmsstatus_, 
        rtftitle =  Table 1 Baseline characteristics, 
        landscape=  F,                               
        file     =  table1Attain, 
        dec      =  1,
        uselbl   =  F);
run;

%table1(data=pooldata,
        agegroup =  agegp,
        exposure =  percdurq,
        varlist  =  agecon female white bmicon alcocon aheiconv &smkst_ packy mvit regaspa regibuia cafh cvdfh dbfh &phmsstatus_,                                                  
        noadj    =  agecon,     
        cat      =  female white &smkst_ mvit regaspa regibuia cafh cvdfh dbfh &phmsstatus_, 
        rtftitle =  Table 1 Baseline characteristics, 
        landscape=  F,                               
        file     =  table1Percent, 
        dec      =  1,
        uselbl   =  F);
run;


/****** Follow-up time ******/ 
proc sort data=pooldata; by id; run;
data fup;
     set pooldata;
     by id;
     if first.id then fup_all=0;
     fup_all+pt_chr;
     if last.id then output;
     keep id fup_all cohort;
     run;

data fup; set fup; 
fupyear_all=fup_all/12; 
run;
proc means n nmiss min mean std median max q1 q3; 
var fupyear_all; 
run;
proc means n nmiss min mean std median max q1 q3; 
var fupyear_all; 
class cohort; run;

data fup_women; set fup;
if cohort ne 2;
run;
proc means data=fup_women n nmiss min mean std median max q1 q3; 
var fupyear_all; 
run;


/****** Cases number   ******/
proc freq data=pooldata;
tables cohort*chrv;
run;


/****** Descriptive statistics for exposures ******/

proc rank data=pooldata out=pooldata group=4;
var   percdur;
ranks percdurquar;
run;

proc sort; by percdurquar; run;
proc means n nmiss min p25 median mean p75 max;
     by percdurquar;
     var percdur;
run;

proc sort data=pooldata; by actq; run;
proc means nmiss min max mean median qrange p25 p75;
     by actq;
     var actcon;
run;

proc sort data=pooldata; by actsimq; run;
proc means nmiss min max mean median qrange p25 p75;
     by actsimq;
     var actsim;
run;

proc sort data=pooldata; by sustainq; run;
proc means nmiss min max mean median qrange p25 p75;
     by sustainq;
     var sustain;
run;

proc sort data=pooldata; by percdurq; run;
proc means nmiss min max mean median qrange p25 p75;
     by percdurq;
     var percdur;
run;

%pre_pm(data=pooldata, out=table, timevar=interval_b,
        irt= irt86 irt88 irt90 irt92 irt94 irt96 irt98 irt00 irt02 irt04 irt06 irt08 irt10 irt12 irt14 irt16 irt18, 
        cutoff= cutoff, dtdx=dt_chr, dtdth=dtdth,
        case=chrv, var=actq);
%pm(data=table, case=chrv, exposure=actq, ref=0);

%pre_pm(data=pooldata, out=table, timevar=interval_b,
        irt= irt86 irt88 irt90 irt92 irt94 irt96 irt98 irt00 irt02 irt04 irt06 irt08 irt10 irt12 irt14 irt16 irt18, 
        cutoff= cutoff, dtdx=dt_chr, dtdth=dtdth,
        case=chrv, var=sustainq);
%pm(data=table, case=chrv, exposure=sustainq, ref=0);

%pre_pm(data=pooldata, out=table, timevar=interval_b,
        irt= irt86 irt88 irt90 irt92 irt94 irt96 irt98 irt00 irt02 irt04 irt06 irt08 irt10 irt12 irt14 irt16 irt18, 
        cutoff= cutoff, dtdx=dt_chr, dtdth=dtdth,
        case=chrv, var=percdurq);
%pm(data=table, case=chrv, exposure=percdurq, ref=0);

%pre_pm(data=pooldata, out=table, timevar=interval_b,
        irt= irt86 irt88 irt90 irt92 irt94 irt96 irt98 irt00 irt02 irt04 irt06 irt08 irt10 irt12 irt14 irt16 irt18, 
        cutoff= cutoff, dtdx=dt_chr, dtdth=dtdth,
        case=chrv, var=percdurquar);
%pm(data=table, case=chrv, exposure=percdurquar, ref=0);


/****** MEN ******/
proc sort data=hpfsdata; by actq; run;
proc means nmiss min max mean median p25 p75 qrange;
     by actq;
     var actcon;
run;

proc sort data=hpfsdata; by actsimq; run;
proc means nmiss min max mean median p25 p75 qrange;
     by actsimq;
     var actsim;
run;

proc sort data=hpfsdata; by sustainq; run;
proc means nmiss min max mean median p25 p75 qrange;
     by sustainq;
     var sustain;
run;

proc sort data=hpfsdata; by percdurq; run;
proc means nmiss min max mean median p25 p75 qrange;
     by percdurq;
     var percdur;
run;

%pre_pm(data=hpfsdata, out=table, timevar=interval,
        irt= irt86 irt88 irt90 irt92 irt94 irt96 irt98 irt00 irt02 irt04 irt06 irt08 irt10 irt12 irt14 irt16 irt18, 
        cutoff= cutoff, dtdx=dt_chr, dtdth=dtdth,
        case=chrv, var=actq);
%pm(data=table, case=chrv, exposure=actq, ref=0);

%pre_pm(data=hpfsdata, out=table, timevar=interval,
        irt= irt86 irt88 irt90 irt92 irt94 irt96 irt98 irt00 irt02 irt04 irt06 irt08 irt10 irt12 irt14 irt16 irt18, 
        cutoff= cutoff, dtdx=dt_chr, dtdth=dtdth,
        case=chrv, var=sustainq);
%pm(data=table, case=chrv, exposure=sustainq, ref=0);

%pre_pm(data=hpfsdata, out=table, timevar=interval,
        irt= irt86 irt88 irt90 irt92 irt94 irt96 irt98 irt00 irt02 irt04 irt06 irt08 irt10 irt12 irt14 irt16 irt18, 
        cutoff= cutoff, dtdx=dt_chr, dtdth=dtdth,
        case=chrv, var=percdurq);
%pm(data=table, case=chrv, exposure=percdurq, ref=0);


/****** WOMEN ******/
proc sort data=nhsdata; by actq; run;
proc means nmiss min max mean median p25 p75 qrange;
     by actq;
     var actcon;
run;

proc sort data=nhsdata; by actsimq; run;
proc means nmiss min max mean median p25 p75 qrange;
     by actsimq;
     var actsim;
run;

proc sort data=nhsdata; by sustainq; run;
proc means nmiss min max mean median p25 p75 qrange;
     by sustainq;
     var sustain;
run;

proc sort data=nhsdata; by percdurq; run;
proc means nmiss min max mean median p25 p75 qrange;
     by percdurq;
     var percdur;
run;

%pre_pm(data=nhsdata, out=table, timevar=interval_b,
        irt= irt86 irt88 irt90 irt92 irt94 irt96 irt98 irt00 irt02 irt04 irt06 irt08 irt10 irt12 irt14 irt16 irt18, 
        cutoff= cutoff, dtdx=dt_chr, dtdth=dtdth,
        case=chrv, var=actq);
%pm(data=table, case=chrv, exposure=actq, ref=0);

%pre_pm(data=nhsdata, out=table, timevar=interval_b,
        irt= irt86 irt88 irt90 irt92 irt94 irt96 irt98 irt00 irt02 irt04 irt06 irt08 irt10 irt12 irt14 irt16 irt18, 
        cutoff= cutoff, dtdx=dt_chr, dtdth=dtdth,
        case=chrv, var=sustainq);
%pm(data=table, case=chrv, exposure=sustainq, ref=0);

%pre_pm(data=nhsdata, out=table, timevar=interval_b,
        irt= irt86 irt88 irt90 irt92 irt94 irt96 irt98 irt00 irt02 irt04 irt06 irt08 irt10 irt12 irt14 irt16 irt18, 
        cutoff= cutoff, dtdx=dt_chr, dtdth=dtdth,
        case=chrv, var=percdurq);
%pm(data=table, case=chrv, exposure=percdurq, ref=0);


proc corr data=pooldata;
var sustain actcon;
run;

