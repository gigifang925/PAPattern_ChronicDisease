%include '/udd/hpzfa/review/PA/traj/hpfs_age_cohort.sas';
%include '/udd/hpzfa/review/PA/traj/nhs_age_cohort.sas';
%include '/udd/hpzfa/review/PA/traj/nhs2_age_cohort.sas';

data age_pool_long;
set age_hpfs_long age_nhs_long age_nhs2_long;
run;


ods listing close;
ods pdf file='pool_act_age_spline.pdf';
proc sgplot data=age_pool_long;
title1 "Physical activity trend over adulthood in the pooled cohorts";
PBSPLINE x=age_new y=actcon/NOMARKERS CLM;
XAXIS values=(23 25 to 110 by 5) label="Age, years";
YAXIS values=(0 to 40 by 5) label="Physical activity, MET-hour/week";
run;
ods pdf close;
ods listing;
