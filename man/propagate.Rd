% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/propagate.R
\name{propagate}
\alias{propagate}
\alias{propagate.list}
\title{Propagate Column}
\usage{
propagate(db, from, add, by, safe = TRUE)

\method{propagate}{list}(db, from, add, by, safe = TRUE)
}
\arguments{
\item{db}{(\code{list} of \code{data.frame}) object for which some variable need to be propagated.}

\item{from}{(\code{string}) the name of the table where the variables to propagate are stored.}

\item{add}{(\code{character}) the names of the variables to propagate.}

\item{by}{(\code{character}) the key binding the \code{from} table to the other tables.}

\item{safe}{(\code{flag}) should the key be checked for uniqueness in the \code{from} table.}
}
\value{
updated \code{list} of \code{data.frame}.
}
\description{
\code{propagate}copy columns from a given table of a \code{list} of \code{data.frame} to all tables based on other
common columns. If several rows are associated with the same key, the rows will be duplicated in the receiving
tables. In safe mode, the key must be unique in the original table.
}
\examples{
df1 <- data.frame(
  id1 = c("a", "a", "c", "d", "e", "f"),
  id2 = c("A", "B", "A", "A", "A", "A"),
  int = c(1, 2, 3, 4, 5, 6),
  bool = c(TRUE, FALSE, TRUE, FALSE, TRUE, FALSE)
)

df2 <- data.frame(
  id1 = c("a", "a", "d", "e", "f", "g"),
  id2 = c("A", "B", "A", "A", "A", "A")
)

df3 <- data.frame(
  id1 = c("a", "c", "d", "e", "f", "x"),
  id2 = c("A", "A", "A", "A", "B", "A"),
  int = c(11, 22, 33, 44, 55, 66)
)

db <- list(df1 = df1, fd2 = df2, df3 = df3)
propagate(db, from = "df1", add = c("int", "bool"), by = c("id1", "id2"))

}
