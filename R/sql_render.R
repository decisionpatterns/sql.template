#' Render SQL template
#'
#' Read SQL and substitute parameters
#'
#' @param sql character or connection object; Can be path to \code{SQL} file,
#' raw SQL or a connection object.
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
#' Reads in a SQL statements, renders it using \code{whisker}. If \code{sql} is
#' character that matches a file on the file system this is read, otherwise
#' \code{character} is taken a a literal statement. \code{sql} can also be a
#' connection object.
#'
#' Strips tags, renders variables and returns the variable
#'
#' \code{sql_render} makes no attempt to determine if resulting SQL is valid SQL.
#'
#' @return character; a SQL statement that can then be passed to a DATABASE
#' connection
#'
#' @seealso
#'   \code{\link[whisker]{whisker.render}} \cr
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
# @import whisker
#' @import whisker.tools
#' @import whisker
#' @export


sql_render <-function(
    sql, data=NULL, tags="r", strip.comments = TRUE,  render=TRUE
) {

  # Create one
  if( is.character(sql) && file.exists(sql) )
    sql <- Reduce( paste, paste0( readLines( sql ), "\n" ) )
  if( is.character(sql) )
    sql <- Reduce( paste, paste0( sql ) ) else
  if( is(sql, "connection") )
    sql <- Reduce( paste, paste0( readLines( sql ), "\n" ) ) else
  stop( "sql is neither type character or a connection object.")


  sql <- gsub( "\\/\\*.*?\\*\\/", "", sql)  # strip comments
  sql <- gsub( "^\\s*", "", sql )           # remove leading white-space
  sql <- gsub( "\\s*$", "" ,sql )           #


  if( length(tags) > 1 )
    stop( "sql_render does not yet support multiple tags.")

  if( render ) {
    sql <- gsub( "--r:", "", sql )
    if( is.null(data) )
      sql <- whisker::whisker.render( sql, data=whisker.tools::whisker_get_all(sql, envir=parent.frame(4) ) ) else
      sql <- whisker::whisker.render( sql, data=data )
  }

  return(sql)

}
