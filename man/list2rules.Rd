% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rules.R
\name{list2rules}
\alias{list2rules}
\title{Convert nested list into list of \code{rule}}
\usage{
list2rules(obj)
}
\arguments{
\item{obj}{(\verb{nested list}) to convert into list of rules.}
}
\value{
a \code{list} of \code{rule} objects.
}
\description{
Convert nested list into list of \code{rule}
}
\examples{
obj <- list(
  rule1 = list("X" = c("a", "b"), "Z" = "c", .to_NA = "xxxx"),
  rule2 = list(Missing = c(NA, "")),
  rule3 = list(Missing = c(NA, ""), .drop = TRUE),
  rule4 = list(Absent = c(NA, ""), .drop = TRUE, .to_NA = "yyyy")
)
list2rules(obj)

}
