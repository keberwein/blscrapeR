## Resubmission
Corrected two items of concern by CRAN review.

* Added the API address to the Description file.

* Removed the `set_bls_key()` function to remain in compliance with CRAN policies regarding writing files to user space. Also, removed any mention of the function from documentation and vignettes.


## Test environments
* local Fedora 33, R 4.05
* win-latest (devel)
* ubuntu-latest (devel)
* ubuntu-latest (release)
* rhub

## R CMD check results

0 errors | 0 warnings | 2 notes

## Notes:
CRAN repository db overrides:
  X-CRAN-Comment: Archived on 2023-02-07 for repeated policy violation.
  
    * This package was previously archived due to CRAN violations, which have all been fixed. The violations regarded bad URL links in documentation and vignettes.


Found the following (possibly) invalid URLs:
  URL: https://www.bls.gov/
    From: DESCRIPTION
    Status: 403
    Message: Forbidden

    * The following note was generated when I added the BLS url to the DESCRIPTION file as requested by CRAN reviewer. The url is valid.


    
    


