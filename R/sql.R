#' Represent a character vector as a SQL statement
#'
#' Creates a string with class 'sql'
#'
#' @param x character; string to convert to a SQL statement
#'
#' @param ... additional arguments
#'
#' @details
#' There is nothing magical here. An object of sql is just a string ... i.e.
#' an one-element character vector. It is coerced to a string by 'collapsing' the
#' vector with \code{\\n}.
#'
#' @seealso
#'   \code{\link{sql_read}} for reading SQL from a connection
#'
#' @examples
#'   stmt = "SELECT * FROM table"
#'
#'   sql(stmt)
#'
#'   is.sql(stmt)        # FALSE
#'   is.sql( sql(stmt) ) # TRUE
#'
#'   as.sql(stmt)
#'
#' @export

sql <- function(x) {

  if( is.sql(x) ) return(x)   # Non-Op

  if( ! is.character(x) ) stop( "x must be a character vector" )
  x <- paste0(x, collapse = "\n")

  class(x) <- append( "sql", "character" )

  return(x)

}


#' @rdname sql
#' @export

is.sql <- function(x) is( x, "sql" )


#' @rdname sql
#' @export

print.sql <- function(x, ... ) {
  message( "SQL statement:")
  cat(x, ...)
}

#' @rdname sql
#' @export

as.sql <- function(x) UseMethod( 'as.sql')


#' @rdname sql
#' @export

as.sql.character <- function(x) sql(x)
