% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/find_shapes.R
\name{find_shapes}
\alias{find_shapes}
\title{Shapefile (.shp) finder}
\usage{
find_shapes(path, full = FALSE, subfolders = FALSE)
}
\arguments{
\item{path}{\code{character}. Path to a specific folder.}

\item{full}{\code{logical}. If \code{FALSE} (the default) the function \code{find_shapes()} returns only the base file name of each Shapefile found. If \code{TRUE} it returns the full path name to every Shapefile}

\item{subfolders}{\code{logical}. If \code{FALSE} (the default) the function \code{get_attributes_info()} won't search within subfolders. If \code{TRUE} it returns all Shapefiles stored within the main folder.}
}
\value{
A \code{character} vector containing the names of the Shapefiles found in the folder path.
}
\description{
\code{find_shapes()} searches Shapefiles existing within an existing folder o directory.
}
\examples{
directory <- system.file("extdata", package = "milcao")
find_shapes(path = directory)

# Set `subfolder = TRUE` to allow to search within any existing subfolder.
find_shapes(path = directory, subfolder = TRUE)

# `full = TRUE` returns the full Shapefile path.
find_shapes(path = directory, full = TRUE, subfolder = TRUE)
}
