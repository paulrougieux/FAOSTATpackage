% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils.R
\name{change_case}
\alias{change_case}
\title{Change case of column names}
\usage{
change_case(
  old_names,
  new_case = c("make.names", "unsanitised", "unsanitized", "snake_case"),
  ...
)
}
\arguments{
\item{old_names}{character. Vector of the names to be changed}

\item{new_case}{character. Choice of new names:
\itemize{
\item make_names - (default) use the \link{make.names} function in R to sanitise names
\item unsanitised/unsanitized - Return names as they are
\item snake_case - Names are converted to lowercase and separators are replaced with underscores
}}

\item{...}{extra arguments to pass to sanitisation function (only works for \link{make.names})}
}
\description{
Columns from FAOSTAT frequently have parentheses and other non-alphanumeric
characters. This suite of functions seeks to give control over these names
for easier data analysis
}
