test_that("notin works", {
  regiones <- c("Atacama", "Aysén", "Coquimbo")
  patagonia <- c("Los Lagos", "Aysén", "Magallanes")
  patagonia %nin% regiones
})
