get_shape_info <- function(path, all_properties = TRUE, subfolders = FALSE) {
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
  layer_name_vct <- as.character()
  layer_format_vct <- as.character()
  last_edited_dbf_vct <- as.character()
  last_edited_b_vct <- as.character()
  source_encoding_vct <- as.character()
  row_count_vct <- as.character()
  col_count_vct <- as.character()
  geom_type_vct <- as.character()
  crs_type_vct <- as.character()
  crs_name_vct <- as.character()
  crs_epsg_vct <- as.character()

  df_attributes <- tibble::tibble(
    layer_name = as.character(),
    layer_format = as.character(),
    last_edited_dbf = as.character(),
    last_edited_b = as.character(),
    source_encoding = as.character(),
    row_count = as.character(),
    col_count = as.character(),
    geom_type = as.character(),
    crs_type = as.character(),
    crs_name = as.character(),
    crs_epsg = as.character()
  )
  for (i in shape_paths) {
    cli::cli_status("Reading {.val {basename(i)}}")
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
    layer_name_vct <- gdal_info$layers["name"] |> unlist(use.names = FALSE)
    layer_format_vct <- gdal_info$driverShortName

    if (names(gdal_info$layers$metadata)[1] == "") {
      last_edited_dbf_vct <- gdal_info$layers$metadata[[1]]$DBF_DATE_LAST_UPDATE
    } else {
      last_edited_dbf_vct <- NA_character_
      }
    # last_edited_a_vct <- gdal_info$layers$metadata[1] |> unlist() |> names()
    last_edited_b_vct <- file.info(i)$mtime |> as.character()
    source_encoding_vct <- gdal_info$layers$metadata$SHAPEFILE$SOURCE_ENCODING
    row_count_vct <- gdal_info$layers["featureCount"] |>
      unlist() |>
      as.character()
    col_count_vct <- gdal_info$layers$fields[[1]]$name |>
      length() |>
      as.character()
    if (!is.null(gdal_info$layers$geometryFields[[1]]$type)) {
      geom_type_vct <- gdal_info$layers$geometryFields[[1]]$type
    } else {
      geom_type_vct <- NA_character_
    }


    if (any(is.na(gdal_info$layers$geometryFields[[1]]$coordinateSystem))) {
      crs_type_vct = NA_character_
      crs_name_vct = NA_character_
      crs_epsg_vct = NA_character_
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
        crs_epsg_vct <- gdal_info$layers$geometryFields[[1]]$coordinateSystem$projjson$id$code |> as.character()
        } else {
          crs_epsg_vct <- NA_character_
        }
      }

    df_tmp <- tibble::tibble(
      layer_name = layer_name_vct,
      layer_format = layer_format_vct,
      last_edited_dbf = last_edited_dbf_vct,
      last_edited_b = last_edited_b_vct,
      source_encoding = source_encoding_vct,
      row_count = row_count_vct,
      col_count = col_count_vct,
      geom_type = geom_type_vct,
      crs_type = crs_type_vct,
      crs_name = crs_name_vct,
      crs_epsg = crs_epsg_vct
    )
    df_attributes <- dplyr::rows_append(x = df_attributes, y = df_tmp)
  }
  if (all_properties == TRUE) {
    return(df_attributes)
  } else {
    return(df_attributes[c("layer_name", "geometry_type", "rows", "columns", "crs_name")])
  }
}
