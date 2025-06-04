%include '/udd/hpzfa/review/PA/nhs.main.sas'; 
  
data pre_pm;
     set base  end=_end_;
           
      array irt     {18} irt86        irt88         irt90         irt92         irt94         irt96        irt98         irt00         irt02         irt04         irt06         irt08         irt10         irt12         irt14        irt16        irt18    cutoff;
      array tvar    {17} t86          t88           t90           t92           t94           t96          t98           t00           t02           t04           t06           t08           t10           t12           t14          t16          t18    ;
      array period  {17} period1      period2       period3       period4       period5       period6      period7       period8       period9       period10      period11      period12      period13      period14      period15     period16     period17   ; 
      
      array age     {17} age86        age88         age90         age92         age94         age96        age98          age00         age02         age04         age06         age08         age10         age12         age14        age16       age18;
      array mar     {17} marital80    marital80     marital80     marital92     marital92     marital96    marital96      marital00     marital00     marital04     marital04     marital08     marital08     marital12     marital12    marital16   marital16;   
      array bmi     {17} bmi86        bmi88         bmi90         bmi92         bmi94         bmi96        bmi98          bmi00         bmi02         bmi04         bmi06         bmi08         bmi10         bmi12         bmi14        bmi16       bmi16;
      array bmiv    {17} bmi86v       bmi88v        bmi90v        bmi92v        bmi94v        bmi96v       bmi98v         bmi00v        bmi02v        bmi04v        bmi06v        bmi08v        bmi10v        bmi12v        bmi14v       bmi16v      bmi16v;
      array smkdr   {17} smkdr86      smkdr88       smkdr90       smkdr92       smkdr94       smkdr96      smkdr98        smkdr00       smkdr02       smkdr04       smkdr06       smkdr08       smkdr10       smkdr12       smkdr14      smkdr16     smkdr16;
      array smok    {17} smoke86      smoke88       smoke90       smoke92       smoke94       smoke96      smoke98        smoke00       smoke02       smoke04       smoke06       smoke08       smoke10       smoke12       smoke14      smoke16     smoke16;   
      array pkyr    {17} pkyr86       pkyr88        pkyr90        pkyr92        pkyr94        pkyr96       pkyr98         pkyr00        pkyr02        pkyr04        pkyr06        pkyr08        pkyr10        pkyr12        pkyr14       pkyr16      pkyr16; 
      array alcon   {17} alco86n      alco86n       alco90n       alco90n       alco94n       alco94n      alco98n        alco98n       alco02n       alco02n       alco06n       alco06n       alco10n       alco10n       alco10n      alco10n     alco10n;     
      array alconv  {17} alco86nv     alco86nv      alco90nv      alco90nv      alco94nv      alco94nv     alco98nv       alco98nv      alco02nv      alco02nv      alco06nv      alco06nv      alco10nv      alco10nv      alco10nv     alco10nv    alco10nv;  
      array ahei    {17} ahei2010_86  ahei2010_86   ahei2010_90   ahei2010_90   ahei2010_94   ahei2010_94  ahei2010_98    ahei2010_98   ahei2010_02   ahei2010_02   ahei2010_06   ahei2010_06   ahei2010_10   ahei2010_10   ahei2010_10  ahei2010_10 ahei2010_10;
      array aheiv   {17} ahei86v      ahei86v       ahei90v       ahei90v       ahei94v       ahei94v      ahei98v        ahei98v       ahei02v       ahei02v       ahei06v       ahei06v       ahei10v       ahei10v       ahei10v      ahei10v     ahei10v;  
      array aspa    {17} regaspre84   regaspre88    regaspre90    regaspre92    regaspre94    regaspre96   regaspre98     regaspre00    regaspre02    regaspre04    regaspre06    regaspre08    regaspre10    regaspre12    regaspre14   regaspre16  regaspre16;
      array ibuia   {17} regibui90    regibui90     regibui90     regibui92     regibui94     regibui96    regibui98      regibui00     regibui02     regibui04     regibui06     regibui08     regibui10     regibui12     regibui14    regibui16   regaspre16;   
      array pmha    {17} pmh86        pmh88         pmh90         pmh92         pmh94         pmh96        pmh98          pmh00         pmh02         pmh04         pmh06         pmh08         pmh10         pmh12         pmh14        pmh16       pmh16; 
      array mvyn    {17} mvyn86       mvyn88        mvyn90        mvyn92        mvyn94        mvyn96       mvyn98         mvyn00        mvyn02        mvyn04        mvyn06        mvyn08        mvyn10        mvyn12        mvyn14       mvyn16      mvyn16; 

      array actm    {17} act86m       act88m        act88m        act92m        act94m        act96m       act98m         act00m        act00m        act04m        act04m        act08m        act08m        act12m        act14m       act14m      act14m;      
      array actmv   {17} act86v       act88v        act88v        act92v        act94v        act96v       act98v         act00v        act00v        act04v        act04v        act08v        act08v        act12v        act14v       act14v      act14v;
      array acts    {17} act86s       act88s        act90s        act92s        act94s        act96s       act98s         act00s        act02s        act04s        act06s        act08s        act10s        act12s        act14s       act16s      act18s;
      array actbin  {17} att86        att88         att88         att92         att94         att96        att98          att00         att00         att04         att04         att08         att08         att12         att14        att14       att14;
      array sust    {17} sust86       sust88        sust90        sust92        sust94        sust96       sust98         sust00        sust02        sust04        sust06        sust08        sust10        sust12        sust14       sust16      sust18;
      array psust   {17} psust86      psust88       psust90       psust92       psust94       psust96      psust98        psust00       psust02       psust04       psust06       psust08       psust10       psust12       psust14      psust16     psust18;

      array fhxcanc {17} cafh82       cafh88        cafh88        cafh92        cafh92        cafh96        cafh96        cafh00        cafh00        cafh04        cafh04        cafh08        cafh08        cafh12        cafh12       cafh12      cafh12;
      array fhxcvd  {17} cvdfh76      cvdfh76       cvdfh76       cvdfh76       cvdfh76       cvdfh96       cvdfh96       cvdfh96       cvdfh96       cvdfh96       cvdfh96       cvdfh08       cvdfh08       cvdfh08       cvdfh08      cvdfh08     cvdfh08;
      array fhxdb   {17} dbfh82       dbfh82        dbfh88        dbfh92        dbfh92        dbfh92        dbfh92        dbfh92        dbfh92        dbfh92        dbfh92        dbfh92        dbfh92        dbfh92        dbfh92       dbfh92      dbfh92;
      array chol    {17} chol86       chol88        chol90        chol92        chol94        chol96        chol98        chol00        chol02        chol04        chol06        chol08        chol10        chol12        chol14       chol16      chol16;
      array hbp     {17} hbp86        hbp88         hbp90         hbp92         hbp94         hbp96         hbp98         hbp00         hbp02         hbp04         hbp06         hbp08         hbp10         hbp12         hbp14        hbp16       hbp16;
      array repang  {17} ang86        ang88         ang90         ang92         ang94         ang96         ang98         ang00         ang02         ang04         ang06         ang08         ang10         ang12         ang14        ang16       ang16;     
      array repcabg {17} cabg86       cabg88        cabg90        cabg92        cabg94        cabg96        cabg98        cabg00        cabg02        cabg04        cabg06        cabg08        cabg10        cabg12        cabg14       cabg16      cabg16; 

      * add lagged years;
      array tvar4 {*} t90 t92 t94 t96 t98 t00 t02 t04 t06 t08 t10 t12 t14 t16 t18; /* Indicator variables for time period - initialize to 0 */
      array tvar8 {*} t94 t96 t98 t00 t02 t04 t06 t08 t10 t12 t14 t16 t18; /* Indicator variables for time period - initialize to 0 */
      array tvar12 {*} t98 t00 t02 t04 t06 t08 t10 t12 t14 t16 t18; /* Indicator variables for time period - initialize to 0 */
      array irt4a {*} irt90 irt92 irt94 irt96 irt98 irt00 irt02 irt04 irt06 irt08 irt10 irt12 irt14 irt16 irt18 cutoff;
      array irt8a {*} irt94 irt96 irt98 irt00 irt02 irt04 irt06 irt08 irt10 irt12 irt14 irt16 irt18 cutoff;
      array irt12a {*} irt98 irt00 irt02 irt04 irt06 irt08 irt10 irt12 irt14 irt16 irt18 cutoff;
      array period4a {*} period1 period2 period3 period4 period5 period6 period7 period8 period9 period10 period11 period12 period13 period14 period15;
      array period8a {*} period1 period2 period3 period4 period5 period6 period7 period8 period9 period10 period11 period12 period13;
      array period12a {*} period1 period2 period3 period4 period5 period6 period7 period8 period9 period10 period11;


/*** Set cutoff at 2020 June 30 ***/
/*************************************************************************
***** If an irt date is before June of that qq year or after or equal ****
***** to the next qq year it is incorrect and should be defaulted to  ****
***** June of that qq year.    Make time period indicator tvar=0.     ****
*************************************************************************/

 cutoff=1446;    
   do i=1 to DIM(irt)-1;
      if (irt{i}<(1014+24*i) | irt{i}>=(1038+24*i)) then irt{i}=1014+24*i;   /*1986*/
   end;


%beginex();

/********* DO LOOP OVER TIME PERIOD **************/

 do i=1 to DIM(irt4a)-1;     
      interval=i;
      do j=1 to DIM(tvar4);
         tvar4{j}=0;
         period4a{j}=0;
      end;
      tvar4{i}=1; 
      period4a{i}=1;

* follow from baseline to diagnosis (incident analysis) *;
obes_cav=0; 
pt_obesca=irt4a{i+1}-irt4a{i};
if  obes_ca=1 and irt4a{i}<dt_obesca<=irt4a{i+1} then do;
    obes_cav=1; pt_obesca=dt_obesca-irt4a{i};
end;
if irt4a{i}<=dtdth<irt4a{i+1} then pt_obesca=min(pt_obesca,dtdth-irt4a{i});


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
      bmicon=bmiv{i}; 
  
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
          actcon=actmv{i};
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
    
          actsum=acts{i};
          attain=actbin{i};
          sustain=sust{i};
          actsim=actm{i};

/* ALCOHOL */
      alcocon=alconv{i}; /***continuous variable, g/day***/ 

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
      aheiconv=aheiv{i};

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

/* FAMILY HISTORY */
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


/* CHRONIC CONDITIONS */
 
      /*** Indicator for History of High Blood Pressure ***/
             select(hbp{i});
                when (1)     htn=1;
      	         otherwise    htn=0;
            end;
          
      /*** Indicator for History of High TC ***/
             select(chol{i});
                when (1)     hchol=1;
      	         otherwise    hchol=0;
             end;

      /*** Indicator for History of selfreport Angina ***/
             select(repang{i});
                when (1)     angina=1;
      	         otherwise    angina=0;
             end;

      /*** Indicator for History of selfreport cabg ***/
             select(repcabg{i});
                when (1)     cabg=1;
      	         otherwise    cabg=0;
             end;


      if dtdth in (0, ., 9999) then dtdth=.; 


/************************  BASELINE EXCLUSIONS ********************************/
  if i=1 then do;

       %exclude(exrec eq 1);                 *multiple records and not in master file;
       %exclude(yobf le 20);
       %exclude(age86 le 0); 
 
       %exclude(act86m eq .);

       %exclude(can90 eq 1);
       %exclude(mi90 eq 1);
       %exclude(str90 eq 1);
       %exclude(db90 eq 1);

       %exclude(0 lt dtdth le irt4a{i});
       %exclude(0 lt dt_totcancer le irt4a{i});
       %exclude(0 lt dt_cvd le irt4a{i});
       %exclude(0 lt dt_diab le irt4a{i});

   %output();

     end;
 
/***************  Each questionnaire cycle exclusions *************************/
   else if i> 1 then do;

       %exclude(irt4a{i-1} le dtdth lt irt4a{i});
       %exclude(irt4a{i-1} le dt_obesca lt irt4a{i});
      
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
interval_b=interval;
keep 
 id cohort interval interval_b sex cutoff dtdth agecon agegp &agegp_ agemos
 /*irt86 irt88*/ irt90 irt92 irt94 irt96 irt98 irt00 irt02 irt04 irt06 irt08 irt10 irt12 irt14 irt16 irt18
 /*t86 t88*/ t90 t92 t94 t96 t98 t00 t02 t04 t06 t08 t10 t12 t14 t16 t18
 period1-period15
 
 obes_ca     obes_cav     pt_obesca     dt_obesca    

 actcon   actcat     attain     actsum    actsim  
          &actcat_   sustain 

 bmicon   bmicat     alcocon    alcc      aheiconv    smkst      smkpy      packy     mvit      phmsstatus
          &bmicat_              &alcc_                &smkst_    &smkpy_                        &phmsstatus_                                 

 regaspa  regibuia   white    cafh    dbfh    cvdfh    hchol    htn    angina    cabg          
; 
run;


proc sort; by interval; run;

proc rank data=nhs1data out=nhs1data group=4;
by interval;
var   aheiconv;
ranks aheiq;
run;

proc rank data=nhs1data out=nhs1data group=4;
var   sustain   actsim   actcon;
ranks sustainq  actsimq  actq;
run;

