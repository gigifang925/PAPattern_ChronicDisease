%include '/udd/hpzfa/review/PA/hpfs.main.sas';

data base;
set base;
     
array irt {17} irt86  irt88  irt90  irt92  irt94  irt96  irt98  irt00  irt02  irt04  irt06  irt08  irt10  irt12  irt14  irt16  irt18;
do i=1 to DIM(irt)-1; 
      if (irt{i}<(1009+24*i) | irt{i}>=(1033+24*i)) then irt{i}=1009+24*i;    /*1986 Jan 31*/
end;  

DXage_chronic=int((dt_chr-dbmy09)/12);	/*age of major chronic disease diagnosis*/
DXage_death=int((dtdth-dbmy09)/12);
DXage_min=min(DXage_chronic, DXage_death);
EVENTtime_min=min(dtdth, dt_chr);
EVENTtime_cvd=min(dtdth, dt_cvd);
EVENTtime_db=min(dtdth, dt_diab);
EVENTtime_canc=min(dtdth, dt_totcancer);
EVENTtime_obes=min(dtdth, dt_obesca);
EVENTtime_phy=min(dtdth, dt_phyca);

/**** BASELINE EXCLUSION ****/
if exrec eq 1 then delete;
if dbmy09 le 0 then delete;
if age86 eq . then delete;
if act86 eq . then delete;

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

drop act86  act88  act90  act92  act94  act96  act98  act00  act02  act04  act06  act08  act10  act12  act14  act16;
run;

/*
proc means n nmiss min max mean median;
var age86;
run;
                         Analysis Variable : age86 
 
             N
    N     Miss         Minimum         Maximum            Mean          Median
------------------------------------------------------------------------------
45426        0      38.0000000      78.0000000      53.4147845      53.0000000
------------------------------------------------------------------------------

proc means n nmiss min max mean median;
var dtdth dt_chr EVENTtime_min dt_cvd EVENTtime_cvd dt_totcancer EVENTtime_canc dt_diab EVENTtime_db ;
run;
*/


%hmet8616;
   data hp_metsm; 
        set hmet8616; 
           array act{*}  act86  act88  act90  act92  act94  act96  act98  act00  act02  act04  act06  act08  act10  act12  act14  act16;         
           do i=1 to dim(act);
           if act{i}<0 or act{i}>=998 then act{i}= . ;
           end; drop i;
        keep id act86 act88 act90 act92 act94 act96 act98 act00 act02 act04 act06 act08 act10 act12 act14 act16;
        run;


data short;
     merge base(in=main) hp_metsm;
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
     else &fup_len=1441-&irt;	/* END of follow-up = Jan 1, 2020 */
     %mend;

     if age86=38 then do;
        act_40=act88; /*1988*/
        act_44=act92; /*1992*/
        act_48=act96; /*1996*/
        act_52=act00; /*2000*/
        act_56=act04; /*2004*/
        act_60=act08; /*2008*/
     end;
     if age86=39 then do;
        act_40=mean(act86, act88); /*1987*/
        act_44=mean(act90, act92); /*1991*/
        act_48=mean(act94, act96); /*1995*/
        act_52=mean(act98, act00); /*1999*/
        act_56=mean(act02, act04); /*2003*/
        act_60=mean(act06, act08); /*2007*/
     end;
     if age86 in (38, 39) then do;
        %fup(dt_chr, EVENTtime_min, fupmos, irt08);
        %fup(dt_cvd, EVENTtime_cvd, fupmos_cvd, irt08);
        %fup(dt_totcancer, EVENTtime_canc, fupmos_canc, irt08);
        %fup(dt_diab, EVENTtime_db, fupmos_db, irt08);
        %fup(dt_obesca, EVENTtime_obes, fupmos_obes, irt08);
        %fup(dt_phyca, EVENTtime_phy, fupmos_phy, irt08);

        agecon=age08; alcocon=alco06nv; aheicon=ahei06v; packy=pckyr08; smkst=smoke08; bmicon=bmi08;
        if regaspre08=2 then regaspa=1; else if regaspre08=1 then regaspa=0;
        if regibui08=2 then regibuia=1; else if regibui08=1 then regibuia=0;
        if smoke08=1 then smkpy=1;
        else if smoke08=2 then do;
                if 0<pckyr08<10         then smkpy=2;
                else if 10<=pckyr08<20  then smkpy=3;
                else if 20<=pckyr08<40  then smkpy=4;
                else if 40<=pckyr08<998 then smkpy=5;
                else smkpy=.;
        end;
        else if smoke08=3 then do;
                if 0<pckyr08<25         then smkpy=6;
                else if 25<=pckyr08<45  then smkpy=7;
                else if 45<=pckyr08<65  then smkpy=8;
                else if 65<=pckyr08<998 then smkpy=9;
                else smkpy=.;
        end; 
        else smkpy=.;

        if mvt08=1 then mvit=1; else mvit=0;
        if cafh08=1 then cafh=1; else cafh=0;
        if cvdfh96=1 then cvdfh=1; else cvdfh=0;
        if dbfh08=1 then dbfh=1; else dbfh=0;
     end;


     if age86=40 then do;
        act_40=act86; /*1986*/
        act_44=act90; /*1990*/
        act_48=act94; /*1994*/
        act_52=act98; /*1998*/
        act_56=act02; /*2002*/
        act_60=act06; /*2006*/
     end;
     if age86=41 then do;
        act_40=act86; /*1985*/
        act_44=mean(act88, act90); /*1989*/
        act_48=mean(act92, act94); /*1993*/
        act_52=mean(act96, act98); /*1997*/
        act_56=mean(act00, act02); /*2001*/
        act_60=mean(act04, act06); /*2005*/
     end;
     if age86 in (40, 41) then do;
        %fup(dt_chr, EVENTtime_min, fupmos, irt06);
        %fup(dt_cvd, EVENTtime_cvd, fupmos_cvd, irt06);
        %fup(dt_totcancer, EVENTtime_canc, fupmos_canc, irt06);
        %fup(dt_diab, EVENTtime_db, fupmos_db, irt06);
        %fup(dt_obesca, EVENTtime_obes, fupmos_obes, irt06);
        %fup(dt_phyca, EVENTtime_phy, fupmos_phy, irt06);

        agecon=age06; alcocon=alco06nv; aheicon=ahei06v; packy=pckyr06; smkst=smoke06; bmicon=bmi06;
        if regaspre06=2 then regaspa=1; else if regaspre06=1 then regaspa=0;
        if regibui06=2 then regibuia=1; else if regibui06=1 then regibuia=0;
        if smoke06=1 then smkpy=1;
        else if smoke06=2 then do;
                if 0<pckyr06<10         then smkpy=2;
                else if 10<=pckyr06<20  then smkpy=3;
                else if 20<=pckyr06<40  then smkpy=4;
                else if 40<=pckyr06<998 then smkpy=5;
                else smkpy=.;
        end;
        else if smoke06=3 then do;
                if 0<pckyr06<25         then smkpy=6;
                else if 25<=pckyr06<45  then smkpy=7;
                else if 45<=pckyr06<65  then smkpy=8;
                else if 65<=pckyr06<998 then smkpy=9;
                else smkpy=.;
        end; 
        else smkpy=.;

        if mvt06=1 then mvit=1; else mvit=0;
        if cafh96=1 then cafh=1; else cafh=0;
        if cvdfh96=1 then cvdfh=1; else cvdfh=0;
        if dbfh92=1 then dbfh=1; else dbfh=0;
     end;


     if age86=42 then do;
        act_40=act86; /*1984*/
        act_44=act88; /*1988*/
        act_48=act92; /*1992*/
        act_52=act96; /*1996*/
        act_56=act00; /*2000*/
        act_60=act04; /*2004*/
     end;
     if age86=43 then do;
        act_40=act86; /*1983*/
        act_44=mean(act86, act88); /*1987*/
        act_48=mean(act90, act92); /*1991*/
        act_52=mean(act94, act96); /*1995*/
        act_56=mean(act98, act00); /*1999*/
        act_60=mean(act02, act04); /*2003*/
     end;
     if age86 in (42, 43) then do;
        %fup(dt_chr, EVENTtime_min, fupmos, irt04);
        %fup(dt_cvd, EVENTtime_cvd, fupmos_cvd, irt04);
        %fup(dt_totcancer, EVENTtime_canc, fupmos_canc, irt04);
        %fup(dt_diab, EVENTtime_db, fupmos_db, irt04);
        %fup(dt_obesca, EVENTtime_obes, fupmos_obes, irt04);
        %fup(dt_phyca, EVENTtime_phy, fupmos_phy, irt04);

        agecon=age04; alcocon=alco02nv; aheicon=ahei02v; packy=pckyr04; smkst=smoke04; bmicon=bmi04;
        if regaspre04=2 then regaspa=1; else if regaspre04=1 then regaspa=0;
        if regibui04=2 then regibuia=1; else if regibui04=1 then regibuia=0;
        if smoke04=1 then smkpy=1;
        else if smoke04=2 then do;
                if 0<pckyr04<10         then smkpy=2;
                else if 10<=pckyr04<20  then smkpy=3;
                else if 20<=pckyr04<40  then smkpy=4;
                else if 40<=pckyr04<998 then smkpy=5;
                else smkpy=.;
        end;
        else if smoke04=3 then do;
                if 0<pckyr04<25         then smkpy=6;
                else if 25<=pckyr04<45  then smkpy=7;
                else if 45<=pckyr04<65  then smkpy=8;
                else if 65<=pckyr04<998 then smkpy=9;
                else smkpy=.;
        end; 
        else smkpy=.;

        if mvt04=1 then mvit=1; else mvit=0;
        if cafh96=1 then cafh=1; else cafh=0;
        if cvdfh96=1 then cvdfh=1; else cvdfh=0;
        if dbfh92=1 then dbfh=1; else dbfh=0;
     end;

     
     if age86=44 then do;
        act_40=.; /*1982*/
        act_44=act86; /*1986*/
        act_48=act90; /*1990*/
        act_52=act94; /*1994*/
        act_56=act98; /*1998*/
        act_60=act02; /*2002*/
     end;
     if age86=45 then do;
        act_40=.; /*1981*/
        act_44=act86; /*1985*/
        act_48=mean(act88, act90); /*1989*/
        act_52=mean(act92, act94); /*1993*/
        act_56=mean(act96, act98); /*1997*/
        act_60=mean(act00, act02); /*2001*/
     end;
     if age86 in (44, 45) then do;
        %fup(dt_chr, EVENTtime_min, fupmos, irt02);
        %fup(dt_cvd, EVENTtime_cvd, fupmos_cvd, irt02);
        %fup(dt_totcancer, EVENTtime_canc, fupmos_canc, irt02);
        %fup(dt_diab, EVENTtime_db, fupmos_db, irt02);
        %fup(dt_obesca, EVENTtime_obes, fupmos_obes, irt02);
        %fup(dt_phyca, EVENTtime_phy, fupmos_phy, irt02);

        agecon=age02; alcocon=alco02nv; aheicon=ahei02v; packy=pckyr02; smkst=smoke02; bmicon=bmi02;
        if regaspre02=2 then regaspa=1; else if regaspre02=1 then regaspa=0;
        if regibui02=2 then regibuia=1; else if regibui02=1 then regibuia=0;
        if smoke02=1 then smkpy=1;
        else if smoke02=2 then do;
                if 0<pckyr02<10         then smkpy=2;
                else if 10<=pckyr02<20  then smkpy=3;
                else if 20<=pckyr02<40  then smkpy=4;
                else if 40<=pckyr02<998 then smkpy=5;
                else smkpy=.;
        end;
        else if smoke02=3 then do;
                if 0<pckyr02<25         then smkpy=6;
                else if 25<=pckyr02<45  then smkpy=7;
                else if 45<=pckyr02<65  then smkpy=8;
                else if 65<=pckyr02<998 then smkpy=9;
                else smkpy=.;
        end; 
        else smkpy=.;

        if mvt02=1 then mvit=1; else mvit=0;
        if cafh96=1 then cafh=1; else cafh=0;
        if cvdfh96=1 then cvdfh=1; else cvdfh=0;
        if dbfh92=1 then dbfh=1; else dbfh=0;
     end;


     if age86=46 then do;
        act_40=.; /*1980*/
        act_44=act86; /*1984*/
        act_48=act88; /*1988*/
        act_52=act92; /*1992*/
        act_56=act96; /*1996*/
        act_60=act00; /*2000*/
     end;
     if age86=47 then do;
        act_40=.; /*1979*/
        act_44=act86; /*1983*/
        act_48=mean(act86, act88); /*1987*/
        act_52=mean(act90, act92); /*1991*/
        act_56=mean(act94, act96); /*1995*/
        act_60=mean(act98, act00); /*1999*/
     end;
     if age86 in (46, 47) then do;
        %fup(dt_chr, EVENTtime_min, fupmos, irt00);
        %fup(dt_cvd, EVENTtime_cvd, fupmos_cvd, irt00);
        %fup(dt_totcancer, EVENTtime_canc, fupmos_canc, irt00);
        %fup(dt_diab, EVENTtime_db, fupmos_db, irt00);
        %fup(dt_obesca, EVENTtime_obes, fupmos_obes, irt00);
        %fup(dt_phyca, EVENTtime_phy, fupmos_phy, irt00);

        agecon=age00; alcocon=alco98nv; aheicon=ahei98v; packy=pckyr00; smkst=smoke00; bmicon=bmi00;
        if regaspre00=2 then regaspa=1; else if regaspre00=1 then regaspa=0;
        if regibui00=2 then regibuia=1; else if regibui00=1 then regibuia=0;
        if smoke00=1 then smkpy=1;
        else if smoke00=2 then do;
                if 0<pckyr00<10         then smkpy=2;
                else if 10<=pckyr00<20  then smkpy=3;
                else if 20<=pckyr00<40  then smkpy=4;
                else if 40<=pckyr00<998 then smkpy=5;
                else smkpy=.;
        end;
        else if smoke00=3 then do;
                if 0<pckyr00<25         then smkpy=6;
                else if 25<=pckyr00<45  then smkpy=7;
                else if 45<=pckyr00<65  then smkpy=8;
                else if 65<=pckyr00<998 then smkpy=9;
                else smkpy=.;
        end; 
        else smkpy=.;

        if mvt00=1 then mvit=1; else mvit=0;
        if cafh96=1 then cafh=1; else cafh=0;
        if cvdfh96=1 then cvdfh=1; else cvdfh=0;
        if dbfh92=1 then dbfh=1; else dbfh=0;
     end;


     if age86=48 then do;
        act_40=.; /*1978*/
        act_44=.; /*1982*/
        act_48=act86; /*1986*/
        act_52=act90; /*1990*/
        act_56=act94; /*1994*/
        act_60=act98; /*1998*/
     end;
     if age86=49 then do;
        act_40=.; /*1977*/
        act_44=.; /*1981*/
        act_48=act86; /*1985*/
        act_52=mean(act88, act90); /*1989*/
        act_56=mean(act92, act94); /*1993*/
        act_60=mean(act96, act98); /*1997*/
     end;
     if age86 in (48, 49) then do;
        %fup(dt_chr, EVENTtime_min, fupmos, irt98);
        %fup(dt_cvd, EVENTtime_cvd, fupmos_cvd, irt98);
        %fup(dt_totcancer, EVENTtime_canc, fupmos_canc, irt98);
        %fup(dt_diab, EVENTtime_db, fupmos_db, irt98);
        %fup(dt_obesca, EVENTtime_obes, fupmos_obes, irt98);
        %fup(dt_phyca, EVENTtime_phy, fupmos_phy, irt98);

        agecon=age98; alcocon=alco98nv; aheicon=ahei98v; packy=pckyr98; smkst=smoke98; bmicon=bmi98;
        if regaspre98=2 then regaspa=1; else if regaspre98=1 then regaspa=0;
        if regibui98=2 then regibuia=1; else if regibui98=1 then regibuia=0;
        if smoke98=1 then smkpy=1;
        else if smoke98=2 then do;
                if 0<pckyr98<10         then smkpy=2;
                else if 10<=pckyr98<20  then smkpy=3;
                else if 20<=pckyr98<40  then smkpy=4;
                else if 40<=pckyr98<998 then smkpy=5;
                else smkpy=.;
        end;
        else if smoke98=3 then do;
                if 0<pckyr98<25         then smkpy=6;
                else if 25<=pckyr98<45  then smkpy=7;
                else if 45<=pckyr98<65  then smkpy=8;
                else if 65<=pckyr98<998 then smkpy=9;
                else smkpy=.;
        end; 
        else smkpy=.;

        if mvt98=1 then mvit=1; else mvit=0;
        if cafh96=1 then cafh=1; else cafh=0;
        if cvdfh96=1 then cvdfh=1; else cvdfh=0;
        if dbfh92=1 then dbfh=1; else dbfh=0;
     end;


     if age86=50 then do;
        act_40=.; /*1976*/
        act_44=.; /*1980*/
        act_48=act86; /*1984*/
        act_52=act88; /*1988*/
        act_56=act92; /*1992*/
        act_60=act96; /*1996*/
     end;
     if age86=51 then do;
        act_40=.; /*1975*/
        act_44=.; /*1979*/
        act_48=act86; /*1983*/
        act_52=mean(act86, act88); /*1987*/
        act_56=mean(act90, act92); /*1991*/
        act_60=mean(act94, act96); /*1995*/
     end;
     if age86 in (50, 51) then do;
        %fup(dt_chr, EVENTtime_min, fupmos, irt96);
        %fup(dt_cvd, EVENTtime_cvd, fupmos_cvd, irt96);
        %fup(dt_totcancer, EVENTtime_canc, fupmos_canc, irt96);
        %fup(dt_diab, EVENTtime_db, fupmos_db, irt96);
        %fup(dt_obesca, EVENTtime_obes, fupmos_obes, irt96);
        %fup(dt_phyca, EVENTtime_phy, fupmos_phy, irt96);

        agecon=age96; alcocon=alco94nv; aheicon=ahei94v; packy=pckyr96; smkst=smoke96; bmicon=bmi96;
        if regaspre96=2 then regaspa=1; else if regaspre96=1 then regaspa=0;
        if regibui96=2 then regibuia=1; else if regibui96=1 then regibuia=0;
        if smoke96=1 then smkpy=1;
        else if smoke96=2 then do;
                if 0<pckyr96<10         then smkpy=2;
                else if 10<=pckyr96<20  then smkpy=3;
                else if 20<=pckyr96<40  then smkpy=4;
                else if 40<=pckyr96<998 then smkpy=5;
                else smkpy=.;
        end;
        else if smoke96=3 then do;
                if 0<pckyr96<25         then smkpy=6;
                else if 25<=pckyr96<45  then smkpy=7;
                else if 45<=pckyr96<65  then smkpy=8;
                else if 65<=pckyr96<998 then smkpy=9;
                else smkpy=.;
        end; 
        else smkpy=.;

        if mvt96=1 then mvit=1; else mvit=0;
        if cafh96=1 then cafh=1; else cafh=0;
        if cvdfh96=1 then cvdfh=1; else cvdfh=0;
        if dbfh92=1 then dbfh=1; else dbfh=0;
    end;
 
     if white ne 1 then white=0;
     phmsstatus=1;

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

data hpfs_traj_sample;
set short;
id=200000000+id;  
cohort=2;
sex=0;
/**** EXCLUSION: THOSE WHO HAD LESS THAN 3 MEASUREMENTS ****/
if act_miss_num>3 then delete;
run;

data hpfs_traj_sample;
set hpfs_traj_sample;
/**** EXCLUSION: THOSE WHO DIED OR HAD OUTCOME BEFORE INDIVIDUAL START OF FOLLOWUP ****/
if DXage_min>0 and DXage_min<60 then delete;
run;

data hpfs_traj_sample;
set hpfs_traj_sample;
if fupmos=. then delete;
run;

data hpfs_traj_sample;
set hpfs_traj_sample;
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
     table chr cvd tot_cancer type2db  white  smkpy  alcc  regaspa  regibuia  mvit  cafh  dbfh  cvdfh     
;
run;
*/

proc datasets; delete base hmet8616 short; run;

