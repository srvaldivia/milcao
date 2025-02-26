#' @title Not-in operator
#'
#' @description
#' Find non-matching elements between two vectors. This is actually a literal negation of the base operator ´%in%´
#'
#' @param path Path where to find th files.
#'
#' @export %nin%
#'
#' @examples
#' 'comunas' %nin% c("Estación Central", "Santiago", "Providencia")

`%nin%` <- Negate(`%in%`)
