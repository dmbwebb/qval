# IMPORT DATA
qvals <- readxl::read_excel("pvals_results.xlsx") %>% dplyr::select(id = original_sorting_order, pval, qval = bh95_qval)
qvals_sharp <- readxl::read_excel("pvals_results_sharpened.xlsx") %>% dplyr::select(id = original_sorting_order, qval_sharp = bky06_qval)
test_data <- dplyr::full_join(qvals, qvals_sharp, by = "id")

# test_that("multiplication works", {
#   expect_equal(2 * 2, 4)
# })

test_that("qval matches test data (SHARPENED)", {

  function_results <- q_val(test_data$pval, sharpened = TRUE)
  data_results <- test_data$qval_sharp

  n_bugs <-sum(abs(function_results - data_results) > 0.0001)

  expect_equal(n_bugs, 0)
})


test_that("qval matches test data (UNSHARPENED)", {

  function_results <- q_val(test_data$pval, sharpened = FALSE)
  data_results <- test_data$qval

  n_bugs <-sum(abs(function_results - data_results) > 0.0001)

  expect_equal(n_bugs, 0)
})


