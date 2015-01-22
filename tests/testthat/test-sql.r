

context( "sql" )

x <- "SELECT * FROM table"
stmt <- sql( x )

expect_is( stmt, "sql")
expect_equal( stmt[[1]], x )
