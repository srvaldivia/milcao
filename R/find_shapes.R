#' @title Find Shapefiles
#'
#' @descriptio
#' Find files within a path which end with ".shp"
#'
#' @param path Path where to find th files.
#'
#' @returns Character vector with shapefile names
#' @export find_shapes
#'
#' @examples
#' find_shapes("path/to/your/location")


find_shapes <- function(path) {

  shapes <- list.files(path = path, pattern = "\\.shp$")
  if (length(shapes) != 0) {
    return(shapes)
  } else {
    print("No existen archivos shapefiles en el directorio seleccionado")
  }

}
