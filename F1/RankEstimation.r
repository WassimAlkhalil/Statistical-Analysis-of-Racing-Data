# Load necessary libraries
library(knitr)

# Define the drivers and their initial probabilities
drivers <- c(
  "Lewis Hamilton", "George Russell", "Max Verstappen", "Sergio Perez", "Charles Leclerc",
  "Carlos Sainz", "Lando Norris", "Oscar Piastri", "Esteban Ocon", "Pierre Gasly",
  "Fernando Alonso", "Lance Stroll", "Kevin Magnussen", "Nico Hulkenberg", "Yuki Tsunoda",
  "Daniel Ricciardo", "Valtteri Bottas", "Zhou Guanyu", "Alex Albon", "Logan Sargeant"
)

initial_guess <- c(0.0081037902, 0.0081037902, 0.1723897481, 0.0162075831, 0.0081037902,
                   0.0072654675, 0.0162075831, 0.0123940343, 0.0004205564, 0.0004205564,
                   0.0026012171, 0.0004205564, 0.0004205564, 0.0004205564, 0.0004205564,
                   0.0004205564, 0.0004205564, 0.0004205564, 0.0004205564, 0.0004205564)

Bookmakers_odds <- c(25/1, 25/1, 2/9, 12/1, 25/1, 28/1, 12/1, 16/1, 500/1, 500/1, 80/1, rep(500/1, 9))

# Create the data frame
data <- data.frame(
  drivers = drivers,
  initial_guess = initial_guess,
  Bookmakers_odds = Bookmakers_odds
)

# Convert odds to win probabilities
win_probabilities <- 1 / (data$Bookmakers_odds + 1)

# Summarize the probabilities
sum_win_probabilities <- sum(win_probabilities)

# Normalize the probabilities
normalized_probabilities <- win_probabilities / sum_win_probabilities

# Define the RSS function
rss_function <- function(initial_guess, normalized_probabilities) {
  predicted_probabilities <- initial_guess / sum(initial_guess)
  rss <- sum((predicted_probabilities - normalized_probabilities)^2)
  return(rss)
}

# Calculate RSS for the initial guess
initial_rss <- rss_function(data$initial_guess, normalized_probabilities)

# Optimize the initial guess
optimized_result <- optim(
  par = data$initial_guess,
  fn = rss_function,
  normalized_probabilities = normalized_probabilities,
  method = "L-BFGS-B", # Or "Powell", "BFGS"
  lower = rep(0, length(data$initial_guess))
)

# Calculate normalized initial guess and inverse CDF
optimized_initial_guess <- optimized_result$par
normalized_initial_guess <- optimized_initial_guess / sum(optimized_initial_guess)

inverse_cdf <- qnorm(normalized_probabilities)
sum_inverse_cdf <- sum(inverse_cdf)

# Calculate sigma and expected rank
n <- length(normalized_probabilities)
sigma <- (1.5 * n - (n * (n + 1)) / 2) / sum_inverse_cdf
mu <- 1.5 - sigma * inverse_cdf

# Print all information in one cat statement
cat(
  "Sum of win probabilities:", sum_win_probabilities, "\n",
  "Sum of normalized probabilities:", sum(normalized_probabilities), "\n",
  "RSS for initial guess:", sprintf("%.10f", initial_rss), "\n",
  "RSS for optimized initial guess values:", sprintf("%.10f", optimized_result$value), "\n",
  "The sum of the inverse CDF values is:", sum_inverse_cdf, "\n"
)

# Create a data frame with the results
df <- data.frame(
  Driver = data$drivers,
  Win_Probabilities = win_probabilities,
  Normalized_Probabilities = normalized_probabilities,
  Initial_Guess = data$initial_guess,
  Optimized_Initial_Guess = optimized_initial_guess,
  Verifying_Probabilities = normalized_initial_guess,
  Inverse_CDF = inverse_cdf,
  Sigma = sigma,
  Expected_Rank = mu
)

# Print the data frame as a table
kable(df, caption = "Formula 1 Drivers and Probabilities")
