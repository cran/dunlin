# assert_one_tablenames ----

test_that("assert_one_tablenames works as expected", {
  df <- list(mtcars = mtcars, iris = iris)

  expect_silent(
    assert_one_tablenames(
      df,
      c("mtcars"),
      qualifier = "first test:"
    )
  )

  expect_silent(
    assert_one_tablenames(
      df,
      c("iris", "haha"),
      qualifier = "first test:"
    )
  )

  expect_error(
    assert_one_tablenames(
      df,
      c("haha", "hoho"),
      qualifier = "first test:"
    ),
    "first test: At least one of: haha, hoho is expected to be a table name of df"
  )

  expect_error(
    assert_one_tablenames(
      df,
      c("haha", "hoho")
    ),
    "At least one of: haha, hoho is expected to be a table name of df"
  )
})

# assert_all_tablenames ----

test_that("assert_all_tablenames works as expected", {
  df <- list(mtcars = mtcars, iris = iris)

  expect_silent(
    assert_all_tablenames(
      df,
      c("mtcars"),
      qualifier = "first test:"
    )
  )

  expect_error(
    assert_all_tablenames(
      df,
      c("iris", "haha"),
      qualifier = "first test:"
    ),
    "first test: Expected table names: haha not in df"
  )

  expect_error(
    assert_all_tablenames(
      df,
      c("haha", "hoho"),
      qualifier = "first test:"
    ),
    "first test: Expected table names: haha, hoho not in df"
  )
})

# assert_valid_format ----

test_that("assert_valid_format works as expected", {
  format <- list(
    df1 = list(
      var1 = rule("X" = "x", "N" = c(NA, ""))
    ),
    df2 = list(
      var1 = rule(),
      var2 = rule("f11" = "F11", "NN" = NA)
    )
  )

  expect_silent(res <- assert_valid_format(format))
  expect_true(res)
})

test_that("assert_valid_format fails as expected", {
  format <- list(
    df1 = list(
      var1 = rule("X" = "x", "N" = c(NA, "")),
      var2 = list(),
      var3 = NULL
    ),
    df2 = list(
      var1 = rule(),
      var1 = rule("f11" = "F11", "NN" = NA),
      var2 = rule("f11" = "F11", "f11" = "F12", "NN" = NA)
    ),
    df2 = NULL
  )


  res <- expect_error(capture_output_lines(assert_valid_format(format), width = 200, print = FALSE))
  expect_match(
    res$message,
    "* Variable 'object': Must have unique names, but element 3 is duplicated.",
    fixed = TRUE
  )
  expect_match(
    res$message,
    "* Variable '[df1]': Contains missing values (element 3).",
    fixed = TRUE
  )
  expect_match(
    res$message,
    "* Variable '[df2]': Must have unique names, but element 2 is duplicated.",
    fixed = TRUE
  )
  expect_match(
    res$message,
    "* Variable '[df2]': Must be of type 'list', not 'NULL'.",
    fixed = TRUE
  )
})

# assert_valid_list_format ----

test_that("assert_valid_list_format works as expected", {
  format <- list(
    df1 = list(
      var1 = list("X" = "x", "N" = c(NA, ""))
    ),
    df2 = list(
      var1 = list(),
      var2 = list("f11" = "F11", "NN" = NA)
    )
  )

  expect_silent(res <- assert_valid_list_format(format))
  expect_true(res)
})

test_that("assert_valid_list_format fails as expected", {
  format <- list(
    df1 = list(
      var1 = list("X" = "x", "N" = c(NA, "")),
      var3 = NULL
    ),
    df2 = list(
      var1 = list(),
      var1 = list("f11" = "F11", "NN" = NA),
      var2 = list("f11" = "F11", "f11" = "F12", "NN" = NA, "X" = NULL)
    )
  )

  res <- expect_error(capture_output_lines(assert_valid_list_format(format), width = 200, print = FALSE))
  expect_match(
    res$message,
    "* Variable '[df1]': Contains missing values (element 2).",
    fixed = TRUE
  )
  expect_match(
    res$message,
    "* Variable '[df2]': Must have unique names, but element 2 is duplicated.",
    fixed = TRUE
  )
  expect_match(
    res$message,
    "* Variable '[df1.var3]': Must be of type 'list', not 'NULL'.",
    fixed = TRUE
  )
  expect_match(
    res$message,
    "* Variable '[df2.var2]': Must have unique names, but element 2 is duplicated.",
    fixed = TRUE
  )
})
