
# anybadger

<!-- badges: start -->
[![R-CMD-check](https://github.com/lmeninato/anybadger/workflows/R-CMD-check/badge.svg)](https://github.com/lmeninato/anybadger/actions)
[![Codecov test coverage](https://codecov.io/gh/lmeninato/anybadger/branch/master/graph/badge.svg)](https://codecov.io/gh/lmeninato/anybadger?branch=master)
[![CRAN status](https://www.r-pkg.org/badges/version/anybadger)](https://CRAN.R-project.org/package=anybadger)
<!-- badges: end -->

The goal of anybadger is to provide an easy way to create custom project badges in R.

Inspired *heavily* by the Python [anybadge](https://github.com/jongracecox/anybadge/) library.

This is useful in a GitLab CI/CD pipeline where you are behind a proxy and cannot easily use external services to create/store pipeline badges. 

For instance, to add a custom badge in your pipeline using R you could do the following in your `.gitlab-ci.yml` file:

```
script:
  - Rscript -e "remotes::install_github('lmeninato/anybadger')"
  - Rscript -e "anybadger::create_badge('anybadger.svg', label = 'any', value = 'badger')"
artifacts:
  paths:
    - anybadger.svg
```

And then access the raw svg file from GitLab with `%{path}/builds/artifacts/%{branch}/raw/anybadger.svg?job=%{job_name}`.

## Installation

``` r
# this is preferred right now as there is a bug in the first CRAN release
remotes::install_github("lmeninato/anybadger")

# in a few weeks this will be bug-free :)

install.packages("anybadger")
```

## Example

Pipeline badge:

``` r
library(anybadger)

# the easiest way to create a badge
create_badge(tmp, label = "any", value = "badger", color = "fuchsia")

# if you want access to the low level Badge constructor and class:
b <- Badge$new(label = "Pipeline", value = "Passing")
b$create_svg("pipeline_status.svg")
```
