/* This program was developed by the coauthor Peilu Wang and used in her project 
'Optimal dietary patterns for prevention of chronic disease' published on Nature Medicine. */
*--- Goal: derive variables for aspirin and nsaids in NHSII 1989 - 2017
*--- update: 10/20/2021
*--- dir: /udd/n2pwa/proj_data/others
*--- ref: /udd/nhyyu/dietpattern/primary/diet_early_crc/nhs2asp.sas
        Change: update from 2011 to 2017
*--- incl: %nur89 - %nur17
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

%nur89(keep=id asp89 aspi89 ibu89 ibui89 tyl89 tyli89);
        * asp89: current use of aspirin 2+ times/week 1=yes ;
        aspi89=1;if asp89=1 then aspi89=2;      * 2=current users, 1=never users *;
        ibui89=1;if ibu89=1 then ibui89=2;      * 2=current users, 1=never users *;
        tyli89=1;if tyl89=1 then tyli89=2;      * 2=current users, 1=never users *;
run;

* not assessed in 1991 *;

%nur93(keep=id batch93 asp93 aspd93 aspi93 ibu93 ibui93 tyl93 tyli93);
        aspi93=1;
        if asp93=1 or aspd93 in (3,4) then aspi93=2; * 3-7 days/wk ;
        ibui93=1;if ibu93=1 then ibui93=2;
        tyli93=1;if tyl93=1 then tyli93=2;

        * code those passthrough who answered short qx as missing *;
        if batch93 not in (001:768) then do; 
        aspi93=.;
        ibui93=.;
        tyli93=.;
        end;
run;

%nur95(keep=id batch95 aspd95 aspi95 ibud95 ibui95 tyld95 tyli95);
        asptemp=aspd95;
        ibutemp=ibud95;
        tyltemp=tyld95;
          
        aspd95=0;
        if asptemp=2 then aspd95=1;
        else if asptemp=3 then aspd95=2;
        else if asptemp=4 then aspd95=3;
        else if asptemp=5 then aspd95=4;
        else if asptemp=6 then aspd95=5;

        ibud95=0;
        if ibutemp=2 then ibud95=1;
        else if ibutemp=3 then ibud95=2;
        else if ibutemp=4 then ibud95=3;
        else if ibutemp=5 then ibud95=4;
        else if ibutemp=6 then ibud95=5;

        tyld95=0;
        if tyltemp=2 then tyld95=1;
        else if tyltemp=3 then tyld95=2;
        else if tyltemp=4 then tyld95=3;
        else if tyltemp=5 then tyld95=4;
        else if tyltemp=6 then tyld95=5;
        aspi95=1;
        if aspd95 in (2,3,4) then aspi95=2;
        ibui95=1;
        if ibud95 in (2,3,4) then ibui95=2;
        tyli95=1;
        if tyld95 in (2,3,4) then tyli95=2;

        if batch95 not in (1:799, 900:999) then do;
        aspi95=.;
        ibui95=.;
        tyli95=.;
        aspd95=.;
        ibud95=.;
        tyld95=.;
        end;
run;

%nur97(keep=id batch97 asp97 aspd97 aspi97 ibu97 ibud97 ibui97  tyl97 tyld97 tyli97);
        if aspd97 not in (1,2,3,4) then aspd97=0; 
        if ibud97 not in (1,2,3,4) then ibud97=0;
        if tyld97 not in (1,2,3,4) then tyld97=0;

        aspi97=1;if asp97 eq 1 or aspd97 in (2,3,4) then aspi97=2; * >=2 days/wk ;
        
        ibui97=1; 
        if ibu97 eq 1 or ibud97 in (2,3,4) then ibui97=2;
        if ibu97 eq 1 and ibud97 eq 1 then ibui97=1;
        
        tyli97=1;        
        if tyl97 eq 1 or tyld97 in (2,3,4) then tyli97=2;
        if tyl97 eq 1 and tyld97 eq 1 then tyli97=1;

        if batch97 not in (1:768) then do;
                aspi97=.;
                ibui97=.;
                tyli97=.;
                aspd97=.;
                ibud97=.;
                tyld97=.;
        end;    
run;

* 1999: start assessing dose *;
%nur99(keep=id q99 asp99 aspd99 nasp99 aspi99 ibu99 ibud99 nibu99 oanlg99 ibui99 aspwk99
	tyl99 tyld99 ntyl99 tyli99);

        if aspd99 not in (1,2,3,4) then aspd99=0;
        if ibud99 not in (1,2,3,4) then ibud99=0;
        if tyld99 not in (1,2,3,4) then tyld99=0;
        if nasp99 not in (1,2,3,4) then nasp99=0;
        if nibu99 not in (1,2,3,4) then nibu99=0;
        if ntyl99 not in (1,2,3,4) then ntyl99=0;

        if aspd99 in (1,2,3,4) and nasp99=0 then nasp99=.;
        if nasp99 in (1,2,3,4) and aspd99=0 then aspd99=.;
        if ibud99 in (1,2,3,4) and nibu99=0 then nibu99=.; 
        if nibu99 in (1,2,3,4) and ibud99=0 then ibud99=.;
        if tyld99 in (1,2,3,4) and ntyl99=0 then ntyl99=.; 
        if ntyl99 in (1,2,3,4) and tyld99=0 then tyld99=.;

        aspi99=1;
        if asp99 eq 1 or aspd99 in (2,3,4) then aspi99=2; 

        ibui99=1;
        if ibu99 eq 1 or oanlg99 eq 1 or ibud99 in (2,3,4) then ibui99=2; 
        if ibu99 eq 1 and ibud99 eq 1 then ibui99=1;

        tyli99=1;
        if tyl99 eq 1 or tyld99 in (2,3,4) then tyli99=2; 
        if tyl99 eq 1 and tyld99 eq 1 then tyli99=1;

        if nasp99=0 then naspx=0; * assign median for cumulative average ;
        else if nasp99=1 then naspx=1.5;
        else if nasp99=2 then naspx=4;
        else if nasp99=3 then naspx=10;
        else if nasp99=4 then naspx=20;

        aspwk99 = naspx; 

        if q99 not in (1,2) then do;
                aspi99=.;
                ibui99=.;
                tyli99=.;
                aspd99=.;
                ibud99=.;
                tyld99=.;
                nasp99=.;
                nibu99=.;
                ntyl99=.;
        end;
run;

* 2001: start assessing baby aspirin *;
%nur01(keep=id q01 bab01 babd01 nbab01 asp01 aspd01 nasp01 aspi01 aspwk01 ibu01 ibud01 nibu01 ibut01 ibui01
	    tyl01 tyld01 ntyl01 tyli01 celeb01 celei01 toti01 totd01 ntot01);


        if aspd01 not in (1,2,3,4) then aspd01=0;   
        if ibud01 not in (1,2,3,4) then ibud01=0;
        if tyld01 not in (1,2,3,4) then tyld01=0;
        if nasp01 not in (1,2,3,4) then nasp01=0;
        if nibu01 not in (1,2,3,4) then nibu01=0;
        if ntyl01 not in (1,2,3,4) then ntyl01=0;
        if nbab01 not in (1,2,3,4) then nbab01=0;   
        if babd01 not in (1,2,3,4) then babd01=0;

        totd01=aspd01; * baby to supplement aspd ;
        if babd01>aspd01 and babd01 in (1,2,3,4) then totd01=babd01; 
        * convert baby aspirin dose to regular aspirin (baby/4=asp)
                1-2 --> 1.5/4= 0.4 tablets/wk
                3-5 --> 4/4= 1.0 tablet/wk
                6-14 --> 10/4= 2.5 tablet/wk
                15+ --> 20/4= 5.0 tablet/wk (based on Huang HPFS) ;

        if nasp01=0 then naspx=0;
        else if nasp01=1 then naspx=1.5;
        else if nasp01=2 then naspx=4;
        else if nasp01=3 then naspx=10;
        else if nasp01=4 then naspx=20;

        if nbab01=0 then naspxx=0;
        else if nbab01=1 then naspxx=0.4;
        else if nbab01=2 then naspxx=1;
        else if nbab01=3 then naspxx=2.5;
        else if nbab01=4 then naspxx=5;

        /*
                For NHS, HPFS
                if tabcum=0 then tabcumgrp=1;
                else if 0<tabcum<2 then tabcumgrp=2;
                else if 2<=tabcum<=5 then tabcumgrp=3;
                else if 5<tabcum<=14 then tabcumgrp=4;
                else if tabcum>14 then tabcumgrp=5;
                else tabcumgrp=.;

                %indic3(vbl=tabcumgrp,prefix=tabcumgrp,min=2,max=5,reflev=1,usemiss=0,
                label1='0 tablets per wk',
                label2='0.5-1.5 tabs per wk',
                label3='2-5 tabs per wk',
                label4='6-14 tabs per wk',
                label5='>14 tabs per wk');
        */

        aspwk01=naspx+naspxx;
        
        if aspd01 in (1,2,3,4) and nasp01=0 then nasp01=.;
        if nasp01 in (1,2,3,4) and aspd01=0 then aspd01=.;
        if ibud01 in (1,2,3,4) and nibu01=0 then nibu01=.;
        if nibu01 in (1,2,3,4) and ibud01=0 then ibud01=.;
        if tyld01 in (1,2,3,4) and ntyl01=0 then ntyl01=.;
        if ntyl01 in (1,2,3,4) and tyld01=0 then tyld01=.;
        if totd01 in (1,2,3,4) and ntot01=0 then ntot01=.;
        if ntot01 in (1,2,3,4) and totd01=0 then totd01=.;

        aspi01=1;
        if asp01 eq 1 or aspd01 in (2,3,4) then aspi01=2; 
        
        toti01=1;
        if asp01 eq 1 or bab01 eq 1 or totd01 in (2,3,4) then toti01=2; * >= 2 d/wk, including baby ;
        if asp01 eq 1 and totd01 eq 1 then toti01=1;
        if bab01 eq 1 and totd01 eq 1 then toti01=1;
                
        ibui01=1;
        if ibu01 eq 1 or ibut01 eq 1 or ibud01 in (2,3,4) then ibui01=2;
        if ibu01 eq 1 and ibud01 eq 1 then ibui01=1;

        tyli01=1;
        if tyl01 eq 1 or tyld01 in (2,3,4) then tyli01=2;
        if tyl01 eq 1 and tyld01 eq 1 then tyli01=1;

        celei01=1;
        if celeb01=1 then celei01=2;

        if q01 not in (1,3) then do;
                aspi01=.;
                ibui01=.;
                tyli01=.;
                celei01=.;
                aspd01=.;
                ibud01=.;
                tyld01=.;
                nasp01=.;
                nibu01=.;
                ntyl01=.;
                toti01=.;
                totd01=.;
                ntot01=.;
        end;
run;


%nur03(keep=id q03 bab03 babd03 nbab03 asp03 aspd03 nasp03 aspi03 aspwk03 ibu03 ibud03 nibu03 ibut03 ibui03 
        tyl03 tyld03 ntyl03 tyli03 celeb03 celed03 celei03 toti03 totd03 ntot03);

        if aspd03 not in (1,2,3,4) then aspd03=0;
        if ibud03 not in (1,2,3,4) then ibud03=0;
        if tyld03 not in (1,2,3,4) then tyld03=0;
        if nasp03 not in (1,2,3,4) then nasp03=0;
        if nibu03 not in (1,2,3,4) then nibu03=0;
        if ntyl03 not in (1,2,3,4) then ntyl03=0;
        if nbab03 not in (1,2,3,4) then nbab03=0;
        if babd03 not in (1,2,3,4) then babd03=0;

        totd03=aspd03;
        if babd03>aspd03 and babd03 in (1,2,3,4) then totd03=babd03;

        if nasp03=0 then naspx=0;
        else if nasp03=1 then naspx=1.5;
        else if nasp03=2 then naspx=4;
        else if nasp03=3 then naspx=10;
        else if nasp03=4 then naspx=20;

        if nbab03=0 then naspxx=0;
        else if nbab03=1 then naspxx=0.4;
        else if nbab03=2 then naspxx=1;
        else if nbab03=3 then naspxx=2.5;
        else if nbab03=4 then naspxx=5;

        aspwk03=naspx+naspxx;

        if aspd03 in (1,2,3,4) and nasp03=0 then nasp03=.;
        if nasp03 in (1,2,3,4) and aspd03=0 then aspd03=.;
        if ibud03 in (1,2,3,4) and nibu03=0 then nibu03=.;
        if nibu03 in (1,2,3,4) and ibud03=0 then ibud03=.;
        if tyld03 in (1,2,3,4) and ntyl03=0 then ntyl03=.;
        if ntyl03 in (1,2,3,4) and tyld03=0 then tyld03=.;
        if totd03 in (1,2,3,4) and ntot03=0 then ntot03=.;
        if ntot03 in (1,2,3,4) and totd03=0 then totd03=.;

        aspi03=1;
        if asp03 eq 1 or aspd03 in (2,3,4) then aspi03=2; 
        
        toti03=1;
        if asp03 eq 1 or bab03 eq 1 or totd03 in (2,3,4) then toti03=2; 
        if asp03 eq 1 and totd03 eq 1 then toti03=1;
        if bab03 eq 1 and totd03 eq 1 then toti03=1;

        ibui03=1;
        if ibu03 eq 1 or ibut03 eq 1 or ibud03 in (2,3,4) then ibui03=2;
        if ibu03 eq 1 and ibud03 eq 1 then ibui03=1;

        tyli03=1;
        if tyl03 eq 1 or tyld03 in (2,3,4) then tyli03=2;
        if tyl03 eq 1 and tyld03 eq 1 then tyli03=1;

        celei03=1;
        if celeb03 eq 1 or celed03 in (2,3,4) then celei03=2;
        if celeb03 eq 1 and celed03 eq 1 then celei03=1;

        if q03 not in (1,2,3,4) then do;
                aspi03=.;
                ibui03=.;
                tyli03=.;
                celei03=.;
                aspd03=.;
                ibud03=.;
                tyld03=.;
                nasp03=.;
                nibu03=.;
                ntyl03=.;
                toti03=.;
                totd03=.;
                ntot03=.;
        end;
run;

%nur05(keep=id q05 bab05 babd05 nbab05 asp05 aspd05 nasp05 aspi05 aspwk05 ibu05 ibud05 nibu05 ibut05 ibui05
	tyl05 tyld05 ntyl05 tyli05 celeb05 celed05 celei05 toti05 totd05 ntot05);

        if aspd05 not in (1,2,3,4) then aspd05=0;
        if ibud05 not in (1,2,3,4) then ibud05=0;
        if tyld05 not in (1,2,3,4) then tyld05=0;
        if nasp05 not in (1,2,3,4) then nasp05=0;
        if nibu05 not in (1,2,3,4) then nibu05=0;
        if ntyl05 not in (1,2,3,4) then ntyl05=0;
        if nbab05 not in (1,2,3,4) then nbab05=0;
        if babd05 not in (1,2,3,4) then babd05=0;

        totd05=aspd05;
        if babd05>aspd05 and babd05 in (1,2,3,4) ne 5 then totd05=babd05;

        if nasp05=0 then naspx=0;
        else if nasp05=1 then naspx=1.5;
        else if nasp05=2 then naspx=4;
        else if nasp05=3 then naspx=10;
        else if nasp05=4 then naspx=20;

        if nbab05=0 then naspxx=0;
        else if nbab05=1 then naspxx=0.4;
        else if nbab05=2 then naspxx=1;
        else if nbab05=3 then naspxx=2.5;
        else if nbab05=4 then naspxx=5;

        aspwk05=naspx+naspxx;

        if aspd05 in (1,2,3,4) and nasp05=0 then nasp05=.;
        if nasp05 in (1,2,3,4) and aspd05=0 then aspd05=.;
        if ibud05 in (1,2,3,4) and nibu05=0 then nibu05=.;
        if nibu05 in (1,2,3,4) and ibud05=0 then ibud05=.;
        if tyld05 in (1,2,3,4) and ntyl05=0 then ntyl05=.;
        if ntyl05 in (1,2,3,4) and tyld05=0 then tyld05=.;
        if totd05 in (1,2,3,4) and ntot05=0 then ntot05=.;
        if ntot05 in (1,2,3,4) and totd05=0 then totd05=.;

        aspi05=1;
        if asp05 eq 1 or aspd05 in (2,3,4) then aspi05=2;

        toti05=1;
        if asp05 eq 1 or bab05 eq 1 or totd05 in (2,3,4) then toti05=2;
        if asp05 eq 1 and totd05 eq 1 then toti05=1;
        if bab05 eq 1 and totd05 eq 1 then toti05=1;

        ibui05=1;
        if ibu05 eq 1 or ibut05 eq 1 or ibud05 in (2,3,4) then ibui05=2;
        if ibu05 eq 1 and ibud05 eq 1 then ibui05=1;

        tyli05=1;
        if tyl05 eq 1 or tyld05 in (2,3,4) then tyli05=2;
        if tyl05 eq 1 and tyld05 eq 1 then tyli05=1;

        celei05=1;
        if celeb05 eq 1 or celed05 in (2,3,4) then celei05=2;
        if celeb05 eq 1 and celed05 eq 1 then celei05=1;

        if q05 not in (1,2) then do;
                aspi05=.;
                ibui05=.;
                tyli05=.;
                celei05=.;
                aspd05=.;
                ibud05=.;
                tyld05=.;
                nasp05=.;
                nibu05=.;
                ntyl05=.;
                toti05=.;
                totd05=.;
                ntot05=.;
        end;
run;

%nur07(keep=id q07 bab07 babd07 nbab07 asp07 aspd07 nasp07 aspi07 aspwk07 ibu07 ibud07 nibu07 ibut07 ibui07
	tyl07 tyld07 ntyl07 tyli07 celeb07 celed07 celei07 toti07 totd07 ntot07);

        if aspd07 not in (1,2,3,4) then aspd07=0;
        if ibud07 not in (1,2,3,4) then ibud07=0;
        if tyld07 not in (1,2,3,4) then tyld07=0;
        if nasp07 not in (1,2,3,4) then nasp07=0;
        if nibu07 not in (1,2,3,4) then nibu07=0;
        if ntyl07 not in (1,2,3,4) then ntyl07=0;
        if nbab07 not in (1,2,3,4) then nbab07=0;
        if babd07 not in (1,2,3,4) then babd07=0;

        totd07=aspd07;
        if babd07>aspd07 and babd07 in (1,2,3,4) then totd07=babd07;

        if nasp07=0 then naspx=0;
        else if nasp07=1 then naspx=1.5;
        else if nasp07=2 then naspx=4;
        else if nasp07=3 then naspx=10;
        else if nasp07=4 then naspx=20;

        if nbab07=0 then naspxx=0;
        else if nbab07=1 then naspxx=0.4;
        else if nbab07=2 then naspxx=1;
        else if nbab07=3 then naspxx=2.5;
        else if nbab07=4 then naspxx=5;

        aspwk07=naspx+naspxx;
        
        if aspd07 in (1,2,3,4) and nasp07=0 then nasp07=.;
        if nasp07 in (1,2,3,4) and aspd07=0 then aspd07=.;
        if ibud07 in (1,2,3,4) and nibu07=0 then nibu07=.;
        if nibu07 in (1,2,3,4) and ibud07=0 then ibud07=.;
        if tyld07 in (1,2,3,4) and ntyl07=0 then ntyl07=.;
        if ntyl07 in (1,2,3,4) and tyld07=0 then tyld07=.;
        if totd07 in (1,2,3,4) and ntot07=0 then ntot07=.;
        if ntot07 in (1,2,3,4) and totd07=0 then totd07=.;

        aspi07=1;
        if asp07 eq 1 or aspd07 in (2,3,4) then aspi07=2;
        if asp07 eq 1 and aspd07 eq 1 then aspi07=1;

        toti07=1;
        if asp07 eq 1 or bab07 eq 1 or totd07 in (2,3,4) then toti07=2;
        if asp07 eq 1 and totd07 eq 1 then toti07=1;
        if bab07 eq 1 and totd07 eq 1 then toti07=1;

        ibui07=1;
        if ibu07 eq 1 or ibut07 eq 1 or ibud07 in (2,3,4) then ibui07=2;
        if ibu07 eq 1 and ibud07 eq 1 then ibui07=1;

        tyli07=1;
        if tyl07 eq 1 or tyld07 in (2,3,4) then tyli07=2;
        if tyl07 eq 1 and tyld07 eq 1 then tyli07=1;

        celei07=1;
        if celeb07 eq 1 or celed07 in (2,3,4) then celei07=2;
        if celeb07 eq 1 and celed07 eq 1 then celei07=1;

        if q07 not in (1,2,3) then do;
                aspi07=.;
                ibui07=.;
                tyli07=.;
                celei07=.;
                aspd07=.;
                ibud07=.;
                tyld07=.;
                nasp07=.;
                nibu07=.;
                ntyl07=.;
                toti07=.;
                totd07=.;
                ntot07=.;
        end;

run;

%nur09(keep=id q09 bab09 babd09 nbab09 asp09 aspd09 nasp09 aspi09 aspwk09 ibu09 ibud09 nibu09 ibut09 ibui09
	tyl09 tyld09 ntyl09 tyli09 celeb09 celed09 celei09 toti09 totd09 ntot09);

        if aspd09 not in (1,2,3,4) then aspd09=0;
        if ibud09 not in (1,2,3,4) then ibud09=0;
        if tyld09 not in (1,2,3,4) then tyld09=0;
        if nasp09 not in (1,2,3,4) then nasp09=0;
        if nibu09 not in (1,2,3,4) then nibu09=0;
        if ntyl09 not in (1,2,3,4) then ntyl09=0;
        if nbab09 not in (1,2,3,4) then nbab09=0;
        if babd09 not in (1,2,3,4) then babd09=0;

        totd09=aspd09;
        if babd09>aspd09 and babd09 in (1,2,3,4) then totd09=babd09;

        if nasp09=0 then naspx=0;
        else if nasp09=1 then naspx=1.5;
        else if nasp09=2 then naspx=4;
        else if nasp09=3 then naspx=10;
        else if nasp09=4 then naspx=20;

        if nbab09=0 then naspxx=0;
        else if nbab09=1 then naspxx=0.4;
        else if nbab09=2 then naspxx=1;
        else if nbab09=3 then naspxx=2.5;
        else if nbab09=4 then naspxx=5;

        aspwk09=naspx+naspxx;

        if aspd09 in (1,2,3,4) and nasp09=0 then nasp09=.;
        if nasp09 in (1,2,3,4) and aspd09=0 then aspd09=.;
        if ibud09 in (1,2,3,4) and nibu09=0 then nibu09=.;
        if nibu09 in (1,2,3,4) and ibud09=0 then ibud09=.;
        if tyld09 in (1,2,3,4) and ntyl09=0 then ntyl09=.;
        if ntyl09 in (1,2,3,4) and tyld09=0 then tyld09=.;
        if totd09 in (1,2,3,4) and ntot09=0 then ntot09=.;
        if ntot09 in (1,2,3,4) and totd09=0 then totd09=.;

        aspi09=1;
        if asp09 eq 2 or aspd09 in (2,3,4) then aspi09=2; 
        
        toti09=1;
        if asp09 eq 2 or bab09 eq 2 or totd09 in (2,3,4) then toti09=2;
        if asp09 eq 2 and totd09 eq 1 then toti09=1;
        if bab09 eq 2 and totd09 eq 1 then toti09=1;

        ibui09=1;
        if ibu09 eq 2 or ibut09 eq 1 or ibud09 in (2,3,4) then ibui09=2;
        if ibu09 eq 2 and ibud09 eq 1 then ibui09=1;

        tyli09=1;
        if tyl09 eq 2 or tyld09 in (2,3,4) then tyli09=2;
        if tyl09 eq 2 and tyld09 eq 1 then tyli09=1;

        celei09=1;
        if celeb09 eq 2 or celed09 in (2,3,4) then celei09=2;
        if celeb09 eq 2 and celed09 eq 1 then celei09=1;

        if q09 not in (1,3) then do;
                aspi09=.;
                ibui09=.;
                tyli09=.;
                celei09=.;
                aspd09=.;
                ibud09=.;
                tyld09=.;
                nasp09=.;
                nibu09=.;
                ntyl09=.;
                toti09=.;
                totd09=.;
                ntot09=.;
        end;

run;

%nur11(keep=id q11 bab11 babd11 nbab11 asp11 aspd11 nasp11 aspi11 aspwk11 ibu11 ibud11 nibu11 ibut11 ibui11
	tyl11 tyld11 ntyl11 tyli11 celeb11 celed11 celei11 toti11 totd11 ntot11);

* aspirin binary variable coding was switched ;
        if aspd11 not in (1,2,3,4) then aspd11=0;
        if ibud11 not in (1,2,3,4) then ibud11=0;
        if tyld11 not in (1,2,3,4) then tyld11=0;
        if nasp11 not in (1,2,3,4) then nasp11=0;
        if nibu11 not in (1,2,3,4) then nibu11=0;
        if ntyl11 not in (1,2,3,4) then ntyl11=0;
        if nbab11 not in (1,2,3,4) then nbab11=0;
        if babd11 not in (1,2,3,4) then babd11=0;

        totd11=aspd11;
        if babd11>aspd11 and babd11 in (1,2,3,4) then totd11=babd11;

        if nasp11=0 then naspx=0;
        else if nasp11=1 then naspx=1.5;
        else if nasp11=2 then naspx=4;
        else if nasp11=3 then naspx=10;
        else if nasp11=4 then naspx=20;

        if nbab11=0 then naspxx=0;
        else if nbab11=1 then naspxx=0.4;
        else if nbab11=2 then naspxx=1;
        else if nbab11=3 then naspxx=2.5;
        else if nbab11=4 then naspxx=5;

        aspwk11=naspx+naspxx;

        if aspd11 in (1,2,3,4) and nasp11=0 then nasp11=.;
        if nasp11 in (1,2,3,4) and aspd11=0 then aspd11=.;
        if ibud11 in (1,2,3,4) and nibu11=0 then nibu11=.;
        if nibu11 in (1,2,3,4) and ibud11=0 then ibud11=.;
        if tyld11 in (1,2,3,4) and ntyl11=0 then ntyl11=.;
        if ntyl11 in (1,2,3,4) and tyld11=0 then tyld11=.;
        if totd11 in (1,2,3,4) and ntot11=0 then ntot11=.;
        if ntot11 in (1,2,3,4) and totd11=0 then totd11=.;

        aspi11=1;
        if asp11 eq 2 or aspd11 in (2,3,4) then aspi11=2; 
        

        toti11=1;
        if asp11 eq 2 or bab11 eq 2 or totd11 in (2,3,4) then toti11=2;
        if asp11 eq 2 and totd11 eq 1 then toti11=1;
        if bab11 eq 2 and totd11 eq 1 then toti11=1;

        ibui11=1;
        if ibu11 eq 2 or ibut11 eq 1 or ibud11 in (2,3,4) then ibui11=2;
        if ibu11 eq 2 and ibud11 eq 1 then ibui11=1;

        tyli11=1;
        if tyl11 eq 2 or tyld11 in (2,3,4) then tyli11=2;
        if tyl11 eq 2 and tyld11 eq 1 then tyli11=1;

        celei11=1;
        if celeb11 eq 2 or celed11 in (2,3,4) then celei11=2;
        if celeb11 eq 2 and celed11 eq 1 then celei11=1;

        if q11 not in (1,2,3,4) then do;
        aspi11=.;
        ibui11=.;
        tyli11=.;
        celei11=.;
        aspd11=.;
        ibud11=.;
        tyld11=.;
        nasp11=.;
        nibu11=.;
        ntyl11=.;
        toti11=.;
        totd11=.;
        ntot11=.;
        end;
run;

%nur13(keep=id q13 bab13 babd13 nbab13 asp13 aspd13 nasp13 aspi13 aspwk13 ibu13 ibud13 nibu13 ibut13 ibui13
	tyl13 tyld13 ntyl13 tyli13 celeb13 celed13 celei13 toti13 totd13 ntot13);

        if aspd13 not in (1,2,3,4) then aspd13=0;
        if ibud13 not in (1,2,3,4) then ibud13=0;
        if tyld13 not in (1,2,3,4) then tyld13=0;
        if nasp13 not in (1,2,3,4) then nasp13=0;
        if nibu13 not in (1,2,3,4) then nibu13=0;
        if ntyl13 not in (1,2,3,4) then ntyl13=0;
        if nbab13 not in (1,2,3,4) then nbab13=0;
        if babd13 not in (1,2,3,4) then babd13=0;

        totd13=aspd13;
        if babd13>aspd13 and babd13 in (1,2,3,4) then totd13=babd13;

        if nasp13=0 then naspx=0;
        else if nasp13=1 then naspx=1.5;
        else if nasp13=2 then naspx=4;
        else if nasp13=3 then naspx=10;
        else if nasp13=4 then naspx=20;

        if nbab13=0 then naspxx=0;
        else if nbab13=1 then naspxx=0.4;
        else if nbab13=2 then naspxx=1;
        else if nbab13=3 then naspxx=2.5;
        else if nbab13=4 then naspxx=5;

        aspwk13=naspx+naspxx;

        if aspd13 in (1,2,3,4) and nasp13=0 then nasp13=.;
        if nasp13 in (1,2,3,4) and aspd13=0 then aspd13=.;
        if ibud13 in (1,2,3,4) and nibu13=0 then nibu13=.;
        if nibu13 in (1,2,3,4) and ibud13=0 then ibud13=.;
        if tyld13 in (1,2,3,4) and ntyl13=0 then ntyl13=.;
        if ntyl13 in (1,2,3,4) and tyld13=0 then tyld13=.;
        if totd13 in (1,2,3,4) and ntot13=0 then ntot13=.;
        if ntot13 in (1,2,3,4) and totd13=0 then totd13=.;

        aspi13=1;
        if asp13 eq 2 or aspd13 in (2,3,4) then aspi13=2; 
        

        toti13=1;
        if asp13 eq 2 or bab13 eq 2 or totd13 in (2,3,4) then toti13=2;
        if asp13 eq 2 and totd13 eq 1 then toti13=1;
        if bab13 eq 2 and totd13 eq 1 then toti13=1;

        ibui13=1;
        if ibu13 eq 2 or ibut13 eq 1 or ibud13 in (2,3,4) then ibui13=2;
        if ibu13 eq 2 and ibud13 eq 1 then ibui13=1;

        tyli13=1;
        if tyl13 eq 2 or tyld13 in (2,3,4) then tyli13=2;
        if tyl13 eq 2 and tyld13 eq 1 then tyli13=1;

        celei13=1;
        if celeb13 eq 2 or celed13 in (2,3,4) then celei13=2;
        if celeb13 eq 2 and celed13 eq 1 then celei13=1;

        if q13 not in (1,2,3) then do;
                aspi13=.;
                ibui13=.;
                tyli13=.;
                celei13=.;
                aspd13=.;
                ibud13=.;
                tyld13=.;
                nasp13=.;
                nibu13=.;
                ntyl13=.;
                toti13=.;
                totd13=.;
                ntot13=.;
        end;
run;

%nur15(keep=id q15 bab15 babd15 nbab15 asp15 aspd15 nasp15 aspi15 aspwk15 ibu15 ibud15 nibu15 ibut15 ibui15
	tyl15 tyld15 ntyl15 tyli15 celeb15 celed15 celei15 toti15 totd15 ntot15);

        if aspd15 not in (1,2,3,4) then aspd15=0;
        if ibud15 not in (1,2,3,4) then ibud15=0;
        if tyld15 not in (1,2,3,4) then tyld15=0;
        if nasp15 not in (1,2,3,4) then nasp15=0;
        if nibu15 not in (1,2,3,4) then nibu15=0;
        if ntyl15 not in (1,2,3,4) then ntyl15=0;
        if nbab15 not in (1,2,3,4) then nbab15=0;
        if babd15 not in (1,2,3,4) then babd15=0;

        totd15=aspd15;
        if babd15>aspd15 and babd15 in (1,2,3,4) then totd15=babd15;

        if nasp15=0 then naspx=0;
        else if nasp15=1 then naspx=1.5;
        else if nasp15=2 then naspx=4;
        else if nasp15=3 then naspx=10;
        else if nasp15=4 then naspx=20;

        if nbab15=0 then naspxx=0;
        else if nbab15=1 then naspxx=0.4;
        else if nbab15=2 then naspxx=1;
        else if nbab15=3 then naspxx=2.5;
        else if nbab15=4 then naspxx=5;

        aspwk15=naspx+naspxx;

        if aspd15 in (1,2,3,4) and nasp15=0 then nasp15=.;
        if nasp15 in (1,2,3,4) and aspd15=0 then aspd15=.;
        if ibud15 in (1,2,3,4) and nibu15=0 then nibu15=.;
        if nibu15 in (1,2,3,4) and ibud15=0 then ibud15=.;
        if tyld15 in (1,2,3,4) and ntyl15=0 then ntyl15=.;
        if ntyl15 in (1,2,3,4) and tyld15=0 then tyld15=.;
        if totd15 in (1,2,3,4) and ntot15=0 then ntot15=.;
        if ntot15 in (1,2,3,4) and totd15=0 then totd15=.;

        aspi15=1;
        if asp15 eq 2 or aspd15 in (2,3,4) then aspi15=2; 
        

        toti15=1;
        if asp15 eq 2 or bab15 eq 2 or totd15 in (2,3,4) then toti15=2;
        if asp15 eq 2 and totd15 eq 1 then toti15=1;
        if bab15 eq 2 and totd15 eq 1 then toti15=1;

        ibui15=1;
        if ibu15 eq 2 or ibut15 eq 1 or ibud15 in (2,3,4) then ibui15=2;
        if ibu15 eq 2 and ibud15 eq 1 then ibui15=1;

        tyli15=1;
        if tyl15 eq 2 or tyld15 in (2,3,4) then tyli15=2;
        if tyl15 eq 2 and tyld15 eq 1 then tyli15=1;

        celei15=1;
        if celeb15 eq 2 or celed15 in (2,3,4) then celei15=2;
        if celeb15 eq 2 and celed15 eq 1 then celei15=1;

        if q15 not in (1,2,3) then do;
                aspi15=.;
                ibui15=.;
                tyli15=.;
                celei15=.;
                aspd15=.;
                ibud15=.;
                tyld15=.;
                nasp15=.;
                nibu15=.;
                ntyl15=.;
                toti15=.;
                totd15=.;
                ntot15=.;
        end;
run;

%nur17(keep=id q17 bab17 babd17 nbab17 asp17 aspd17 nasp17 aspi17 aspwk17 ibu17 ibud17 nibu17 ibut17 ibui17
	tyl17 tyld17 ntyl17 tyli17 celeb17 celed17 celei17 toti17 totd17 ntot17);

        if aspd17 not in (1,2,3,4) then aspd17=0;
        if ibud17 not in (1,2,3,4) then ibud17=0;
        if tyld17 not in (1,2,3,4) then tyld17=0;
        if nasp17 not in (1,2,3,4) then nasp17=0;
        if nibu17 not in (1,2,3,4) then nibu17=0;
        if ntyl17 not in (1,2,3,4) then ntyl17=0;
        if nbab17 not in (1,2,3,4) then nbab17=0;
        if babd17 not in (1,2,3,4) then babd17=0;

        totd17=aspd17;
        if babd17>aspd17 and babd17 in (1,2,3,4) then totd17=babd17;

        if nasp17=0 then naspx=0;
        else if nasp17=1 then naspx=1.5;
        else if nasp17=2 then naspx=4;
        else if nasp17=3 then naspx=10;
        else if nasp17=4 then naspx=20;

        if nbab17=0 then naspxx=0;
        else if nbab17=1 then naspxx=0.4;
        else if nbab17=2 then naspxx=1;
        else if nbab17=3 then naspxx=2.5;
        else if nbab17=4 then naspxx=5;

        aspwk17=naspx+naspxx;

        if aspd17 in (1,2,3,4) and nasp17=0 then nasp17=.;
        if nasp17 in (1,2,3,4) and aspd17=0 then aspd17=.;
        if ibud17 in (1,2,3,4) and nibu17=0 then nibu17=.;
        if nibu17 in (1,2,3,4) and ibud17=0 then ibud17=.;
        if tyld17 in (1,2,3,4) and ntyl17=0 then ntyl17=.;
        if ntyl17 in (1,2,3,4) and tyld17=0 then tyld17=.;
        if totd17 in (1,2,3,4) and ntot17=0 then ntot17=.;
        if ntot17 in (1,2,3,4) and totd17=0 then totd17=.;

        aspi17=1;
        if asp17 eq 2 or aspd17 in (2,3,4) then aspi17=2; 
        

        toti17=1;
        if asp17 eq 2 or bab17 eq 2 or totd17 in (2,3,4) then toti17=2;
        if asp17 eq 2 and totd17 eq 1 then toti17=1;
        if bab17 eq 2 and totd17 eq 1 then toti17=1;

        ibui17=1;
        if ibu17 eq 2 or ibut17 eq 1 or ibud17 in (2,3,4) then ibui17=2;
        if ibu17 eq 2 and ibud17 eq 1 then ibui17=1;

        tyli17=1;
        if tyl17 eq 2 or tyld17 in (2,3,4) then tyli17=2;
        if tyl17 eq 2 and tyld17 eq 1 then tyli17=1;

        celei17=1;
        if celeb17 eq 2 or celed17 in (2,3,4) then celei17=2;
        if celeb17 eq 2 and celed17 eq 1 then celei17=1;

        if q17 not in (1,2,3) then do;
                aspi17=.;
                ibui17=.;
                tyli17=.;
                celei17=.;
                aspd17=.;
                ibud17=.;
                tyld17=.;
                nasp17=.;
                nibu17=.;
                ntyl17=.;
                toti17=.;
                totd17=.;
                ntot17=.;
        end;
run;

data NHS2ASPONE;
   merge nur89 nur93 nur95 nur97 nur99 nur01 nur03 nur05 nur07 nur09 nur11 nur13 nur15 nur17;
   by id;
   exrec=0; 
   if first.id;

/*************regular use of aspirin >=2 days/wk*****************/
* cumulative average is not calculated for regular use in HPFS and NHS2
        because regular use is defined as frequency (2 or more times/week)*;

array reguasp{*} aspi89 aspi93 aspi95 aspi97 aspi99 aspi01 aspi03 aspi05 aspi07 aspi09 aspi11 aspi13 aspi15 aspi17;
array regaspre{*} regaspre89 regaspre93 regaspre95 regaspre97 regaspre99 regaspre01 regaspre03 regaspre05 regaspre07 regaspre09 regaspre11 regaspre13 regaspre15 regaspre17;

/***********Dose:tabs/week -available from 1999**************/

array aspwk{*}  aspwk99 aspwk01 aspwk03 aspwk05 aspwk07 aspwk09 aspwk11 aspwk13 aspwk15 aspwk17;
array aspwkpre{*} aspwkpre99 aspwkpre01 aspwkpre03 aspwkpre05 aspwkpre07 aspwkpre09 aspwkpre11 aspwkpre13 aspwkpre15 aspwkpre17;			   
array avaspwkpre{*} avaspwkpre99 avaspwkpre01 avaspwkpre03 avaspwkpre05 avaspwkpre07 avaspwkpre09 avaspwkpre11 avaspwkpre13 avaspwkpre15 avaspwkpre17;

/*************Duration of regular aspirin use************/

array adur{*} adur8991 adur9395 adur9597 adur9799 adur9901 adur0103 adur0305 adur0507 adur0709 adur0911 adur1113 adur1315 adur1517 adur1719;
array adurarray{*} adur8991 adur9395 adur9597 adur9799 adur9901 adur0103 adur0305 adur0507 adur0709 adur0911 adur1113 adur1315 adur1517 adur1719;

/**********Any regular use of aspirin/baby aspirin*********/
array anyasp{*} aspi89 aspi93 aspi95 aspi97 aspi99 toti01 toti03 toti05 toti07 toti09 toti11 toti13 toti15 toti17;
array anyasppre{*} anyasppre89 anyasppre93 anyasppre95 anyasppre97 anyasppre99 anyasppre01 anyasppre03 anyasppre05 anyasppre07 anyasppre09 anyasppre11 anyasppre13 anyasppre15 anyasppre17;

/************cumulative average of aspirin tabs/week*********/
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

* carry forward regular use of aspirin one cycle *;
do i=1 to dim(reguasp);
        regaspre{i}=reguasp{i};
end;
do i=dim(regaspre) to 2 by -1;
        if regaspre{i} eq . and regaspre{i-1} ne . then regaspre{i}=regaspre{i-1};
end;
  
* carry forward aspirin tabs/week one cycle, after calculating cumulative *;
do i=1 to dim(aspwk);
        aspwkpre{i}=aspwk{i};
end;

do i=dim(aspwkpre) to 2 by -1;
        if aspwkpre{i} eq . and aspwkpre{i-1} ne . then aspwkpre{i}=aspwkpre{i-1};
end;

do i=dim(avaspwkpre) to 2 by -1;
 if avaspwkpre{i} eq . and avaspwkpre{i-1} ne . then avaspwkpre{i}=avaspwkpre{i-1};
end;

* carry forward any use of aspirin one cycle *;
do i=1 to dim(anyasppre);
        anyasppre{i}=anyasp{i};
end;
do i=dim(anyasppre) to 2 by -1;
        if anyasppre{i} eq . and anyasppre{i-1} ne . then anyasppre{i}=anyasppre{i-1};
end;

/*****************duration of regular aspirin**************/
if aspi89>=2 then  do;
        adur8991=4; * assume that have been using for at least 2 years at baseline, consistent with HPFS *;  
end; 
else if .<aspi89<2 then do; 
        adur8991=0; 
end; 
else if aspi89=. then do; 
        adur8991=.; 
end;

* 91+, if aspirin was regularly used, 2 years were added as the duration in the period *;
do i=2 to dim(adur);
        if reguasp{i}>=2 then adur{i}=2;  
        else if .<reguasp{i}<2 then adur{i}=0;  
        else if reguasp{i}=. then adur{i}=.; 
end;

* 1991, no asprirn question, similar to NHS 1986 *;
adur9193=adur8991;

* fills in missing duration with prior questionnaire response */;   
do i=2 to dim(adurarray);
        if adurarray{i}=. then adurarray{i}=adurarray{i-1};
        else;
end;

        regaspdur89=sum(adur8991);
        regaspdur91=sum(adur8991,adur9193);
        regaspdur93=sum(adur8991,adur9193,adur9395);
        regaspdur95=sum(adur8991,adur9193,adur9395,adur9597);
        regaspdur97=sum(adur8991,adur9193,adur9395,adur9597,adur9799); 
        regaspdur99=sum(adur8991,adur9193,adur9395,adur9597,adur9799,adur9901);
        regaspdur01=sum(adur8991,adur9193,adur9395,adur9597,adur9799,adur9901,adur0103);
        regaspdur03=sum(adur8991,adur9193,adur9395,adur9597,adur9799,adur9901,adur0103,adur0305);
        regaspdur05=sum(adur8991,adur9193,adur9395,adur9597,adur9799,adur9901,adur0103,adur0305,adur0507);
        regaspdur07=sum(adur8991,adur9193,adur9395,adur9597,adur9799,adur9901,adur0103,adur0305,adur0507,adur0709);
        regaspdur09=sum(adur8991,adur9193,adur9395,adur9597,adur9799,adur9901,adur0103,adur0305,adur0507,adur0709,adur0911);
        regaspdur11=sum(adur8991,adur9193,adur9395,adur9597,adur9799,adur9901,adur0103,adur0305,adur0507,adur0709,adur0911,adur1113);
        regaspdur13=sum(adur8991,adur9193,adur9395,adur9597,adur9799,adur9901,adur0103,adur0305,adur0507,adur0709,adur0911,adur1113,adur1315);
        regaspdur15=sum(adur8991,adur9193,adur9395,adur9597,adur9799,adur9901,adur0103,adur0305,adur0507,adur0709,adur0911,adur1113,adur1315,adur1517);
        regaspdur17=sum(adur8991,adur9193,adur9395,adur9597,adur9799,adur9901,adur0103,adur0305,adur0507,adur0709,adur0911,adur1113,adur1315,adur1517,adur1719);

/***************NSAIDs********************/
array ibui{*} ibui89 ibui93 ibui95 ibui97 ibui99 ibui01 ibui03 ibui05 ibui07 ibui09 ibui11 ibui13 ibui15 ibui17;
array anyibu{*} regibui89 regibui93 regibui95 regibui97 regibui99 regibui01 regibui03 regibui05 regibui07 regibui09 regibui11 regibui13 regibui15 regibui17;

* Carry forward one cycle *;
do i=1 to dim(ibui);
        anyibu{i}=ibui{i};
end;

do i=dim(anyibu) to 2 by -1;
        if anyibu{i} eq . and anyibu{i-1} ne . then anyibu{i}=anyibu{i-1};
end;

run; 

data nhs2_asp;
        set nhs2aspone;
        keep id regaspre: regibui:
        /*        aspwkpre: avaspwkpre: regaspdur: anyasppre: */
                
;
run;

proc datasets nolist;
	delete nur89 nur93 nur95 nur97 nur99 nur01 nur03 nur05 nur07 nur09 nur11 nur13 nur15 nur17 nhs2aspone;
run;

/*
proc means n nmiss mean data=nhs2_asp;
var regaspre89 regaspre93 regaspre95 regaspre97 regaspre99 regaspre01 regaspre03 regaspre05 regaspre07 regaspre09 regaspre11 regaspre13 regaspre15 regaspre17
    regibui89 regibui93 regibui95 regibui97 regibui99 regibui01 regibui03 regibui05 regibui07 regibui09 regibui11 regibui13 regibui15 regibui17
;
run;

                                                      The MEANS Procedure

                                       Variable           N    N Miss            Mean
                                       ----------------------------------------------
                                       regaspre89    116678         4       1.1126433
                                       regaspre93    116678         4       1.0971734
                                       regaspre95    103738     12944       1.0881355
                                       regaspre97    102432     14250       1.1361977
                                       regaspre99    101394     15288       1.1709470
                                       regaspre01     98280     18402       1.1241860
                                       regaspre03     93117     23565       1.1189364
                                       regaspre05     91915     24767       1.1075668
                                       regaspre07     96488     20194       1.0766727
                                       regaspre09     96948     19734       1.0729773
                                       regaspre11     97324     19358       1.0880256
                                       regaspre13     96787     19895       1.0820255
                                       regaspre15     92433     24249       1.0816700
                                       regaspre17     88113     28569       1.0779227
                                       regibui89     116678         4       1.1945697
                                       regibui93     116678         4       1.2076398
                                       regibui95     103738     12944       1.2711446
                                       regibui97     102432     14250       1.2682755
                                       regibui99     101394     15288       1.3301773
                                       regibui01      98280     18402       1.3248575
                                       regibui03      93117     23565       1.3326890
                                       regibui05      91915     24767       1.3423707
                                       regibui07      96488     20194       1.3485718
                                       regibui09      96948     19734       1.3123014
                                       regibui11      97324     19358       1.3413958
                                       regibui13      96787     19895       1.5971153
                                       regibui15      92433     24249       1.6125193
                                       regibui17      88113     28569       1.7194512
                                       ----------------------------------------------
*/
