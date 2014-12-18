library(testthat)

tmpl <- "select * from {{TABLE}}"

# VALUES FROM LIST
  sql <- sql_render(tmpl, list(TABLE = "table_1"))
  expect_identical( sql, "select * from table_1" )

# VALUES FROM ENVIRONMENT
  li <- list(TABLE = "table_2")
  env <- as.environment(li)
  sql <- sql_render(tmpl, env )
  expect_identical( sql, "select * from table_2" )


# REPLACE COMMENTS
  tmpl <- "select * from {{TABLE}} --r: where ROWNUM <= {{ROWS}}"
  sql  <- sql_render( tmpl, list(TABLE = "t1", ROWS = 10 ) )
  expect_identical( sql, 'select * from t1  where ROWNUM <= 10' )

# FROM .Global
# debug(sql_render)
  TABLE <- "t2"
  ROWS <- 20
  sql <- sql_render( tmpl )
  message(sql)
  expect_identical( sql, 'select * from t2  where ROWNUM <= 20' )


# FROM search path
  rm( TABLE, ROWS )
  CONFIG <- new.env()
  CONFIG$TABLE <- "t3"
  CONFIG$ROWS  <- 30
  attach(CONFIG, warn.conflicts = FALSE)
  rm(CONFIG)
  sql <- sql_render( tmpl )
  message(sql)
  expect_identical( sql, 'select * from t3  where ROWNUM <= 30')

# CLEANUP
  detach( CONFIG )
