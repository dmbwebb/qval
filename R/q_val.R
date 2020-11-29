#' Calculate FDR-adjusted q-values from a vector of p-values
#'
#' @param p_vals Numerical vector with the p values to calculate from
#' @param q_res Defaults to 0.001, the resolution of the resulting q value
#' @param sharpened Logical, if TRUE then uses sharpened q values calculation
#'
#' @return
#' @export
#'
#' @examples
q_val <- function(p_vals, q_res = 0.001, sharpened = TRUE) {

  rank_p <- data.table::frank(p_vals, ties.method = "first")
  M <- length(p_vals)

  q_vals <- seq(0, 1, q_res)

  # print("Computing sharpened q-value set")

  # UNSHARPENED
  if (!sharpened) {
    q_val_df <- tibble::tibble(
      val_id = rep(1:length(p_vals), times = length(q_vals)),
      p = rep(p_vals, times = length(q_vals)),
      rank_p = rep(rank_p, times = length(q_vals)),
      q = rep(q_vals, each = length(p_vals))
    ) %>%
      dplyr::mutate(
        fdr_temp = q * rank_p / length(p_vals),
        reject_temp = p <= fdr_temp,
        reject_rank = reject_temp * rank_p
      ) %>%
      dplyr::group_by(q) %>%
      dplyr::mutate(reject = rank_p <= max(reject_rank)) %>%
      dplyr::ungroup()
  } else if (sharpened) {
    q_val_df <- tibble::tibble(
      val_id = rep(1:length(p_vals), times = length(q_vals)),
      p = rep(p_vals, times = length(q_vals)),
      rank_p = rep(rank_p, times = length(q_vals)),
      q = rep(q_vals, each = length(p_vals))
    ) %>%
      dplyr::mutate(
        q_prime = q / (1 + q),
        fdr_temp = q_prime * rank_p / length(p_vals),
        reject_temp = p <= fdr_temp,
        reject_rank = reject_temp * rank_p
      ) %>%
      dplyr::group_by(q) %>%
      dplyr::mutate(reject_final = rank_p <= max(reject_rank),
             n_hyp_rejected = sum(reject_final)) %>%
      dplyr::ungroup() %>%

      # Sharpened second step
      dplyr::mutate(
        M_new = M - n_hyp_rejected,
        q_star = q_prime * M / M_new
      ) %>%
      dplyr::mutate(
        fdr_temp_sharp = q_star * rank_p / length(p_vals),
        reject_temp_sharp = p <= fdr_temp_sharp,
        reject_rank_sharp = reject_temp_sharp * rank_p
      ) %>%
      dplyr::group_by(q) %>%
      dplyr::mutate(reject_final_sharp = rank_p <= max(reject_rank_sharp)) %>%
      dplyr::ungroup() %>%
      # Choose which reject to return
      dplyr::mutate(reject = dplyr::if_else(n_hyp_rejected == 0, reject_final, reject_final_sharp),
             reject = dplyr::if_else(q == 1, TRUE, reject)) # always reject at 1
  }

  return_q <- q_val_df %>% # Return the minimum q for each one
    dplyr::filter(reject) %>%
    dplyr::group_by(val_id) %>%
    dplyr::summarise(q = min(q), .groups = "drop") %>%
    .$q

  return(return_q)


}
