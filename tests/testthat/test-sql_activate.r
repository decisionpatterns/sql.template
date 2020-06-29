# test-sql_activate.r

context("sql_activate")


context( ".. block comments")

sql <- "SELECT  \n col a \n --, col b \n FROM table"
sql_activated <- sql("SELECT  \n col a \n , col b \n FROM table")

  expect_equal( sql_activate( sql ), sql_activated )

  # INLINE COMMENTS
context( ".. inline comments")

sql <- "SELECT col a /*, col b */ FROM table"
sql_activated <- sql("SELECT col a, col b  FROM table")
expect_equal( sql_activated, sql_activated  )
