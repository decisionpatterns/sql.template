
context("sql_uncomment")


context( ".. block comments")
test_that( "block comments", {
  sql <- "SELECT  \n col a \n --, col b \n FROM table"
  sql_uncommented <- sql("SELECT  \n col a \n , col b \n FROM table")
  expect_equal( sql_uncomment( sql ), sql_uncommented )
})

  # INLINE COMMENTS
context( ".. inline comments")
test_that( "inline comments", {
  sql <- "SELECT col a /*, col b */ FROM table"
  sql_uncommented <-
  sql_uncommented <- sql("SELECT col a, col b  FROM table")
  expect_equal( sql_uncomment( sql ), sql_uncommented  )
})
