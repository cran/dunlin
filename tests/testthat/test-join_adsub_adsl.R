adsl <- tibble::tibble(
  USUBJID = c("S1", "S2", "S3", "S4"),
  STUDYID = "My_study",
  AGE = c(60, 44, 23, 31)
)

adsub <- tibble::tibble(
  USUBJID = c("S1", "S2", "S3", "S4", "S1", "S2", "S3", "S99"),
  STUDYID = "My_study",
  PARAM = c("weight", "weight", "weight", "weight", "height", "height", "height", "weight"),
  PARAMCD = c("w", "w", "w", "w", "h", "h", "h", "w"),
  AVAL = c(98, 75, 70, 71, 182, 155, 152, 50),
  AVALC = c(">80", "<=80", "<=80", "<=80", ">180", "<=180", "<=180", "<=80")
)

ldb <- list(adsl = adsl, adsub = adsub)

# join_adsub_adsl.list ---

test_that("join_adsub_adsl.list works as expected with default values", {
  res <- expect_silent(join_adsub_adsl(adam_db = ldb))
  checkmate::expect_list(res, types = "data.frame", len = 2)
  checkmate::expect_names(names(res$adsl), identical.to = c("USUBJID", "STUDYID", "AGE", "w", "h", "w_CAT", "h_CAT"))
  expect_identical(attr(res$adsl$w, "label"), "weight")
  expect_identical(attr(res$adsl$w_CAT, "label"), "weight")
})

test_that("join_adsub_adsl.list works as expected when no column is selected", {
  res <- expect_silent(join_adsub_adsl(adam_db = ldb, continuous_var = NULL))
  checkmate::expect_list(res, types = "data.frame", len = 2)
  checkmate::expect_names(names(res$adsl), identical.to = c("USUBJID", "STUDYID", "AGE", "w_CAT", "h_CAT"))

  res <- expect_silent(join_adsub_adsl(adam_db = ldb, categorical_var = NULL))
  checkmate::expect_list(res, types = "data.frame", len = 2)
  checkmate::expect_names(names(res$adsl), identical.to = c("USUBJID", "STUDYID", "AGE", "w", "h"))

  res <- expect_silent(join_adsub_adsl(adam_db = ldb, continuous_var = NULL, categorical_var = NULL))
  checkmate::expect_list(res, types = "data.frame", len = 2)
  checkmate::expect_names(names(res$adsl), identical.to = c("USUBJID", "STUDYID", "AGE"))
})

test_that("join_adsub_adsl.list throw a warning when column already exist in adsl.", {
  ldb$adsl <- ldb$adsl %>%
    mutate(h = 160)

  expect_warning(join_adsub_adsl(adam_db = ldb), "h already exist in adsl, the name will default to another values")
})

test_that("join_adsub_adsl.list throw a warning the required column doesn't exist.", {
  adsub <- tibble::tibble(
    USUBJID = c("S1", "S2", "S3", "S4", "S1", "S2", "S3", "S99"),
    STUDYID = "My_study",
    PARAM = c("sex", "sex", "sex", "sex", "height", "height", "height", "sex"),
    PARAMCD = c("s", "s", "s", "s", "h", "h", "h", "s"),
    AVAL = c(NA, NA, NA, NA, 182, 155, 152, NA),
    AVALC = c("F", "F", "F", "M", ">180", "<=180", "<=180", "M")
  )

  ldb <- list(adsl = adsl, adsub = adsub)

  expect_warning(
    join_adsub_adsl(adam_db = ldb),
    "Dropping s for Continuous type, No data available. Adjust `continuous_var` argument to silence this warning."
  )
})

test_that("join_adsub_adsl.list works with factor PARAM and PARAMCD column.", {
  adsub <- tibble::tibble(
    USUBJID = c("S1", "S2", "S3", "S4", "S1", "S2", "S3", "S99"),
    STUDYID = "My_study",
    PARAM = factor(c("weight", "weight", "weight", "weight", "height", "height", "height", "weight")),
    PARAMCD = factor(c("w", "w", "w", "w", "h", "h", "h", "w")),
    AVAL = c(98, 75, 70, 71, 182, 155, 152, 50),
    AVALC = c(">80", "<=80", "<=80", "<=80", ">180", "<=180", "<=180", "<=80")
  )

  ldb <- list(adsl = adsl, adsub = adsub)

  expect_silent(
    res <- join_adsub_adsl(adam_db = ldb)
  )

  checkmate::expect_list(res, types = "data.frame", len = 2)
  checkmate::expect_names(names(res$adsl), identical.to = c("USUBJID", "STUDYID", "AGE", "w", "h", "w_CAT", "h_CAT"))
  expect_identical(attr(res$adsl$w, "label"), "weight")
  expect_identical(attr(res$adsl$w_CAT, "label"), "weight")
})

test_that("join_adsub_adsl.list keep all NA columns if drop_na = FALSE.", {
  adsub <- tibble::tibble(
    USUBJID = c("S1", "S2", "S3", "S4", "S1", "S2", "S3", "S99"),
    STUDYID = "My_study",
    PARAM = c("sex", "sex", "sex", "sex", "height", "height", "height", "sex"),
    PARAMCD = c("s", "s", "s", "s", "h", "h", "h", "s"),
    AVAL = c(NA, NA, NA, NA, 182, 155, 152, NA),
    AVALC = c("F", "F", "F", "M", ">180", "<=180", "<=180", "M")
  )

  ldb <- list(adsl = adsl, adsub = adsub)

  expect_silent(
    res <- join_adsub_adsl(adam_db = ldb, drop_na = FALSE)
  )

  expect_true(all(is.na(res$adsl$s)))
})

test_that("join_adsub_adsl.list works with empty strings", {
  adsub <- tibble::tibble(
    USUBJID = c("S1", "S2", "S3", "S4", "S1", "S2", "S3", "S99"),
    STUDYID = "My_study",
    PARAM = factor(c("weight", "weight", "weight", "weight", "height", "height", "height", "weight")),
    PARAMCD = factor(c("w", "w", "w", "w", "h", "h", "h", "w")),
    AVAL = c(98, 75, 70, 71, 182, 155, 152, 50),
    AVALC = c("", "", "", "", ">180", "<=180", "<=180", "")
  )

  ldb <- list(adsl = adsl, adsub = adsub)

  expect_warning(
    res <- join_adsub_adsl(adam_db = ldb),
    "Dropping w for Categorical type, No data available."
  )

  checkmate::expect_list(res, types = "data.frame", len = 2)
  checkmate::expect_names(names(res$adsl), identical.to = c("USUBJID", "STUDYID", "AGE", "w", "h", "h_CAT"))
  expect_identical(attr(res$adsl$w, "label"), "weight")
})

test_that("join_adsub_adsl.list works with factor AVALC column.", {
  adsub <- tibble::tibble(
    USUBJID = c("S1", "S2", "S3", "S4", "S1", "S2", "S3", "S99"),
    STUDYID = "My_study",
    PARAM = factor(c("weight", "weight", "weight", "weight", "height", "height", "height", "weight")),
    PARAMCD = factor(c("w", "w", "w", "w", "h", "h", "h", "w")),
    AVAL = c(98, 75, 70, 71, 182, 155, 152, 50),
    AVALC = factor(c(">80", "<=80", "<=80", "<=80", ">180", "<=180", "<=180", "<=80"))
  )

  ldb <- list(adsl = adsl, adsub = adsub)

  expect_silent(
    res <- join_adsub_adsl(adam_db = ldb, drop_lvl = FALSE)
  )

  checkmate::expect_list(res, types = "data.frame", len = 2)
  checkmate::expect_names(names(res$adsl), identical.to = c("USUBJID", "STUDYID", "AGE", "w", "h", "w_CAT", "h_CAT"))
  expect_identical(attr(res$adsl$w, "label"), "weight")
  expect_identical(attr(res$adsl$w_CAT, "label"), "weight")
})

test_that("join_adsub_adsl.list works with factor AVALC column and drop_lvl = TRUE.", {
  adsub <- tibble::tibble(
    USUBJID = c("S1", "S2", "S3", "S4", "S1", "S2", "S3", "S99"),
    STUDYID = "My_study",
    PARAM = factor(c("weight", "weight", "weight", "weight", "height", "height", "height", "weight")),
    PARAMCD = factor(c("w", "w", "w", "w", "h", "h", "h", "w")),
    AVAL = c(98, 75, 70, 71, 182, 155, 152, 50),
    AVALC = factor(c(">80", "<=80", "<=80", "<=80", ">180", "<=180", "<=180", "<=80"))
  )

  ldb <- list(adsl = adsl, adsub = adsub)

  expect_silent(
    res <- join_adsub_adsl(adam_db = ldb, drop_lvl = TRUE)
  )

  checkmate::expect_list(res, types = "data.frame", len = 2)
  checkmate::expect_names(names(res$adsl), identical.to = c("USUBJID", "STUDYID", "AGE", "w", "h", "w_CAT", "h_CAT"))
  expect_identical(attr(res$adsl$w, "label"), "weight")
  expect_identical(attr(res$adsl$w_CAT, "label"), "weight")
  checkmate::expect_factor(res$adsl$w_CAT, levels = c("<=80", ">80"))
  checkmate::expect_factor(res$adsl$h_CAT, levels = c("<=180", ">180"))
})
