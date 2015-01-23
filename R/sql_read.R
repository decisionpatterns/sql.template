#' Read SQL statement from a connection or string
#'
#' Reads a SQL statement from a file or connection string.
#'
#' @param ... arguments passed to \code{\link[base]{readLines}}
#' @param strip.comments logical; Strip block and inline comments from sql.
#' Default: \code{FALSE}
#'
#' @details
#'
#' For converting a character vector to a \code{sql}, see \code{\link{sql}}.
#'
#' \code{...} is passed to \code{\link[base]{readLines}} and can provide either
#' a connection object or a character vector denoting a path to a local file.
#'
#' The resulting text is coerced to a \code{sql} object using \code{\link{sql}}.
#'
#' \code{strip.comments} strips comments from the SQL.
#'
#'
#' @note
#'   \code{sql_read} is an alias for \code{sql_read}. The latter aligns with the
#'   conventions of this package, i.e. exported functions are prefixed with
#'   \code{sql_}, while the former conforms to the conventions of base R where
#'   functions for reading data begin with \code{read.}. The developer is free
#'   to follow the convention of this package or base R.
#'
#' @return an object of class sql, i.e. string (character) containing a SQL
#' statement
#'
#' @seealso
#'   For finer contol of stipping comments see: \code{\link{sql_strip_comments}}. \cr
#'
#'   For rendering a mustache style SQL template see: \code{\link{sql_render}} \cr
#'
#'   \code{\link{sql}} \cr
#'   \code{\link[base]{readLines}}
#'
#' @examples
#'   \dontrun{
#'      sql_read( "path/to/file )
#'      sql_read( connection )
#'   }
#'
#' @export

sql_read <- function( ..., strip.comments=FALSE ) {

  sql <- sql( readLines( ... ) )
  if(strip.comments) sql_strip_comments(sql)

  return(sql)

}

#' @rdname sql_read
#' @export

read.sql <- sql_read
