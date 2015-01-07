#' Render SQL template
#'
#' Read SQL and substitute parameters, use tags to allow for programatic
#' functionality.
#'
#' @param sql character or connection object; Can be path to \code{SQL} file,
#' raw SQL or a connection object, See \code{\link{read.sql}} for details.
#'
#' @param data environment, list or named vector. Locations to search for values
#' to substitute into the query. The default, \code{NULL} finds the names from
#' the call stack.
#'
#' @param render logical; whether to make a template replacement using
#' \code{whisker.render} (DEFAULT:TRUE)
#'
#' @param tags character; list of tags to uncomment.  Default: "r"
#'
#' @param strip.comments logical; whether to strip comments from sql;
#' Default: TRUE
#'
#' @details
#'
#' \code{sql_render} renders a SQL template by substituting values for the
#' whisker tags.
#'
#' Strips tags, renders variables and returns the text.
#'
#' \code{sql} can either be 1) a connection object 2) a character vector of
#' length one that is a path to a file on file system or 3) a character
#' vector containing a SQL statement. The last of these is assumed if the first
#' two cannot be satisfied.  Both the connection and the file are read using
#' \code{\link[base]{readLines}}.
#' In all cases the SQL statements are collapsed to a string (character vector
#' of length 1) before further processing.
#'
#' \code{data} can be a list or environment that provides the values to be
#' substituted.  See \code{whisker.render} for complete details.
#'
#' When set to \code{FALSE}, \code{render} will prevent rendering of the
#' template and pass-through the SQL unaltered. This is useful mainly for
#' debugging.
#'
#'
#' @section Variable Substitution:
#'
#' The SQL are rendered it using \code{\link[whisker]{whisker.render}} using the
#' values provided in \code{data} or the \code{parent.frame} if data is not
#' provided.
#'
#' @section Uncommenting:
#'
#' Tagged comments allow the user to implement additional functionality
#' at run-time. This allows queries to be shared by multiple functions.
#' For example, a query might be used in a bulk operation operating on all
#' records or an iterative procedure where a subset of records are used.
#'
#' Comments are uncommeted by tags.  By default, the tag is {{r}}; comments
#' that have this tag are "uncommented". For example,
#' {{--r:}} is removed from the file, {{/*r: ... */}} is replaced by {{...}}
#'
#' This interface may change in the future.
#'
#'
#' The combination of substitution and uncommenting allows queries to be shared
#' among a variety of functions.
#'
#' @note
#' \code{sql_render} makes no attempt to determine if resulting SQL is valid SQL.
#'
#' @return character; a SQL statement that can then be passed to a DATABASE
#' connection
#'
#' @seealso
#'   \code{\link{read.sql}} \cr
#'   \code{\link[whisker]{whisker.render}} \cr
#'
#'
#' @examples
#'
#'   sql = "select * from {{table}}"
#'   table = "table1"
#'   sql_render( sql )
#'
#'   table = "table_1"
#'   sql_render( sql )
#'   sql_render( "select * from {{table}} --r: where ROWNUM < 10 ")
#'
#'   # with magrittr:
#'   \dontrun{
#'     sql %>% sql_render( c( table = "table4" ) )
#'   }
#'
#' @import whisker.tools
#' @export

# NOTE: It might be tempting to put data=parent.frame, the problem is that
#       whisker::whisker.render does not search the call stack this should
#       be done.

sql_render <-function(
    sql, data=NULL, tags="r", strip.comments = FALSE,  render=TRUE
) {


  stmt <- read.sql( sql, collapse="\n" )

  # sql <- gsub( "\\/\\*.*?\\*\\/", "", sql)  # strip comments
  stmt <- gsub( "^\\s*", "", stmt )           # remove leading white-space
  stmt <- gsub( "\\s*$", "" ,stmt )           # remove trailing white-space

  # SUBSTITUTE TAGS:
  if( length(tags) > 1 )
    stop( "sql_render does not support multiple tags ... yet")


  if( render ) {
    # HANDLE --r: style comments
    pattern <- paste0( "--", tags, ":" )
    stmt    <- gsub( pattern, "", stmt )

    # HANDLE /*r: ... */ comments
    pattern <- paste0( "(?s)\\/\\*", tags, ":(.*?)\\*\\/" )  # REGEXP PATTERN
    stmt <- gsub( pattern, "\\1", stmt, perl=TRUE )


    # RENDER VALUES
    # For whatever reason this works, but we cannot set the
    if( is.null(data) ) {
      stmt <- whisker::whisker.render( stmt, data=whisker.tools::whisker_get_all(stmt, envir=parent.frame()) ) } else
      stmt <- whisker::whisker.render( stmt, data=data )
  }

  return(stmt)

}
