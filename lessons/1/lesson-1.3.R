###############################################################################
# Lesson 3: Advanced Data Cleaning & Text Handling in R
#
# Author: Petr Čala
# Date: 2025-02-26
#
# Lesson 3 Notebook
#
# In previous lessons, you learned:
# - Lesson 1: Reading datasets, cleaning basics, simple EDA.
# - Lesson 2: Reshaping, merging data, intro to SQL in R.
#
# Now, we’ll explore:
# - More advanced data cleaning techniques
# - Text processing (common in journalism)
# - A mini-project to tie it all together
#
# Topics:
# 1. Advanced Data Cleaning & Validation
# 2. Handling & Cleaning Text Data
# 3. Combining Data Wrangling & SQL
# 4. Mini Workflow / Capstone Example
# 5. Looking Ahead & Thesis Tips
###############################################################################


###############################################################################
# 1. Advanced Data Cleaning & Validation
#
# In Lesson 1, we covered missing values, renaming, and basic type conversion.
# Real-world data might have inconsistent formats, typos, outliers, or invalid
# values. We'll look at approaches to handle these issues.
#
# 1.1 Revisiting the df from Lesson 1 (or a new data set)
# We simulate a dataset (df) with issues:
#  - String inconsistencies (capitalization)
#  - Out-of-range values
#  - Whitespace or strange characters
###############################################################################

# Load needed packages
library(tidyverse)

# Suppose we have a small example simulating these issues
df <- data.frame(
  ID = 1:6,
  Department = c("Marketing ", "MARKETING", "Sales", "sales", "Sales ", "IT "),
  Age = c(25, 200, 30, NA, 28, 45),
  Comment = c("  Great Employee ", "N/A", "excellent worker", "??", "n/a", "    "),
  stringsAsFactors = FALSE
)

df


###############################################################################
# 1.2 Dealing with Inconsistent Text
#
# We can trim whitespace, convert to lowercase/title case, replace placeholders
# ("N/A", "n/a", "?") with actual NA, etc.
###############################################################################

# Stringr (part of tidyverse) is useful for text manipulations
library(stringr)

df_clean <- df %>%
  mutate(
    # Trim whitespace
    Department = str_trim(Department),

    # Convert to proper case or consistent case
    Department = str_to_title(Department),

    # Replace "N/A", "n/a", "??" with NA in Comment
    Comment = na_if(Comment, "N/A"),
    Comment = na_if(Comment, "n/a"),
    Comment = na_if(Comment, "??"),

    # Trim whitespace in Comment
    Comment = str_trim(Comment),

    # If Comment is just empty string, treat as NA
    Comment = ifelse(Comment == "", NA, Comment)
  )

df_clean


###############################################################################
# 1.3 Validating Numeric Ranges
#
# Suppose Age should never exceed 120. We can flag or fix out-of-range values.
###############################################################################

df_clean <- df_clean %>%
  mutate(
    Age = ifelse(Age > 120, NA, Age) # treat out-of-range as NA
  )

df_clean

# Additional validation packages: "validate", "assertr"
# They allow you to define validation rules, e.g. Age >= 0 & Age <= 120.


###############################################################################
# 2. Handling and Cleaning Text Data
#
# Journalists often deal with text-heavy data: articles, transcripts, tweets.
# R provides stringr, tidytext, etc.
#
# 2.1 Basic Stringr Operations
# - str_detect(text, pattern)
# - str_replace_all(text, pattern, replacement)
# - str_split(text, pattern)
###############################################################################

# Simple example: searching & replacing in a column
text_data <- data.frame(
  ID = 1:4,
  Tweet = c(
    "This is #awesome!",
    "Check out https://example.com for details",
    "Breaking news: R is amazing???",
    "Email me at test@example.com."
  ),
  stringsAsFactors = FALSE
)

text_data


###############################################################################
# Removing URLs or Email Addresses (mask them in the text)
###############################################################################

# nolint start: nonportable_file_linter
text_clean <- text_data %>%
  mutate(
    # Replace URLs with [LINK]
    Tweet = str_replace_all(Tweet, "http\\S+", "[LINK]"),

    # Replace email addresses with [EMAIL]
    Tweet = str_replace_all(Tweet, "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}", "[EMAIL]")
  )
# nolint end: nonportable_file_linter


###############################################################################
# 2.2 Tidytext Basics
#
# For tokenization (splitting into words), stopword removal, word frequencies:
# library(tidytext)
#
# text_tokens <- text_clean %>%
#   unnest_tokens(output = "word", input = "Tweet")
#
# text_tokens %>% count(word, sort = TRUE)
#
# Then filter stopwords, compare top terms, etc.
###############################################################################


###############################################################################
# 3. Combining Data Wrangling and SQL
#
# You can use both dplyr/stringr for specialized wrangling and SQL queries
# for large data filtering or aggregation.
#
# 3.1 Example: Clean + Query
###############################################################################

library(sqldf)

# 1. Suppose we have a data frame with messy text/numeric issues
df_example <- data.frame(
  user_id = 1:5,
  status = c("Active", "active", "inactive", "unknown", "ACTIVE"),
  score = c(50, 80, 90, NA, 120),
  stringsAsFactors = FALSE
)

# 2. Clean status text, set out-of-range score to NA
df_example <- df_example %>%
  mutate(
    status = str_to_lower(status),
    status = ifelse(status == "unknown", NA, status),
    score  = ifelse(score > 100, NA, score)
  )

# 3. Query using sqldf
sqldf("SELECT user_id, status, score FROM df_example WHERE score >= 60")


###############################################################################
# 4. Mini Workflow / Capstone Example
#
# A conceptual mini-project:
# 1. Import a dataset of news articles (articles.csv)
# 2. Clean text (remove URLs, standardize capitalization, handle placeholders)
# 3. Join w/ category lookup
# 4. Explore text frequencies (tidytext)
# 5. (Optional) Store in SQLite, do queries
# 6. Visualize top words/categories
# 7. Export final cleaned dataset
###############################################################################

# Example Pseudocode:
# articles <- read_csv("articles.csv")
# lookup   <- read_csv("category_lookup.csv")
#
# articles <- articles %>%
#   mutate(
#     title   = str_to_title(title),
#     content = str_replace_all(content, "http[^\"]+", "[LINK]"),
#     content = str_trim(content),
#     content = ifelse(content == "", NA, content)
#   )
#
# articles_joined <- left_join(articles, lookup, by = "category")
#
# library(tidytext)
# tokenized <- articles_joined %>%
#   unnest_tokens(word, content)
#
# sqldf("SELECT descriptive_category, COUNT(*) as count FROM tokenized GROUP BY descriptive_category")
#
# tokenized %>%
#   count(word, sort = TRUE) %>%
#   filter(n > 50) %>%
#   ggplot(aes(x = reorder(word, n), y = n)) +
#   geom_col() +
#   coord_flip() +
#   labs(title = "Most Common Words", x = "Word", y = "Count")
#
# write_csv(articles_joined, "articles_cleaned.csv")


###############################################################################
# 5. Looking Ahead & Thesis Tips
#
# 1. Text Data: Keep practicing stringr, tidytext.
# 2. SQL: Consider DB approach for large data. Use DBI or sqldf.
# 3. Validation: Tools like validate, assertr ensure data quality.
# 4. Reproducibility: Use R Markdown or Quarto for reproducible reporting.
# 5. Version Control: Use Git for collaboration and version history.
#
# You've now seen a robust toolkit: importing, cleaning, reshaping,
# merging, text processing, and SQL in R—valuable for data-driven journalism.
#
# End of Lesson 3
###############################################################################
