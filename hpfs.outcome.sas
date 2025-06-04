/* This program was updated based on the code used in the coauthor Peilu Wang's project 
'Optimal dietary patterns for prevention of chronic disease' published on Nature Medicine. */
*--- Goal: Read in disease endpoints in HPFS
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
options nocenter ls=130 ps=80; 
*options mprint symbolgen mlogic;
filename hpstools '/proj/hpsass/hpsas00/hpstools/sasautos';
filename channing '/usr/local/channing/sasautos';
libname readfmt '/proj/hpsass/hpsas00/formats';
options mautosource sasautos=(channing hpstools);
options fmtsearch=(readfmt) nofmterr;
*/

%let cutoff = 1441; /* cutoff: 2018/1 = 1417  2020/1 = 1441 */

   **************************************************
   *                    Death                       *
   **************************************************;
      
   %hp_dead;
   data hp_dead;
       set hp_dead;
    
       if 0<=yydth<50 then yydth=yydth+100;
       if mmdth<=0 or mmdth>12 then mmdth=6;
       if mmdth>0 and yydth>0 then dtdth=(12*yydth)+mmdth;
       else dtdth=9999;

       if dtdth>0 then dead=1;
       if dtdth eq 9999 or dtdth gt &cutoff then delete;
     
       keep id mmdth yydth dtdth dead;

   run;
   proc sort nodupkey; by id;


   **************************************************
   *              DIABETES MELLITUS                 *
   **************************************************;

data diabetes;
infile '/proj/hpdbxs/hpdbx00/diab_cases_8620/diab8620.05MAY23' lrecl=49 recfm=d;  
input
@1 id        6.
@30 type     1.
@32 prob     1.
@34 dbcase   1.
@36 dtdx     4.
;
label
		id		= 'id segment only'
		type		= 'type'
		prob		= 'probability; blank if no quest returned'
		dbcase		= 'Is 1 if confirmed conf code, type=2, prob=1'
		dtdx		= 'date dx from medical record'
;
if dtdx>0 and type=2 and prob=1 then type2db=1; * definite T2D *;
if type2db=1 then dt_diab=dtdx; * confirmed T2D dx date *;
if dt_diab<=0 or dt_diab gt &cutoff then delete;
keep id type2db dt_diab;
run;
proc sort nodupkey; by id; run;


   **************************************************
   *             CARDIOVASCULAR DISEASE             *
   **************************************************;

data cvd;
infile '/proj/hpchds/hpchd0q/CARDIO2016/cardio2016.02062020';
input  @1  id         6.
       @7  mi_nf      1. /* Non fatal MI: 0=non case, 1=definite, 2=probable, 3=no further info, 4=rejected */
       @8  mnyr_nmi   4. /* Diagnosis date for nfmi in terms of months from 1900 */
       @27 fat_chd    1. /* Fatal mi: 0=non case, 1=definite, 2=presumed, 3=sudden death */
       @28 mnyr_fat   4. /* Diagnosis date for fmi in terms of months from 1900 */
       @12 cabg_sr    1. /* CABG: 0=non case, 1=definite, 2=probable, 3=no further info, 4=rejected */
       @13 mnyr_ca    4. /* Diagnosis date for cabg in terms of months from 1900 */
       @17 angina     1. /* Angina: 0=non case, 1=definite, 2=probable, 3=no further info, 4=rejected */
       @18 mnyr_an    4. /* Diagnosis date for angina in terms of months from 1900 */
       @22 nf_stroke  1. /* Non fatal Stroke: 0=non case, 1=definite, 2=probable, 3=no further info, 4=rejected */
       @23 mnyr_st    4. /* Diagnosis date for nfstr in terms of months from 1900 */         
       @37 tot_cvd    1. /* Total CVD: 0=no, 1=yes */
       @32 tot_chd    1. /* Non-fatal MI, Fatal CHD, or CABG: 0=none, 1=total CHD, def/prb */
       @38 mnyr_cvd   4. /* Diagnosis date for totcvd in terms of months from 1900 */
       @33 mnyr_chd   4. /* Diagnosis date for totchd in terms of months from 1900 */
       @42 fat_st     1. /* Fatal Stroke: 0=non case, 1=definite, 2=probable */
       @43 tot_str    1. /* Total Stroke: 0=none, 1=total str, def/prb */
       @47 mnyr_tst   4. /* Diagnosis date for totstr in terms of months from 1900 */
;

if mi_nf in (1,2) and mnyr_nmi>0 then dt_nfmi=mnyr_nmi; * non-fatal MI *;
if fat_chd in (1,2,3) and mnyr_fat>0 then dt_fmi=mnyr_fat;  * fatal CHD = fatal MI + sudden death *;
if cabg_sr in (1,2) and mnyr_ca>0 then dt_cabg=mnyr_ca; * CABG *;
if fat_st in (1,2) and mnyr_tst>0 then dt_fst=mnyr_tst;  * fatal stroke *;
if nf_stroke in (1,2) and mnyr_st>0 then dt_nfst=mnyr_st;  * non-fatal stroke *;

* ID=39698 dx with non-fatal MI {1209} after fatal MI {1203} ;
if dt_nfmi>0 and dt_fmi>0 and dt_nfmi>=dt_fmi then do;
  dt_nfmi=.; mi_nf = .;
end;

* CHD = non-fatal MI + fatal CHD, prioritize non-fatal MI *;
if (mi_nf in (1,2) or fat_chd in (1,2,3)) and (dt_nfmi>0 or dt_fmi>0) then chd = 1;
if chd=1 and dt_nfmi>0 then dt_chd=dt_nfmi;
else if chd=1 and dt_fmi>0 then dt_chd=dt_fmi;

* CHD (w/ CABG) = non-fatal MI + fatal CHD + CABG, 
            prioritize non-fatal MI, then CABG, last fatal MI 
  tot_chd
  mnyr_chd
*;
if mnyr_chd <= 0 then tot_chd = .;
if tot_chd = 1 then dt_totchd = mnyr_chd;

* tot_str = non-fatal stroke + fatal stroke 
  prioritize fatal stroke, then non-fatal stroke
  tot_str
  mnyr_str
*;
if mnyr_tst <= 0 then tot_str = .;
if tot_str = 1 then dt_totstr = mnyr_tst;

* CVD = CHD + stroke *;
if chd=1 or tot_str=1 then cvd=1;
if (dt_chd>0 or dt_totstr>0) and cvd=1 then dt_cvd=min(dt_chd, dt_totstr);

* CVD w/ CABG = CHD + stroke + CABG 
  tot_cvd
  mnyr_cvd
  prioritize tot_chd, then fatal stroke, last non-fatal stroke
  *;
if mnyr_cvd <= 0 then tot_cvd = .;
if tot_cvd = 1 then dt_totcvd = mnyr_cvd;

if dt_totcvd <=0 or dt_totcvd gt &cutoff then delete;
keep id chd      tot_chd     tot_str     cvd      tot_cvd
        dt_chd   dt_totchd   dt_totstr   dt_cvd   dt_totcvd;
run; 
proc sort nodupkey; by id; run;  * some may have both chd and stroke *;


   **************************************************
   *                    Cancer                      *
   **************************************************;

data cancer; 
infile '/proj/hpchds/hpchd0y/Cancer_2020_data/Cancer2020_March2024_withduplicate.dat' lrecl=128;  
input
hpfsid    1-6
dateca    8-11  /* date of cancer */
dod       12-15  /* date of death for all deaths */
cancer    16 /* all cancers 1,0 */
mel       18 /* melanoma */
lal       19 /* lymphoma + leukemia */
other     20 /* other cancers */
colorect  21  /* colorectal */
lung      22  /* */
carcin    24  /* carcinoma = cancers without lal,brain,sarcoma */
newag     25  /* prostate cancer aggressive only */
cancerp   26 /* total cancers including ONLY aggressive prostate ca */
carcinp   27 /* total carconoma including ONLY aggressive prostate ca */
prosnoa1  29 /* prostate no A1 stage*/
acan      30 /* icd code is: 141,143,144,145,146,148,149,150,153,154 */
bladder   31
pancreas  32
kidney    33
stomach   34
liver     35
brain     36
sarcoma   37
oralc     38
status    39  /* prostate, no A1 stage, from prostate cancer file */
esoph     40
leuk      41
lymp_nh   42
lymp_h    43
myeloma   44
pharyn    45
oroph     46
conf      47-48   /* confirmation code */
cancerdth 49  /* 1: death from cancer cause; 0: other */
icdx      52-54  /* icd code , 3 digits*/;

id=hpfsid; 
icda=icdx;

if dateca>0 then dtdxca0 = dateca;
if dateca>0 then cancer = 1;
if dateca>0 then do;
* oral cancer *;        if (oralc=1 | pharyn=1 | oroph=1) & 140=<icda<=149 then do; oral_ca=1; dt_oral=dateca; end;
* esophageal ca *;      if esoph=1 & icda=150 then do; esoph_ca=1; dt_esoph=dateca; end; */
* stomach ca *;         if stomach=1 & icda=151 then do; stomach_ca=1; dt_stomach=dateca; end; */
* small intestine *;    if icda=152 then do; smallintest_ca=1; dt_smallintest=dateca; end;
* colorectal ca *;      if colorect=1 & icda in (153, 154) then do; colorect_ca=1; dt_colorect=dateca; end;
* liver ca *;           if liver=1 & icda=155 then do; liver_ca=1; dt_liver=dateca; end;*/
* gallbladder/biliary *;if icda=156 then do; gallbladder_ca=1; dt_gallbladder=dateca; end;
* pancreatic ca *;      if icda = 157 then do; pancr_ca=1; dt_pancr=dateca; end;
* peritoneal ca *;      if icda in (158, 159) then do; peritoneal_ca=1; dt_peritoneal=dateca; end;

* lung ca *;            if lung=1 & icda=162 then do; lung_ca=1; dt_lung=dateca; end;
* other respiratory ca *;if icda in (160,161,163,164,165) then do; otherresp_ca=1; dt_otherresp=dateca; end;
* head and neck*;       if 140=<icda<=149 | (160<=icda<=161) then do; headneck_ca=1; dt_headneck=dateca; end;

* bone ca *;            if icda=170 then do; bone_ca=1; dt_bone=dateca; end;
* connective tissue *;  if icda=171 then do; connect_ca=1; dt_connect=dateca; end;
* melanoma *;           if icda=172 & conf = 11 then do; mel_ca=1; dt_mel=dateca; end; 
* melanoma in situ *;   if icda=172 and conf = 25 then do; melsitu_ca=1; dt_melsitu=dateca; end;
* basal cell *;         if icda=173.1 then basal_ca=1; 
* squamous cell *;      if icda=173.2 then do; squamous_ca=1; dt_squamous=dateca; end; 
* breast ca *;          if icda=174 then do; brca_ca=1; dt_brca=dateca; end;

* cervical ca *;        if icda=180 then do; cervical_ca=1; dt_cervical=dateca; end;
* endometrial ca *;     if icda=182 then do; endo_ca=1; dt_endo=dateca; end;
* ovarian ca *;         if icda=183 then do; ovca_ca=1; dt_ovca=dateca; end;
* prostate ca *;        if icda=185 then do; prostate_ca=1; dt_prostate=dateca; end;
* aggressive only *;    if newag=1 then do; fatal_pca=1; dt_fatalpca=dateca; end;
* other repro *;        if icda in (181, 184, 186, 187) then do; otherrepro_ca=1; dt_otherrepro=dateca; end;
* bladder ca *;         if bladder=1 & icda=188 & (11<=conf<=19 or conf=25) then do; bladder_ca=1; dt_bladder=dateca; end;
* kidney/ureter ca *;   if kidney=1 & icda=189 then do; kidney_ca=1; dt_kidney=dateca; end;

* eye ca *;             if icda=190 then do; eye_ca=1; dt_eye=dateca; end;
* brain ca *;           if brain=1 /*and icda=191*/ then do; brain_ca=1; dt_brain=dateca; end;
* nervous system *;     if 192<=icda<193 then do; nervous_ca=1; dt_nervous=dateca; end;
* thyroid ca *;         if icda=193 then do; thyroid_ca=1; dt_thyroid=dateca; end;
* other ca *;           if icda in (142,175,179,190,192,194,195,196,197,198,199) then do; other_ca=1;dt_other=dateca;end;

* lymphosarcoma *;      if icda=200 then do; lymphosarcoma_ca=1; dt_lymphosarcoma=dateca; end;
* Hodgkins disease *;   if icda=201 then do; hodg_ca=1; dt_hodg=dateca; end;
* Non-Hodgkins *;       if lymp_nh=1 /*and icda=202*/ then do; nonhodg_ca=1; dt_nonhodg=dateca; end;
* Multiple myeloma *;   if icda=203 then do; mmyeloma_ca=1; dt_mmyeloma=dateca; end;
* lymphatic leukemia *; if icda=204 then do; lymleuk_ca=1; dt_lymleuk=dateca; end;
* myeoloid leukemia *;  if icda=205 then do; myeleuk_ca=1; dt_myeleuk=dateca; end;
* lymphatic cancer *;   if 201=<icda<=207 then do; lymphaem_ca=1; dt_lymphaem=dateca; end; 
* blood cancer *;       if 200=<icda<=209 then do; blood_ca=1; dt_blood=dateca; end; 
end;
if (conf<11 | conf>19) or (dtdxca0 <=0 | dtdxca0 gt &cutoff) or cancerp < 1 then delete;
/* if icda=185 then delete; obtain more accurate data from separate file */
keep id icda dtdxca0 cancer cancerp conf
     oral_ca dt_oral esoph_ca dt_esoph stomach_ca dt_stomach smallintest_ca dt_smallintest 
     colorect_ca dt_colorect liver_ca dt_liver gallbladder_ca dt_gallbladder 
     pancr_ca dt_pancr peritoneal_ca dt_peritoneal
     lung_ca dt_lung otherresp_ca dt_otherresp headneck_ca dt_headneck 
     bone_ca dt_bone connect_ca dt_connect mel_ca dt_mel melsitu_ca dt_melsitu /* basal_ca squamous_ca dt_squamous */
     brca_ca dt_brca cervical_ca dt_cervical endo_ca dt_endo ovca_ca dt_ovca prostate_ca dt_prostate fatal_pca dt_fatalpca otherrepro_ca dt_otherrepro
     bladder_ca dt_bladder kidney_ca dt_kidney eye_ca dt_eye brain_ca dt_brain nervous_ca dt_nervous 
     thyroid_ca dt_thyroid other_ca dt_other lymphosarcoma_ca dt_lymphosarcoma hodg_ca dt_hodg nonhodg_ca dt_nonhodg 
     mmyeloma_ca dt_mmyeloma lymleuk_ca dt_lymleuk myeleuk_ca dt_myeleuk lymphaem_ca dt_lymphaem blood_ca dt_blood;
run;
proc sort nodupkey; by id; run;

* skin cancer *;
*read in SCC case files *;
data scc8617;
infile '/proj/hpdats/hp_dat_can/scc/2017/scc173.2_8614.nodupes.112817.dat' lrecl=78 recfm=d;
input   
@1              id                  6.   
@9              icda         $      3.   
@18             mdx1                2.   
@20             ydx1                2.   
@14             qyr                 2.   

@38             scc_conf            2.   
@25             mdx                 2. /*confirmed diagnosis month*/   
@27             ydx                 2. /*confirmed diagnosis year*/ 
@44             scc_site            2. /*site*/
@62             dxmonth             4.
;      
label   
                icda            = 'reported icda'   
                mdx1            = 'month of dx reported'   
                ydx1            = 'year of dx reported'   
                qyr             = 'questionnaire year'   
                scc_conf        = 'SCC conf code'   
                mdx             = 'nhs month dx'   
                ydx             = 'nhs year dx'   
	       scc_site        = 'site of SCC'
;
/*$label 01.scalp;
	 02.forehaed;
	 03.eyes;
	 04.cheeks;
	 05.nose;
     06.mouth;
	 07.face, other;
	 08.ears;
	 09.neck;
	 10.trunk, shoulder, hip, upper and lower back, abdomen;
     11.upper arm, elbow;
     12.forearm;
	 13.hand, finger;
     14.thigh, buttock, leg, ankle, foot 
     15.anal,vulval,vaginal;
	 99.unknown*/ 
 
if scc_conf in (21,22,23) then delete; *false diagnoses;
scccase=1;
 
*Cases Confirmed by medical record;
if scc_conf in (11,25) then scc=1;
else scc=.;

if scc_conf=11 then scc_11=1;
if scc_conf=25 then scc_25=1;

if scc_11=1 and scc_site not in (3,15) then sccskin=1;

*define body site of melanoma;

if scc_site in (01,02,04,05,07,08,09,11,12,13,14) then sites= 1 ; 
else if scc_site in (06,10,15)                         then sites= 2 ; 
else if scc_site=3                                     then sites= 3 ; 
else                                                        sites= . ; 

label sites= '1-head/neck/extremities, 2-trunk/mucosa, 3-ocular' ;   

if scc_site in (01,02,03,04,05,06,07,08,09)       then sitesb= 1 ; 
else if scc_site in (10,15)                       then sitesb= 2 ; 
else if scc_site in (11,12,13,14)                 then sitesb= 3 ; 
else                                                   sitesb= . ; 

label sitesb= '1-head/neck, 2-trunk, 3-extremities' ;  

if scc_site in (01,02,03,04,05,06,07,08,09,11,12,13) then sitesc= 1 ; 
else if scc_site in (10,15)                            then sitesc= 2 ; 
else if scc_site =14                                   then sitesc= 3 ;
else                                                        sitesc= . ;

label sitesc= '1-head/neck/arms, 2-trunk/mucosa, 3-lower limbs' ;

if scc_site in (01,02,03,04,05,06,07,08,09)       then sitesd= 1 ; 
else if scc_site in (10,15)                       then sitesd= 2 ; 
else if scc_site in (11,12,13)                    then sitesd= 3 ; 
else if scc_site =14                              then sitesd= 4 ;
else                                                   sitesd= . ; 
label sitesd= '1-head/neck, 2-trunk/mucosa, 3-upper limbs, 4-lower limbs' ;
rename dxmonth=dtdxscc;  
run;
proc sort nodupkey;by id;run;

/**Read BCC disease files-all self reported**/  
data bcc8610;    
infile '/proj/hpdats/hp_dat_can/bcc/2012/bcc173.1_8610.nodupes.102412.dat';
input   
@1              id                  6.   
@9              icda            $   3.   
@18             mdx1                2.   
@20             ydx1                2.   
@14             qyr                 2.   
@25             mdx                 2.   
@27             ydx                 2.   
@62             dtdxbcc             4.
;   
bcccase=1;
keep id bcccase dtdxbcc;
run;    
proc sort nodupkey;by id;run;

data skin_ca;   
merge scc8617 bcc8610;
by id;
dtdxnmsc=min(dtdxbcc,dtdxscc);
basalskin_ca=bcccase;
sqskin_ca=scccase;
dt_basalskin=dtdxbcc;
dt_sqskin=dtdxscc;
keep id basalskin_ca sqskin_ca dt_basalskin dt_sqskin;
run;
proc sort nodupkey;by id;run;


*************** combine cancer files ***************;
* When you merge files that have the same variable, 
  SAS will use the values from the file that appears last on the merge statement. *;

data cancer;
merge cancer skin_ca;
by id;

if dtdxca0>0 and
  (sqskin_ca eq 1 | basalskin_ca eq 1) and 
  sum(of oral_ca esoph_ca stomach_ca smallintest_ca colorect_ca liver_ca gallbladder_ca pancr_ca peritoneal_ca 
         lung_ca otherresp_ca /*headneck_ca*/ bone_ca connect_ca mel_ca brca_ca cervical_ca endo_ca ovca_ca fatal_pca otherrepro_ca
         bladder_ca kidney_ca eye_ca brain_ca nervous_ca thyroid_ca other_ca blood_ca)<1 then excl_ca=1;

if dtdxca0>0 and excl_ca<1 then tot_cancer = 1; 

if tot_cancer=1 then 
  dt_totcancer = min(of dt_oral dt_esoph dt_stomach dt_smallintest dt_colorect dt_liver dt_gallbladder dt_pancr dt_peritoneal
                          dt_lung dt_otherresp /*dt_headneck*/ dt_bone dt_connect dt_mel dt_brca dt_cervical dt_endo dt_ovca dt_fatalpca dt_otherrepro
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
        breast(post)* 
        endometrial 
        ovary 
        kidney(renal cell)* 
        meningioma** 
        thyroid 
        multiple myeloma 
*;
if sum(of esoph_ca stomach_ca colorect_ca liver_ca gallbladder_ca pancr_ca brca_ca 
	        endo_ca ovca_ca kidney_ca thyroid_ca mmyeloma_ca)>=1 then obes_ca=1;
if obes_ca=1 then dt_obesca = min(of dt_esoph dt_stomach dt_colorect dt_liver dt_gallbladder dt_pancr dt_brca 
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
if smoke_ca=1 then dt_smokeca = min(of dt_oral dt_esoph dt_stomach dt_colorect dt_liver dt_pancr dt_otherresp
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
     obes_ca dt_obesca 
     smoke_ca dt_smokeca
     phyact_ca dt_phyca
     gi_ca dt_gi 
     git_ca dt_git 
     gio_ca dt_gio 
     upgit_ca dt_upgit 

     dt_oral dt_esoph dt_stomach dt_smallintest dt_colorect dt_liver dt_gallbladder dt_pancr dt_peritoneal
     dt_lung dt_otherresp dt_headneck dt_bone dt_connect dt_mel dt_brca dt_cervical dt_endo dt_ovca dt_fatalpca dt_otherrepro
     dt_bladder dt_kidney dt_eye dt_brain dt_nervous dt_thyroid dt_other dt_blood
     dt_prostate dt_fatalpca

     dtdxca0
     oral_ca esoph_ca stomach_ca smallintest_ca colorect_ca liver_ca gallbladder_ca pancr_ca peritoneal_ca 
     lung_ca otherresp_ca headneck_ca bone_ca connect_ca mel_ca brca_ca cervical_ca endo_ca ovca_ca /*fatal_pca*/ otherrepro_ca
     bladder_ca kidney_ca eye_ca brain_ca nervous_ca thyroid_ca other_ca blood_ca
     prostate_ca fatal_pca ;

run;
proc sort nodupkey; by id; run;


data hpfs_outcome;
merge diabetes cvd cancer hp_dead;
by id;
* check ties
        type: 1 T2D, 2 CVD, 3 CABG, 4 cancer, 5 non-t death *;
if tot_cvd=1 and cvd<1 then cabg = 1;
if cabg = 1 then dt_cabg = dt_totcvd;
event_num = sum(of type2db cvd cabg tot_cancer);

if event_num>0 & (0<dtdth<dt_diab | 0<dtdth<dt_cvd | 0<dtdth<dt_cabg | 0<dtdth<dt_totcancer)
  then flag = 1; 

run;

data hpfs_outcome;
set hpfs_outcome;
*--- chronic diseases ---*;
* [primary: incident T2D|CVD|cancer] *;
if type2db=1 | cvd=1 | tot_cancer=1 then chr = 1;
if chr = 1 then dt_chr = min(of dt_diab dt_cvd dt_totcancer);
run;
proc sort nodupkey; by id; run;

proc freq data=hpfs_outcome;
        table type2db cvd tot_cancer chr obes_ca phyact_ca;
run;

proc means min max q1 median q3 n nmiss;
var dtdth dt_chr dt_totcancer dt_diab dt_cvd dt_obesca dt_phyca;
run;

proc datasets nolist;
delete diabetes cvd cancer 
       scc8617 bcc8610 skin_ca hp_dead;
run;
