%include '/udd/hpzfa/review/PA/revision/gformula/nhs.main.sas'; 
  
data pre_pm;
     set base  end=_end_;
           
      array irt     {19} irt86        irt86        irt88         irt90         irt92         irt94         irt96        irt98         irt00         irt02         irt04         irt06         irt08         irt10         irt12         irt14        irt16        irt18      cutoff;
      /** check **/
      array anoirt  {18} noirt86      noirt86      noirt88	  noirt90       noirt92	   noirt94       noirt96	   noirt98       noirt00	    noirt02	noirt04	     noirt06	 noirt08	      noirt10	  noirt12       noirt14      noirt16      noirt18;

      array tvar    {18} t86          t86          t88           t90           t92           t94           t96          t98            t00           t02           t04           t06           t08           t10           t12           t14          t16         t18;
      array age     {18} age86        age86        age88         age90         age92         age94         age96        age98          age00         age02         age04         age06         age08         age10         age12         age14        age16       age18;
      array mar     {18} marital80    marital80    marital80     marital80     marital92     marital92     marital96    marital96      marital00     marital00     marital04     marital04     marital08     marital08     marital12     marital12    marital16   marital16;   
      array bmi     {18} bmi86        bmi86        bmi88         bmi90         bmi92         bmi94         bmi96        bmi98          bmi00         bmi02         bmi04         bmi06         bmi08         bmi10         bmi12         bmi14        bmi16       bmi16;
      array bmiv    {18} bmi86v       bmi86v       bmi88v        bmi90v        bmi92v        bmi94v        bmi96v       bmi98v         bmi00v        bmi02v        bmi04v        bmi06v        bmi08v        bmi10v        bmi12v        bmi14v       bmi16v      bmi16v;
      array smkdr   {18} smkdr86      smkdr86      smkdr88       smkdr90       smkdr92       smkdr94       smkdr96      smkdr98        smkdr00       smkdr02       smkdr04       smkdr06       smkdr08       smkdr10       smkdr12       smkdr14      smkdr16     smkdr16;
      array smok    {18} smoke86      smoke86      smoke88       smoke90       smoke92       smoke94       smoke96      smoke98        smoke00       smoke02       smoke04       smoke06       smoke08       smoke10       smoke12       smoke14      smoke16     smoke16;   
      array pkyr    {18} pkyr86       pkyr86       pkyr88        pkyr90        pkyr92        pkyr94        pkyr96       pkyr98         pkyr00        pkyr02        pkyr04        pkyr06        pkyr08        pkyr10        pkyr12        pkyr14       pkyr16      pkyr16; 
      array alcon   {18} alco86n      alco86n      alco86n       alco90n       alco90n       alco94n       alco94n      alco98n        alco98n       alco02n       alco02n       alco06n       alco06n       alco10n       alco10n       alco10n      alco10n     alco10n;     
      array alconv  {18} alco86nv     alco86nv     alco86nv      alco90nv      alco90nv      alco94nv      alco94nv     alco98nv       alco98nv      alco02nv      alco02nv      alco06nv      alco06nv      alco10nv      alco10nv      alco10nv     alco10nv    alco10nv;  
      array ahei    {18} ahei2010_86  ahei2010_86  ahei2010_86   ahei2010_90   ahei2010_90   ahei2010_94   ahei2010_94  ahei2010_98    ahei2010_98   ahei2010_02   ahei2010_02   ahei2010_06   ahei2010_06   ahei2010_10   ahei2010_10   ahei2010_10  ahei2010_10 ahei2010_10;
      array aheiv   {18} ahei86v      ahei86v      ahei86v       ahei90v       ahei90v       ahei94v       ahei94v      ahei98v        ahei98v       ahei02v       ahei02v       ahei06v       ahei06v       ahei10v       ahei10v       ahei10v      ahei10v     ahei10v;  
      array aspa    {18} regaspre84   regaspre84   regaspre88    regaspre90    regaspre92    regaspre94    regaspre96   regaspre98     regaspre00    regaspre02    regaspre04    regaspre06    regaspre08    regaspre10    regaspre12    regaspre14   regaspre16  regaspre16;
      array ibuia   {18} regibui90    regibui90    regibui90     regibui90     regibui92     regibui94     regibui96    regibui98      regibui00     regibui02     regibui04     regibui06     regibui08     regibui10     regibui12     regibui14    regibui16   regaspre16;   
      array pmha    {18} pmh86        pmh86        pmh88         pmh90         pmh92         pmh94         pmh96        pmh98          pmh00         pmh02         pmh04         pmh06         pmh08         pmh10         pmh12         pmh14        pmh16       pmh16; 
      array mvyn    {18} mvyn86       mvyn86       mvyn88        mvyn90        mvyn92        mvyn94        mvyn96       mvyn98         mvyn00        mvyn02        mvyn04        mvyn06        mvyn08        mvyn10        mvyn12        mvyn14       mvyn16      mvyn16; 
      array nhora   {18} nhor86       nhor86       nhor88        nhor90        nhor92        nhor94        nhor96       nhor98         nhor00        nhor02        nhor04        nhor06        nhor08        nhor10        nhor12        nhor14       nhor16      nhor16; 
      array menopa  {18} menop86      menop86      menop88       menop90       menop92       menop94       menop96      menop98        menop00       menop02       menop04       menop06       menop08       menop10       menop12       menop14      menop16     menop16; 

      array actm    {18} act86m       act86m       act88m        act88m        act92m        act94m        act96m       act98m         act00m        act00m        act04m        act04m        act08m        act08m        act12m        act14m       act14m      act14m;      
      array actmv   {18} act86v       act86v       act88v        act88v        act92v        act94v        act96v       act98v         act00v        act00v        act04v        act04v        act08v        act08v        act12v        act14v       act14v      act14v;
      array acts    {18} act86s       act86s       act88s        act90s        act92s        act94s        act96s       act98s         act00s        act02s        act04s        act06s        act08s        act10s        act12s        act14s       act16s      act18s;
      array actbin  {18} att86        att86        att88         att88         att92         att94         att96        att98          att00         att00         att04         att04         att08         att08         att12         att14        att14       att14;
      array sust    {18} sust86       sust86       sust88        sust90        sust92        sust94        sust96       sust98         sust00        sust02        sust04        sust06        sust08        sust10        sust12        sust14       sust16      sust18;
      array psust   {18} psust86      psust86      psust88       psust90       psust92       psust94       psust96      psust98        psust00       psust02       psust04       psust06       psust08       psust10       psust12       psust14      psust16     psust18;

      /*
      array fhxcanc {18} cafh82       cafh82       cafh88        cafh88        cafh92        cafh92        cafh96        cafh96        cafh00        cafh00        cafh04        cafh04        cafh08        cafh08        cafh12        cafh12       cafh12      cafh12;
      array fhxcvd  {18} cvdfh76      cvdfh76      cvdfh76       cvdfh76       cvdfh76       cvdfh76       cvdfh96       cvdfh96       cvdfh96       cvdfh96       cvdfh96       cvdfh96       cvdfh08       cvdfh08       cvdfh08       cvdfh08      cvdfh08     cvdfh08;
      array fhxdb   {18} dbfh82       dbfh82       dbfh82        dbfh88        dbfh92        dbfh92        dbfh92        dbfh92        dbfh92        dbfh92        dbfh92        dbfh92        dbfh92        dbfh92        dbfh92        dbfh92       dbfh92      dbfh92;
      array chol    {18} chol86       chol86       chol88        chol90        chol92        chol94        chol96        chol98        chol00        chol02        chol04        chol06        chol08        chol10        chol12        chol14       chol16      chol16;
      array hbp     {18} hbp86        hbp86        hbp88         hbp90         hbp92         hbp94         hbp96         hbp98         hbp00         hbp02         hbp04         hbp06         hbp08         hbp10         hbp12         hbp14        hbp16       hbp16;
      array repang  {18} ang86        ang86        ang88         ang90         ang92         ang94         ang96         ang98         ang00         ang02         ang04         ang06         ang08         ang10         ang12         ang14        ang16       ang16;     
      array repcabg {18} cabg86       cabg86       cabg88        cabg90        cabg92        cabg94        cabg96        cabg98        cabg00        cabg02        cabg04        cabg06        cabg08        cabg10        cabg12        cabg14       cabg16      cabg16; 
      */

/*** Set cutoff at 2020 June 30 ***/
/*************************************************************************
***** If an irt date is before June of that qq year or after or equal ****
***** to the next qq year it is incorrect and should be defaulted to  ****
***** June of that qq year.    Make time period indicator tvar=0.     ****
*************************************************************************/

 cutoff=1446;  
 /** check **/  
   do i=2 to DIM(irt)-1;
      if (irt{i}<(990+24*i) | irt{i}>=(1014+24*i)) then irt{i}=990+24*i;   /*1986*/
   end;


%beginex();

/********* DO LOOP OVER TIME PERIOD **************/

 /** check **/
 do i=2 to DIM(irt)-1 until (event or censor);     
      period=i-2;

      do j=2 to DIM(tvar);
         tvar{j}=0;
      end;

      /*SET CURRENT TIMEVAR INDICATOR AND TIME PERIOD EXPOSURE INDICATOR TO ONE*/
      tvar{i}=1; 
      event=0;
      if chr=1 and irt{i}<dt_chr<=irt{i+1} then event=1;

      diag_chr=0;
      if chr=1 and irt{i}<dt_chr<=irt{i+1} then diag_chr=1;

      censor=0; censdead=0; censlost=0;
      if irt{i}<dtdth<=irt{i+1} and diag_chr ne 1 then do;
       	censor=1;  diag_chr=.;  censdead=1;
      end;
      else if anoirt{i}=1 and diag_chr ne 1 then do;       
	censor=1;  diag_chr =.; censlost=1;  
      end;

      pt_chr=irt{i+1}-irt{i};
      if diag_chr=1 and irt{i}<dt_chr<=irt{i+1} then pt_chr=dt_chr-irt{i};
      if irt{i}<=dtdth<irt{i+1} then pt_chr=min(pt_chr, dtdth-irt{i});


/********************* Exposures & Covariates **********************/

      
/* DEFINE AGE */ 
      agecon=age{i}; /* in years */
      agemos=int((irt{i}-bdt)); /* in months */

      if 0<age{i}<60 then agegp=0;     
      else if age{i}>=60 and age{i}<65 then agegp=1;
      else if age{i}>=65 and age{i}<70 then agegp=2;
      else if age{i}>=70 and age{i}<75 then agegp=3;
      else if age{i}>=75 and age{i}<80 then agegp=4;
      else agegp=5;
%indic3(vbl=agegp, prefix=agegp, min=1, max=5, reflev=0, missing=., usemiss=0,
                   label1='age<60ys',
                   label2='age60-64ys',
                   label3='age65-69ys',
                   label4='age70-74ys',
                   label5='age75-79ys',
                   label6='age>=80ys');
        
/* DEFINE BMI */ 
      bmicon=bmi{i}; 
  
      if 0<bmicon<23 then bmicat=0; 
      else if 23=<bmicon<25 then bmicat=1;
      else if 25=<bmicon<30 then bmicat=2;
      else if 30=<bmicon<35 then bmicat=3;
      else if bmicon>=35 then bmicat=4;
      else bmicat=1;
%indic3(vbl=bmicat, prefix=bmicat, min=0, max=4, reflev=1, missing=., usemiss=0,
                label1='<23.0',
                label2='23.0-24.9',
                label3='25-29.9',
                label4='30-34.9',
      	       label5='35+');

/* EXERCISE */
	 actcon=actm{i};
          actconv=actmv{i};
          if actcon<3           then actcat=1;
          else if 3=<actcon<9     then actcat=2;
          else if 9=<actcon<18    then actcat=3;
          else if 18=<actcon<27   then actcat=4;
          else if 27=<actcon      then actcat=5;
          else actcat=.;  
%indic3(vbl=actcat, prefix=actcat, min=2, max=5, reflev=1, missing=., usemiss=0,
                    label1='<3 total MET-hours/week',
	           label2='3 to < 9 MET-hours/week',
	           label3='9 to < 18 MET-hours/week', 
	           label4='18 to < 27 MET-hours/week',
	           label5='27+ MET-hours/week');

          actsim=actm{i};
          actsum=acts{i};
          attain=actbin{i};
          sustain=sust{i};
          percdur=psust{i};

/* ALCOHOL */
      alcocon=alcon{i}; /***continuous variable, g/day***/ 

      if alcocon=0.0                           then   alcc=1;
      else if alcocon>0.0   and alcocon<10.0   then   alcc=2;
      else if alcocon>=10.0  and alcocon<20.0  then   alcc=3;
      else if alcocon>=20.0                    then   alcc=4;    
      else alcc=.;  
%indic3(vbl=alcc, prefix=alcc, min=1, max=4, reflev=1, missing=., usemiss=1,
                  label1='0 g/d',
                  label2='0.1-9.9 g/d',
                  label3='10.0-20.0 g/d',
        	         label4='20+ g/d');

/* DIETARY PATTERN***/
      aheicon=ahei{i};

/* ASPIRIN or NSAIDS ***/
      if aspa{i}=2       then  regaspa=1;
      else regaspa=0;
      
      if ibuia{i}=2       then  regibuia=1;
      else regibuia=0;

/* SMOKING */        
   smkst=smok{i}; 
%indic3(vbl=smkst, prefix=smkst, min=2, max=3, reflev=1, usemiss=1, missing=., label1='never smoker', label2='past smoker', label3='current smoker');
   
   packy=pkyr{i};

     if smok{i}=1 then smkpy=1;
     else if smok{i}=2 then do;
                if 0<pkyr{i}<10         then smkpy=2;
                else if 10<=pkyr{i}<20  then smkpy=3;
                else if 20<=pkyr{i}<40  then smkpy=4;
                else if 40<=pkyr{i}<998 then smkpy=5;
                else smkpy=.;
        end;
     else if smok{i}=3 then do;
                if 0<pkyr{i}<25         then smkpy=6;
                else if 25<=pkyr{i}<45  then smkpy=7;
                else if 45<=pkyr{i}<65  then smkpy=8;
                else if 65<=pkyr{i}<998 then smkpy=9;
                else smkpy=.;
        end; 
     else smkpy=.;
   
%indic3(vbl=smkpy, prefix=smkpy, min=2, max=9, reflev=1, usemiss=1, missing=., label1='never', 
                   label2='past < 10 pkyr',  label3='past 10-19 pkyr',
                   label4='past 20-39 pkyr', label5='past 40+ pkyr',
                   label6='curr < 25 pkyr',  label7='curr 25-44 pkyr',
                   label8='curr 45-64 pkyr', label9='curr 65+ pkyr');

/* MULTIVITAMIN */
        mvit=mvyn{i};
%indic3(vbl=mvit, prefix=mvit, min=1, max=1, reflev=0, missing=., usemiss=0);   

/* MENOPAUSE & HORMONE USE */
        phmsstatus=pmha{i};
%indic3(vbl=phmsstatus, prefix=phmsstatus, min=2, max=4, reflev=1, missing=., usemiss=1,      
                        label1='pre mnp',      
                        label2='never/unknown pmhuser, post mnp',      
                        label3='past pmh user and post mnp',      
                        label4='curr pmhuser and post mnp');  

        postmnp=menopa{i};
        hor=nhora{i};

/* FAMILY HISTORY */
/*
        select(fhxcanc{i});
                when (1)     cafh=1;
      	         otherwise    cafh=0;
        end;
          
        select(fhxcvd{i});
                when (1)     cvdfh=1;
      	         otherwise    cvdfh=0;
        end;

        select(fhxdb{i});
                when (1)     dbfh=1;
      	         otherwise    dbfh=0;
        end;
*/

/** check **/
        actcon_l1=actm{i-1};
        agecon_l1=age{i-1};
        bmicon_l1=bmi{i-1};
        alcocon_l1=alcon{i-1};
        aheicon_l1=ahei{i-1};
        packy_l1=pkyr{i-1};
        mvit_l1=mvyn{i-1};
        if aspa{i-1}=2 then regaspa_l1=1; else regaspa_l1=0;
        if ibuia{i-1}=2 then regibuia_l1=1; else regibuia_l1=0;
        postmnp_l1 = menopa{i-1};
        hor_l1 = nhora{i-1};


      if dtdth in (0, ., 9999) then dtdth=.; 


/************************  BASELINE EXCLUSIONS ********************************/

/** check **/
  if i=2 then do;

       %exclude(exrec eq 1);                 *multiple records and not in master file;
       %exclude(yobf le 20);
       %exclude(age86 le 0); 
 
       %exclude(act86m eq .);

       %exclude(can86 eq 1);
       %exclude(mi86 eq 1);
       %exclude(str86 eq 1);
       %exclude(db86 eq 1);

       %exclude(0 lt dtdth le irt{i});
       %exclude(0 lt dt_totcancer le irt{i});
       %exclude(0 lt dt_cvd le irt{i});
       %exclude(0 lt dt_diab le irt{i});

       %exclude(bmi86 eq .);
       %exclude(pkyr86 eq .);
       %exclude(alco86n eq .);
       %exclude(ahei2010_86 eq .);

   %output();

     end;
 
/***************  Each questionnaire cycle exclusions *************************/
   else if i> 2 then do;

       %exclude(irt{i-1} le dtdth lt irt{i});
       %exclude(irt{i-1} le dt_chr lt irt{i});
      
   %output();

     end;

 end; /* END OF DO-LOOP OVER TIME PERIODs */
      
   %endex();

run;


proc datasets nolist; delete base; run;


                            ***
                        ***     ***
                    ***            ***
                ***    data-nhs    ***
                    ***            ***
                        ***     ***
                            ***;

data nhs1data;
set pre_pm end=_end_;
cohort=1;
sex=1;
id=100000000+id;  
period_b=period; /* start from 1986, 0 */
if regaspre84=. then regaspre84=0;
if regibui90=. then regibui90=0;
if pkyr86<=5 then packy86=0; else packy86=1; 
if bmi86<25 then obes86=0; else obes86=1;
if nhor86=1 then hor86=1; else hor86=0;
keep 
 id cohort period period_b sex cutoff dtdth agecon agegp &agegp_ agemos
 /*irt86 irt88 irt90 irt92 irt94 irt96 irt98 irt00 irt02 irt04 irt06 irt08 irt10 irt12 irt14 irt16 irt18*/
 t86 t88 t90 t92 t94 t96 t98 t00 t02 t04 t06 t08 t10 t12 t14 t16 t18
 
 chr      dt_chr     diag_chr     pt_chr   

 censor   censdead   censlost

 actcon   actcat     attain      actsum    actsim   percdur
 actconv  &actcat_   sustain 

 bmicon   bmicat     alcocon    alcc      aheicon     smkst      smkpy      packy     mvit      phmsstatus
          &bmicat_              &alcc_                &smkst_    &smkpy_                        &phmsstatus_                                 

 regaspa  regibuia   white    cafh    dbfh    cvdfh    postmnp   hor 

 regaspa_l1  regibuia_l1  mvit_l1     postmnp_l1   hor_l1      actcon_l1
 bmicon_l1   alcocon_l1   aheicon_l1  packy_l1     agecon_l1

 age86  bmi86  obes86  regaspre84  regibui90  mvyn86  packy86  alco86n  ahei2010_86  menop86  hor86
; 
run;

proc sort; by id period; run;

data nhs;
set nhs1data;
rename age86=age_bs
       bmi86=bmi_bs
       obes86=obes_bs
       regaspre84=aspirin_bs
       regibui90=ibui_bs
       mvyn86=mvt_bs
       packy86=pkyr_bs
       alco86n=alco_bs
       ahei2010_86=ahei_bs
       menop86=menop_bs
       hor86=nhor_bs;
run;

data g_fm.nhs1_main; set nhs; 
run;

proc freq; 
table diag_chr censor censdead censlost period
      white   cafh   dbfh   cvdfh
      regaspa     regibuia     mvit     postmnp     hor    
      regaspa_l1  regibuia_l1  mvit_l1  postmnp_l1  hor_l1
;
run; 

proc means n nmiss mean median min max; 
     var agecon      actcon
         agecon_l1   actcon_l1
         bmicon      alcocon      aheicon      packy 
         bmicon_l1   alcocon_l1   aheicon_l1   packy_l1
	age_bs  bmi_bs  aspirin_bs  ibui_bs    mvt_bs  pkyr_bs  alco_bs  ahei_bs  menop_bs  nhor_bs  obes_bs
;
run;

proc datasets;
delete  base  pre_pm  nhs1data;
run;

