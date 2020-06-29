#' Activate (uncomment) Part(s) of a SQL Template
#'
#' Activates (uncomments) Part of a SQL Template based on supplied data.
#'
#' @param x character or sql object; if character, it is first coerced to SQL
#'
#' @param tags character; tags that should be uncommenting. The default
#' is \code{getOption(sql.tags)} or else \code{""} -- all comments are
#' uncommented.
#'
#' @param block logical; uncomment block (/* ... */) comments. Default: TRUE
#'
#' @param inline logical; uncomment inline (-- ...) comments. Default: TRUE
#'
#' @details
#' `sql_activate` is **not** the same as
#' [sql_strip_comments()] which completely removes comments from a
#' SQL statement.
#'
#' `sql_activate` removes comment delimiters so that comments
#' that normally skipped will be evaluated by a SQL engine.
#'
#' By default, \strong{all} comments are uncommented, setting the global
#' option \code{sql.tag} or passing an argument to \code{tags} will uncomment
#' only tagged comments.
#'
#' @section Tagged Comments:
#'
#' Tagged comments allow the user to implement additional functionality
#' at run-time. This allows queries to be shared by multiple functions.
#' For example, a query might be used in a bulk operation operating on all
#' records or an iterative procedure where a subset of records are used.
#'
#' Comments are uncommeted by tags.  By default, the tag is `""`, namely all
#' comments.  A common case is to have a part of the where clause be for
#' development.  For example,
#' {{--dev: AND user_id = 1}} or {{/*dev: AND user_id = 1 */}}.
#'
#' Comments can be  tagged in the SQL code, by placing the tag as the first
#' letter type character(s) of the query followed by a colon. For example:
#'
#' inline: `--tag_name:` \cr
#' block: `/*tag_name:*/`
#'
#' **A comment can only have one tag.**
#'
#' This interface may change in the future.
#'
#' @note
#' Todo: Fixes white-space problems related to uncommenting.
#'
#' @seealso
#'   \code{\link{sql}} \cr
#'   \code{\link{sql_render}} \cr
#'
#' @examples
#'   sql <- "SELECT  \n col a \n --, col b \n FROM table"
#'   sql_activate( sql )
#'
#'   sql <- "SELECT col a /*, col b */ FROM table"
#'   sql_activate( sql )
#'
#' @md
#' @export

sql_activate <- function(
    x
  , tags=if( ! is.null(getOption('sql.tags')) )  getOption('sql.tags') else ""
# NB: The resaon NULL is not used in the tags is that NULL does not exist in
# vectors NA is a possibility here.
  , block = TRUE
  , inline = TRUE
) {

  stmt <- if( is.sql(x) ) x else sql(x)


  for( tag in tags ) {

    if( tag != "" ) {
      if( grepl("^\\W", tag) ) stop( "tags must begin with a letter or number")
       tag <- paste0( tag, ":")
    }

    # BLOCK comments
    if( block ){
      # stmt <- gsub( paste0( " +?" ))
      pattern <- paste0(   "(?s) ?\\/\\*", tag, "(.*?)\\*\\/" )  # REGEXP PATTERN: /* ... */
      stmt <- gsub( pattern, "\\1", stmt, perl=TRUE )
    }

    # INLINE COMMENTS
    # stmt <- gsub( paste0(" --", tags, ":"), " --", stmt)  # FIX whitespace replace two spaces preceding comment with one
    if( inline ) {
      pattern <- paste0( "--", tag, " *" )
      stmt    <- gsub( pattern, "", stmt )
    }

  }

  return(stmt)
}
