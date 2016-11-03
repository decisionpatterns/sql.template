library(testthat)
library(sql.template)

context('sql_render')

  rm( list=ls() )
  prefix <- if( interactive() )  "tests/testthat" else ""
  tmpl <- "select * from {{TABLE}}"

# VALUES FROM LIST
context( ".. values from list")
test_that( "values from list", {
  sql <- sql_render(tmpl, list(TABLE = "table_1"))
  expect_identical( sql, sql("select * from table_1") )
  expect_is( sql, 'sql' )
})

# VALUES FROM ENVIRONMENT
context( ".. values from environment")
test_that( ".. values from environmnet", {
  li <- list(TABLE = "table_2")
  env <- as.environment(li)
  sql <- sql_render(tmpl, env )
  expect_identical( sql, sql("select * from table_2") )
})

# REPLACE COMMENTS
context( ".. replace comments")
test_that( "replace comments", {
  tmpl <- "select * from {{TABLE}} --r: where ROWNUM <= {{ROWS}}"
  sql  <- sql_render( tmpl, list(TABLE = "table_3", ROWS = 3 ), tags="r" )
  expect_identical( sql, sql('select * from table_3 where ROWNUM <= 3') )
})

tmpl <- "select * from {{TABLE}} --r: where ROWNUM <= {{ROWS}}"

# FROM .Global
# debug(sql_render)
# NOTE: THIS FAILS UNDER testthat, but works
context( ".. from global")
test_that( "from global", {
  # if( exists('tmpl') ) rm(tmpl)
  # tmpl <- "select * from {{TABLE}} --r: where ROWNUM <= {{ROWS}}"
  TABLE <- "t4"
  ROWS <- 4
  sql <- sql_render( tmpl, tags="r" )
  expect_identical( sql, sql('select * from t4 where ROWNUM <= 4') )
  rm( TABLE, ROWS )
})



# FROM search path
context( ".. from search path")
test_that( "from search path", {
  CONFIG <- new.env()
  CONFIG$TABLE <- "t5"
  CONFIG$ROWS  <- 5
  attach(CONFIG, warn.conflicts = FALSE)
  rm(CONFIG)
  options( sql.tags = 'r')
# debugonce(sql_render)
  sql <- sql_render( tmpl )
  expect_identical( sql, sql('select * from t5 where ROWNUM <= 5'))


# READ SQL
# debugonce(sql_render)
  TABLE <- 't6'
  ROWS  <- 6
  sql <- sql_render( sql_read( "select-1.sql") )
  expect_identical( sql, sql('select * from t6 where ROWNUM <= 6'))


# MULTILINE COMMENTS
# SOURCE
  sql <- sql_render( file.path(prefix, "select-2.sql") )


# CLEANUP
  detach( CONFIG )
  options(sql.tags=NULL)
})
