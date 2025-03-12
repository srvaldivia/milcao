
<!-- README.md is generated from README.Rmd. Please edit that file -->

# milcao

<!-- badges: start -->
<!-- badges: end -->

The goal of milcao is to …

## Installation

You can install the development version of milcao from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("srvaldivia/milcao")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(milcao)
folder <- system.file("shape", package = "sf")
```

``` r
find_shapes(path = folder)
#> [1] "nc.shp"                  "olinda1.shp"            
#> [3] "storms_xyz.shp"          "storms_xyz_feature.shp" 
#> [5] "storms_xyzm.shp"         "storms_xyzm_feature.shp"
find_shapes(path = folder, full = TRUE)
#> [1] "C:\\Users\\Elite Center\\AppData\\Local\\R\\win-library\\4.4\\sf\\shape/nc.shp"                 
#> [2] "C:\\Users\\Elite Center\\AppData\\Local\\R\\win-library\\4.4\\sf\\shape/olinda1.shp"            
#> [3] "C:\\Users\\Elite Center\\AppData\\Local\\R\\win-library\\4.4\\sf\\shape/storms_xyz.shp"         
#> [4] "C:\\Users\\Elite Center\\AppData\\Local\\R\\win-library\\4.4\\sf\\shape/storms_xyz_feature.shp" 
#> [5] "C:\\Users\\Elite Center\\AppData\\Local\\R\\win-library\\4.4\\sf\\shape/storms_xyzm.shp"        
#> [6] "C:\\Users\\Elite Center\\AppData\\Local\\R\\win-library\\4.4\\sf\\shape/storms_xyzm_feature.shp"
```

``` r
get_attributes_info(path = folder)
#> $nc
#>         name    type
#> 1       AREA    Real
#> 2  PERIMETER    Real
#> 3      CNTY_    Real
#> 4    CNTY_ID    Real
#> 5       NAME  String
#> 6       FIPS  String
#> 7     FIPSNO    Real
#> 8   CRESS_ID Integer
#> 9      BIR74    Real
#> 10     SID74    Real
#> 11   NWBIR74    Real
#> 12     BIR79    Real
#> 13     SID79    Real
#> 14   NWBIR79    Real
#> 
#> $olinda1
#>         name      type
#> 1         ID      Real
#> 2 CD_GEOCODI    String
#> 3       TIPO    String
#> 4 CD_GEOCODB    String
#> 5    NM_BAIR    String
#> 6       V014 Integer64
#> 
#> $storms_xyz
#> data frame with 0 columns and 0 rows
#> 
#> $storms_xyz_feature
#>    name   type
#> 1 Track String
#> 
#> $storms_xyzm
#> data frame with 0 columns and 0 rows
#> 
#> $storms_xyzm_feature
#>    name   type
#> 1 Track String
get_attributes_info(path = folder, subfolder = TRUE)
#> $nc
#>         name    type
#> 1       AREA    Real
#> 2  PERIMETER    Real
#> 3      CNTY_    Real
#> 4    CNTY_ID    Real
#> 5       NAME  String
#> 6       FIPS  String
#> 7     FIPSNO    Real
#> 8   CRESS_ID Integer
#> 9      BIR74    Real
#> 10     SID74    Real
#> 11   NWBIR74    Real
#> 12     BIR79    Real
#> 13     SID79    Real
#> 14   NWBIR79    Real
#> 
#> $olinda1
#>         name      type
#> 1         ID      Real
#> 2 CD_GEOCODI    String
#> 3       TIPO    String
#> 4 CD_GEOCODB    String
#> 5    NM_BAIR    String
#> 6       V014 Integer64
#> 
#> $storms_xyz
#> data frame with 0 columns and 0 rows
#> 
#> $storms_xyz_feature
#>    name   type
#> 1 Track String
#> 
#> $storms_xyzm
#> data frame with 0 columns and 0 rows
#> 
#> $storms_xyzm_feature
#>    name   type
#> 1 Track String
```
