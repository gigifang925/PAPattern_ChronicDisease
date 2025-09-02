/* This program was developed by the coauthor Peilu Wang and used in her project 
'Optimal dietary patterns for prevention of chronic disease' published on Nature Medicine. */
*--- Goal: derive variables for aspirin and nsaids in NHS 1980 - 2016
*--- update: 10/20/2021
*--- dir: /udd/n2pwa/proj_data/others
*--- ref: /udd/nhyco/aspirin_immune/nhsasp.sas
     change: update from 2010 to 2016.
*--- incl: /proj/nhdats/nh_dat_der/disease/meddata.all
           /proj/nhdats/nh_dat_der/derived/fileb
           %nur82 - %nur16
*--- variables:
   Aspirin (no aspirin info in 1986 in NHS, 91 in NHSII, 
            no tablets/week info until 1992 in HPFS, 1999 in NHSII)
      regaspreXX: regular aspirin, 1=non regular user, 2=regular user                                       
                  at least 2 tabs/week in NHS, 
                  at least 2 times/week in HPFS and NHSII
      avregaspreXX: regular use using cumulative average of intake in each year (only for NHS)
      aspwkpreXX: aspirin intake in each year (carry forward one cycle), Tablets/week, continuous        
      avaspwkpreXX: cumulative average of aspirin intake in each year, Tablets/week, continuous      
      regaspdurXX: years of regular use, continuous (Duration of 1986-88 was imputed by 1984-86 in NHS) 
      anyasppreXX (NHS/NHSII) or regaspreXX (HPFS): regularly use any mount of aspirin in each year (carry forward one cycle)         
   NSAIDs (NHS 90+, HPFS 86+, NHSII 1989+)
      regibuiXX: any use of NSAIDs other than aspirin 1=non-user, 2=any user (regularly use any amount of NSAIDs)    
;

data meddata;
   infile '/proj/nhdats/nh_dat_der/disease/meddata.all' lrecl=49 recfm=d;
   input
   @1   id        6.
   @23  adur80    2. /* duration use aspirin (years) */
   @25  aspwk80   2. /* number aspirin per week */
   ;
proc sort; by id; run;

data fileb;
   infile '/proj/nhdats/nh_dat_der/derived/fileb' lrecl=400 recfm=d;
   input
   @1                  id                  6.
   @188                vigwk80             2.
   @190                vigend80            2.
   @192                modwk80             2.
   @194                modend80            2.
   @196                regact80            1.
   @197                stact80             2.
   @216                asp80               1. /* Do you currently take during most weeks? 0=blank, 1=yes 2=no */
   @217                ibu80               1.
   @227                asp82               1.
   @228                aspwk82             1.
   @235                asp84               1.
   @236                numasp84            1.
   ;
proc sort; by id; run;

data aspdata;
   merge meddata fileb; by id; if first.id;
   if aspwk80>90 then aspwk80=.;  if aspwk80=0  and  asp80=1 then aspwk80=.;
   if aspwk80>0  and  asp80=2 then aspwk80=.; 
   else aspwk80=aspwk80; 

   aspmo80 = aspwk80 * 4.3;
   if  0<=aspwk80<2 then reguasp80=1;
   else if aspwk80>=2 then reguasp80=2;
   else if aspwk80=. then reguasp80=.;
   if adur80>30 then adur80=.; 
   if  asp80=1 then anyasp80=2;
   else anyasp80=1;   
   keep id asp80 aspwk80 aspmo80 adur80 reguasp80 anyasp80;
run;

%nur82(keep=asp82 uspr82 uspr82q uspr82m aspwk82 aspmo82 reguasp82 anyasp82);
   if asp82=0 and uspr82=0 then do; uspr82q=1; uspr82m=0; end;
   else if asp82=1 and uspr82=0 then do; uspr82q=.; uspr82m=.; end;
   else if asp82=1 and uspr82>0 then do;

   uspr82q=uspr82+1;
      if uspr82q=2 then uspr82m=2;
      if uspr82q=3 then uspr82m=5;
      if uspr82q=4 then uspr82m=11;
      if uspr82q=5 then uspr82m=30;
   end;
   aspwk82=uspr82m; 
   aspmo82 = uspr82m * 4.3; 

   if  0<=aspwk82<2 then reguasp82=1;
   else if aspwk82>=2 then reguasp82=2;
   else if aspwk82=. then reguasp82=.;

   if asp82=1 then anyasp82=2;
   else anyasp82=1;
run;


%nur84(keep=aspd84 nasp84 aspwk84 aspmo84 reguasp84 anyasp84);
   if 1<aspd84<6 and nasp84=1 then do; aspd84=0; nasp84=0; end;
   if aspd84=1 and 1<nasp84<7 then do; aspd84=0; nasp84=0; end;

   if aspd84=1 then aspd=0;
   else if aspd84=2 then aspd=2.5;
   else if aspd84=3 then aspd=9.5;
   else if aspd84=4 then aspd=18;
   else if aspd84=5 then aspd=30;
   else if aspd84 in (.,0,6) then aspd=.;

   if nasp84=1 then nasp=0;
   else if nasp84=2 then nasp=1;
   else if nasp84=3 then nasp=2;
   else if nasp84=4 then nasp=3.5;
   else if nasp84=5 then nasp=5.5;
   else if nasp84=6 then nasp =9;
   else if nasp84 in (.,0,7) then nasp=.;

   aspmo84=aspd*nasp;
   aspwk84=aspmo84/4.3;
   
   if  0<=aspwk84<2 then reguasp84=1;
   else if aspwk84>=2 then reguasp84=2;
   else if aspwk84=. then reguasp84=.;

   if aspd84=1 or nasp84=1 then anyasp84=1;
   else if aspd84 in (2,3,4,5) then anyasp84=2;
   else anyasp84=.;
run;

%nur88(keep=aspd88 nasp88 aspwk88 aspmo88 reguasp88 anyasp88);
   if 1<aspd88<6 and nasp88=1 then do; aspd88=0; nasp88=0; end;
   if aspd88=1 and 1<nasp88<7 then do; aspd88=0; nasp88=0; end;
   
   if aspd88=1 or nasp88=1 then anyasp88=1;
      else if aspd88 in (2,3,4,5) then anyasp88=2;
      else anyasp88=.;

   if aspd88=1 then aspd=0;
   else if aspd88=2 then aspd=2.5;
   else if aspd88=3 then aspd=9.5;
   else if aspd88=4 then aspd=18;
   else if aspd88=5 then aspd=30;
   else if aspd88 in (.,0,6) then aspd=.;

   if nasp88=1 then nasp=0;
   else if nasp88=2 then nasp=1;
   else if nasp88=3 then nasp=2;
   else if nasp88=4 then nasp=3.5;
   else if nasp88=5 then nasp=5.5;
   else if nasp88=6 then nasp=9;
   else if nasp88 in (.,0,7) then nasp=.;
   aspmo88=aspd*nasp;
   aspwk88=aspmo88/4.3;

   if  0<=aspwk88<2 then reguasp88=1;
   else if aspwk88>=2 then reguasp88=2;
   else if aspwk88=. then reguasp88=.;
   
run;

* Separately asked for acetaminophen and nsaids. 
   Based on /proj/nhclcs/nhclc0d/achan/cvd/ NSAIDPT.sas, there very few participants 
   who are truly missing -skipped all three analgesic classes.  Most answered one of 
   the analgesic classes and skipped the others (96%) - thus, will assume that these 
   are non-users*;
%nur90 (keep=asp90 aspmo90 aspwk90 aspdm90 aspdd90 allmiss90 reguasp90 anyasp90
             ibumo90 ibuwk90 tyl90 tylmo90 tylwk90 ibudm90 tyldm90 ibudd90 tyldd90
             batch90 regibu90 regtyl90);
   if asp90 in (1,2,3,4,5) and ibu90 in (1,2,3,4,5) and tyl90 in (1,2,3,4,5) then allmiss90=0; 
   else if asp90 in (1,2,3,4,5) and ibu90 in (1,2,3,4,5) and tyl90 in (.,0,6) then allmiss90=1;
   else if asp90 in (1,2,3,4,5) and ibu90 in (.,0,6) and tyl90 in (1,2,3,4,5) then allmiss90=1;
   else if asp90 in (.,0,6) and ibu90 in (1,2,3,4,5) and tyl90 in (1,2,3,4,5) then allmiss90=1;
   else if asp90 in (1,2,3,4,5) and ibu90 in (.,0,6) and tyl90 in (.,0,6) then allmiss90=2;
   else if asp90 in (.,0,6) and ibu90 in (1,2,3,4,5) and tyl90 in (.,0,6) then allmiss90=2;
   else if asp90 in (.,0,6) and ibu90 in (.,0,6) and tyl90 in (1,2,3,4,5) then allmiss90=2;   
   else if asp90 in (.,0,6) and ibu90 in (.,0,6) and tyl90 in (.,0,6) then allmiss90=3;

   if asp90=1 then aspdm90=1;
   else if asp90=2 then aspdm90=2;
   else if asp90=3 then aspdm90=3;
   else if asp90=4 then aspdm90=4;
   else if asp90=5 then aspdm90=5;
   else if asp90 in (.,0,6) and allmiss90 in (1,2) then aspdm90=1; 
   else if asp90 in (.,0,6) and allmiss90=3 then aspdm90=.; 


   if ibu90=1 then ibudm90=1;
   else if ibu90=2 then ibudm90=2;
   else if ibu90=3 then ibudm90=3;
   else if ibu90=4 then ibudm90=4;
   else if ibu90=5 then ibudm90=5;
   else if ibu90 in (.,0,6) and allmiss90 in (1,2) then ibudm90=1;
   else if ibu90 in (.,0,6) and allmiss90=3 then ibudm90=.;


   if tyl90=1 then tyldm90=1;
   else if tyl90=2 then tyldm90=2;
   else if tyl90=3 then tyldm90=3;
   else if tyl90=4 then tyldm90=4;
   else if tyl90=5 then tyldm90=5;
   else if tyl90 in (.,0,6) and allmiss90 in (1,2) then tyldm90=1; 
   else if tyl90 in (.,0,6) and allmiss90=3 then tyldm90=.; 

   if asp90=1 then aspdd90=0;
   else if asp90=2 then aspdd90=2.5;
   else if asp90=3 then aspdd90=9.5;
   else if asp90=4 then aspdd90=18;
   else if asp90=5 then aspdd90=22;
   else if asp90 in (.,0,6) and allmiss90 in (1,2) then aspdd90=0;
   else if asp90 in (.,0,6) and allmiss90=3 then aspdd90=.;


   if ibu90=1 then ibudd90=0;
   else if ibu90=2 then ibudd90=2.5;
   else if ibu90=3 then ibudd90=9.5;
   else if ibu90=4 then ibudd90=18;
   else if ibu90=5 then ibudd90=22;
   else if ibu90 in (.,0,6) and allmiss90 in (1,2) then ibudd90=0; 
   else if ibu90 in (.,0,6) and allmiss90=3 then ibudd90=.; /*if truly missing*/


   if tyl90=1 then tyldd90=0;
   else if tyl90=2 then tyldd90=2.5;
   else if tyl90=3 then tyldd90=9.5;
   else if tyl90=4 then tyldd90=18;
   else if tyl90=5 then tyldd90=22;
   else if tyl90 in (.,0,6) and allmiss90 in (1,2) then tyldd90=0; 
   else if tyl90 in (.,0,6) and allmiss90=3 then tyldd90=.; /*if truly missing*/

   **Assume each day of use is at least 1 tablet/day for aspirin and 2 tablets/day 
   for NSAIDs/tylenol based on Curhan's supplementary questionnaire**;
   aspmo90=aspdd90*1; 
   ibumo90=ibudd90*2;
   tylmo90=tyldd90*2;


      aspwk90=aspmo90/4.3;
      ibuwk90=ibumo90/4.3;
      tylwk90=tylmo90/4.3;

   if  0<=aspwk90<2 then reguasp90=1;
   else if aspwk90>=2 then reguasp90=2;
   else if aspwk90=. then reguasp90=.;
   
   if asp90 in (1) then anyasp90=1;
      else if asp90 in (2,3,4,5) then anyasp90=2;
   else if asp90 in (.,0,6) and allmiss90 in (1,2) then anyasp90=1; 
      else anyasp90=.;

      if ibu90 in (1) then regibu90=1; 
      else if ibu90 in (2,3,4,5) then regibu90=2;
   else if ibu90 in (.,0,6) and allmiss90 in (1,2) then regibu90=1; 
      else regibu90=.;

   if tyl90 in (1) then regtyl90=1;
      else if tyl90 in (2,3,4,5) then regtyl90=2; 
   else if tyl90 in (.,0,6) and allmiss90 in (1,2) then regtyl90=1; 
   else regtyl90=.;

run;


%nur92 (keep=asp92 aspwk92 aspmo92 aspdm92 aspdd92 ibu92 tyl92 allmiss92 reguasp92 anyasp92
             ibumo92 ibuwk92 tylmo92 tylwk92
             ibudm92 tyldm92 ibudd92 tyldd92 regibu92 regtyl92);
   if asp92 in (1,2,3,4,5) and ibu92 in (1,2,3,4,5) and tyl92 in (1,2,3,4,5) then allmiss92=0; 
   else if asp92 in (1,2,3,4,5) and ibu92 in (1,2,3,4,5) and tyl92 in (.,0,6) then allmiss92=1;
   else if asp92 in (1,2,3,4,5) and ibu92 in (.,0,6) and tyl92 in (1,2,3,4,5) then allmiss92=1;
   else if asp92 in (.,0,6) and ibu92 in (1,2,3,4,5) and tyl92 in (1,2,3,4,5) then allmiss92=1;
   else if asp92 in (1,2,3,4,5) and ibu92 in (.,0,6) and tyl92 in (.,0,6) then allmiss92=2;
   else if asp92 in (.,0,6) and ibu92 in (1,2,3,4,5) and tyl92 in (.,0,6) then allmiss92=2;
   else if asp92 in (.,0,6) and ibu92 in (.,0,6) and tyl92 in (1,2,3,4,5) then allmiss92=2;   
   else if asp92 in (.,0,6) and ibu92 in (.,0,6) and tyl92 in (.,0,6) then allmiss92=3;

   if asp92=1 then aspdm92=1;
   else if asp92=2 then aspdm92=2;
   else if asp92=3 then aspdm92=3;
   else if asp92=4 then aspdm92=4;
   else if asp92=5 then aspdm92=5;
   else if asp92 in (.,0,6) and allmiss92 in (1,2) then aspdm92=1; 
   else if asp92 in (.,0,6) and allmiss92=3 then aspdm92=.; /*if truly missing*/


   if ibu92=1 then ibudm92=1;
   else if ibu92=2 then ibudm92=2;
   else if ibu92=3 then ibudm92=3;
   else if ibu92=4 then ibudm92=4;
   else if ibu92=5 then ibudm92=5;
   else if ibu92 in (.,0,6) and allmiss92 in (1,2) then ibudm92=1; 
   else if ibu92 in (.,0,6) and allmiss92=3 then ibudm92=.; /*if truly missing*/


   if tyl92=1 then tyldm92=1;
   else if tyl92=2 then tyldm92=2;
   else if tyl92=3 then tyldm92=3;
   else if tyl92=4 then tyldm92=4;
   else if tyl92=5 then tyldm92=5;
   else if tyl92 in (.,0,6) and allmiss92 in (1,2) then tyldm92=1; 
   else if tyl92 in (.,0,6) and allmiss92=3 then tyldm92=.; /*if truly missing*/


   if asp92=1 then aspdd92=0;
   else if asp92=2 then aspdd92=2.5;
   else if asp92=3 then aspdd92=9.5;
   else if asp92=4 then aspdd92=18;
   else if asp92=5 then aspdd92=22;
   else if asp92 in (.,0,6) and allmiss92 in (1,2) then aspdd92=0; 
   else if asp92 in (.,0,6) and allmiss92=3 then aspdd92=.; /*if truly missing*/


   if ibu92=1 then ibudd92=0;
   else if ibu92=2 then ibudd92=2.5;
   else if ibu92=3 then ibudd92=9.5;
   else if ibu92=4 then ibudd92=18;
   else if ibu92=5 then ibudd92=22;
   else if ibu92 in (.,0,6) and allmiss92 in (1,2) then ibudd92=0; 
   else if ibu92 in (.,0,6) and allmiss92=3 then ibudd92=.; /*if truly missing*/


   if tyl92=1 then tyldd92=0;
   else if tyl92=2 then tyldd92=2.5;
   else if tyl92=3 then tyldd92=9.5;
   else if tyl92=4 then tyldd92=18;
   else if tyl92=5 then tyldd92=22;
   else if tyl92 in (.,0,6) and allmiss92 in (1,2) then tyldd92=0; 
   else if tyl92 in (.,0,6) and allmiss92=3 then tyldd92=.; /*if truly missing*/


   /**Assume each day of use is at least 1 tablet/day**/
      aspmo92=aspdd92*1;
      ibumo92=ibudd92*2;
      tylmo92=tyldd92*2;

   /**translate asp/month to asp/week ***/
      aspwk92=aspmo92/4.3;
      ibuwk92=ibumo92/4.3;
      tylwk92=tylmo92/4.3;

   /*1992 regural use of asp*/
   if  0<=aspwk92<2 then reguasp92=1;  
   else if aspwk92>=2 then reguasp92=2; 
   else if aspwk92=. then reguasp92=.;

   if asp92 in (1) then anyasp92=1;
      else if asp92 in (2,3,4,5) then anyasp92=2;
   else if asp92 in (.,0,6) and allmiss92 in (1,2) then anyasp92=1; 
      else anyasp92=.;
   
   if ibu92 in (1) then regibu92=1; 
      else if ibu92 in (2,3,4,5) then regibu92=2;
   else if ibu92 in (.,0,6) and allmiss92 in (1,2) then regibu92=1;    
      else regibu92=.;

   if tyl92 in (1) then regtyl92=1;
      else if tyl92 in (2,3,4,5) then regtyl92=2;
   else if tyl92 in (.,0,6) and allmiss92 in (1,2) then regtyl92=1;    
   else regtyl92=.;
run;


%nur94 (keep=aspd94 aspdm94 aspdd94 nasp94 aspwk94 aspmo94 asp94 reguasp94 anyasp94
             ibu94 regibu94 tyl94 regtyl94 batch94 ibuwk94 tylwk94);
   if aspd94 in (1,2) and nasp94 >1  then do; aspd94=0; nasp94=0; end;
   if aspd94>1 and nasp94=1 then do; aspd94=0; nasp94=0; end;   
   else if aspd94 in (.,0,7) then aspd=.;

   if aspd94=1 then aspdm94=1; 
   else if aspd94=2 then aspdm94=2; 
   else if aspd94=3 then aspdm94=3;
   else if aspd94=4 then aspdm94=4; 
   else if aspd94=5 then aspdm94=5; 
   else if aspd94=6 then aspdm94=5; 
   else if aspd94 in (.,0,7) then aspdm94=.;

   if aspd94=1 then aspdd94=0;
   else if aspd94=2 then aspdd94=2.5; 
   else if aspd94=3 then aspdd94=9.5;
   else if aspd94=4 then aspdd94=18; 
   else if aspd94=5 then aspdd94=30; 
   else if aspd94=6 then aspdd94=30; 
   else if aspd94 in (.,0,7) then aspdd94=.;

   if nasp94=1 then nasp=0;
   else if nasp94=2 then nasp=1.25;
   else if nasp94=3 then nasp=4;
   else if nasp94=4 then nasp=10;
   else if nasp94=5 then nasp=20;
   else if nasp94 in(.,0,6) then nasp=.;
   aspwk94 = nasp; 
   aspmo94 = nasp * 4.3; 

   if  0<=aspwk94<2 then reguasp94=1; 
   else if aspwk94>=2 then reguasp94=2; 
   else if aspwk94=. then reguasp94=.;


      if .<aspd94<2 or nasp94=1 then anyasp94=1; 
      else if aspd94 in (2,3,4,5,6) or nasp94 in (2,3,4,5) then anyasp94=2;
      else anyasp94=.; 

   if 0<batch94<800 then do;
      if ibu94=1 then regibu94=2;
      else regibu94=1;
      end;
   else regibu94=.;

   if 0<batch94<800 then do;
      if tyl94=1 then regtyl94=2;
      else regtyl94=1;
      end;
   else regtyl94=.;

   if 0<batch94<800 then ibuwk94=0;
   if ibu94=1 then ibuwk94=2;
   tylwk94=0;
   if tyl94=1 then tylwk94=2;
run;

%nur96(keep= aspdd96 aspdm96 aspd96 nasp96 aspwk96 aspmo96 reguasp96 anyasp96
   ibu96 tyl96 regibu96 regtyl96 batch96  oa96 oad96 batch96
   ibuwk96 tylwk96);

   if aspd96 in (1,2) and nasp96 >1  then do; aspd96=0; nasp96=0; end;
   if aspd96>1 and nasp96=1 then do; aspd96=0; nasp96=0; end;   
   else if aspd96 in (.,0,7) then aspd96=.;

   if aspd96=1 then aspdm96=1; 
   else if aspd96=2 then aspdm96=2; 
   else if aspd96=3 then aspdm96=3;
   else if aspd96=4 then aspdm96=4; 
   else if aspd96=5 then aspdm96=5; 
   else if aspd96=6 then aspdm96=5; 
   else if aspd96 in (.,0,7) then aspdm96=.;

   if aspd96=1 then aspdd96=0; 
   else if aspd96=2 then aspdd96=2.5; 
   else if aspd96=3 then aspdd96=9.5;
   else if aspd96=4 then aspdd96=18; 
   else if aspd96=5 then aspdd96=30; 
   else if aspd96=6 then aspdd96=30; 
   else if aspd96 in (.,0,7) then aspdd96=.;

   if nasp96=1 then nasp=0;
   else if nasp96=2 then nasp=1.25;
   else if nasp96=3 then nasp=4;
   else if nasp96=4 then nasp=10;
   else if nasp96=5 then nasp=20;
   else if nasp96 in(.,0,6) then nasp=.;
   aspwk96 = nasp;
   aspmo96 = nasp * 4.3; 

   if  0<=aspwk96<2 then reguasp96=1; 
   else if aspwk96>=2 then reguasp96=2; 
   else if aspwk96=. then reguasp96=.;

      if .<aspd96<2 or nasp96=1 then anyasp96=1; 
      else if aspd96 in (2,3,4,5,6) or nasp96 in (2,3,4,5) then anyasp96=2; /* user*/
      else anyasp96=.;

   if 0<batch96<800 then do; 
      if ibu96=1 then regibu96=2; 
      else regibu96=1; 
      end;
   else regibu96=.; 

   if 0<batch96<800 then do; 
      if tyl96=1 then regtyl96=2; 
      else regtyl96=1; 
      end;
   else regtyl96=.; 

/* bring in osteoarthritis from lifetime history question*/
   if oa96=1 then do;
   oa90f=.; oa92f=.; oa94f=.; oa96f=.;
   if oad96 in (1,2) then oa90f=1;
      else if oad96=3 then oa92f=1;
      else if oad96=4 then oa94f=1;
      else if oad96=5 then oa96f=1;
      end;
      else do;
      oa90f=2; oa92f=2; oa94f=2; oa96f=2; /*no OA*/
   end;

   ibuwk96=0;
   if ibu96=1 then ibuwk96=2;

   tylwk96=0;
   if tyl96=1 then tylwk96=2;
run;

%nur98(keep=aspd98 nasp98 aspwk98 aspdm98 aspdd98 reguasp98 anyasp98
   regtyl98 tyl98 tyld98 tyln98 tylwk98 tyldm98 tyldd98 
   regibu98 ibu98 ibud98 ibudm98 ibun98 ibuwk98 ibut98 
   q98 ibudd98 nondm98 nondd98 nonwk98);

   if aspd98 in (1,2) and nasp98 >1  then do; aspd98=0; nasp98=0; end;
   if aspd98>1 and nasp98=1 then do; aspd98=0; nasp98=0; end;   
   else if aspd98 in (.,0,7) then aspd98=.;

      if q98 in (1,2) then do; 
         if ibu98=1 then regibu98=2; 
         else regibu98=1; 
         end;
      else regibu98=.; 

      if q98 in (1,2) then do; 
         if tyl98=1 then regtyl98=2; 
         else regtyl98=1; 
         end;
      else regtyl98=.; 

      if .<aspd98<2 or nasp98=1 then anyasp98=1; 
      else if aspd98 in (2,3,4,5,6) or nasp98 in (2,3,4,5) then anyasp98=2; /* user*/
      else anyasp98=.; /*missing aspirin*/

   if aspd98=1 then aspdm98=1; 
   else if aspd98=2 then aspdm98=2; 
   else if aspd98=3 then aspdm98=3;
   else if aspd98=4 then aspdm98=4; 
   else if aspd98=5 then aspdm98=5; 
   else if aspd98=6 then aspdm98=5; 
   else if aspd98 in (.,0,7) then aspdm98=.;

   if regibu98=1 then ibudm98=1; 
   else if regibu98=2 then do;
      if ibud98=1 then ibudm98=2; 
      else if ibud98=2 then ibudm98=3;
      else if ibud98=3 then ibudm98=4;
      else if ibud98=4 then ibudm98=5;
      else if ibud98 in (.,0,5) then ibudm98=.;
   end;
   else ibudm98=.;
      
   if regibu98=1 then nondm98=1; 
   else if regibu98=2 then do;
      if ibut98=1 then do; 
         if ibudm98=1 then nondm98=1; 
         else if ibudm98=2 then nondm98=2; 
         else if ibudm98=3 then nondm98=3; 
         else if ibudm98=4 then nondm98=4; 
         else if ibudm98=5 then nondm98=5; 
      end;  
      else if ibut98=2 then do;
         if ibudm98=1 then nondm98=1; 
         else if ibudm98=2 then nondm98=6; 
         else if ibudm98=3 then nondm98=7; 
         else if ibudm98=4 then nondm98=8; 
         else if ibudm98=5 then nondm98=9; 
      end;
      else nondm98=10;  
   end;
   else nondm98=.; 
   
   if regtyl98=1 then tyldm98=1; 
      else if regtyl98=2 then do;
   if tyld98=1 then tyldm98=2; 
   else if tyld98=2 then tyldm98=3;
   else if tyld98=3 then tyldm98=4;
   else if tyld98=4 then tyldm98=5;
   else if tyld98 in (.,0,5) then tyldm98=.;
         end;
   else tyldm98=.;

   if aspd98=1 then aspdd98=0; 
   else if aspd98=2 then aspdd98=2.5; 
   else if aspd98=3 then aspdd98=9.5;
   else if aspd98=4 then aspdd98=18; 
   else if aspd98=5 then aspdd98=22; 
   else if aspd98=6 then aspdd98=22; 
   else if aspd98 in (.,0,7) then aspdd98=.;

      if regibu98=1 then ibudd98=0; 
      else if regibu98=2 then do;
   if ibud98=1 then ibudd98=2.5; 
   else if ibud98=2 then ibudd98=9.5;
   else if ibud98=3 then ibudd98=18;
   else if ibud98=4 then ibudd98=22;
   else if ibud98 in (.,0,5) then ibudd98=.;
         end;
   else ibudd98=.;
   
   if regibu98=1 then nondd98=0; 
   else if regibu98=2 then do;
      if ibut98=1 then do; 
         if ibudm98=1 then nondd98=0; 
         else if ibudm98=2 then nondd98=0; 
         else if ibudm98=3 then nondd98=0; 
         else if ibudm98=4 then nondd98=0; 
         else if ibudm98=5 then nondd98=0; 
      end;  
      else if ibut98=2 then do;
         if ibudm98=1 then nondd98=0; 
         else if ibudm98=2 then nondd98=2.5; 
         else if ibudm98=3 then nondd98=9.5; 
         else if ibudm98=4 then nondd98=18; 
         else if ibudm98=5 then nondd98=22; 
      end;
      else nondd98=.;  
   end;
   else nondd98=.; 
   
   if regtyl98=1 then tyldd98=0; 
      else if regtyl98=2 then do;
   if tyld98=1 then tyldd98=2.5; 
   else if tyld98=2 then tyldd98=9.5;
   else if tyld98=3 then tyldd98=18;
   else if tyld98=4 then tyldd98=22;
   else if tyld98 in (.,0,5) then tyldd98=.;
         end;
   else tyldd98=.;

   if nasp98=1 then nasp=0;
   else if nasp98=2 then nasp=1.25;
   else if nasp98=3 then nasp=4;
   else if nasp98=4 then nasp=10;
   else if nasp98=5 then nasp=20;
   else if nasp98 in(.,0,6) then nasp=.;
   aspwk98 = nasp;

   if regibu98=1 then ibuwk98=0; 
   else if regibu98=2 then do;
   if ibun98=1 then ibuwk98=1.5; 
   else if ibun98=2 then ibuwk98=4;
   else if ibun98=3 then ibuwk98=10;
   else if ibun98=4 then ibuwk98=20;
   else if ibun98 in (.,0,5) then ibuwk98=.;
         end;
   else ibuwk98=.; 

   
   if regibu98=1 then nonwk98=0; 
   else if regibu98=2 then do;
      if ibut98=1 then do; 
         if ibuwk98=0 then nonwk98=0; 
         else if ibuwk98=1.5 then nonwk98=0;
         else if ibuwk98=4 then nonwk98=0;
         else if ibuwk98=10 then nonwk98=0;
         else if ibuwk98=20 then nonwk98=0;
      end;  
      else if ibut98=2 then do; 
         if ibuwk98=0 then nonwk98=0; 
         else if ibuwk98=1.5 then nonwk98=1.5; 
         else if ibuwk98=4 then nonwk98=4; 
         else if ibuwk98=10 then nonwk98=10;  
         else if ibuwk98=20 then nonwk98=20; 
      end;
      else nonwk98=.;  
   end;
   else nonwk98=.; 
   
   if regtyl98=1 then tylwk98=0; 
   else if regtyl98=2 then do;
      if tyln98=1 then tylwk98=1.5; 
      else if tyln98=2 then tylwk98=4;
      else if tyln98=3 then tylwk98=10;
      else if tyln98=4 then tylwk98=20;
      else if tyln98 in (.,0,5) then tylwk98=.;
   end;
   else tylwk98=.;
   
   if  0<=aspwk98<2 then reguasp98=1; 
   else if aspwk98>=2 then reguasp98=2; 
   else if aspwk98=. then reguasp98=.;

run;


%nur00(keep=q00 asp00 aspd00 nasp00 aspwk00 aspdm00 aspdd00 regu00 reguasp00
   bab00 babd00 nbab00 babdm00 babdd00 regbab00 regaspb00 baby00
   regnsad00 
   regtyl00 tyl00 tyld00 tyln00 tylwk00 tyldm00 tyldd00 
   regibu00 ibu00 ibud00 ibudm00 ibun00 ibuwk00 ibut00 q00 
   ibudd00 regnon00 totadd00 totadm00
   celeb00 regcox00 oa00 oad00 oa96ff oa98f oa00f);

   if q00 in (1,2,3) then do; 
      if ibu00=1 then regibu00=2; 
      else regibu00=1; 
      end;
   else regibu00=.; 

   if q00 in (1,2,3) then do; 
      if tyl00=1 then regtyl00=2; 
      else regtyl00=1; 
      end;
   else regtyl00=.; 

   if q00 in (1,2,3) then do; 
      if ibut00=1 then regnon00=2; 
      else regnon00=1; 
      end;
   else regnon00=.; 

   if q00 in (1,2,3) then do; 
      if celeb00=1 then regcox00=2; 
      else regcox00=1; 
      end;
   else regcox00=.; 

   if q00 in (1,2,3) then do; 
   if asp00=1 then regu00=2; 
   else regu00=1; 
   end;
   else regu00=.; 

   if q00 in (1,2,3) then do; 
   if bab00=1 then regbab00=2; 
   else regbab00=1; 
   end;
   else regbab00=.;

   if regu00=1 then aspdm00=1; 
   else if regu00=2 then do;
   if aspd00=1 then aspdm00=2; 
   else if aspd00=2 then aspdm00=3;
   else if aspd00=3 then aspdm00=4;
   else if aspd00=4 then aspdm00=5;
   else if aspd00 in (.,0,5) then aspdm00=.;
   end;
   else aspdm00=.;

   if regbab00=1 then babdm00=1; 
   else if regbab00=2 then do;
   if babd00=1 then babdm00=2; 
   else if babd00=2 then babdm00=3;
   else if babd00=3 then babdm00=4;
   else if babd00=4 then babdm00=5;
   else if babd00 in (.,0,5) then babdm00=.;
   end;
   else babdm00=.;

   if regibu00=1 then ibudm00=1; 
   else if regibu00=2 then do;
      if ibud00=1 then ibudm00=2; 
      else if ibud00=2 then ibudm00=3;
      else if ibud00=3 then ibudm00=4;
      else if ibud00=4 then ibudm00=5;
      else if ibud00 in (.,0,5) then ibudm00=.;
   end;
   else ibudm00=.;
      
   if regtyl00=1 then tyldm00=1; 
   else if regtyl00=2 then do;
      if tyld00=1 then tyldm00=2; 
      else if tyld00=2 then tyldm00=3;
      else if tyld00=3 then tyldm00=4;
      else if tyld00=4 then tyldm00=5;
      else if tyld00 in (.,0,5) then tyldm00=.;
   end;
   else tyldm00=.;

   if regu00=1 then aspdd00=0; 
   else if regu00=2 then do;
   if aspd00=1 then aspdd00=2.5; 
   else if aspd00=2 then aspdd00=9.5;
   else if aspd00=3 then aspdd00=18;
   else if aspd00=4 then aspdd00=22;
   else if aspd00 in (.,0,5) then aspdd00=.;
   end;
   else aspdd00=.;
   /*baby aspirin*/
   if regbab00=1 then babdd00=0; 
   else if regbab00=2 then do;
   if babd00=1 then babdd00=2.5; 
   else if babd00=2 then babdd00=9.5;
   else if babd00=3 then babdd00=18;
   else if babd00=4 then babdd00=22;
   else if babd00 in (.,0,5) then babdd00=.;
   end;
   else babdd00=.;

   totadd00=sum (babdd00, aspdd00); 
   /*sum of all aspirin days - this can also be used as a continous variable for trend*/
   if totadd00=0 then totadm00=1; /*lowest category of days per month*/
   else if 0< totadd00 <=4 then totadm00=2; /*1-4 d/month*/
   else if 4< totadd00 <=14 then totadm00=3; /*5-14 d/month*/
   else if 15< totadd00<=21 then totadm00=4; /*15-21 d/month*/
   else if totadd00>21 then totadm00=5; /*22+ days/month*/


   if regibu00=1 then ibudd00=0; 
   else if regibu00=2 then do;
      if ibud00=1 then ibudd00=2.5; 
      else if ibud00=2 then ibudd00=9.5;
      else if ibud00=3 then ibudd00=18;
      else if ibud00=4 then ibudd00=22;
      else if ibud00 in (.,0,5) then ibudd00=.;
   end;
   else ibudd00=.;

   if regtyl00=1 then tyldd00=0; 
   else if regtyl00=2 then do;
      if tyld00=1 then tyldd00=2.5; 
      else if tyld00=2 then tyldd00=9.5;
      else if tyld00=3 then tyldd00=18;
      else if tyld00=4 then tyldd00=22;
      else if tyld00 in (.,0,5) then tyldd00=.;
   end;
   else tyldd00=.;
 
   if regu00=1 then nasp=0;
   else if regu00=2 then do; 
   if nasp00=1 then nasp=1.5;
   else if nasp00=2 then nasp=4;
   else if nasp00=3 then nasp=10;
   else if nasp00=4 then nasp=20;
   else if nasp00 in(.,0,5) then nasp=.;
   end;
   else nasp=.;

   /**set each baby aspirin group to the median number of asp consumed**/
   if regbab00=1 then nbab=0;
   else if regbab00=2 then do; 
   if nbab00=1 then nbab=1.5;
   else if nbab00=2 then nbab=4;
   else if nbab00=3 then nbab=10;
   else if nbab00=4 then nbab=20;
   else if nbab00 in(.,0,5) then nbab=.;
   end;
   else nbab=.;

   /*2000 average asp per week*/
   naspeq=nbab/4; /*number of aspirin equivalents*/
   /*2000 intake asp/week*/
   if nasp eq . and naspeq ne . then aspwk00=naspeq;
   else if nasp ne . and naspeq eq . then aspwk00=nasp;
   else  aspwk00 = nasp+ naspeq; 

   if regu00=2 and nasp in (0,.) and naspeq in (0,.) then aspwk00=.;  /*changed*/
   else if regbab00=2 and nasp in (0,.) and naspeq in (0,.) then aspwk00=.;
   /*2000 intake asp/month*/
   aspmo00 = aspwk00 * 4.3; 

   
      if regibu00=1 then ibuwk00=0; 
      else if regibu00=2 then do;
   if ibun00=1 then ibuwk00=1.5; 
   else if ibun00=2 then ibuwk00=4;
   else if ibun00=3 then ibuwk00=10;
   else if ibun00=4 then ibuwk00=20;
   else if ibun00 in (.,0,5) then ibuwk00=.;
         end;
   else ibuwk00=.; /*did not report any nsaid data*/
      
   
   /*set each group the median number of tylenol consumed*/
      if regtyl00=1 then tylwk00=0; 
      else if regtyl00=2 then do;
   if tyln00=1 then tylwk00=1.5; 
   else if tyln00=2 then tylwk00=4;
   else if tyln00=3 then tylwk00=10;
   else if tyln00=4 then tylwk00=20;
   else if tyln00 in (.,0,5) then tylwk00=.;
         end;
   else tylwk00=.; 


   /* bring in osteoarthritis from lifetime history question*/
      if oa00=1 then do;
      oa96ff=.; oa98f=.; oa00f=.; 
      if oad00 in (1) then oa96ff=1; /*differentiate this from the oa96f from nur96*/
         else if oad00=2 then oa98f=1;
         else if oad00 in (3,4) then oa00f=1;
         else if oad00=5 then oa02f=1;
         end;
         else do;
         oa96ff=2; oa98f=2; oa00f=2; oa02f=2;/*no OA*/
      end;


   /*regular aspirin or baby aspirin*/
   if regu00=1 and regbab00 in (.,1) then regaspb00=1;
   else if regu00 in (.,1) and regbab00=1 then regaspb00=1;
   else if regu00=2 and regbab00 in (.,1,2) then regaspb00=2;
   else if regu00 in (.,1,2) and regbab00=2 then regaspb00=2;


   /*regular nsaid*/
   if regibu00=1 and regnon00 in (.,1) and regcox00 in (.,1) then regnsad00=1;
   else if regibu00 in (.,1) and regnon00=1 and regcox00 in (.,1) then regnsad00=1;
   else if regibu00 in (.,1) and regnon00 in (.,1) and regcox00=1 then regnsad00=1;
   else if regibu00=2 and regnon00 in (.,1,2) and regcox00 in (.,1,2) then regnsad00=2;
   else if regibu00 in (.,1,2) and regnon00=2 and regcox00 in (.,1,2) then regnsad00=2;
   else if regibu00 in (.,1,2) and regnon00 in (.,1,2) and regcox00=2 then regnsad00=2;


   /*2000 regular use of aspirin*/
   if  0<=aspwk00<2 then reguasp00=1; 
   else if aspwk00>=2 then reguasp00=2; 
   else if aspwk00=. then reguasp00=.;

   baby00=1; 
   if bab00=1 and babd00=4 then baby00=3; 
   else if reguasp00=2 and aspd00=4 then baby00=4; 
   else if reguasp00=2 then baby00=2; 

run;

%nur02(keep=q02 asp02 aspd02 nasp02 aspwk02 aspdm02 aspdd02 regu02 reguasp02
   bab02 babd02 nbab02 babdm02 babdd02 regbab02 regaspb02 baby02
   regtyl02 tyl02 tyld02 tyln02 tylwk02 tyldm02 tyldd02 
   regibu02 ibu02 ibud02 ibudm02 nibu02 ibuwk02 ibut02 
   ibudd02 regnon02 totadd02 totadm02
   celeb02 regcox02  );

   if q02 in (1,2,3) then do; 
      if ibu02=1 then regibu02=2; 
      else regibu02=1; 
      end;
   else regibu02=.; 

   if q02 in (1,2,3) then do; 
      if tyl02=1 then regtyl02=2; 
      else regtyl02=1; 
      end;
   else regtyl02=.; 

   if q02 in (1,2,3) then do; 
      if ibut02=1 then regnon02=2; 
      else regnon02=1; 
      end;
   else regnon02=.; 

   if q02 in (1,2,3) then do; 
      if celeb02=1 then regcox02=2; 
      else regcox02=1; 
      end;
   else regcox02=.; 

   if q02 in (1,2,3) then do; 
   if asp02=1 then regu02=2; 
   else regu02=1; 
   end;
   else regu02=.; 

   /*bring in 2002 baby aspirin*/
   if q02 in (1,2,3) then do; 
   if bab02=1 then regbab02=2; 
   else regbab02=1; 
   end;
   else regbab02=.; 

   /*Days per month in categories - using days/week and make
   consistent with days per month from 1990 and 1992 questionnaires */
   if regu02=1 then aspdm02=1; 
   else if regu02=2 then do;
   if aspd02=1 then aspdm02=2; 
   else if aspd02=2 then aspdm02=3;
   else if aspd02=3 then aspdm02=4;
   else if aspd02=4 then aspdm02=5;
   else if aspd02 in (.,0,5) then aspdm02=.;
   end;
   else aspdm02=.;

   if regbab02=1 then babdm02=1; 
   else if regbab02=2 then do;
   if babd02=1 then babdm02=2; 
   else if babd02=2 then babdm02=3;
   else if babd02=3 then babdm02=4;
   else if babd02=4 then babdm02=5;
   else if babd02 in (.,0,5) then babdm02=.;
   end;
   else babdm02=.;


      if regibu02=1 then ibudm02=1; 
      else if regibu02=2 then do;
   if ibud02=1 then ibudm02=2; 
   else if ibud02=2 then ibudm02=3;
   else if ibud02=3 then ibudm02=4;
   else if ibud02=4 then ibudm02=5;
   else if ibud02 in (.,0,5) then ibudm02=.;
         end;
   else ibudm02=.;
         
   if regtyl02=1 then tyldm02=1; 
      else if regtyl02=2 then do;
   if tyld02=1 then tyldm02=2; 
   else if tyld02=2 then tyldm02=3;
   else if tyld02=3 then tyldm02=4;
   else if tyld02=4 then tyldm02=5;
   else if tyld02 in (.,0,5) then tyldm02=.;
         end;
   else tyldm02=.;


   /*Days per month set to medians consistent with 1990 and 1992 questionnaires */
   /*aspirin*/
   if regu02=1 then aspdd02=0; 
   else if regu02=2 then do;
   if aspd02=1 then aspdd02=2.5; 
   else if aspd02=2 then aspdd02=9.5;
   else if aspd02=3 then aspdd02=18;
   else if aspd02=4 then aspdd02=22;
   else if aspd02 in (.,0,5) then aspdd02=.;
   end;
   else aspdd02=.;
   /*baby aspirin*/
   if regbab02=1 then babdd02=0; 
   else if regbab02=2 then do;
   if babd02=1 then babdd02=2.5; 
   else if babd02=2 then babdd02=9.5;
   else if babd02=3 then babdd02=18;
   else if babd02=4 then babdd02=22;
   else if babd02 in (.,0,5) then babdd02=.;
   end;
   else babdd02=.;

   /*create a composite category of aspirin frequency which includes baby and full aspirin*/
   totadd02=sum (babdd02, aspdd02); 
   /*sum of all aspirin days - this can also be used as a continous variable for trend*/
   if totadd02=0 then totadm02=1; /*lowest category of days per month*/
   else if 0< totadd02 <=4 then totadm02=2; /*1-4 d/month*/
   else if 4< totadd02 <=14 then totadm02=3; /*5-14 d/month*/
   else if 15< totadd02<=21 then totadm02=4; /*15-21 d/month*/
   else if totadd02>21 then totadm02=5; /*22+ days/month*/


      if regibu02=1 then ibudd02=0; 
      else if regibu02=2 then do;
   if ibud02=1 then ibudd02=2.5; 
   else if ibud02=2 then ibudd02=9.5;
   else if ibud02=3 then ibudd02=18;
   else if ibud02=4 then ibudd02=22;
   else if ibud02 in (.,0,5) then ibudd02=.;
         end;
   else ibudd02=.;

   if regtyl02=1 then tyldd02=0; 
      else if regtyl02=2 then do;
   if tyld02=1 then tyldd02=2.5; 
   else if tyld02=2 then tyldd02=9.5;
   else if tyld02=3 then tyldd02=18;
   else if tyld02=4 then tyldd02=22;
   else if tyld02 in (.,0,5) then tyldd02=.;
         end;
   else tyldd02=.;



   /**set each aspirin group to the median number of asp consumed**/
   if regu02=1 then nasp=0;
   else if regu02=2 then do; 
   if nasp02=1 then nasp=1.5;
   else if nasp02=2 then nasp=4;
   else if nasp02=3 then nasp=10;
   else if nasp02=4 then nasp=20;
   else if nasp02 in(.,0,5) then nasp=.;
   end;
   else nasp=.;

   /**set each baby aspirin group to the median number of asp consumed**/
   if regbab02=1 then nbab=0;
   else if regbab02=2 then do; 
   if nbab02=1 then nbab=1.5;
   else if nbab02=2 then nbab=4;
   else if nbab02=3 then nbab=10;
   else if nbab02=4 then nbab=20;
   else if nbab02 in(.,0,5) then nbab=.;
   end;
   else nbab=.;

   /*2002 average asp per week*/
   naspeq=nbab/4; /*number of aspirin equivalents*/
   /*2002 intake asp/week*/
   if nasp eq . and naspeq ne . then aspwk02=naspeq;
   else if nasp ne . and naspeq eq . then aspwk02=nasp;
   else  aspwk02 = nasp+ naspeq; 

   if regu02=2 and nasp in (0,.) and naspeq in (0,.) then aspwk02=.; /*changed*/
   else if regbab02=2 and nasp in (0,.) and naspeq in (0,.) then aspwk02=.;

   /*2002 intake asp/month*/
   aspmo02 = aspwk02 * 4.3; 


   
      if regibu02=1 then ibuwk02=0; 
      else if regibu02=2 then do;
   if nibu02=1 then ibuwk02=1.5; 
   else if nibu02=2 then ibuwk02=4;
   else if nibu02=3 then ibuwk02=10;
   else if nibu02=4 then ibuwk02=20;
   else if nibu02 in (.,0,5) then ibuwk02=.;
         end;
   else ibuwk02=.; /*did not report any nsaid data*/
      
   
   /*set each group the median number of tylenol consumed*/
      if regtyl02=1 then tylwk02=0; 
      else if regtyl02=2 then do;
   if tyln02=1 then tylwk02=1.5; 
   else if tyln02=2 then tylwk02=4;
   else if tyln02=3 then tylwk02=10;
   else if tyln02=4 then tylwk02=20;
   else if tyln02 in (.,0,5) then tylwk02=.;
         end;
   else tylwk02=.; 



   /*regular aspirin or baby aspirin*/
   if regu02=1 and regbab02 in (.,1) then regaspb02=1;
   else if regu02 in (.,1) and regbab02=1 then regaspb02=1;
   else if regu02=2 and regbab02 in (.,1,2) then regaspb02=2;
   else if regu02 in (.,1,2) and regbab02=2 then regaspb02=2;

   /*regular nsaid*/
   if regibu02=1 and regnon02 in (.,1) and regcox02 in (.,1) then regnsad02=1;
   else if regibu02 in (.,1) and regnon02=1 and regcox02 in (.,1) then regnsad02=1;
   else if regibu02 in (.,1) and regnon02 in (.,1) and regcox02=1 then regnsad02=1;
   else if regibu02=2 and regnon02 in (.,1,2) and regcox02 in (.,1,2) then regnsad02=2;
   else if regibu02 in (.,1,2) and regnon02=2 and regcox02 in (.,1,2) then regnsad02=2;
   else if regibu02 in (.,1,2) and regnon02 in (.,1,2) and regcox02=2 then regnsad02=2;


   /*2002 regular use of aspirin*/
   if  0<=aspwk02<2 then reguasp02=1; 
   else if aspwk02>=2 then reguasp02=2; 
   else if aspwk02=. then reguasp02=.;

   baby02=1; 
   if bab02=1 and babd02=4 then baby02=3; 
   else if reguasp02=2 and aspd02=4 then baby02=4; 
   else if reguasp02=2 then baby02=2; /*infrequent user*/

run;

%nur04(keep=q04 asp04 aspd04 nasp04 aspwk04 aspdm04 aspdd04 regu04 reguasp04
      bab04 babd04 nbab04 babdm04 babdd04 regbab04 regaspb04 baby04
      regnsad04
      regtyl04 tyl04 tyld04 tyln04 tylwk04 tyldm04 tyldd04 
      regibu04 ibu04 ibud04 ibudm04 nibu04 ibuwk04 ibut04 
      ibudd04  regnon04 totadd04 totadm04
      celeb04 regcox04 );

      if q04 in (1,2) then do; 
         if ibu04=1 then regibu04=2; 
         else regibu04=1; 
         end;
      else regibu04=.; 

      if q04 in (1,2) then do; 
         if tyl04=1 then regtyl04=2; 
         else regtyl04=1; 
         end;
      else regtyl04=.; 

      if q04 in (1,2) then do; 
         if ibut04=1 then regnon04=2; 
         else regnon04=1; 
         end;
      else regnon04=.; 

      if q04 in (1,2) then do; 
         if celeb04=1 then regcox04=2; 
         else regcox04=1; 
         end;
      else regcox04=.; 

      if q04 in (1,2) then do; 
      if asp04=1 then regu04=2; 
      else regu04=1; 
      end;
      else regu04=.; 


      /*bring in 2004 baby aspirin*/
      if q04 in (1,2) then do; 
      if bab04=1 then regbab04=2; 
      else regbab04=1; 
      end;
      else regbab04=.; 

      /*Days per month in categories - using days/week and make
      consistent with days per month from 1990 and 1992 questionnaires */
      if regu04=1 then aspdm04=1; 
      else if regu04=2 then do;
      if aspd04=1 then aspdm04=2; 
      else if aspd04=2 then aspdm04=3;
      else if aspd04=3 then aspdm04=4;
      else if aspd04=4 then aspdm04=5;
      else if aspd04 in (.,0,5) then aspdm04=.;
      end;
      else aspdm04=.;

      if regbab04=1 then babdm04=1; 
      else if regbab04=2 then do;
      if babd04=1 then babdm04=2; 
      else if babd04=2 then babdm04=3;
      else if babd04=3 then babdm04=4;
      else if babd04=4 then babdm04=5;
      else if babd04 in (.,0,5) then babdm04=.;
      end;
      else babdm04=.;


         if regibu04=1 then ibudm04=1; 
         else if regibu04=2 then do;
      if ibud04=1 then ibudm04=2; 
      else if ibud04=2 then ibudm04=3;
      else if ibud04=3 then ibudm04=4;
      else if ibud04=4 then ibudm04=5;
      else if ibud04 in (.,0,5) then ibudm04=.;
            end;
      else ibudm04=.;
            
      if regtyl04=1 then tyldm04=1; 
         else if regtyl04=2 then do;
      if tyld04=1 then tyldm04=2; 
      else if tyld04=2 then tyldm04=3;
      else if tyld04=3 then tyldm04=4;
      else if tyld04=4 then tyldm04=5;
      else if tyld04 in (.,0,5) then tyldm04=.;
            end;
      else tyldm04=.;


      /*Days per month set to medians consistent with 1990 and 1992 questionnaires */
      /*aspirin*/
      if regu04=1 then aspdd04=0; 
      else if regu04=2 then do;
      if aspd04=1 then aspdd04=2.5; 
      else if aspd04=2 then aspdd04=9.5;
      else if aspd04=3 then aspdd04=18;
      else if aspd04=4 then aspdd04=22;
      else if aspd04 in (.,0,5) then aspdd04=.;
      end;
      else aspdd04=.;
      /*baby aspirin*/
      if regbab04=1 then babdd04=0; 
      else if regbab04=2 then do;
      if babd04=1 then babdd04=2.5; 
      else if babd04=2 then babdd04=9.5;
      else if babd04=3 then babdd04=18;
      else if babd04=4 then babdd04=22;
      else if babd04 in (.,0,5) then babdd04=.;
      end;
      else babdd04=.;

      /*create a composite category of aspirin frequency which includes baby and full aspirin*/
      totadd04=sum (babdd04, aspdd04); 
      /*sum of all aspirin days - this can also be used as a continous variable for trend*/
      if totadd04=0 then totadm04=1; /*lowest category of days per month*/
      else if 0< totadd04 <=4 then totadm04=2; /*1-4 d/month*/
      else if 4< totadd04 <=14 then totadm04=3; /*5-14 d/month*/
      else if 15< totadd04<=21 then totadm04=4; /*15-21 d/month*/
      else if totadd04>21 then totadm04=5; /*22+ days/month*/


         if regibu04=1 then ibudd04=0; 
         else if regibu04=2 then do;
      if ibud04=1 then ibudd04=2.5; 
      else if ibud04=2 then ibudd04=9.5;
      else if ibud04=3 then ibudd04=18;
      else if ibud04=4 then ibudd04=22;
      else if ibud04 in (.,0,5) then ibudd04=.;
            end;
      else ibudd04=.;

      if regtyl04=1 then tyldd04=0; 
         else if regtyl04=2 then do;
      if tyld04=1 then tyldd04=2.5; 
      else if tyld04=2 then tyldd04=9.5;
      else if tyld04=3 then tyldd04=18;
      else if tyld04=4 then tyldd04=22;
      else if tyld04 in (.,0,5) then tyldd04=.;
            end;
      else tyldd04=.;


      /**set each aspirin group to the median number of asp consumed**/
      if regu04=1 then nasp=0;
      else if regu04=2 then do; 
      if nasp04=1 then nasp=1.5;
      else if nasp04=2 then nasp=4;
      else if nasp04=3 then nasp=10;
      else if nasp04=4 then nasp=20;
      else if nasp04 in(.,0,5) then nasp=.;
      end;
      else nasp=.;

      /**set each baby aspirin group to the median number of asp consumed**/
      if regbab04=1 then nbab=0;
      else if regbab04=2 then do; 
      if nbab04=1 then nbab=1.5;
      else if nbab04=2 then nbab=4;
      else if nbab04=3 then nbab=10;
      else if nbab04=4 then nbab=20;
      else if nbab04 in(.,0,5) then nbab=.;
      end;
      else nbab=.;

      /*2004 average asp per week*/
      naspeq=nbab/4; /*number of aspirin equivalents*/
      /*2004 intake asp/week*/
      if nasp eq . and naspeq ne . then aspwk04=naspeq;
      else if nasp ne . and naspeq eq . then aspwk04=nasp;
      else  aspwk04 = nasp+ naspeq; 

      if regu04=2 and nasp in (0,.) and naspeq in (0,.) then aspwk04=.;  /*changed*/
      else if regbab04=2 and nasp in (0,.) and naspeq in (0,.) then aspwk04=.;

      
      aspmo04 = aspwk04 * 4.3; 

      
         if regibu04=1 then ibuwk04=0; 
         else if regibu04=2 then do;
      if nibu04=1 then ibuwk04=1.5; 
      else if nibu04=2 then ibuwk04=4;
      else if nibu04=3 then ibuwk04=10;
      else if nibu04=4 then ibuwk04=20;
      else if nibu04 in (.,0,5) then ibuwk04=.;
            end;
      else ibuwk04=.; /*did not report any nsaid data*/
         
      
      /*set each group the median number of tylenol consumed*/
         if regtyl04=1 then tylwk04=0; 
         else if regtyl04=2 then do;
      if tyln04=1 then tylwk04=1.5; 
      else if tyln04=2 then tylwk04=4;
      else if tyln04=3 then tylwk04=10;
      else if tyln04=4 then tylwk04=20;
      else if tyln04 in (.,0,5) then tylwk04=.;
            end;
      else tylwk04=.; 


      /*regular nsaid*/
      if regibu04=1 and regnon04 in (.,1) and regcox04 in (.,1) then regnsad04=1;
      else if regibu04 in (.,1) and regnon04=1 and regcox04 in (.,1) then regnsad04=1;
      else if regibu04 in (.,1) and regnon04 in (.,1) and regcox04=1 then regnsad04=1;
      else if regibu04=2 and regnon04 in (.,1,2) and regcox04 in (.,1,2) then regnsad04=2;
      else if regibu04 in (.,1,2) and regnon04=2 and regcox04 in (.,1,2) then regnsad04=2;
      else if regibu04 in (.,1,2) and regnon04 in (.,1,2) and regcox04=2 then regnsad04=2;



      /*regular aspirin or baby aspirin*/
      if regu04=1 and regbab04 in (.,1) then regaspb04=1;
      else if regu04 in (.,1) and regbab04=1 then regaspb04=1;
      else if regu04=2 and regbab04 in (.,1,2) then regaspb04=2;
      else if regu04 in (.,1,2) and regbab04=2 then regaspb04=2;

      /*2004 regular use of aspirin*/
      if  0<=aspwk04<2 then reguasp04=1; 
      else if aspwk04>=2 then reguasp04=2; 
      else if aspwk04=. then reguasp04=.;

      baby04=1; 
      if bab04=1 and babd04=4 then baby04=3; 
      else if reguasp04=2 and aspd04=4 then baby04=4; 
      else if reguasp04=2 then baby04=2; /*infrequent user*/

   run;



   %nur06(keep=q06 asp06 aspd06 nasp06 aspwk06 aspdm06 aspdd06 regu06 reguasp06
      bab06 babd06 nbab06 babdm06 babdd06 regbab06 regaspb06 baby06
      regnsad06
      regtyl06 tyl06 tyld06 tyln06 tylwk06 tyldm06 tyldd06 
      regibu06 ibu06 ibud06 ibudm06 nibu06 ibuwk06 ibut06 
      ibudd06  regnon06 totadd06 totadm06
      celeb06 regcox06 );

      if q06 in (1,2) then do; 
         if ibu06=1 then regibu06=2; 
         else regibu06=1; 
         end;
      else regibu06=.; 

      if q06 in (1,2) then do; 
         if tyl06=1 then regtyl06=2; 
         else regtyl06=1; 
         end;
      else regtyl06=.; 

      if q06 in (1,2) then do; 
         if ibut06=1 then regnon06=2; 
         else regnon06=1; 
         end;
      else regnon06=.; 

      if q06 in (1,2) then do; 
         if celeb06=1 then regcox06=2; 
         else regcox06=1; 
         end;
      else regcox06=.; 

      if q06 in (1,2,3,4) then do; /*filled out long, booklet, pg1-2 or telephone questionnaire*/
      if asp06=1 then regu06=2; 
      else regu06=1; 
      end;
      else regu06=.; 


      /*bring in 2006 baby aspirin*/
      if q06 in (1,2,3,4) then do; /*filled out long, booklet, pg1-2 or telephone questionnaire*/
      if bab06=1 then regbab06=2; 
      else regbab06=1; 
      end;
      else regbab06=.; 

      /*Days per month in categories - using days/week and make
      consistent with days per month from 1990 and 1992 questionnaires */
      if regu06=1 then aspdm06=1; 
      else if regu06=2 then do;
      if aspd06=1 then aspdm06=2; 
      else if aspd06=2 then aspdm06=3;
      else if aspd06=3 then aspdm06=4;
      else if aspd06=4 then aspdm06=5;
      else if aspd06 in (.,0,5) then aspdm06=.;
      end;
      else aspdm06=.;

      if regbab06=1 then babdm06=1; 
      else if regbab06=2 then do;
      if babd06=1 then babdm06=2; 
      else if babd06=2 then babdm06=3;
      else if babd06=3 then babdm06=4;
      else if babd06=4 then babdm06=5;
      else if babd06 in (.,0,5) then babdm06=.;
      end;
      else babdm06=.;

         if regibu06=1 then ibudm06=1; 
         else if regibu06=2 then do;
      if ibud06=1 then ibudm06=2; 
      else if ibud06=2 then ibudm06=3;
      else if ibud06=3 then ibudm06=4;
      else if ibud06=4 then ibudm06=5;
      else if ibud06 in (.,0,5) then ibudm06=.;
            end;
      else ibudm06=.;
            
      if regtyl06=1 then tyldm06=1; 
         else if regtyl06=2 then do;
      if tyld06=1 then tyldm06=2; 
      else if tyld06=2 then tyldm06=3;
      else if tyld06=3 then tyldm06=4;
      else if tyld06=4 then tyldm06=5;
      else if tyld06 in (.,0,5) then tyldm06=.;
            end;
      else tyldm06=.;



      /*Days per month set to medians consistent with 1990 and 1992 questionnaires */
      /*aspirin*/
      if regu06=1 then aspdd06=0; 
      else if regu06=2 then do;
      if aspd06=1 then aspdd06=2.5; 
      else if aspd06=2 then aspdd06=9.5;
      else if aspd06=3 then aspdd06=18;
      else if aspd06=4 then aspdd06=22;
      else if aspd06 in (.,0,5) then aspdd06=.;
      end;
      else aspdd06=.;
      /*baby aspirin*/
      if regbab06=1 then babdd06=0; 
      else if regbab06=2 then do;
      if babd06=1 then babdd06=2.5; 
      else if babd06=2 then babdd06=9.5;
      else if babd06=3 then babdd06=18;
      else if babd06=4 then babdd06=22;
      else if babd06 in (.,0,5) then babdd06=.;
      end;
      else babdd06=.;

      /*create a composite category of aspirin frequency which includes baby and full aspirin*/
      totadd06=sum (babdd06, aspdd06); 
      /*sum of all aspirin days - this can also be used as a continous variable for trend*/
      if totadd06=0 then totadm06=1; /*lowest category of days per month*/
      else if 0< totadd06 <=4 then totadm06=2; /*1-4 d/month*/
      else if 4< totadd06 <=14 then totadm06=3; /*5-14 d/month*/
      else if 15< totadd06<=21 then totadm06=4; /*15-21 d/month*/
      else if totadd06>21 then totadm06=5; /*22+ days/month*/

         if regibu06=1 then ibudd06=0; 
         else if regibu06=2 then do;
      if ibud06=1 then ibudd06=2.5; 
      else if ibud06=2 then ibudd06=9.5;
      else if ibud06=3 then ibudd06=18;
      else if ibud06=4 then ibudd06=22;
      else if ibud06 in (.,0,5) then ibudd06=.;
            end;
      else ibudd06=.;

      if regtyl06=1 then tyldd06=0; 
         else if regtyl06=2 then do;
      if tyld06=1 then tyldd06=2.5; 
      else if tyld06=2 then tyldd06=9.5;
      else if tyld06=3 then tyldd06=18;
      else if tyld06=4 then tyldd06=22;
      else if tyld06 in (.,0,5) then tyldd06=.;
            end;
      else tyldd06=.;


      /**set each aspirin group to the median number of asp consumed**/
      if regu06=1 then nasp=0;
      else if regu06=2 then do; 
      if nasp06=1 then nasp=1.5;
      else if nasp06=2 then nasp=4;
      else if nasp06=3 then nasp=10;
      else if nasp06=4 then nasp=20;
      else if nasp06 in(.,0,5) then nasp=.;
      end;
      else nasp=.;

      /**set each baby aspirin group to the median number of asp consumed**/
      if regbab06=1 then nbab=0;
      else if regbab06=2 then do; 
      if nbab06=1 then nbab=1.5;
      else if nbab06=2 then nbab=4;
      else if nbab06=3 then nbab=10;
      else if nbab06=4 then nbab=20;
      else if nbab06 in(.,0,5) then nbab=.;
      end;
      else nbab=.;

      /*2006 average asp per week*/
      naspeq=nbab/4; /*number of aspirin equivalents*/
      /*2006 intake asp/week*/
      if nasp eq . and naspeq ne . then aspwk06=naspeq;
      else if nasp ne . and naspeq eq . then aspwk06=nasp;
      else  aspwk06 = nasp+ naspeq; 

      if regu06=2 and nasp in (0,.) and naspeq in (0,.) then aspwk06=.; /*changed*/
      else if regbab06=2 and nasp in (0,.) and naspeq in (0,.) then aspwk06=.;

      /*2006 intake asp/month*/
      aspmo06 = aspwk06 * 4.3; 

      
         if regibu06=1 then ibuwk06=0; 
         else if regibu06=2 then do;
      if nibu06=1 then ibuwk06=1.5; 
      else if nibu06=2 then ibuwk06=4;
      else if nibu06=3 then ibuwk06=10;
      else if nibu06=4 then ibuwk06=20;
      else if nibu06 in (.,0,5) then ibuwk06=.;
            end;
      else ibuwk06=.; /*did not report any nsaid data*/
         
      
      /*set each group the median number of tylenol consumed*/
         if regtyl06=1 then tylwk06=0; 
         else if regtyl06=2 then do;
      if tyln06=1 then tylwk06=1.5; 
      else if tyln06=2 then tylwk06=4;
      else if tyln06=3 then tylwk06=10;
      else if tyln06=4 then tylwk06=20;
      else if tyln06 in (.,0,5) then tylwk06=.;
            end;
      else tylwk06=.; 


      /*regular nsaid*/
      if regibu06=1 and regnon06 in (.,1) and regcox06 in (.,1) then regnsad06=1;
      else if regibu06 in (.,1) and regnon06=1 and regcox06 in (.,1) then regnsad06=1;
      else if regibu06 in (.,1) and regnon06 in (.,1) and regcox06=1 then regnsad06=1;
      else if regibu06=2 and regnon06 in (.,1,2) and regcox06 in (.,1,2) then regnsad06=2;
      else if regibu06 in (.,1,2) and regnon06=2 and regcox06 in (.,1,2) then regnsad06=2;
      else if regibu06 in (.,1,2) and regnon06 in (.,1,2) and regcox06=2 then regnsad06=2;


      /*regular aspirin or baby aspirin*/
      if regu06=1 and regbab06 in (.,1) then regaspb06=1;
      else if regu06 in (.,1) and regbab06=1 then regaspb06=1;
      else if regu06=2 and regbab06 in (.,1,2) then regaspb06=2;
      else if regu06 in (.,1,2) and regbab06=2 then regaspb06=2;

      /*2006 regular use of aspirin*/
      if  0<=aspwk06<2 then reguasp06=1; 
      else if aspwk06>=2 then reguasp06=2; 
      else if aspwk06=. then reguasp06=.;

      baby06=1; 
      if bab06=1 and babd06=4 then baby06=3; 
      else if reguasp06=2 and aspd06=4 then baby06=4; 
      else if reguasp06=2 then baby06=2; /*infrequent user*/

run;

%nur08(keep=q08 asp08 aspd08 nasp08 aspwk08 aspdm08 aspdd08 regu08 reguasp08
      bab08 babd08 nbab08 babdm08 babdd08 regbab08 regaspb08 baby08
      regnsad08
      regtyl08 tyl08 tyld08 tyln08 tylwk08 tyldm08 tyldd08 
      regibu08 ibu08 ibud08 ibudm08 nibu08 ibuwk08 ibut08 
      ibudd08  regnon08 totadd08 totadm08
      celeb08 regcox08 );

   if q08 in (1,2) then do; 
      if ibu08=1 then regibu08=2; 
      else regibu08=1; 
      end;
   else regibu08=.; 

   if q08 in (1,2) then do; 
      if tyl08=1 then regtyl08=2; 
      else regtyl08=1; 
      end;
   else regtyl08=.; 

   if q08 in (1,2) then do; 
      if ibut08=1 then regnon08=2; 
      else regnon08=1; 
      end;
   else regnon08=.; 

   if q08 in (1,2) then do; 
      if celeb08=1 then regcox08=2; 
      else regcox08=1; 
      end;
   else regcox08=.; 

   if q08 in (1,2) then do; 
   if asp08=1 then regu08=2; 
   else regu08=1; 
   end;
   else regu08=.; 


   /*bring in 2008 baby aspirin*/
   if q08 in (1,2) then do; 
   if bab08=1 then regbab08=2; 
   else regbab08=1; 
   end;
   else regbab08=.; 

   /*Days per month in categories - using days/week and make
   consistent with days per month from 1990 and 1992 questionnaires */
   if regu08=1 then aspdm08=1; 
   else if regu08=2 then do;
   if aspd08=1 then aspdm08=2; 
   else if aspd08=2 then aspdm08=3;
   else if aspd08=3 then aspdm08=4;
   else if aspd08=4 then aspdm08=5;
   else if aspd08 in (.,0,5) then aspdm08=.;
   end;
   else aspdm08=.;

   if regbab08=1 then babdm08=1; 
   else if regbab08=2 then do;
   if babd08=1 then babdm08=2; 
   else if babd08=2 then babdm08=3;
   else if babd08=3 then babdm08=4;
   else if babd08=4 then babdm08=5;
   else if babd08 in (.,0,5) then babdm08=.;
   end;
   else babdm08=.;


      if regibu08=1 then ibudm08=1; 
      else if regibu08=2 then do;
   if ibud08=1 then ibudm08=2; 
   else if ibud08=2 then ibudm08=3;
   else if ibud08=3 then ibudm08=4;
   else if ibud08=4 then ibudm08=5;
   else if ibud08 in (.,0,5) then ibudm08=.;
         end;
   else ibudm08=.;
         
   if regtyl08=1 then tyldm08=1; 
      else if regtyl08=2 then do;
   if tyld08=1 then tyldm08=2; 
   else if tyld08=2 then tyldm08=3;
   else if tyld08=3 then tyldm08=4;
   else if tyld08=4 then tyldm08=5;
   else if tyld08 in (.,0,5) then tyldm08=.;
         end;
   else tyldm08=.;



   /*Days per month set to medians consistent with 1990 and 1992 questionnaires */
   /*aspirin*/
   if regu08=1 then aspdd08=0; 
   else if regu08=2 then do;
   if aspd08=1 then aspdd08=2.5; 
   else if aspd08=2 then aspdd08=9.5;
   else if aspd08=3 then aspdd08=18;
   else if aspd08=4 then aspdd08=22;
   else if aspd08 in (.,0,5) then aspdd08=.;
   end;
   else aspdd08=.;
   /*baby aspirin*/
   if regbab08=1 then babdd08=0; 
   else if regbab08=2 then do;
   if babd08=1 then babdd08=2.5; 
   else if babd08=2 then babdd08=9.5;
   else if babd08=3 then babdd08=18;
   else if babd08=4 then babdd08=22;
   else if babd08 in (.,0,5) then babdd08=.;
   end;
   else babdd08=.;

   /*create a composite category of aspirin frequency which includes baby and full aspirin*/
   totadd08=sum (babdd08, aspdd08); 
   /*sum of all aspirin days - this can also be used as a continous variable for trend*/
   if totadd08=0 then totadm08=1; /*lowest category of days per month*/
   else if 0< totadd08 <=4 then totadm08=2; /*1-4 d/month*/
   else if 4< totadd08 <=14 then totadm08=3; /*5-14 d/month*/
   else if 15< totadd08<=21 then totadm08=4; /*15-21 d/month*/
   else if totadd08>21 then totadm08=5; /*22+ days/month*/


      if regibu08=1 then ibudd08=0; 
      else if regibu08=2 then do;
   if ibud08=1 then ibudd08=2.5; 
   else if ibud08=2 then ibudd08=9.5;
   else if ibud08=3 then ibudd08=18;
   else if ibud08=4 then ibudd08=22;
   else if ibud08 in (.,0,5) then ibudd08=.;
         end;
   else ibudd08=.;

   if regtyl08=1 then tyldd08=0; 
      else if regtyl08=2 then do;
   if tyld08=1 then tyldd08=2.5; 
   else if tyld08=2 then tyldd08=9.5;
   else if tyld08=3 then tyldd08=18;
   else if tyld08=4 then tyldd08=22;
   else if tyld08 in (.,0,5) then tyldd08=.;
         end;
   else tyldd08=.;


   /**set each aspirin group to the median number of asp consumed**/
   if regu08=1 then nasp=0;
   else if regu08=2 then do; 
   if nasp08=1 then nasp=1.5;
   else if nasp08=2 then nasp=4;
   else if nasp08=3 then nasp=10;
   else if nasp08=4 then nasp=20;
   else if nasp08 in(.,0,5) then nasp=.;
   end;
   else nasp=.;

   /**set each baby aspirin group to the median number of asp consumed**/
   if regbab08=1 then nbab=0;
   else if regbab08=2 then do; 
   if nbab08=1 then nbab=1.5;
   else if nbab08=2 then nbab=4;
   else if nbab08=3 then nbab=10;
   else if nbab08=4 then nbab=20;
   else if nbab08 in(.,0,5) then nbab=.;
   end;
   else nbab=.;

   /*2008 average asp per week*/
   naspeq=nbab/4; /*number of aspirin equivalents*/
   /*2008 intake asp/week*/
   if nasp eq . and naspeq ne . then aspwk08=naspeq;
   else if nasp ne . and naspeq eq . then aspwk08=nasp;
   else  aspwk08 = nasp+ naspeq; 

   if regu08=2 and nasp in (0,.) and naspeq in (0,.) then aspwk08=.; /*changed*/
   else if regbab08=2 and nasp in (0,.) and naspeq in (0,.) then aspwk08=.; /*changed*/

   /*2008 intake asp/month*/
   aspmo08 = aspwk08 * 4.3; 


   
      if regibu08=1 then ibuwk08=0; 
      else if regibu08=2 then do;
   if nibu08=1 then ibuwk08=1.5; 
   else if nibu08=2 then ibuwk08=4;
   else if nibu08=3 then ibuwk08=10;
   else if nibu08=4 then ibuwk08=20;
   else if nibu08 in (.,0,5) then ibuwk08=.;
         end;
   else ibuwk08=.; /*did not report any nsaid data*/
      
   
   /*set each group the median number of tylenol consumed*/
      if regtyl08=1 then tylwk08=0; 
      else if regtyl08=2 then do;
   if tyln08=1 then tylwk08=1.5; 
   else if tyln08=2 then tylwk08=4;
   else if tyln08=3 then tylwk08=10;
   else if tyln08=4 then tylwk08=20;
   else if tyln08 in (.,0,5) then tylwk08=.;
         end;
   else tylwk08=.; 


   /*regular nsaid*/
   if regibu08=1 and regnon08 in (.,1) and regcox08 in (.,1) then regnsad08=1;
   else if regibu08 in (.,1) and regnon08=1 and regcox08 in (.,1) then regnsad08=1;
   else if regibu08 in (.,1) and regnon08 in (.,1) and regcox08=1 then regnsad08=1;
   else if regibu08=2 and regnon08 in (.,1,2) and regcox08 in (.,1,2) then regnsad08=2;
   else if regibu08 in (.,1,2) and regnon08=2 and regcox08 in (.,1,2) then regnsad08=2;
   else if regibu08 in (.,1,2) and regnon08 in (.,1,2) and regcox08=2 then regnsad08=2;



   /*regular aspirin or baby aspirin*/
   if regu08=1 and regbab08 in (.,1) then regaspb08=1;
   else if regu08 in (.,1) and regbab08=1 then regaspb08=1;
   else if regu08=2 and regbab08 in (.,1,2) then regaspb08=2;
   else if regu08 in (.,1,2) and regbab08=2 then regaspb08=2;

   /*2008 regular use of aspirin*/
   if  0<=aspwk08<2 then reguasp08=1; 
   else if aspwk08>=2 then reguasp08=2; 
   else if aspwk08=. then reguasp08=.;

   baby08=1; 
   if bab08=1 and babd08=4 then baby08=3; 
   else if reguasp08=2 and aspd08=4 then baby08=4; 
   else if reguasp08=2 then baby08=2; /*infrequent user*/

run;

%nur10(keep=q10 asp10 aspd10 nasp10 aspwk10 aspdm10 aspdd10 regu10 reguasp10
   bab10 babd10 nbab10 babdm10 babdd10 regbab10 regaspb10 baby10
	regnsad10
   regtyl10 tyl10 tyld10 tyln10 tylwk10 tyldm10 tyldd10 
   regibu10 ibu10 ibud10 ibudm10 nibu10 ibuwk10 ibut10 
   ibudd10  regnon10 totadd10 totadm10
   celeb10 regcox10 );

   if q10 in (1,2) then do; 
      if ibu10=1 then regibu10=2; 
      else regibu10=1; 
      end;
   else regibu10=.; 

   if q10 in (1,2) then do; 
      if tyl10=1 then regtyl10=2; 
      else regtyl10=1; 
      end;
   else regtyl10=.; 


   if q10 in (1,2) then do; 
      if ibut10=1 then regnon10=2; 
      else regnon10=1; 
      end;
   else regnon10=.; 

   if q10 in (1,2) then do; 
      if celeb10=1 then regcox10=2; 
      else regcox10=1; 
      end;
   else regcox10=.; 

   if q10 in (1,2) then do; 
   if asp10=1 then regu10=2; 
   else regu10=1; 
   end;
   else regu10=.; 

   if q10 in (1,2) then do; 
   if bab10=1 then regbab10=2; 
   else regbab10=1; 
   end;
   else regbab10=.; 

   if regu10=1 then aspdm10=1; 
   else if regu10=2 then do;
   if aspd10=1 then aspdm10=2; 
   else if aspd10=2 then aspdm10=3;
   else if aspd10=3 then aspdm10=4;
   else if aspd10=4 then aspdm10=5;
   else if aspd10 in (.,0,5) then aspdm10=.;
   end;
   else aspdm10=.;

   if regbab10=1 then babdm10=1; 
   else if regbab10=2 then do;
   if babd10=1 then babdm10=2; 
   else if babd10=2 then babdm10=3;
   else if babd10=3 then babdm10=4;
   else if babd10=4 then babdm10=5;
   else if babd10 in (.,0,5) then babdm10=.;
   end;
   else babdm10=.;


      if regibu10=1 then ibudm10=1; 
      else if regibu10=2 then do;
   if ibud10=1 then ibudm10=2; 
   else if ibud10=2 then ibudm10=3;
   else if ibud10=3 then ibudm10=4;
   else if ibud10=4 then ibudm10=5;
   else if ibud10 in (.,0,5) then ibudm10=.;
         end;
   else ibudm10=.;
         
   if regtyl10=1 then tyldm10=1; 
      else if regtyl10=2 then do;
   if tyld10=1 then tyldm10=2; 
   else if tyld10=2 then tyldm10=3;
   else if tyld10=3 then tyldm10=4;
   else if tyld10=4 then tyldm10=5;
   else if tyld10 in (.,0,5) then tyldm10=.;
         end;
   else tyldm10=.;


   if regu10=1 then aspdd10=0; 
   else if regu10=2 then do;
   if aspd10=1 then aspdd10=2.5; 
   else if aspd10=2 then aspdd10=9.5;
   else if aspd10=3 then aspdd10=18;
   else if aspd10=4 then aspdd10=22;
   else if aspd10 in (.,0,5) then aspdd10=.;
   end;
   else aspdd10=.;

   if regbab10=1 then babdd10=0; 
   else if regbab10=2 then do;
   if babd10=1 then babdd10=2.5; 
   else if babd10=2 then babdd10=9.5;
   else if babd10=3 then babdd10=18;
   else if babd10=4 then babdd10=22;
   else if babd10 in (.,0,5) then babdd10=.;
   end;
   else babdd10=.;

   totadd10=sum (babdd10, aspdd10); 
   if totadd10=0 then totadm10=1; /*lowest category of days per month*/
   else if 0< totadd10 <=4 then totadm10=2; /*1-4 d/month*/
   else if 4< totadd10 <=14 then totadm10=3; /*5-14 d/month*/
   else if 15< totadd10<=21 then totadm10=4; /*15-21 d/month*/
   else if totadd10>21 then totadm10=5; /*22+ days/month*/


      if regibu10=1 then ibudd10=0; 
      else if regibu10=2 then do;
   if ibud10=1 then ibudd10=2.5; 
   else if ibud10=2 then ibudd10=9.5;
   else if ibud10=3 then ibudd10=18;
   else if ibud10=4 then ibudd10=22;
   else if ibud10 in (.,0,5) then ibudd10=.;
         end;
   else ibudd10=.;

   if regtyl10=1 then tyldd10=0; 
      else if regtyl10=2 then do;
   if tyld10=1 then tyldd10=2.5; 
   else if tyld10=2 then tyldd10=9.5;
   else if tyld10=3 then tyldd10=18;
   else if tyld10=4 then tyldd10=22;
   else if tyld10 in (.,0,5) then tyldd10=.;
         end;
   else tyldd10=.;

   if regu10=1 then nasp=0;
   else if regu10=2 then do; 
   if nasp10=1 then nasp=1.5;
   else if nasp10=2 then nasp=4;
   else if nasp10=3 then nasp=10;
   else if nasp10=4 then nasp=20;
   else if nasp10 in(.,0,5) then nasp=.;
   end;
   else nasp=.;

   if regbab10=1 then nbab=0;
   else if regbab10=2 then do; 
   if nbab10=1 then nbab=1.5;
   else if nbab10=2 then nbab=4;
   else if nbab10=3 then nbab=10;
   else if nbab10=4 then nbab=20;
   else if nbab10 in(.,0,5) then nbab=.;
   end;
   else nbab=.;

   naspeq=nbab/4; /*number of aspirin equivalents*/
   if nasp eq . and naspeq ne . then aspwk10=naspeq;
   else if nasp ne . and naspeq eq . then aspwk10=nasp;
   else  aspwk10 = nasp+ naspeq; 

   if regu10=2 and nasp in (0,.) and naspeq in (0,.) then aspwk10=.; /*changed*/
   else if regbab10=2 and nasp in (0,.) and naspeq in (0,.) then aspwk10=.; /*changed*/

   aspmo10 = aspwk10 * 4.3; 



      if regibu10=1 then ibuwk10=0; 
      else if regibu10=2 then do;
   if nibu10=1 then ibuwk10=1.5; 
   else if nibu10=2 then ibuwk10=4;
   else if nibu10=3 then ibuwk10=10;
   else if nibu10=4 then ibuwk10=20;
   else if nibu10 in (.,0,5) then ibuwk10=.;
         end;
   else ibuwk10=.; /*did not report any nsaid data*/
      
   
   /*set each group the median number of tylenol consumed*/
      if regtyl10=1 then tylwk10=0; 
      else if regtyl10=2 then do;
   if tyln10=1 then tylwk10=1.5; 
   else if tyln10=2 then tylwk10=4;
   else if tyln10=3 then tylwk10=10;
   else if tyln10=4 then tylwk10=20;
   else if tyln10 in (.,0,5) then tylwk10=.;
         end;
   else tylwk10=.; 


   if regibu10=1 and regnon10 in (.,1) and regcox10 in (.,1) then regnsad10=1;
   else if regibu10 in (.,1) and regnon10=1 and regcox10 in (.,1) then regnsad10=1;
   else if regibu10 in (.,1) and regnon10 in (.,1) and regcox10=1 then regnsad10=1;
   else if regibu10=2 and regnon10 in (.,1,2) and regcox10 in (.,1,2) then regnsad10=2;
   else if regibu10 in (.,1,2) and regnon10=2 and regcox10 in (.,1,2) then regnsad10=2;
   else if regibu10 in (.,1,2) and regnon10 in (.,1,2) and regcox10=2 then regnsad10=2;


   if regu10=1 and regbab10 in (.,1) then regaspb10=1;
   else if regu10 in (.,1) and regbab10=1 then regaspb10=1;
   else if regu10=2 and regbab10 in (.,1,2) then regaspb10=2;
   else if regu10 in (.,1,2) and regbab10=2 then regaspb10=2;

   if  0<=aspwk10<2 then reguasp10=1; 
   else if aspwk10>=2 then reguasp10=2; 
   else if aspwk10=. then reguasp10=.;

   baby10=1; 
   if bab10=1 and babd10=4 then baby10=3; 
   else if reguasp10=2 and aspd10=4 then baby10=4; 
   else if reguasp10=2 then baby10=2; /*infrequent user*/

run;

%nur12(keep=q12 asp12 aspd12 nasp12 aspwk12 aspdm12 aspdd12 regu12 reguasp12
   bab12 babd12 nbab12 babdm12 babdd12 regbab12 regaspb12 baby12
	regnsad12
   regtyl12 tyl12 tyld12 tyln12 tylwk12 tyldm12 tyldd12 
   regibu12 ibu12 ibud12 ibudm12 nibu12 ibuwk12 ibut12 
   ibudd12  regnon12 totadd12 totadm12
   celeb12 regcox12 );

   if q12 in (1,2) then do; 
      if ibu12=1 then regibu12=2; 
      else regibu12=1; 
      end;
   else regibu12=.; 

   if q12 in (1,2) then do; 
      if tyl12=1 then regtyl12=2; 
      else regtyl12=1; 
      end;
   else regtyl12=.; 


   if q12 in (1,2) then do; 
      if ibut12=1 then regnon12=2; 
      else regnon12=1; 
      end;
   else regnon12=.; 

   if q12 in (1,2) then do; 
      if celeb12=1 then regcox12=2; 
      else regcox12=1; 
      end;
   else regcox12=.; 

   if q12 in (1,2) then do; 
   if asp12=1 then regu12=2; 
   else regu12=1; 
   end;
   else regu12=.; 

   if q12 in (1,2) then do; 
   if bab12=1 then regbab12=2; 
   else regbab12=1; 
   end;
   else regbab12=.; 

   if regu12=1 then aspdm12=1; 
   else if regu12=2 then do;
   if aspd12=1 then aspdm12=2; 
   else if aspd12=2 then aspdm12=3;
   else if aspd12=3 then aspdm12=4;
   else if aspd12=4 then aspdm12=5;
   else if aspd12 in (.,0,5) then aspdm12=.;
   end;
   else aspdm12=.;

   if regbab12=1 then babdm12=1; 
   else if regbab12=2 then do;
   if babd12=1 then babdm12=2; 
   else if babd12=2 then babdm12=3;
   else if babd12=3 then babdm12=4;
   else if babd12=4 then babdm12=5;
   else if babd12 in (.,0,5) then babdm12=.;
   end;
   else babdm12=.;


      if regibu12=1 then ibudm12=1; 
      else if regibu12=2 then do;
   if ibud12=1 then ibudm12=2; 
   else if ibud12=2 then ibudm12=3;
   else if ibud12=3 then ibudm12=4;
   else if ibud12=4 then ibudm12=5;
   else if ibud12 in (.,0,5) then ibudm12=.;
         end;
   else ibudm12=.;
         
   if regtyl12=1 then tyldm12=1; 
      else if regtyl12=2 then do;
   if tyld12=1 then tyldm12=2; 
   else if tyld12=2 then tyldm12=3;
   else if tyld12=3 then tyldm12=4;
   else if tyld12=4 then tyldm12=5;
   else if tyld12 in (.,0,5) then tyldm12=.;
         end;
   else tyldm12=.;


   if regu12=1 then aspdd12=0; 
   else if regu12=2 then do;
   if aspd12=1 then aspdd12=2.5; 
   else if aspd12=2 then aspdd12=9.5;
   else if aspd12=3 then aspdd12=18;
   else if aspd12=4 then aspdd12=22;
   else if aspd12 in (.,0,5) then aspdd12=.;
   end;
   else aspdd12=.;

   if regbab12=1 then babdd12=0; 
   else if regbab12=2 then do;
   if babd12=1 then babdd12=2.5; 
   else if babd12=2 then babdd12=9.5;
   else if babd12=3 then babdd12=18;
   else if babd12=4 then babdd12=22;
   else if babd12 in (.,0,5) then babdd12=.;
   end;
   else babdd12=.;

   totadd12=sum (babdd12, aspdd12); 
   if totadd12=0 then totadm12=1; /*lowest category of days per month*/
   else if 0< totadd12 <=4 then totadm12=2; /*1-4 d/month*/
   else if 4< totadd12 <=14 then totadm12=3; /*5-14 d/month*/
   else if 15< totadd12<=21 then totadm12=4; /*15-21 d/month*/
   else if totadd12>21 then totadm12=5; /*22+ days/month*/


      if regibu12=1 then ibudd12=0; 
      else if regibu12=2 then do;
   if ibud12=1 then ibudd12=2.5; 
   else if ibud12=2 then ibudd12=9.5;
   else if ibud12=3 then ibudd12=18;
   else if ibud12=4 then ibudd12=22;
   else if ibud12 in (.,0,5) then ibudd12=.;
         end;
   else ibudd12=.;

   if regtyl12=1 then tyldd12=0; 
      else if regtyl12=2 then do;
   if tyld12=1 then tyldd12=2.5; 
   else if tyld12=2 then tyldd12=9.5;
   else if tyld12=3 then tyldd12=18;
   else if tyld12=4 then tyldd12=22;
   else if tyld12 in (.,0,5) then tyldd12=.;
         end;
   else tyldd12=.;

   if regu12=1 then nasp=0;
   else if regu12=2 then do; 
   if nasp12=1 then nasp=1.5;
   else if nasp12=2 then nasp=4;
   else if nasp12=3 then nasp=10;
   else if nasp12=4 then nasp=20;
   else if nasp12 in(.,0,5) then nasp=.;
   end;
   else nasp=.;

   if regbab12=1 then nbab=0;
   else if regbab12=2 then do; 
   if nbab12=1 then nbab=1.5;
   else if nbab12=2 then nbab=4;
   else if nbab12=3 then nbab=10;
   else if nbab12=4 then nbab=20;
   else if nbab12 in(.,0,5) then nbab=.;
   end;
   else nbab=.;

   naspeq=nbab/4; /*number of aspirin equivalents*/
   if nasp eq . and naspeq ne . then aspwk12=naspeq;
   else if nasp ne . and naspeq eq . then aspwk12=nasp;
   else  aspwk12 = nasp+ naspeq; 

   if regu12=2 and nasp in (0,.) and naspeq in (0,.) then aspwk12=.; /*changed*/
   else if regbab12=2 and nasp in (0,.) and naspeq in (0,.) then aspwk12=.; /*changed*/

   aspmo12 = aspwk12 * 4.3; 



      if regibu12=1 then ibuwk12=0; 
      else if regibu12=2 then do;
   if nibu12=1 then ibuwk12=1.5; 
   else if nibu12=2 then ibuwk12=4;
   else if nibu12=3 then ibuwk12=10;
   else if nibu12=4 then ibuwk12=20;
   else if nibu12 in (.,0,5) then ibuwk12=.;
         end;
   else ibuwk12=.; /*did not report any nsaid data*/
      
   
   /*set each group the median number of tylenol consumed*/
      if regtyl12=1 then tylwk12=0; 
      else if regtyl12=2 then do;
   if tyln12=1 then tylwk12=1.5; 
   else if tyln12=2 then tylwk12=4;
   else if tyln12=3 then tylwk12=10;
   else if tyln12=4 then tylwk12=20;
   else if tyln12 in (.,0,5) then tylwk12=.;
         end;
   else tylwk12=.; 


   if regibu12=1 and regnon12 in (.,1) and regcox12 in (.,1) then regnsad12=1;
   else if regibu12 in (.,1) and regnon12=1 and regcox12 in (.,1) then regnsad12=1;
   else if regibu12 in (.,1) and regnon12 in (.,1) and regcox12=1 then regnsad12=1;
   else if regibu12=2 and regnon12 in (.,1,2) and regcox12 in (.,1,2) then regnsad12=2;
   else if regibu12 in (.,1,2) and regnon12=2 and regcox12 in (.,1,2) then regnsad12=2;
   else if regibu12 in (.,1,2) and regnon12 in (.,1,2) and regcox12=2 then regnsad12=2;


   if regu12=1 and regbab12 in (.,1) then regaspb12=1;
   else if regu12 in (.,1) and regbab12=1 then regaspb12=1;
   else if regu12=2 and regbab12 in (.,1,2) then regaspb12=2;
   else if regu12 in (.,1,2) and regbab12=2 then regaspb12=2;

   if  0<=aspwk12<2 then reguasp12=1; 
   else if aspwk12>=2 then reguasp12=2; 
   else if aspwk12=. then reguasp12=.;

   baby12=1; 
   if bab12=1 and babd12=4 then baby12=3; 
   else if reguasp12=2 and aspd12=4 then baby12=4; 
   else if reguasp12=2 then baby12=2; /*infrequent user*/

run;


%nur14(keep=q14 asp14 aspd14 nasp14 aspwk14 aspdm14 aspdd14 regu14 reguasp14
   bab14 babd14 nbab14 babdm14 babdd14 regbab14 regaspb14 baby14
	regnsad14
   regtyl14 tyl14 tyld14 tyln14 tylwk14 tyldm14 tyldd14 
   regibu14 ibu14 ibud14 ibudm14 nibu14 ibuwk14 ibut14 
   ibudd14  regnon14 totadd14 totadm14
   celeb14 regcox14 );

   if q14 in (1,2) then do; 
      if ibu14=2 then regibu14=2;  * note ibu14 coded differently from ibu12;
      else regibu14=1; 
      end;
   else regibu14=.; 

   if q14 in (1,2) then do; 
      if tyl14=2 then regtyl14=2; 
      else regtyl14=1; 
      end;
   else regtyl14=.; 


   if q14 in (1,2) then do; 
      if ibut14=2 then regnon14=2; 
      else regnon14=1; 
      end;
   else regnon14=.; 

   if q14 in (1,2) then do; 
      if celeb14=2 then regcox14=2; 
      else regcox14=1; 
      end;
   else regcox14=.; 

   if q14 in (1,2) then do; 
   if asp14=2 then regu14=2; 
   else regu14=1; 
   end;
   else regu14=.; 

   if q14 in (1,2) then do; 
   if bab14=2 then regbab14=2; 
   else regbab14=1; 
   end;
   else regbab14=.; 

   if regu14=1 then aspdm14=1; 
   else if regu14=2 then do;
   if aspd14=1 then aspdm14=2; 
   else if aspd14=2 then aspdm14=3;
   else if aspd14=3 then aspdm14=4;
   else if aspd14=4 then aspdm14=5;
   else if aspd14 in (.,0,5) then aspdm14=.;
   end;
   else aspdm14=.;

   if regbab14=1 then babdm14=1; 
   else if regbab14=2 then do;
   if babd14=1 then babdm14=2; 
   else if babd14=2 then babdm14=3;
   else if babd14=3 then babdm14=4;
   else if babd14=4 then babdm14=5;
   else if babd14 in (.,0,5) then babdm14=.;
   end;
   else babdm14=.;


      if regibu14=1 then ibudm14=1; 
      else if regibu14=2 then do;
   if ibud14=1 then ibudm14=2; 
   else if ibud14=2 then ibudm14=3;
   else if ibud14=3 then ibudm14=4;
   else if ibud14=4 then ibudm14=5;
   else if ibud14 in (.,0,5) then ibudm14=.;
         end;
   else ibudm14=.;
         
   if regtyl14=1 then tyldm14=1; 
      else if regtyl14=2 then do;
   if tyld14=1 then tyldm14=2; 
   else if tyld14=2 then tyldm14=3;
   else if tyld14=3 then tyldm14=4;
   else if tyld14=4 then tyldm14=5;
   else if tyld14 in (.,0,5) then tyldm14=.;
         end;
   else tyldm14=.;


   if regu14=1 then aspdd14=0; 
   else if regu14=2 then do;
   if aspd14=1 then aspdd14=2.5; 
   else if aspd14=2 then aspdd14=9.5;
   else if aspd14=3 then aspdd14=18;
   else if aspd14=4 then aspdd14=22;
   else if aspd14 in (.,0,5) then aspdd14=.;
   end;
   else aspdd14=.;

   if regbab14=1 then babdd14=0; 
   else if regbab14=2 then do;
   if babd14=1 then babdd14=2.5; 
   else if babd14=2 then babdd14=9.5;
   else if babd14=3 then babdd14=18;
   else if babd14=4 then babdd14=22;
   else if babd14 in (.,0,5) then babdd14=.;
   end;
   else babdd14=.;

   totadd14=sum (babdd14, aspdd14); 
   if totadd14=0 then totadm14=1; /*lowest category of days per month*/
   else if 0< totadd14 <=4 then totadm14=2; /*1-4 d/month*/
   else if 4< totadd14 <=14 then totadm14=3; /*5-14 d/month*/
   else if 15< totadd14<=21 then totadm14=4; /*15-21 d/month*/
   else if totadd14>21 then totadm14=5; /*22+ days/month*/


      if regibu14=1 then ibudd14=0; 
      else if regibu14=2 then do;
   if ibud14=1 then ibudd14=2.5; 
   else if ibud14=2 then ibudd14=9.5;
   else if ibud14=3 then ibudd14=18;
   else if ibud14=4 then ibudd14=22;
   else if ibud14 in (.,0,5) then ibudd14=.;
         end;
   else ibudd14=.;

   if regtyl14=1 then tyldd14=0; 
      else if regtyl14=2 then do;
   if tyld14=1 then tyldd14=2.5; 
   else if tyld14=2 then tyldd14=9.5;
   else if tyld14=3 then tyldd14=18;
   else if tyld14=4 then tyldd14=22;
   else if tyld14 in (.,0,5) then tyldd14=.;
         end;
   else tyldd14=.;

   if regu14=1 then nasp=0;
   else if regu14=2 then do; 
   if nasp14=1 then nasp=1.5;
   else if nasp14=2 then nasp=4;
   else if nasp14=3 then nasp=10;
   else if nasp14=4 then nasp=20;
   else if nasp14 in(.,0,5) then nasp=.;
   end;
   else nasp=.;

   if regbab14=1 then nbab=0;
   else if regbab14=2 then do; 
   if nbab14=1 then nbab=1.5;
   else if nbab14=2 then nbab=4;
   else if nbab14=3 then nbab=10;
   else if nbab14=4 then nbab=20;
   else if nbab14 in(.,0,5) then nbab=.;
   end;
   else nbab=.;

   naspeq=nbab/4; /*number of aspirin equivalents*/
   if nasp eq . and naspeq ne . then aspwk14=naspeq;
   else if nasp ne . and naspeq eq . then aspwk14=nasp;
   else  aspwk14 = nasp+ naspeq; 

   if regu14=2 and nasp in (0,.) and naspeq in (0,.) then aspwk14=.; /*changed*/
   else if regbab14=2 and nasp in (0,.) and naspeq in (0,.) then aspwk14=.; /*changed*/

   aspmo14 = aspwk14 * 4.3; 



      if regibu14=1 then ibuwk14=0; 
      else if regibu14=2 then do;
   if nibu14=1 then ibuwk14=1.5; 
   else if nibu14=2 then ibuwk14=4;
   else if nibu14=3 then ibuwk14=10;
   else if nibu14=4 then ibuwk14=20;
   else if nibu14 in (.,0,5) then ibuwk14=.;
         end;
   else ibuwk14=.; /*did not report any nsaid data*/
      
   
   /*set each group the median number of tylenol consumed*/
      if regtyl14=1 then tylwk14=0; 
      else if regtyl14=2 then do;
   if tyln14=1 then tylwk14=1.5; 
   else if tyln14=2 then tylwk14=4;
   else if tyln14=3 then tylwk14=10;
   else if tyln14=4 then tylwk14=20;
   else if tyln14 in (.,0,5) then tylwk14=.;
         end;
   else tylwk14=.; 


   if regibu14=1 and regnon14 in (.,1) and regcox14 in (.,1) then regnsad14=1;
   else if regibu14 in (.,1) and regnon14=1 and regcox14 in (.,1) then regnsad14=1;
   else if regibu14 in (.,1) and regnon14 in (.,1) and regcox14=1 then regnsad14=1;
   else if regibu14=2 and regnon14 in (.,1,2) and regcox14 in (.,1,2) then regnsad14=2;
   else if regibu14 in (.,1,2) and regnon14=2 and regcox14 in (.,1,2) then regnsad14=2;
   else if regibu14 in (.,1,2) and regnon14 in (.,1,2) and regcox14=2 then regnsad14=2;


   if regu14=1 and regbab14 in (.,1) then regaspb14=1;
   else if regu14 in (.,1) and regbab14=1 then regaspb14=1;
   else if regu14=2 and regbab14 in (.,1,2) then regaspb14=2;
   else if regu14 in (.,1,2) and regbab14=2 then regaspb14=2;

   if  0<=aspwk14<2 then reguasp14=1; 
   else if aspwk14>=2 then reguasp14=2; 
   else if aspwk14=. then reguasp14=.;

   baby14=1; 
   if bab14=1 and babd14=4 then baby14=3; 
   else if reguasp14=2 and aspd14=4 then baby14=4; 
   else if reguasp14=2 then baby14=2; /*infrequent user*/

run;


%nur16(keep=q16 asp16 aspd16 nasp16 aspwk16 aspdm16 aspdd16 regu16 reguasp16
   bab16 babd16 nbab16 babdm16 babdd16 regbab16 regaspb16 baby16
	regnsad16
   regtyl16 tyl16 tyld16 tyln16 tylwk16 tyldm16 tyldd16 
   regibu16 ibu16 ibud16 ibudm16 nibu16 ibuwk16 ibut16 
   ibudd16  regnon16 totadd16 totadm16
   celeb16 regcox16 );

   if q16 in (1,2) then do; 
      if ibu16=2 then regibu16=2;  * note ibu16 coded differently from ibu12;
      else regibu16=1; 
      end;
   else regibu16=.; 

   if q16 in (1,2) then do; 
      if tyl16=2 then regtyl16=2; 
      else regtyl16=1; 
      end;
   else regtyl16=.; 


   if q16 in (1,2) then do; 
      if ibut16=2 then regnon16=2; 
      else regnon16=1; 
      end;
   else regnon16=.; 

   if q16 in (1,2) then do; 
      if celeb16=2 then regcox16=2; 
      else regcox16=1; 
      end;
   else regcox16=.; 

   if q16 in (1,2) then do; 
   if asp16=2 then regu16=2; 
   else regu16=1; 
   end;
   else regu16=.; 

   if q16 in (1,2) then do; 
   if bab16=2 then regbab16=2; 
   else regbab16=1; 
   end;
   else regbab16=.; 

   if regu16=1 then aspdm16=1; 
   else if regu16=2 then do;
   if aspd16=1 then aspdm16=2; 
   else if aspd16=2 then aspdm16=3;
   else if aspd16=3 then aspdm16=4;
   else if aspd16=4 then aspdm16=5;
   else if aspd16 in (.,0,5) then aspdm16=.;
   end;
   else aspdm16=.;

   if regbab16=1 then babdm16=1; 
   else if regbab16=2 then do;
   if babd16=1 then babdm16=2; 
   else if babd16=2 then babdm16=3;
   else if babd16=3 then babdm16=4;
   else if babd16=4 then babdm16=5;
   else if babd16 in (.,0,5) then babdm16=.;
   end;
   else babdm16=.;


      if regibu16=1 then ibudm16=1; 
      else if regibu16=2 then do;
   if ibud16=1 then ibudm16=2; 
   else if ibud16=2 then ibudm16=3;
   else if ibud16=3 then ibudm16=4;
   else if ibud16=4 then ibudm16=5;
   else if ibud16 in (.,0,5) then ibudm16=.;
         end;
   else ibudm16=.;
         
   if regtyl16=1 then tyldm16=1; 
      else if regtyl16=2 then do;
   if tyld16=1 then tyldm16=2; 
   else if tyld16=2 then tyldm16=3;
   else if tyld16=3 then tyldm16=4;
   else if tyld16=4 then tyldm16=5;
   else if tyld16 in (.,0,5) then tyldm16=.;
         end;
   else tyldm16=.;


   if regu16=1 then aspdd16=0; 
   else if regu16=2 then do;
   if aspd16=1 then aspdd16=2.5; 
   else if aspd16=2 then aspdd16=9.5;
   else if aspd16=3 then aspdd16=18;
   else if aspd16=4 then aspdd16=22;
   else if aspd16 in (.,0,5) then aspdd16=.;
   end;
   else aspdd16=.;

   if regbab16=1 then babdd16=0; 
   else if regbab16=2 then do;
   if babd16=1 then babdd16=2.5; 
   else if babd16=2 then babdd16=9.5;
   else if babd16=3 then babdd16=18;
   else if babd16=4 then babdd16=22;
   else if babd16 in (.,0,5) then babdd16=.;
   end;
   else babdd16=.;

   totadd16=sum (babdd16, aspdd16); 
   if totadd16=0 then totadm16=1; /*lowest category of days per month*/
   else if 0< totadd16 <=4 then totadm16=2; /*1-4 d/month*/
   else if 4< totadd16 <=16 then totadm16=3; /*5-16 d/month*/
   else if 15< totadd16<=21 then totadm16=4; /*15-21 d/month*/
   else if totadd16>21 then totadm16=5; /*22+ days/month*/


      if regibu16=1 then ibudd16=0; 
      else if regibu16=2 then do;
   if ibud16=1 then ibudd16=2.5; 
   else if ibud16=2 then ibudd16=9.5;
   else if ibud16=3 then ibudd16=18;
   else if ibud16=4 then ibudd16=22;
   else if ibud16 in (.,0,5) then ibudd16=.;
         end;
   else ibudd16=.;

   if regtyl16=1 then tyldd16=0; 
      else if regtyl16=2 then do;
   if tyld16=1 then tyldd16=2.5; 
   else if tyld16=2 then tyldd16=9.5;
   else if tyld16=3 then tyldd16=18;
   else if tyld16=4 then tyldd16=22;
   else if tyld16 in (.,0,5) then tyldd16=.;
         end;
   else tyldd16=.;

   if regu16=1 then nasp=0;
   else if regu16=2 then do; 
   if nasp16=1 then nasp=1.5;
   else if nasp16=2 then nasp=4;
   else if nasp16=3 then nasp=10;
   else if nasp16=4 then nasp=20;
   else if nasp16 in(.,0,5) then nasp=.;
   end;
   else nasp=.;

   if regbab16=1 then nbab=0;
   else if regbab16=2 then do; 
   if nbab16=1 then nbab=1.5;
   else if nbab16=2 then nbab=4;
   else if nbab16=3 then nbab=10;
   else if nbab16=4 then nbab=20;
   else if nbab16 in(.,0,5) then nbab=.;
   end;
   else nbab=.;

   naspeq=nbab/4; /*number of aspirin equivalents*/
   if nasp eq . and naspeq ne . then aspwk16=naspeq;
   else if nasp ne . and naspeq eq . then aspwk16=nasp;
   else  aspwk16 = nasp+ naspeq; 

   if regu16=2 and nasp in (0,.) and naspeq in (0,.) then aspwk16=.; /*changed*/
   else if regbab16=2 and nasp in (0,.) and naspeq in (0,.) then aspwk16=.; /*changed*/

   aspmo16 = aspwk16 * 4.3; 



      if regibu16=1 then ibuwk16=0; 
      else if regibu16=2 then do;
   if nibu16=1 then ibuwk16=1.5; 
   else if nibu16=2 then ibuwk16=4;
   else if nibu16=3 then ibuwk16=10;
   else if nibu16=4 then ibuwk16=20;
   else if nibu16 in (.,0,5) then ibuwk16=.;
         end;
   else ibuwk16=.; /*did not report any nsaid data*/
      
   
   /*set each group the median number of tylenol consumed*/
      if regtyl16=1 then tylwk16=0; 
      else if regtyl16=2 then do;
   if tyln16=1 then tylwk16=1.5; 
   else if tyln16=2 then tylwk16=4;
   else if tyln16=3 then tylwk16=10;
   else if tyln16=4 then tylwk16=20;
   else if tyln16 in (.,0,5) then tylwk16=.;
         end;
   else tylwk16=.; 


   if regibu16=1 and regnon16 in (.,1) and regcox16 in (.,1) then regnsad16=1;
   else if regibu16 in (.,1) and regnon16=1 and regcox16 in (.,1) then regnsad16=1;
   else if regibu16 in (.,1) and regnon16 in (.,1) and regcox16=1 then regnsad16=1;
   else if regibu16=2 and regnon16 in (.,1,2) and regcox16 in (.,1,2) then regnsad16=2;
   else if regibu16 in (.,1,2) and regnon16=2 and regcox16 in (.,1,2) then regnsad16=2;
   else if regibu16 in (.,1,2) and regnon16 in (.,1,2) and regcox16=2 then regnsad16=2;


   if regu16=1 and regbab16 in (.,1) then regaspb16=1;
   else if regu16 in (.,1) and regbab16=1 then regaspb16=1;
   else if regu16=2 and regbab16 in (.,1,2) then regaspb16=2;
   else if regu16 in (.,1,2) and regbab16=2 then regaspb16=2;

   if  0<=aspwk16<2 then reguasp16=1; 
   else if aspwk16>=2 then reguasp16=2; 
   else if aspwk16=. then reguasp16=.;

   baby16=1; 
   if bab16=1 and babd16=4 then baby16=3; 
   else if reguasp16=2 and aspd16=4 then baby16=4; 
   else if reguasp16=2 then baby16=2; /*infrequent user*/

run;

/*merge aspirin files*/
data nhaspone;
merge aspdata nur82 nur84 nur88 nur90 nur92 nur94 nur96 nur98 
      nur00 nur02 nur04 nur06 nur08 nur10 nur12 nur14 nur16;
   by id;
   if first.id;

/*Carry forward if missing and creat new aspirin variables*/
/*1986 is not included in the array*/
/*any use of aspirin (regularly use any amount of aspirin)*/
array anyasp{*} anyasp80 anyasp82 anyasp84 anyasp84  anyasp88 anyasp90 anyasp92 anyasp94 anyasp96 anyasp98 
                regaspb00 regaspb02 regaspb04 regaspb06 regaspb08 regaspb10 regaspb12 regaspb14 regaspb16; /*regaspb include baby asp*/
array anyasppre{*} anyasppre80 anyasppre82 anyasppre84 anyasppre84 anyasppre88 anyasppre90 anyasppre92 anyasppre94 anyasppre96 anyasppre98 
                   anyasppre00 anyasppre02 anyasppre04 anyasppre06 anyasppre08 anyasppre10 anyasppre12 anyasppre14 anyasppre16;

/*aspirin intake tabs/week*/
array aspwk{*} aspwk80 aspwk82 aspwk84 aspwk84 aspwk88 aspwk90 aspwk92 aspwk94 aspwk96 aspwk98 
               aspwk00 aspwk02 aspwk04 aspwk06 aspwk08 aspwk10 aspwk12 aspwk14 aspwk16;

array aspwkpre{*} aspwkpre80 aspwkpre82 aspwkpre84 aspwkpre84 aspwkpre88 aspwkpre90 aspwkpre92 aspwkpre94 aspwkpre96 aspwkpre98 
                  aspwkpre00 aspwkpre02 aspwkpre04 aspwkpre06 aspwkpre08 aspwkpre10 aspwkpre12 aspwkpre14 aspwkpre16;	

/*note here, when calculate cumulative average, avaspwkpre84 shoudn't be included*/		   
array avaspwkpre{*} avaspwkpre80 avaspwkpre82 avaspwkpre84 avaspwkpre86 avaspwkpre88 avaspwkpre90 avaspwkpre92 avaspwkpre94 avaspwkpre96 avaspwkpre98 
                    avaspwkpre00 avaspwkpre02 avaspwkpre04 avaspwkpre06 avaspwkpre08 avaspwkpre10 avaspwkpre12 avaspwkpre14 avaspwkpre16;

array avaspwkpren{*} avaspwkpren80 avaspwkpren82 avaspwkpren84 avaspwkpren86 avaspwkpren88 avaspwkpren90 avaspwkpren92 avaspwkpren94 avaspwkpren96 avaspwkpren98 
                     avaspwkpren00 avaspwkpren02 avaspwkpren04 avaspwkpren06 avaspwkpren08 avaspwkpren10 avaspwkpren12 avaspwkpren14 avaspwkpren16; /*per Ed, cumulative dose only when aspirin is used*/


/*regular use of aspirin*/					 
array reguasp{*} reguasp80 reguasp82 reguasp84 reguasp84 reguasp88 reguasp90 reguasp92 reguasp94 reguasp96 reguasp98 
                 reguasp00 reguasp02 reguasp04 reguasp06 reguasp08 reguasp10 reguasp12 reguasp14 reguasp16;
array regaspre{*} regaspre80 regaspre82 regaspre84 regaspre84 regaspre88 regaspre90 regaspre92 regaspre94 regaspre96 regaspre98 
                  regaspre00 regaspre02 regaspre04 regaspre06 regaspre08 regaspre10 regaspre12 regaspre14 regaspre16;

/*defined by avaspwkpre*/
array avregaspre{*} avregaspre80 avregaspre82 avregaspre84 avregaspre86 avregaspre88 avregaspre90 avregaspre92 avregaspre94 avregaspre96 avregaspre98 
                    avregaspre00 avregaspre02 avregaspre04 avregaspre06 avregaspre08 avregaspre10 avregaspre12 avregaspre14 avregaspre16;

/*duration of regular use of aspirin, this include */
array adur{*}      adur8082 adur8284 adur8486 adur8890 adur9092 adur9294 adur9496 adur9698 adur9800 
                   adur0002 adur0204 adur0406 adur0608 adur0810 adur1012 adur1214 adur1416 adur1618;
array adurarray{*} adur8082 adur8284 adur8486 adur8688 adur8890 adur9092 adur9294 adur9496 adur9698 adur9800 
/*calculate 1986*/ adur0002 adur0204 adur0406 adur0608 adur0810 adur1012 adur1214 adur1416 adur1618; 

array regaspdur{*} regaspdur80 regaspdur82 regaspdur84 regaspdur86 regaspdur88 regaspdur90 regaspdur92 regaspdur94 regaspdur96 regaspdur98 
                   regaspdur00 regaspdur02 regaspdur04 regaspdur06 regaspdur08 regaspdur10 regaspdur12 regaspdur14 regaspdur16;

 /*duration of any use of aspirin, this include */
array aadur{*}     aadur8082 aadur8284 aadur8486 aadur8890 aadur9092 aadur9294 aadur9496 aadur9698 aadur9800 
                   aadur0002 aadur0204 aadur0406 aadur0608 aadur0810 aadur1012 aadur1214 aadur1416 aadur1618;
array aadurarray{*} aadur8082 aadur8284 aadur8486 aadur8688 aadur8890 aadur9092 aadur9294 aadur9496 aadur9698 aadur9800 
/*calculate 1986*/  aadur0002 aadur0204 aadur0406 aadur0608 aadur0810 aadur1012 aadur1214 aadur1416 aadur1618; 

array aaspdur{*} aaspdur80 aaspdur82 aaspdur84 aaspdur86 aaspdur88 aaspdur90 aaspdur92 aaspdur94 aaspdur96 aaspdur98 
                 aaspdur00 aaspdur02 aaspdur04 aaspdur06 aaspdur08 aaspdur10 aaspdur12 aaspdur14 aaspdur16;


/*tablet/week-years*/
array tabwy{*} tabwy80 tabwy82 tabwy84 tabwy84 tabwy88 tabwy90 tabwy92 tabwy94 tabwy96 tabwy98 
               tabwy00 tabwy02 tabwy04 tabwy06 tabwy08 tabwy10 tabwy12 tabwy14 tabwy16; /*each year*/
array cumtabwy{*} cumtabwy80 cumtabwy82 cumtabwy84 cumtabwy84 cumtabwy88 cumtabwy90 cumtabwy92 cumtabwy94 cumtabwy96 cumtabwy98 
                  cumtabwy00 cumtabwy02 cumtabwy04 cumtabwy06 cumtabwy08 cumtabwy10 cumtabwy12 cumtabwy14 cumtabwy16; /*cumulative average*/

/*time since discontinuation, per Andy 102714*/

array tsd{*} tsd80 tsd82 tsd84 tsd84 tsd88 tsd90 tsd92 tsd94 tsd96 tsd98 
             tsd00 tsd02 tsd04 tsd06 tsd08 tsd10 tsd12 tsd14 tsd16;
array timesd{*} timesd80 timesd82 timesd84 timesd84 timesd88 timesd90 timesd92 timesd94 timesd96 timesd98 
                timesd00 timesd02 timesd04 timesd06 timesd08 timesd10 timesd12 timesd14 timesd16;

/***daily baby aspirin, since 2000***/
array baby{*} baby00 baby02 baby04 baby06 baby08 baby10 baby12 baby14 baby16;
array daily{*} daily00 daily02 daily04 daily06 daily08 daily10 daily12 daily14 daily16;

/***NSAIDs array***/
/*any use of ibuprofen*/
array ibui{*} regibu90 regibu92 regibu94 regibu96 regibu98 regibu00 regibu02 regibu04 regibu06 regibu08 regibu10 regibu12 regibu14 regibu16;
array anyibu{*} regibui90 regibui92 regibui94 regibui96 regibui98 regibui00 regibui02 regibui04 regibui06 regibui08 regibui10 regibui12 regibui14 regibui16;


/*make consistent with each variable, any asp, regular asp, tabls/week*/
do i=1 to dim(anyasp);
   if anyasp{i}=. and (0<aspwk{i} or reguasp{i}=2) then anyasp{i}=2;
   else if anyasp{i}=. and aspwk{i}=0 then anyasp{i}=1;

   if aspwk{i}=. and anyasp{i}=1 then aspwk{i}=0;

   if reguasp{i}=. and 0<=aspwk{i}<2 then reguasp{i}=1;
   else if reguasp{i}=. and 2<=aspwk{i} then reguasp{i}=2;
end;

/*cumulative average of aspirin tabs/week, what Reiko and Andy (tested with Andy gastro code, exactly the same)used*/
/*also exactly code as in cumavg macro-which works out fine and used by many other people*/ 
/*for missing, previous values were carried forward*/

sumvar=0; n=0;
do j=1 to dim(aspwk);
 avaspwkpre{j} = aspwk{j};
 if (aspwk{j} ne .) then do;
  n=n+1;
  sumvar=sumvar+aspwk{j};
 end;

 if n=0 then avaspwkpre{j} = aspwk{j};
 else avaspwkpre{j} = sumvar/n;
end;


/*prediagnosis average of regular use of aspirin using cumulative of aspirin intake*/
do i=1 to dim(avaspwkpre);
 if 0<=avaspwkpre{i}<2 then avregaspre{i}=1; /* No regular use of aspirin */
 else if avaspwkpre{i}>=2 then avregaspre{i}=2; /* regular use of aspirin */
 else if avaspwkpre{i}=. then avregaspre{i}=.;
end;

/*cumulative average of aspirin tabs/week, only count when asp is used, per Ed 010615*/

do i=1 to dim(avaspwkpren);
 if aspwk{i}<=0 then avaspwkpren{i}=.; /*also set 0 to ., so then won't be included in the mean calculation*/
end;

sumvar1=0; n1=0;
   do j=1 to dim(aspwk);
   if (aspwk{j} >0 ) then do;
   n1=n1+1;
   sumvar1=sumvar1+aspwk{j}; 
   avaspwkpren{j} = sumvar1/n1; end;
   else avaspwkpren{j}=.; /*need to set n1 back to 0 if aspwk=.*/

end;
 


/*Prediagnosis*/
/*carry aspirin variables forward ONE CYCLE if missing to use these as time-dependent variables*/ 
/*carry forward any use of aspirin one cycle*/
do i=1 to dim(anyasppre);
   anyasppre{i}=anyasp{i};
end;

do i=dim(anyasppre) to 2 by -1;
 if anyasppre{i} eq . and anyasppre{i-1} ne . then anyasppre{i}=anyasppre{i-1};
 if 0<aspwk{i} and anyasp{i}=. and anyasp{i-1}=1 then anyasppre{i}=.;     /*changed*/
 else if aspwk{i}=0 and anyasp{i}=. and anyasp{i-1}=2 then anyasppre{i}=.;/*changed*/
 else if anyasp{i}=. and reguasp{i}=2 and anyasp{i-1}=1 then anyasp{i}=1; /*changed*/
end;

 
/*carry forward aspirin tabs/week one cycle*/
do i=1 to dim(aspwk);
 aspwkpre{i}=aspwk{i};
end;

do i=dim(aspwkpre) to 2 by -1;
 if aspwkpre{i} eq . and aspwkpre{i-1} ne . then aspwkpre{i}=aspwkpre{i-1};
 if anyasp{i}=2 and aspwk{i}=. and aspwk{i-1}=0 then aspwkpre{i}=.;     /*changed*/
 else if anyasp{i}=1 and aspwk{i}=. and 0<aspwk{i-1} then aspwkpre{i}=.; /*changed*/
end;

/*carry forward cumulative average of aspirin tabs/week one cycle*/
do i=dim(avaspwkpre) to 2 by -1;
 if avaspwkpre{i} eq . and avaspwkpre{i-1} ne . then avaspwkpre{i}=avaspwkpre{i-1};
end;

do i=dim(avaspwkpren) to 2 by -1;
 if avaspwkpren{i} eq . and avaspwkpren{i-1} ne . then avaspwkpren{i}=avaspwkpren{i-1};
end;

/*carry forward regular use of aspirin one cycle*/
do i=1 to dim(reguasp);
 regaspre{i}=reguasp{i};
end;

do i=dim(regaspre) to 2 by -1;
 if regaspre{i} eq . and regaspre{i-1} ne . then regaspre{i}=regaspre{i-1};
 if anyasp{i}=1 and reguasp{i}=. and reguasp{i-1}=2 then regaspre{i}=.;     /*changed*/
end;

/*carry forward regular use of aspirin using cumulative average of aspirin tabs/week one cycle*/
do i=dim(avregaspre) to 2 by -1;
 if avregaspre{i} eq . and avregaspre{i-1} ne . then avregaspre{i}=avregaspre{i-1};
end;



/*duration of regular aspirin use*/
/*1980 questionnaire asked duration in the past*/
if aspwkpre80>=2 then do;
 adur8080=adur80; adur8082=2;
end;
else if 0<=aspwkpre80<2 then do;
 adur8080=0; adur8082=0;
end;
else if aspwkpre80=. then do;
 adur8080=.; adur8082=.;
end;

/*1988-2008, if aspirin was regularly used, 2 years were added as the duration in the period*/
/**note that do not use cumulative here*/

do i=2 to dim(adur);
 if aspwkpre{i}>=2 then adur{i}=2;
 else if 0<=aspwkpre{i}<2 then adur{i}=0;
 else if aspwkpre{i}=. then adur{i}=.;
end;
/*1986, no asprirn question*/
adur8688=adur8486;

/*fills in missing duration with one cycle prior questionnaire response*/ 
do i=2 to dim(adurarray);
 if adurarray{i}=. then adurarray{i}=adurarray{i-1};
 else;
end;

regaspdur80=sum(adur8080,adur8082);
regaspdur82=sum(adur8080,adur8082,adur8284);
regaspdur84=sum(adur8080,adur8082,adur8284,adur8486);
regaspdur86=sum(adur8080,adur8082,adur8284,adur8486,adur8688);
regaspdur88=sum(adur8080,adur8082,adur8284,adur8486,adur8688,adur8890);
regaspdur90=sum(adur8080,adur8082,adur8284,adur8486,adur8688,adur8890,adur9092);
regaspdur92=sum(adur8080,adur8082,adur8284,adur8486,adur8688,adur8890,adur9092,adur9294);
regaspdur94=sum(adur8080,adur8082,adur8284,adur8486,adur8688,adur8890,adur9092,adur9294,adur9496); 
regaspdur96=sum(adur8080,adur8082,adur8284,adur8486,adur8688,adur8890,adur9092,adur9294,adur9496,adur9698);
regaspdur98=sum(adur8080,adur8082,adur8284,adur8486,adur8688,adur8890,adur9092,adur9294,adur9496,adur9698,adur9800);
regaspdur00=sum(adur8080,adur8082,adur8284,adur8486,adur8688,adur8890,adur9092,adur9294,adur9496,adur9698,adur9800,adur0002);
regaspdur02=sum(adur8080,adur8082,adur8284,adur8486,adur8688,adur8890,adur9092,adur9294,adur9496,adur9698,adur9800,adur0002,adur0204);
regaspdur04=sum(adur8080,adur8082,adur8284,adur8486,adur8688,adur8890,adur9092,adur9294,adur9496,adur9698,adur9800,adur0002,adur0204,adur0406);
regaspdur06=sum(adur8080,adur8082,adur8284,adur8486,adur8688,adur8890,adur9092,adur9294,adur9496,adur9698,adur9800,adur0002,adur0204,adur0406,adur0608);
regaspdur08=sum(adur8080,adur8082,adur8284,adur8486,adur8688,adur8890,adur9092,adur9294,adur9496,adur9698,adur9800,adur0002,adur0204,adur0406,adur0608,adur0810);
regaspdur10=sum(adur8080,adur8082,adur8284,adur8486,adur8688,adur8890,adur9092,adur9294,adur9496,adur9698,adur9800,adur0002,adur0204,adur0406,adur0608,adur0810, adur1012);
regaspdur12=sum(adur8080,adur8082,adur8284,adur8486,adur8688,adur8890,adur9092,adur9294,adur9496,adur9698,adur9800,adur0002,adur0204,adur0406,adur0608,adur0810, adur1012,adur1214);
regaspdur14=sum(adur8080,adur8082,adur8284,adur8486,adur8688,adur8890,adur9092,adur9294,adur9496,adur9698,adur9800,adur0002,adur0204,adur0406,adur0608,adur0810, adur1012,adur1214,adur1416);
regaspdur16=sum(adur8080,adur8082,adur8284,adur8486,adur8688,adur8890,adur9092,adur9294,adur9496,adur9698,adur9800,adur0002,adur0204,adur0406,adur0608,adur0810, adur1012,adur1214,adur1416,adur1618);


/**********************new definition: duration of any asp use 011415***************/

/*duration of any aspirin use*/
/*1980 questionnaire asked duration in the past*/
if aspwkpre80>0 then do;
 aadur8080=adur80; aadur8082=2;
end;
else if aspwkpre80=0 then do;
 aadur8080=0; aadur8082=0;
end;
else if aspwkpre80=. then do;
 aadur8080=.; aadur8082=.;
end;

/*1988-2008, if aspirin was used, 2 years were added as the duration in the period*/
/**note that do not use cumulative here*/

do i=2 to dim(adur);
 if aspwkpre{i}>0 then aadur{i}=2;
 else if aspwkpre{i}=0 then aadur{i}=0;
 else if aspwkpre{i}=. then aadur{i}=.;
end;

/*1986, no asprirn question*/
aadur8688=aadur8486;

/*fills in missing duration with one cycle prior questionnaire response*/ 
do i=2 to dim(aadurarray);
 if aadurarray{i}=. then aadurarray{i}=aadurarray{i-1};
 else;
end;

aaspdur80=sum(aadur8080,aadur8082);
aaspdur82=sum(aadur8080,aadur8082,aadur8284);
aaspdur84=sum(aadur8080,aadur8082,aadur8284,aadur8486);
aaspdur86=sum(aadur8080,aadur8082,aadur8284,aadur8486,aadur8688);
aaspdur88=sum(aadur8080,aadur8082,aadur8284,aadur8486,aadur8688,aadur8890);
aaspdur90=sum(aadur8080,aadur8082,aadur8284,aadur8486,aadur8688,aadur8890,aadur9092);
aaspdur92=sum(aadur8080,aadur8082,aadur8284,aadur8486,aadur8688,aadur8890,aadur9092,aadur9294);
aaspdur94=sum(aadur8080,aadur8082,aadur8284,aadur8486,aadur8688,aadur8890,aadur9092,aadur9294,aadur9496); 
aaspdur96=sum(aadur8080,aadur8082,aadur8284,aadur8486,aadur8688,aadur8890,aadur9092,aadur9294,aadur9496,aadur9698);
aaspdur98=sum(aadur8080,aadur8082,aadur8284,aadur8486,aadur8688,aadur8890,aadur9092,aadur9294,aadur9496,aadur9698,aadur9800);
aaspdur00=sum(aadur8080,aadur8082,aadur8284,aadur8486,aadur8688,aadur8890,aadur9092,aadur9294,aadur9496,aadur9698,aadur9800,aadur0002);
aaspdur02=sum(aadur8080,aadur8082,aadur8284,aadur8486,aadur8688,aadur8890,aadur9092,aadur9294,aadur9496,aadur9698,aadur9800,aadur0002,aadur0204);
aaspdur04=sum(aadur8080,aadur8082,aadur8284,aadur8486,aadur8688,aadur8890,aadur9092,aadur9294,aadur9496,aadur9698,aadur9800,aadur0002,aadur0204,aadur0406);
aaspdur06=sum(aadur8080,aadur8082,aadur8284,aadur8486,aadur8688,aadur8890,aadur9092,aadur9294,aadur9496,aadur9698,aadur9800,aadur0002,aadur0204,aadur0406,aadur0608);
aaspdur08=sum(aadur8080,aadur8082,aadur8284,aadur8486,aadur8688,aadur8890,aadur9092,aadur9294,aadur9496,aadur9698,aadur9800,aadur0002,aadur0204,aadur0406,aadur0608,aadur0810);
aaspdur10=sum(aadur8080,aadur8082,aadur8284,aadur8486,aadur8688,aadur8890,aadur9092,aadur9294,aadur9496,aadur9698,aadur9800,aadur0002,aadur0204,aadur0406,aadur0608,aadur0810, aadur1012);
aaspdur12=sum(aadur8080,aadur8082,aadur8284,aadur8486,aadur8688,aadur8890,aadur9092,aadur9294,aadur9496,aadur9698,aadur9800,aadur0002,aadur0204,aadur0406,aadur0608,aadur0810, aadur1012,aadur1214);
aaspdur14=sum(aadur8080,aadur8082,aadur8284,aadur8486,aadur8688,aadur8890,aadur9092,aadur9294,aadur9496,aadur9698,aadur9800,aadur0002,aadur0204,aadur0406,aadur0608,aadur0810, aadur1012,aadur1214,aadur1416);
aaspdur16=sum(aadur8080,aadur8082,aadur8284,aadur8486,aadur8688,aadur8890,aadur9092,aadur9294,aadur9496,aadur9698,aadur9800,aadur0002,aadur0204,aadur0406,aadur0608,aadur0810, aadur1012,aadur1214,aadur1416,aadur1618);





*Create tablet/week-years*;
/*1980 questionnaire asked duration in the past*/
tabwy80=aspwkpre80*(adur80+2); *adur80 is duration before 1980, plus, 2 yrs*;
do i=2 to dim(tabwy);
   tabwy{i}=aspwkpre{i}*2; *tablet/wk*2years, if tab/wk is missing, tabwy is missing*;
end;

*cumulative average*;
sumvar=0; n=0;
do j=1 to dim(tabwy);
   cumtabwy{j}=tabwy{j};
   if (tabwy{j} ne .) then do;
      n=n+1;
      sumvar=sumvar+tabwy{j};
   end;
   if n=0 then cumtabwy{j}=tabwy{j};
   else cumtabwy{j}=sumvar/n;
end;

*if adur80 is missing, all the tablet/week-years are missing, only for NHS*;
if adur80=. then do;
   do i=1 to dim(cumtabwy);
      cumtabwy[i]=.;
   end;
end;

/*****time since discontinuation**********/
/*revised  1118 to use aspwkpre instead of avaspwkpre*/

do i=1 to dim(tsd);
if aspwkpre{i}>=2 then tsd{i}=5; /*current regular, lowest risk*/
else if regaspdur{i}=0 then tsd{i}=1; /*never used aspirin regularly, from the way duration is defined, 0 means all 0 in the past*/
else if .<aspwkpre{i}<2 then do; /*for non-current regular user*/
     tsd{i}=.;
     if i=2 then do; if aspwkpre{i-1}>=2 then tsd{i}=4; end;
     if i=3 then do; if aspwkpre{i-1}>=2 then tsd{i}=4;   /*<4 yr*/  
                          else if .<aspwkpre{i-1}<2 and aspwkpre{i-2}>=2 then tsd{i}=4;  /*<4 yr*/ 
                          end; 
     if i=4 then do; if aspwkpre{i-1}>=2 then tsd{i}=4;   /*<4 yr*/  
                          else if .<aspwkpre{i-1}<2 and aspwkpre{i-2}>=2 then tsd{i}=4;  /*<4 yr*/ 
                          else if .<aspwkpre{i-1}<2 and .<aspwkpre{i-2}<2 and aspwkpre{i-3}>=2 then tsd{i}=3; /*4-5.9*/
                          end; 

     if i>4 then do; if aspwkpre{i-1}>=2 then tsd{i}=4;   /*<4 yr*/  
                          else if .<aspwkpre{i-1}<2 and aspwkpre{i-2}>=2  then tsd{i}=4;  /*<4 yr*/    
                          else if .<aspwkpre{i-1}<2 and .<aspwkpre{i-2}<2 and aspwkpre{i-3}>=2 then tsd{i}=3;  /*4-5.9*/
                          else if .<aspwkpre{i-1}<2 and .<aspwkpre{i-2}<2 and .<aspwkpre{i-3}<2  then do;
                          do j=i-4 to 1 by -1;
                          if aspwkpre{j}>=2 then tsd{i}=2;  /*6+, more than 3 cycle non-users*/ 
                          end;
                          end; 
                          end;
end; 
                  
end;

/*Carry forward one cycle*/ 
do i=1 to dim(tsd);
timesd{i}=tsd{i};
end;

do i=dim(timesd) to 2 by -1;
 if timesd{i} eq . and timesd{i-1} ne . then timesd{i}=timesd{i-1};
end;

/*****************daily baby aspirin, since 2000********/
do i=1 to dim(baby);
 daily{i}=baby{i};
end;

do i=dim(daily) to 2 by -1;
 if daily{i} eq . and daily{i-1} ne . then daily{i}=daily{i-1};
end;

/*******baseline baby, baby00, per Andy********/

/*******consecutive baby, 2 QQ, since 04********/

/***00,02*/
if baby00=1 and baby02=1 then baby202=1;
else if baby00=3 and baby02=3 then baby202=3; /*consecutive daily baby user*/
else if baby00=4 and baby02=4 then baby202=4; /*consecutive daily adult*/
else if baby00=2 and baby02=2 then baby202=2; /*consecutive infrequent user*/

/***00,02,04*/
if baby00=1 and baby02=1 and baby04=1 then baby304=1; /*consecutive non-user*/
else if baby00=3 and baby02=3 and baby04=3 then baby304=3; /*consecutive daily baby user*/
else if baby00=4 and baby02=4 and baby04=4 then baby304=4; /*consecutive daily adult*/
else if baby00=2 and baby02=2 and baby04=2 then baby304=2; /*consecutive infrequent user*/

/*****NSAIDs*****/
/*Carry forward one cycle*/
do i=1 to dim(ibui);
 anyibu{i}=ibui{i};
end;

do i=dim(anyibu) to 2 by -1;
 if anyibu{i} eq . and anyibu{i-1} ne . then anyibu{i}=anyibu{i-1};
end;
run;

 

data nhs_asp;
set nhaspone;
keep id regaspre: regibui:
  /* anyasppre: 
   aspwkpre: avaspwkpre: avaspwkpren: *cumulative dose when asp is used*;
   avregaspre: *only NHS*;
   regaspdur: tabwy: cumtabwy: adur80
   aaspdur: *duration for any aspirin*;
   baby: daily: baby00 baby202 baby304
   tsd: timesd:
   bab00 asp00 bab02 asp02 bab04 asp04 bab06 asp06*/
;
run;
 
proc datasets nolist;
delete 
meddata fileb
aspdata nur82 nur84 nur88 nur90 nur92 nur94 nur96 nur98 
nur00 nur02 nur04 nur06 nur08 nur10 nur12 nur14 nur16
nhaspone;
run;

/*
proc means n nmiss mean data=nhs_asp;
var regaspre80 regaspre82 regaspre84 regaspre84 regaspre88 regaspre90 regaspre92 regaspre94 regaspre96 regaspre98 regaspre00 regaspre02 regaspre04 regaspre06 regaspre08 regaspre10 regaspre12 regaspre14 regaspre16
    regibui90 regibui92 regibui94 regibui96 regibui98 regibui00 regibui02 regibui04 regibui06 regibui08 regibui10 regibui12 regibui14 regibui16
;
run;
                                                     The MEANS Procedure

                                          Variable           N    N Miss            Mean
                                          ----------------------------------------------
                                          regaspre80    115001      6735       1.2774324
                                          regaspre82    121285       451       1.3450798
                                          regaspre84    111514     10222       1.3397690
                                          regaspre88     98574     23162       1.3445533
                                          regaspre90     95503     26233       1.2492592
                                          regaspre92     96158     25578       1.2811519
                                          regaspre94     96419     25317       1.2637136
                                          regaspre96     94104     27632       1.3165859
                                          regaspre98     87884     33852       1.3327113
                                          regaspre00     89733     32003       1.3166839
                                          regaspre02     87648     34088       1.3478003
                                          regaspre04     82943     38793       1.4243276
                                          regaspre06     83269     38467       1.4425537
                                          regaspre08     80263     41473       1.4589661
                                          regaspre10     71993     49743       1.4794772
                                          regaspre12     67085     54651       1.4751286
                                          regaspre14     61184     60552       1.4539259
                                          regaspre16     55345     66391       1.4223868
                                          regibui90      84980     36756       1.3636973
                                          regibui92      96158     25578       1.4134133
                                          regibui94      97239     24497       1.2611812
                                          regibui96      97003     24733       1.2637032
                                          regibui98      94073     27663       1.3185611
                                          regibui00      92414     29322       1.2731945
                                          regibui02      90192     31544       1.2364068
                                          regibui04      84966     36770       1.2334581
                                          regibui06      79834     41902       1.2423153
                                          regibui08      76972     44764       1.2301616
                                          regibui10      73631     48105       1.2342492
                                          regibui12      68797     52939       1.2338038
                                          regibui14      63909     57827       1.2621540
                                          regibui16      57901     63835       1.2285625
                                          ----------------------------------------------

*/