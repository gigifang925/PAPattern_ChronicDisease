/********************************************************************************************************************************************
Programmer:         Zhe (Gigi) Fang                                                                                                       
Start Date:         02/20/2024  
Purpose:            Long-term physical activity patterns and incidence of major chronic diseases
Study design:       Prospective cohort                                                                              
Follow-up period:   1986-2020  
Exclusions at baseline:
- multiple records and not in master file
- missing age in 1986
- missing physical activity in 1986
- death before 1986
- history of cancer, CVD, or diabetes before 1986 
Outcomes: incidence of major chronic diseases, including 
- type 2 diabetes
- major CVD 
- cancer (excluding nonmelanoma skin cancer and nonfatal prostate cancer) 
Exposures: 
- cumulative average physical activity volume, MET-hours/week (actcon) 
- duration meeting the recommended level, % of follow-up years (percdur)
- duration meeting the recommended level, years (sustain)
- simple updated physical activity volume, MET-hours/week (actsim) 
Covariates:                                                                                                                                                                                                                                      
age, race, body mass index, smoking status and packyears, family history of diabetes mellitus, myocardial infarction, or cancer,
cumulative average of alcohol consumption, cumulative average of alternative healthy eating index-2010, 
regular aspirin use, regular NSAIDs use, multivitamin use,  
for women, menopausal status and hormone use;
Carry forward: BMI, PA, alcohol, AHEI, packyear, aspirin, NSAIDs, multivitamin
Analyses: Cox  
*******************************************************************************************************************************************/

options nocenter ls=130 ps=80; 
*options mprint symbolgen mlogic;
filename hpstools '/proj/hpsass/hpsas00/hpstools/sasautos';
filename channing '/usr/local/channing/sasautos';
libname readfmt '/proj/hpsass/hpsas00/formats';
options mautosource sasautos=(channing hpstools);
options fmtsearch=(readfmt) nofmterr;

libname g_fm '/udd/hpzfa/review/PA/revision/gformula'; 

*macro for calculation of CV;
%include '/proj/nhchks/nhchk00/SAMPLE_CODES/cumavg.sas';

*call in outcome;
%include '/udd/hpzfa/review/PA/revision/gformula/hpfs.outcome.sas';

*call in derived aspirin and nsaids;
%include '/udd/hpzfa/review/PA/revision/gformula/asp_hpfs.sas';
proc sort nodupkey data=hpfs_asp;by id;run;

               
   %hp_der (keep= stpyr86 dbmy86 dbmy09 rtmnyr86 rtmnyr87 rtmnyr88 rtmnyr90 rtmnyr92 rtmnyr94 rtmnyr96 rtmnyr98 rtmnyr00 rtmnyr02 rtmnyr04 rtmnyr06 
                  height bmi2186 bmi86 bmi88 bmi90 bmi92 bmi94 bmi96 bmi98 bmi00 bmi02 bmi04 bmi06 
                  wt86 wt88 wt90 wt92 wt94 wt96 wt98 wt00 wt02 wt04 wt06 
                  smoke86 smoke88 smoke90 smoke92 smoke94 smoke96 smoke98 smoke00 smoke02 smoke04 smoke06 
                  cgnm86 cgnm88 cgnm90 cgnm92 cgnm94 cgnm96 cgnm98 cgnm00 cgnm02 cgnm04 cgnm06
                  pckyr86 pckyr88 pckyr90 pckyr92 pckyr94 pckyr96 pckyr98 pckyr00 pckyr02 pckyr04 pckyr06  
                  fdb3087 mdb3087 sdb3087 bdb3087 fdb2987 mdb2987 sdb2987 bdb2987 dbfh87);
                  dbfh87=0; if fdb3087=1 or mdb3087=1 or sdb3087=1 or bdb3087=1 then dbfh87=1;                   
                  height=height*2.54; 
                  run;

   %hp_der_2(keep= rtmnyr08 wt08 smoke08 cgnm08 bmi08 pckyr08
                   rtmnyr10 wt10 smoke10 cgnm10 bmi10 pckyr10 
                   rtmnyr12 wt12 smoke12 cgnm12 bmi12 pckyr12
                   rtmnyr14 wt14 smoke14 cgnm14 bmi14 pckyr14
                   rtmnyr16 wt16 smoke16 cgnm16 bmi16 pckyr16
                   rtmnyr18 wt18 smoke18 cgnm18 bmi18 pckyr18);

   %hp86(keep=mar86 marital86 smk1586 smk1986 smk2986 smk3986 smk4986 smk5986 smk6086 ago86 smk86 
              hbp86 db86 chol86 trig86 mi86 ang86 str86 cabg86 
              colc86 pros86 lymp86 ocan86 mel86 can86
              seuro86 scand86 ocauc86 afric86 asian86 oanc86 
              hbpd86 renf86 renfd86 pe86 ucol86 asth86 
              livng86 teeth86 fmi86 mmi86 cvdfh86 fclc86 mclc86 cafh86
              asp86 betab86 lasix86 diur86 calcb86 ald86 antch86);
              marital86=0; if mar86=1 then marital86=1;  
              if fmi86=1 or mmi86=1 then cvdfh86=1; else cvdfh86=0;
              if (fclc86=1 | mclc86=1) then cafh86=1; else cafh86=0;
              can86=0; if pros86=1 or lymp86=1 or ocan86=1 or colc86=1 or mel86=1 then can86=1;
              run;
  
   %h86_dt(keep=mvt86d mvt86);  
                if mvt86d in (0,1) then mvt86=0; 
                else if mvt86d=2 then mvt86=1; 
                else mvt86=.;
                run;  
                /***   mvt86d         take multiple vitamins (34)
	              $label 0.never;
	              1.past only;
	              2.yes current;
	              9.passthru ***/

   %hp88(keep=mar88 marital88 hbp88 db88 chol88 trig88 mi88 ang88 str88 cabg88 perd88 smk88 ncig88
              colc88 pros88 lymp88 ocan88 mel88 can88
              hbpd88 renf88 renfd88 pe88 ucol88 
              mvt88 teeth88 mar88 livng88
              asp88 betab88 lasix88 diur88 ccblo88 ald88
              pct588 pct1088 pct2088 pct3088 pct4088 pct88 physc88 chrx88 sittv88); 
              marital88=0; if mar88=1 then marital88=1;  
              if mvt88=2 then mvt88=0;  
              /***  mvt88     Currently take multivitamins? (L18)
	           $label 1.Yes, takes mvits;
	           2.No multivitamins ***/
              if smk88=1 then smk88=2; else if smk88=2 then smk88=1;
              can88=0; if pros88=1 or lymp88=1 or ocan88=1 or colc88=1 or mel88=1 then can88=1;
              run;

   %hp90(keep=mar90 marital90 hbp90 db90 chol90 trig90 mi90 ang90 str90 cabg90 perd90 smk90 ncig90
              colc90 pros90 lymp90 ocan90 mel90 can90
              renf90 renfd90 hbpd90 pe90 ucol90 
              mar90 livng90 physc90 sittv90 stcar90 stwrk90 sthom90 teeth90
              asp90  antid90 betab90 lasix90 diur90 ccblo90 ald90 chrx90
              mdb90 fdb90 sdb90 dbfh90
              fclc90 fpro90 mmel90 fmel90 mclc90 sclc90 spro90 smel90 cafh90); 
              marital90=0; if mar90=1 then marital90=1;  
              if fdb90=1 or mdb90=1 or sdb90=1 then dbfh90=1; else dbfh90=0; 
              if sum(fclc90,fpro90,mmel90,fmel90,mclc90,sclc90,spro90,smel90)>=1 then cafh90=1; else cafh90=0;
              can90=0; if pros90=1 or lymp90=1 or ocan90=1 or colc90=1 or mel90=1 then can90=1;
              run;

   %h90_dt(keep=mvt90d mvt90);  
           if mvt90d=2 then mvt90=1; else if mvt90d=1 then mvt90=0; else mvt90=.; 
           /*** mvt90d     25) Use of Multiple Vitamins
	       1 = No
	       2 = Yes
	       3 = Missing, PASSTRU
	       $range 1-3 ***/
           run;
                 
   %hp92(keep=mar92 marital92 hbp92 db92 chol92 trig92 mi92 ang92 str92 cabg92 perd92 smk92 ncig92
              renf92 renfd92 hbpd92 pe92 ucol92 asth92 pneu92
              colc92 pros92 lymp92 ocan92 mel92 can92
              mvt92  mar92 livng92 sittv92 teeth92 physx92 
              asp92 aspd92 antid92 betab92 lasix92 thiaz92 ccblo92 ald92 chrx92
              fdb92 mdb92 sdb92 dbfh92
              mlng92 mclc92 mmel92 flng92 fmel92 fclc92 fpro92 smel92 slng92 sclc92 spro92 cafh92);
              marital92=0; if mar92=1 then marital92=1; 
              if mvt92=1 then mvt92=0; 
              else if mvt92=2 then mvt92=1; 
              else mvt92=.;
              /*** mvt92     Multi-vitamin, current intake (L21)
	          $label 1.No multivitamins;\
	          2.Yes;\
	          3.passthru ***/
              if fdb92=1 or mdb92=1 or sdb92=1 then dbfh92=1; else dbfh92=0; 
              if sum(mlng92,mmel92,fmel92,mclc92,flng92,fclc92,fpro92,smel92,slng92,sclc92,spro92)>=1 then cafh92=1; else cafh92=0; 
              can92=0; if pros92=1 or lymp92=1 or ocan92=1 or colc92=1 or mel92=1 then can92=1;
              run;

   %hp94(keep=mar94 marital94 psa94 psad94 hbp94 db94 chol94 trig94 mi94 ang94 str94 cabg94 hbpd94 pe94 ucol94 pneu94 smk94 ncig94
              colc94  pros94  lymp94  ocan94  mel94 perd94 can94
              mar94 livng94 physx94 sittv94 stcar94 stwrk94 sitrd94 sito94 teeth94
              asp94 antid94 betab94 lasix94 thiaz94 ccblo94 ald94 chrx94);
              marital94=0; if mar94=1 then marital94=1; 
              can94=0; if pros94=1 or lymp94=1 or ocan94=1 or colc94=1 or mel94=1 then can94=1;
              run;

   %h94_dt(keep=mvt94d mvt94);
           if mvt94d=2 then mvt94=1; else if mvt94d=1 then mvt94=0; else mvt94=.;
           run; 

   %hp96(keep=mar96 marital96 psa96 hbp96 db96 chol96 trig96 mi96 ang96 str96 cabg96 perd96 smk96 ncig96
              hbpd96 renf96 renfd96 pe96 ucol96 asth96 pneu96 emph96
              colc96 pros96 lymp96 ocan96 mel96 smi96 brmi96 bstr96 sstr96 cvdfh96 can96
              mvt96  mar96 livar96 sittv96 tlost96 physx96 
              aspd96 antid96 betab96 lasix96 thiaz96 ccblo96 ald96 chrx96 przc96 tcyc96
              pclc96 sclc196 sclc296 fpro96 bpro196 bpro296 sbrc196 mbrcn96 cafh96 ); 
              marital96=0; if mar96=1 then marital96=1; 
              if mvt96=1 then mvt96=0; 
              else if mvt96=2 then mvt96=1; 
              else mvt96=.;
              if brmi96=1 or smi96=1 or bstr96=1 or sstr96=1 then cvdfh96=1; else cvdfh96=0;
              if sum(pclc96,sclc196,sclc296,fpro96,bpro196,bpro296,sbrc196,mbrcn96)>=1 then cafh96=1; else cafh96=0;
              can96=0; if pros96=1 or lymp96=1 or ocan96=1 or colc96=1 or mel96=1 then can96=1;
              run;

   %hp98(keep=mar98 marital98 psa98 hbp98 db98 chol98 trig98 mi98 ang98 str98 cabg98 perd98 smk98 ncig98
              colc98 pros98 lymp98 ocan98 mel98 can98
              hbpd98 renf98 renfd98 pe98 ucol98 asth98 pneu98 emph98    
              mar98 livng98 physx98 stwrk98 stcar98 sittv98 sitrd98 sito98 teeth98
              aspfr98 antid98 betab98 lasix98 thiaz98 ccblo98 ald98 chrx98 przc98 tcyc98); 
              marital98=0; if mar98=1 then marital98=1;
              can98=0; if pros98=1 or lymp98=1 or ocan98=1 or colc98=1 or mel98=1 then can98=1;
              run;
             
   %h98_dt(keep=mvt98d mvt98);
           if mvt98d=2 then mvt98=1; else if mvt98d=1 then mvt98=0; else mvt98=.;           
           run; 

   %hp00(keep=mar00 marital00 psa00 hbp00 db00 chol00 trig00 mi00 ang00 strk00 cabg00 perd00 smk00 ncig00
              colc00 pros00 lymp00 ocan00 mel00 can00
              slp00 snore00 bus00 indrs00 space00 ill00  htsc00 panic00 worry00 out00 
              hbpd00 renf00 renfd00 pe00 ucol00 asth00 pneu00 emph00    
              asp00 antid00 betab00 lasix00 thiaz00 ccblo00 oanth00 ochrx00 chrx00 przc00 tcyc00
              mvt00 mar00 livng00 vite00 physx00 sittv00 tlost00);
              marital00=0; if mar00=1 then marital00=1; 
              if mvt00=1 then mvt00=0; 
              else if mvt00=2 then mvt00=1; 
              else mvt00=.;
              can00=0; if pros00=1 or lymp00=1 or ocan00=1 or colc00=1 or mel00=1 then can00=1;  
              run;     

   %hp02(keep=mar02 marital02 psasy02 psasc02 hbp02 db02 chol02 trig02 mi02 ang02 strk02 cabg02 perd02 
              renal02 renld02 hbpd02 ra02 oa02 smk02 ncig02 renal02
              colc02 pros02 lymp02 ocan02 mel02 can02
              asp02 antid02 betab02 lasix02 thiaz02 calcb02 anthp02 iron02 stat02 ochrx02 przc02 tcyc02
              legpn02 rest02 night02
              pe02 ucol02 asth02 pneu02 pern02 copd02  
              mvt02 vite02 mar02 lalon02 depr02 physc02 stwrk02 stcar02 sittv02 sitrd02 sito02);
              marital02=0; if mar02=1 then marital02=1;
              if mvt02=1 then mvt02=0; 
              else if mvt02=2 then mvt02=1; 
              else mvt02=.;
              can02=0; if pros02=1 or lymp02=1 or ocan02=1 or colc02=1 or mel02=1 then can02=1;    
              run; 	     

   %hp04(keep=mar04 marital04 psasy04 psasc04 hbp04 db04 chol04 trig04 mi04 mi1d04 ang04 angd04 strk04 cabg04 cabgd04
              asp04 betab04 ace04 lasix04 thiaz04 calcb04 anthp04 iron04 stat04 przc04 tcyc04 antid04 ra04 oa04 smk04 ncig04 
              colc04 pros04 lymp04 ocan04 mel04 dfslp04 wake04 early04 nap04 restd04 renal04  
              hbpd04 renal04 renld04 pe04 ucol04 asth04 pneu04 pern04 copd04 perd04 can04
              mvt04 vite04 physc04 depr04 mar04 lalon04
              mev04 zoc04 crest04 prav04 lip04 ostat04 ochrx04 slept04 sittv04 tlost04);
              marital04=0; if mar04=1 then marital04=1;
              if mvt04=1 then mvt04=0; 
              else if mvt04=2 then mvt04=1; 
              else mvt04=.;
              can04=0; if pros04=1 or lymp04=1 or ocan04=1 or colc04=1 or mel04=1 then can04=1;   
              run;            

   %hp06(keep=mar06 marital06 psasy06 psasc06 hbp06 hbpd06 db06 chol06 trig06 mi06 ang06 angd06 strk06 cabg06 cabgd06 mib06 angd06 
              asp06 betab06 ace06 lasix06 thiaz06 calcb06 anthp06 iron06 stat06 przc06 tcyc06 antid06 ra06 oa06 smk06 ncig06 
              colc06 pros06 lymp06 ocan06 mel06 perd06 can06
              mvt06 vite06 physc06
              hbpd06 renal06 renld06 pe06 ucol06 asth06 pneu06 pern06  copd06  mar06 lalon06
              mev06 zoc06 crest06 prav06 lip06 ostat06 ochrx06 stwrk06 stcar06 sittv06 sitrd06 stcmp06 sito06 tlost06);
              marital06=0; if mar06=1 then marital06=1;   
              if mvt06=1 then mvt06=0; 
              else if mvt06=2 then mvt06=1; 
              else mvt06=.;
              can06=0; if pros06=1 or lymp06=1 or ocan06=1 or colc06=1 or mel06=1 then can06=1;   
              run;  

   %hp08(keep=mar08 marital08 psasy08 psasc08 hbp08 hbpd08 db08 chol08 trig08 mi08 ang08 strk08 cabg08 cabgd08 mi1d08 angd08 
              colc08 pros08 lymp08 ocan08 mel08 perd08 can08
              asp08 betab08 ace08 lasix08 thiaz08 calcb08 arb08 anthp08 iron08 ssri08 snri08 tcyc08 maoi08 antid08 
              ra08 oa08 smk08 ncig08 renal08  
              mvt08 vite08 physc08
              sclc108 sclc208 pmel08 smel08 mpnc08 fpnc08 spnc08 bpnc08 cafh08 
              fdb08 sdb08 mdb08 dbfh08
              hbpd08 renal08 renld08 pe08 ucol08 asth08 pneu08 pern08 copd08 group08 mar08 lalon08 depr08 ncig08
              drt08  stat08 mev08 zoc08 crest08 prav08 lip08 ostat08 ochrx08 stwrk08 stcar08 sittv08 sitrd08 stcmp08 sito08 tlost08);
              marital08=0; if mar08=1 then marital08=1;    
              if mvt08=1 then mvt08=0; 
              else if mvt08=2 then mvt08=1; 
              else mvt08=.;    
              if sum(sclc108,sclc208,pmel08,smel08,mpnc08,fpnc08,spnc08,bpnc08)>=1 then cafh08=1; else cafh08=0;  
              if fdb08=1 or sdb08=1 or mdb08=1 then dbfh08=1; else dbfh08=0; 
              can08=0; if pros08=1 or lymp08=1 or ocan08=1 or colc08=1 or mel08=1 then can08=1;  
              run;         

   %hp10(keep=mar10 marital10 psasy10 psasc10 hbp10 hbpd10 db10 chol10 trig10 mi10 ang10 strk10 cabg10 cabgd10 smk10 ncig10
              mvt10 physc10  mar10 lalon10
              pros10 lymp10 ocan10 colc10 mel10 perd10 can10
              asp10 betab10 ace10 lasix10 thiaz10 calcb10 arb10 anthp10 andep10
              stat10 mev10 zoc10 crest10 prav10 lip10 ostat10 ochrx10 stwrk10 sittv10 sito10 tlost10);
              marital10=0; if mar10=1 then marital10=1;
              if mvt10=1 then mvt10=0; 
              else if mvt10=2 then mvt10=1; 
              else mvt10=.;
              can10=0; if pros10=1 or lymp10=1 or ocan10=1 or colc10=1 or mel10=1 then can10=1; 
              run;       

   %hp12(keep=mar12 marital12 psasy12 psasc12 hbp12 hbpd12 db12 chol12 trig12 mi12 ang12 strk12 cabg12 cabgd12 smk12 ncig12
              pros12 lymp12 ocan12 colc12 mel12 perd12 can12
              mvt12 vite12 asp12);
              marital12=0; if mar12=1 then marital12=1;   
              if mvt12=1 then mvt12=0; 
              else if mvt12=2 then mvt12=1; 
              else mvt12=.;
              can12=0; if pros12=1 or lymp12=1 or ocan12=1 or colc12=1 or mel12=1 then can12=1;  
              run;   

   %hp14(keep=mar14 marital14 psasy14 psasc14 hbp14 hbpd14 db14 chol14 mi14 ang14 strk14 cabg14 cabgd14 mvt14 vite14 asp14 smk14 ncig14
              pros14 lymp14 ocan14 colc14 mel14 perd14 can14);
              marital14=0; if mar14=1 then marital14=1;  
              if mvt14=1 then mvt14=0; 
              else if mvt14=2 then mvt14=1; 
              else mvt14=.;
              can14=0; if pros14=1 or lymp14=1 or ocan14=1 or colc14=1 or mel14=1 then can14=1;
              run;        

   %hp16(keep=mar16 marital16 psasy16 psasc16 hbp16 hbpd16 db16 chol16 mi16 ang16 stk16 cabg16 cabgd16 asp16 smk16 ncig16
              pros16 lymp16 ocan16 colc16 mel16 can16);  /*no mvt*/ 
              marital16=0; if mar16=1 then marital16=1;    
              can16=0; if pros16=1 or lymp16=1 or ocan16=1 or colc16=1 or mel16=1 then can16=1; 
              run;    
  
   %hp18(keep=mar18 marital18 psasy18 psasc18 hbp18 hbpd18 db18 chol18 mi18 ang18 strk18 cabg18 cabgd18 asp18 smk18 ncig18
              pros18 lymp18 ocan18 colc18 mel18 can18 mvt18); 
              marital18=0; if mar18=1 then marital18=1; 
	     if mvt18=1 then mvt18=0; 
              else if mvt18=2 then mvt18=1; 
              else mvt18=.;   
              can18=0; if pros18=1 or lymp18=1 or ocan18=1 or colc18=1 or mel18=1 then can18=1; 
              run;    

   %hmet8620;
   data hp_metsm; 
        set hmet8620; 
           array act{*}  act86  act88  act90  act92  act94  act96  act98  act00  act02  act04  act06  act08  act10  act12  act14  act16  act20 ;         
           do i=1 to dim(act);
           if act{i}<0 or act{i}>=998 then act{i}= . ;
           end; drop i;
           do i=2 to 17;
		if act{i}=. then act{i}=act{i-1};  /*carry forward missing PA*/
           end; drop i; 
           keep id act86 act88 act90 act92 act94 act96 act98 act00 act02 act04 act06 act08 act10 act12 act14 act16 act20;
           run; 

   %h86_nts(keep = calor86n alco86n); 
   %h90_nts(keep = calor90n alco90n); 
   %h94_nts(keep = calor94n alco94n); 
   %h98_nts(keep = calor98n alco98n); 
   %h02_nts(keep = calor02n alco02n); 
   %h06_nts(keep = calor06n alco06n); 
   %h10_nts(keep = calor10n alco10n); 
   %h14_nts(keep = calor14n alco14n); 
   %h18_nts(keep = calor18n alco18n);

   libname AHEIdat '/proj/hpalcs/hpalc0b/DIETSCORES/HPFS/';

          data ahei86; set AHEIdat.hnahei86l; 
                 keep id nAHEI86a nAHEI86_noal;
                 proc sort; by id; run;
                       
          data ahei90; set AHEIdat.hnahei90l; 
                 keep id nAHEI90a nAHEI90_noal;
 	        proc sort; by id; run;
         
          data ahei94; set AHEIdat.hnahei94l;  
                 keep id nAHEI94a nAHEI94_noal;
                 proc sort; by id; run;
        
          data ahei98; set AHEIdat.hnahei98l; 
                 keep id nAHEI98a nAHEI98_noal;
                 proc sort; by id; run;
        
          data ahei02; set AHEIdat.hnahei02l; 
                 keep id nAHEI02a nAHEI02_noal;
                 proc sort; by id; run;
        
          data ahei06; set AHEIdat.hnahei06l; 
                 keep id nAHEI06a nAHEI06_noal;              
                 proc sort; by id; run; 

   libname AHEI1014 '/udd/hpypl/review/dietscore/';

          data ahei10; set AHEI1014.hnahei10l; 
                 keep id nAHEI10a nAHEI10_noal;              
                 proc sort; by id; run;

          data ahei14; set AHEI1014.hnahei14l; 
                 keep id nAHEI14a nAHEI14_noal;              
                 proc sort; by id; run;


    *******************************************
    *           Merge    Datasets             *
    *******************************************;

data base;
    merge hp_der(in=mst) hp_der_2 hpfs_outcome hp_metsm hpfs_asp
                         hp86 hp88 hp90 hp92 hp94 hp96 hp98 hp00 hp02 hp04 hp06 hp08 hp10 hp12 hp14 hp16 hp18
                         h86_dt h90_dt h94_dt h98_dt 
                         ahei86 ahei90 ahei94 ahei98 ahei02 ahei06 ahei10 ahei14
                         h86_nts h90_nts h94_nts h98_nts h02_nts h06_nts h10_nts h14_nts h18_nts
                         ;
    by id;
    exrec=1;
    if first.id and mst then exrec=0;  

     /* RACE */
     if seuro86=1 then ethnic =1;
     else if scand86=1 then ethnic =1;
     else if ocauc86=1 then ethnic =1;
     else if afric86=1 then ethnic =2;
     else if asian86=1 then ethnic =3;
     else if oanc86=1  then ethnic =4;
     else ethnic=.;
     if ethnic=1 then white=1; else white=0; if ethnic=. then white=.;

    /* AGE */
    array age    {*}  age86          age88          age90          age92          age94           age96           age98          age00          age02          age04          age06           age08           age10          age12          age14        age16       age18;
    array rtmn   {*}  rtmnyr86       rtmnyr88       rtmnyr90       rtmnyr92       rtmnyr94        rtmnyr96        rtmnyr98       rtmnyr00       rtmnyr02       rtmnyr04       rtmnyr06        rtmnyr08        rtmnyr10       rtmnyr12       rtmnyr14     rtmnyr16    rtmnyr18;
    array irt    {*}  irt86          irt88          irt90          irt92          irt94           irt96           irt98          irt00          irt02          irt04          irt06           irt08           irt10          irt12          irt14        irt16       irt18;

    do i=1 to DIM(age);
    irt(i)=rtmn(i); 
    age(i)=int((rtmn(i) - dbmy09)/12);   
    if age(i) le 0 then age(i)=.; 
    end; drop i;
    do i=2 to DIM(age);
    if age(i)=.    then age(i)=age(i-1)+2;    
    end; drop i;


    /** check **/
    array airt   {*} irt86    irt88    irt90    irt92    irt94    irt96    irt98    irt00    irt02    irt04    irt06    irt08    irt10    irt12    irt14    irt16    irt18;
    array anoirt {*} noirt86  noirt88  noirt90  noirt92  noirt94  noirt96  noirt98  noirt00  noirt02  noirt04  noirt06  noirt08  noirt10  noirt12  noirt14  noirt16  noirt18;

    do i=1 to DIM(airt);
    if airt{i}=. | airt{i}=0 then anoirt{i}=1;
    end; drop i;


    /* PHYSICAL ACTIVITY */   
    act86v=act86; 
    act88v=mean(act86, act88);
    act90v=mean(act86, act88, act90);
    act92v=mean(act86, act88, act90, act92);
    act94v=mean(act86, act88, act90, act92, act94);
    act96v=mean(act86, act88, act90, act92, act94, act96);
    act98v=mean(act86, act88, act90, act92, act94, act96, act98);
    act00v=mean(act86, act88, act90, act92, act94, act96, act98, act00);
    act02v=mean(act86, act88, act90, act92, act94, act96, act98, act00, act02);
    act04v=mean(act86, act88, act90, act92, act94, act96, act98, act00, act02, act04);
    act06v=mean(act86, act88, act90, act92, act94, act96, act98, act00, act02, act04, act06);
    act08v=mean(act86, act88, act90, act92, act94, act96, act98, act00, act02, act04, act06, act08);
    act10v=mean(act86, act88, act90, act92, act94, act96, act98, act00, act02, act04, act06, act08, act10);
    act12v=mean(act86, act88, act90, act92, act94, act96, act98, act00, act02, act04, act06, act08, act10, act12);
    act14v=mean(act86, act88, act90, act92, act94, act96, act98, act00, act02, act04, act06, act08, act10, act12, act14);
    act16v=mean(act86, act88, act90, act92, act94, act96, act98, act00, act02, act04, act06, act08, act10, act12, act14, act16);

    act86s=act86; 
    act88s=sum(act86, act88);
    act90s=sum(act86, act88, act90);
    act92s=sum(act86, act88, act90, act92);
    act94s=sum(act86, act88, act90, act92, act94);
    act96s=sum(act86, act88, act90, act92, act94, act96);
    act98s=sum(act86, act88, act90, act92, act94, act96, act98);
    act00s=sum(act86, act88, act90, act92, act94, act96, act98, act00);
    act02s=sum(act86, act88, act90, act92, act94, act96, act98, act00, act02);
    act04s=sum(act86, act88, act90, act92, act94, act96, act98, act00, act02, act04);
    act06s=sum(act86, act88, act90, act92, act94, act96, act98, act00, act02, act04, act06);
    act08s=sum(act86, act88, act90, act92, act94, act96, act98, act00, act02, act04, act06, act08);
    act10s=sum(act86, act88, act90, act92, act94, act96, act98, act00, act02, act04, act06, act08, act10);
    act12s=sum(act86, act88, act90, act92, act94, act96, act98, act00, act02, act04, act06, act08, act10, act12);
    act14s=sum(act86, act88, act90, act92, act94, act96, act98, act00, act02, act04, act06, act08, act10, act12, act14);
    act16s=sum(act86, act88, act90, act92, act94, act96, act98, act00, act02, act04, act06, act08, act10, act12, act14, act16);
    act18s=sum(act86, act88, act90, act92, act94, act96, act98, act00, act02, act04, act06, act08, act10, act12, act14, act16, act16);

    array act{*}       act86  act88  act90  act92  act94  act96  act98  act00  act02  act04  act06  act08  act10  act12  act14  act16;
    array actbin{*}    att86  att88  att90  att92  att94  att96  att98  att00  att02  att04  att06  att08  att10  att12  att14  att16; 

    do i=1 to dim(act);
    /* whether satisfy the recommended level */
    if act{i}>=7.5 then actbin{i}=1; else actbin{i}=0;
    end; drop i; 
 
    /* cumulative duration of satisfying the recommended level */
    sust86=sum(att86); 
    sust88=sum(att86, att88);
    sust90=sum(att86, att88, att90);
    sust92=sum(att86, att88, att90, att92);
    sust94=sum(att86, att88, att90, att92, att94);
    sust96=sum(att86, att88, att90, att92, att94, att96);
    sust98=sum(att86, att88, att90, att92, att94, att96, att98);
    sust00=sum(att86, att88, att90, att92, att94, att96, att98, att00);
    sust02=sum(att86, att88, att90, att92, att94, att96, att98, att00, att02);
    sust04=sum(att86, att88, att90, att92, att94, att96, att98, att00, att02, att04);
    sust06=sum(att86, att88, att90, att92, att94, att96, att98, att00, att02, att04, att06);
    sust08=sum(att86, att88, att90, att92, att94, att96, att98, att00, att02, att04, att06, att08);
    sust10=sum(att86, att88, att90, att92, att94, att96, att98, att00, att02, att04, att06, att08, att10);
    sust12=sum(att86, att88, att90, att92, att94, att96, att98, att00, att02, att04, att06, att08, att10, att12);
    sust14=sum(att86, att88, att90, att92, att94, att96, att98, att00, att02, att04, att06, att08, att10, att12, att14);
    sust16=sum(att86, att88, att90, att92, att94, att96, att98, att00, att02, att04, att06, att08, att10, att12, att14, att16);
    sust18=sum(att86, att88, att90, att92, att94, att96, att98, att00, att02, att04, att06, att08, att10, att12, att14, att16, att16);

    /* percentage of years satisfying the recommended level */
    psust86=sum(att86); 
    psust88=round(sum(att86, att88)/2, 0.01);
    psust90=round(sum(att86, att88, att90)/3, 0.01);
    psust92=round(sum(att86, att88, att90, att92)/4, 0.01);
    psust94=round(sum(att86, att88, att90, att92, att94)/5, 0.01);
    psust96=round(sum(att86, att88, att90, att92, att94, att96)/6, 0.01);
    psust98=round(sum(att86, att88, att90, att92, att94, att96, att98)/7, 0.01);
    psust00=round(sum(att86, att88, att90, att92, att94, att96, att98, att00)/8, 0.01);
    psust02=round(sum(att86, att88, att90, att92, att94, att96, att98, att00, att02)/9, 0.01);
    psust04=round(sum(att86, att88, att90, att92, att94, att96, att98, att00, att02, att04)/10, 0.01);
    psust06=round(sum(att86, att88, att90, att92, att94, att96, att98, att00, att02, att04, att06)/11, 0.01);
    psust08=round(sum(att86, att88, att90, att92, att94, att96, att98, att00, att02, att04, att06, att08)/12, 0.01);
    psust10=round(sum(att86, att88, att90, att92, att94, att96, att98, att00, att02, att04, att06, att08, att10)/13, 0.01);
    psust12=round(sum(att86, att88, att90, att92, att94, att96, att98, att00, att02, att04, att06, att08, att10, att12)/14, 0.01);
    psust14=round(sum(att86, att88, att90, att92, att94, att96, att98, att00, att02, att04, att06, att08, att10, att12, att14)/15, 0.01);
    psust16=round(sum(att86, att88, att90, att92, att94, att96, att98, att00, att02, att04, att06, att08, att10, att12, att14, att16)/16, 0.01);
    psust18=round(sum(att86, att88, att90, att92, att94, att96, att98, att00, att02, att04, att06, att08, att10, att12, att14, att16, att16)/17, 0.01);

    /* BMI */
    array bmi    {*}  bmi86  bmi88  bmi90  bmi92  bmi94  bmi96  bmi98  bmi00  bmi02  bmi04  bmi06  bmi08  bmi10  bmi12  bmi14  bmi16  bmi18;
    
    do i=1 to dim(bmi);
    if bmi{i}<=10 then bmi{i}=.;
    end; drop i;

    do i=2 to dim(bmi); 
    if bmi{i}=. then bmi{i}=bmi{i-1};
    end; drop i;
    
    bmi86v=bmi86;
    bmi88v=mean(bmi86, bmi88);
    bmi90v=mean(bmi86, bmi88, bmi90);
    bmi92v=mean(bmi86, bmi88, bmi90, bmi92);
    bmi94v=mean(bmi86, bmi88, bmi90, bmi92, bmi94);
    bmi96v=mean(bmi86, bmi88, bmi90, bmi92, bmi94, bmi96);
    bmi98v=mean(bmi86, bmi88, bmi90, bmi92, bmi94, bmi96,bmi98);
    bmi00v=mean(bmi86, bmi88, bmi90, bmi92, bmi94, bmi96,bmi98, bmi00);
    bmi02v=mean(bmi86, bmi88, bmi90, bmi92, bmi94, bmi96,bmi98, bmi00, bmi02);
    bmi04v=mean(bmi86, bmi88, bmi90, bmi92, bmi94, bmi96,bmi98, bmi00, bmi02, bmi04);
    bmi06v=mean(bmi86, bmi88, bmi90, bmi92, bmi94, bmi96,bmi98, bmi00, bmi02, bmi04,bmi06);
    bmi08v=mean(bmi86, bmi88, bmi90, bmi92, bmi94, bmi96,bmi98, bmi00, bmi02, bmi04,bmi06, bmi08);
    bmi10v=mean(bmi86, bmi88, bmi90, bmi92, bmi94, bmi96,bmi98, bmi00, bmi02, bmi04,bmi06, bmi08, bmi10);
    bmi12v=mean(bmi86, bmi88, bmi90, bmi92, bmi94, bmi96,bmi98, bmi00, bmi02, bmi04,bmi06, bmi08, bmi10, bmi12);
    bmi14v=mean(bmi86, bmi88, bmi90, bmi92, bmi94, bmi96,bmi98, bmi00, bmi02, bmi04,bmi06, bmi08, bmi10, bmi12, bmi14);
    bmi16v=mean(bmi86, bmi88, bmi90, bmi92, bmi94, bmi96,bmi98, bmi00, bmi02, bmi04,bmi06, bmi08, bmi10, bmi12, bmi14, bmi16);
    bmi18v=mean(bmi86, bmi88, bmi90, bmi92, bmi94, bmi96,bmi98, bmi00, bmi02, bmi04,bmi06, bmi08, bmi10, bmi12, bmi14, bmi16, bmi18);

    basebmi=bmi86;

    /* ALCOHOL */
    array alcon   {*} alco86n   alco90n   alco94n   alco98n   alco02n   alco06n   alco10n   alco14n  alco18n;  
        
    do i=2 to dim(alcon); 
    if alcon{i}=. then alcon{i}=alcon{i-1};
    end; drop i;

    alco86nv=alco86n;
    alco90nv=mean(alco86n,alco90n);
    alco94nv=mean(alco86n,alco90n,alco94n);
    alco98nv=mean(alco86n,alco90n,alco94n,alco98n);
    alco02nv=mean(alco86n,alco90n,alco94n,alco98n,alco02n);
    alco06nv=mean(alco86n,alco90n,alco94n,alco98n,alco02n,alco06n);
    alco10nv=mean(alco86n,alco90n,alco94n,alco98n,alco02n,alco06n,alco10n);
    alco14nv=mean(alco86n,alco90n,alco94n,alco98n,alco02n,alco06n,alco10n,alco14n);
    alco18nv=mean(alco86n,alco90n,alco94n,alco98n,alco02n,alco06n,alco10n,alco14n,alco18n);

    /* AHEI */
    array ahei    {*} nAHEI86a    nAHEI90a     nAHEI94a    nAHEI98a     nAHEI02a     nAHEI06a    nAHEI10a    nAHEI14a;  

    do i=2 to dim(ahei); 
    if ahei{i}=. then ahei{i}=ahei{i-1};
    end; drop i;

    ahei86v=nAHEI86a;
    ahei90v=mean(nAHEI86a,nAHEI90a);
    ahei94v=mean(nAHEI86a,nAHEI90a,nAHEI94a);
    ahei98v=mean(nAHEI86a,nAHEI90a,nAHEI94a,nAHEI98a);
    ahei02v=mean(nAHEI86a,nAHEI90a,nAHEI94a,nAHEI98a,nAHEI02a);
    ahei06v=mean(nAHEI86a,nAHEI90a,nAHEI94a,nAHEI98a,nAHEI02a,nAHEI06a);
    ahei10v=mean(nAHEI86a,nAHEI90a,nAHEI94a,nAHEI98a,nAHEI02a,nAHEI06a,nAHEI10a);
    ahei14v=mean(nAHEI86a,nAHEI90a,nAHEI94a,nAHEI98a,nAHEI02a,nAHEI06a,nAHEI10a,nAHEI14a);

    /* ASPIRIN or NSAIDS */
    /* aspu 1 = current (current, >1 d/w, or >=1 tabs/w), 2 = former, 0 = never, . = missing */
    array regaspa {*} regaspre86 regaspre88 regaspre90 regaspre92 regaspre94 regaspre96 regaspre98 regaspre00 regaspre02 regaspre04 regaspre06 regaspre08 regaspre10 regaspre12 regaspre14 regaspre16;
    array regibuia{*} regibui86  regibui88  regibui90  regibui92  regibui94  regibui96  regibui98  regibui00  regibui02  regibui04  regibui06  regibui08  regibui10  regibui12  regibui14  regibui16;
	
    do i=1 to dim(regaspa);
	if i>1 then do;
	   if regaspa{i}=. and regaspa{i-1} ne . then regaspa{i}=regaspa{i-1};
	   if regibuia{i}=. and regibuia{i-1} ne . then regibuia{i}=regibuia{i-1};
	end;
    end; drop i;

    array mvit {*} mvt86  mvt88  mvt90  mvt92  mvt94  mvt96  mvt98  mvt00  mvt02  mvt04  mvt06  mvt08  mvt10  mvt12  mvt14  mvt18;
    do i=1 to dim(mvit);
	if i>1 then do;
	   if mvit{i}=. and mvit{i-1} ne . then mvit{i}=mvit{i-1};
	end;
    end; drop i;

    /* SMOKING */
    /* RAW Data: SMOKE=smoking status label 1.Never;  2.Past; 3.No, unknown past history; 4.Current; 5.PASSTHRU; */
    array smk    {*}  smoke86  smoke88  smoke90  smoke92  smoke94  smoke96  smoke98  smoke00  smoke02  smoke04  smoke06  smoke08  smoke10  smoke12  smoke14  smoke16  smoke18;
    array cigda  {*}  cgnm86   cgnm88   cgnm90   cgnm92   cgnm94   cgnm96   cgnm98   cgnm00   cgnm02   cgnm04   cgnm06   cgnm08   cgnm10   cgnm12   cgnm14   cgnm16   cgnm18;
    array pkyr   {*}  pckyr86  pckyr88  pckyr90  pckyr92  pckyr94  pckyr96  pckyr98  pckyr00  pckyr02  pckyr04  pckyr06  pckyr08  pckyr10  pckyr12  pckyr14  pckyr16  pckyr18; 

    do i=1 to dim(smk);
		if smk{i} in (.,3,5) then smk{i}=.; else if smk{i}=4 then smk{i}=3; *current;
		if smk{i}=. and cigda{i} in (1,2,3,4,5,6) then smk{i}=3;
		if cigda{i} in (.,0,7) then cigda{i}=.;
		if pkyr{i}>=998 then pkyr{i}=.;
        
            if i>1 then do;
			if smk{i}=. & smk{i-1}^=. then smk{i}=smk{i-1};
			if smk{i}=3 & cigda{i}=. & cigda{i-1}^=. then cigda{i}=cigda{i-1};
			if pkyr{i}=. & pkyr{i-1}^=. then pkyr{i}=pkyr{i-1};
            end;

    end; drop i;

    /* CHRONIC DISEASE */
    array repmi   {*}    mi86           mi88           mi90           mi92           mi94            mi96            mi98           mi00           mi02           mi04           mi06            mi08            mi10           mi12           mi14         mi16       mi18;
    array repstrk {*}    str86          str88          str90          str92          str94           str96           str98          strk00         strk02         strk04         strk06          strk08          strk10         strk12         strk14       stk16      stk18;
    array diab    {*}    db86           db88           db90           db92           db94            db96            db98           db00           db02           db04           db06            db08            db10           db12           db14         db16       db18;
    array canc    {*}    can86          can88          can90          can92          can94           can96           can98          can00          can02          can04          can06           can08           can10          can12          can14        can16      can18;
    array chol    {*}    chol86         chol88         chol90         chol92         chol94          chol96          chol98         chol00         chol02         chol04         chol06          chol08          chol10         chol12         chol14       chol16     chol18;
    array hbp     {*}    hbp86          hbp88          hbp90          hbp92          hbp94           hbp96           hbp98          hbp00          hbp02          hbp04          hbp06           hbp08           hbp10          hbp12          hbp14        hbp16      hbp18;
    array repang  {*}    ang86          ang88          ang90          ang92          ang94           ang96           ang98          ang00          ang02          ang04          ang06           ang08           ang10          ang12          ang14        ang16      ang18;
    array repcabg {*}    cabg86         cabg88         cabg90         cabg92         cabg94          cabg96          cabg98         cabg00         cabg02         cabg04         cabg06          cabg08          cabg10         cabg12         cabg14       cabg16     cabg18;
 
    do i= 2 to DIM(repmi);     if repmi(i-1)=1       then repmi(i)=1;     end; drop i;
    do i= 2 to DIM(repstrk);   if repstrk(i-1)=1     then repstrk(i)=1;   end; drop i;
    do i= 2 to DIM(diab);      if diab(i-1)=1        then diab(i)=1;      end; drop i;
    do i= 2 to DIM(canc);      if canc(i-1)=1        then canc(i)=1;      end; drop i;
    do i= 2 to DIM(chol);      if chol(i-1)=1        then chol(i)=1;      end; drop i;
    do i= 2 to DIM(hbp);       if hbp(i-1)=1         then hbp(i)=1;       end; drop i;
    do i= 2 to DIM(repang);    if repang(i-1)=1      then repang(i)=1;    end; drop i;
    do i= 2 to DIM(repcabg);   if repcabg(i-1)=1     then repcabg(i)=1;   end; drop i; 

    /* FAMILY HISTORY */
    array fhxcanc {*}    cafh86   cafh90   cafh92   cafh96   cafh08   cafh12 ;
    array fhxcvd  {*}    cvdfh86  cvdfh96  ;
    array fhxdb   {*}    dbfh87   dbfh90   dbfh92   dbfh08 ;

    do i= 2 to DIM(fhxcanc);    if fhxcanc(i-1)=1      then fhxcanc(i)=1;    end;
    do i= 2 to DIM(fhxcvd);     if fhxcvd(i-1)=1       then fhxcvd(i)=1;    end;
    do i= 2 to DIM(fhxdb);      if fhxdb(i-1)=1        then fhxdb(i)=1;    end;
 
    /** check **/
    if cafh86=1 or cafh90=1 or cafh92=1 or cafh96=1 or cafh08=1 or cafh12=1 then cafh=1; else cafh=0;
    if dbfh87=1 or dbfh90=1 or dbfh92=1 or dbfh08=1 then dbfh=1; else dbfh=0;
    if cvdfh86=1 or cvdfh96=1 then cvdfh=1; else cvdfh=0;

run;

proc datasets;
delete    hp_der hp_der_2 hpfs_outcome hp_metsm hpfs_asp
                         hp86 hp88 hp90 hp92 hp94 hp96 hp98 hp00 hp02 hp04 hp06 hp08 hp10 hp12 hp14 hp16 hp18
                         h86_dt h90_dt h94_dt h98_dt 
                         ahei86 ahei90 ahei94 ahei98 ahei02 ahei06 ahei10 ahei14
                         h86_nts h90_nts h94_nts h98_nts h02_nts h06_nts h10_nts h14_nts h18_nts
;
run;

/*
proc means n nmiss mean min max;
run;
*/
