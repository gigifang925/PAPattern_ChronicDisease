%include '/udd/hpzfa/review/PA/hpfs.main.sas'; 

data pre_pm;
     set base  end=_end_;
   
   array rtmnyr  {16}    rtmnyr86       rtmnyr88       rtmnyr90       rtmnyr92       rtmnyr94        rtmnyr96        rtmnyr98       rtmnyr00       rtmnyr02       rtmnyr04       rtmnyr06        rtmnyr08        rtmnyr10       rtmnyr12       rtmnyr14       cutoff; 
   array irt     {16}    irt86          irt88          irt90          irt92          irt94           irt96           irt98          irt00          irt02          irt04          irt06           irt08           irt10          irt12          irt14          cutoff;
   array tvar    {15}    t86            t88            t90            t92            t94             t96             t98            t00            t02            t04            t06             t08             t10            t12            t14            ;
   array period  {15}    period1        period2        period3        period4        period5         period6         period7        period8        period9        period10       period11        period12        period13       period14       period15       ; 
   
   array age     {15}    age86          age88          age90          age92          age94           age96           age98          age00          age02          age04          age06           age08           age10          age12          age14          ;
   array mar     {15}    marital86      marital88      marital90      marital92      marital94       marital96       marital98      marital00      marital02      marital04      marital06       marital08       marital10      marital12      marital14      ;   
   array bmi     {15}    bmi86          bmi88          bmi90          bmi92          bmi94           bmi96           bmi98          bmi00          bmi02          bmi04          bmi06           bmi08           bmi10          bmi12          bmi14          ;
   array bmiv    {15}    bmi86v         bmi88v         bmi90v         bmi92v         bmi94v          bmi96v          bmi98v         bmi00v         bmi02v         bmi04v         bmi06v          bmi08v          bmi10v         bmi12v         bmi14v         ;
   array smok    {15}    smoke86        smoke88        smoke90        smoke92        smoke94         smoke96         smoke98        smoke00        smoke02        smoke04        smoke06         smoke08         smoke10        smoke12        smoke14        ;
   array pkyr    {15}    pckyr86        pckyr88        pckyr90        pckyr92        pckyr94         pckyr96         pckyr98        pckyr00        pckyr02        pckyr04        pckyr06         pckyr08         pckyr10        pckyr12        pckyr14        ; 
   array cig     {15}    cgnm86         cgnm88         cgnm90         cgnm92         cgnm94          cgnm96          cgnm98         cgnm00         cgnm02         cgnm04         cgnm06          cgnm08          cgnm10         cgnm12         cgnm14         ;
   array alcon   {15}    alco86n        alco86n        alco90n        alco90n        alco94n         alco94n         alco98n        alco98n        alco02n        alco02n        alco06n         alco06n         alco10n        alco10n        alco10n        ;  
   array alconv  {15}    alco86nv       alco86nv       alco90nv       alco90nv       alco94nv        alco94nv        alco98nv       alco98nv       alco02nv       alco02nv       alco06nv        alco06nv        alco10nv       alco10nv       alco10nv       ;  
   array ahei    {15}    nAHEI86a       nAHEI86a       nAHEI90a       nAHEI90a       nAHEI94a        nAHEI94a        nAHEI98a       nAHEI98a       nAHEI02a       nAHEI02a       nAHEI06a        nAHEI06a        nAHEI10a       nAHEI10a       nAHEI14a       ;  
   array aheiv   {15}    ahei86v        ahei86v        ahei90v        ahei90v        ahei94v         ahei94v         ahei98v        ahei98v        ahei02v        ahei02v        ahei06v         ahei06v         ahei10v        ahei10v        ahei14v        ;  
   array aspa    {15}    regaspre86     regaspre88     regaspre90     regaspre92     regaspre94      regaspre96      regaspre98     regaspre00     regaspre02     regaspre04     regaspre06      regaspre08      regaspre10     regaspre12     regaspre14     ;
   array ibuia   {15}    regibui86      regibui88      regibui90      regibui92      regibui94       regibui96       regibui98      regibui00      regibui02      regibui04      regibui06       regibui08       regibui10      regibui12      regibui14      ;   
   array mvyn    {15}    mvt86          mvt88          mvt90          mvt92          mvt94           mvt96           mvt98          mvt00          mvt02          mvt04          mvt06           mvt08           mvt10          mvt12          mvt14          ;

   array actm    {15}    act86          act88          act90          act92          act94           act96           act98          act00          act02          act04          act06           act08           act10          act12          act14          ;
   array actmv   {15}    act86v         act88v         act90v         act92v         act94v          act96v          act98v         act00v         act02v         act04v         act06v          act08v          act10v         act12v         act14v         ;      
   array actbin  {15}    att86          att88          att90          att92          att94           att96           att98          att00          att02          att04          att06           att08           att10          att12          att14          ;
   array acts    {15}    act86s         act88s         act90s         act92s         act94s          act96s          act98s         act00s         act02s         act04s         act06s          act08s          act10s         act12s         act14s         ; 
   array sust    {15}    sust86         sust88         sust90         sust92         sust94          sust96          sust98         sust00         sust02         sust04         sust06          sust08          sust10         sust12         sust14         ;
   array psust   {15}    psust86        psust88        psust90        psust92        psust94         psust96         psust98        psust00        psust02        psust04        psust06         psust08         psust10        psust12        psust14        ;

   array fhxcanc {15}    cafh86         cafh86         cafh90         cafh92         cafh92          cafh96          cafh96         cafh96         cafh96         cafh96         cafh96          cafh08          cafh08         cafh12         cafh12         ;
   array fhxcvd  {15}    cvdfh86        cvdfh86        cvdfh86        cvdfh86        cvdfh86         cvdfh96         cvdfh96        cvdfh96        cvdfh96        cvdfh96        cvdfh96         cvdfh96         cvdfh96        cvdfh96        cvdfh96        ;
   array fhxdb   {15}    dbfh87         dbfh87         dbfh90         dbfh92         dbfh92          dbfh92          dbfh92         dbfh92         dbfh92         dbfh92         dbfh92          dbfh08          dbfh08         dbfh08         dbfh08         ;
   array chol    {15}    chol86         chol88         chol90         chol92         chol94          chol96          chol98         chol00         chol02         chol04         chol06          chol08          chol10         chol12         chol14         ;
   array hbp     {15}    hbp86          hbp88          hbp90          hbp92          hbp94           hbp96           hbp98          hbp00          hbp02          hbp04          hbp06           hbp08           hbp10          hbp12          hbp14          ;
   array repang  {15}    ang86          ang88          ang90          ang92          ang94           ang96           ang98          ang00          ang02          ang04          ang06           ang08           ang10          ang12          ang14          ;     
   array repcabg {15}    cabg86         cabg88         cabg90         cabg92         cabg94          cabg96          cabg98         cabg00         cabg02         cabg04         cabg06          cabg08          cabg10         cabg12         cabg14         ; 
 
   * add lagged years;
   array tvar4 {*} t90 t92 t94 t96 t98 t00 t02 t04 t06 t08 t10 t12 t14; /* Indicator variables for time period - initialize to 0 */
   array tvar8 {*} t94 t96 t98 t00 t02 t04 t06 t08 t10 t12 t14; /* Indicator variables for time period - initialize to 0 */
   array tvar12 {*} t98 t00 t02 t04 t06 t08 t10 t12 t14; /* Indicator variables for time period - initialize to 0 */
   array irt4a {*} irt90 irt92 irt94 irt96 irt98 irt00 irt02 irt04 irt06 irt08 irt10 irt12 irt14 cutoff;
   array irt8a {*} irt94 irt96 irt98 irt00 irt02 irt04 irt06 irt08 irt10 irt12 irt14 cutoff;
   array irt12a {*} irt98 irt00 irt02 irt04 irt06 irt08 irt10 irt12 irt14 cutoff;
   array period4a {*} period1 period2 period3 period4 period5 period6 period7 period8 period9 period10 period11 period12 period13;
   array period8a {*} period1 period2 period3 period4 period5 period6 period7 period8 period9 period10 period11;
   array period12a {*} period1 period2 period3 period4 period5 period6 period7 period8 period9;

   
/*** Set cutoff at 2016 Jan 31 ***/
/*************************************************************************
***** If an irt date is before June of that qq year or after or equal ****
***** to the next qq year it is incorrect and should be defaulted to  ****
***** Jan of that qq year.    Make time period indicator tvar=0.     ****
*************************************************************************/

 cutoff=1393;    
   do i=1 to DIM(irt)-1; 
      if (irt{i}<(1009+24*i) | irt{i}>=(1033+24*i)) then irt{i}=1009+24*i;    /*1986*/
   end;  


%beginex();

************************* Do-Loop over time periods ****************************;
  
 do i=1 to DIM(irt12a)-1;
    interval=i;
      do j=1 to DIM(tvar12);
         tvar12{j}=0;
         period12a{j}=0;
      end;
    tvar12{i}=1;
    period12a{i}=1;
    
* follow from baseline to diagnosis (incident analysis) *;
cvdv=0; 
pt_cvd=irt12a{i+1}-irt12a{i};
if  cvd=1 and irt12a{i}<dt_cvd<=irt12a{i+1} then do;
    cvdv=1; pt_cvd=dt_cvd-irt12a{i};
end;
if irt12a{i}<=dtdth<irt12a{i+1} then pt_cvd=min(pt_cvd,dtdth-irt12a{i});
  

/********************* Exposures & Covariates **********************/
                        
/* DEFINE AGE */ 
      agemos=int((irt{i}-dbmy09)); /* in months */
      agecon=age{i}; /* in year */ 

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
      else bmicat=2;
%indic3(vbl=bmicat, prefix=bmicat, min=0, max=4, reflev=1, missing=., usemiss=0,
                label1='<23.0',
                label2='23.0-24.9',
                label3='25-29.9',
                label4='30-34.9',
      	       label5='35+');

/* EXERCISE */
      actcon=actmv{i};
      if actcon<3 then actcat=1;                                            /*categorical PA*/
      else if actcon>=3 and actcon<9 then actcat=2;
      else if actcon>=9 and actcon<18 then actcat=3;
      else if actcon>=18 and actcon<27 then actcat=4;
      else if actcon>=27 then actcat=5;
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
      else if aspa{i}=1  then  regaspa=0;
      
      if ibuia{i}=2       then  regibuia=1;
      else if ibuia{i}=1  then  regibuia=0;

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
        select(mvyn{i});
                when (1)     mvit=1;
      	         otherwise    mvit=0;
        end;       

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
     
     /****** History of High Blood Pressure *******/
            select(hbp{i});
                when (1)     htn=1;
      	         otherwise    htn=0;
            end;
       
     /****** History of High TC ******/
            select(chol{i});
                when (1)     hchol=1;
      	         otherwise    hchol=0;
            end;

     /****** History of selfreport heart disease MI & Angina ******/
            select(repang{i});
                when (1)     angina=1;
      	         otherwise    angina=0;
            end;

     /****** History of CABG ******/
            select(repcabg{i});
                when (1)     cabg=1;
      	         otherwise    cabg=0;
            end;
               
       if dtdth in (0,., 9999) then dtdth=.; 
       if white ne 1 then white=0;


/****************  BASELINE EXCLUSIONS ********************************************/
   if i=1 then do;

   %exclude(exrec eq 1);                 /*multiple records and not in master file*/
   %exclude(dbmy09 le 0); 
   %exclude(age86 eq .);

   %exclude(act86 eq .); 

   %exclude(can98 eq 1);
   %exclude(mi98 eq 1);
   %exclude(str98 eq 1);
   %exclude(db98 eq 1);

   %exclude(0 lt dtdth le irt12a{i});
   %exclude(0 lt dt_totcancer le irt12a{i});
   %exclude(0 lt dt_cvd le irt12a{i});
   %exclude(0 lt dt_diab le irt12a{i});
  
   %output();

     end;

/***************  Each questionnaire cycle exclusions *****************/
   else if i>1 then do;

       %exclude(irt12a{i-1} le dtdth lt irt12a{i});
       %exclude(irt12a{i-1} le dt_cvd lt irt12a{i});

       %output();
     end;

 end;   /* END OF DO-LOOP OVER TIME PERIODs */   
            
   %endex();

run;


proc datasets nolist; delete base; run;


                            ***
                        ***     ***
                    ***            ***
                ***    data-hpfs    ***
                    ***            ***
                        ***     ***
                            ***;

data hpfsdata;
set pre_pm end=_end_;
cohort=2;
sex=2;
id=200000000+id;  
interval_b=interval;
phmsstatus=1;  /*male premenopausal*/  
%indic3(vbl=phmsstatus, prefix=phmsstatus, min=2, max=4, reflev=1, missing=., usemiss=1,      
                     label1='pre mnp',      
                     label2='never/unknown pmhuser, post mnp',      
                     label3='curr pmh user and post mnp',      
                     label4='past pmhuser and post mnp');
keep 
 id cohort interval interval_b sex cutoff dtdth agecon agegp &agegp_ agemos
 /*irt86 irt88 irt90 irt92 irt94 irt96*/ irt98 irt00 irt02 irt04 irt06 irt08 irt10 irt12 irt14
 /*t86 t88 t90 t92 t94 t96*/ t98 t00 t02 t04 t06 t08 t10 t12 t14
 period1-period9
 
 cvd       dt_cvd     cvdv     pt_cvd
 
 actcon   actcat     attain    actsum    actsim   
          &actcat_   sustain 

 bmicon   bmicat     alcocon    alcc      aheiconv    smkst      smkpy      packy     mvit      phmsstatus
          &bmicat_              &alcc_                &smkst_    &smkpy_                        &phmsstatus_                                 

 regaspa  regibuia   white    cafh    dbfh    cvdfh    hchol    htn    angina    cabg          
; 
run;


proc sort; by interval; run;

proc rank data=hpfsdata out=hpfsdata group=4;
by interval;
var   aheiconv;
ranks aheiq;
run;

proc rank data=hpfsdata out=hpfsdata group=4;
var   sustain    actsim    actcon;
ranks sustainq   actsimq   actq;
run; 

