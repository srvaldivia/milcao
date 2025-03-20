
<!-- README.md is generated from README.Rmd. Please edit that file -->

# milcao

<!-- badges: start -->

[![R-CMD-check](https://github.com/srvaldivia/milcao/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/srvaldivia/milcao/actions/workflows/R-CMD-check.yaml)

<!-- badges: end -->

The goal of milcao is to provide handy functions to handle geospatial
data and tools to improve some GIS workflow and analysis.

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
data_directory <- system.file("extdata", package = "milcao")
```

The function `find_shapes()` can be used to know all the existing
Shapefiles within a given directory using its path.

``` r
find_shapes(path = data_directory)
#> [1] "estaciones_meteorologicas.shp"
```

By default `find_shapes()` does not search Shapefiles living in any
subfolder inside the folder path. However, this can be changed setting
`subfolders = TRUE`.

``` r
 find_shapes(path = data_directory, subfolders  = TRUE)
#> [1] "boundaries/dpa_comunas.shp"    "boundaries/dpa_provincias.shp"
#> [3] "boundaries/dpa_regiones.shp"   "estaciones_meteorologicas.shp"
```

Notice that the default behaviour of `find_shapes()` is set to return
only the name of every Shapefile. You can add the argument `full = TRUE`
to get the full path to each Shapefile.

``` r
find_shapes(path = data_directory, subfolders  = TRUE, full = TRUE)
#> [1] "C:/Users/ASUS/AppData/Local/Temp/RtmpSWwHv4/temp_libpath34ec3fa2397b/milcao/extdata/boundaries/dpa_comunas.shp"   
#> [2] "C:/Users/ASUS/AppData/Local/Temp/RtmpSWwHv4/temp_libpath34ec3fa2397b/milcao/extdata/boundaries/dpa_provincias.shp"
#> [3] "C:/Users/ASUS/AppData/Local/Temp/RtmpSWwHv4/temp_libpath34ec3fa2397b/milcao/extdata/boundaries/dpa_regiones.shp"  
#> [4] "C:/Users/ASUS/AppData/Local/Temp/RtmpSWwHv4/temp_libpath34ec3fa2397b/milcao/extdata/estaciones_meteorologicas.shp"
```
