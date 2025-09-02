/* This program was developed by the coauthor Peilu Wang and used in her project 
'Optimal dietary patterns for prevention of chronic disease' published on Nature Medicine. */
*--- Goal: Derive variables for aspirin and nsaids in HPFS 1986-2016
*--- update: 10/20/2021
*--- dir: /udd/n2pwa/proj_data/others
*--- ref: /udd/nhyco/aspirin_immune/hpfsasp.sas
     Change: update from 2002 to 2016
*--- incl: %hp86 - %hp16
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

%hp86 (keep=id asp86 aspi86 q18pt86 nomed86 tyl86 motrn86 ibui86 tyli86, noformat=t);
     aspi86=1;
     if asp86=1 then aspi86=2;

     ibui86=1;
     if motrn86=1 then ibui86=2;

     tyli86=1;
     if tyl86=1 then tyli86=2;
run;

%hp88 (keep=id asp88 q26pt88 flag88 aspi88 motrn88 ibui88 tyl88 tyli88, noformat=t); 
     aspi88=1;
     if asp88=1 then aspi88=2;

     ibui88=1;
     if motrn88=1 then ibui88=2;

     tyli88=1;
     if tyl88=1 then tyli88=2;

     if flag88=2 then do;
          aspi88=.; 
          ibui88=.;
          tyli88=.;
     end;
run; 

%hp90 (keep=id asp90 aspi90 flag90 q20pt90 motrn90 ibui90 tyl90 tyli90, noformat=t);
     aspi90=1;
     if asp90=1 then aspi90=2; 

     ibui90=1;
     if motrn90=1 then ibui90=2;

     tyli90=1;
     if tyl90=1 then tyli90=2;

     if flag90=2 then do;
          aspi90=.;
          ibui90=.;
          tyli90=.; 
     end;
run;



/*********************************************************************
1992 data
asp92: current use of aspirin 2+ times/week 
       1=yes
aspd92: Aspirin, average days in a month
        1=Never 2=1-4 days/month 3=5-14 days/month 4=15-21 days/month 
        5=22+ days/month 6=passthru
nasp92: How many aspirin a day
        1=Never, 2=less than 1,	3=1 aspirin, 4=2 aspirin, 
        5=3 - 4 aspirin, 6=5 - 6 aspirin, 7=7+  aspirin, 8=passthru
nomed92: 1=No regular medication, 2=passthru
**********************************************************************/
%hp92 (keep=id asp92 aspd92 nasp92 aspi92 flag92 nomed92 aspd nasp aspmo92 aspwk92
     motrn92 tyl92 ibui92 tyli92, noformat=t);
     
     aspi92=.;
     if asp92=1 then aspi92=2; 

     ibui92=1;
     if motrn92=1 then ibui92=2;

     tyli92=1;
     if tyl92=1 then tyli92=2;

     if aspd92=1 then aspd=0;
     else if aspd92=2 then aspd=2.5;
     else if aspd92=3 then aspd=9.5;
     else if aspd92=4 then aspd=18;
     else if aspd92=5 then aspd=30;
     else if aspd92 in (0,6) then aspd=.;

     if nasp92=1 then nasp=0;
     else if nasp92=2 then nasp=0.5;
     else if nasp92=3 then nasp=1;
     else if nasp92=4 then nasp=2;
     else if nasp92=5 then nasp=3.5;
     else if nasp92=6 then nasp=5.5;
     else if nasp92=7 then nasp=9;
     else if nasp92 in(0,8) then nasp=.;

     aspmo92=aspd*nasp; ** number of tablets asp/month **;
     aspwk92=aspmo92/4.3;  

     if aspi92=. then do;
          if aspd92>=3 then aspi92=2; * >=2 times/week ;
          else if 0<=aspd92<3 then aspi92=1;
          else aspi92=1;
     end;              

     if flag92=2 then do; 
          aspi92=.; 
          aspwk92=.; 
          aspd92=.;
          tyli92=.;
          ibui92=.;   
     end;

     if flag92=1 then do;
          if aspi92=1 and aspwk92=. then  aspwk92=0; 
          if aspi92=1 and aspd92=. then aspd92=1;  
     end;   

run;


%hp94(keep=id asp94 aspfr94 aspw94 aspi94 aspwk94 aspmo94 freque94 nasp94 naspxx aspd94 flag94
     motrn94 tyl94 ibui94 tyli94, noformat=t);

     aspi94=.;
     if asp94=1 then aspi94=2;

     tyli94=1;
     if tyl94=1 then tyli94=2;

     ibui94=1;
     if motrn94=1 then ibui94=2;
     * 07.08.04 recode the 1994 ibuprofen variable *;

     freque94=aspfr94;
     nasp94=aspw94;

          if freque94=1 then aspd94=1;
     else if freque94=2 then aspd94=2;
     else if freque94=3 then aspd94=3;
     else if freque94=4 then aspd94=4;
     else if freque94 in (5,6) then aspd94=5;
     else if freque94 in (0,7) then aspd94=.;

          if nasp94=1 then naspxx=0;
     else if nasp94=2 then naspxx=1.25;
     else if nasp94=3 then naspxx=4;
     else if nasp94=4 then naspxx=10;
     else if nasp94=5 then naspxx=20;
     else if nasp94 in(0,6) then naspxx=.;

     aspwk94 = naspxx; 
     aspmo94 = naspxx * 4.3; 

     if aspi94=. then do;
          if aspd94>=3 then aspi94=2; 
          else if 0<=aspd94<3 then aspi94=1;
          else aspi94=1;
     end;

     if flag94=2 then do;
          aspi94=.;
          aspwk94=.;
          aspd94=.;
          ibui94=.;
          tyli94=.;
     end;

     if flag94=1 then do;
          if aspi94=1 and aspwk94=. then aspwk94=0;
          if aspi94=1 and aspd94=. then aspd94=1;
     end;
run;

%hp96 (keep=id aspd96 nasp96 flag96 aspi96 aspd nasp aspmo96 aspwk96
     motrn96 tyl96 ibui96 tyli96 onsai96, noformat=t);
     if aspd96=1 then aspd=0;
     else if aspd96=2 then aspd=2.5;
     else if aspd96=3 then aspd=9.5;
     else if aspd96=4 then aspd=18;
     else if aspd96=5 then aspd=30;
     else if aspd96 in (0,6) then aspd=.;

     if nasp96=1 then nasp=0;
     else if nasp96=2 then nasp=0.5;
     else if nasp96=3 then nasp=1;
     else if nasp96=4 then nasp=2;
     else if nasp96=5 then nasp=3.5;
     else if nasp96=6 then nasp=5.5;
     else if nasp96=7 then nasp=9;
     else if nasp96 in(0,8) then nasp=.;

     aspmo96=aspd*nasp; 
     aspwk96=aspmo96/4.3;

     if 0<=aspd96<3 then aspi96=1;
     else if aspd96>=3 then aspi96=2;
     else aspi96=.;

     ibui96=1;
     if motrn96=1 then ibui96=2;
     else if onsai96=1 then ibui96=2;
     
     tyli96=1;
     if tyl96=1 then tyli96=2;

     if flag96=2 then do;
          aspi96=.;
          aspwk96=.;
          aspd96=.;
          ibui96=.;
          tyli96=.;
     end;
run;

%hp98(keep=id aspfr98 aspw98 flag98 nasp98 aspd98 naspx aspwk98 aspmo98 aspi98
           tyl98 motrn98 nsaid98 ibui98 tyli98, noformat=t);

     nasp98= aspw98;

     if aspfr98=1 then aspd98=1;
     else if aspfr98=2 then aspd98=2;
     else if aspfr98=3 then aspd98=3;
     else if aspfr98=4 then aspd98=4;
     else if aspfr98 in (5,6) then aspd98=5;
     else if aspfr98 in (0,7) then aspd98=.;

     if nasp98=1 then naspx=0;
     else if nasp98=2 then naspx=1.25;
     else if nasp98=3 then naspx=4;
     else if nasp98=4 then naspx=10;
     else if nasp98=5 then naspx=20;
     else if nasp98 in(0,6) then naspx=.;

     aspwk98 = naspx; /*1998 average asp per week*/
     aspmo98 = naspx * 4.3; /*1998 asp per month*/

     if 0<=aspd98<3 then aspi98=1;
     else if aspd98>=3 then aspi98=2;
     else aspi98=.;

     ibui98=1;
     if motrn98=1 then ibui98=2;
     if nsaid98=1 then ibui98=2;
     
     tyli98=1;
     if tyl98=1 then tyli98=2;

     if flag98=2 then do;
          aspi98=.;
          aspwk98=.;
          aspd98=.;
          ibui98=.;
          tyli98=.;
     end;
run;


%hp00(keep=id asp00 aspw00 aspdw00 aspds00 flag00 aspd00 nasp00 aspi00 naspxx dosxx mgwk baby00 aspwk00 aspmo00
     tyl00 tyldw00 tylw00 motrn00 nsaid00 mtrnw00 mtrdw00 ibui00 tyli00, noformat=t); 

     aspd00= aspdw00;
     nasp00= aspw00;

     if flag00=1 then do;
          if asp00=1 then aspi00=2;  
          else if aspdw00 in (2,3,4) then aspi00=2;
          else aspi00=1;
     end;

     baby00=1; /*nonuser*/
     if aspds00 in (1,2) and aspdw00=4 then baby00=3; /*daily baby*/
     else if aspds00 in (3,4) and aspdw00=4 then baby00=4; /*daily adult*/
     else if aspi00=2 then baby00=2; /*infrequent user*/

     if flag00=1 then do;
          tyli00=1;
          if tyl00=1 then tyli00=2;
     end;
     
     if flag00=1 then do;
          ibui00=1;
          if motrn00=1 then ibui00=2;
          if mtrdw00 in (2,3,4) then ibui00=2;
          if nsaid00=1 then ibui00=2; /*nsaids other than ibuprofen*/
     end;

     if aspdw00=1 then aspd00=2;
     else if aspdw00=2 then aspd00=3;
     else if aspdw00=3 then aspd00=4;
     else if aspdw00=4 then aspd00=5;
     else if aspi00=1 then aspd00=1;
     else if aspdw00 in (0,5) then aspd00=.; 
     
     if nasp00=1 then naspxx=1.5;
     else if nasp00=2 then naspxx=4;
     else if nasp00=3 then naspxx=10;
     else if nasp00=4 then naspxx=20;
     else if aspi00=1 then naspxx=0;
     else if nasp00 in (0,5) then naspxx=.;

     if aspds00=1 then dosxx=81; /*81 mg dose is likely*/
     else if aspds00=2 then dosxx=162; /*2 baby aspirin dose*/
     else if aspds00=3 then dosxx=325;
     else if aspds00=4 then dosxx=650;
     else if aspds00 in (0,5) then dosxx=.;

     if dosxx ne . then mgwk=naspxx*dosxx; 
     else mgwk=naspxx*325; /*if mg/week is missing, assume standard dose*/

     /*standard aspirin tablets/week*/
     aspwk00 = mgwk/325; /*2000average asp per week (standard dose equivalents)*/
     aspmo00 = aspwk00 * 4.3; /*2000 asp per month*/

     if flag00=2 then do;
          aspi00=.;
          aspwk00=.;
          aspd00=.;
          ibui00=.;
          tyli00=.;
          baby00=.;
     end;
run;

%hp02(keep=id asp02 aspd02 aspt02 aspds02 flag02 nasp02 aspi02 naspxx dosxx baby02 mgwk aspwk02 aspmo02
     tyl02 tyld02 tylt02 mtrn02 mtrnd02 mtrnt02 analg02 cox2i02 ibui02 tyli02, noformat=t);

     aspd02= aspd02;
     nasp02= aspt02;

     if flag02=1 then do;
     if asp02=1 then aspi02=2;  
     else if aspd02 in (2,3,4) then aspi02=2;
     else aspi02=1;
     end;

     baby02=1; 
     if aspds02 in (1,2) and aspd02=4 then baby02=3; 
     else if aspds02 in (3,4) and aspd02=4 then baby02=4;
     else if aspi02=2 then baby02=2; 

     if flag02=1 then do;
     tyli02=1;
     if tyl02=1 then tyli02=2;
     end;
     
     if flag02=1 then do;
     ibui02=1;
     if mtrnd02 in (2,3,4) then ibui02=2;
     if mtrn02=1 then ibui02=2;
     if analg02=1 then ibui02=2; 
     end;

     if aspd02=1 then aspd02=2;
     else if aspd02=2 then aspd02=3;
     else if aspd02=3 then aspd02=4;
     else if aspd02=4 then aspd02=5;
     else if aspi02=1 then aspd02=1; 
     else if aspd02 in (0,5) then aspd02=.; 

     if nasp02=1 then naspxx=1.5;
     else if nasp02=2 then naspxx=4;
     else if nasp02=3 then naspxx=10;
     else if nasp02=4 then naspxx=20;
     else if aspi02=1 then naspxx=0; 
     else if nasp02 in (0,5) then naspxx=.;

     if aspds02=1 then dosxx=81; 
     else if aspds02=2 then dosxx=162; 
     else if aspds02=3 then dosxx=325;
     else if aspds02=4 then dosxx=650;
     else if aspds02 in (0,5) then dosxx=.;

     if dosxx ne . then mgwk=naspxx*dosxx; 
     else mgwk=naspxx*325; 
          
     aspwk02 = mgwk/325; 
     aspmo02 = aspwk02 * 4.3; 

     if flag02=2 then do;
          aspi02=.;
          aspwk02=.;
          aspd02=.;
          ibui02=.;
          tyli02=.;
          baby02=.;
     end;
run;

%hp04(keep=id asp04 aspd04 aspt04 aspds04 flag04 nasp04 aspi04 naspxx dosxx baby04 mgwk aspwk04 aspmo04
     tyl04 tyld04 tylt04 mtrn04 mtrnd04 mtrnt04 analg04 cox2i04 cox2d04 ibui04 tyli04, noformat=t);

     aspd04= aspd04;
     nasp04= aspt04;

     if flag04=1 then do;
     if asp04=1 then aspi04=2;  
     else if aspd04 in (2,3,4) then aspi04=2;
     else aspi04=1;
     end;

     
     baby04=1;
     if aspds04 in (1,2) and aspd04=4 then baby04=3;
     else if aspds04 in (3,4) and aspd04=4 then baby04=4;
     else if aspi04=2 then baby04=2;

     
     if flag04=1 then do;
     tyli04=1;
     if tyl04=1 then tyli04=2;
     end;
     
     
     if flag04=1 then do;
     ibui04=1;
     if mtrn04=1 then ibui04=2;
     if mtrnd04 in (2,3,4) then ibui04=2;
     if analg04=1 then ibui04=2;
     end;

     if aspd04=1 then aspd04=2;
     else if aspd04=2 then aspd04=3;
     else if aspd04=3 then aspd04=4;
     else if aspd04=4 then aspd04=5;
     else if aspi04=1 then aspd04=1;
     else if aspd04 in (0,5) then aspd04=.; 

          if nasp04=1 then naspxx=1.5;
     else if nasp04=2 then naspxx=4;
     else if nasp04=3 then naspxx=10;
     else if nasp04=4 then naspxx=20;
     else if aspi04=1 then naspxx=0;
     else if nasp04 in (0,5) then naspxx=.;

     if aspds04=1 then dosxx=81;
     else if aspds04=2 then dosxx=162;
     else if aspds04=3 then dosxx=325;
     else if aspds04=4 then dosxx=650;
     else if aspds04 in (0,5) then dosxx=.;

     if dosxx ne . then mgwk=naspxx*dosxx; 
     else mgwk=naspxx*325;
          
     aspwk04 = mgwk/325;
     aspmo04 = aspwk04 * 4.3;

     if flag04=2 then do;
          aspi04=.;
          aspwk04=.;
          aspd04=.;
          ibui04=.;
          tyli04=.;
          baby04=.;
     end;
run;

%hp06(keep=id asp06 aspd06 aspt06 aspds06 flag06 nasp06 aspi06 naspxx dosxx baby06 mgwk aspwk06 aspmo06
     tyl06 tyld06 tylt06 mtrn06 mtrnd06 mtrnt06 analg06 cox2i06 cox2d06 ibui06 tyli06, noformat=t);

     aspd06= aspd06;
     nasp06= aspt06;

     if flag06=1 then do;
     if asp06=1 then aspi06=2;  
     else if aspd06 in (2,3,4) then aspi06=2;
     else aspi06=1;
     end;

     baby06=1;
     if aspds06 in (1,2) and aspd06=4 then baby06=3;
     else if aspds06 in (3,4) and aspd06=4 then baby06=4;
     else if aspi06=2 then baby06=2;


     if flag06=1 then do;
     tyli06=1;
     if tyl06=1 then tyli06=2;
     end;
     
     if flag06=1 then do;
     ibui06=1;
     if mtrn06=1 then ibui06=2;
     if mtrnd06 in (2,3,4) then ibui06=2;
     if analg06=1 then ibui06=2;
     end;

     if aspd06=1 then aspd06=2;
     else if aspd06=2 then aspd06=3;
     else if aspd06=3 then aspd06=4;
     else if aspd06=4 then aspd06=5;
     else if aspi06=1 then aspd06=1;
     else if aspd06 in (0,5) then aspd06=.; 

          if nasp06=1 then naspxx=1.5;
     else if nasp06=2 then naspxx=4;
     else if nasp06=3 then naspxx=10;
     else if nasp06=4 then naspxx=20;
     else if aspi06=1 then naspxx=0;
     else if nasp06 in (0,5) then naspxx=.;

     if aspds06=1 then dosxx=81;
     else if aspds06=2 then dosxx=162;
     else if aspds06=3 then dosxx=325;
     else if aspds06=4 then dosxx=650;
     else if aspds06 in (0,5) then dosxx=.;

     if dosxx ne . then mgwk=naspxx*dosxx; 
     else mgwk=naspxx*325;
          
     aspwk06 = mgwk/325;
     aspmo06 = aspwk06 * 4.3;

     if flag06=2 then do;
          aspi06=.;
          aspwk06=.;
          aspd06=.;
          ibui06=.;
          tyli06=.;
          baby06=.;
     end;
run;


%hp08(keep=id asp08 aspd08 aspt08 aspds08 flag08 nasp08 aspi08 naspxx dosxx baby08 mgwk aspwk08 aspmo08
     tyl08 tyld08 tylt08 mtrn08 mtrnd08 mtrnt08 analg08 cox2i08 cox2d08 ibui08 tyli08);

     aspd08= aspd08;
     nasp08= aspt08;

     if flag08=1 then do;
     if asp08=1 then aspi08=2;  
     else if aspd08 in (2,3,4) then aspi08=2;
     else aspi08=1;
     end;

     baby08=1;
     if aspds08 in (1,2) and aspd08=5 then baby08=3;
     else if aspds08 in (3,4) and aspd08=5 then baby08=4;
     else if aspi08=2 then baby08=2;


     if flag08=1 then do;
     tyli08=1;
     if tyl08=1 then tyli08=2;
     end;
     

     if flag08=1 then do;
     ibui08=1;
     if mtrn08=1 then ibui08=2;
     if mtrnd08 in (2,3,4) then ibui08=2;
     if analg08=1 then ibui08=2;
     end;

     if aspd08=1 then aspd08=2;
     else if aspd08=2 then aspd08=3;
     else if aspd08=3 then aspd08=4;
     else if aspd08=4 then aspd08=5;
     else if aspi08=1 then aspd08=1;
     else if aspd08 in (0,5) then aspd08=.; 

          if nasp08=1 then naspxx=1.5;
     else if nasp08=2 then naspxx=4;
     else if nasp08=3 then naspxx=10;
     else if nasp08=4 then naspxx=20;
     else if aspi08=1 then naspxx=0;
     else if nasp08 in (0,5) then naspxx=.;

     if aspds08=1 then dosxx=81;
     else if aspds08=2 then dosxx=162;
     else if aspds08=3 then dosxx=325;
     else if aspds08=4 then dosxx=650;
     else if aspds08 in (0,5) then dosxx=.;

     if dosxx ne . then mgwk=naspxx*dosxx; 
     else mgwk=naspxx*325;
          
     aspwk08 = mgwk/325; 
     aspmo08 = aspwk08 * 4.3;

     if flag08=2 then do;
          aspi08=.;
          aspwk08=.;
          aspd08=.;
          ibui08=.;
          tyli08=.;
          baby08=.;
     end;
run;

%hp10(keep=id asp10 aspd10 aspt10 aspds10 flag10 nasp10 aspi10 naspxx dosxx baby10 mgwk aspwk10 aspmo10
     tyl10 tyld10 tylt10 mtrn10 mtrnd10 mtrnt10 analg10 cox2i10 cox2d10 ibui10 tyli10);

     aspd10= aspd10;
     nasp10= aspt10;

     if flag10=1 then do;
     if asp10=1 then aspi10=2;  
     else if aspd10 in (2,3,4) then aspi10=2;
     else aspi10=1;
     end;

     baby10=1;
     if aspds10 in (1,2) and aspd10=5 then baby10=3;
     else if aspds10 in (3,4) and aspd10=5 then baby10=4;
     else if aspi10=2 then baby10=2;


     if flag10=1 then do;
     tyli10=1;
     if tyl10=1 then tyli10=2;
     end;
     

     if flag10=1 then do;
     ibui10=1;
     if mtrn10=1 then ibui10=2;
     if mtrnd10 in (2,3,4) then ibui10=2;
     if analg10=1 then ibui10=2;
     end;

     if aspd10=1 then aspd10=2;
     else if aspd10=2 then aspd10=3;
     else if aspd10=3 then aspd10=4;
     else if aspd10=4 then aspd10=5;
     else if aspi10=1 then aspd10=1;
     else if aspd10 in (0,5) then aspd10=.; 

          if nasp10=1 then naspxx=1.5;
     else if nasp10=2 then naspxx=4;
     else if nasp10=3 then naspxx=10;
     else if nasp10=4 then naspxx=20;
     else if aspi10=1 then naspxx=0;
     else if nasp10 in (0,5) then naspxx=.;

     if aspds10=1 then dosxx=81;
     else if aspds10=2 then dosxx=162;
     else if aspds10=3 then dosxx=325;
     else if aspds10=4 then dosxx=650;
     else if aspds10 in (0,5) then dosxx=.;

     if dosxx ne . then mgwk=naspxx*dosxx; 
     else mgwk=naspxx*325;
          
     aspwk10 = mgwk/325; 
     aspmo10 = aspwk10 * 4.3;

     if flag10=2 then do;
          aspi10=.;
          aspwk10=.;
          aspd10=.;
          ibui10=.;
          tyli10=.;
          baby10=.;
     end;
run;

%hp12(keep=id asp12 aspd12 aspt12 aspds12 flag12 nasp12 aspi12 naspxx dosxx baby12 mgwk aspwk12 aspmo12
     tyl12 tyld12 tylt12 mtrn12 mtrnd12 mtrnt12 analg12 cox2i12 cox2d12 ibui12 tyli12);

     aspd12= aspd12;
     nasp12= aspt12;

     if flag12 in (1,3) then do;
     if asp12=1 then aspi12=2;  
     else if aspd12 in (2,3,4) then aspi12=2;
     else aspi12=1;
     end;

     baby12=1;
     if aspds12 in (1,2) and aspd12=5 then baby12=3;
     else if aspds12 in (3,4) and aspd12=5 then baby12=4;
     else if aspi12=2 then baby12=2;


     if flag12 in (1,3) then do;
     tyli12=1;
     if tyl12=1 then tyli12=2;
     end;
     

     if flag12 in (1,3) then do;
     ibui12=1;
     if mtrn12=1 then ibui12=2;
     if mtrnd12 in (2,3,4) then ibui12=2;
     if analg12=1 then ibui12=2;
     end;

     if aspd12=1 then aspd12=2;
     else if aspd12=2 then aspd12=3;
     else if aspd12=3 then aspd12=4;
     else if aspd12=4 then aspd12=5;
     else if aspi12=1 then aspd12=1;
     else if aspd12 in (0,5) then aspd12=.; 

          if nasp12=1 then naspxx=1.5;
     else if nasp12=2 then naspxx=4;
     else if nasp12=3 then naspxx=10;
     else if nasp12=4 then naspxx=20;
     else if aspi12=1 then naspxx=0;
     else if nasp12 in (0,5) then naspxx=.;

     if aspds12=1 then dosxx=81;
     else if aspds12=2 then dosxx=162;
     else if aspds12=3 then dosxx=325;
     else if aspds12=4 then dosxx=650;
     else if aspds12 in (0,5) then dosxx=.;

     if dosxx ne . then mgwk=naspxx*dosxx; 
     else mgwk=naspxx*325;
          
     aspwk12 = mgwk/325; 
     aspmo12 = aspwk12 * 4.3;

     if flag12=2 then do;
          aspi12=.;
          aspwk12=.;
          aspd12=.;
          ibui12=.;
          tyli12=.;
          baby12=.;
     end;
run;

%hp14(keep=id asp14 aspd14 aspt14 flag14 nasp14 aspi14 naspxx baby14 mgwk aspwk14 aspmo14
     tyl14 tyld14 tylt14 mtrn14 mtrnd14 mtrnt14 analg14 cox2i14 cox2d14 ibui14 tyli14);

     aspd14= aspd14;
     nasp14= aspt14;

     if flag14 in (1,3) then do;
     if asp14=1 then aspi14=2;  
     else if aspd14 in (2,3,4) then aspi14=2;
     else aspi14=1;
     end;

     if flag14 in (1,3) then do;
     tyli14=1;
     if tyl14=1 then tyli14=2;
     end; 

     if flag14 in (1,3) then do;
     ibui14=1;
     if mtrn14=1 then ibui14=2;
     if mtrnd14 in (2,3,4) then ibui14=2;
     if analg14=1 then ibui14=2;
     end;

     if aspd14=1 then aspd14=2;
     else if aspd14=2 then aspd14=3;
     else if aspd14=3 then aspd14=4;
     else if aspd14=4 then aspd14=5;
     else if aspi14=1 then aspd14=1;
     else if aspd14 in (0,5) then aspd14=.; 

          if nasp14=1 then naspxx=1.5;
     else if nasp14=2 then naspxx=4;
     else if nasp14=3 then naspxx=10;
     else if nasp14=4 then naspxx=20;
     else if aspi14=1 then naspxx=0;
     else if nasp14 in (0,5) then naspxx=.;

     mgwk=naspxx*325;
          
     aspwk14 = mgwk/325; 
     aspmo14 = aspwk14 * 4.3;

     if flag14=2 then do;
          aspi14=.;
          aspwk14=.;
          aspd14=.;
          ibui14=.;
          tyli14=.;
          baby14=.;
     end;
run;

%hp16(keep=id asp16 aspd16 aspt16 flag16 nasp16 aspi16 naspxx baby16 mgwk aspwk16 aspmo16
     acetam16 acedays16 acetabs16 ibupro16 ibudays16 ibutabs16 analg16 celebrex16 celetabs16 ibui16 tyli16);

     aspd16= aspd16;
     nasp16= aspt16;

     if flag16 in (1,3) then do;
     if asp16=1 then aspi16=2;  
     else if aspd16 in (2,3,4) then aspi16=2;
     else aspi16=1;
     end;

     if flag16 in (1,3) then do;
     tyli16=1;
     if acetam16=1 then tyli16=2;
     end; 

     if flag16 in (1,3) then do;
     ibui16=1;
     if ibupro16=1 then ibui16=2;
     if ibudays16 in (2,3,4) then ibui16=2;
     if analg16=1 then ibui16=2;
     end;

     if aspd16=1 then aspd16=2;
     else if aspd16=2 then aspd16=3;
     else if aspd16=3 then aspd16=4;
     else if aspd16=4 then aspd16=5;
     else if aspi16=1 then aspd16=1;
     else if aspd16 in (0,5) then aspd16=.; 

          if nasp16=1 then naspxx=1.5;
     else if nasp16=2 then naspxx=4;
     else if nasp16=3 then naspxx=10;
     else if nasp16=4 then naspxx=20;
     else if aspi16=1 then naspxx=0;
     else if nasp16 in (0,5) then naspxx=.;

     mgwk=naspxx*325;
          
     aspwk16 = mgwk/325; 
     aspmo16 = aspwk16 * 4.3;

     if flag16=2 then do;
          aspi16=.;
          aspwk16=.;
          aspd16=.;
          ibui16=.;
          tyli16=.;
          baby16=.;
     end;
run;

/*merge aspirin files*/
data hpaspone;
     merge  hp86 hp88 hp90 hp92 hp94 hp96 hp98 hp00 hp02 hp04 hp06 hp08 hp10 hp12 hp14 hp16;
     by id;
     if first.id;

/*Carry forward or backward if missing and creat new aspirin variables*/
array anyasppre{*} anyasppre86 anyasppre88 anyasppre90 anyasppre92 anyasppre94 anyasppre96 anyasppre98 
                   anyasppre00 anyasppre02 anyasppre04 anyasppre06 anyasppre08 anyasppre10 anyasppre12 anyasppre14 anyasppre16;

/*aspirin intake tabs/week -available from 1992-*/
array aspwk{*} aspwk92 aspwk94 aspwk96 aspwk98 aspwk00 aspwk02 aspwk04 aspwk06 aspwk08 aspwk10 aspwk12 aspwk14 aspwk16;
array aspwkpre{*} aspwkpre92 aspwkpre94 aspwkpre96 aspwkpre98 aspwkpre00 
     aspwkpre02 aspwkpre04 aspwkpre06 aspwkpre08 aspwkpre10 aspwkpre12 aspwkpre14 aspwkpre16;			   
array avaspwkpre{*} avaspwkpre92 avaspwkpre94 avaspwkpre96 avaspwkpre98 avaspwkpre00
     avaspwkpre02 avaspwkpre04 avaspwkpre06 avaspwkpre08 avaspwkpre10 avaspwkpre12 avaspwkpre14 avaspwkpre16; 

array avaspwkpren{*} avaspwkpren92 avaspwkpren94 avaspwkpren96 avaspwkpren98 avaspwkpren00
     avaspwkpren02 avaspwkpren04 avaspwkpren06 avaspwkpren08 avaspwkpren10 avaspwkpren12 avaspwkpren14 avaspwkpren16;  
                    * per Ed, cumulative dose only when aspirin is used *;

/*regular use of aspirin*/
* cumulative average is not calculated for regular use in HPFS 
because regular use is defined as frequency (2 or more times/week) *;				  
array reguasp{*} aspi86 aspi88 aspi90 aspi92 aspi94
     aspi96 aspi98 aspi00 aspi02 aspi04 aspi06 aspi08 aspi10 aspi12 aspi14 aspi16;
array regaspre{*} regaspre86 regaspre88 regaspre90 regaspre92 regaspre94
     regaspre96 regaspre98 regaspre00 regaspre02 regaspre04 regaspre06 regaspre08 regaspre10 regaspre12 regaspre14 regaspre16;

/*duration of regular use of aspirin*/
array adur{*} adur8688 adur8890 adur9092 adur9294 adur9496 adur9698 adur9800 
     adur0002 adur0204 adur0406 adur0608 adur0810 adur1012 adur1214 adur1416 adur1618;
array adurarray{*}  adur8688 adur8890 adur9092 adur9294 adur9496 adur9698 adur9800
     adur0002 adur0204 adur0406 adur0608 adur0810 adur1012 adur1214 adur1416 adur1618;

array regaspdur{*} regaspdur86 regaspdur88 regaspdur90 regaspdur92 regaspdur94 
     regaspdur96 regaspdur98 regaspdur00 regaspdur02 regaspdur04 regaspdur06 regaspdur08 regaspdur10 regaspdur12 regaspdur14 regaspdur16;

/*to have same number of variables in the array from 1992*/
array sameaspwk{*} aspwk92 aspwk94 aspwk96 aspwk98 aspwk00 aspwk02 aspwk04 aspwk06 aspwk08 aspwk10 aspwk12 aspwk14 aspwk16;
array samereguasp{*} aspi92 aspi94 aspi96 aspi98 aspi00 aspi02 aspi04 aspi06 aspi08 aspi10 aspi12 aspi14 aspi16;
array sameaspwkpre{*} aspwkpre92 aspwkpre94 aspwkpre96 aspwkpre98 aspwkpre00 
     aspwkpre02 aspwkpre04 aspwkpre06 aspwkpre08 aspwkpre10 aspwkpre12 aspwkpre14 aspwkpre16;			   
array sameregaspre{*} regaspre92 regaspre94 regaspre96 regaspre98 regaspre00 regaspre02 regaspre04 regaspre06 
     regaspre08 regaspre10 regaspre12 regaspre14 regaspre16;

/*tablet/week-years*/
array tabwy{*} tabwy92 tabwy94 tabwy96 tabwy98 tabwy00 tabwy02 tabwy04 tabwy06 tabwy08 tabwy10 tabwy12 tabwy14 tabwy16;
array cumtabwy{*} cumtabwy92 cumtabwy94 cumtabwy96 cumtabwy98 cumtabwy00 cumtabwy02 cumtabwy04 cumtabwy06 cumtabwy08 cumtabwy10 cumtabwy12 cumtabwy14 cumtabwy16;


/*time since discontinuation, per Andy 102714*/
array tsd{*} tsd86 tsd88 tsd90 tsd92 tsd94 tsd96 tsd98 tsd00 tsd02 tsd04 tsd06 tsd08 tsd10 tsd12 tsd14 tsd16;
array timesd{*} timesd86 timesd88 timesd90 timesd92 timesd94
     timesd96 timesd98 timesd00 timesd02 timesd04 timesd06 timesd08 timesd10 timesd12 timesd14 timesd16;

/***daily baby aspirin, since 2000***/
array baby{*} baby00 baby02 baby04 baby06 baby08 baby10 baby12 baby14 baby16;
array daily{*} daily00 daily02 daily04 daily06 daily08 daily10 daily12 daily14 daily16;

/***NSAIDs array***/
/*any use of ibuprofen*/
array ibui{*} ibui86 ibui88 ibui90 ibui92 ibui94 ibui96 ibui98 ibui00 ibui02 ibui04 ibui06 ibui08 ibui10 ibui12 ibui14 ibui16;
array anyibu{*} regibui86 regibui88 regibui90 regibui92 regibui94 regibui96 regibui98 regibui00 regibui02 regibui04 regibui06 regibui08 regibui10 regibui12 regibui14 regibui16;

/*cumulative average of aspirin variables before carrying forward
  available from 1992*/

/*cumulative average of aspirin tabs/week, what Reiko and Andy used*/
/*this is problematic, for missing, previous values were carried forward*/
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
/*carry forward aspirin tabs/week one cycle*/
do i=1 to dim(aspwk);
     aspwkpre{i}=aspwk{i};
end;

do i=dim(aspwkpre) to 2 by -1;
     if aspwkpre{i} eq . and aspwkpre{i-1} ne . then aspwkpre{i}=aspwkpre{i-1};
end;

do i=2 to dim(sameaspwk);
     if samereguasp{i}=2 and sameaspwk{i}=. and sameaspwk{i-1}=0 then sameaspwkpre{i}=.;     /*changed*/
     if samereguasp{i}=1 and sameaspwk{i}=. and 0<sameaspwk{i-1} then sameaspwkpre{i}=.;     /*changed*/
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
end;
do i=2 to dim(sameaspwk);
     if samereguasp{i}=. and sameaspwk{i}=0 and samereguasp{i-1}=2 then sameregaspre{i}=.;   /*changed*/
end;

/*duration of regular aspirin use*/
/*1986*/
if aspi86>=2 then  do;
     adur8688=4; /*assume that the 1986 users have been using for at least 2 years at baseline*/     
end; 
else if .<aspi86<2 then do; 
     adur8688=0; 
end; 
else if aspi86=. then do; 
     adur8688=.; 
end;

/*1988-2008, if aspirin was regularly used, 2 years were added as the duration in the period*/
do i=2 to dim(adur);
     if reguasp{i}>=2 then adur{i}=2;  
     else if .<reguasp{i}<2 then adur{i}=0;  
     else if reguasp{i}=. then adur{i}=.; 
end;

/*fills in missing duration with prior questionnaire response*/    
do i=2 to dim(adurarray);
     if adurarray{i}=. then adurarray{i}=adurarray{i-1};
     else;
end;

regaspdur86=sum(adur8688);
regaspdur88=sum(adur8688,adur8890);
regaspdur90=sum(adur8688,adur8890,adur9092);
regaspdur92=sum(adur8688,adur8890,adur9092,adur9294);
regaspdur94=sum(adur8688,adur8890,adur9092,adur9294,adur9496); 
regaspdur96=sum(adur8688,adur8890,adur9092,adur9294,adur9496,adur9698);
regaspdur98=sum(adur8688,adur8890,adur9092,adur9294,adur9496,adur9698,adur9800);
regaspdur00=sum(adur8688,adur8890,adur9092,adur9294,adur9496,adur9698,adur9800,adur0002);
regaspdur02=sum(adur8688,adur8890,adur9092,adur9294,adur9496,adur9698,adur9800,adur0002,adur0204);
regaspdur04=sum(adur8688,adur8890,adur9092,adur9294,adur9496,adur9698,adur9800,adur0002,adur0204,adur0406);
regaspdur06=sum(adur8688,adur8890,adur9092,adur9294,adur9496,adur9698,adur9800,adur0002,adur0204,adur0406,adur0608);
regaspdur08=sum(adur8688,adur8890,adur9092,adur9294,adur9496,adur9698,adur9800,adur0002,adur0204,adur0406,adur0608,adur0810);
regaspdur10=sum(adur8688,adur8890,adur9092,adur9294,adur9496,adur9698,adur9800,adur0002,adur0204,adur0406,adur0608,adur0810,adur1012);
regaspdur12=sum(adur8688,adur8890,adur9092,adur9294,adur9496,adur9698,adur9800,adur0002,adur0204,adur0406,adur0608,adur0810,adur1012,adur1214);
regaspdur14=sum(adur8688,adur8890,adur9092,adur9294,adur9496,adur9698,adur9800,adur0002,adur0204,adur0406,adur0608,adur0810,adur1012,adur1214,adur1416);
regaspdur16=sum(adur8688,adur8890,adur9092,adur9294,adur9496,adur9698,adur9800,adur0002,adur0204,adur0406,adur0608,adur0810,adur1012,adur1214,adur1416,adur1618);

/*Any amount of aspirin is same as regular use of aspirin in HPFS*/
do i=1 to dim(anyasppre);
   anyasppre[i]=regaspre[i];
end;

/***redefine duration of any asp use since 1992 based on aspwk**/
/***what to do with 86 88 90==>6 years*****/
array aadur{*} aadur9294 aadur9496 aadur9698 aadur9800 aadur0002 aadur0204 aadur0406 aadur0608 aadur0810 aadur1012 aadur1214 aadur1416 aadur1618;
array aadurarray{*} aadur9294 aadur9496 aadur9698 aadur9800 aadur0002 aadur0204 aadur0406 aadur0608 aadur0810 aadur1012 aadur1214 aadur1416 aadur1618;

array aaspdur{*} aaspdur92 aaspdur94 aaspdur96 aaspdur98 aaspdur00 aaspdur02 aaspdur04 aaspdur06 aaspdur08 aaspdur10 aaspdur12 aaspdur14 aaspdur16;

/*1986*/
if aspwkpre92>0 then  do;
     aadur9294=regaspdur90+2;     
end; 
else if aspwkpre92=0 then do; 
     aadur9294=regaspdur90; 
end; 
else if aspwkpre92=. then do; 
     aadur9294=.; 
end;

/*1988-2008, if aspirin was used, 2 years were added as the duration in the period*/
do i=2 to dim(aadur);
     if aspwkpre{i}>0 then aadur{i}=2;
     else if aspwkpre{i}=0 then aadur{i}=0;
     else if aspwkpre{i}=. then aadur{i}=.;
end;

/*fills in missing duration with prior questionnaire response*/    
do i=2 to dim(aadurarray);
     if aadurarray{i}=. then aadurarray{i}=aadurarray{i-1};
     else;
end;


aaspdur92=sum(aadur9294);
aaspdur94=sum(aadur9294,aadur9496); 
aaspdur96=sum(aadur9294,aadur9496,aadur9698);
aaspdur98=sum(aadur9294,aadur9496,aadur9698,aadur9800);
aaspdur00=sum(aadur9294,aadur9496,aadur9698,aadur9800,aadur0002);
aaspdur02=sum(aadur9294,aadur9496,aadur9698,aadur9800,aadur0002,aadur0204);
aaspdur04=sum(aadur9294,aadur9496,aadur9698,aadur9800,aadur0002,aadur0204,aadur0406);
aaspdur06=sum(aadur9294,aadur9496,aadur9698,aadur9800,aadur0002,aadur0204,aadur0406,aadur0608);
aaspdur08=sum(aadur9294,aadur9496,aadur9698,aadur9800,aadur0002,aadur0204,aadur0406,aadur0608,aadur0810);
aaspdur10=sum(aadur9294,aadur9496,aadur9698,aadur9800,aadur0002,aadur0204,aadur0406,aadur0608,aadur0810,aadur1012);
aaspdur12=sum(aadur9294,aadur9496,aadur9698,aadur9800,aadur0002,aadur0204,aadur0406,aadur0608,aadur0810,aadur1012,aadur1214);
aaspdur14=sum(aadur9294,aadur9496,aadur9698,aadur9800,aadur0002,aadur0204,aadur0406,aadur0608,aadur0810,aadur1012,aadur1214,aadur1416);
aaspdur16=sum(aadur9294,aadur9496,aadur9698,aadur9800,aadur0002,aadur0204,aadur0406,aadur0608,aadur0810,aadur1012,aadur1214,aadur1416,aadur1618);

/*Any amount of aspirin is same as regular use of aspirin in HPFS*/
do i=1 to dim(anyasppre);
   anyasppre[i]=regaspre[i];
end;

/*Create tablet/week-years*/
do i=1 to dim(tabwy); *tabs/week before 1992 is unknown*;
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

/*****time since discontinuation**********/
do i=1 to dim(tsd);
if reguasp{i}>=2 then tsd{i}=5; /*current, lowest risk*/
else if regaspdur{i}=0 then tsd{i}=1; /*never, highest risk, reference*/
else if .<reguasp{i}<2 then do;
     tsd{i}=.;
     if i=2 then do; if reguasp{i-1}>=2 then tsd{i}=4; end;
     if i=3 then do; if reguasp{i-1}>=2 then tsd{i}=4;   /*<4 yr*/  
                          else if .<reguasp{i-1}<2 and reguasp{i-2}>=2 then tsd{i}=4;  /*<4 yr*/ 
                          end; 
     if i=4 then do; if reguasp{i-1}>=2 then tsd{i}=4;   /*<4 yr*/  
                          else if .<reguasp{i-1}<2 and reguasp{i-2}>=2  then tsd{i}=4;  /*<4 yr*/ 
                          else if .<reguasp{i-1}<2 and .<reguasp{i-2}<2 and reguasp{i-3}>=2 then tsd{i}=3;
                          end; 

     if i>4 then do; if reguasp{i-1}>=2 then tsd{i}=4;   /*<4 yr*/  
                          else if .<reguasp{i-1}<2 and reguasp{i-2}>=2 then tsd{i}=4;  /*<4 yr*/    
                          else if .<reguasp{i-1}<2 and .<reguasp{i-2}<2 and reguasp{i-3}>=2 then tsd{i}=3;  /*4-5.9*/
                          else if .<reguasp{i-1}<2 and .<reguasp{i-2}<2 and .<reguasp{i-3}<2 then do;
                          do j=i-4 to 1 by -1;
                          if reguasp{j}>=2 then tsd{i}=2;  /*6+, more than 3 cycle non-users*/ 
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


/*************daily baby aspirin, since 2000**************/
/*Carry forward one cycle*/ 
do i=1 to dim(baby);
 daily{i}=baby{i};
end;

do i=dim(daily) to 2 by -1;
 if daily{i} eq . and daily{i-1} ne . then daily{i}=daily{i-1};
end;

/*******baseline baby, baby00, per Andy********/

 
/*******consecutive baby, 2 QQ, since 04********/

/***00,02, analysis started from 02*/
if baby00=1 and baby02=1 then baby202=1;
else if baby00=3 and baby02=3 then baby202=3; /*consecutive daily baby user*/
else if baby00=4 and baby02=4 then baby202=4; /*consecutive daily adult*/
else if baby00=2 and baby02=2 then baby202=2; /*consecutive infrequent user*/

/***00,02,04, analysis started from 04*/
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

 
data hpfs_asp;
 set hpaspone;
     keep id regaspre:  regibui:
    /* aspi:
     anyasppre: 
     aspwk:
     aspwkpre: 
     avaspwkpre: 
     avaspwkpren:
     regaspdur: 
     aaspdur:
     tabwy: cumtabwy:
     tsd:
     timesd:
     baby: daily:
     baby00 baby202 baby304 
     aspds00 aspds02 aspds04 aspds06 */
;
run;
 
proc datasets nolist;
delete hp86 hp88 hp90 hp92 hp94 hp96 hp98 hp00 hp02 hp04 hp06 hp08 hp10 hp12 hp14 hp16 hpaspone;
run;

/*
proc means n nmiss mean data=hpfs_asp;
var regaspre86 regaspre88 regaspre90 regaspre92 regaspre94 regaspre96 regaspre98 regaspre00 regaspre02 regaspre04 regaspre06 regaspre08 regaspre10 regaspre12 regaspre14 regaspre16
    regibui86 regibui88 regibui90 regibui92 regibui94 regibui96 regibui98 regibui00 regibui02 regibui04 regibui06 regibui08 regibui10 regibui12 regibui14 regibui16
;
run;

The MEANS Procedure

                           N
Variable          N     Miss            Mean
--------------------------------------------
regaspre86    51530        0       1.2945081
regaspre88    51530        0       1.3803415
regaspre90    44731     6799       1.3374617
regaspre92    44552     6978       1.4428308
regaspre94    43491     8039       1.4734083
regaspre96    41382    10148       1.5099560
regaspre98    40148    11382       1.5681728
regaspre00    38847    12683       1.5416892
regaspre02    37065    14465       1.5554566
regaspre04    35301    16229       1.5867539
regaspre06    33406    18124       1.5942944
regaspre08    30942    20588       1.6195786
regaspre10    28767    22763       1.5916154
regaspre12    27055    24475       1.5654777
regaspre14    24906    26624       1.2040472
regaspre16    22949    28581       1.1465859
regibui86     51530        0       1.0559480
regibui88     51530        0       1.0919853
regibui90     44731     6799       1.0985893
regibui92     44552     6978       1.1018809
regibui94     43491     8039       1.1271298
regibui96     41382    10148       1.1343821
regibui98     40256    11274       1.1774394
regibui00     38988    12542       1.2451011
regibui02     37065    14465       1.2237960
regibui04     35301    16229       1.2243846
regibui06     33406    18124       1.2430102
regibui08     30942    20588       1.2452977
regibui10     28767    22763       1.2467411
regibui12     27055    24475       1.2517464
regibui14     24906    26624       1.2575283
regibui16     22949    28581       1.2940433
--------------------------------------------
*/
