#' Shapefile (.shp) finder
#'
#' `find_shapes()` searches Shapefiles existing within an existing folder o directory.
#'
#' @param path `character`. Path to a specific folder.
#' @param full `logical`. If `FALSE` (the default) the function `find_shapes()` returns only the base file name of each Shapefile found. If `TRUE` it returns the full path name to every Shapefile
#'
#' @returns A `character` vector containing the names of the Shapefiles found in the folder path.
#' @export
#'
#' @examples
#' # Error message when using an inexisting path
#' \dontrun{
#' find_shapes(path = "github/project/data")
#'
#' # Error in `find_shapes()`:
#' # ✖ The path "github/project/data" doesn't exist.
#' # ℹ Make sure to use an existing folder path.
#' }
find_shapes <- function(path, full = FALSE, subfolders) {
  if (missing(path) || is.null(path) || path == "") {
    cli::cli_abort(c("x" = "Argument {.code path} is missing or empty.",
                     "i" = "Use argument {.code path} to define a valid folder path."))
  }
  if (!dir.exists(path)) {
    cli::cli_abort(c("x" = "The path {.val {path}} doesn't exist.",
                     "i" = "Make sure to use an existing folder path."))
  } else {
    norm_path <- enc2utf8(normalizePath(path))
  }
  shape_list <- list.files(path = norm_path, pattern = "\\.shp$", full.names = full, recursive = subfolders)
  if (length(shape_list) == 0) {
    cli::cli_warn(c("!" = "No shapefiles found in folder {.val {path}}"))
    return(character(0))
  } else {
    return(shape_list)
  }
}
