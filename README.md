
# anybadger

<!-- badges: start -->
[![R-CMD-check](https://github.com/lmeninato/anybadger/workflows/R-CMD-check/badge.svg)](https://github.com/lmeninato/anybadger/actions)
[![Codecov test coverage](https://codecov.io/gh/lmeninato/anybadger/branch/master/graph/badge.svg)](https://codecov.io/gh/lmeninato/anybadger?branch=master)
<!-- badges: end -->

The goal of anybadger is to provide an easy way to create custom project badges in R.

Inspired *heavily* by the Python [anybadge](https://github.com/jongracecox/anybadge/).

## Installation

``` r
remotes::install_github("lmeninato/anybadger")
```

## Example

Pipeline badge:

``` r
library(anybadger)
b <- Badge$new(label = "Pipeline", value = "Passing")
b$create_svg("pipeline_status.svg")
```
