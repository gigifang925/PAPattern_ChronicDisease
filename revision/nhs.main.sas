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

         options linesize=130 pagesize=80;
         filename nhstools '/proj/nhsass/nhsas00/nhstools/sasautos/'; 
         filename local '/usr/local/channing/sasautos/';
         filename ehmac '/udd/stleh/ehmac/';
         libname library '/proj/nhsass/nhsas00/formats/';
         options mautosource sasautos=(local nhstools);          *** path to macros  ***;
         options fmtsearch=(library);                            *** path to formats ***;


*call in outcome;
%include '/udd/hpzfa/review/PA/revision/nhs.outcome.sas';

*call in derived aspirin and nsaids;
%include '/udd/hpzfa/review/PA/revision/asp_nhs.sas';
proc sort nodupkey data=nhs_asp;by id;run;


* ------ FAMILY HISTORY ------ *;
    %n767880(keep=mbrcn76 nsbrc76 mmi76 fmi76 cvdfh76 cafh76);      
             if mbrcn76=1 or nsbrc76>0 then cafh76=1; else cafh76=0;
             if mmi76=1 or fmi76=1 then cvdfh76=1; else cvdfh76=0;
             run;

    %nur82(keep=mclc82 fclc82 sclc82 bclc82 mbrcn82 sbrcn82 mmel82 fmel82 smel82 cafh82 mdb82 fdb82 sdb82 bdb82 dbfh82);
           cafh82=0; if mclc82=1 or fclc82=1 or sclc82=1 or bclc82=1 or mbrcn82=1 or sbrcn82=1 or mmel82=1 or fmel82=1 or smel82=1 then cafh82=1; 
           if mdb82=1 or fdb82=1 or sdb82=1 or bdb82=1 then dbfh82=1; else dbfh82=0;
           run;

    %nur84(keep=fmi84 mmi84 cvdfh84);
           if fmi84=2 or mmi84=2 then cvdfh84=1; else cvdfh84=0;
           run;

    %nur88(keep=mclc88 fclc88 sclc88 bclc88 mbrcn88 sbrcn88 mcanc88 fcanc88 cafh88 mdb88 fdb88 bdb88 sdb88 dbfh88);
           cafh88=0; if mclc88=1 or fclc88=1 or sclc88=1 or bclc88=1 or mbrcn88=1 or sbrcn88=1 or mcanc88=1 or fcanc88=1 then cafh88=1;
           if mdb88=1 or fdb88=1 or bdb88=1 or sdb88=1 then dbfh88=1;
           run;
   
    %nur92(keep=mbrcn92 mov92 mcolc92 fcolc92 sbrcn92 sov92 scolc92 mmel92 fmel92 cafh92 fdb92 mdb92 sdb92 dbfh92);
           cafh92=0; if sum(mbrcn92, mov92, mcolc92, fcolc92, sbrcn92, sov92, scolc92, mmel92, fmel92)>0 then cafh92=1;
           if fdb92=1 or mdb92=1 or sdb92=1 then dbfh92=1; else dbfh92=0;
           run;
     
    %nur96(keep=fdcan96 mdcan96 pclc96 sclc196 sclc296 sbrc196 sbrc296 mbrcn96 mov96 sov96 mut96 sut96 fpro96 bpro196 bpro296 ppan96 span96 pmel96 smel96 cafh96 
                fdchd96 fdstr96 mdchd96 mdstr96 cvdfh96);
           cafh96=0; if sum(fdcan96,mdcan96,pclc96,sclc196,sclc296,sbrc196,sbrc296,mbrcn96,mov96,sov96,mut96,sut96,fpro96,bpro196,bpro296,ppan96,span96,pmel96,smel96)>0 then cafh96=1;
           if fdchd96=1 or fdstr96=1 or mdchd96=1 or mdstr96=1 then cvdfh96=1; else cvdfh96=0;
           run;

    %nur00(keep=mbrcn00 sbrc100 sbrc200 pclc00 sclc100 sclc200 plng00 slng00 cafh00);
           if mbrcn00=1 or sbrc100=1 or sbrc200=1 or pclc00=1 or sclc100=1 or sclc200=1 or plng00=1 or slng00=1 then cafh00=1; else cafh00=0;
           run;

    %nur04(keep=pclc04 sclc104 sclc204 mbrcn04 sbrc104 sbrc204 dbrcn04 mov04 sov04 dov04 cafh04);
           cafh04=0; if pclc04=1 or sclc104=1 or sclc204=1 or mbrcn04=1 or sbrc104=1 or sbrc204=1 or mov04=1 or sov04=1 then cafh04=1;
           run;

    %nur08(keep=sclc108 sclc208 sbrc108 sbrc208 dbrcn08 mov08 sov08 dov08 ppan08 span08 pmel08 smel08 omel08 mut08 sut08 out08 pkdc08 skidc08 cafh08 
                mstr08 fstr08 sstr08 cvdfh08);
           cafh08=0; if sclc108=1 or sclc208=1 or sbrc108=1 or sbrc208=1 or mov08=1 or sov08=1 or ppan08=1 or span08=1 or pmel08=1 or smel08=1 or omel08=1 or mut08=1 or sut08=1 or out08=1 or pkdc08=1 or skidc08=1 then cafh08=1;
           if mstr08=1 or fstr08=1 or sstr08=1 then cvdfh08=1; else cvdfh08=0;
           run;
    
    %nur12(keep=sbrcn12 sov12 cafh12);
           cafh12=0; if sbrcn12=1 or sov12=1 then cafh12=1;
           run;

    data familyhis;
      merge n767880 nur82 nur84 nur88 nur92 nur96 nur00 nur04 nur08 nur12;
      by id;
   
      /*
      if cafh76=1 or cafh82=1 or cafh88=1 or cafh92=1 or cafh96=1 or cafh00=1 or cafh04=1 or cafh08=1 or cafh12=1 then cafh=1; else cafh=0;
      cvdfh=0; if cvdfh76=1 or cvdfh84=1 or cvdfh96 or cvdfh08=1 then cvdfh=1;
      dbfh=0; if dbfh82=1 or dbfh88=1 or dbfh92=1 then dbfh=1; 
      */
   
      keep id /*cafh dbfh cvdfh*/
           cafh76 cafh82 cafh88 cafh92 cafh96 cafh00 cafh04 cafh08 cafh12
           cvdfh76 cvdfh96 cvdfh08 dbfh82 dbfh88 dbfh92;
      proc sort; by id; run;
      
    PROC DATASETS;
    delete n767880 nur82 nur84 nur88 nur92 nur96 nur00 nur04 nur08 nur12;
    RUN;
      

* ------ EXPOSURES & Oth COVARIATES ------ *;

    %der7620(keep=mobf yobf race9204 white bmiage18 ageb1
                  irt76    irt78    irt80    irt82    irt84    irt86    irt88    irt90    irt92    irt94 
                  irt96    irt98    irt00    irt02    irt04    irt06    irt08    irt10    irt12    irt14    irt16    irt20
                  age76    age78    age80    age82    age84    age86    age88    age90    age92    age94    
                  age96    age98    age00    age02    age04    age06    age08    age10    age12    age14    age16    age20
                  bmi76    bmi78    bmi80    bmi82    bmi84    bmi86    bmi88    bmi90    bmi92    bmi94   
                  bmi96    bmi98    bmi00    bmi02    bmi04    bmi06    bmi08    bmi10    bmi12    bmi14    bmi16    bmi20
                  smkdr76  smkdr78  smkdr80  smkdr82  smkdr84  smkdr86  smkdr88  smkdr90  smkdr92  smkdr94   
                  smkdr96  smkdr98  smkdr00  smkdr02  smkdr04  smkdr06  smkdr08  smkdr10  smkdr12  smkdr14  smkdr16  smkdr20
                  msqui76  msqui78  msqui80  msqui82  msqui84  msqui86  msqui88  msqui90  msqui92  msqui94  
                  msqui96  msqui98  msqui00  msqui02  msqui04  msqui06  msqui08  msqui10  msqui12  msqui14  msqui16  msqui20
                  pkyr76   pkyr78   pkyr80   pkyr82   pkyr84   pkyr86   pkyr88   pkyr90   pkyr92   pkyr94   
                  pkyr96   pkyr98   pkyr00   pkyr02   pkyr04   pkyr06   pkyr08   pkyr10   pkyr12   pkyr14   pkyr16   pkyr20

                  npar76   npar78   npar80   npar82   npar84   npar86   npar88   npar90   npar92   npar94   npar96
                  dmnp76   dmnp78   dmnp80   dmnp82   dmnp84   dmnp86   dmnp88   dmnp90   dmnp92   dmnp94   dmnp96 
                  dmnp98   dmnp00   dmnp02   dmnp04
                  nhor76   nhor78   nhor80   nhor82   nhor84   nhor86   nhor88   nhor90   nhor92   nhor94 
                  nhor96   nhor98   nhor00   nhor02   nhor04   nhor06   nhor08   nhor10   nhor12   nhor14   nhor16   nhor20
                  can76    can78    can80    can82    can84    can86    can88    can90    can92    can94 
                  can96    can98    can00    can02    can04    can06    can08    can10    can12    can14    can16    can20
                  hrt76    hrt78    hrt80    hrt82    hrt84    hrt86    hrt88    hrt90    hrt92    hrt94 
                  hrt96    hrt98    hrt00    hrt02    hrt04    hrt06    hrt08    hrt10    hrt12    hrt14    hrt16    hrt20
                  );                      
                  if ageb1 in (0,98,99) then ageb1=.;
                  if race9204=1 then white=1; else white=0;
                  if race9204=. then white=.; 
                  irt18=1422;
                  run;
                
    %n767880(keep=wt18 asmk menarche mar80 marital80
                  ht76 wt76 wt78 wt80 chol76 chol78 chol80 hbp76 hbp78 hbp80 db76 db78 db80  
                  mi76 mi78 mi80 ang76 ang78 ang80);  
                  if menarche=0 then menarche=.;
                  if asmk=0 then asmk=.;
                  marital80=0; if mar80=1 then marital80=1;
                  run;
                               
    %nur82(keep=wt82 chol82 hbp82 db82 mi82 ang82 str82);
                   
    %nur84(keep=wt84 db84 hbp84 chol84 mi84 ang84 str84 cabg84); 
                   /* all diseases callin from nur84 code 2 as Yes, in order to be consistent with other
                      recode and rename to be the similiar names   
                         $range 0 - 2
                           0 = blank   
                           1 = no     
                           2 = yes   */
                array dis hbp84 db84 chol84 mi84 ang84 str84 cabg84 ;
	       do over dis; if dis in (0,1) then dis=0; else if dis=2 then dis=1; end;
                run;
      
    %nur86(keep=wt86 db86 hbp86 chol86 mi86 ang86 str86 cabg86);
                  
    %nur88(keep=wt88 db88 hbp88 chol88 mi88 ang88 str88 cabg88); 
                                                      
    %nur90(keep=wt90 db90 hbp90 chol90 mi90 ang90 str90 cabg90);
                  
    %nur92(keep=wt92 db92 hbp92 chol92 mi92 ang92 str92 cabg92 marry92 divor92 separ92 widow92 nvrmr92 marital92 husbe92 husbedu
                ra92 alone92 fhbp92 shbp92 mhbp92);  
                marital92=0; if marry92=1 then marital92=1;
	       if husbe92=1 or husbe92=2 or husbe92=3 then husbedu=1; 
	       else if husbe92=4 then husbedu=2;
	       else if husbe92=5 then husbedu=3;
 	       else if husbe92=6 or husbe92=. then husbedu=.;
                run;
                   
    %nur94(keep=wt94 db94 hbp94 chol94 mi94 ang94 str94 cabg94); 
                 
    %nur96(keep=wt96 db96 hbp96 chol96 mi96 ang96 fbbd96 str96 cabg96 marry96 divor96 separ96 widow96 nvrmr96 marital96
                antid96 antidepr96 alone96 physx96 physc96);
                marital96=0; if marry96=1 then marital96=1;
                antidepr96=0; if antid96=1 then antidepr96=1;
                run;
                                                        
    %nur98(keep=wt98 db98 hbp98 chol98 mi98 ang98 fbbd98 str98 cabg98
                antid98 antidepr98 physx98 physc98);   
                antidepr98=0; if antid98=1 then antidepr98=1; 
                run;              

    %nur00(keep=wt00 db00 hbp00 chol00 mi00 ang00 str00 cabg00 marry00 divor00 widow00 separ00 nvmar00 q31pt00 marital00 ladda00 laddb00 ladda laddb
                marry00 alone00 chrx00 chrxd00 przc00 zol00 paxil00 celex00 antid00 antidepr00
                physx00 physc00 deprd00 depr00); 
                marital00=0; if marry00=1 then marital00=1; 
                antidepr00=0; if antid00=1 or przc00=1 or zol00=1 or paxil00=1 or celex00=1 then antidepr00=1;
	       if ladda00=1 or ladda00=2 then ladda=0;
	       else if ladda00=3 or ladda00=4 or ladda00=5 then ladda=1;
                else if ladda00=6 or ladda00=7 or ladda00=8 or ladda00=9 or ladda00=10 then ladda=2;
	       else if ladda00=11 or ladda00=. then ladda=.;
	       if laddb00=1 or laddb00=2 then laddb=0;
	       else if laddb00=3 or laddb00=4 or laddb00=5 then laddb=1;
                else if laddb00=6 or laddb00=7 or laddb00=8 or laddb00=9 or laddb00=10 then laddb=2;
	       else if laddb00=11 or laddb00=. then laddb=.;
                run;
                                                              
    %nur02(keep=wt02 db02 hbp02 chol02 mi02 ang02 str02 cabg02 
                przc02 zol02 paxil02 celex02 antid02 antidepr02
                physx02 physc02 deprd02 deprs02 depr02);    
                antidepr02=0; if antid02=1 or przc02=1 or zol02=1 or paxil02=1 or celex02=1 then antidepr02=1;
                deprs02=0; if deprd02 in (2,3) then deprs02=1; 
                if depr02=. then depr02=0;
                run;
                                                      
    %nur04(keep=wt04 db04 hbp04 chol04 mi04 ang04 str04 cabg04 angd04 cabgd04 
                marry04 divor04 widow04 separ04 nvrmr04 dompa04 q43pt04 marital04
                antid04 antidepr04 ssri04 bprex04 lasix04 thiaz04 ace04 ccblo04 betab04 k04 iron04 antia04
                alone04 physx04 physc04 deprd04 deprs04 depr04);  
                marital04=0; if marry04=1 then marital04=1;
                antidepr04=0; if antid04=1 or ssri04=1 then antidepr04=1;   
                deprs04=0; if deprd04 in (2,3) then deprs04=1; 
                if depr04=. then depr04=0;
                run;
                   
    %nur06(keep=wt06 db06 hbp06 chol06 mi06 ang06 str06 cabg06 
                antid06 antidepr06 ssri06 bprx06 lasix06 thiaz06 ace06 ccblo06 betab06 k06 iron06d antia06
                physx06 physc06 deprd06 deprs06 depr06); 
                antidepr06=0; if antid06=1 or ssri06=1 then antidepr06=1;    
                deprs06=0; if deprd06 in (2,3) then deprs06=1; 
                if depr06=. then depr06=0;  
                run;
                   
    %nur08(keep=wt08 db08 hbp08 chol08 mi08 ang08 str08 cabg08 
                marry08 divor08 widow08 dompa08 separ08 nvmr08 q25pt08 marital08
                alone08 antid08 antidepr08 ssri08 bprx08 lasix08 thiaz08 ace08 ccblo08 betab08 k08 
                physx08 physc08  deprd08 deprs08 depr08);
                marital08=0; if marry08=1 then marital08=1;
                antidepr08=0; if antid08=1 or ssri08=1 then antidepr08=1; 
                deprs08=0; if deprd08 in (2,3) then deprs08=1; 
                if depr08=. then depr08=0;
                run;
                                    
    %nur10(keep=wt10 db10 hbp10 chol10 mi10 ang10 str10 cabg10 
                antid10 antidepr10 ssri10 bprx10 lasix10 thiaz10 ace10 ccblo10 betab10 k10 
                physc10 deprd10 deprs10 depr10);
                antidepr10=0; if antid10=1 or ssri10=1 then antidepr10=1;   
                deprs10=0; if deprd10 in (2,3) then deprs10=1; 
                if depr10=. then depr10=0;      
                run;             
                  
    %nur12(keep=wt12 db12 hbp12 chol12 mi12 ang12 str12 cabg12 
                marry12 divor12 widow12 dompa12 separ12 nvrmr12 stapt12 marital12
                antid12 ssri12 antidepr12 thiaz12 lasix12 k12 ccblo12 betab12 ace12 bprx12 
                physc12 deprd12 deprs12 depr12); 
                marital12=0; if marry12=1 then marital12=1;
                antidepr12=0; if antid12=1 or ssri12=1 then antidepr12=1;
                deprs12=0; if deprd12 in (2,3) then deprs12=1; 
                if depr12=. then depr12=0;  
                run;  
                                      
    %nur14(keep=wt14 asp14 antid14 ssri14 antidepr14
                db14 chol14 hbp14 mi14 ang14 cabg14 str14 deprd14 deprs14 depr14);
                antidepr14=0; if antid14=1 or ssri14=1 then antidepr14=1; 
                deprs14=0; if deprd14 in (2,3) then deprs14=1; 
                if depr14=. then depr14=0; 
                run; 

    %nur16(keep=ang16 mi16 db16 chol16 hbp16 str16 cabg16 marry16 marital16
                antid16 ssri16 antidepr16 marital16 deprd16 deprs16 depr16); 
                marital16=0; if marry16=1 then marital16=1;
                antidepr16=0; if antid16=1 or ssri16=1 then antidepr16=1; 
                deprs16=0; if deprd16 in (2,3) then deprs16=1; 
                if depr16=. then depr16=0;  
                run;

    %nur20(keep=ang20 mi20 db20 chol20 hbp20 str20 cabg20 marry20 marital20
                antida20 antidepr20 marital20 deprd20 deprs20 depr20); 
                marital20=0; if marry20=1 then marital20=1;
                antidepr20=0; if antida20=1 then antidepr20=1; 
                deprs20=0; if deprd20 in (2,3) then deprs20=1; 
                if depr20=. then depr20=0;  
                run;

    %supp8020(keep=mvitu80 mvitu82 mvitu84 mvitu86 mvitu88 mvitu90 mvitu92 mvitu94 mvitu96 mvitu98 mvitu00 mvitu02 mvitu04 mvitu06 mvitu08 mvitu10 mvitu12 mvitu14 mvitu16 mvitu20
		 mvyn80 mvyn82 mvyn84 mvyn86 mvyn88 mvyn90 mvyn92 mvyn94 mvyn96 mvyn98 mvyn00 mvyn02 mvyn04 mvyn06 mvyn08 mvyn10 mvyn12 mvyn14 mvyn16 mvyn20); 
	    
              array mvitu{*} mvitu80 mvitu82 mvitu84 mvitu86 mvitu88 mvitu90 mvitu92 mvitu94 mvitu96 mvitu98 mvitu00 mvitu02 mvitu04 mvitu06 mvitu08 mvitu10 mvitu12 mvitu14 mvitu16 mvitu20;
	     array mvyn{*} mvyn80 mvyn82 mvyn84 mvyn86 mvyn88 mvyn90 mvyn92 mvyn94 mvyn96 mvyn98 mvyn00 mvyn02 mvyn04 mvyn06 mvyn08 mvyn10 mvyn12 mvyn14 mvyn16 mvyn20;
	     do i=2 to dim(mvitu); if mvitu{i} in (.,9) and mvitu{i-1} in (1,0) then mvitu{i}=mvitu{i-1}; end;
	     do i=1 to dim(mvitu); if mvitu{i}=1 then mvyn{i}=1; else mvyn{i}=0; end;
              run;
                     /* Label multivitamin use   $label 0.nonuser;\   1.current user;\   9.unknown status */

    %meds8020(keep=aspu80 aspu82 aspu84 aspu86 aspu88 aspu90 aspu92 aspu94 aspu96 aspu98 aspu00 aspu02 aspu04 aspu06 aspu08 aspu10 aspu12 aspu14 aspu16 aspu20);
                     /* Label aspirin use   $label 0.nonuser;\   1.current user;\   9.unknown status */

    %act8614(keep= id  act86m  act88m  act92m   act94m   act96m   act98m   act00m   act04m   act08m   act12m   act14m);

		array actm [*]  act86m   act88m   act92m   act94m   act96m   act98m   act00m   act04m   act08m   act12m   act14m; 
								
   		do i=1 to 11;												
      		if actm[i]>997 then actm[i]=.; 
                  end; drop i;																								
   		do i=2 to 11;								
      		if actm[i]=. then actm[i]=actm[i-1];	
      		end; drop i;												
    run;


* ------ nutrient ------ *;
    %n80_nts(keep=id alco80n calor80n);
    %n84_nts(keep=id alco84n calor84n);
    %n86_nts(keep=id alco86n calor86n);
    %n90_nts(keep=id alco90n calor90n);
    %n94_nts(keep=id alco94n calor94n);
    %n98_nts(keep=id alco98n calor98n);
    %n02_nts(keep=id alco02n calor02n);
    %n06_nts(keep=id alco06n calor06n);
    %n10_nts(keep=id alco10n calor10n);
    %n20_nts(keep=id alco20n calor20n);
   
    %ahei2010_8420(keep=ahei2010_noETOH84 ahei2010_noETOH86 ahei2010_noETOH90 ahei2010_noETOH94 
                        ahei2010_noETOH98 ahei2010_noETOH02 ahei2010_noETOH06 ahei2010_noETOH10 ahei2010_noETOH20
                        ahei2010_84 ahei2010_86 ahei2010_90 ahei2010_94 ahei2010_98 ahei2010_02 ahei2010_06 ahei2010_10 ahei2010_noETOH20);


    *******************************************
    *           Merge    Datasets             *
    *******************************************;

    data base;
    merge der7620(in=mst) nhs_outcome meds8020 supp8020 act8614 familyhis nhs_asp ahei2010_8420
          n767880 nur82 nur84 nur86 nur88 nur90 nur92 nur94 nur96 nur98 nur00 nur02 nur04 nur06 nur08 nur10 nur12 nur14 nur16 nur20
          n80_nts n84_nts n86_nts n90_nts n94_nts n98_nts n02_nts n06_nts n10_nts n20_nts;
  
     by id;
     exrec=1;
     if first.id and mst then exrec=0; 

            height=ht76*2.54; 
    
            if wt18=0 then wt18=.;   
            if ht76=0 then ht76=.; 
            if wt18=. then wt18=124;
            if ht76>0 and wt18>0 then bmi18=(wt18*0.45359237)/((ht76*25.4/1000)*(ht76*25.4/1000)); 
            if ht76=0 or ht76=. or wt18=. then bmi18=.; 
                   
            if mobf<=0 or mobf>12 then mobf=6;   
               /* birthday in months */   
               bdt=12*yobf+mobf;

      /* AGE */
      array age {*}  age76 age78 age80  age82  age84  age86  age88  age90  age92  age94  age96  age98  age00  age02  age04  age06  age08  age10  age12  age14  age16  age18;
   
      do i=1 to DIM(age);  
      if age{i} le 0 then age{i}=.; 
      end; drop i; 
      do i=2 to DIM(age);
      if age{i}=. then age{i}=age{i-1}+2;
      end; drop i;
    
      /* PHYSICAL ACTIVITY */
      act86v=act86m; 
      act88v=mean(act86m, act88m);
      act92v=mean(act86m, act88m, act92m);
      act94v=mean(act86m, act88m, act92m, act94m);
      act96v=mean(act86m, act88m, act92m, act94m, act96m);
      act98v=mean(act86m, act88m, act92m, act94m, act96m, act98m);
      act00v=mean(act86m, act88m, act92m, act94m, act96m, act98m, act00m);
      act04v=mean(act86m, act88m, act92m, act94m, act96m, act98m, act00m, act04m);
      act08v=mean(act86m, act88m, act92m, act94m, act96m, act98m, act00m, act04m, act08m);
      act12v=mean(act86m, act88m, act92m, act94m, act96m, act98m, act00m, act04m, act08m, act12m);
      act14v=mean(act86m, act88m, act92m, act94m, act96m, act98m, act00m, act04m, act08m, act12m, act14m);
          
      act86s=act86m; 
      act88s=sum(act86m, act88m);
      act90s=sum(act86m, act88m, act88m);
      act92s=sum(act86m, act88m, act88m, act92m);
      act94s=sum(act86m, act88m, act88m, act92m, act94m);
      act96s=sum(act86m, act88m, act88m, act92m, act94m, act96m);
      act98s=sum(act86m, act88m, act88m, act92m, act94m, act96m, act98m);
      act00s=sum(act86m, act88m, act88m, act92m, act94m, act96m, act98m, act00m);
      act02s=sum(act86m, act88m, act88m, act92m, act94m, act96m, act98m, act00m, act00m);
      act04s=sum(act86m, act88m, act88m, act92m, act94m, act96m, act98m, act00m, act00m, act04m);
      act06s=sum(act86m, act88m, act88m, act92m, act94m, act96m, act98m, act00m, act00m, act04m, act04m);
      act08s=sum(act86m, act88m, act88m, act92m, act94m, act96m, act98m, act00m, act00m, act04m, act04m, act08m);
      act10s=sum(act86m, act88m, act88m, act92m, act94m, act96m, act98m, act00m, act00m, act04m, act04m, act08m, act08m);
      act12s=sum(act86m, act88m, act88m, act92m, act94m, act96m, act98m, act00m, act00m, act04m, act04m, act08m, act08m, act12m);
      act14s=sum(act86m, act88m, act88m, act92m, act94m, act96m, act98m, act00m, act00m, act04m, act04m, act08m, act08m, act12m, act14m);
      act16s=sum(act86m, act88m, act88m, act92m, act94m, act96m, act98m, act00m, act00m, act04m, act04m, act08m, act08m, act12m, act14m, act14m);
      act18s=sum(act86m, act88m, act88m, act92m, act94m, act96m, act98m, act00m, act00m, act04m, act04m, act08m, act08m, act12m, act14m, act14m, act14m);

      array act{*}      act86m act88m act92m act94m act96m act98m act00m act04m act08m act12m act14m;
      array actbin{*}   att86  att88  att92  att94  att96  att98  att00  att04  att08  att12  att14; 

      do i=1 to dim(act);
      /* whether satisfy the recommended level */
      if act{i}>=7.5 then actbin{i}=1; else actbin{i}=0;
      end; drop i; 
 
      /* cumulative duration of maintaining the recommended level */
      sust86=att86; 
      sust88=sum(att86, att88);
      sust90=sum(att86, att88, att88);
      sust92=sum(att86, att88, att88, att92);
      sust94=sum(att86, att88, att88, att92, att94);
      sust96=sum(att86, att88, att88, att92, att94, att96);
      sust98=sum(att86, att88, att88, att92, att94, att96, att98);
      sust00=sum(att86, att88, att88, att92, att94, att96, att98, att00);
      sust02=sum(att86, att88, att88, att92, att94, att96, att98, att00, att00);
      sust04=sum(att86, att88, att88, att92, att94, att96, att98, att00, att00, att04);
      sust06=sum(att86, att88, att88, att92, att94, att96, att98, att00, att00, att04, att04);
      sust08=sum(att86, att88, att88, att92, att94, att96, att98, att00, att00, att04, att04, att08);
      sust10=sum(att86, att88, att88, att92, att94, att96, att98, att00, att00, att04, att04, att08, att08);
      sust12=sum(att86, att88, att88, att92, att94, att96, att98, att00, att00, att04, att04, att08, att08, att12);
      sust14=sum(att86, att88, att88, att92, att94, att96, att98, att00, att00, att04, att04, att08, att08, att12, att14);
      sust16=sum(att86, att88, att88, att92, att94, att96, att98, att00, att00, att04, att04, att08, att08, att12, att14, att14);
      sust18=sum(att86, att88, att88, att92, att94, att96, att98, att00, att00, att04, att04, att08, att08, att12, att14, att14, att14);
     
      /* percentage of years satisfying the recommended level */
      psust86=sum(att86); 
      psust88=round(sum(att86, att88)/2, 0.01);
      psust90=round(sum(att86, att88, att88)/3, 0.01);
      psust92=round(sum(att86, att88, att88, att92)/4, 0.01);
      psust94=round(sum(att86, att88, att88, att92, att94)/5, 0.01);
      psust96=round(sum(att86, att88, att88, att92, att94, att96)/6, 0.01);
      psust98=round(sum(att86, att88, att88, att92, att94, att96, att98)/7, 0.01);
      psust00=round(sum(att86, att88, att88, att92, att94, att96, att98, att00)/8, 0.01);
      psust02=round(sum(att86, att88, att88, att92, att94, att96, att98, att00, att00)/9, 0.01);
      psust04=round(sum(att86, att88, att88, att92, att94, att96, att98, att00, att00, att04)/10, 0.01);
      psust06=round(sum(att86, att88, att88, att92, att94, att96, att98, att00, att00, att04, att04)/11, 0.01);
      psust08=round(sum(att86, att88, att88, att92, att94, att96, att98, att00, att00, att04, att04, att08)/12, 0.01);
      psust10=round(sum(att86, att88, att88, att92, att94, att96, att98, att00, att00, att04, att04, att08, att08)/13, 0.01);
      psust12=round(sum(att86, att88, att88, att92, att94, att96, att98, att00, att00, att04, att04, att08, att08, att12)/14, 0.01);
      psust14=round(sum(att86, att88, att88, att92, att94, att96, att98, att00, att00, att04, att04, att08, att08, att12, att14)/15, 0.01);
      psust16=round(sum(att86, att88, att88, att92, att94, att96, att98, att00, att00, att04, att04, att08, att08, att12, att14, att14)/16, 0.01);
      psust18=round(sum(att86, att88, att88, att92, att94, att96, att98, att00, att00, att04, att04, att08, att08, att12, att14, att14, att14)/17, 0.01);

      /* BMI */
      array bmi  {*} bmi76  bmi78  bmi80  bmi82  bmi84  bmi86  bmi88  bmi90  bmi92  bmi94  bmi96  bmi98  bmi00  bmi02  bmi04  bmi06  bmi08  bmi10  bmi12  bmi14  bmi16  bmi18 ;
    
      do i=1 to dim(bmi);
      if bmi{i}<=10 then bmi{i}=.;
      end; drop i;

      do i=2 to dim(bmi); 
      if bmi{i}=. then bmi{i}=bmi{i-1};
      end; drop i;
      
      bmi76v=bmi76;
      bmi78v=mean(bmi76, bmi78);
      bmi80v=mean(bmi76, bmi78, bmi80);
      bmi84v=mean(bmi76, bmi78, bmi80, bmi84);
      bmi86v=mean(bmi76, bmi78, bmi80, bmi84, bmi86);
      bmi88v=mean(bmi76, bmi78, bmi80, bmi84, bmi86, bmi88);
      bmi90v=mean(bmi76, bmi78, bmi80, bmi84, bmi86, bmi88, bmi90);
      bmi92v=mean(bmi76, bmi78, bmi80, bmi84, bmi86, bmi88, bmi90, bmi92);
      bmi94v=mean(bmi76, bmi78, bmi80, bmi84, bmi86, bmi88, bmi90, bmi92, bmi94);
      bmi96v=mean(bmi76, bmi78, bmi80, bmi84, bmi86, bmi88, bmi90, bmi92, bmi94, bmi96);
      bmi98v=mean(bmi76, bmi78, bmi80, bmi84, bmi86, bmi88, bmi90, bmi92, bmi94, bmi96,bmi98);
      bmi00v=mean(bmi76, bmi78, bmi80, bmi84, bmi86, bmi88, bmi90, bmi92, bmi94, bmi96,bmi98, bmi00);
      bmi02v=mean(bmi76, bmi78, bmi80, bmi84, bmi86, bmi88, bmi90, bmi92, bmi94, bmi96,bmi98, bmi00, bmi02);
      bmi04v=mean(bmi76, bmi78, bmi80, bmi84, bmi86, bmi88, bmi90, bmi92, bmi94, bmi96,bmi98, bmi00, bmi02, bmi04);
      bmi06v=mean(bmi76, bmi78, bmi80, bmi84, bmi86, bmi88, bmi90, bmi92, bmi94, bmi96,bmi98, bmi00, bmi02, bmi04,bmi06);
      bmi08v=mean(bmi76, bmi78, bmi80, bmi84, bmi86, bmi88, bmi90, bmi92, bmi94, bmi96,bmi98, bmi00, bmi02, bmi04,bmi06, bmi08);
      bmi10v=mean(bmi76, bmi78, bmi80, bmi84, bmi86, bmi88, bmi90, bmi92, bmi94, bmi96,bmi98, bmi00, bmi02, bmi04,bmi06, bmi08, bmi10);
      bmi12v=mean(bmi76, bmi78, bmi80, bmi84, bmi86, bmi88, bmi90, bmi92, bmi94, bmi96,bmi98, bmi00, bmi02, bmi04,bmi06, bmi08, bmi10, bmi12);
      bmi14v=mean(bmi76, bmi78, bmi80, bmi84, bmi86, bmi88, bmi90, bmi92, bmi94, bmi96,bmi98, bmi00, bmi02, bmi04,bmi06, bmi08, bmi10, bmi12, bmi14);
      bmi16v=mean(bmi76, bmi78, bmi80, bmi84, bmi86, bmi88, bmi90, bmi92, bmi94, bmi96,bmi98, bmi00, bmi02, bmi04,bmi06, bmi08, bmi10, bmi12, bmi14, bmi16);

      basebmi=bmi86;

      /* ALCOHOL */
      array alcon   {*} alco80n   alco84n   alco86n   alco90n   alco94n   alco98n   alco02n   alco06n   alco10n   ;  
          
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
      alco14nv=mean(alco86n,alco90n,alco94n,alco98n,alco02n,alco06n,alco10n,alco10nv);
         
      /* AHEI */
      array ahei    {*} ahei2010_84   ahei2010_86   ahei2010_90   ahei2010_94   ahei2010_98   ahei2010_02   ahei2010_06   ahei2010_10;  

      do i=2 to dim(ahei); 
      if ahei{i}=. then ahei{i}=ahei{i-1};
      end; drop i;

      ahei84v=ahei2010_84;
      ahei86v=mean(ahei2010_84,ahei2010_86);
      ahei90v=mean(ahei2010_84,ahei2010_86,ahei2010_90);
      ahei94v=mean(ahei2010_84,ahei2010_86,ahei2010_90,ahei2010_94);
      ahei98v=mean(ahei2010_84,ahei2010_86,ahei2010_90,ahei2010_94,ahei2010_98);
      ahei02v=mean(ahei2010_84,ahei2010_86,ahei2010_90,ahei2010_94,ahei2010_98,ahei2010_02);
      ahei06v=mean(ahei2010_84,ahei2010_86,ahei2010_90,ahei2010_94,ahei2010_98,ahei2010_02,ahei2010_06);
      ahei10v=mean(ahei2010_84,ahei2010_86,ahei2010_90,ahei2010_94,ahei2010_98,ahei2010_02,ahei2010_06,ahei2010_10);
    
      /* REGULAR ASPIRIN OR NSAIDS */
      /* We did not incorporate %meds8915 or %med8016 
	because we want to adjust for regular aspirin use as defined in prior studies. 
	Briefly, the regular aspirin user was defined by participants who take at least 2 tables of aspirin (325 mg/tablet) per week in the NHS and at least 2 times per week in the HPFS and NHSII. 
	Regular NSAIDs users are defined as participants who take at least 2 times per week. ; */

      array regaspa {*} regaspre80 regaspre82 regaspre84 regaspre84 regaspre88 regaspre90 regaspre92 regaspre94 regaspre96 regaspre98 regaspre00 regaspre02 regaspre04 regaspre06 regaspre08 regaspre10 regaspre12 regaspre14 regaspre16;
      array regibuia {*} XXXX XXXX XXXX XXXX XXXX regibui90 regibui92 regibui94 regibui96 regibui98 regibui00 regibui02 regibui04 regibui06 regibui08 regibui10 regibui12 regibui14 regibui16;

	do i=1 to dim(regaspa);
		if i>1 then do;
			if regaspa{i}=. and regaspa{i-1} ne . then regaspa{i}=regaspa{i-1};
			if regibuia{i}=. and regibuia{i-1} ne . then regibuia{i}=regibuia{i-1};
		end;
	end;

      /* SMOKING */    
      array pkyr  {*} pkyr76  pkyr78  pkyr80  pkyr82  pkyr84  pkyr86  pkyr88  pkyr90  pkyr92  pkyr94  pkyr96  pkyr98  pkyr00  pkyr02  pkyr04  pkyr06  pkyr08  pkyr10  pkyr12  pkyr14  pkyr16; 
      array smkdr {*} smkdr76 smkdr78 smkdr80 smkdr82 smkdr84 smkdr86 smkdr88 smkdr90 smkdr92 smkdr94 smkdr96 smkdr98 smkdr00 smkdr02 smkdr04 smkdr06 smkdr08 smkdr10 smkdr12 smkdr14 smkdr16;
      array smks  {*} smoke76 smoke78 smoke80 smoke82 smoke84 smoke86 smoke88 smoke90 smoke92 smoke94 smoke96 smoke98 smoke00 smoke02 smoke04 smoke06 smoke08 smoke10 smoke12 smoke14 smoke16;

         do i=1 to dim(pkyr);
             if pkyr{i}=998 then pkyr{i}=0;
             if pkyr{i}>998 then pkyr{i}=.;

             if smkdr{i}=1           then smks{i}=1; * never;
             else if 2<=smkdr{i}<=8  then smks{i}=2; * former;
             else if 9<=smkdr{i}<=15 then smks{i}=3; * current;
             else smks{i}=.;

         end; drop i;

      /* MENOPAUSE & HORMONE USE */
      array dmnpa{*} dmnp76 dmnp78 dmnp80 dmnp82 dmnp84 dmnp86 dmnp88 dmnp90 dmnp92 dmnp94 dmnp96 dmnp98 dmnp00 dmnp02 dmnp04 dmnp04 dmnp04 dmnp04 dmnp04 dmnp04 dmnp04; 
      array nhora{*} nhor76 nhor78 nhor80 nhor82 nhor84 nhor86 nhor88 nhor90 nhor92 nhor94 nhor96 nhor98 nhor00 nhor02 nhor04 nhor06 nhor08 nhor10 nhor12 nhor14 nhor16; 
      array menopa{*} meno76 meno78 meno80 meno82 menop84 menop86 menop88 menop90 menop92 menop94 menop96 menop98 menop00 menop02 menop04 menop06 menop08 menop10 menop12 menop14 menop16; 
      array pmha{*} pmh76 pmh78 pmh80 pmh82 pmh84 pmh86 pmh88 pmh90 pmh92 pmh94 pmh96 pmh98 pmh00 pmh02 pmh04 pmh06 pmh08 pmh10 pmh12 pmh14 pmh16; 

         do i=1 to dim(dmnpa);
		if i>1 then do;if dmnpa{i-1}=2 then dmnpa{i}=2;end;
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

      /* CHRONIC DISEASE */  
      array repmi   {*}    mi76     mi78     mi80     mi82     mi84     mi86     mi88     mi90     mi92     mi94     mi96     mi98     mi00     mi02     mi04     mi06     mi08     mi10     mi12     mi14     mi16    ;
      array repstrk {*}    str82    str86    str90    str92    str94    str96    str98    str00    str02    str04    str06    str08    str10    str12    str14    str16   ; 
      array diab    {*}    db76     db78     db80     db82     db84     db86     db88     db90     db92     db94     db96     db98     db00     db02     db04     db06     db08     db10     db12     db14     db16    ;
      array canc    {*}    can76    can78    can80    can82    can84    can86    can88    can90    can92    can94    can96    can98    can00    can02    can04    can06    can08    can10    can12    can14    can16   ;
      array chol    {*}    chol76   chol78   chol80   chol82   chol84   chol86   chol88   chol90   chol92   chol94   chol96   chol98   chol00   chol02   chol04   chol06   chol08   chol10   chol12   chol14   chol16  ;      
      array hbp     {*}    hbp76    hbp78    hbp80    hbp82    hbp84    hbp86    hbp88    hbp90    hbp92    hbp94    hbp96    hbp98    hbp00    hbp02    hbp04    hbp06    hbp08    hbp10    hbp12    hbp14    hbp16   ; 
      array repang  {*}    ang76    ang78    ang80    ang82    ang84    ang86    ang88    ang90    ang92    ang94    ang96    ang98    ang00    ang02    ang04    ang06    ang08    ang10    ang12    ang14    ang16   ;
      array repcabg {*}    cabg84   cabg86   cabg88   cabg90   cabg92   cabg94   cabg96   cabg98   cabg00   cabg02   cabg04   cabg06   cabg08   cabg10   cabg12   cabg14   cabg16  ;

        do i= 2 to DIM(repmi);     if repmi(i-1)=1       then repmi(i)=1;     end;
        do i= 2 to DIM(repstrk);   if repstrk(i-1)=1     then repstrk(i)=1;   end;
        do i= 2 to DIM(repang);    if repang(i-1)=1      then repang(i)=1;    end;
        do i= 2 to DIM(repcabg);   if repcabg(i-1)=1     then repcabg(i)=1;   end;
        do i= 2 to DIM(diab);      if diab(i-1)=1        then diab(i)=1;      end;
        do i= 2 to DIM(canc);      if canc(i-1)=1        then canc(i)=1;      end;
        do i= 2 to DIM(chol);      if chol(i-1)=1        then chol(i)=1;      end;
        do i= 2 to DIM(hbp);       if hbp(i-1)=1         then hbp(i)=1;       end;

      /* FAMILY HISTORY */
      array fhxcanc {*}    cafh76   cafh82   cafh88   cafh92   cafh96   cafh00   cafh04   cafh08   cafh12 ;
      array fhxcvd  {*}    cvdfh76  cvdfh96  cvdfh08 ;
      array fhxdb   {*}    dbfh82   dbfh88   dbfh92  ;

        do i= 2 to DIM(fhxcanc);    if fhxcanc(i-1)=1      then fhxcanc(i)=1;    end;
        do i= 2 to DIM(fhxcvd);     if fhxcvd(i-1)=1       then fhxcvd(i)=1;    end;
        do i= 2 to DIM(fhxdb);      if fhxdb(i-1)=1        then fhxdb(i)=1;    end;

        /*
        if cafh76=1 or cafh82 or cafh88=1 or cafh92=1 or cafh96=1 or cafh00=1 or cafh04=1 or cafh08=1 or cafh12=1 then cafh=1; else cafh=0;
        if dbfh82=1 or dbfh88=1 or dbfh92=1 then dbfh=1; else dbfh=0;
        if cvdfh76=1 or cvdfh96=1 or cvdfh08=1 then cvdfh=1; else cvdfh=0;
        */

run;
   
proc datasets;
        delete der7620 nhs_outcome meds8020 supp8020 act8614 familyhis nhs_asp ahei2010_8420
          n767880 nur82 nur84 nur86 nur88 nur90 nur92 nur94 nur96 nur98 nur00 nur02 nur04 nur06 nur08 nur10 nur12 nur14 nur16 nur20
          n80_nts n84_nts n86_nts n90_nts n94_nts n98_nts n02_nts n06_nts n10_nts n20_nts;
run;

/*
proc means n nmiss mean min max;
run;
*/
