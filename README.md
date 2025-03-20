
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

## Usage

``` r
library(milcao)
```

### find_shapes()

``` r
data_directory <- system.file("extdata", package = "milcao")
data_directory
#> [1] "C:/Users/Elite Center/AppData/Local/Temp/Rtmpc1Aac5/temp_libpath180103def4/milcao/extdata"
```

The function `find_shapes()` can be used to get a `character` vector
containing the names of all Shapefiles present within a given folder.

``` r
find_shapes(path = data_directory)
#> [1] "estaciones_meteorologicas.shp"
```

By default `find_shapes()` does not search in any subfolder inside the
folder path. However, this can be changed setting `subfolders = TRUE`.
The name of Shapefile living inside a subfolder will include the path
relative to the main folder defined in `path`.

``` r
 find_shapes(path = data_directory, subfolders  = TRUE)
#> [1] "boundaries/dpa_comunas.shp"    "boundaries/dpa_provincias.shp"
#> [3] "boundaries/dpa_regiones.shp"   "estaciones_meteorologicas.shp"
```

Notice that the default behaviour of `find_shapes()` is set to return
only the name of every Shapefile. You can include `full = TRUE` to the
function to get the full path to each Shapefile.

``` r
find_shapes(path = data_directory, subfolders  = TRUE, full = TRUE)
#> [1] "C:/Users/Elite Center/AppData/Local/Temp/Rtmpc1Aac5/temp_libpath180103def4/milcao/extdata/boundaries/dpa_comunas.shp"   
#> [2] "C:/Users/Elite Center/AppData/Local/Temp/Rtmpc1Aac5/temp_libpath180103def4/milcao/extdata/boundaries/dpa_provincias.shp"
#> [3] "C:/Users/Elite Center/AppData/Local/Temp/Rtmpc1Aac5/temp_libpath180103def4/milcao/extdata/boundaries/dpa_regiones.shp"  
#> [4] "C:/Users/Elite Center/AppData/Local/Temp/Rtmpc1Aac5/temp_libpath180103def4/milcao/extdata/estaciones_meteorologicas.shp"
```

### get_shape_info()

Another handy function from milcao is `get_shape_info()` which returns a
`tibble` object with several vector properties for each Shapefile found,
such as, geometry type, number of rows and cols, CRS name, epgs code
among others. See the function documentation to know the full list of
properties.

``` r
get_shape_info(path = data_directory, subfolders = TRUE)
#> # A tibble: 4 × 12
#>   shape_name          path  format last_edited         source_encoding row_count
#>   <chr>               <chr> <chr>  <dttm>              <chr>               <int>
#> 1 dpa_comunas         C:/U… ESRI … 2025-03-20 15:25:23 UTF-8                 345
#> 2 dpa_provincias      C:/U… ESRI … 2025-03-20 15:25:23 UTF-8                  56
#> 3 dpa_regiones        C:/U… ESRI … 2025-03-20 15:25:23 UTF-8                  16
#> 4 estaciones_meteoro… C:/U… ESRI … 2025-03-20 15:25:23 UTF-8                  46
#> # ℹ 6 more variables: col_count <int>, geom_type <chr>, has_zm <lgl>,
#> #   crs_type <chr>, crs_name <chr>, crs_epsg <int>
```

### get_attribute_info()

This function also creates a `tibble` object which summarises the name
of all Shapefiles columns (also refered to fields or attributes), and
their data type or format.

``` r
get_attributes_info(path = data_directory, subfolders = TRUE)
#> # A tibble: 32 × 3
#>    shape_name     field_name data_type
#>    <chr>          <chr>      <chr>    
#>  1 dpa_comunas    CUT_REG    String   
#>  2 dpa_comunas    CUT_PROV   String   
#>  3 dpa_comunas    CUT_COM    String   
#>  4 dpa_comunas    REGION     String   
#>  5 dpa_comunas    PROVINCIA  String   
#>  6 dpa_comunas    COMUNA     String   
#>  7 dpa_comunas    SUPERFICIE Real     
#>  8 dpa_provincias CUT_REG    String   
#>  9 dpa_provincias CUT_PROV   String   
#> 10 dpa_provincias REGION     String   
#> # ℹ 22 more rows
```

If needed the argument `report` can be included to define an Excel
(.xlsx) file path which will be created with the attribute summary.
