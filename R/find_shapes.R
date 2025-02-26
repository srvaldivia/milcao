find_shapes <- function(path) {

  shapes <- list.files(path = path, pattern = "\\.shp$")
  if (length(shapes) != 0) {
    return(shapes)
  } else {
    print("No existen archivos shapefiles en el directorio seleccionado")
  }

}
