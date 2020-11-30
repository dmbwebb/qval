
<!-- README.md is generated from README.Rmd. Please edit that file -->

# qval

<!-- badges: start -->

<!-- badges: end -->

<!-- https://www.tandfonline.com/doi/abs/10.1198/016214508000000841 -->

If you test multiple hypotheses at once, then you risk getting false
positives. One way of dealing with this problem is by adjusting the
p-values of your results to account for the fact that you’ve run
multiple hypotheses. This package takes a vector of p-values, and
outputs a vector of ‘’q-values’‘, in the style of [Anderson
(2008)](https://www.tandfonline.com/doi/abs/10.1198/016214508000000841).
Rejecting q-values below a threshold, say $ = 0.05 $, will control for
the’‘false-discovery rate’’ (FDR). In other words, the probability that
a given significant result is a false positive will be equal to or less
than $ $.

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("dmbwebb/qval")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(qval)
pval_example <- c(runif(10, 0, 1), runif(2, 0, 0.05))
q_val(pval_example)
#>  [1] 1.000 1.000 1.000 1.000 1.000 1.000 1.000 1.000 1.000 1.000 0.003 0.360
```
