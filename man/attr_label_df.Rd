% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils.R
\name{attr_label_df}
\alias{attr_label_df}
\title{Setting the Label Attribute to Data Frame Columns}
\usage{
attr_label_df(df, label)
}
\arguments{
\item{df}{(\code{data.frame}).}

\item{label}{(\code{character}) the labels to add.}
}
\value{
\code{data.frame} with label attributes.
}
\description{
Setting the Label Attribute to Data Frame Columns
}
\examples{
res <- attr_label_df(mtcars, letters[1:11])
res
lapply(res, attr, "label")
}
