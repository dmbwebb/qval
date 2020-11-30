
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
Rejecting q-values below a threshold, say alpha = 0.05, will control for
the’‘false-discovery rate’’ (FDR). In other words, the probability that
a given significant result is a false positive will then be equal to or
less than 0.05.

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
set.seed(12345)
pval_example <- c(runif(10, 0, 1), runif(2, 0, 0.05))
pval_example
#>  [1] 0.720903896 0.875773193 0.760982328 0.886124566 0.456480960 0.166371785
#>  [7] 0.325095387 0.509224336 0.727705254 0.989736938 0.001726772 0.007618675
q_val(pval_example)
#>  [1] 1.000 1.000 1.000 1.000 1.000 1.000 1.000 1.000 1.000 1.000 0.022 0.044
```
