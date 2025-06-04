* * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*      FINAL PA TRAJECTORY AT 40-60 - 3,4,5 groups      *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * *;

%include '/udd/hpzfa/review/PA/traj/hpfs_traj_4060.sas';
%include '/udd/hpzfa/review/PA/traj/nhs_traj_4060.sas';
%include '/udd/hpzfa/review/PA/traj/nhs2_traj_4060.sas';

libname traj '/udd/hpzfa/review/PA/traj/traj_output/';

data pool_traj;
set hpfs_traj_sample nhs_traj_sample nhs2_traj_sample;
run;

proc sort; by cohort; run;
proc means n nmiss mean median min max;
by cohort;
var act_40 act_44 act_48 act_52 act_56 act_60;
run;

data pool_traj;
set pool_traj;
if act_40>=7.5 or act_44>=7.5 or act_48>=7.5 or act_52>=7.5 or act_56>=7.5 or act_60>=7.5;
run;

PROC TRAJ DATA=pool_traj OUT=OF_3 OUTPLOT=OP_3 OUTSTAT=OS_3 OUTEST=OE_3 ITDETAIL;
    ID id; VAR act_40 act_44 act_48 act_52 act_56 act_60; INDEP age_40 age_44 age_48 age_52 age_56 age_60;
    MODEL CNORM; MAX 100; NGROUPS 3; ORDER 3 3 3 ;
RUN;

data traj.traj4060_3group;
set OF_3;
run;
data traj.traj4060_3plot;
set OP_3;
run;
data traj.traj4060_3plotest;
set OS_3;
run;
data traj.traj4060_3est;
set OE_3;
run;

PROC TRAJ DATA=pool_traj OUT=OF_4 OUTPLOT=OP_4 OUTSTAT=OS_4 OUTEST=OE_4 ITDETAIL;
    ID id; VAR act_40 act_44 act_48 act_52 act_56 act_60; INDEP age_40 age_44 age_48 age_52 age_56 age_60;
    MODEL CNORM; MAX 100; NGROUPS 4; ORDER 3 3 3 3 ;
RUN;

data traj.traj4060_4group;
set OF_4;
run;
data traj.traj4060_4plot;
set OP_4;
run;
data traj.traj4060_4plotest;
set OS_4;
run;
data traj.traj4060_4est;
set OE_4;
run;

PROC TRAJ DATA=pool_traj OUT=OF_5 OUTPLOT=OP_5 OUTSTAT=OS_5 OUTEST=OE_5 ITDETAIL;
    ID id; VAR act_40 act_44 act_48 act_52 act_56 act_60; INDEP age_40 age_44 age_48 age_52 age_56 age_60;
    MODEL CNORM; MAX 100; NGROUPS 5; ORDER 3 3 3 3 3 ;
RUN;

data traj.traj4060_5group;
set OF_5;
run;
data traj.traj4060_5plot;
set OP_5;
run;
data traj.traj4060_5plotest;
set OS_5;
run;
data traj.traj4060_5est;
set OE_5;
run;
