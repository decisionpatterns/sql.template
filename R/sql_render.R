#' Render mustache-style SQL template
#'
#' Read SQL and substitute parameters, use tags to allow for programatic
#' functionality.
#'
#' @param sql either a connection or character string;
#' see \code{\link{sql}} and \code{\link{sql_read}}
#'
#' @param data environment, list or named vector. Locations to search for values
#' to substitute into the query. The default, \code{NULL} finds the names from
#' the call stack/search path.
#'
#' @param tags character; list of tags to uncomment. See
#' \code{\link{sql_uncomment}}. The default, \code{NULL} does not perform any
#' uncommenting.
#'
#' @param strip.comments logical; whether to strip comments from sql;
#' The Default is taken from the global option \code{sql.strip.comments} or else
#' it is \code{TRUE}
#'
#' @param render logical; whether to make a template replacement using
#' \code{whisker.render} (DEFAULT:TRUE)
#'
#' @param ... aditional arguments supplied to \code{\link{sql_read}}
#'
#' @details
#'
#' \code{sql_render} renders a SQL template by optionally uncommenting and/or
#' stripping comments followed by substituting template variables using whisker.
#' The process occurs in that order.
#'
#' When set to \code{FALSE}, \code{render} will prevent rendering of the
#' template and pass-through the SQL unaltered. This is useful mainly for
#' debugging.
#'
#'
#' @section Uncommenting:
#'
#' See \code{\link{sql_uncomment}},
#'
#' \code{tags} are used to uncomment SQL comments using. The default is provided
#' by global option \code{sql.tags}. If unset or \code{NULL}, no uncommenting is
#' performed.  If an empty character string, \code{""}, is provided, all
#' comments are uncommented.
#'
#' @section Comment stripping:
#'
#' \code{strip.comments} controls the stripping of comments. It is performed by
#' \code{\link{sql_strip_comments}}. Since comment stripping occurs after
#' uncommenting, previously uncommented lines are not stripped from the SQL.
#' The default to strip comments since 1) most operations are believed to be
#' automatic in nature and 2) any unfound template variables result in a
#' warning courtesy of \code{whisker.tools}. Thus stripping comments means
#' warnings only occur only from evaluated SQL and not comments.
#'
#'
#' @section Variable Substitution:
#'
#' SQL is rendered it using \code{\link[whisker]{whisker.render}} using the
#' values provided in \code{data} or the \code{parent.frame} by default.
#' \code{data} can be a list or environment that provides the values to be
#' substituted. If a varaible is not found, an warning is given.
#'
#' @note
#' \code{sql_render} makes no attempt to determine if resulting SQL is valid SQL.
#'
#' @return sql; a SQL statement that can then be passed to a DATABASE
#' connection
#'
#' @seealso
#'   \code{\link{sql_read}} \cr
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
      sql
    , data = NULL
    , tags = getOption('sql.tags')
    , strip.comments = getOption('sql.strip.comments', TRUE )
    , render = TRUE
    , ...
) {

  # 0. CONNECTION -> CHARACTER
  if( is(sql, "connection") || file.exists(sql) )
    sql <- sql_read( sql, ... )

  # SQL IS UNIDENTIFIED
  if( ! is.character(sql) )
    stop( "'sql' is neither type character or a connection object.")

  stmt <- sql(sql)

  # 1. UNCOMMENT
  if( ! is.null(tags) )
    stmt <- sql_uncomment( stmt, tags=tags, ... )


  # 2. STRIP COMMENTS
  if( strip.comments ) stmt <- sql_strip_comments( stmt )


  # SUBSTITUTE TAGS
  if( render )
    if( is.null(data) )
      stmt <- whisker::whisker.render( stmt, data=whisker.tools::whisker_get_all(stmt, envir=parent.frame()) )  else
      stmt <- whisker::whisker.render( stmt, data=data )


  stmt <- gsub( "^\\s*", "", stmt )           # remove leading white-space
  stmt <- gsub( "\\s*$", "" ,stmt )           # remove trailing white-space

  stmt <- gsub( "(m?)\\n\\s+\\n", "\n", stmt )# Remove superfluous whitespace


  stmt <- sql(stmt)

  return(stmt)

}
