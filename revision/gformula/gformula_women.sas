
libname g_fm '/udd/hpzfa/review/PA/revision/gformula';
%include '/udd/hpzfa/review/PA/revision/gformula/gformula4.0.sas';
 
data nhs1; set g_fm.nhs1_main; run;


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
    data=nhs1, 
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
    fixedcov = age_bs  white  cafh  cvdfh  dbfh  aspirin_bs  ibui_bs  mvt_bs  ahei_bs  alco_bs  pkyr_bs  menop_bs  nhor_bs  obes_bs,
    ncov=10,
    cov1  = postmnp,  cov1otype = 1,  cov1ptype = tsswitch1,
    cov2  = hor,      cov2otype = 1,  cov2ptype = lag1bin,
    cov3  = regaspa,  cov3otype = 1,  cov3ptype = lag1bin, 
    cov4  = regibuia, cov4otype = 1,  cov4ptype = lag1bin,
    cov5  = alcocon,  cov5otype = 3,  cov5ptype = lag1qdc,  cov5skip= 1 3 5 7 9 11 13 15,
    cov6  = packy,    cov6otype = 3,  cov6ptype = lag1qdc,
    cov7  = aheicon,  cov7otype = 3,  cov7ptype = lag1bin,  cov7skip= 1 3 5 7 9 11 13 15,
    cov8  = mvit,     cov8otype = 1,  cov8ptype = lag1bin,
    cov9  = bmicon,   cov9otype = 3,  cov9ptype = lag1qdc,
    cov10  = actcon,  cov10otype = 3, cov10ptype = lag1cub,
    refint = 1,
    seed = 9458, 
    nsamples = 200,
    check_cov_models = 1, /* default=0*/
    print_cov_means = 0, /* default */
    save_raw_covmean = 1, /* default=0*/
    savelib = ,
    survdata = g_fm.women_surv,
    covmeandata = g_fm.women_covmean,
    intervname = g_fm.women_interv,
    observed_surv = g_fm.women_obssurv,
    betadata = g_fm.women_betadata,
    rungraphs = 0, /* default */
    printlogstats = 0 /* default */
    );

