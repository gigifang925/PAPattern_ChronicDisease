%include '/udd/hpzfa/review/PA/nhs2.main.sas';

data base;
set base;

array retmo {16} retmo89  retmo91  retmo93  retmo95  retmo97  retmo99  retmo01  retmo03  retmo05  retmo07  retmo09  retmo11  retmo13  retmo15   retmo17   retmo19;           
array irt   {16} irt88    irt90    irt92    irt94    irt96    irt98    irt00    irt02    irt04    irt06    irt08    irt10    irt12    irt14     irt16     irt18;

do i=1 to DIM(retmo);
      irt{i}=retmo{i};
      if (irt{i}<(1050+24*i) | irt{i}>=(1074+24*i)) then irt{i}=1050+24*i;   /*1989 June 30*/
end;

DXage_chronic=int((dt_chr-birthday)/12);	/*age of major chronic disease diagnosis*/
DXage_death=int((dtdth-birthday)/12);
DXage_min=min(DXage_chronic, DXage_death);
EVENTtime_min=min(dtdth, dt_chr);
EVENTtime_cvd=min(dtdth, dt_cvd);
EVENTtime_db=min(dtdth, dt_diab);
EVENTtime_canc=min(dtdth, dt_totcancer);
EVENTtime_obes=min(dtdth, dt_obesca);
EVENTtime_phy=min(dtdth, dt_phyca);

/**** BASELINE EXCLUSION ****/
if exrec eq 1 then delete;
if birthday eq . then delete;
if age89 eq . then delete;
if act89m eq . then delete;

if can89 eq 1 then delete;   
if mi89 eq 1 then delete; 
if str89 eq 1 then delete;
if db89 eq 1 then delete;
if 0<dt_chr<=irt88  then delete;          
if 0<dtdth<=irt88 then delete;           
if 0<dt_totcancer<=irt88 then delete;
if 0<dt_cvd<=irt88 then delete;
if 0<dt_diab<=irt88 then delete;

/**** EXCLUSION: THOSE WHO DIED OR HAD OUTCOME BEFORE AGE50 ****/
*if DXage_min>0 and DXage_min<60 then delete;

drop  act89m   act91m   act97m   act01m   act05m   act09m   act13m   act17m;
run;

/*
proc means n nmiss min max median mean p10 p25 p75 p90 ;
var age89;
run;

                               Analysis Variable : age89 age at 1989 qq return
 
       N  N Miss       Minimum       Maximum        Median          Mean     10th Pctl     25th Pctl     75th Pctl     90th Pctl
  ------------------------------------------------------------------------------------------------------------------------------
  113120       0    24.0000000    44.0000000    34.0000000    34.3265028    28.0000000    31.0000000    38.0000000    41.0000000
  ------------------------------------------------------------------------------------------------------------------------------

proc means n nmiss min max mean median;
var dtdth dt_chr EVENTtime_min dt_cvd EVENTtime_cvd dt_totcancer EVENTtime_canc dt_diab EVENTtime_db ;
run;
*/


%act8917(keep = id act89m act91m act97m act01m act05m act09m act13m act17m);
                 array actm{*} act89m   act91m   act97m   act01m   act05m   act09m   act13m   act17m;
                 do i=1 to 8;
                 if actm{i}>=997 then actm{i}=.;
                 end; drop i;
run;


data short;
     merge base(in=main) act8917;
     by id;
     if first.id and main;

     age_40=40;
     age_44=44;
     age_48=48;
     age_52=52;
     age_56=56;
     age_60=60;
     
     %macro fup(dtime, mintime, fup_len, irt);
     if (&dtime ne . or dtdth ne .) and &mintime gt &irt then &fup_len=&mintime-&irt;
     else if (&dtime ne . or dtdth ne .) and &mintime le &irt then &fup_len=.; 
     else &fup_len=1458-&irt;	/* END of follow-up = June 30, 2021 */
     %mend;

     if age89=44 then do;
        act_40=.; /*1985*/
        act_44=act89m; /*1989*/
        act_48=act91m; /*1993*/
        act_52=act97m; /*1997*/
        act_56=act01m; /*2001*/
        act_60=act05m; /*2005*/
        
        %fup(dt_chr, EVENTtime_min, fupmos, irt04);
        %fup(dt_cvd, EVENTtime_cvd, fupmos_cvd, irt04);
        %fup(dt_totcancer, EVENTtime_canc, fupmos_canc, irt04);
        %fup(dt_diab, EVENTtime_db, fupmos_db, irt04);
        %fup(dt_obesca, EVENTtime_obes, fupmos_obes, irt04);
        %fup(dt_phyca, EVENTtime_phy, fupmos_phy, irt04);

        agecon=age05; alcocon=alco03nv; aheicon=ahei03v; phmsstatus=pmh05; packy=pkyr05; smkst=smoke05; bmicon=bmi05;
        if regaspre05=2 then regaspa=1; else if regaspre05=1 then regaspa=0;
        if regibui05=2 then regibuia=1; else if regibui05=1 then regibuia=0;
        if smoke05=1 then smkpy=1;
        else if smoke05=2 then do;
                if 0<pkyr05<10         then smkpy=2;
                else if 10<=pkyr05<20  then smkpy=3;
                else if 20<=pkyr05<40  then smkpy=4;
                else if 40<=pkyr05<998 then smkpy=5;
                else smkpy=.;
        end;
        else if smoke05=3 then do;
                if 0<pkyr05<25         then smkpy=6;
                else if 25<=pkyr05<45  then smkpy=7;
                else if 45<=pkyr05<65  then smkpy=8;
                else if 65<=pkyr05<998 then smkpy=9;
                else smkpy=.;
        end; 
        else smkpy=.;

        if mvyn05=1 then mvit=1; else mvit=0;
        if cafh05=1 then cafh=1; else cafh=0;
        if cvdfh05=1 then cvdfh=1; else cvdfh=0;
        if dbfh05=1 then dbfh=1; else dbfh=0;
     end;


     if age89=43 then do;
        act_40=act89m; /*1986*/
        act_44=mean(act89m, act91m); /*1990*/
        act_48=mean(act91m, act97m); /*1994*/
        act_52=mean(act97m, act01m); /*1998*/
        act_56=mean(act01m, act05m); /*2002*/
        act_60=mean(act05m, act09m); /*2006*/
     end;
     if age89 in (42, 41) then do;
        act_40=act89m; /*1987*/
        act_44=act91m; /*1991*/
        act_48=act97m; /*1995*/
        act_52=mean(act97m, act01m); /*1999*/
        act_56=mean(act01m, act05m); /*2003*/
        act_60=mean(act05m, act09m); /*2007*/
     end;
     if age89=40 then do;
        act_40=act89m; /*1989*/
        act_44=act91m; /*1993*/
        act_48=act97m; /*1997*/
        act_52=act01m; /*2001*/
        act_56=act05m; /*2005*/
        act_60=act09m; /*2009*/
     end;
     if age89 in (43, 42, 41, 40) then do;
        %fup(dt_chr, EVENTtime_min, fupmos, irt08);
        %fup(dt_cvd, EVENTtime_cvd, fupmos_cvd, irt08);
        %fup(dt_totcancer, EVENTtime_canc, fupmos_canc, irt08);
        %fup(dt_diab, EVENTtime_db, fupmos_db, irt08);
        %fup(dt_obesca, EVENTtime_obes, fupmos_obes, irt08);
        %fup(dt_phyca, EVENTtime_phy, fupmos_phy, irt08);
   
        agecon=age09; alcocon=alco07nv; aheicon=ahei07v; phmsstatus=pmh09; packy=pkyr09; smkst=smoke09; bmicon=bmi09;
        if regaspre09=2 then regaspa=1; else if regaspre09=1 then regaspa=0;
        if regibui09=2 then regibuia=1; else if regibui09=1 then regibuia=0;
        if smoke09=1 then smkpy=1;
        else if smoke09=2 then do;
                if 0<pkyr09<10         then smkpy=2;
                else if 10<=pkyr09<20  then smkpy=3;
                else if 20<=pkyr09<40  then smkpy=4;
                else if 40<=pkyr09<998 then smkpy=5;
                else smkpy=.;
        end;
        else if smoke09=3 then do;
                if 0<pkyr09<25         then smkpy=6;
                else if 25<=pkyr09<45  then smkpy=7;
                else if 45<=pkyr09<65  then smkpy=8;
                else if 65<=pkyr09<998 then smkpy=9;
                else smkpy=.;
        end; 
        else smkpy=.;

        if mvyn09=1 then mvit=1; else mvit=0;
        if cafh09=1 then cafh=1; else cafh=0;
        if cvdfh09=1 then cvdfh=1; else cvdfh=0;
        if dbfh09=1 then dbfh=1; else dbfh=0;
     end;

        
     if age89=39 then do;
        act_40=mean(act89m, act91m); /*1990*/
        act_44=mean(act91m, act97m); /*1994*/
        act_48=mean(act97m, act01m); /*1998*/
        act_52=mean(act01m, act05m); /*2002*/
        act_56=mean(act05m, act09m); /*2006*/
        act_60=mean(act09m, act13m); /*2010*/
     end;
     if age89 in (38, 37) then do;
        act_40=act91m; /*1991*/
        act_44=act97m; /*1995*/
        act_48=mean(act97m, act01m); /*1999*/
        act_52=mean(act01m, act05m); /*2003*/
        act_56=mean(act05m, act09m); /*2007*/
        act_60=mean(act09m, act13m); /*2011*/
     end;
     if age89=36 then do;
        act_40=act91m; /*1993*/
        act_44=act97m; /*1997*/
        act_48=act01m; /*2001*/
        act_52=act05m; /*2005*/
        act_56=act09m; /*2009*/
        act_60=act13m; /*2013*/
     end;
     if age89 in (39, 38, 37, 36) then do;
        %fup(dt_chr, EVENTtime_min, fupmos, irt12);
        %fup(dt_cvd, EVENTtime_cvd, fupmos_cvd, irt12);
        %fup(dt_totcancer, EVENTtime_canc, fupmos_canc, irt12);
        %fup(dt_diab, EVENTtime_db, fupmos_db, irt12);
        %fup(dt_obesca, EVENTtime_obes, fupmos_obes, irt12);
        %fup(dt_phyca, EVENTtime_phy, fupmos_phy, irt12);
   
        agecon=age13; alcocon=alco11nv; aheicon=ahei11v; phmsstatus=pmh13; packy=pkyr13; smkst=smoke13; bmicon=bmi13;
        if regaspre13=2 then regaspa=1; else if regaspre13=1 then regaspa=0;
        if regibui13=2 then regibuia=1; else if regibui13=1 then regibuia=0;
        if smoke13=1 then smkpy=1;
        else if smoke13=2 then do;
                if 0<pkyr13<10         then smkpy=2;
                else if 10<=pkyr13<20  then smkpy=3;
                else if 20<=pkyr13<40  then smkpy=4;
                else if 40<=pkyr13<998 then smkpy=5;
                else smkpy=.;
        end;
        else if smoke13=3 then do;
                if 0<pkyr13<25         then smkpy=6;
                else if 25<=pkyr13<45  then smkpy=7;
                else if 45<=pkyr13<65  then smkpy=8;
                else if 65<=pkyr13<998 then smkpy=9;
                else smkpy=.;
        end; 
        else smkpy=.;

        if mvyn13=1 then mvit=1; else mvit=0;
        if cafh13=1 then cafh=1; else cafh=0;
        if cvdfh13=1 then cvdfh=1; else cvdfh=0;
        if dbfh13=1 then dbfh=1; else dbfh=0;
     end;

     if white ne 1 then white=0;

     if alcocon=0.0                           then   alcc=1;
     else if alcocon>0.0   and alcocon<10.0   then   alcc=2;
     else if alcocon>=10.0  and alcocon<20.0  then   alcc=3;
     else if alcocon>=20.0                    then   alcc=4;    
     else alcc=.;  

     keep id age89 age_40 age_44 age_48 age_52 age_56 age_60 act_40 act_44 act_48 act_52 act_56 act_60 
          dt_chr dtdth DXage_chronic DXage_death DXage_min EVENTtime_min fupmos chr cvd type2db tot_cancer obes_ca phyact_ca
          EVENTtime_cvd EVENTtime_canc EVENTtime_db EVENTtime_obes EVENTtime_phy fupmos_cvd fupmos_canc fupmos_db fupmos_obes fupmos_phy
          white smkst smkpy alcc regaspa regibuia mvit cafh dbfh cvdfh aheicon agecon alcocon bmicon packy phmsstatus
          ;
run;


data short;
set short;
missing_any=0;
if act_40=. or act_44=. or act_48=. or act_52=. or act_56=. or act_60=. then missing_any=1;
/*count the number of missing measurements*/
array act {*} act_40 act_44 act_48 act_52 act_56 act_60 ;
array act_miss {*} act_40m act_44m act_48m act_52m act_56m act_60m;
do i=1 to dim(act);
act_miss(i)=0; if act(i)=. then act_miss(i)=1;
end;
act_miss_num=sum(act_40m, act_44m, act_48m, act_52m, act_56m, act_60m);
run;

proc means;
var act_miss_num;
run;

data nhs2_traj_sample;
set short;
id=300000000+id;  
cohort=3;
sex=1;
/**** EXCLUSION: THOSE WHO HAD LESS THAN 3 MEASUREMENTS ****/
if act_miss_num>3 then delete;
run;

data nhs2_traj_sample;
set nhs2_traj_sample;
/**** EXCLUSION: THOSE WHO DIED OR HAD OUTCOME BEFORE INDIVIDUAL START OF FOLLOWUP ****/
if DXage_min>0 and DXage_min<60 then delete;
run;

data nhs2_traj_sample;
set nhs2_traj_sample;
if fupmos=. then delete;
run;

data nhs2_traj_sample;
set nhs2_traj_sample;
if act_40 ge 100 then delete;
if act_44 ge 100 then delete;
if act_48 ge 100 then delete;
if act_52 ge 100 then delete;
if act_56 ge 100 then delete;
if act_60 ge 100 then delete;
run;

/*
proc means n nmiss min max median mean p25 p75 p95 p99;
var act_40 act_44 act_48 act_52 act_56 act_60 fupmos fupmos_cvd fupmos_canc fupmos_db aheicon agecon;
run;

proc freq;
     table chr cvd tot_cancer type2db  white  smkpy  alcc  regaspa  regibuia  mvit  cafh  dbfh  cvdfh  phmsstatus    
;
run;
*/

proc datasets; delete base act8917 nhs2_traj; run;

