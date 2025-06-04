/* This program was updated based on the code developed by Mingyang Song for the project 
'Long-term status and change of body fat distribution, and risk of colorectal cancer: a prospective cohort study */
*--- Goal: Compute the trend of physical activity by age;


%include '/udd/hpzfa/review/PA/nhs.main.sas'; 

proc sort data=base; by id; run;

data base;
set base;
by id;
DXage_chronic=int((dt_chr-bdt)/12);	/*age of major chronic disease diagnosis*/
DXage_canc=int((dt_totcancer-bdt)/12);
DXage_cvd=int((dt_cvd-bdt)/12);
DXage_tb=int((dt_diab-bdt)/12);
DXage_death=int((dtdth-bdt)/12);

/*minimum age of major chronic disease diagnosis */
DXage_min=min(DXage_chronic, DXage_canc, DXage_cvd, DXage_tb, DXage_death);

/*exclude participants who had major chronic disease diagnosis at baseline*/
if DXage_min<=age86 then delete;
run;

data age_cohort;
set base;

      array agec    {17} age86        age88         age90         age92         age94         age96        age98          age00         age02         age04         age06         age08         age10         age12         age14        age16       age18;      
      array age     {18} age86        age86         age88         age90         age92         age94        age96          age98         age00         age02         age04         age06         age08         age10         age12        age14       age16      age18;
     
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

/*TRANSFORM THE DATASET: from wide to long format (1 observation/2-year age)*/ 
do i=1 to 17;
  interval=i;
  age_new=agec(i);
  /*all covariates*/
  actcon=actm(i); 
  bmicon=bmi(i);
  alcocon=alcon(i);
  aheicon=ahei(i);
  if aspa{i}=2       then  regaspa=1;
  else regaspa=0;    
  if ibuia{i}=2       then  regibuia=1;
  else regibuia=0;
  smkst=smok(i);
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

  mvit=mvyn(i);
  phmsstatus=pmha(i);
    
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
 
  /*time variable*/
  chrv=0;
  time_chr=2; /*pseudo-time variable: 1 for cases and 2 for non-cases*/
  if age(i)<DXage_chronic<=age(i+1) then do;
  chrv=1;
  time_chr=1;
  end;
  
  output;	/*output the records here*/

  if age(i)<DXage_min<=age(i+1) then leave;	/*censor when having major chronic diseases or death: exit the loop*/

end;

run;

proc freq data=age_cohort;
table chrv interval;
run;

data age_nhs_long;
set age_cohort;
keep id age_new actcon;
run;

/*
ods listing close;
ods pdf file='nhs_act_age_spline.pdf';
proc sgplot data=age_nhs_long;
title1 "Physical activity volume during adulthood in the NHS";
PBSPLINE x=age_new y=actcon/NOMARKERS CLM;
XAXIS values=(40 to 100 by 5) label="Age, years";
YAXIS values=(0 to 40 by 5) label="Physical activity volume, MET-hour/week";
run;
ods pdf close;
ods listing;

endsas;
*/
