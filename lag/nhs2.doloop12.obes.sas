%include '/udd/hpzfa/review/PA/nhs2.main.sas'; 

data pre_pm;
     set base  end=_end_;

      array retmo   {17} retmo89       retmo91       retmo93       retmo95       retmo97       retmo99       retmo01       retmo03       retmo05       retmo07       retmo09       retmo11       retmo13       retmo15      retmo17     retmo19   cutoff;           
      array irt     {17} irt88         irt90         irt92         irt94         irt96         irt98         irt00         irt02         irt04         irt06         irt08         irt10         irt12         irt14        irt16       irt18     cutoff;
      array tvar    {16} t88           t90           t92           t94           t96           t98           t00           t02           t04           t06           t08           t10           t12           t14          t16         t18;
      array period  {16} period1       period2       period3       period4       period5       period6       period7       period8       period9       period10      period11      period12      period13      period14     period15    period16;     
      array age     {16} age89         age91         age93         age95         age97         age99         age01         age03         age05         age07         age09         age11         age13         age15        age17       age19;
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
  
      * add lagged years;
      array tvar4 {*} t92 t94 t96 t98 t00 t02 t04 t06 t08 t10 t12 t14 t16 t18; /* Indicator variables for time period - initialize to 0 */
      array tvar8 {*} t96 t98 t00 t02 t04 t06 t08 t10 t12 t14 t16 t18; /* Indicator variables for time period - initialize to 0 */
      array tvar12 {*} t00 t02 t04 t06 t08 t10 t12 t14 t16 t18; /* Indicator variables for time period - initialize to 0 */
      array irt4a {*} irt92 irt94 irt96 irt98 irt00 irt02 irt04 irt06 irt08 irt10 irt12 irt14 irt16 irt18 cutoff;
      array irt8a {*} irt96 irt98 irt00 irt02 irt04 irt06 irt08 irt10 irt12 irt14 irt16 irt18 cutoff;
      array irt12a {*} irt00 irt02 irt04 irt06 irt08 irt10 irt12 irt14 irt16 irt18 cutoff;
      array period4a {*} period1 period2 period3 period4 period5 period6 period7 period8 period9 period10 period11 period12 period13 period14;
      array period8a {*} period1 period2 period3 period4 period5 period6 period7 period8 period9 period10 period11 period12;
      array period12a {*} period1 period2 period3 period4 period5 period6 period7 period8 period9 period10;

      /****** rtmnyr to irt ******/
      do c=1 to 16;
      irt{c}=retmo{c};
      end; drop c;
   
  
/*** Set cutoff at 2021 June 30 ***/
/*************************************************************************
***** If an irt date is before June of that qq year or after or equal ****
***** to the next qq year it is incorrect and should be defaulted to  ****
***** June of that qq year.    Make time period indicator tvar=0.     ****
*************************************************************************/
 
 cutoff=1458;    
   do i=1 to DIM(irt)-1;
      if (irt{i}<(1050+24*i) | irt{i}>=(1074+24*i)) then irt{i}=1050+24*i;   /*1989*/
   end;


%beginex();

/********* DO LOOP OVER TIME PERIOD **************/

 do i=1 to DIM(irt12a)-1;     
      interval=i;
      do j=1 to DIM(tvar12);
         tvar12{j}=0;
         period12a{j}=0;
      end;
      tvar12{i}=1; 
      period12a{i}=1;

* follow from baseline to diagnosis (incident analysis) *;
obes_cav=0; 
pt_obesca=irt12a{i+1}-irt12a{i};
if  obes_ca=1 and irt12a{i}<dt_obesca<=irt12a{i+1} then do;
    obes_cav=1; pt_obesca=dt_obesca-irt12a{i};
end;
if irt12a{i}<=dtdth<irt12a{i+1} then pt_obesca=min(pt_obesca,dtdth-irt12a{i});


/********************* main exposures **********************/

/* DEFINE AGE */ 
      agecon=age{i}; /* in years */
      agemos=int((irt{i}-birthday)); /* in months */

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
      else bmicat=0;
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

/* MENOPAUSE & HORMONE USE */
      phmsstatus=pmha{i};
%indic3(vbl=phmsstatus, prefix=phmsstatus, min=2, max=4, reflev=1, missing=9, usemiss=1,      
                        label1='pre mnp',      
                        label2='never/unknown pmhuser, post mnp',      
                        label3='past pmh user and post mnp',      
                        label4='curr pmhuser and post mnp');  

/*** OC use ***/
        select(oc{i}); 
          when (1)     ocu=1;  
          when (2)     ocu=2;  
          when (3)     ocu=3;  
          when (4)     ocu=1; 
          otherwise    ocu=1; 
          end;       /*set missing category as never users*/
%indic3(vbl=ocu, prefix=ocu, min=2, max=3, reflev=1,  missing=., usemiss=0, 
                 label1='never OC', 
                 label2='past OC', 
                 label3='current OC');


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
 
      /****** Indicator for History of High Blood Pressure *******/
            select(hbp{i});
                when (1)     htn=1;
      	         otherwise    htn=0;
            end;
                      
      /****** Indicator for History of High TC ******/
            select(chol{i});
                when (1)     hchol=1;
      	         otherwise    hchol=0;
            end;

      /****** Indicator for History of selfreport heart disease MI & Angina ******/
            select(repang{i});
                when (1)     angina=1;
      	         otherwise    angina=0;
            end;

      /****** Indicator for History of selfreport cabg ******/
            select(repcabg{i});
                when (1)     cabg=1;
      	         otherwise    cabg=0;
            end;

       if dtdth in (0,., 9999) then dtdth=.; 


  /************************  BASELINE EXCLUSIONS ********************************/
  
   if i=1 then do;

       %exclude(exrec eq 1);                 *multiple records and not in master file; 
       %exclude(birthday eq . );             *missing date of birth;
       %exclude(age89 eq .); 
    
       %exclude(act89m eq .);

       %exclude(can01 eq 1);
       %exclude(mi01 eq 1);
       %exclude(str01 eq 1);
       %exclude(db01 eq 1);
 
       %exclude(0 lt dtdth le irt12a{i});
       %exclude(0 lt dt_totcancer le irt12a{i});
       %exclude(0 lt dt_cvd le irt12a{i});
       %exclude(0 lt dt_diab le irt12a{i});

   %output();

     end;


/***************  Each questionnaire cycle exclusions *****************/
   else if i>1 then do;

       %exclude(irt12a{i-1} le dtdth lt irt12a{i});
       %exclude(irt12a{i-1} lt dt_obesca le irt12a{i});

   %output();
     end;

 end; /* END OF DO-LOOP OVER TIME PERIODs */
      
   %endex();

run;

proc datasets nolist; delete base ; run;   


                            ***
                        ***     ***
                    ***            ***
                ***    data-nhs2    ***
                    ***            ***
                        ***     ***
                            ***;

data nhs2data;
set pre_pm end=_end_;
cohort=3;
sex=1;
id=300000000+id;  
interval_b=interval+1;
keep 
 id cohort interval interval_b sex cutoff dtdth agecon agegp &agegp_ agemos
 /*irt86 irt88 irt90 irt92 irt94 irt96 irt98*/ irt00 irt02 irt04 irt06 irt08 irt10 irt12 irt14 irt16 irt18
 /*t86 t88 t90 t92 t94 t96 t98*/ t00 t02 t04 t06 t08 t10 t12 t14 t16 t18
 period1-period10
 
 obes_ca     obes_cav     pt_obesca     dt_obesca       

 actcon   actcat     attain    actsim        
          &actcat_   sustain 

 bmicon   bmicat     alcocon    alcc      aheiconv    smkst      smkpy     packy     mvit      phmsstatus
          &bmicat_              &alcc_                &smkst_    &smkpy_                       &phmsstatus_                                 

 regaspa  regibuia   white    cafh    dbfh    cvdfh    hchol    htn    angina    cabg          
; 
run;


proc sort; by interval; run;

proc rank data=nhs2data out=nhs2data group=4;
by interval;
var   aheiconv  ;
ranks aheiq ;
run;

proc rank data=nhs2data out=nhs2data group=4;
var   sustain   actsim   actcon;
ranks sustainq  actsimq  actq;
run;
