# Time-Rank Duality Applied to Formula 1 and Horse Racing

## Overview
This project explores the concept of time-rank duality in modeling Formula 1 race outcomes and apply the method to horse racing. The time-rank duality combines a probabilistic approach, based on exponential distributions, with a statistical regression model of final rankings to estimate race-winning probabilities. This duality enables the separation of driver and car performance effects. The work in this project is based on the paper [Time-Rank Duality](https://www.sciencedirect.com/science/article/pii/S016517652400154X).

## Rank Estimation of F1
In this project, the results shown in the paper are recalculated. The provided R script estimates the rank probabilities for a list of drivers based on their initial probabilities and bookmaker odds.

### Description
The `RankEstimation.r` script performs rank estimation for a list of racing drivers. It uses initial probability guesses and bookmaker odds to calculate the rank probabilities.

## Simulation R Script
This R script performs a series of statistical simulations and optimizations. The main steps involve generating random probabilities, normalizing them, optimizing initial guesses using the Residual Sum of Squares (RSS) method, and calculating statistical parameters such as sigma and mu values.

### Steps Performed
1. **Initialization**:
    - Set the seed for reproducibility.
    - Generate a set of random probabilities and normalize them.
    - Create an initial guess of probabilities.

2. **Optimization**:
    - Define an RSS function to calculate the Residual Sum of Squares between predicted and normalized probabilities.
    - Optimize the initial guesses using the `optim` function with different methods, see [SciPy Minimize](https://docs.scipy.org/doc/scipy/reference/generated/scipy.optimize.minimize.html).

3. **Calculations**:
    - Normalize the optimized guesses.
    - Compute the inverse CDF values of the normalized optimized probabilities.
    - Define and calculate the sigma value based on normalized probabilities.
    - Compute the mu values and sum of ranks.

## Horse Racing Data Analysis
This project aims to analyze and clean horse racing data from [Kaggel](https://www.kaggle.com/datasets/hwaitt/horse-racing), with a focus on optimizing win probabilities and understanding the dynamics of horse racing events. The project is divided into two main components:

### Cleaning.ipynb
**Description**: This notebook is dedicated to cleaning and preprocessing the horse racing data.

- **Data Loading**: Reads the raw data from a CSV file into a DataFrame.
- **Missing Data Summary**: Identifies and summarizes columns with missing data.
- **Data Cleaning Steps**:
  - Selects relevant columns.
  - Drops rows with missing values.
  - Converts price strings to floats.
  - Renames columns for better readability.
  - Calculates win probabilities based on the price.
- **Data Saving**: Saves the cleaned data to a new CSV file and splits the data by race ID into separate files.
- **Functions**: Organized into clear, modular functions for easy understanding and maintenance.

**Key Code Sections**:
- Loading and summarizing missing data.
- Cleaning data by handling missing values and converting data types.
- Saving cleaned data and splitting it by race ID.

### SuccessRate.ipynb
**Description**: This notebook analyzes the success rates of horses and normalizes win probabilities.

- **Data Loading**: Loads data from cleaned CSV files.
- **Win Probability Normalization**: Normalizes the implied win probabilities.
- **Initial Guess Optimization**:
  - Generates initial guesses for probabilities.
  - Normalizes these guesses.
- **Residual Sum of Squares (RSS)**: Defines an RSS function to measure the difference between predicted and actual probabilities.
- **Year-wise Analysis**:
  - Reads cleaned data for each year.
  - Stores DataFrames and race IDs for each year.
  - Verifies the uniqueness of race IDs across years.
  - Retrieves DataFrame rows for specific race IDs.

**Key Code Sections**:
- Normalizing win probabilities.
- Generating and normalizing initial guesses.
- Year-wise data loading and verification.
- Success rate of the lowest rank with the probability less or equal than 1.5 is the actual winner of the race.
- Success rate of the horse with the highest probability is the actual winner of the race.

## Installation

1. Clone the repository:
    ```bash
    git clone git@github.com:WassimAlkhalil/Statistical-Analysis-of-Racing-Data.git
    ```
2. Navigate to the project directory:
    ```bash
    cd Statistical-Analysis-of-Racing-Data
    ```
3. Install the required packages:
    ```bash
    pip install -r requirements.txt
    ```
    
## Acknowledgments

Special thanks to [Artur Marschenkulov](https://github.com/ArturMarschenkulov) for his valuable contributions to this project.
