test_that("find_shapes() TESTING", {
  expect_equal(find_shapes(path = system.file("extdata", package = "milcao")),
               "estaciones_meteorologicas.shp")
  # expect_equal(find_shapes(path = system.file("extdata", package = "milcao"), full = TRUE),
  #              "C:/Users/Elite Center/Desktop/github/milcao/inst/extdata/estaciones_meteorologicas.shp")
  expect_equal(find_shapes(path = system.file("extdata", package = "milcao"), subfolders = TRUE),
               c("boundaries/dpa_comunas.shp", "boundaries/dpa_provincias.shp", "boundaries/dpa_regiones.shp", "estaciones_meteorologicas.shp"))
  expect_equal(tryCatch(expr = find_shapes(path = "github/project/data"),
                        error = function(e) NA_character_),
               NA_character_)
  }
)
