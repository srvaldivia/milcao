#' "Not-in" operator
#'
#' This operator is simply the negation of the %in% from base R.
#'
#' @param x vector with values to be found
#' @param y vector with values of reference
#'
#' @returns `TRUE` or `FALSE`
#' @export
#'
#' @examples
#' c("a", "b, "c") %nin% letters
`%nin%` <- function(x, y) {
  !(x %in% y)
}


