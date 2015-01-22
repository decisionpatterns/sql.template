#' sql_strip_comments
#'
#' Strip comments from a SQL STATEMENT
#'
#'
#' @param sql connection or character;
#' @param block logical; strip block (\code{/* ... */}) comments, default: \code{TRUE}
#' @param inline logical; strip inline \code{--} comments, default: \code{TRUE}
#' @param ... additional arguments passed to \code{sql_read}
#'
#' @details
#'   \code{sql_strip_comments} removes SQL standard comments from a SQL
#'   statement. Both inline (\code{--}) and block (\code{/* ... */}) style
#'   comments can be striped independently with the \code{inline} and
#'   \code{block} arguments, the default is to strip both style of comments.
#'   \code{block} comments are given priority and will remove any nested
#'   comments.
#'
#'   A single space preceding a comment is also stripped.
#'
#' @examples
#'   # BLOCK COMMENTS
#'   sql <- "SELECT name /* User Name */ FROM table"
#'   sql_strip_comments( sql )
#'
#'   sql <- "SELECT name /* User \n Name */ FROM table"
#'   sql_strip_comments( sql )
#'
#'   sql <- "SELECT\n first_name, /* User First Name */\n last_name /* User Last Name */\n FROM table"
#'   sql_strip_comments( sql )
#'
#'   # INLINE COMMENTS
#'   sql <- "SELECT -- comment \n A -- col A \n from \n table"
#'   sql_strip_comments( sql )
#'
#' @seealso
#'   \code{\link{sql_read}}
#'
#' @export

sql_strip_comments <- function(sql, block = TRUE, inline = TRUE, ...) {

  if( ! is.sql(sql) ) sql <- sql(sql)

  # sql <- sql_read( sql, collapse="\n", ... )

  # STRIP '/* ... */ style comments
  #  NB the (?s) = single line matching. see ?regex
  if(block)
    sql <- gsub( "(?s) ?\\/\\*.*?\\*\\/", '', sql, perl=TRUE )

  # STRIP '--' style comments
  if(inline)
    sql <- gsub( "(?m) ?--.*([\\n$])", "\\1", sql, perl = TRUE )   # strip '--' style comments


  # REMOVE MULTIPLE SPACES?

  return( sql(sql) )

}

