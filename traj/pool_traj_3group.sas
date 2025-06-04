* * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*      PA TRAJECTORY AT 40-60 - Identify 3 groups       *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * *;

%include '/udd/hpzfa/review/PA/traj/hpfs_traj_4060.sas';
%include '/udd/hpzfa/review/PA/traj/nhs_traj_4060.sas';
%include '/udd/hpzfa/review/PA/traj/nhs2_traj_4060.sas';

libname traj '/udd/hpzfa/review/PA/traj/traj_output/';

data pool_traj;
set hpfs_traj_sample nhs_traj_sample nhs2_traj_sample;
run;

/*Exclude consistently inactive group that will be manually identified */
data pool_traj;
set pool_traj;
if act_40>=7.5 or act_44>=7.5 or act_48>=7.5 or act_52>=7.5 or act_56>=7.5 or act_60>=7.5;
run;

/* Determine function forms based on BIC */

PROC TRAJ DATA=pool_traj OUT=OF_3 OUTPLOT=OP_3 OUTSTAT=OS_3 OUTEST=OE_3 ITDETAIL;
    ID id; VAR act_40 act_44 act_48 act_52 act_56 act_60; INDEP age_40 age_44 age_48 age_52 age_56 age_60;
    MODEL CNORM; MAX 100; NGROUPS 3; ORDER 3 3 3 ;
RUN;

PROC TRAJ DATA=pool_traj OUT=OF_3 OUTPLOT=OP_3 OUTSTAT=OS_3 OUTEST=OE_3 ITDETAIL;
    ID id; VAR act_40 act_44 act_48 act_52 act_56 act_60; INDEP age_40 age_44 age_48 age_52 age_56 age_60;
    MODEL CNORM; MAX 100; NGROUPS 3; ORDER 2 3 3 ;
RUN;

PROC TRAJ DATA=pool_traj OUT=OF_3 OUTPLOT=OP_3 OUTSTAT=OS_3 OUTEST=OE_3 ITDETAIL;
    ID id; VAR act_40 act_44 act_48 act_52 act_56 act_60; INDEP age_40 age_44 age_48 age_52 age_56 age_60;
    MODEL CNORM; MAX 100; NGROUPS 3; ORDER 1 3 3 ;
RUN;

PROC TRAJ DATA=pool_traj OUT=OF_3 OUTPLOT=OP_3 OUTSTAT=OS_3 OUTEST=OE_3 ITDETAIL;
    ID id; VAR act_40 act_44 act_48 act_52 act_56 act_60; INDEP age_40 age_44 age_48 age_52 age_56 age_60;
    MODEL CNORM; MAX 100; NGROUPS 3; ORDER 2 2 3 ;
RUN;

PROC TRAJ DATA=pool_traj OUT=OF_3 OUTPLOT=OP_3 OUTSTAT=OS_3 OUTEST=OE_3 ITDETAIL;
    ID id; VAR act_40 act_44 act_48 act_52 act_56 act_60; INDEP age_40 age_44 age_48 age_52 age_56 age_60;
    MODEL CNORM; MAX 100; NGROUPS 3; ORDER 1 2 3 ;
RUN;

PROC TRAJ DATA=pool_traj OUT=OF_3 OUTPLOT=OP_3 OUTSTAT=OS_3 OUTEST=OE_3 ITDETAIL;
    ID id; VAR act_40 act_44 act_48 act_52 act_56 act_60; INDEP age_40 age_44 age_48 age_52 age_56 age_60;
    MODEL CNORM; MAX 100; NGROUPS 3; ORDER 1 1 3 ;
RUN;

PROC TRAJ DATA=pool_traj OUT=OF_3 OUTPLOT=OP_3 OUTSTAT=OS_3 OUTEST=OE_3 ITDETAIL;
    ID id; VAR act_40 act_44 act_48 act_52 act_56 act_60; INDEP age_40 age_44 age_48 age_52 age_56 age_60;
    MODEL CNORM; MAX 100; NGROUPS 3; ORDER 2 2 2 ;
RUN;

PROC TRAJ DATA=pool_traj OUT=OF_3 OUTPLOT=OP_3 OUTSTAT=OS_3 OUTEST=OE_3 ITDETAIL;
    ID id; VAR act_40 act_44 act_48 act_52 act_56 act_60; INDEP age_40 age_44 age_48 age_52 age_56 age_60;
    MODEL CNORM; MAX 100; NGROUPS 3; ORDER 1 2 2 ;
RUN;

PROC TRAJ DATA=pool_traj OUT=OF_3 OUTPLOT=OP_3 OUTSTAT=OS_3 OUTEST=OE_3 ITDETAIL;
    ID id; VAR act_40 act_44 act_48 act_52 act_56 act_60; INDEP age_40 age_44 age_48 age_52 age_56 age_60;
    MODEL CNORM; MAX 100; NGROUPS 3; ORDER 1 1 2 ;
RUN;

PROC TRAJ DATA=pool_traj OUT=OF_3 OUTPLOT=OP_3 OUTSTAT=OS_3 OUTEST=OE_3 ITDETAIL;
    ID id; VAR act_40 act_44 act_48 act_52 act_56 act_60; INDEP age_40 age_44 age_48 age_52 age_56 age_60;
    MODEL CNORM; MAX 100; NGROUPS 3; ORDER 1 1 1 ;
RUN;
