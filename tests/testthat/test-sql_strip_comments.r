library(testthat)
library(sql.template)

context('sql_strip_comments')

# BLOCK COMMENTS
context( ".. block comment")

  # SIMPLE BLOCK COMMENT
  sql = "SELECT name /* User Name */ FROM table"
  sql_stripped = sql("SELECT name FROM table")
  res = sql_strip_comments(sql)
  expect_is( sql_strip_comments(sql), "sql" )
  expect_equivalent( sql_strip_comments(sql), sql_stripped )

  # BLOCK COMMENT SPANNING \n
  sql <- "SELECT name /* User \n Name */ FROM table"
  sql_stripped = sql("SELECT name FROM table")
  expect_is( sql_strip_comments(sql), "sql" )
  expect_equivalent( sql_strip_comments(sql), sql_stripped )

  # MULTIPLE BLOCK COMMENTS
  sql <- "SELECT\n first_name, /* User First Name */\n last_name /* User Last Name */\n FROM table"
  sql_stripped = sql("SELECT\n first_name,\n last_name\n FROM table")
  expect_is( sql_strip_comments(sql), "sql" )
  expect_equivalent( sql_strip_comments(sql), sql_stripped )



# INLINE COMMENTS
context( ".. inline comment")
  sql <- "SELECT -- comment \n A -- col A \n FROM \n table"
  sql_stripped = sql("SELECT\n A\n FROM \n table")
  expect_is( sql_strip_comments(sql), "sql" )
  expect_equivalent( sql_strip_comments(sql), sql_stripped )


