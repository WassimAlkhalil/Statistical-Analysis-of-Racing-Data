library(knitr)
library(stats)

set.seed(123)

random_probs <- c(0.5875775, 0.4663081, 0.2089868, 0.0763001, 0.0840574, 0.0433435, 0.0227104, 0.068231, 0.0641339, 0.0395554)
normalized_probs <- random_probs / sum(random_probs)
initial_guess <- runif(10)

rss_function <- function(initial_guess, normalized_probs) {
  predicted_probabilities <- initial_guess / sum(initial_guess)
  rss <- sum((predicted_probabilities - normalized_probs)^2)
  return(rss)
}

initial_rss <- rss_function(initial_guess, normalized_probs)
result <- optim(
  par = initial_guess,
  fn = rss_function,
  normalized_probs = normalized_probs,
  method = "L-BFGS-B",
  lower = rep(0, length(initial_guess))
)
optimized_initial_guess <- result$par
Normalized_Optimized_Values <- optimized_initial_guess / sum(optimized_initial_guess)
qnorm_values <- qnorm(Normalized_Optimized_Values)

sigma <- function(p) {
  n <- length(p)
  numerator <- n - (n^2 / 2)
  denominator <- sum(qnorm(p))
  sigma <- numerator / denominator
  return(sigma)
}
sigma_value <- sigma(normalized_probs)
mu <- 1.5 - sigma_value * qnorm_values
sum_ranks <- 1.5 * length(normalized_probs) - (sigma_value * sum(qnorm_values))
expected_sum_ranks <- sum(1.5 - (sigma_value * qnorm_values))

cat(sprintf(
  "Sum of Random Probabilities: %.10f\nSum of Normalized Probabilities: %.10f\nSum of Initial Guesses: %.10f\nRSS before optimization: %.10f\nRSS after optimization: %.10f\nSum of Optimized Probabilities: %.10f\nSum of Normalized Optimized Probabilities: %.10f\nSigma value: %.10f\nSum of Mu values: %.10f\nSum of ranks: %.10f\nExpected sum of ranks: %.10f\n",
  sum(random_probs),
  sum(normalized_probs),
  sum(initial_guess),
  initial_rss,
  result$value,
  sum(optimized_initial_guess),
  sum(Normalized_Optimized_Values),
  sigma_value,
  sum(mu),
  sum_ranks,
  expected_sum_ranks
))

output_table <- data.frame(
  "Random_Probabilities" = random_probs,
  "Normalized_Probabilities" = normalized_probs,
  "Initial_Guess" = initial_guess,
  "Optimized_Intial_Guess" = optimized_initial_guess,
  "Normalized_Optimized_Values" = Normalized_Optimized_Values,
  "Inverse_CDF" = qnorm_values,
  "Mu_i" = mu 
)

print(kable(output_table, format = "pipe"))
