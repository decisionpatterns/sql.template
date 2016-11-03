

context( "sql" )

x <- "SELECT * FROM table"
stmt <- sql( x )

test_that( "sql", {
  expect_is( stmt, "sql")
  expect_equal( stmt[[1]], x )
})
