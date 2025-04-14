## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

library(dunlin)

## -----------------------------------------------------------------------------
rule(A = "a", B = c("c", "d"))

## -----------------------------------------------------------------------------
r <- rule(A = "a", B = c("c", "d"))
reformat(c("a", "c", "d", NA), r)

## -----------------------------------------------------------------------------
r <- rule(A = "a", B = c("c", "d"))
reformat(factor(c("a", "c", "d", NA)), r)

## -----------------------------------------------------------------------------
r <- rule(A = "a", C = NA, B = c("c", "d"))
reformat(factor(c("a", "c", "d", NA)), r)

## -----------------------------------------------------------------------------
r <- rule(A = "a", C = NA, B = c("c", "d"))
reformat(factor(c("a", "c", "d", NA)), r, .na_last = FALSE)

## -----------------------------------------------------------------------------
df1 <- data.frame(
  "char" = c("", "b", NA, "a", "k", "x"),
  "fact" = factor(c("f1", "f2", NA, NA, "f1", "f1"), levels = c("f2", "f1")),
  "logi" = c(NA, FALSE, TRUE, NA, FALSE, NA)
)
df2 <- data.frame(
  "char" = c("a", "b", NA, "a", "k", "x"),
  "fact" = factor(c("f1", "f2", NA, NA, "f1", "f1"))
)

db <- list(df1 = df1, df2 = df2)
attr(db$df1$char, "label") <- "my label"

rule_map <- list(
  df1 = list(
    char = rule("Empty" = "", "B" = "b", "Not Available" = NA),
    fact = rule("F1" = "f1"),
    logi = rule()
  ),
  df2 = list(
    char = rule("Empty" = "", "A" = "a", "Not Available" = NA)
  )
)

res <- reformat(db, rule_map, .na_last = TRUE)
res

## -----------------------------------------------------------------------------
r <- rule(A = "a", B = c("c", "d"), .to_NA = c("x"))
reformat(c("a", "c", "d", NA, "x"), r)

## -----------------------------------------------------------------------------
# With drop = FALSE
obj <- factor(c("a", "c", "d", NA), levels = c("d", "c", "a", "Not used"))
r <- rule(A = "a", B = c("c", "d"))
reformat(obj, r)

# With drop = TRUE
obj <- factor(c("a", "c", "d", NA), levels = c("d", "c", "a", "Not used"))
r <- rule(A = "a", B = c("c", "d"), .drop = TRUE)
reformat(obj, r)

## -----------------------------------------------------------------------------
r <- rule(A = "a", B = c("c", "d"), .to_NA = c("x"), .drop = TRUE)
obj <- factor(c("a", "c", "d", NA, "x", "y"), levels = c("d", "c", "a", "Not used", "x", "y"))

reformat(obj, r)

# Override
reformat(obj, r, .to_NA = "y", .drop = FALSE)

