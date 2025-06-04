%include '/udd/hpzfa/review/PA/traj/hpfs_traj_4060.sas';
%include '/udd/hpzfa/review/PA/traj/nhs_traj_4060.sas';
%include '/udd/hpzfa/review/PA/traj/nhs2_traj_4060.sas';

libname traj '/udd/hpzfa/review/PA/traj/traj_output/';

proc printto print='OUTPUT_Descript_Pool' new;

data pool_traj;
set hpfs_traj_sample nhs_traj_sample nhs2_traj_sample;
fupyrs=fupmos/12;
if chr ne 1 then chr=0;
keep id cohort age_40 age_44 age_48 age_52 age_56 age_60 act_40 act_44 act_48 act_52 act_56 act_60  
     fupyrs fupmos chr dt_chr dtdth DXage_chronic DXage_death DXage_min EVENTtime_min  
     agecon  white  sex  smkst  smkpy  alcc  regaspa  regibuia  mvit  cafh  dbfh  cvdfh  aheicon  phmsstatus
     bmicon  alcocon  packy
;
run;
proc sort; by id; run;


/* GROUP0: consistently inactive */
data set1;
set pool_traj;
if act_40<7.5 and act_44<7.5 and act_48<7.5 and act_52<7.5 and act_56<7.5 and act_60<7.5;
GROUP=0; /* manual identification: consistently inactive */
run;

proc means mean clm min max;
var act_40 act_44 act_48 act_52 act_56 act_60;
run;

data set1;
set set1;
keep id GROUP;
run;

/* GROUP1,2,3,4 */
data set2;
set traj.traj4060_4group;
keep id GROUP;
run;

data traj_group;
set set1 set2;
run;
proc sort; by id; run; 

proc print data=traj.traj4060_4plot;
run;


/* Merge All Groups */
data final_data;
merge pool_traj traj_group;
by id;
if GROUP=. then delete;
run;

proc freq data=final_data;
table GROUP;
run;

proc freq data=final_data;
table cohort;
run;

data final_data;
set final_data end=_end_;
%indic3(vbl=smkst, prefix=smkst, min=2, max=3, reflev=1, usemiss=1, missing=., 
                        label1='never smoker', 
                        label2='past smoker', 
                        label3='current smoker');
%indic3(vbl=phmsstatus, prefix=phmsstatus, min=2, max=4, reflev=1, missing=., usemiss=1,      
                        label1='pre mnp',      
                        label2='never/unknown pmhuser, post mnp',      
                        label3='past pmh user and post mnp',      
                        label4='curr pmhuser and post mnp');  
run;


%table1(data=final_data,
        ageadj   =  F,
        exposure =  GROUP,
        varlist  =  agecon sex white bmicon alcocon aheicon &smkst_ packy mvit regaspa regibuia cafh cvdfh dbfh &phmsstatus_,                                                      
        cat      =  sex white &smkst_ mvit regaspa regibuia cafh cvdfh dbfh &phmsstatus_, 
        rtftitle =  Table 1 Baseline characteristics, 
        landscape=  F,                               
        file     =  table1, 
        dec      =  1,
        uselbl   =  F);
run;
