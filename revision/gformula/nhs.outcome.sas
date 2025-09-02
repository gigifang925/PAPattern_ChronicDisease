/* This program was updated based on the code used in the coauthor Peilu Wang's project 
'Optimal dietary patterns for prevention of chronic disease' published on Nature Medicine. */
*--- Goal: Read in disease endpoints in NHS
	Primary incidence of 1) CVD, 2) type II diabetes, 3) cancer
*--- update: 12/19/2024
     change: add physical activity-related cancer, use the latest case files
*--- variables:
     chr [dt_chr]                  = incident T2D|CVD|cancer
     type2db [dt_diab]             = confirmed T2D
     cvd [dt_cvd]                  = non-fatal or fatal CHD (incl. sudden death) + stroke
     tot_cancer [dt_totcancer]     = total cancer excl. non-melanoma skin cancer and non-fatal prostate cancer      
     obes_ca [dt_obesca]           = 13 cancers listed in IARC (see notes)
     phyact_ca [dt_phyca]          = 6 cancers with suggestive or sufficient evidence for PA
;

/*
         options linesize=130 pagesize=80;
         filename nhstools '/proj/nhsass/nhsas00/nhstools/sasautos/'; 
         filename local '/usr/local/channing/sasautos/';
         filename ehmac '/udd/stleh/ehmac/';
         libname library '/proj/nhsass/nhsas00/formats/';
         options mautosource sasautos=(local nhstools);          *** path to macros  ***;
         options fmtsearch=(library);                            *** path to formats ***;
*/

%let cutoff = 1446; /* cutoff: 1422 = 2018/6  1446 = 2020/6 */
 
    ******************************************
    *               Death                    *
    ******************************************;

%deadff(file=/proj/nhdats/nh_dat_cdx/deaths/deadff.current.nhs1);  
data dead;
set deadff;
dtdth=9999;
if deadmonth > 0 then do;
	dtdth=deadmonth;  
	dead=1;
end;
if dtdth eq 9999 or dtdth gt &cutoff then delete;

keep id dtdth deadmonth dead; 
run; 
proc sort nodupkey; by id; run;
    

    ******************************************
    *           DIABETES MELLITUS            *
    ******************************************;

data diabetes;
infile '/proj/nhdats/nh_dat_cdx/endpoints/diabetes/db7624.110123.cases' lrecl=183 recfm=d;
input
@1		id		    6.
@7		cd		$   1.
@10		cohort		    1.
@13		icda		    5.1
@20		qyr		    2.
@26		mdx1		    2.
@28		ydx1		    2.
@32		conf		    2.
@36		nhsicda		    5.1
@43		mdx		    2.
@45		ydx		    2.
@49		dxmonth		    4.
@55		rc_record_id	    6.
@63		recur		    1.
@66		type		    1.
@67		probabil	             1.
;
label
		id		= 'ID'
		cd		= 'Check Digit'
		cohort		= 'Cohort'
		icda		= 'Reported ICDA'
		qyr		= 'Questionnaire cycle year when reported'
		mdx1		= 'Reported month of diagnosis'
		ydx1		= 'Reported year of diagnosis'
		conf		= 'Confirmation Code'
		nhsicda		= 'NHS reviewed and confirmed ICDA code'
		mdx		= 'Confirmed Month of Diagnosis'
		ydx		= 'Confirmed Year of Diagnosis'
		dxmonth		= 'Date of dx months since 1900'
		rc_record_id	= 'REDCap Record ID'
		recur		= 'Possible recurrence'
		type		= 'Type of DM'
		probabil	         = 'Ranks certainty of diabetes type status'
;
if type=2 and probabil=1 and dxmonth>0 then type2db=1; *type 2 diabetes;
if type2db=1 then dt_diab=dxmonth;
if dt_diab<=0 or dt_diab gt &cutoff then delete;
keep id type2db dt_diab;
run;
proc sort nodupkey; by id; run; 


   **************************************************
   *             CARDIOVASCULAR DISEASE             *
   **************************************************;

data mi;
infile '/proj/nhdats/nh_dat_cdx/endpoints/mi/mi7620.073120.cases' lrecl=117 recfm=d;
input
@1		id		    6.
@7		cd		$   1.
@10		cohort		    1.
@13		icda		    5.1
@20		qyr		    2.
@26		mdx1		    2.
@28		ydx1		    2.
@32		conf		    2.
@36		nhsicda		    5.1
@43		mdx		    2.
@45		ydx		    2.
@49		dxmonth		    4.
;
label
		id		= 'ID'
		cd		= 'Check Digit'
		cohort		= 'Cohort'
		icda		= 'Reported ICDA'
		qyr		= 'Questionnaire cycle year when reported'
		mdx1		= 'Reported month of diagnosis'
		ydx1		= 'Reported year of diagnosis'
		conf		= 'Confirmation Code'
		nhsicda		= 'NHS reviewed and confirmed ICDA code'
		mdx		= 'Confirmed Month of Diagnosis'
		ydx		= 'Confirmed Year of Diagnosis'
		dxmonth		= 'Date of dx months since 1900'
;
if 11<=conf<=19 and dxmonth>0 then chd=1; 
if chd=1 then dt_chd=dxmonth;
if dt_chd<=0 or dt_chd gt &cutoff then delete;
keep id chd dt_chd;
run;
proc sort nodupkey; by id; run;


data cabg;
%include '/proj/nhdats/nh_dat_cdx/endpoints/cabg/cabg7612.060816.nodups.input'; 
if dxmonth>0 then dt_cabg=dxmonth;
keep id dt_cabg;
run;

*Read reproted cabg from %nurXX;
%nur14(keep=cabg14 cabgd14 );
run;
%nur16(keep=cabg16 cabgd16 );
run;
*We did not sent out questionnaires in 2018. Instead, the questionnaires were sent out in 2019. The variables were labled as 20; 
%nur20(keep=cabg20 cabgd20);
run;

data update_cabg;
  merge cabg nur14 nur16 nur20;
  by id;

if dt_cabg=. then do;
                              if cabg20=1 then do;
                                                 if cabgd20=1 then dt_cabg=1404;
                                            else if cabgd20=2 then dt_cabg=1422;
                                            else if cabgd20=3 then dt_cabg=1434;
                                            else                   dt_cabg=1422;
                                                end;

                              if cabg16=1 then do;
                                                 if cabgd16=1 then dt_cabg=1374;
                                            else if cabgd16=2 then dt_cabg=1386;
                                            else if cabgd16=3 then dt_cabg=1398;
                                            else                   dt_cabg=1386;
						end;

                              if cabg14=1 then do;
                                                 if cabgd14=1 then dt_cabg=1350;
                                            else if cabgd14=2 then dt_cabg=1362;
                                            else if cabgd14=3 then dt_cabg=1374;
                                            else                   dt_cabg=1362;
                                              end;
end;
if dt_cabg>0 ;
cabg=1;
if dt_cabg<=0 or dt_cabg gt &cutoff then delete;
keep id cabg dt_cabg;
run;
proc sort nodupkey; by id; run;


* fatal and non-fatal stroke *;
* WE ARE NO LONGER SEPARATING FATAL AND NON-FATAL STROKES.  
    Fatal strokes can be identified using the new variable death_record in the .cases file;
data stroke;
infile '/proj/nhdats/nh_dat_cdx/endpoints/stroke/str7620.031621.cases' lrecl=81 recfm=d;
input
@1		id		    6.
@7		cd		$   1.
@10		cohort		    1.
@13		icda		    5.
@20		qyr		    2.
@26		mdx1		    2.
@28		ydx1		    2.
@32		conf		    2.
@36		nhsicda		    5.
@43		mdx		    2.
@45		ydx		    2.
@49		dxmonth		    4.
;
label
		id		= 'ID'
		cd		= 'Check Digit'
		cohort		= 'Cohort'
		icda		= 'Reported ICDA'
		qyr		= 'Questionnaire cycle year when reported'
		mdx1		= 'Reported month of diagnosis'
		ydx1		= 'Reported year of diagnosis'
		conf		= 'Confirmation Code'
		nhsicda		= 'NHS reviewed and confirmed ICDA code'
		mdx		= 'Confirmed Month of Diagnosis'
		ydx		= 'Confirmed Year of Diagnosis'
		dxmonth		= 'Date of dx months since 1900'
;
if 11<=conf<=19 and dxmonth>0 then tot_str=1;
if tot_str=1 then dt_totstr=dxmonth;
if dt_totstr<=0 or dt_totstr gt &cutoff then delete;
keep id tot_str dt_totstr;
run;
proc sort nodupkey; by id; run;


data cvd;
merge mi update_cabg stroke;
by id;
* CHD (w/ CABG) = non-fatal MI + fatal CHD + CABG *;
if chd=1 or cabg=1 then tot_chd=1;
if dt_chd>0 or dt_cabg>0 then dt_totchd=min(dt_chd,dt_cabg);

* CVD = CHD + stroke *;
if chd=1 or tot_str=1 then cvd=1;
if dt_chd>0 or dt_totstr>0 then dt_cvd=min(dt_chd,dt_totstr);

* CVD w/ CABG = CHD + stroke + CABG 
  tot_cvd
  mnyr_cvd
  prioritize tot_chd, then fatal stroke, last non-fatal stroke
  *;
if cvd=1 or cabg=1 then tot_cvd=1;
if dt_cvd>0 or dt_cabg>0 then dt_totcvd=min(dt_cvd,dt_cabg);

if dt_totcvd<=0 or dt_totcvd gt &cutoff then delete;
keep id chd      tot_chd     tot_str     cvd      tot_cvd
        dt_chd   dt_totchd   dt_totstr   dt_cvd   dt_totcvd;
run;
proc sort nodupkey; by id; run;  


    ******************************************
    *               Cancer                   *
    ******************************************;

data cancer;
infile '/proj/nhdats/nh_dat_cdx/endpoints/allcancer/canc7622.082823.cases' lrecl=53 recfm=d;
input
@1		id		    6.
@7		cd		$   1.
@10		cohort		    1.
@13		icda		    5.1
@20		qyr		    2.
@26		mdx1		    2.
@28		ydx1		    2.
@32		conf		    2.
@36		nhsicda		    5.1
@43		mdx		    2.
@45		ydx		    2.
@49		dxmonth		    4.
;
label
		id		= 'ID'
		cd		= 'Check Digit'
		cohort		= 'Cohort'
		icda		= 'Reported ICDA'
		qyr		= 'Questionnaire cycle year when reported'
		mdx1		= 'Reported month of diagnosis'
		ydx1		= 'Reported year of diagnosis'
		conf		= 'Confirmation Code'
		nhsicda		= 'NHS reviewed and confirmed ICDA code'
		mdx		= 'Confirmed Month of Diagnosis'
		ydx		= 'Confirmed Year of Diagnosis'
		dxmonth		= 'Date of dx months since 1900'
;
icda=floor(nhsicda); * 3 digits *;

if dxmonth>0 then dtdxca0=dxmonth;
if dxmonth>0 then cancer=1;
if dxmonth>0 then do;
* oral cancer *;        if 140=<icda<=149 then do; oral_ca=1; dt_oral=dxmonth; end;
* esophageal ca *;      if icda=150 then do; esoph_ca=1; dt_esoph=dxmonth; end; 
* stomach ca *;         if icda=151 then do; stomach_ca=1; dt_stomach=dxmonth; end; 
* small intestine *;    if icda=152 then do; smallintest_ca=1; dt_smallintest=dxmonth; end;
* colorectal ca *;      if icda in (153, 154) then do; colorect_ca=1; dt_colorect=dxmonth; end;
* liver ca *;           if icda=155 then do; liver_ca=1; dt_liver=dxmonth; end;
* gallbladder/biliary *;if icda=156 then do; gallbladder_ca=1; dt_gallbladder=dxmonth; end;
* pancreatic ca *;      if icda = 157 then do; pancr_ca=1; dt_pancr=dxmonth; end;
* peritoneal ca *;      if icda in (158, 159) then do; peritoneal_ca=1; dt_peritoneal=dxmonth; end;

* lung ca *;             if icda=162 then do; lung_ca=1; dt_lung=dxmonth; end;
* other respiratory ca *;if icda in (160,161,163) then do; otherresp_ca=1; dt_otherresp=dxmonth; end;
        * head and neck*;if (140<=icda<=149 or 160<=icda<=161) then do; headneck_ca=1; dt_headneck=dxmonth;end;

* bone ca *;            if 170<=icda<171 then do; bone_ca=1; dt_bone=dxmonth; end;
* connective tissue *;  if icda=171 then do; connect_ca=1; dt_connect=dxmonth; end;
* melanoma *;           if 172<=icda<173 then do; mel_ca=1; dt_mel=dxmonth; end; 
* melanoma in situ none in NHS *;   if icda=172 and conf = 25 then do; melsitu_ca=1; dt_melsitu=dxmonth; end;
* basal cell none in NHS *;         if nhsicda=173.1 then basal_ca=1; 
* squamous cell none in NHS *;      if nhsicda=173.2 then do; squamous_ca=1; dt_squamous=dxmonth; end; 
* breast ca *;          /*if icda=174 then do; brca_ca=1; dt_brca=dxmonth; end;*/

* cervical ca *;        if icda=180 then do; cervical_ca=1; dt_cervical=dxmonth; end;
* endometrial ca *;     if icda=182 then do; endo_ca=1; dt_endo=dxmonth; end;
* ovarian ca *;         if icda=183 then do; ovca_ca=1; dt_ovca=dxmonth; end;
* prostate ca - none in NHS *;if icda=185 then do; prostate_ca=1; dt_prostate=dxmonth; end;
* other repro *;        if icda in (181, 184, 186, 187) then do; otherrepro_ca=1; dt_otherrepro=dxmonth; end;
* bladder ca *;         if icda=188 then do; bladder_ca=1; dt_bladder=dxmonth; end;
* kidney/ureter ca *;   if 188<icda<190 then do; kidney_ca=1; dt_kidney=dxmonth; end;

* eye ca *;             if icda=190 then do; eye_ca=1; dt_eye=dxmonth; end;
* brain ca *;           if icda=191 then do; brain_ca=1; dt_brain=dxmonth; end;
* nervous system *;     if 192<=icda<193 then do; nervous_ca=1; dt_nervous=dxmonth; end;
* thyroid ca *;         if icda=193 then do; thyroid_ca=1; dt_thyroid=dxmonth; end;
* other ca *;           if icda in (.,179, 190,192,194,195,196,197,198,199) then do; other_ca=1;dt_other=dxmonth;end;
 
* lymphosarcoma *;      if icda=200 then do; lymphosarcoma_ca=1; dt_lymphosarcoma=dxmonth; end;
* Hodgkins disease *;   if icda=201 then do; hodg_ca=1; dt_hodg=dxmonth; end;
* Non-Hodgkins *;       if icda=202 then do; nonhodg_ca=1; dt_nonhodg=dxmonth; end;
* Multiple myeloma *;   if icda=203 then do; mmyeloma_ca=1; dt_mmyeloma=dxmonth; end;
* lymphatic leukemia *; if icda=204 then do; lymleuk_ca=1; dt_lymleuk=dxmonth; end;
* myeoloid leukemia *;  if icda=205 then do; myeleuk_ca=1; dt_myeleuk=dxmonth; end;
* lymphatic cancer *;   if 201=<icda<=207 then do; lymphaem_ca=1; dt_lymphaem=dxmonth; end; 
* blood cancer *;       if 200=<icda<=209 then do; blood_ca=1; dt_blood=dxmonth; end; 
end;
if (conf<11 | conf>19) or (dxmonth <=0 | dxmonth gt &cutoff) then delete;
if icda=174 then delete; * obtain more accurate data from separate file *;
keep id icda dtdxca0 cancer
     oral_ca dt_oral esoph_ca dt_esoph stomach_ca dt_stomach smallintest_ca dt_smallintest 
     colorect_ca dt_colorect liver_ca dt_liver gallbladder_ca dt_gallbladder 
     pancr_ca dt_pancr peritoneal_ca dt_peritoneal
     lung_ca dt_lung otherresp_ca dt_otherresp headneck_ca dt_headneck 
     bone_ca dt_bone connect_ca dt_connect mel_ca dt_mel melsitu_ca dt_melsitu basal_ca squamous_ca dt_squamous 
     /*brca_ca dt_brca*/ cervical_ca dt_cervical endo_ca dt_endo ovca_ca dt_ovca /*prostate_ca dt_prostate*/ otherrepro_ca dt_otherrepro
     bladder_ca dt_bladder kidney_ca dt_kidney eye_ca dt_eye brain_ca dt_brain nervous_ca dt_nervous 
     thyroid_ca dt_thyroid other_ca dt_other lymphosarcoma_ca dt_lymphosarcoma hodg_ca dt_hodg nonhodg_ca dt_nonhodg 
     mmyeloma_ca dt_mmyeloma lymleuk_ca dt_lymleuk myeleuk_ca dt_myeleuk lymphaem_ca dt_lymphaem blood_ca dt_blood;
run;
proc sort nodupkey; by id; run;

* breast cancer *;
data brca;
%include '/proj/nhdats/nh_dat_cdx/endpoints/breast/br7620.040921.cases.input';
if 11<=conf<=19  then brca_ca=1;
if brca_ca=1 then dt_brca=dxmonth;
if brca_ca=1 and era_results=1 then er_status=1;
if brca_ca=1 and pra_results=1 then pr_status=1; 
dtdxca3=dt_brca;
if dt_brca<=0 | dt_brca gt &cutoff then delete;
keep id brca_ca er_status pr_status dt_brca dtdxca3;
run;
proc sort nodupkey; by id; run;

%der7616(keep=amnp mobf yobf
              namnp76 namnp78 namnp80 namnp82 namnp84 namnp86 namnp88 namnp90 namnp92 namnp94 namnp96 namnp98 namnp00 namnp02 namnp04
              age76 age78 age80 age82 age84 age86 age88 age90 age92 age94 age96 age98 age00 age02 age04 age06 age08 age10 age12 age14 age16
              smkdr76 smkdr78 smkdr80 smkdr82 smkdr84 smkdr86 smkdr88 smkdr90 smkdr92 smkdr94 smkdr96 smkdr98 smkdr00 smkdr02 smkdr04 smkdr06 smkdr08 smkdr10 smkdr12 smkdr14 smkdr16);
array namnp{*} namnp76 namnp78 namnp80 namnp82 namnp84 namnp86 namnp88 namnp90 namnp92 namnp94 namnp96 namnp98 namnp00 namnp02 namnp04;
amnp = .;
do i=1 to dim(namnp);
if .<namnp{i}<95 & amnp=. then amnp=namnp{i};
end;
run;

data brca;
merge der7616 brca(in=a);
by id;
if a=1;

if mobf<=0 or mobf>12 then mobf=6;if yobf>20 then birthday=yobf*12+mobf; else birthday=.;
age_dx = ( dt_brca - birthday )/12;

array age{*} age76 age78 age80 age82 age84 age86 age88 age90 age92 age94 age96 age98 age00 age02 age04 age06 age08 age10 age12 age14 age16;
array smkdr{*} smkdr76 smkdr78 smkdr80 smkdr82 smkdr84 smkdr86 smkdr88 smkdr90 smkdr92 smkdr94 smkdr96 smkdr98 smkdr00 smkdr02 smkdr04 smkdr06 smkdr08 smkdr10 smkdr12 smkdr14 smkdr16;

if age_dx>0 & amnp>0 & age_dx<amnp then prebrca_ca=1;
else if age_dx>0 & amnp>0 & age_dx>=amnp then postbrca_ca=1;

do i=2 to dim(age);
        if age{i-1}<=age_dx<age{i} & amnp =. then do;
        if age_dx<46 & 9<=smkdr{i-1}<=15 then prebrca_ca=1;
        else if age_dx<48 & 1<=smkdr{i-1}<=8 then prebrca_ca=1;
        else if age_dx>54 & 9<=smkdr{i-1}<=15 then postbrca_ca=1;
        else if age_dx>56 & 1<=smkdr{i-1}<=8 then postbrca_ca=1;
        end;
end;

if prebrca_ca=. & postbrca_ca=. & brca_ca=1 then prebrca_ca=1;
keep id brca_ca prebrca_ca postbrca_ca er_status pr_status dt_brca dtdxca3;
run;


*************** combine cancer files ***************;
data cancer;
merge cancer brca ;
by id;
* exclude those not diagnosed with other cancer but nonfatal prostate ca or non-melanoma skin cancer *;
if sum(of dtdxca0 dtdxca3)>0 and 
   (squamous_ca eq 1 | basal_ca eq 1) and 
   sum(of oral_ca esoph_ca stomach_ca smallintest_ca colorect_ca liver_ca gallbladder_ca pancr_ca peritoneal_ca 
         lung_ca otherresp_ca /*headneck_ca*/ bone_ca connect_ca mel_ca brca_ca cervical_ca endo_ca ovca_ca otherrepro_ca
         bladder_ca kidney_ca eye_ca brain_ca nervous_ca thyroid_ca other_ca blood_ca)<1 then excl_ca=1;
if sum(of dtdxca0 dtdxca3)>0 and excl_ca<1 then tot_cancer = 1;

if tot_cancer=1 then 
  dt_totcancer = min(of dt_oral dt_esoph dt_stomach dt_smallintest dt_colorect dt_liver dt_gallbladder dt_pancr dt_peritoneal
                          dt_lung dt_otherresp /*dt_headneck*/ dt_bone dt_connect dt_mel dt_brca dt_cervical dt_endo dt_ovca dt_otherrepro
                          dt_bladder dt_kidney dt_eye dt_brain dt_nervous dt_thyroid dt_other dt_blood);

if tot_cancer=1 then do;
* GI cancer *;
if sum(of oral_ca esoph_ca stomach_ca smallintest_ca colorect_ca liver_ca gallbladder_ca pancr_ca)>=1 then gi_ca=1;
if gi_ca=1 then dt_gi=min(of dt_oral dt_esoph dt_stomach dt_smallintest dt_colorect dt_liver dt_gallbladder dt_pancr);

if sum(of oral_ca esoph_ca stomach_ca smallintest_ca colorect_ca)>=1 then git_ca=1;
if git_ca=1 then dt_git=min(of dt_oral dt_esoph dt_stomach dt_smallintest dt_colorect);

if sum(of oral_ca esoph_ca stomach_ca smallintest_ca)>=1 then upgit_ca=1;
if upgit_ca=1 then dt_upgit=min(of dt_oral dt_esoph dt_stomach dt_smallintest);

if sum(of liver_ca gallbladder_ca pancr_ca)>=1 then gio_ca=1;
if gio_ca=1 then dt_gio=min(of dt_liver dt_gallbladder dt_pancr);

* re: (Lauby-Secretan, 2017) 13 cancers with sufficient evidence for cancer (* vaguely used, ** missing)
        esoph(adenoma)* 
        gastric(cardia)* 
        colon/rectum 
        liver 
        gallbladder 
        pancreas 
        breast(post)
        endometrial 
        ovary 
        kidney(renal cell)* 
        meningioma** 
        thyroid 
        multiple myeloma 
*;

if postbrca_ca=1 then dt_postbrca=dt_brca;
if prebrca_ca=1 then dt_prebrca=dt_brca;

if sum(of esoph_ca stomach_ca colorect_ca liver_ca gallbladder_ca pancr_ca postbrca_ca
	  endo_ca ovca_ca kidney_ca thyroid_ca mmyeloma_ca)>=1 then obes_ca=1;
if obes_ca=1 then dt_obesca = min(of dt_esoph dt_stomach dt_colorect dt_liver dt_gallbladder dt_pancr dt_postbrca 
                                       dt_endo dt_ovca dt_kidney dt_thyroid dt_mmyeloma);

* re: IARC vol 100E 
        oral cavity
        pharynx
        nasal cavity and paranasal sinuses
        esophagus
        stomach
        bowel
        liver
        pancreas
        larynx
        lung
        uterine cervix
        ovary
        urinary bladder
        kidney
        ureter
        bone marrow (myeloid leukaemia)
;
if sum(of oral_ca esoph_ca stomach_ca colorect_ca liver_ca pancr_ca otherresp_ca 
          lung_ca cervical_ca ovca_ca bladder_ca kidney_ca myeleuk_ca)>=1 then smoke_ca=1;
if smoke_ca=1 then dt_smokeca=min(of dt_oral dt_esoph dt_stomach dt_colorect dt_liver dt_pancr dt_otherresp
                                       dt_lung dt_cervical dt_ovca dt_bladder dt_kidney dt_myeleuk);

* re: WCRF/IARC 
        colon/rectum
        breast
        endometrial 
        esophagus
        liver
        lung
;
if sum(of esoph_ca colorect_ca liver_ca lung_ca endo_ca brca_ca)>=1 then phyact_ca=1;
if phyact_ca=1 then dt_phyca = min(of dt_esoph dt_colorect dt_liver dt_lung dt_endo dt_brca);

end;
if tot_cancer ne 1 then delete;
if dt_totcancer<=0 or dt_totcancer gt &cutoff then delete;
keep id icda
     tot_cancer dt_totcancer 
     obes_ca dt_obesca prebrca_ca postbrca_ca 
     smoke_ca dt_smokeca
     phyact_ca dt_phyca
     gi_ca dt_gi git_ca dt_git gio_ca dt_gio upgit_ca dt_upgit

     dt_oral dt_esoph dt_stomach dt_smallintest dt_colorect dt_liver dt_gallbladder dt_pancr dt_peritoneal
     dt_lung dt_otherresp dt_headneck dt_bone dt_connect dt_mel dt_brca dt_cervical dt_endo dt_ovca /*dt_fatalpca*/ dt_otherrepro
     dt_bladder dt_kidney dt_eye dt_brain dt_nervous dt_thyroid dt_other dt_blood

     dtdxca0 dtdxca3
     oral_ca esoph_ca stomach_ca smallintest_ca colorect_ca liver_ca gallbladder_ca pancr_ca peritoneal_ca 
     lung_ca otherresp_ca headneck_ca bone_ca connect_ca mel_ca brca_ca cervical_ca endo_ca ovca_ca /*fatal_pca*/ otherrepro_ca
     bladder_ca kidney_ca eye_ca brain_ca nervous_ca thyroid_ca other_ca blood_ca;
run;
proc sort nodupkey; by id; run;


data nhs_outcome;
merge diabetes cvd dead cancer;
by id;
* check ties
        type: 1 T2D, 2 CVD, 3 CABG, 4 cancer, 5 non-t death *;
if tot_cvd=1 and cvd<1 then cabg = 1;
if cabg = 1 then dt_cabg = dt_totcvd;
event_num = sum(of type2db cvd cabg tot_cancer);

if event_num>0 & (0<dtdth<dt_diab | 0<dtdth<dt_cvd | 0<dtdth<dt_cabg | 0<dtdth<dt_totcancer)
  then flag = 1; 

run;

data nhs_outcome;
set nhs_outcome;
*--- chronic diseases ---*;
* [primary: incident T2D|CVD|cancer] *;
if type2db=1 | cvd=1 | tot_cancer=1 then chr = 1;
if chr = 1 then dt_chr = min(of dt_diab dt_cvd dt_totcancer);
run;
proc sort nodupkey; by id; run;

proc freq data=nhs_outcome;
        tables chr type2db cvd tot_cancer obes_ca phyact_ca;
run;

proc means min max q1 median q3 n nmiss;
var dtdth dt_chr dt_totcancer dt_diab dt_cvd dt_obesca dt_phyca;
run;

proc datasets nolist;
delete diabetes mi cabg stroke cvd cancer der7616 nur14 nur16 nur20 update_cabg
       brca deadff dead;
run;
