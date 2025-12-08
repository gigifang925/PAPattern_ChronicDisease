/* This program was updated based on the code developed by Mingyang Song for the project 
'Long-term status and change of body fat distribution, and risk of colorectal cancer: a prospective cohort study */
*--- Goal: Compute the trend of physical activity by age;


%include '/udd/hpzfa/review/PA/nhs2.main.sas'; 

proc sort data=base; by id; run;

data base;
set base;
by id;
DXage_chronic=int((dt_chr-birthday)/12);	/*age of major chronic disease diagnosis*/
DXage_canc=int((dt_totcancer-birthday)/12);
DXage_cvd=int((dt_cvd-birthday)/12);
DXage_tb=int((dt_diab-birthday)/12);
DXage_death=int((dtdth-birthday)/12);

/*minimum age of major chronic disease diagnosis */
DXage_min=min(DXage_chronic, DXage_canc, DXage_cvd, DXage_tb, DXage_death);

/*exclude participants who had major chronic disease diagnosis at baseline*/
if exrec eq 1 or birthday eq . or age89 eq . or act89m eq . or  can89 eq 1 or mi89 eq 1 or str89 eq 1 or db89 eq 1 then delete;
if DXage_min ne . and DXage_min<=age89 then delete;
run;


data age_cohort;
set base;

      array agec    {16} age89         age91         age93         age95         age97         age99         age01         age03         age05         age07         age09         age11         age13         age15        age17       age19;
      array age     {17} age89         age89         age91         age93         age95         age97         age99         age01         age03         age05         age07         age09         age11         age13        age15       age17      age19;

      array bmi     {16} bmi89         bmi91         bmi93         bmi95         bmi97         bmi99         bmi01         bmi03         bmi05         bmi07         bmi09         bmi11         bmi13         bmi15        bmi17       bmi19;
      array bmiv    {16} bmi89v        bmi91v        bmi93v        bmi95v        bmi97v        bmi99v        bmi01v        bmi03v        bmi05v        bmi07v        bmi09v        bmi11v        bmi13v        bmi15v       bmi17v      bmi19v;
      array smkdr   {16} smkdr89       smkdr91       smkdr93       smkdr95       smkdr97       smkdr99       smkdr01       smkdr03       smkdr05       smkdr07       smkdr09       smkdr11       smkdr13       smkdr15      smkdr17     smkdr19;
      array smok    {16} smoke89       smoke91       smoke93       smoke95       smoke97       smoke99       smoke01       smoke03       smoke05       smoke07       smoke09       smoke11       smoke13       smoke15      smoke17     smoke19;
      array pkyr    {16} pkyr89        pkyr91        pkyr93        pkyr95        pkyr97        pkyr99        pkyr01        pkyr03        pkyr05        pkyr07        pkyr09        pkyr11        pkyr13        pkyr15       pkyr17      pkyr19; 
      array alcon   {16} alco91n       alco91n       alco91n       alco95n       alco95n       alco99n       alco99n       alco03n       alco03n       alco07n       alco07n       alco11n       alco11n       alco15n      alco15n     alco19n;     
      array alconv  {16} alco91nv      alco91nv      alco91nv      alco95nv      alco95nv      alco99nv      alco99nv      alco03nv      alco03nv      alco07nv      alco07nv      alco11nv      alco11nv      alco15nv     alco15nv    alco19nv;     
      array ahei    {16} ahei2010_91   ahei2010_91   ahei2010_91   ahei2010_95   ahei2010_95   ahei2010_99   ahei2010_99   ahei2010_03   ahei2010_03   ahei2010_07   ahei2010_07   ahei2010_11   ahei2010_11   ahei2010_15  ahei2010_15 ahei2010_19;
      array aheiv   {16} ahei91v       ahei91v       ahei91v       ahei95v       ahei95v       ahei99v       ahei99v       ahei03v       ahei03v       ahei07v       ahei07v       ahei11v       ahei11v       ahei15v      ahei15v     ahei19v;  
      array aspa    {16} regaspre89    regaspre89    regaspre93    regaspre95    regaspre97    regaspre99    regaspre01    regaspre03    regaspre05    regaspre07    regaspre09    regaspre11    regaspre13    regaspre15   regaspre17  regaspre17;
      array ibuia   {16} regibui89     regibui89     regibui93     regibui95     regibui97     regibui99     regibui01     regibui03     regibui05     regibui07     regibui09     regibui11     regibui13     regibui15    regibui17   regibui17;   
      array pmha    {16} pmh89         pmh91         pmh93         pmh95         pmh97         pmh99         pmh01         pmh03         pmh05         pmh07         pmh09         pmh11         pmh13         pmh15        pmh17       pmh19; 
      array mvyn    {16} mvyn89        mvyn91        mvyn93        mvyn95        mvyn97        mvyn99        mvyn01        mvyn03        mvyn05        mvyn07        mvyn09        mvyn11        mvyn13        mvyn15       mvyn17      mvyn19; 
      array oc      {16} nocu89        nocu91        nocu93        nocu95        nocu97        nocu99        nocu01        nocu03        nocu05        nocu07        nocu09        nocu11        nocu11        nocu11       nocu11      nocu11; 
    
      array actm    {16} act89m        act91m        act91m        act91m        act97m        act97m        act01m        act01m        act05m        act05m        act09m        act09m        act13m        act13m       act17m      act17m;             
      array actmv   {16} act89v        act91v        act91v        act91v        act97v        act97v        act01v        act01v        act05v        act05v        act09v        act09v        act13v        act13v       act17v      act17v;
      array acts    {16} act89s        act91s        act93s        act95s        act97s        act99s        act01s        act03s        act05s        act07s        act09s        act11s        act13s        act15s       act17s      act19s;
      array actbin  {16} att89         att91         att91         att91         att97         att97         att01         att01         att05         att05         att09         att09         att13         att13        att17       att17;
      array sust    {16} sust89        sust91        sust93        sust95        sust97        sust99        sust01        sust03        sust05        sust07        sust09        sust11        sust13        sust15       sust17      sust19;
      array psust   {16} psust89       psust91       psust93       psust95       psust97       psust99       psust01       psust03       psust05       psust07       psust09       psust11       psust13       psust15      psust17     psust19;

      array fhxcanc {16} cafh89        cafh89        cafh93        cafh93        cafh97        cafh97        cafh01        cafh01        cafh05        cafh05        cafh09        cafh09        cafh13        cafh13       cafh13      cafh13;
      array fhxcvd  {16} cvdfh89       cvdfh89       cvdfh93       cvdfh93       cvdfh97       cvdfh97       cvdfh01       cvdfh01       cvdfh05       cvdfh05       cvdfh09       cvdfh09       cvdfh13       cvdfh13      cvdfh13     cvdfh13;
      array fhxdb   {16} dbfh89        dbfh89        dbfh89        dbfh89        dbfh97        dbfh97        dbfh01        dbfh01        dbfh05        dbfh05        dbfh09        dbfh09        dbfh13        dbfh13       dbfh13      dbfh13;
      array chol    {16} chol89        chol91        chol93        chol95        chol97        chol99        chol01        chol03        chol05        chol07        chol09        chol11        chol13        chol15       chol17      chol19;
      array hbp     {16} hbp89         hbp91         hbp93         hbp95         hbp97         hbp99         hbp01         hbp03         hbp05         hbp07         hbp09         hbp11         hbp13         hbp15        hbp17       hbp19;
      array repang  {16} ang91         ang91         ang93         ang95         ang97         ang99         ang01         ang03         ang05         ang07         ang09         ang11         ang13         ang15        ang17       ang19;     
      array repcabg {16} cabg91        cabg91        cabg93        cabg95        cabg97        cabg99        cabg01        cabg03        cabg05        cabg07        cabg09        cabg11        cabg13        cabg15       cabg17      cabg19;           

/*TRANSFORM THE DATASET: from wide to long format (1 observation/2-year age)*/ 
do i=1 to 16;
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

data age_nhs2_long;
set age_cohort;
keep id age_new actcon;
run;

/*
ods listing close;
ods pdf file='nhs2_act_age_spline.pdf';
proc sgplot data=age_nhs2_long;
title1 "Physical activity during adulthood in the NHSII";
PBSPLINE x=age_new y=actcon/NOMARKERS CLM;
XAXIS values=(23 25 to 75 by 5) label="Age, years";
YAXIS values=(0 to 40 by 5) label="Physical activity, MET-hour/week";
run;
ods pdf close;
ods listing;

endsas;
*/
