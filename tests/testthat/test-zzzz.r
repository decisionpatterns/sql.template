# test-zzzz.r - clean up tests

context("clean up")
options(sql.tags=NULL)
expect_null( getOption('sql.tags') )
