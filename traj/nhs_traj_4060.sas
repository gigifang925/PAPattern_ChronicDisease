%include '/udd/hpzfa/review/PA/nhs.main.sas';

data base;
set base;

array irt {17} irt86  irt88  irt90  irt92  irt94  irt96  irt98  irt00  irt02  irt04  irt06  irt08  irt10  irt12  irt14  irt16  irt18;
do i=1 to DIM(irt);
      if (irt{i}<(1014+24*i) | irt{i}>=(1038+24*i)) then irt{i}=1014+24*i;   /*1986 June 30*/
end;

DXage_chronic=int((dt_chr-bdt)/12);	/*age of major chronic disease diagnosis*/
DXage_death=int((dtdth-bdt)/12);
DXage_min=min(DXage_chronic, DXage_death);
EVENTtime_min=min(dtdth, dt_chr);
EVENTtime_cvd=min(dtdth, dt_cvd);
EVENTtime_db=min(dtdth, dt_diab);
EVENTtime_canc=min(dtdth, dt_totcancer);
EVENTtime_obes=min(dtdth, dt_obesca);
EVENTtime_phy=min(dtdth, dt_phyca);

/**** BASELINE EXCLUSION ****/
if exrec eq 1 then delete;
if yobf le 20 then delete;
if age86 eq . then delete;
if act86m eq . then delete;

if can86 eq 1 then delete;   
if mi86 eq 1 then delete; 
if str86 eq 1 then delete;
if db86 eq 1 then delete;
if 0<dt_chr<=irt86  then delete;          
if 0<dtdth<=irt86 then delete;           
if 0<dt_totcancer<=irt86 then delete;
if 0<dt_cvd<=irt86 then delete;
if 0<dt_diab<=irt86 then delete;

/**** EXCLUSION: THOSE WHO DIED OR HAD OUTCOME BEFORE AGE60 ****/
*if DXage_min>0 and DXage_min<60 then delete;

drop  act86m  act88m  act92m   act94m   act96m   act98m   act00m   act04m   act08m   act12m   act14m;
run;

/*
proc means n nmiss min max median mean;
var age86;
run;
                                           Analysis Variable : age86 Age at qq return, 1986
 
                                       N
                              N     Miss         Minimum         Maximum          Median            Mean
                          ------------------------------------------------------------------------------
                          72942        0      39.0000000      66.0000000      52.0000000      52.2578213
                          ------------------------------------------------------------------------------

proc means n nmiss min max mean median;
var dtdth dt_chr EVENTtime_min dt_cvd EVENTtime_cvd dt_totcancer EVENTtime_canc dt_diab EVENTtime_db ;
run;
*/


%act8614(keep= id  act86m  act88m  act92m   act94m   act96m   act98m   act00m   act04m   act08m   act12m   act14m);
         array actm [*]  act86m   act88m   act92m   act94m   act96m   act98m   act00m   act04m   act08m   act12m   act14m; 							
         do i=1 to 11;												
             if actm[i]>997 then actm[i]=.; 
         end; drop i;																																			
run;

data short;
     merge base(in=main) act8614 end=_end_;
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
     else &fup_len=1446-&irt;	/* END of follow-up = June 30, 2020 */
     %mend;

     if age86=39 then do;
        act_40=mean(act86m, act88m); /*1987*/
        act_44=mean(act88m, act92m); /*1991*/
        act_48=mean(act94m, act96m); /*1995*/
        act_52=mean(act98m, act00m); /*1999*/
        act_56=mean(act00m, act04m); /*2003*/
        act_60=mean(act04m, act08m); /*2007*/
     end;
     if age86=40 then do;
        act_40=act86m; /*1986*/
        act_44=mean(act88m, act92m); /*1990*/
        act_48=act94m; /*1994*/
        act_52=act98m; /*1998*/
        act_56=mean(act00m, act04m); /*2002*/
        act_60=mean(act04m, act08m); /*2006*/
     end;
     if age86=41 then do;
        act_40=act86m; /*1985*/
        act_44=mean(act88m, act92m); /*1989*/
        act_48=mean(act92m, act94m); /*1993*/
        act_52=mean(act96m, act98m); /*1997*/
        act_56=mean(act00m, act04m); /*2001*/
        act_60=mean(act04m, act08m); /*2005*/
     end;
     if age86 in (39, 40, 41) then do;
        %fup(dt_chr, EVENTtime_min, fupmos, irt08);
        %fup(dt_cvd, EVENTtime_cvd, fupmos_cvd, irt08);
        %fup(dt_totcancer, EVENTtime_canc, fupmos_canc, irt08);
        %fup(dt_diab, EVENTtime_db, fupmos_db, irt08);
        %fup(dt_obesca, EVENTtime_obes, fupmos_obes, irt08);
        %fup(dt_phyca, EVENTtime_phy, fupmos_phy, irt08);

        agecon=age08; alcocon=alco06nv; aheicon=ahei06v; phmsstatus=pmh08; packy=pkyr08; smkst=smoke08; bmicon=bmi08;
        if regaspre08=2 then regaspa=1; else if regaspre08=1 then regaspa=0;
        if regibui08=2 then regibuia=1; else if regibui08=1 then regibuia=0;
        if smoke08=1 then smkpy=1;
        else if smoke08=2 then do;
                if 0<pkyr08<10         then smkpy=2;
                else if 10<=pkyr08<20  then smkpy=3;
                else if 20<=pkyr08<40  then smkpy=4;
                else if 40<=pkyr08<998 then smkpy=5;
                else smkpy=.;
        end;
        else if smoke08=3 then do;
                if 0<pkyr08<25         then smkpy=6;
                else if 25<=pkyr08<45  then smkpy=7;
                else if 45<=pkyr08<65  then smkpy=8;
                else if 65<=pkyr08<998 then smkpy=9;
                else smkpy=.;
        end; 
        else smkpy=.;

        if mvyn08=1 then mvit=1; else mvit=0;
        if cafh08=1 then cafh=1; else cafh=0;
        if cvdfh08=1 then cvdfh=1; else cvdfh=0;
        if dbfh92=1 then dbfh=1; else dbfh=0;
     end;

  
     if age86=42 then do;
        act_40=act86m; /*1984*/
        act_44=act88m; /*1988*/
        act_48=act92m; /*1992*/
        act_52=act96m; /*1996*/
        act_56=act00m; /*2000*/
        act_60=act04m; /*2004*/
     end;
     if age86=43 then do;
        act_40=act86m; /*1983*/
        act_44=mean(act86m, act88m); /*1987*/
        act_48=mean(act88m, act92m); /*1991*/
        act_52=mean(act94m, act96m); /*1995*/
        act_56=mean(act98m, act00m); /*1999*/
        act_60=mean(act00m, act04m); /*2003*/
     end;
     if age86=44 then do;
        act_40=.; /*1982*/
        act_44=act86m; /*1986*/
        act_48=mean(act88m, act92m); /*1990*/
        act_52=act94m; /*1994*/
        act_56=act98m; /*1998*/
        act_60=mean(act00m, act04m); /*2002*/
     end;
     if age86=45 then do;
        act_40=.; /*1981*/
        act_44=act86m; /*1985*/
        act_48=mean(act88m, act92m); /*1989*/
        act_52=mean(act92m, act94m); /*1993*/
        act_56=mean(act96m, act98m); /*1997*/
        act_60=mean(act00m, act04m); /*2001*/
     end;
     if age86 in (42, 43, 44, 45) then do;
        %fup(dt_chr, EVENTtime_min, fupmos, irt04);
        %fup(dt_cvd, EVENTtime_cvd, fupmos_cvd, irt04);
        %fup(dt_totcancer, EVENTtime_canc, fupmos_canc, irt04);
        %fup(dt_diab, EVENTtime_db, fupmos_db, irt04);
        %fup(dt_obesca, EVENTtime_obes, fupmos_obes, irt04);
        %fup(dt_phyca, EVENTtime_phy, fupmos_phy, irt04);

        agecon=age04; alcocon=alco02nv; aheicon=ahei02v; phmsstatus=pmh04; packy=pkyr04; smkst=smoke04; bmicon=bmi04;
        if regaspre04=2 then regaspa=1; else if regaspre04=1 then regaspa=0;
        if regibui04=2 then regibuia=1; else if regibui04=1 then regibuia=0;
        if smoke04=1 then smkpy=1;
        else if smoke04=2 then do;
                if 0<pkyr04<10         then smkpy=2;
                else if 10<=pkyr04<20  then smkpy=3;
                else if 20<=pkyr04<40  then smkpy=4;
                else if 40<=pkyr04<998 then smkpy=5;
                else smkpy=.;
        end;
        else if smoke04=3 then do;
                if 0<pkyr04<25         then smkpy=6;
                else if 25<=pkyr04<45  then smkpy=7;
                else if 45<=pkyr04<65  then smkpy=8;
                else if 65<=pkyr04<998 then smkpy=9;
                else smkpy=.;
        end; 
        else smkpy=.;

        if mvyn04=1 then mvit=1; else mvit=0;
        if cafh04=1 then cafh=1; else cafh=0;
        if cvdfh96=1 then cvdfh=1; else cvdfh=0;
        if dbfh92=1 then dbfh=1; else dbfh=0;
     end;


     if age86=46 then do;
        act_40=.; /*1980*/
        act_44=act86m; /*1984*/
        act_48=act88m; /*1988*/
        act_52=act92m; /*1992*/
        act_56=act96m; /*1996*/
        act_60=act00m; /*2000*/
     end;
     if age86=47 then do;
        act_40=.; /*1979*/
        act_44=act86m; /*1983*/
        act_48=mean(act86m, act88m); /*1987*/
        act_52=mean(act88m, act92m); /*1991*/
        act_56=mean(act94m, act96m); /*1995*/
        act_60=mean(act98m, act00m); /*1999*/
     end;
     if age86 in (46, 47) then do;
        %fup(dt_chr, EVENTtime_min, fupmos, irt00);
        %fup(dt_cvd, EVENTtime_cvd, fupmos_cvd, irt00);
        %fup(dt_totcancer, EVENTtime_canc, fupmos_canc, irt00);
        %fup(dt_diab, EVENTtime_db, fupmos_db, irt00);
        %fup(dt_obesca, EVENTtime_obes, fupmos_obes, irt00);
        %fup(dt_phyca, EVENTtime_phy, fupmos_phy, irt00);

        agecon=age00; alcocon=alco98nv; aheicon=ahei98v; phmsstatus=pmh00; packy=pkyr00; smkst=smoke00; bmicon=bmi00;
        if regaspre00=2 then regaspa=1; else if regaspre00=1 then regaspa=0;
        if regibui00=2 then regibuia=1; else if regibui00=1 then regibuia=0;
        if smoke00=1 then smkpy=1;
        else if smoke00=2 then do;
                if 0<pkyr00<10         then smkpy=2;
                else if 10<=pkyr00<20  then smkpy=3;
                else if 20<=pkyr00<40  then smkpy=4;
                else if 40<=pkyr00<998 then smkpy=5;
                else smkpy=.;
        end;
        else if smoke00=3 then do;
                if 0<pkyr00<25         then smkpy=6;
                else if 25<=pkyr00<45  then smkpy=7;
                else if 45<=pkyr00<65  then smkpy=8;
                else if 65<=pkyr00<998 then smkpy=9;
                else smkpy=.;
        end; 
        else smkpy=.;

        if mvyn00=1 then mvit=1; else mvit=0;
        if cafh00=1 then cafh=1; else cafh=0;
        if cvdfh96=1 then cvdfh=1; else cvdfh=0;
        if dbfh92=1 then dbfh=1; else dbfh=0;
     end;


     if age86=48 then do;
        act_40=.; /*1978*/
        act_44=.; /*1982*/
        act_48=act86m; /*1986*/
        act_52=mean(act88m, act92m); /*1990*/
        act_56=act94m; /*1994*/
        act_60=act98m; /*1998*/
     end;
     if age86=49 then do;
        act_40=.; /*1977*/
        act_44=.; /*1981*/
        act_48=act86m; /*1985*/
        act_52=mean(act88m, act92m); /*1989*/
        act_56=mean(act92m, act94m); /*1993*/
        act_60=mean(act96m, act98m); /*1997*/
     end;
     if age86 in (48, 49) then do;
        %fup(dt_chr, EVENTtime_min, fupmos, irt98);
        %fup(dt_cvd, EVENTtime_cvd, fupmos_cvd, irt98);
        %fup(dt_totcancer, EVENTtime_canc, fupmos_canc, irt98);
        %fup(dt_diab, EVENTtime_db, fupmos_db, irt98);
        %fup(dt_obesca, EVENTtime_obes, fupmos_obes, irt98);
        %fup(dt_phyca, EVENTtime_phy, fupmos_phy, irt98);

        agecon=age98; alcocon=alco98nv; aheicon=ahei98v; phmsstatus=pmh98; packy=pkyr98; smkst=smoke98; bmicon=bmi98;
        if regaspre98=2 then regaspa=1; else if regaspre98=1 then regaspa=0;
        if regibui98=2 then regibuia=1; else if regibui98=1 then regibuia=0;
        if smoke98=1 then smkpy=1;
        else if smoke98=2 then do;
                if 0<pkyr98<10         then smkpy=2;
                else if 10<=pkyr98<20  then smkpy=3;
                else if 20<=pkyr98<40  then smkpy=4;
                else if 40<=pkyr98<998 then smkpy=5;
                else smkpy=.;
        end;
        else if smoke98=3 then do;
                if 0<pkyr98<25         then smkpy=6;
                else if 25<=pkyr98<45  then smkpy=7;
                else if 45<=pkyr98<65  then smkpy=8;
                else if 65<=pkyr98<998 then smkpy=9;
                else smkpy=.;
        end; 
        else smkpy=.;

        if mvyn98=1 then mvit=1; else mvit=0;
        if cafh96=1 then cafh=1; else cafh=0;
        if cvdfh96=1 then cvdfh=1; else cvdfh=0;
        if dbfh92=1 then dbfh=1; else dbfh=0;
     end;


     if age86=50 then do;
        act_40=.; /*1976*/
        act_44=.; /*1980*/
        act_48=act86m; /*1984*/
        act_52=act88m; /*1988*/
        act_56=act92m; /*1992*/
        act_60=act96m; /*1996*/
     end;
     if age86=51 then do;
        act_40=.; /*1975*/
        act_44=.; /*1979*/
        act_48=act86m; /*1983*/
        act_52=mean(act86m, act88m); /*1987*/
        act_56=mean(act88m, act92m); /*1991*/
        act_60=mean(act94m, act96m); /*1995*/
     end;
     if age86 in (50, 51) then do;
        %fup(dt_chr, EVENTtime_min, fupmos, irt96);
        %fup(dt_cvd, EVENTtime_cvd, fupmos_cvd, irt96);
        %fup(dt_totcancer, EVENTtime_canc, fupmos_canc, irt96);
        %fup(dt_diab, EVENTtime_db, fupmos_db, irt96);
        %fup(dt_obesca, EVENTtime_obes, fupmos_obes, irt96);
        %fup(dt_phyca, EVENTtime_phy, fupmos_phy, irt96);

        agecon=age96; alcocon=alco94nv; aheicon=ahei94v; phmsstatus=pmh96; packy=pkyr96; smkst=smoke96; bmicon=bmi96;
        if regaspre96=2 then regaspa=1; else if regaspre96=1 then regaspa=0;
        if regibui96=2 then regibuia=1; else if regibui96=1 then regibuia=0;
        if smoke96=1 then smkpy=1;
        else if smoke96=2 then do;
                if 0<pkyr96<10         then smkpy=2;
                else if 10<=pkyr96<20  then smkpy=3;
                else if 20<=pkyr96<40  then smkpy=4;
                else if 40<=pkyr96<998 then smkpy=5;
                else smkpy=.;
        end;
        else if smoke96=3 then do;
                if 0<pkyr96<25         then smkpy=6;
                else if 25<=pkyr96<45  then smkpy=7;
                else if 45<=pkyr96<65  then smkpy=8;
                else if 65<=pkyr96<998 then smkpy=9;
                else smkpy=.;
        end; 
        else smkpy=.;

        if mvyn96=1 then mvit=1; else mvit=0;
        if cafh92=1 then cafh=1; else cafh=0;
        if cvdfh76=1 then cvdfh=1; else cvdfh=0;
        if dbfh92=1 then dbfh=1; else dbfh=0;
     end;


     if white ne 1 then white=0;

     if alcocon=0.0                           then   alcc=1;
     else if alcocon>0.0   and alcocon<10.0   then   alcc=2;
     else if alcocon>=10.0  and alcocon<20.0  then   alcc=3;
     else if alcocon>=20.0                    then   alcc=4;    
     else alcc=.;  

     keep id age86 age_40 age_44 age_48 age_52 age_56 age_60 act_40 act_44 act_48 act_52 act_56 act_60 
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

data nhs_traj_sample;
set short;
id=100000000+id;  
cohort=1;
sex=1;
/**** EXCLUSION: THOSE WHO HAD LESS THAN 3 MEASUREMENTS ****/
if act_miss_num>3 then delete;
run; 

data nhs_traj_sample;
set nhs_traj_sample;
/**** EXCLUSION: THOSE WHO DIED OR HAD OUTCOME BEFORE INDIVIDUAL START OF FOLLOWUP ****/
if DXage_min>0 and DXage_min<60 then delete;
run;

data nhs_traj_sample;
set nhs_traj_sample;
if fupmos=. then delete;
run;

data nhs_traj_sample;
set nhs_traj_sample;
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

proc datasets; delete base act8614 short; run;

