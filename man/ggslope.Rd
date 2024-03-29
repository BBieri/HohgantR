% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ggslopegraph.R
\name{ggslope}
\alias{ggslope}
\title{Slope graph for ggplot2}
\source{
Adapted and updated from
\href{https://github.com/leeper/slopegraph}{this great package}.
}
\usage{
ggslope(
  data,
  x,
  y,
  group,
  DataLabel = NULL,
  title = "No title given",
  subtitle = "No subtitle given",
  caption = "No caption given",
  LineThickness = 1,
  LineColor = "ByGroup",
  DataTextSize = 2.5,
  DataTextColor = "black",
  DataLabelPadding = 0.05,
  DataLabelLineSize = 0,
  DataLabelFillColor = "#f5f5f2",
  WiderLabels = FALSE,
  ReverseYAxis = FALSE,
  ReverseXAxis = FALSE,
  RemoveMissing = TRUE
)
}
\arguments{
\item{data}{Data frame containing the data in a long form. Required input.}

\item{x}{The variable on the x axis, usually time, survey wave, etc. Required
input.}

\item{y}{The variable on the y axis, usually an indicator such as poverty and
inequality measures. Required input.}

\item{group}{Grouping variable showing various levels of the indicator.}

\item{DataLabel}{Data label}

\item{title}{Plot title}

\item{subtitle}{Plot subtitle}

\item{caption}{Plot caption}

\item{LineThickness}{Line width}

\item{LineColor}{Line color}

\item{DataTextSize}{Text size of the data point value.}

\item{DataTextColor}{Text color of the data point value.}

\item{DataLabelPadding}{Text padding of the label of each level.}

\item{DataLabelLineSize}{Text label line size.}

\item{DataLabelFillColor}{Text label fill color.}

\item{WiderLabels}{Set wider labels? False by default.}

\item{ReverseYAxis}{Revert Y axis? False by default.}

\item{ReverseXAxis}{Revert X axis? False by default.}

\item{RemoveMissing}{Remove missing values? True by default.}
}
\value{
A pretty slope graph.
}
\description{
Creates a slope graph ideal to use when computing changes in one or more
indicators between waves of a survey or other time series data with
a low number of periods.
}
\examples{
HohgantR::indicators_long |>
dplyr::filter(indicator == "Indicator") |>
ggslope(year, value, unit)

}
