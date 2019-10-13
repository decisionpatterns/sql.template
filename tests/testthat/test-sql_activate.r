
context("sql_activate")


context( ".. block comments")
test_that( "block comments", {
  sql <- "SELECT  \n col a \n --, col b \n FROM table"
  sql_activateed <- sql("SELECT  \n col a \n , col b \n FROM table")
  expect_equal( sql_activate( sql ), sql_activateed )
})

  # INLINE COMMENTS
context( ".. inline comments")
test_that( "inline comments", {
  sql <- "SELECT col a /*, col b */ FROM table"
  sql_activateed <-
  sql_activateed <- sql("SELECT col a, col b  FROM table")
  expect_equal( sql_activate( sql ), sql_activateed  )
})
