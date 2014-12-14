

sql = "SELECT * FROM {{TABLE}}"


expect_identical(
  sql_render(sql, list(TABLE = "table_1")),
  "SELECT * FROM table_1"
)

expect_identical(
  sql_render(sql, list(TABLE = "table_2")),
  "SELECT * FROM table_2"
)
