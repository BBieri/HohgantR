
<!-- README.md is generated from README.Rmd. Please edit that file -->

# HohgantR <img src="man/figures/logo.png" align="right" height="138" />

<!-- badges: start -->

[![forthebadge](https://forthebadge.com/images/badges/works-on-my-machine.svg)](https://forthebadge.com)
[![](https://img.shields.io/badge/devel%20version-0.0.1-blue.svg)](https://github.com/BBieri/HohgantR)
[![](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

The goal of HohgantR is to serve as a toolbox filled with all the
miscellaneous functions that might be useful one day, or not…

## Installation

You can install the latest version of HohgantR from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("BBieri/HohgantR")
```

A release on CRAN is not planned as the package is intended to serve as
a “cabinet de curiosités” of R functions.

## Slope charts à la Tufte

A `{ggplot2}` graphing function inspired by and updated from [this great
package](https://github.com/leeper/slopegraph).

``` r
library(HohgantR)
HohgantR::indicators_long |>
dplyr::filter(indicator == "Indicator") |> # Filter by indicator if necessary
ggslope(year, value, DisaggregationLevel)  # Plot things
```

<img src="man/figures/README-ggslopeexample-1.png" width="100%" />

## Bernie’s theme

A `{ggplot2}` theme for Bernie’s blog.

``` r
library(HohgantR)
library(tidyverse)
#> Warning: package 'tidyverse' was built under R version 4.2.2
#> Warning in Sys.timezone(): unable to identify current timezone 'C':
#> please set environment variable 'TZ'
#> Warning: package 'ggplot2' was built under R version 4.2.2
#> Warning: package 'readr' was built under R version 4.2.2
#> Warning: package 'stringr' was built under R version 4.2.2
# Prepare data
cty_mpg <- aggregate(mpg$cty, by = list(mpg$manufacturer), FUN = mean)
colnames(cty_mpg) <- c("make", "mileage") # change column names
cty_mpg <- cty_mpg[order(cty_mpg$mileage), ] # sort
cty_mpg$make <- factor(cty_mpg$make, levels = cty_mpg$make)
# Plot
ggplot(cty_mpg, aes(x = make, y = mileage)) +
  geom_segment(aes(
    x = make,
    xend = make,
    y = 0,
    yend = mileage
  ), color = "white") +
  geom_point(size = 3, color = "orange") +
  labs(
    title = "Lollipop Chart",
    subtitle = "Make Vs Avg. Mileage",
    caption = "source: mpg"
  ) +
  HohgantR::themebernie() +
  theme(axis.text.x = element_text(angle = 65, vjust = 0.6))
```

<img src="man/figures/README-berniestheme-1.png" width="100%" />

## Mineral theme

A `{ggplot2}` theme inspired by minerals.

``` r
library(HohgantR)
library(tidyverse)
# Prepare data
cty_mpg <- aggregate(mpg$cty, by = list(mpg$manufacturer), FUN = mean)
colnames(cty_mpg) <- c("make", "mileage") # change column names
cty_mpg <- cty_mpg[order(cty_mpg$mileage), ] # sort
cty_mpg$make <- factor(cty_mpg$make, levels = cty_mpg$make)
# Plot
ggplot(cty_mpg, aes(x = make, y = mileage)) +
  geom_segment(aes(
    x = make,
    xend = make,
    y = 0,
    yend = mileage
  ), color = "white") +
  geom_point(size = 3, color = "#C3CED6") +
  labs(
    title = "Lollipop Chart",
    subtitle = "Make Vs Avg. Mileage",
    caption = "source: mpg"
  ) +
  HohgantR::thememineral() +
  theme(axis.text.x = element_text(angle = 65, vjust = 0.6))
```

<img src="man/figures/README-mineraltheme-1.png" width="100%" />
