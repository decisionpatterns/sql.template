library(testthat)
library(sql.template)

context('sql_read')

path = "."
# path <- if( interactive() ) "tests/testthat/" else "."

# readfile
  sql <- sql_read( file.path( path, "select-1.sql") )
  expect_is( sql, 'sql')
  expect_equal( sql, sql("select * from {{TABLE}} --r: where ROWNUM <= {{ROWS}}") )

  sql <- sql_read( file.path( path, "select-2.sql") )
  expect_is( sql, 'sql')
  expect_equal( sql, sql("-- select-2.sql\n\nSELECT\n *\nFROM\n table_1\nWHERE\n    1 = 1\n/*r:\nAND 2=2\nAND 3=3\n*/") )
