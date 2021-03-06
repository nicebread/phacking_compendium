% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/exploitCovariates.R
\name{.covhack}
\alias{.covhack}
\title{P-Hacking function for multiple covariates}
\usage{
.covhack(
  df,
  dv,
  group,
  covs,
  interactions = FALSE,
  strategy = "firstsig",
  alpha = 0.05
)
}
\arguments{
\item{df}{Data frame with one group variable, one dependent variable, and one or more covariates}

\item{dv}{Integer defining the location of the dependent variable column}

\item{group}{Integer defining the location of the group variable column}

\item{covs}{Numeric vector defining the location of the covariate(s).}

\item{interactions}{Should interaction terms be added to the ANCOVA models? TRUE/FALSE}

\item{strategy}{String value: One out of "firstsig", "smallest", "smallest.sig"}

\item{alpha}{Significance level of the t-test}
}
\description{
Outputs a p-hacked p-value and a vector of all p-values that were computed in the process
}
