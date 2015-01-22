library(testthat)
library(sql.template)

context('sql_render')


  rm( list=ls() )
  prefix <- if( interactive() )  "tests/testthat" else ""

# VALUES FROM LIST
  tmpl <- "select * from {{TABLE}}"
  sql <- sql_render(tmpl, list(TABLE = "table_1"))
  expect_identical( sql, sql("select * from table_1") )
  expect_is( sql, 'sql' )

# VALUES FROM ENVIRONMENT
  li <- list(TABLE = "table_2")
  env <- as.environment(li)
  sql <- sql_render(tmpl, env )
  expect_identical( sql, sql("select * from table_2") )


# REPLACE COMMENTS
  tmpl <- "select * from {{TABLE}} --r: where ROWNUM <= {{ROWS}}"
  sql  <- sql_render( tmpl, list(TABLE = "table_3", ROWS = 3 ), tags="r" )
  expect_identical( sql, sql('select * from table_3  where ROWNUM <= 3') )



# FROM .Global
# debug(sql_render)
# NOTE: THIS FAILS UNDER testthat, but works
  if( exists('tmpl') ) rm(tmpl)
  tmpl <- "select * from {{TABLE}} --r: where ROWNUM <= {{ROWS}}"
  TABLE <- "t4"
  ROWS <- 4
  sql <- sql_render( tmpl, tags="r" )
  expect_identical( sql, sql('select * from t4  where ROWNUM <= 4') )

# FROM search path
  rm( TABLE, ROWS, tmpl )
  tmpl <- "select * from {{TABLE}} --r: where ROWNUM <= {{ROWS}}"
  CONFIG <- new.env()
  CONFIG$TABLE <- "t5"
  CONFIG$ROWS  <- 5
  attach(CONFIG, warn.conflicts = FALSE)
  rm(CONFIG)
  options( sql.tags = 'r')
# debugonce(sql_render)
  sql <- sql_render( tmpl )
  expect_identical( sql, sql('select * from t5  where ROWNUM <= 5'))


# READ SQL
# debugonce(sql_render)
  TABLE <- 't6'
  ROWS  <- 6
  sql <- sql_render( sql_read( "select-1.sql") )
  expect_identical( sql, sql('select * from t6  where ROWNUM <= 6'))


# MULTILINE COMMENTS
# SOURCE
  sql <- sql_render( file.path(prefix, "select-2.sql") )


# CLEANUP
  detach( CONFIG )
  options(sql.tags=NULL)

