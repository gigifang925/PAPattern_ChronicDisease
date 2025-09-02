/********************************************************************************************************************************************
Programmer:         Zhe (Gigi) Fang                                                                                                       
Start Date:         02/20/2024  
Purpose:            Long-term physical activity patterns and incidence of major chronic diseases
Study design:       Prospective cohort                                                                              
Follow-up period:   1989-2021  
Exclusions at baseline:
- multiple records and not in master file
- missing age in 1989
- missing physical activity in 1989
- death before 1989
- history of cancer, CVD, or diabetes before 1989 
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


         options linesize=130 pagesize=80;
         filename nhstools '/proj/nhsass/nhsas00/nhstools/sasautos/'; 
         filename local '/usr/local/channing/sasautos/';
         filename ehmac '/udd/stleh/ehmac/';
         libname library '/proj/nhsass/nhsas00/formats/';
         options mautosource sasautos=(local nhstools);          *** path to macros  ***;
         options fmtsearch=(library);                            *** path to formats ***;

libname g_fm '/udd/hpzfa/review/PA/revision/gformula'; 

*call in outcome;
%include '/udd/hpzfa/review/PA/revision/gformula/nhs2.outcome.sas';

*call in derived aspirin and nsaids;
%include '/udd/hpzfa/review/PA/revision/gformula/asp_nhs2.sas';
proc sort nodupkey data=nhs2_asp;by id;run;


* ------ FAMILY HISTORY ------ *;

      %nur89(keep=ambrc89 asbrc89 mclc89 fclc89 bclc89 sclc89 mmel89 fmel89 bmel89 smel89 cafh89 
                  mdb89 fdb89 bdb89 sdb89 dbfh89 ammi89 afmi89 cvdfh89); 
             if ambrc89 in (1,2,3,4,5) or asbrc89 in (1,2,3,4,5) or mclc89=1 or fclc89=1 or bclc89=1 or sclc89=1 or mmel89=1 or fmel89=1 or bmel89=1 or smel89=1 then cafh89=1; else cafh89=0;
             if mdb89=1 or fdb89=1 or bdb89=1 or sdb89=1 then dbfh89=1; else dbfh89=0;
             if ammi89 in (1,2,3,4,5) or afmi89 in (1,2,3,4,5) then cvdfh89=1; else cvdfh89=0;
             run;  

      %nur93(keep=msov93 mcanc93 fcanc93 cafh93 fmi93 mmi93 cvdfh93);
	    cafh93=0; if msov93=2 or mcanc93=1 or fcanc93=1 then cafh93=1; 
	    if fmi93=1 or mmi93=1 then cvdfh93=1; else cvdfh93=0;
             run;

      %nur97(keep=pclc97 sclc197 sclc297 mbrcn97 sbrc197 sbrc297 mov97 sov97 pclc97 sclc197 sclc297 pmel97 smel97 cafh97 
                  pdb97 sbdb97 dbfh97 mstr97 fstr97 sbstr97 mmi97 fmi97 cvdfh97); 
             if sum(pclc97,sclc197,sclc297,mbrcn97,sbrc197,sbrc297,mov97,sov97,pclc97,sclc197,sclc297,pmel97,smel97)>0 then cafh97=1; else cafh97=0;
             if pdb97=1 or sbdb97=1 then dbfh97=1; else dbfh97=0;
             if mstr97=1 or fstr97=1 or sbstr97=1 or mmi97=1 or fmi97=1 then cvdfh97=1; else cvdfh97=0;
             run;

      %nur01(keep=mov01 sov01 mbrcn01 sbrc101 sbrc201 pclc01 sclc101 sclc201 mut01 smut01 ppan01 span01 pmel01 smel01 cafh01 
                  mdb01 fdb01 sdb01 dbfh01 mstr01 fstr01 sstr01 mmi01 fmi01 smi01 cvdfh01);
             if sum(mov01,sov01,mbrcn01,sbrc101,sbrc201,pclc01,sclc101,sclc201,mut01,smut01,ppan01,span01,pmel01,smel01)>0 then cafh01=1; else cafh01=0;
             if mdb01=1 or fdb01=1 or sdb01=1 then dbfh01=1; else dbfh01=0;
             if mstr01=1 or fstr01=1 or sstr01=1 or mmi01=1 or fmi01=1 or smi01=1 then cvdfh01=1; else cvdfh01=0;
             run;

      %nur05(keep=mov05 sov05 mbrcn05 sbrc105 sbrc205 pclc05 sclc105 sclc205 mdcan05 fdcan05 pmel05 smel05 cafh05 
                  mdb05 fdb05 sdb05 dbfh05 fdchd05 fdstr05 mdchd05 mdstr05 cvdfh05); 
             if sum(mov05,sov05,mbrcn05,sbrc105,sbrc205,pclc05,sclc105,sclc205,mdcan05,fdcan05,pmel05,smel05) then cafh05=1; else cafh05=0;
             if mdb05=1 or fdb05=1 or sdb05=1 then dbfh05=1; else dbfh05=0;
             if fdchd05=1 or fdstr05=1 or mdchd05=1 or mdstr05=1 then cvdfh05=1; else cvdfh05=0;
             run; 
         
      %nur09(keep=pclc09 sclc109 sclc209 mov09 sov09 mbrcn09 sbrcn09 mdcan09 fdcan09 cafh09 
                  pdb09 sdb09 dbfh09 mdchd09 mdstr09 fdchd09 fdstr09 cvdfh09); 
             if sum(pclc09,sclc109,sclc209,mov09,sov09,mbrcn09,sbrcn09,mdcan09,fdcan09)>0 then cafh09=1; else cafh09=0;
             if pdb09=1 or sdb09=1 then dbfh09=1; else dbfh09=0;
             if mdchd09=1 or mdstr09=1 or fdchd09=1 or fdstr09=1 then cvdfh09=1; else cvdfh09=0;
             run;

      %nur13(keep=hxov13 hxbc13 mdcan13 fdcan13 cafh13 fdchd13 fdstr13 mdchd13 mdstr13 cvdfh13 
                  hxdb13 dbfh13);
             if sum(hxov13,hxbc13,mdcan13,fdcan13)>0 then cafh13=1; else cafh13=0;
             if fdchd13=1 or fdstr13=1 or mdchd13=1 or mdstr13=1 then cvdfh13=1; else cvdfh13=0;
             if hxdb13=1 then dbfh13=1; else dbfh13=0;
             run;

      data  familyhis;
         merge nur89 nur93 nur97 nur01 nur05 nur09 nur13;
         by id;

            /*
            if cafh89=1 or cafh93=1 or cafh97=1 or cafh01=1 or cafh05=1 or cafh09=1 or cafh13=1 then cafh=1; else cafh=0;
            if cvdfh89=1 or cvdfh93=1 or cvdfh97=1 or cvdfh01=1 or cvdfh05=1 or cvdfh09=1 or cvdfh13=1 then cvdfh=1; else cvdfh=0;
            if dbfh89=1 or dbfh97=1 or dbfh01=1 or dbfh05=1 or dbfh09=1 or dbfh13=1 then dbfh=1; else dbfh=0;
            */

            keep id /*cafh dbfh cvdfh*/
                 cafh89 cafh93 cafh97 cafh01 cafh05 cafh09 cafh13 
                 cvdfh89 cvdfh93 cvdfh97 cvdfh01 cvdfh05 cvdfh09 cvdfh13
                 dbfh89 dbfh97 dbfh01 dbfh05 dbfh09 dbfh13 ;

         run;
      proc sort; by id; run;

      PROC DATASETS;
      delete nur89 nur93 nur97 nur01 nur05 nur09 nur13 ;
      RUN;


* ------ EXPOSURES & Oth COVARIATES ------ *;

      %der8919 (keep=birthday height89 bmi18 race8905 mrace8905 eth8905 height agessmk
                     retmo89  retmo91   retmo93  retmo95  retmo97  retmo99  retmo01  retmo03  retmo05   retmo07   retmo09  retmo11  retmo13  retmo15  retmo17  retmo19
                     age89    age91     age93    age95    age97    age99    age01    age03    age05     age07     age09    age11    age13    age15    age17    age19
                     smkdr89  smkdr91   smkdr93  smkdr95  smkdr97  smkdr99  smkdr01  smkdr03  smkdr05   smkdr07   smkdr09  smkdr11  smkdr13  smkdr15  smkdr17  smkdr19
                     msqui89  msqui91   msqui93  msqui95  msqui97  msqui99  msqui01  msqui03  msqui05   msqui07   msqui09  msqui11  msqui13  msqui15  msqui17  msqui19
                     pkyr89   pkyr91    pkyr93   pkyr95   pkyr97   pkyr99   pkyr01   pkyr03   pkyr05    pkyr07    pkyr09   pkyr11   pkyr13   pkyr15   pkyr17   pkyr19
                     bmi89    bmi91     bmi93    bmi95    bmi97    bmi99    bmi01    bmi03    bmi05     bmi07     bmi09    bmi11    bmi13    bmi15    bmi17    bmi19
                     can89    can91     can93    can95    can97    can99    can01    can03    can05     can07     can09    can11    can13    can15    can17    can19
                     
                     nhor89   nhor91    nhor93   nhor95   nhor97   nhor99   nhor01   nhor03   nhor05    nhor07    nhor09   nhor11   nhor13   nhor15   nhor17   nhor19
                     namnp89  namnp91   namnp93  namnp95  namnp97  namnp99  namnp01  namnp03  namnp05   namnp07   namnp09  namnp11  namnp13  namnp15  namnp17  namnp19
                     mnpst89  mnpst91   mnpst93  mnpst95  mnpst97  mnpst99  mnpst01  mnpst03  mnpst05   mnpst07   mnpst09  mnpst11  mnpst13  mnpst15  mnpst17  mnpst19
                     mnty89   mnty91    mnty93   mnty95   mnty97   mnty99   mnty01   mnty03   mnty05    mnty07    mnty09   mnty11   mnty13   mnty15   mnty17   mnty19
                     gravid89 gravid91  gravid93 gravid95 gravid97 gravid99 gravid01 gravid03 gravid05  gravid07  gravid09
                     npar89   npar91    npar93   npar95   npar97   npar99   npar01   npar03   npar05    npar07    npar09 
                     bbd89    bbd91     bbd93    bbd95    bbd97    bbd99    bbd01    bbd03    bbd05     bbd07     bbd09    bbd11    bbd13    bbd15    bbd17    bbd19);

                     height=height89*2.54;
                     if height=. then height=164.7687280; /*mean*/
                     if agessmk=99 then agessmk=.;
                    
                     run;
         
           %nur89(keep=wt89 wt1889 mi89 db89 dbg89 hbp89 str89 chol89 mar89 marital89
                       pct589 pct1089 pct2089 /*bodyshape at ages 5, 10, 20 years*/);
                       if mar89=2 then marital89=1; else marital89=0;  /*mar89=2 married*/
                       if wt89 = 0 then wt89=.;
                       if wt1889=0 then wt1889=.;
                       if wt1889=. then wt1889=125;
                  run;
                      
           %nur91(keep=wt91 sittv91 mi91 db91 dbg91 hbp91 str91 chol91             
                       cpreg91/*current pregant*/
                       preg91 /*Pregnant Since 9/89 (L5 S5)*/);
                       if wt91 = 0 then wt91=.;
                  run;

           %nur93(keep=wt93 mi93 db93 dbg93 hbp93 str93 ang93 chol93 cpreg93 preg93      
                       marry93 div93 widow93 nvmar93 q37pt93
                       alone93 husb93 ofam93 othlv93 q38pt93
                       waist93 hip93 marry93);
                       if wt95 = 0 then wt95=.;
                  run;
        
           %nur95(keep=wt95 mi95 db95 dbg95 hbp95 str95 ang95 chol95 cabg95              
                       cpreg95 preg95); 
                       if wt95 = 0 then wt95=.;
                  run;
         
           %nur97(keep=wt97 sittv97 mi97 db97 hbp97 str97 chol97
                       cpreg97 preg97);
                       if wt97 = 0 then wt97=.;
                  run;

           %nur99(keep=wt99 mi99 db99 hbp99 str99 ang99 chol99 cabg99 
                       cpreg99 preg99);
                       if wt99 = 0 then wt99=.;
                  run;
         
           %nur01(keep=wt01 sittv01 sleep01 mi01 db01 hbp01 str01 ang01 chol01 cabg01        
                       depre01 depdr01 
                       marry01 divor01 widow01 nvmar01 separ01 q27pt01
                       alone01 husb01 afam01 othlv01 mchld01 q28pt01
                       cpreg01 preg01); 
                       if wt01 = 0 then wt01=.;
                  run;
                       
           %nur03(keep=wt03 mi03 db03 hbp03 str03 ang03 chol03 cabg03
                       depr03 deprd03 depre03 cpreg03 preg03); 
                       if wt03 = 0 then wt03=.;
                  run;

           %nur05(keep=wt05 sittv05 mi05 db05 hbp05 str05 ang05 chol05 cabg05 
                       marry05 divor05 widow05 nvrmr05 separ05 dompa05 q23pt05
                       alone05 husb05 ofam05 othlv05 mchld05 q24pt05
                       depr05 deprd05  depre05 waist05 hip05  
                       bus05 indrs05 space05 incur05 htsc05 panic05 worry05 out05 cpreg05 preg05);
                       if wt05 = 0 then wt05=.;
                  run;

           %nur07(keep=wt07 mi07 db07 hbp07 str07 ang07 chol07 cabg07 
                       depr07 deprd07 depre07 mnp07 cpreg07 preg07);
                       if wt07 = 0 then wt07=.;       
                  run;

           %nur09(keep=wt09 mi09 db09 hbp09 str09 ang09 chol09 cabg09     
                       marry09 divor09 widow09 nvrmr09 separ09 dompa09 
                       alone09 husb09 ofam09 othlv09 mchld09 
                       depr09 deprd09 depre09 mnp09 preg09 sittv09 cpreg09);
                       if wt09 = 0 then wt09=.;       
                  run;    

           %nur11(keep=wt11 mi11 db11 hbp11 str11 ang11 chol11 cabg11);
                       if wt11 = 0 then wt11=.;      
                  run;

           %nur13(keep=wt13 sittv13 mi13 db13 hbp13 str13 ang13 chol13 cabg13);
                       if wt13 = 0 then wt13=.;
                  run;

           %nur15(keep=wt15 mi15 db15 hbp15 str15 ang15 chol15 cabg15);
                       if wt15 = 0 then wt15=.;
                  run;

           %nur17(keep=wt17 mi17 db17 hbp17 str17 ang17 chol17 cabg17);
                       if wt17 = 0 then wt17=.;
                  run;

           %nur19(keep=wt19 mi19 db19 hbp19 str19 ang19 chol19 cabg19);
                       if wt19 = 0 then wt19=.;
                  run;

           %supp8919(keep=mvitu89 mvitu91 mvitu93 mvitu95 mvitu97 mvitu99 mvitu01 mvitu03 mvitu05 mvitu07 mvitu09 mvitu11 mvitu13 mvitu15 mvitu17 mvitu19
			   mvyn89 mvyn91 mvyn93 mvyn95 mvyn97 mvyn99 mvyn01 mvyn03 mvyn05 mvyn07 mvyn09 mvyn11 mvyn13 mvyn15 mvyn17 mvyn19);
	           
                    array mvitu{*} mvitu89 mvitu91 mvitu93 mvitu95 mvitu97 mvitu99 mvitu01 mvitu03 mvitu05 mvitu07 mvitu09 mvitu11 mvitu13 mvitu15 mvitu17 mvitu19;
	           array mvyn{*} mvyn89 mvyn91 mvyn93 mvyn95 mvyn97 mvyn99 mvyn01 mvyn03 mvyn05 mvyn07 mvyn09 mvyn11 mvyn13 mvyn15 mvyn17 mvyn19;
	           do i=2 to dim(mvitu); if mvitu{i} in (.,9) and mvitu{i-1} in (1,0) then mvitu{i}=mvitu{i-1}; end;
	           do i=1 to dim(mvitu); if mvitu{i}=1 then mvyn{i}=1; else mvyn{i}=0; end;
                    run;
                         /* Label multivitamin use   $label 0.nonuser;\   1.current user;\   9.unknown status */

           %meds8919(keep=aspu89 aspu91 aspu93 aspu95 aspu97 aspu99 aspu01 aspu03 aspu05 aspu07 aspu09 aspu11 aspu13 aspu15 aspu17 aspu19);
                         /* Label aspirin use   $label 0.nonuser;\   1.current user;\   9.unknown status */

           %oc8911(keep=nocu89 nocu91 nocu93 nocu95 nocu97 nocu99 nocu01 nocu03 nocu05 nocu07 nocu09 nocu11);
                         /*  label 1.current oc user;\  2.past oc user;\  3.never oc user;\  4.missing oc status */


           %act8917(keep = id act89m act91m act97m act01m act05m act09m act13m act17m);

                 array actm{*} act89m   act91m   act97m   act01m   act05m   act09m   act13m   act17m;
                 do i=1 to 8;
                 if actm{i}>=997 then actm{i}=.;
                 end; drop i;
                 do i=2 to 8;
	        if actm{i}=. then actm{i}=actm{i-1}; 		
                 end; drop i;
           run;


* ------ nutrient ------ *;

          %n91_nts(keep=alco91n calor91n);
          %n95_nts(keep=alco95n calor95n);
          %n99_nts(keep=alco99n calor99n);
          %n03_nts(keep=alco03n calor03n);
          %n07_nts(keep=alco07n calor07n);
          %n11_nts(keep=alco11n calor11n);
          %n15_nts(keep=alco15n calor15n);
          %n19_nts(keep=alco19n calor19n);

          %ahei2010_9119(keep=ahei2010_noETOH91 ahei2010_noETOH95 ahei2010_noETOH95 ahei2010_noETOH99 
                              ahei2010_noETOH03 ahei2010_noETOH07 ahei2010_noETOH11 ahei2010_noETOH15 ahei2010_noETOH15
                              ahei2010_91 ahei2010_95 ahei2010_99 ahei2010_03 ahei2010_07 ahei2010_11 ahei2010_15 ahei2010_19);


         *******************************************
         *           Merge    Datasets             *
         *******************************************;

         data base;         
              merge der8919(in=mst) nhs2_outcome
                    nur89 nur91 nur93 nur95 nur97 nur99 nur01 nur03 nur05 nur07 nur09 nur11 nur13 nur15 nur17 nur19
                    familyhis act8917 supp8919 meds8919 oc8911 nhs2_asp ahei2010_9119
                    n91_nts n95_nts n99_nts n03_nts n07_nts n11_nts n15_nts n19_nts
                    end=_end_;
              by id;  
              exrec=1;
              if first.id and mst then exrec=0; 
                
                /* RACE */
                if race8905=1 then white=1; else white=0;
	       if race8905=. then white=.;

             /** check **/
	    array irt     {*} retmo89  retmo91  retmo93  retmo95  retmo97  retmo99  retmo01  retmo03  retmo05  retmo07  retmo09  retmo11  retmo13  retmo15  retmo17  retmo19;
             array anoirt  {*} noirt88  noirt90  noirt92  noirt94  noirt96  noirt98  noirt00  noirt02  noirt04  noirt06  noirt08  noirt10  noirt12  noirt14  noirt16  noirt18;

             do i=1 to DIM(irt);
             if irt{i}=. | irt{i}=0 then anoirt{i}=1;
             end; drop i;


             /* AGE */
             array age {*}  age89  age91  age93  age95  age97  age99  age01  age03  age05  age07  age09  age11  age13  age15  age17  age19;
              
             do i=1 to DIM(age);  
             if age{i} le 0 then age{i}=.; 
             end; drop i; 
             do i=2 to DIM(age);
             if age{i}=. then age{i}=age{i-1}+2;
             end; drop i;

             /* PHYSICAL ACTIVITY */
             act89v=act89m; 
             act91v=mean(act89m, act91m);
             act97v=mean(act89m, act91m, act97m);
             act01v=mean(act89m, act91m, act97m, act01m);
             act05v=mean(act89m, act91m, act97m, act01m, act05m);
             act09v=mean(act89m, act91m, act97m, act01m, act05m, act09m);
             act13v=mean(act89m, act91m, act97m, act01m, act05m, act09m, act13m);
             act17v=mean(act89m, act91m, act97m, act01m, act05m, act09m, act13m, act17m);
             
             act89s=sum(act89m); 
             act91s=sum(act89m, act91m);
             act93s=sum(act89m, act91m, act91m);
             act95s=sum(act89m, act91m, act91m, act91m);
             act97s=sum(act89m, act91m, act91m, act91m, act97m);
             act99s=sum(act89m, act91m, act91m, act91m, act97m, act97m);
             act01s=sum(act89m, act91m, act91m, act91m, act97m, act97m, act01m);
             act03s=sum(act89m, act91m, act91m, act91m, act97m, act97m, act01m, act01m);
             act05s=sum(act89m, act91m, act91m, act91m, act97m, act97m, act01m, act01m, act05m);
             act07s=sum(act89m, act91m, act91m, act91m, act97m, act97m, act01m, act01m, act05m, act05m);
             act09s=sum(act89m, act91m, act91m, act91m, act97m, act97m, act01m, act01m, act05m, act05m, act09m);
             act11s=sum(act89m, act91m, act91m, act91m, act97m, act97m, act01m, act01m, act05m, act05m, act09m, act09m);
             act13s=sum(act89m, act91m, act91m, act91m, act97m, act97m, act01m, act01m, act05m, act05m, act09m, act09m, act13m);
             act15s=sum(act89m, act91m, act91m, act91m, act97m, act97m, act01m, act01m, act05m, act05m, act09m, act09m, act13m, act13m);
             act17s=sum(act89m, act91m, act91m, act91m, act97m, act97m, act01m, act01m, act05m, act05m, act09m, act09m, act13m, act13m, act17m);
             act19s=sum(act89m, act91m, act91m, act91m, act97m, act97m, act01m, act01m, act05m, act05m, act09m, act09m, act13m, act13m, act17m, act17m);

             array act{*}      act89m act91m act97m act01m act05m act09m act13m act17m;
             array actbin{*}   att89  att91  att97  att01  att05  att09  att13  att17; 

             do i=1 to dim(act);
             /* whether satisfy the recommended level */
             if act{i}>=7.5 then actbin{i}=1; else actbin{i}=0;
             end; drop i; 
 
             /* cumulative duration of maintaining the recommended level */
             sust89=sum(att89); 
             sust91=sum(att89, att91);
             sust93=sum(att89, att91, att91);
             sust95=sum(att89, att91, att91, att91);
             sust97=sum(att89, att91, att91, att91, att97);
             sust99=sum(att89, att91, att91, att91, att97, att97);
             sust01=sum(att89, att91, att91, att91, att97, att97, att01);
             sust03=sum(att89, att91, att91, att91, att97, att97, att01, att01);
             sust05=sum(att89, att91, att91, att91, att97, att97, att01, att01, att05);
             sust07=sum(att89, att91, att91, att91, att97, att97, att01, att01, att05, att05);
             sust09=sum(att89, att91, att91, att91, att97, att97, att01, att01, att05, att05, att09);
             sust11=sum(att89, att91, att91, att91, att97, att97, att01, att01, att05, att05, att09, att09);
             sust13=sum(att89, att91, att91, att91, att97, att97, att01, att01, att05, att05, att09, att09, att13);
             sust15=sum(att89, att91, att91, att91, att97, att97, att01, att01, att05, att05, att09, att09, att13, att13);
             sust17=sum(att89, att91, att91, att91, att97, att97, att01, att01, att05, att05, att09, att09, att13, att13, att17);
             sust19=sum(att89, att91, att91, att91, att97, att97, att01, att01, att05, att05, att09, att09, att13, att13, att17, att17);
    
             /* percentage of years satisfying the recommended level */
             psust89=sum(att89); 
             psust91=round(sum(att89, att91)/2, 0.01);
             psust93=round(sum(att89, att91, att91)/3, 0.01);
             psust95=round(sum(att89, att91, att91, att91)/4, 0.01);
             psust97=round(sum(att89, att91, att91, att91, att97)/5, 0.01);
             psust99=round(sum(att89, att91, att91, att91, att97, att97)/6, 0.01);
             psust01=round(sum(att89, att91, att91, att91, att97, att97, att01)/7, 0.01);
             psust03=round(sum(att89, att91, att91, att91, att97, att97, att01, att01)/8, 0.01);
             psust05=round(sum(att89, att91, att91, att91, att97, att97, att01, att01, att05)/9, 0.01);
             psust07=round(sum(att89, att91, att91, att91, att97, att97, att01, att01, att05, att05)/10, 0.01);
             psust09=round(sum(att89, att91, att91, att91, att97, att97, att01, att01, att05, att05, att09)/11, 0.01);
             psust11=round(sum(att89, att91, att91, att91, att97, att97, att01, att01, att05, att05, att09, att09)/12, 0.01);
             psust13=round(sum(att89, att91, att91, att91, att97, att97, att01, att01, att05, att05, att09, att09, att13)/13, 0.01);
             psust15=round(sum(att89, att91, att91, att91, att97, att97, att01, att01, att05, att05, att09, att09, att13, att13)/14, 0.01);
             psust17=round(sum(att89, att91, att91, att91, att97, att97, att01, att01, att05, att05, att09, att09, att13, att13, att17)/15, 0.01);
             psust19=round(sum(att89, att91, att91, att91, att97, att97, att01, att01, att05, att05, att09, att09, att13, att13, att17, att17)/16, 0.01);

             /* BMI */
             array bmi  {*}  bmi89  bmi91  bmi93  bmi95  bmi97  bmi99  bmi01  bmi03  bmi05  bmi07  bmi09  bmi11  bmi13  bmi15  bmi17  bmi19;
               
             do i=1 to dim(bmi);
             if bmi{i}<=10 then bmi{i}=.;
             end; drop i;
             do i=2 to dim(bmi); 
             if bmi{i}=. then bmi{i}=bmi{i-1};
             end; drop i;
      
             bmi89v=bmi89;
             bmi91v=mean(bmi89, bmi91);
             bmi93v=mean(bmi89, bmi91, bmi93);
             bmi95v=mean(bmi89, bmi91, bmi93, bmi95);
             bmi97v=mean(bmi89, bmi91, bmi93, bmi95, bmi97);
             bmi99v=mean(bmi89, bmi91, bmi93, bmi95, bmi97, bmi99);
             bmi01v=mean(bmi89, bmi91, bmi93, bmi95, bmi97, bmi99, bmi01);
             bmi03v=mean(bmi89, bmi91, bmi93, bmi95, bmi97, bmi99, bmi01, bmi03);
             bmi05v=mean(bmi89, bmi91, bmi93, bmi95, bmi97, bmi99, bmi01, bmi03, bmi05);
             bmi07v=mean(bmi89, bmi91, bmi93, bmi95, bmi97, bmi99, bmi01, bmi03, bmi05, bmi07);
             bmi09v=mean(bmi89, bmi91, bmi93, bmi95, bmi97, bmi99, bmi01, bmi03, bmi05, bmi07, bmi09);
             bmi11v=mean(bmi89, bmi91, bmi93, bmi95, bmi97, bmi99, bmi01, bmi03, bmi05, bmi07, bmi09, bmi11);
             bmi13v=mean(bmi89, bmi91, bmi93, bmi95, bmi97, bmi99, bmi01, bmi03, bmi05, bmi07, bmi09, bmi11, bmi13);
             bmi15v=mean(bmi89, bmi91, bmi93, bmi95, bmi97, bmi99, bmi01, bmi03, bmi05, bmi07, bmi09, bmi11, bmi13, bmi15);
             bmi17v=mean(bmi89, bmi91, bmi93, bmi95, bmi97, bmi99, bmi01, bmi03, bmi05, bmi07, bmi09, bmi11, bmi13, bmi15, bmi17);
             bmi19v=mean(bmi89, bmi91, bmi93, bmi95, bmi97, bmi99, bmi01, bmi03, bmi05, bmi07, bmi09, bmi11, bmi13, bmi15, bmi17, bmi19);

             basebmi=bmi89;

             /* ALCOHOL */
             array alcon {*}  alco91n   alco95n   alco99n   alco03n   alco07n   alco11n   alco15n   alco19n;     
             
             do i=2 to dim(alcon); 
             if alcon{i}=. then alcon{i}=alcon{i-1};
             end; drop i;

             alco91nv=alco91n;
             alco95nv=mean(alco91n,alco95n);
             alco99nv=mean(alco91n,alco95n,alco99n);
             alco03nv=mean(alco91n,alco95n,alco99n,alco03n);
             alco07nv=mean(alco91n,alco95n,alco99n,alco03n,alco07n);
             alco11nv=mean(alco91n,alco95n,alco99n,alco03n,alco07n,alco11n);
             alco15nv=mean(alco91n,alco95n,alco99n,alco03n,alco07n,alco11n,alco15n); 
             alco19nv=mean(alco91n,alco95n,alco99n,alco03n,alco07n,alco11n,alco15n,alco19n); 

             /* AHEI */
             array ahei    {*} ahei2010_91   ahei2010_95   ahei2010_99   ahei2010_03   ahei2010_07   ahei2010_11   ahei2010_15   ahei2010_19;  

             do i=2 to dim(ahei); 
             if ahei{i}=. then ahei{i}=ahei{i-1};
             end; drop i;

             ahei91v=ahei2010_91;
             ahei95v=mean(ahei2010_91,ahei2010_95);
             ahei99v=mean(ahei2010_91,ahei2010_95,ahei2010_99);
             ahei03v=mean(ahei2010_91,ahei2010_95,ahei2010_99,ahei2010_03);
             ahei07v=mean(ahei2010_91,ahei2010_95,ahei2010_99,ahei2010_03,ahei2010_07);
             ahei11v=mean(ahei2010_91,ahei2010_95,ahei2010_99,ahei2010_03,ahei2010_07,ahei2010_11);
             ahei15v=mean(ahei2010_91,ahei2010_95,ahei2010_99,ahei2010_03,ahei2010_07,ahei2010_11,ahei2010_15);
             ahei19v=mean(ahei2010_91,ahei2010_95,ahei2010_99,ahei2010_03,ahei2010_07,ahei2010_11,ahei2010_15,ahei2010_19);
           
             /* ASPIRIN or NSAIDS */ 
	    /* We did not incorporate %meds8915 or %med8016 
	    because we want to adjust for regular aspirin use as defined in prior studies. 
	    Briefly, the regular aspirin user was defined by participants who take at least 2 tables of aspirin (325 mg/tablet) per week in the NHS and at least 2 times per week in the HPFS and NHSII. 
	    Regular NSAIDs users are defined as participants who take at least 2 times per week. 
             1=non regular user, 2=regular user; */

             array regaspa {*} regaspre89 regaspre93 regaspre95 regaspre97 regaspre99 regaspre01 regaspre03 regaspre05 regaspre07 regaspre09 regaspre11 regaspre13 regaspre15 regaspre17;
             array regibuia{*} regibui89 regibui93 regibui95 regibui97 regibui99 regibui01 regibui03 regibui05 regibui07 regibui09 regibui11 regibui13 regibui15 regibui17;
 
	    do i=1 to dim(regaspa);
		if i>1 then do;
			if regaspa{i}=. and regaspa{i-1} ne . then regaspa{i}=regaspa{i-1};
			if regibuia{i}=. and regibuia{i-1} ne . then regibuia{i}=regibuia{i-1};
		end;
	    end;

             /* SMOKING */    
             array pkyr   {*} pkyr89  pkyr91  pkyr93  pkyr95  pkyr97  pkyr99  pkyr01  pkyr03  pkyr05  pkyr07  pkyr09  pkyr11  pkyr13  pkyr15  pkyr17  pkyr19; 
             array smkdr  {*} smkdr89 smkdr91 smkdr93 smkdr95 smkdr97 smkdr99 smkdr01 smkdr03 smkdr05 smkdr07 smkdr09 smkdr11 smkdr13 smkdr15 smkdr17 smkdr19;
             array smks   {*} smoke89 smoke91 smoke93 smoke95 smoke97 smoke99 smoke01 smoke03 smoke05 smoke07 smoke09 smoke11 smoke13 smoke15 smoke17 smoke19;   

             do i=1 to dim(pkyr);
             if pkyr{i}=998 then pkyr{i}=0;
             if pkyr{i}>998 then pkyr{i}=.;

             if smkdr{i}=1           then smks{i}=1; * never;
             else if 2<=smkdr{i}<=8  then smks{i}=2; * former;
             else if 9<=smkdr{i}<=15 then smks{i}=3; * current;
             else smks{i}=.;

             if i>1 then do;
		if smks{i}=. & smks{i-1}^=. then smks{i}=smks{i-1};
		if pkyr{i}=. & pkyr{i-1}^=. then pkyr{i}=pkyr{i-1};
             end;

             end; drop i;

             /* MENOPAUSE & HORMONE USE */
             /* mnpst	menopausal status
	          $label 1.pre;
	                 2.post; 
	                 3.dubious;
	                 4.unsure;
	                 5.missing 

                nhor      NEW PMH USE
                   $label 1.Pre/Missing Mnp;
                          2.Never Used;
                          3.Current User;
                          4.Past User;
                          5.Status Uknown;
                          6.Missing */

            array dmnpa{*} mnpst89 mnpst91 mnpst93 mnpst95 mnpst97 mnpst99 mnpst01 mnpst03 mnpst05 mnpst07 mnpst09 mnpst11 mnpst13 mnpst15 mnpst17 mnpst19; 
            array nhora{*} nhor89 nhor91 nhor93 nhor95 nhor97 nhor99 nhor01 nhor03 nhor05 nhor07 nhor09 nhor11 nhor13 nhor15 nhor17 nhor19; 
            array menopa{*} menop89 menop91 menop93 menop95 menop97 menop99 menop01 menop03 menop05 menop07 menop09 menop11 menop13 menop15 menop17 menop19; 
            array pmha{*} pmh89 pmh91 pmh93 pmh95 pmh97 pmh99 pmh01 pmh03 pmh05 pmh07 pmh09 pmh11 pmh13 pmh15 pmh17 pmh19; 

	   do i=1 to dim(dmnpa);
		if i>1 then do; if dmnpa{i-1}=2 then dmnpa{i}=2; end;
		if dmnpa{i} in (1,2) then menopa{i}=dmnpa{i}; else menopa{i}=1;
		if dmnpa{i} in (3,4,5,.) then do;
			if age{i}<46 and smks{i}=3 then menopa{i}=1;
			else if age{i}<48 and smks{i} in (1,2) then menopa{i}=1;
			else if age{i}>54 and smks{i}=3 then menopa{i}=2;
			else if age{i}>56 and smks{i} in (1,2) then menopa{i}=2;
		end;
	   end;
	
	   do i=1 to dim(dmnpa);
		if menopa{i}=1 then pmha{i}=1; * pre or missing ;
		else if menopa{i}=2 and nhora{i}=2 then pmha{i}=2; * post never ;
		else if menopa{i}=2 and nhora{i}=4 then pmha{i}=3; * post former ;
		else if menopa{i}=2 and nhora{i}=3 then pmha{i}=4; * post current ;
		if i>1 then do;
			if pmha{i}=. and pmha{i-1} ne . then pmha{i}=pmha{i-1};
		end;
	   end;

            /** check **/
            do i=1 to dim(dmnpa);
		if menopa{i}=2 then menopa{i}=1; else menopa{i}=0; * post menopausal;
	         if nhora{i}=3 or nhora{i}=4 then nhora{i}=1; else nhora{i}=0; * pmh use;
            end;

            /* CHRONIC DISEASE */ 
            array repmi   {*}    mi89           mi91          mi93          mi95          mi97          mi99           mi01          mi03          mi05          mi07           mi09           mi11          mi13         mi15        mi17       mi19  ;
            array repstrk {*}    str89          str91         str93         str95         str97         str99          str01         str03         str05         str07          str09          str11         str13        str15       str17      str19   ;
            array diab    {*}    db89           db91          db93          db95          db97          db99           db01          db03          db05          db07           db09           db11          db13         db15        db17       db19   ;
            array canc    {*}    can89          can91         can93         can95         can97         can99          can01         can03         can05         can07          can09          can11         can13        can15       can17      can19  ;
            array chol    {*}    chol89         chol91        chol93        chol95        chol97        chol99         chol01        chol03        chol05        chol07         chol09         chol11        chol13       chol15      chol17     chol19 ;
            array hbp     {*}    hbp89          hbp91         hbp93         hbp95         hbp97         hbp99          hbp01         hbp03         hbp05         hbp07          hbp09          hbp11         hbp13        hbp15       hbp17      hbp19  ; 

            do i= 2 to DIM(repmi);     if repmi(i-1)=1       then repmi(i)=1;     end;   drop i;
            do i= 2 to DIM(repstrk);   if repstrk(i-1)=1     then repstrk(i)=1;   end;   drop i;
            do i= 2 to DIM(diab);      if diab(i-1)=1        then diab(i)=1;      end;   drop i;
            do i= 2 to DIM(canc);      if canc(i-1)=1        then canc(i)=1;      end;   drop i;
            do i= 2 to DIM(chol);      if chol(i-1)=1        then chol(i)=1;      end;   drop i;
            do i= 2 to DIM(hbp);       if hbp(i-1)=1         then hbp(i)=1;       end;   drop i;

            /* FAMILY HISTORY */
            array fhxcanc  {*}    cafh89   cafh93   cafh97   cafh01   cafh05   cafh09   cafh13   ;
            array fhxcvd   {*}    cvdfh89  cvdfh93  cvdfh97  cvdfh01  cvdfh05  cvdfh09  cvdfh13  ;
            array fhxdb    {*}    dbfh89   dbfh97   dbfh05   dbfh09   dbfh13  ;

            do i= 1 to DIM(fhxcanc);    
              if i>1 then do; if fhxcanc(i-1)=1  then fhxcanc(i)=1; end;
              *if fhxcanc(i)=. then fhxcanc(i)=0;
            end;
            do i= 1 to DIM(fhxcvd);    
              if i>1 then do; if fhxcvd(i-1)=1   then fhxcvd(i)=1; end;
              *if fhxcvd(i)=. then fhxcvd(i)=0;
            end;
            do i= 1 to DIM(fhxdb);      
              if i>1 then do; if fhxdb(i-1)=1    then fhxdb(i)=1; end;
              *if fhxdb(i)=. then fhxdb(i)=0;
            end;

            /** check **/
            if cafh89=1 or cafh93=1 or cafh97=1 or cafh01=1 or cafh05=1 or cafh09=1 or cafh13=1 then cafh=1; else cafh=0;
            if dbfh89=1 or dbfh97=1 or dbfh05=1 or dbfh09=1 or dbfh13=1 then dbfh=1; else dbfh=0;
            if cvdfh89=1 or cvdfh93=1 or cvdfh97=1 or cvdfh01=1 or cvdfh05=1 or cvdfh09=1 or cvdfh13=1 then cvdfh=1; else cvdfh=0;
           
run;
    
     proc datasets nolist;
              delete 
                     der8919 nhs2_outcome act8917 familyhis supp8919 meds8919 oc8911 nhs2_asp
		   nur89 nur91 nur93 nur95 nur97 nur99 nur01 nur03 nur05 nur07 nur09 nur11 nur13 nur15 nur17 nur19 
                     n91_nts n95_nts n99_nts n03_nts n07_nts n11_nts n15_nts n19_nts
                     ;
              run;
 
/*
proc means n nmiss mean min max;
run;
*/
