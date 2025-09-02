
libname g_fm '/udd/hpzfa/review/PA/revision/gformula';
%include '/udd/hpzfa/review/PA/revision/gformula/gformula4.0.sas';

data hpfs; 
set g_fm.hpfs_main;
run; 


%let interv1 = intno = 1,
intlabel = 'limit physical activity < 7.5 met-hr/wk',
nintvar = 1,
intvar1 = actcon, inttype1 = 2,  intpr1 = 1, intmax1 = 7.5,  inttimes1 = 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16;

%let interv2 = intno = 2,
intlabel = 'maintain PA >= 7.5 MET-hr/wk', 
nintvar = 1,
intvar1 = actcon, inttype1 = 2,  intpr1 = 1, intmin1 = 7.5,  inttimes1 = 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16;

%let interv3 = intno = 3,
intlabel = 'maintain PA >= 15 MET-hr/wk', 
nintvar = 1,
intvar1 = actcon, inttype1 = 2,  intpr1 = 1, intmin1 = 15,  inttimes1 = 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16;

%let interv4 = intno = 4,
intlabel = 'maintain PA >= 30 MET-hr/wk', 
nintvar = 1,
intvar1 = actcon, inttype1 = 2,  intpr1 = 1, intmin1 = 30,  inttimes1 = 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16;


%gformula(
    data=hpfs, 
    id=id, 
    time=period,  
    timepoints=17,
    timeptype=concat, 
    timeknots=1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16,
    outc=diag_chr,
    outctype=binsurv, 
    interval=2,  
    censor=censor,      
    numint=4,     
    fixedcov = age86  white  cafh  cvdfh  dbfh  regaspre86  regibui86  mvt86  pkyr86  alco86n  nAHEI86a  obes86,
    ncov=8,
    cov1  = regaspa,  cov1otype = 1,  cov1ptype = lag1bin, 
    cov2  = regibuia, cov2otype = 1,  cov2ptype = lag1bin,
    cov3  = alcocon,  cov3otype = 3,  cov3ptype = lag1qdc,  cov3skip= 1 3 5 7 9 11 13 15,
    cov4  = packy,    cov4otype = 3,  cov4ptype = lag1qdc,
    cov5  = aheicon,  cov5otype = 3,  cov5ptype = lag1bin,  cov5skip= 1 3 5 7 9 11 13 15,
    cov6  = mvit,     cov6otype = 1,  cov6ptype = lag1bin,
    cov7  = bmicon,   cov7otype = 3,  cov7ptype = lag1qdc,
    cov8  = actcon,   cov8otype = 3,  cov8ptype = lag1cub,
    refint = 1,
    seed = 9458, 
    nsamples = 200,
    check_cov_models = 1, /* default=0*/
    print_cov_means = 0, /* default */
    save_raw_covmean = 1, /* default=0*/
    savelib = ,
    survdata = g_fm.men_surv,
    covmeandata = g_fm.men_covmean,
    intervname = g_fm.men_interv,
    observed_surv = g_fm.men_obssurv,
    betadata = g_fm.men_betadata,
    rungraphs = 0, /* default */
    printlogstats = 0 /* default */
    );

