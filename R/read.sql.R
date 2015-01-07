#' Read SQL statement from a connection or string
#'
#' Reads a SQL statement from a file or connection string.
#'
#' @param sql character or connection object; Can be the path to \code{SQL}
#' file, raw SQL or a connection object.
#'
#' @param collapse character; ptional character string to separate the results.
#' See \code{\link[base]{paste}}.
#'
#' @param strip.comments logical; whether to strip SQL style comments
#'
#' @details
#'
#' \code{sql} can either be 1) a connection object 2) a character vector
#' with one element denoting a path to a file on file system or 3) a character
#' vector containing a SQL statement. The connection object or file path
#' are read using \code{\link[base]{readLines}}.
#'
#' \code{collapse} controls whether the result is collapsed to a string, i.e. a
#' character vector of a single element.
#'
#' \code{strip.comments} controls whether comments are stripped from the SQL
#' statement.  Both \code{--} and \code{/* ... */} style comments are removed.
#'
#' For using \code{collapse} with \code{strip.comments}, stripping \code{--}
#' comments occurs before collapsing and \code{/* ... */} comments are stripped
#' after. In order to strip multiline \code{/* ... */} comments, \code{collapse}
#' has to be TRUE.
#'
#' @note
#'   Though the convention for this package is to prefix methods with
#'   \code{sql_}, the style of \code{read.*} is followed to closely match base
#'   R.
#'
#' @return character containin a SQL statement
#'
#' @seealso
#'   \code{\link[base]{readLines}}
#'
#' @examples
#'   sql <- "select * from t1"
#'   read.sql(sql)
#'
#'   sql <- c("select", "*", "from", "t1" )
#'   read.sql(sql)
#'   read.sql(sql, collapse=' ')
#'
#'   sql <- c("select  -- 1", "* --2", "from --3 ", "t1 --4 " )
#'   read.sql(sql, strip.comments = TRUE )
#'   read.sql( sql, collapse = ' ', strip.comments = TRUE )
#'
#'   sql <- c("select  /*1*/", "* /*2*/", "from --3 ", "t1 --4" )
#'   read.sql(sql, strip.comments = TRUE )
#'   read.sql(sql, strip.comments = TRUE, collapse = " "  )
#'
#' @export

read.sql <- function( sql, collapse = NULL, strip.comments=FALSE ) {

  # FILE -> CHARACER
  if( is.character(sql) && length(sql) == 1 && file.exists(sql) )
    sql <- readLines(sql)

  # CONNECTION -> CHARACTER
  if( is(sql, "connection") )
    sql <- readLines( sql )

  # SQL IS UNIDENTIFIED
  if( ! is.character(sql) )
    stop( "'sql' is neither type character or a connection object.")


  # STRIP '--' style comments
  #  This should precede collapsing since
  if(strip.comments)
    sql <- gsub( "(?s)--.*$", "", sql, perl = TRUE )   # strip '--' style comments

  # COLLAPSE
  if( ! is.null(collapse) ) sql <- paste0( sql, collapse=collapse )

  # STRIP '/* ... */ style comments
  if(strip.comments) sql <- gsub( "(?s)\\/\\*.*?\\*\\/", '', sql, perl=TRUE )

  return(sql)

}
