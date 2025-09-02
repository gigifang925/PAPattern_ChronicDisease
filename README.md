# Association between long-term physical activity patterns and incidence of major chronic diseases

Using data from three large U.S. cohorts of health professionals (HPFS, NHS, NHSII), we prospectively examined how different long-term physical activity patterns are associated with the incidence of major chronic diseases.


## Code Directory

-  The following files contains code for dataset generation
    -  '*.doloop.sas' → transform into counting process data structure (one row per person-time)
      -  '*.main.sas' → merge outcome, exposure, covariate files
        -  '*.outcome.sas' and 'asp*.sas'
         
-  Files with the following naming conventions correspond to specific analyses:
  - `"table2"` → volume and consistency analysis
  - `"joint"` → joint analysis of activity volume and consistency
  - `"spline"` → dose-response analysis

- **Folder: `second/`**  
  Primary analysis for secondary outcomes: type 2 diabetes (T2D), cardiovascular disease (CVD), cancer, and obesity-related cancer

- **Folder: `traj/`**  
  Group-based trajectory analysis for both the main outcome and secondary outcomes

- **Folder: `lag/`**  
  Lagged analysis for the main and secondary outcomes

- **Folder: `revision/`**  
  Additional analyses conducted during the revision process
  
