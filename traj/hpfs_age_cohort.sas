/* This program was updated based on the code developed by Mingyang Song for the project 
'Long-term status and change of body fat distribution, and risk of colorectal cancer: a prospective cohort study */
*--- Goal: Compute the trend of physical activity by age;


%include '/udd/hpzfa/review/PA/hpfs.main.sas'; 

proc sort data=base; by id; run;

data base;
set base;
by id;
DXage_chronic=int((dt_chr-dbmy09)/12);	/*age of major chronic disease diagnosis*/
DXage_canc=int((dt_totcancer-dbmy09)/12);
DXage_cvd=int((dt_cvd-dbmy09)/12);
DXage_tb=int((dt_diab-dbmy09)/12);
DXage_death=int((dtdth-dbmy09)/12);

/* minimum age of major chronic disease diagnosis */
DXage_min=min(DXage_chronic, DXage_canc, DXage_cvd, DXage_tb, DXage_death);

/* exclude participants who had major chronic disease diagnosis at baseline */
if exrec eq 1 or dbmy09 le 0 or age86 eq . or act86 eq . or  can86 eq 1 or mi86 eq 1 or str86 eq 1 or db86 eq 1 then delete;
if DXage_min ne . and DXage_min<=age86 then delete;
run;

data age_cohort;
set base;

   array agec    {17}    age86          age88          age90          age92          age94           age96           age98          age00          age02          age04          age06           age08           age10          age12          age14          age16        age18;
   array age     {18}    age86          age86          age88          age90          age92          age94           age96           age98          age00          age02          age04          age06            age08          age10          age12          age14        age16        age18;
   
   array mar     {17}    marital86      marital88      marital90      marital92      marital94       marital96       marital98      marital00      marital02      marital04      marital06       marital08       marital10      marital12      marital14      marital16    marital18;   
   array bmi     {17}    bmi86          bmi88          bmi90          bmi92          bmi94           bmi96           bmi98          bmi00          bmi02          bmi04          bmi06           bmi08           bmi10          bmi12          bmi14          bmi16        bmi18;
   array bmiv    {17}    bmi86v         bmi88v         bmi90v         bmi92v         bmi94v          bmi96v          bmi98v         bmi00v         bmi02v         bmi04v         bmi06v          bmi08v          bmi10v         bmi12v         bmi14v         bmi16v       bmi18v;
   array smok    {17}    smoke86        smoke88        smoke90        smoke92        smoke94         smoke96         smoke98        smoke00        smoke02        smoke04        smoke06         smoke08         smoke10        smoke12        smoke14        smoke16      smoke18;
   array pkyr    {17}    pckyr86        pckyr88        pckyr90        pckyr92        pckyr94         pckyr96         pckyr98        pckyr00        pckyr02        pckyr04        pckyr06         pckyr08         pckyr10        pckyr12        pckyr14        pckyr16      pckyr18; 
   array cig     {17}    cgnm86         cgnm88         cgnm90         cgnm92         cgnm94          cgnm96          cgnm98         cgnm00         cgnm02         cgnm04         cgnm06          cgnm08          cgnm10         cgnm12         cgnm14         cgnm16       cgnm18;
   array alcon   {17}    alco86n        alco86n        alco90n        alco90n        alco94n         alco94n         alco98n        alco98n        alco02n        alco02n        alco06n         alco06n         alco10n        alco10n        alco14n        alco14n      alco18n;  
   array alconv  {17}    alco86nv       alco86nv       alco90nv       alco90nv       alco94nv        alco94nv        alco98nv       alco98nv       alco02nv       alco02nv       alco06nv        alco06nv        alco10nv       alco10nv       alco14nv       alco14nv     alco18nv;  
   array ahei    {17}    nAHEI86a       nAHEI86a       nAHEI90a       nAHEI90a       nAHEI94a        nAHEI94a        nAHEI98a       nAHEI98a       nAHEI02a       nAHEI02a       nAHEI06a        nAHEI06a        nAHEI10a       nAHEI10a       nAHEI14a       nAHEI14a     nAHEI14a;  
   array aheiv   {17}    ahei86v        ahei86v        ahei90v        ahei90v        ahei94v         ahei94v         ahei98v        ahei98v        ahei02v        ahei02v        ahei06v         ahei06v         ahei10v        ahei10v        ahei14v        ahei14v      ahei14v;  
   array aspa    {17}    regaspre86     regaspre88     regaspre90     regaspre92     regaspre94      regaspre96      regaspre98     regaspre00     regaspre02     regaspre04     regaspre06      regaspre08      regaspre10     regaspre12     regaspre14     regaspre16   regaspre16;
   array ibuia   {17}    regibui86      regibui88      regibui90      regibui92      regibui94       regibui96       regibui98      regibui00      regibui02      regibui04      regibui06       regibui08       regibui10      regibui12      regibui14      regibui16    regibui16;   
   array mvyn    {17}    mvt86          mvt88          mvt90          mvt92          mvt94           mvt96           mvt98          mvt00          mvt02          mvt04          mvt06           mvt08           mvt10          mvt12          mvt14          mvt14        mvt18;

   array actm    {17}    act86          act88          act90          act92          act94           act96           act98          act00          act02          act04          act06           act08           act10          act12          act14          act16        act16;
   array actmv   {17}    act86v         act88v         act90v         act92v         act94v          act96v          act98v         act00v         act02v         act04v         act06v          act08v          act10v         act12v         act14v         act16v       act16v;      
   array acts    {17}    act86s         act88s         act90s         act92s         act94s          act96s          act98s         act00s         act02s         act04s         act06s          act08s          act10s         act12s         act14s         act16s       act18s;      
   array actbin  {17}    att86          att88          att90          att92          att94           att96           att98          att00          att02          att04          att06           att08           att10          att12          att14          att16        att16;
   array sust    {17}    sust86         sust88         sust90         sust92         sust94          sust96          sust98         sust00         sust02         sust04         sust06          sust08          sust10         sust12         sust14         sust16       sust18;
   array psust   {17}    psust86        psust88        psust90        psust92        psust94         psust96         psust98        psust00        psust02        psust04        psust06         psust08         psust10        psust12        psust14        psust16      psust18;

   array fhxcanc {17}    cafh86         cafh86         cafh90         cafh92         cafh92          cafh96          cafh96         cafh96         cafh96         cafh96         cafh96          cafh08          cafh08         cafh12         cafh12         cafh12       cafh12;
   array fhxcvd  {17}    cvdfh86        cvdfh86        cvdfh86        cvdfh86        cvdfh86         cvdfh96         cvdfh96        cvdfh96        cvdfh96        cvdfh96        cvdfh96         cvdfh96         cvdfh96        cvdfh96        cvdfh96        cvdfh96      cvdfh96;
   array fhxdb   {17}    dbfh87         dbfh87         dbfh90         dbfh92         dbfh92          dbfh92          dbfh92         dbfh92         dbfh92         dbfh92         dbfh92          dbfh08          dbfh08         dbfh08         dbfh08         dbfh08       dbfh08;
   array chol    {17}    chol86         chol88         chol90         chol92         chol94          chol96          chol98         chol00         chol02         chol04         chol06          chol08          chol10         chol12         chol14         chol16       chol18;
   array hbp     {17}    hbp86          hbp88          hbp90          hbp92          hbp94           hbp96           hbp98          hbp00          hbp02          hbp04          hbp06           hbp08           hbp10          hbp12          hbp14          hbp16        hbp18;
   array repang  {17}    ang86          ang88          ang90          ang92          ang94           ang96           ang98          ang00          ang02          ang04          ang06           ang08           ang10          ang12          ang14          ang16        ang18;     
   array repcabg {17}    cabg86         cabg88         cabg90         cabg92         cabg94          cabg96          cabg98         cabg00         cabg02         cabg04         cabg06          cabg08          cabg10         cabg12         cabg14         cabg16       cabg18; 


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

data age_hpfs_long;
set age_cohort;
keep id age_new actcon;
run;

/*
ods listing close;
ods pdf file='hpfs_act_age_spline.pdf';
proc sgplot data=age_hpfs_long;
title1 "Physical activity during adulthood in the HPFS";
PBSPLINE x=age_new y=actcon/NOMARKERS CLM;
XAXIS values=(35 to 110 by 5) label="Age, years";
YAXIS values=(0 to 40 by 5) label="Physical activity, MET-hour/week";
run;
ods pdf close;
ods listing;

endsas;
*/
