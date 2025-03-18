test_that("find a shapefile inside a directory using find_shapes()", {
  expect_equal(find_shapes(path = system.file("extdata", package = "milcao")),
               "estaciones_meteorologicas.shp")
  }
)

test_that("warning message when a shapefile is not found using find_shapes()", {
  expect_equal(tryCatch(expr = find_shapes(path = system.file("extdata/datasets", package = "milcao")),
                        error = function(e) "Error in `find_shapes()`:"),
               "Error in `find_shapes()`:")
  }
)

test_that("use subfolder argument to search in all existing subfolders", {
  expect_equal(find_shapes(path = system.file("extdata", package = "milcao"),
                           subfolders = TRUE),
               c("boundaries/dpa_comunas.shp", "boundaries/dpa_provincias.shp", "boundaries/dpa_regiones.shp", "estaciones_meteorologicas.shp"))
  }
)
