% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rules.R
\name{rule}
\alias{rule}
\title{Create rule based on mappings}
\usage{
rule(
  ...,
  .lst = list(...),
  .string_as_fct = TRUE,
  .na_last = TRUE,
  .drop = FALSE,
  .to_NA = ""
)
}
\arguments{
\item{...}{Mapping pairs, the argument name is the transformed while
its values are original values.}

\item{.lst}{(\code{list}) of mapping.}

\item{.string_as_fct}{(\code{flag}) whether to convert characters to factors.}

\item{.na_last}{(\code{flag})  whether the level replacing \code{NA} should be last.}

\item{.drop}{(\code{flag}) whether to drop empty levels.}

\item{.to_NA}{(\code{character}) values that should be converted to \code{NA}. Set to \code{NULL} if nothing should be converted to
\code{NA}.}
}
\value{
a \code{rule} object.
}
\description{
Create rule based on mappings
}
\note{
Conversion to \code{NA} is the last step of the remapping process.
}
\examples{
rule("X" = "x", "Y" = c("y", "z"))
rule("X" = "x", "Y" = c("y", "z"), .drop = TRUE, .to_NA = c("a", "b"), .na_last = FALSE)

}
