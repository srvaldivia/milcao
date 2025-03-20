#' Get vector properties of Shapefile
#'
#' Retrieves vector properties of Shapefiles including file name, geometry type, CRS among other.
#'
#' @param path `character`. Path to either a Shapefile or to a folder.
#' @param subfolders `logical`. If `FALSE` (the default) and `path` argument is set to a folder the function won't search within any existing subfolders.
#'
#' @returns A `tibble` with the following Shapefile properties:
#' * `shape_name`. Name of the Shapefile.
#' * `path`. Path to the Shapefile's folder.
#' * `format`. Name of the file's format.
#' * `last_edited_gdal`. Shapefile's last edition date.
#' * `source_encoding`. Character encoding of the Shapefile's attribute table.
#' * `row_count`. Number of rows of the Shapefile's attribute table.
#' * `col_count`. Number of cols of the Shapefile's attribute table.
#' * `geom_type`. Type of geometry of the Shapefile.
#' * `has_zm`. ¿Does the Shapefile has ZM values? Yes (`TRUE`) or No (`FALSE`)
#' * `crs_type`. Type of coordinates of the CRS (Geographic or Projected).
#' * `crs_name`. Name of the CRS.
#' * `crs_epsg`. EPSG code of the CRS.
#'
#'
#' @export
#'
#' @examples
#' directory <- system.file("extdata", package = "milcao")
#' get_shape_info(path = directory, subfolder = TRUE)
#'

#' # Set `subfolder = TRUE` to search within any existing subfolder.
#' get_shape_info(path = directory, subfolder = TRUE)
get_shape_info <- function(path, subfolders = FALSE) {
  if (missing(path) || is.null(path)) {
    cli::cli_abort(c(
      "x" = "Argument {.code path} is missing or empty.",
      "i" = "Use a valid folder or Shapefile path."
    ))
  }
  is_folder <- any(stringr::str_detect(path, pattern = "\\.shp", negate = TRUE))
  if (!any(dir.exists(path)) && is_folder) {
    cli::cli_abort(c(
      "x" = "The path {.val {path}} doesn't exist.",
      "i" = "Make sure to use an existing folder path."
    ))
  }
  if (!any(file.exists(path))) {
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
      recursive = subfolders
    )
  } else {
    shape_paths <- path
  }
  if (length(shape_paths) == 0) {
    cli::cli_warn(c("!" = "No shapefiles found in folder {.val {path}}."))
    return(invisible(character(0)))
  }
  shape_name_vct      <- as.character()
  path_vct            <- as.character()
  format_vct          <- as.character()
  last_edited_vct     <- as.POSIXct(0)
  source_encoding_vct <- as.character()
  row_count_vct       <- as.character()
  col_count_vct       <- as.integer()
  geom_type_vct       <- as.integer()
  has_zm_vct          <- as.logical()
  crs_type_vct        <- as.character()
  crs_name_vct        <- as.character()
  crs_epsg_vct        <- as.integer()

  df_attributes <- tibble::tibble(
    shape_name      = as.character(),
    path            = as.character(),
    format          = as.character(),
    last_edited     = as.POSIXct(0),
    source_encoding = as.character(),
    row_count       = as.integer(),
    col_count       = as.integer(),
    geom_type       = as.character(),
    has_zm          = as.logical(),
    crs_type        = as.character(),
    crs_name        = as.character(),
    crs_epsg        = as.integer()
  )
  for (i in shape_paths) {
    # cli::cli_status("Reading {.val {basename(i)}}")
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
    shape_name_vct <- gdal_info$layers["name"] |> unlist(use.names = FALSE)
    path_vct <- i
    format_vct <- gdal_info$driverShortName

    last_edited_vct <- file.info(i)$mtime
    source_encoding_vct <- gdal_info$layers$metadata$SHAPEFILE$SOURCE_ENCODING
    row_count_vct <- gdal_info$layers["featureCount"] |>
      unlist() #|>
      #as.character()
    col_count_vct <- gdal_info$layers$fields[[1]]$name |>
      length() #|>
      #as.character()
    if (!is.null(gdal_info$layers$geometryFields[[1]]$type)) {
      geom_type_vct <- gdal_info$layers$geometryFields[[1]]$type
    } else {
      geom_type_vct <- NA_character_
    }
    if (!is.na(geom_type_vct)) {
      has_zm_vct <- ifelse(test = grepl("[[:alpha:]]+ZM$", x = geom_type_vct),
                           yes = TRUE,
                           no = FALSE)
    } else {
      has_zm_vct <- NA
    }


    if (any(is.na(gdal_info$layers$geometryFields[[1]]$coordinateSystem))) {
      crs_type_vct = NA_character_
      crs_name_vct = NA_character_
      crs_epsg_vct = NA_integer_
    } else {
      if (!is.null(gdal_info$layers$geometryFields[[1]]$coordinateSystem$projjson$type)) {
        crs_type_vct <- gdal_info$layers$geometryFields[[1]]$coordinateSystem$projjson$type
        } else {
          crs_type_vct <- NA_character_
          }
      if (!is.null(gdal_info$layers$geometryFields[[1]]$coordinateSystem$projjson$name)) {
        crs_name_vct <- gdal_info$layers$geometryFields[[1]]$coordinateSystem$projjson$name
        } else {
          crs_name_vct <- NA_character_
          }
      if (!is.null(gdal_info$layers$geometryFields[[1]]$coordinateSystem$projjson$id$code)) {
        crs_epsg_vct <- gdal_info$layers$geometryFields[[1]]$coordinateSystem$projjson$id$code #|> as.character()
        } else {
          crs_epsg_vct <- NA_integer_
        }
      }

    df_tmp <- tibble::tibble(
      shape_name      = shape_name_vct,
      path            = path_vct,
      format          = format_vct,
      last_edited     = last_edited_vct,
      source_encoding = source_encoding_vct,
      row_count       = row_count_vct,
      col_count       = col_count_vct,
      geom_type       = geom_type_vct,
      crs_type        = crs_type_vct,
      has_zm          = has_zm_vct,
      crs_name        = crs_name_vct,
      crs_epsg        = crs_epsg_vct
    )
    df_attributes <- dplyr::rows_append(x = df_attributes, y = df_tmp)
  }
  return(df_attributes)
}
