
# anybadger

<!-- badges: start -->
[![CircleCI build status](https://circleci.com/gh/lmeninato/anybadger.svg?style=svg)](https://circleci.com/gh/lmeninato/anybadger)
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
