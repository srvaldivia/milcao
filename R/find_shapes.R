find_shapes <- function(path, full = FALSE) {
  if (missing(path) || is.null(path) || path == "" || trimws(path) == "") {
    cli::cli_abort(c("x" = "Argument {.code path} is missing or empty.",
                     "i" = "Use argument {.code path} to define a valid folder path."))
  }
  if (!dir.exists(path)) {
    cli::cli_abort(c("x" = "The path {.val {path}} doesn't exist.",
                     "i" = "Make sure to use an existing folder path."))
  }
  shape_list <- list.files(path = path, pattern = "\\.shp$", full.names = full)
  if (length(shape_list) == 0) {
    cli::cli_warn(c("!" = "No shapefiles found in folder {.val {path}}"))
    return(character(0))
  } else {
    return(shape_list)
  }
}
