library(testthat)
library(sql.template)

context('read.sql')

# Single string
  sql_1 <- "select * from t1"
  expect_identical( read.sql(sql_1), sql_1 )

# Multiple length string
  sql_2 <- c("select", "*", "from", "t1" )
  expect_identical( read.sql(sql_2), sql_2 )

  expect_identical( read.sql(sql_2, collapse=' '), sql_1 )

# -- style comments
  sql_3 <- c("select-- 1", "*--2", "from--3 ", "t1--4 " )
  expect_identical( read.sql(sql_3, strip.comments = TRUE ), sql_2 )

  expect_identical( read.sql( sql_3, collapse = ' ', strip.comments = TRUE ), sql_1 )

# Mixed style comments
  sql <- c("select/*1*/", "*/*2*/", "from--3 ", "t1--4" )
  expect_identical( read.sql(sql, strip.comments = TRUE ), sql_2 )

  expect_identical( read.sql(sql, strip.comments = TRUE, collapse = " "  ), sql_1)

# readfile
