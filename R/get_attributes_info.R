#' Get attributes summary from Shapefiles
#'
#' Getssearches Shapefiles existing within an existing folder o directory.
#'
#' @param path `character`. Path to either a Shapefile or to a folder.
#' @param subfolders `logical`. If `FALSE` (the default) and `path` argument is set to a folder the function won't search within any existing subfolders.
#' @param report `character`. Path to an Excel to be created which contains all the attributes found. If there are more than one Shapefile the Excel file will have as many tabs as Shapefiles.
#'
#' @returns A `tibble` object that stores one every Shapefile attributes.
#' * `shape_name`. Name of the Shapefile.
#' * `field_name`. Name of each field from a Shapefile.
#' * `data_type`. Format of each field.
#' @export
#'
#' @examples
#' directory <- system.file("extdata", package = "milcao")
#' get_attributes_info(path = directory)
#'
#' # Set `subfolder = TRUE` to search within any existing subfolder.
#' get_attributes_info(path = directory, subfolder = TRUE)
get_attributes_info <- function(path, subfolders = FALSE, report = NULL) {
  if (missing(path) || is.null(path)) {
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
    shape_paths <- list.files(
      path = path,
      pattern = "\\.shp$",
      full.names = TRUE,
      recursive = subfolders)
  } else {
    shape_paths <- path
  }
  if (length(shape_paths) == 0) {
    cli::cli_warn(c("!" = "No shapefiles found in folder {.val {path}}."))
    return(invisible(character(0)))
  }
  meta_list <- list()
  for (i in shape_paths) {
    gdal_info <- tryCatch(
      sf::gdal_utils(
        util = "ogrinfo",
        source = i,
        options = "-json",
        quiet = TRUE
      ) |>
        jsonlite::fromJSON(),
      error = function(e) {
        return(NULL)
      }
    )
    if (is.null(gdal_info)) {
      cli::cli_warn(c("x" = "Failed to parse JSON from GDAL output."))
      return(invisible(NULL))
    }
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
  meta_df <- tibble::tibble(dplyr::bind_rows(meta_list, .id = "shape_name"))
  names(meta_df)[2:3] <- c("field_name", "data_type")
  if (!is.null(report)) {
    writexl::write_xlsx(x = meta_list, path = report)
    if (!file.exists(report)) {
      cli::cli_warn(c(
        "!" = "The file {.file {report}} couldn't be created.",
        "i" = "Check the file's path is correct."
      ))
    }
    return(meta_df)
  } else {
    return(meta_df)
  }
}

