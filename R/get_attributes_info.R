#' Get attributes summary from Shapefiles
#'
#' Getssearches Shapefiles existing within an existing folder o directory.
#'
#' @param path `character`. Path to either a specific containing Shapefiles or to a Shapefile.
#' @param subfolders `logical`. If `FALSE` (the default) the function `get_attributes_info()` won't search within subfolders. If `TRUE` it returns all Shapefiles stored within the main folder.
#' @param report `character`. Path to an Excel to be created which contains all the attributes data found.
#'
#' @returns A `list` object that stores one dataframe per shapefile attributes.
#' @export
#'
#' @examples
#' # Error message when using an inexisting path
#' \dontrun{
#' get_attributes_info(path = "github/project/data/survey.shp")
#'
#' # Error in `get_attributes_info()`:
#' # ✖ The path "github/project/data/survey.shp" doesn't exist.
#' # ℹ Make sure to use an existing Shapefile path.
#' }
get_attributes_info <- function(path, subfolders = FALSE, report = NULL) {
  if (missing(path) || is.null(path) || path == "") {
    cli::cli_abort(c(
      "x" = "Argument {.code path} is missing or empty.",
      "i" = "Use a valid folder or Shapefile path."
    ))
  }
  is_folder <- stringr::str_detect(path, pattern = "\\.shp", negate = TRUE)
  if (!dir.exists(path) && is_folder) {
    cli::cli_abort(c(
      "x" = "The path {.val {path}} doesn't exist.",
      "i" = "Make sure to use an existing folder path."
    ))
  }
  if (!file.exists(path)) {
    cli::cli_abort(c(
      "x" = "The path {.val {path}} doesn't exist.",
      "i" = "Make sure to use an existing Shapefile path."
    ))
  }
  if (is_folder == TRUE) {
    shape_paths <- list.files(path = path, pattern = "\\.shp$", full.names = TRUE, recursive = subfolders)
  } else {
    shape_paths <- path
  }
  if (length(shape_paths) == 0) {
    cli::cli_warn(c("!" = "No shapefiles found in folder {.val {path}}."))
    return(invisible(character(0)))
  }
  meta_list <- list()
  for (i in shape_paths) {
    gdal_info <-
      sf::gdal_utils(util = "ogrinfo", source = i, options = "-json", quiet = TRUE) |>
      jsonlite::fromJSON()
    layer_names <- gdal_info$layers$name
    for (j in layer_names) {
      if (is.data.frame(gdal_info$layers$fields[[1]])) {
        meta_list[[j]] <- gdal_info$layers$fields[[1]]
        meta_list[[j]] <- meta_list[[j]][1:2]
      } else {
        meta_list[[j]] <- data.frame()
      }
    }
  }
  if (!is.null(report)) {
    writexl::write_xlsx(x = meta_list, path = report)
    if (!file.exists(report)) {
      cli::cli_warn(c(
        "!" = "The file {.file {report}} couldn't be created.",
        "i" = "Check the file's path is correct."
      ))
    }
    return(meta_list)
  } else {
    return(meta_list)
  }
}

