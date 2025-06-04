* * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*     PA TRAJECTORY AT 40-60 - CHRONIC Disease  Cox     *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * *;

%include '/udd/hpzfa/review/PA/traj/hpfs_traj_4060.sas';
%include '/udd/hpzfa/review/PA/traj/nhs_traj_4060.sas';
%include '/udd/hpzfa/review/PA/traj/nhs2_traj_4060.sas';

libname traj '/udd/hpzfa/review/PA/traj/traj_output/';

proc printto print='OUTPUT_Main_Pool' new;

data pool_traj;
set hpfs_traj_sample nhs_traj_sample nhs2_traj_sample;
fupyrs=fupmos/12;
fupyrs_cvd=fupmos_cvd/12;
fupyrs_canc=fupmos_canc/12;
fupyrs_db=fupmos_db/12;
fupyrs_obes=fupmos_obes/12;
fupyrs_phy=fupmos_phy/12;
if chr ne 1 then chr=0;
if cvd ne 1 then cvd=0;
if type2db ne 1 then type2db=0;
if tot_cancer ne 1 then tot_cancer=0;
if obes_ca ne 1 then obes_ca=0;
if phyact_ca ne 1 then phyact_ca=0;
if regibuia ne 1 then regibuia=0;
if regaspa ne 1 then regaspa=0;
keep id cohort age_40 age_44 age_48 age_52 age_56 age_60 act_40 act_44 act_48 act_52 act_56 act_60 
     fupyrs fupmos chr cvd type2db tot_cancer obes_ca phyact_ca dt_chr dtdth DXage_chronic DXage_death DXage_min 
     EVENTtime_min EVENTtime_cvd EVENTtime_canc EVENTtime_db 
     fupmos_cvd fupmos_canc fupmos_db fupmos_obes fupmos_phy fupyrs_cvd fupyrs_canc fupyrs_db fupyrs_obes fupyrs_phy     
     agecon  white  sex  smkpy  alcc  regaspa  regibuia  mvit  cafh  dbfh  cvdfh  aheicon  phmsstatus
;
run;
proc sort; by id; run;

data set1;
set pool_traj;
if act_40<7.5 and act_44<7.5 and act_48<7.5 and act_52<7.5 and act_56<7.5 and act_60<7.5;
GROUP=0; /* manual identification: consistently inactive */
keep id GROUP;
run;

data set2;
set traj.traj4060_4group;
keep id GROUP;
run;

data traj_group;
set set1 set2;
run;
proc sort; by id; run; 

data model;
merge pool_traj traj_group;
by id;
if GROUP=. then delete;
run;

proc rank data=model out=model group=4;
var   aheicon;
ranks aheiq;
run;

proc means n nmiss min max mean;
var fupyrs fupyrs_cvd fupyrs_db fupyrs_canc fupyrs_obes fupyrs_phy agecon sex GROUP;
run;

proc freq;
table cohort chr cvd tot_cancer type2db obes_ca phyact_ca white  smkpy  alcc  regaspa  regibuia  mvit  cafh  dbfh  cvdfh  phmsstatus  aheiq   
;
run;

data model;
set model end=_end_;
%indic3(vbl=GROUP, prefix=GROUP, min=1, max=4, reflev=0, missing=., usemiss=0);
%indic3(vbl=aheiq, prefix=aheiq, min=1, max=3, reflev=0, missing=., usemiss=1);
%indic3(vbl=smkpy, prefix=smkpy, min=2, max=9, reflev=1, usemiss=1, missing=., label1='never', 
                   label2='past < 10 pkyr',  label3='past 10-19 pkyr',
                   label4='past 20-39 pkyr', label5='past 40+ pkyr',
                   label6='curr < 25 pkyr',  label7='curr 25-44 pkyr',
                   label8='curr 45-64 pkyr', label9='curr 65+ pkyr');
%indic3(vbl=alcc, prefix=alcc, min=1, max=4, reflev=1, missing=., usemiss=1,
                  label1='0 g/d',
                  label2='0.1-9.9 g/d',
                  label3='10.0-20.0 g/d',
        	         label4='20+ g/d');
%indic3(vbl=phmsstatus, prefix=phmsstatus, min=2, max=4, reflev=1, missing=., usemiss=1,      
                        label1='pre mnp',      
                        label2='never/unknown pmhuser, post mnp',      
                        label3='past pmh user and post mnp',      
                        label4='curr pmhuser and post mnp');  
run;

%let cov2=white &phmsstatus_ cafh cvdfh dbfh &smkpy_ &alcc_ &aheiq_  mvit  regaspa  regibuia ;

proc phreg data=model nosummary;
class cohort;
model fupyrs*chr(0)=&GROUP_ agecon/rl ties=efron;
ods output ParameterEstimates=mv; 
run;
proc phreg data=model nosummary;
class cohort;
model fupyrs*chr(0)=&GROUP_ agecon &cov2/rl ties=efron;
Test1: test GROUP2=GROUP1;
Test2: test GROUP2=GROUP3;
Test3: test GROUP2=GROUP4;
Test4: test GROUP1=GROUP3;
run;

proc phreg data=model nosummary;
class cohort;
model fupyrs_db*type2db(0)=&GROUP_ agecon/rl ties=efron;
ods output ParameterEstimates=mv; 
run;
proc phreg data=model nosummary;
class cohort;
model fupyrs_db*type2db(0)=&GROUP_ agecon &cov2/rl ties=efron;
Test1: test GROUP2=GROUP1;
Test2: test GROUP2=GROUP3;
Test3: test GROUP2=GROUP4;
Test4: test GROUP1=GROUP3;
run;

proc phreg data=model nosummary;
class cohort;
model fupyrs_cvd*cvd(0)=&GROUP_ agecon/rl ties=efron;
ods output ParameterEstimates=mv; 
run;
proc phreg data=model nosummary;
class cohort;
model fupyrs_cvd*cvd(0)=&GROUP_ agecon &cov2/rl ties=efron;
Test1: test GROUP2=GROUP1;
Test2: test GROUP2=GROUP3;
Test3: test GROUP2=GROUP4;
Test4: test GROUP1=GROUP3;
run;

proc phreg data=model nosummary;
class cohort;
model fupyrs_canc*tot_cancer(0)=&GROUP_ agecon/rl ties=efron;
ods output ParameterEstimates=mv; 
run;
proc phreg data=model nosummary;
class cohort;
model fupyrs_canc*tot_cancer(0)=&GROUP_ agecon &cov2/rl ties=efron;
Test1: test GROUP2=GROUP1;
Test2: test GROUP2=GROUP3;
Test3: test GROUP2=GROUP4;
Test4: test GROUP1=GROUP3;
run;

proc phreg data=model nosummary;
class cohort;
model fupyrs_obes*obes_ca(0)=&GROUP_ agecon/rl ties=efron;
ods output ParameterEstimates=mv; 
run;
proc phreg data=model nosummary;
class cohort;
model fupyrs_obes*obes_ca(0)=&GROUP_ agecon &cov2/rl ties=efron;
Test1: test GROUP2=GROUP1;
Test2: test GROUP2=GROUP3;
Test3: test GROUP2=GROUP4;
Test4: test GROUP1=GROUP3;
run;

proc phreg data=model nosummary;
class cohort;
model fupyrs_phy*phyact_ca(0)=&GROUP_ agecon/rl ties=efron;
ods output ParameterEstimates=mv; 
run;
proc phreg data=model nosummary;
class cohort;
model fupyrs_phy*phyact_ca(0)=&GROUP_ agecon &cov2/rl ties=efron;
Test1: test GROUP2=GROUP1;
Test2: test GROUP2=GROUP3;
Test3: test GROUP2=GROUP4;
Test4: test GROUP1=GROUP3;
run;


data traj.data_surv_4060;
set model;
run;

