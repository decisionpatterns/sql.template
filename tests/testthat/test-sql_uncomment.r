
context("sql_uncomment")

  # BLOCK COMMENTS
  sql <- "SELECT  \n col a \n --, col b \n FROM table"
  sql_uncommented <- sql("SELECT  \n col a \n , col b \n FROM table")
  expect_equal( sql_uncomment( sql ), sql_uncommented )

  # INLINE COMMENTS
  sql <- "SELECT col a /*, col b */ FROM table"
  sql_uncommented <-
  sql_uncommented <- sql("SELECT col a, col b  FROM table")
  expect_equal( sql_uncomment( sql ), sql_uncommented  )
