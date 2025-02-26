###############################################################################
# Lesson 2: Data Reshaping, Merging & Introduction to SQL in R
#
# Author: Petr Čala
# Date: 2025-02-26
#
# Lesson 2 Notebook
#
# Welcome to our second 4-hour block! In this lesson, we’ll build on the
# skills from Lesson 1. By the end, you should be comfortable reshaping
# your data (widening/longening), merging multiple data sources, and running
# basic SQL queries directly in R.
#
# Topics:
# 1. Recap & Q&A
# 2. Data Reshaping (Pivoting)
# 3. Data Merging (Joins)
# 4. Introduction to SQL in R
# 5. Wrapping Up with a Real-World Workflow Example
###############################################################################


###############################################################################
# 1. Recap & Q&A
#
# Let’s briefly recap Lesson 1:
# - Installed/loaded the tidyverse and possibly skimr.
# - Learned how to import data, handle missing values, rename columns,
#   convert data types, and do quick EDA.
# - Exported the cleaned data.
#
# Any questions or troubleshooting from Lesson 1? Once you're ready,
# move on to the next section.
###############################################################################


###############################################################################
# 2. Data Reshaping (Pivoting)
#
# Sometimes your data isn’t in the format you need for analysis.
# You may have to pivot from long to wide or vice versa.
# We’ll explore tidyr::pivot_longer() and tidyr::pivot_wider().
#
# 2.1 Example Dataset (Wide to Long)
###############################################################################

# Ensure we have the necessary packages loaded
library(tidyverse)

# Example wide dataset: Survey results from different quarters
set.seed(123)
survey_data <- data.frame(
  RespondentID = 1:5,
  Q1_Score = round(runif(5, 1, 5), 1),
  Q2_Score = round(runif(5, 1, 5), 1),
  Q3_Score = round(runif(5, 1, 5), 1)
)

survey_data


###############################################################################
# 2.2 Pivoting from Wide to Long
#
# Suppose we want to gather these separate quarterly columns (Q1_Score,
# Q2_Score, Q3_Score) into one column indicating the quarter and another
# for the score.
###############################################################################

# Pivot from wide to long using tidyr::pivot_longer
survey_long <- survey_data %>%
  pivot_longer(
    cols = starts_with("Q"), # which columns to pivot
    names_to = "Quarter",
    values_to = "Score"
  )

survey_long


###############################################################################
# 2.3 Pivoting from Long to Wide
#
# To pivot back (or if you have a truly long dataset you want to widen),
# use pivot_wider().
###############################################################################

# Pivot back from long to wide
survey_wide <- survey_long %>%
  pivot_wider(
    names_from = Quarter,
    values_from = Score
  )

survey_wide

# Exercise suggestion:
# 1. Create a new column in your long dataset that identifies which half
#    of the year a quarter belongs to.
# 2. Pivot wide again, grouping by your new half-year variable.


###############################################################################
# 3. Data Merging (Joins)
#
# In Lesson 1, we focused on one dataset. Now we’ll learn how to combine
# multiple datasets using dplyr joins: left_join(), right_join(),
# inner_join(), full_join().
###############################################################################

# Let's create two small data frames that share a key column
dfA <- data.frame(
  ID = 1:5,
  Name = c("Alice", "Bob", "Carla", "David", "Elena"),
  Score = c(10, 15, 8, 12, 20),
  stringsAsFactors = FALSE
)

dfB <- data.frame(
  ID = c(1, 2, 6),
  Age = c(25, 34, 45)
)

# Let's see them:
dfA
dfB


###############################################################################
# 3.1 Left Join
#
# left_join(dfA, dfB, by = "ID") keeps all rows from dfA, matching rows
# from dfB.
###############################################################################

left_join_result <- left_join(dfA, dfB, by = "ID")
left_join_result


###############################################################################
# 3.2 Inner, Right, and Full Joins
#
# - inner_join(): Keeps rows with matches in both dfA and dfB.
# - right_join(): Keeps all rows from dfB.
# - full_join(): Keeps all rows from both data frames.
###############################################################################

inner_join_result <- inner_join(dfA, dfB, by = "ID")
inner_join_result

right_join_result <- right_join(dfA, dfB, by = "ID")
right_join_result

full_join_result <- full_join(dfA, dfB, by = "ID")
full_join_result

# Exercise suggestion:
# 1. Suppose you have a second dataset with ID and Department. Try merging
#    it with dfA or dfB.
# 2. Observe how missing or mismatched keys affect each type of join.


###############################################################################
# 4. Introduction to SQL in R
#
# For data stored in databases, or if you’re familiar with SQL, R allows
# you to run queries using packages like sqldf or DBI + RSQLite.
#
# 4.1 Using sqldf
###############################################################################

# If needed: install.packages("sqldf")
library(sqldf)

# Example: We'll use dfA for a basic SQL query
sqldf_result <- sqldf("SELECT Name, Score FROM dfA WHERE Score > 10")
sqldf_result

# With sqldf, you can do joins, GROUP BY, ORDER BY, etc.


###############################################################################
# 4.2 Using DBI + RSQLite
#
# For more sophisticated/persistent usage, you might use DBI with RSQLite
# to create an in-memory or file-based SQL database.
###############################################################################

# If needed:
# install.packages("DBI")
# install.packages("RSQLite")

library(DBI)
library(RSQLite)

# Create an in-memory SQLite database
con <- dbConnect(RSQLite::SQLite(), ":memory:")

# Copy dfA into the database
dbWriteTable(con, "dfA_table", dfA)

# Let's run a query
res <- dbGetQuery(con, "SELECT * FROM dfA_table WHERE Score >= 10")
res

# Once done, you can disconnect:
# dbDisconnect(con)

# Exercise suggestion:
# 1. Insert dfB into your SQLite database and perform a JOIN.
# 2. Practice GROUP BY queries (e.g., grouping by certain columns).


###############################################################################
# 5. Wrapping Up with a Real-World Workflow
#
# A simple end-to-end flow might be:
# 1. Import a dataset (read_csv).
# 2. Reshape if needed (pivot).
# 3. Merge with another dataset using a join.
# 4. Explore or filter data with SQL or dplyr.
# 5. Summarize and visualize results.
# 6. Export final or intermediate datasets.
#
# Example Pseudocode:
# df_main <- read_csv("my_data.csv")
# df_ref  <- read_csv("lookup_table.csv")
#
# df_long <- df_main %>% pivot_longer(cols = ...)
# df_merged <- left_join(df_long, df_ref, by = "some_key")
# df_filtered <- sqldf("SELECT * FROM df_merged WHERE columnX = '...'")
#
# df_filtered %>% group_by(...) %>% summarise(...)
# ggplot(...) + geom_...
#
# write_csv(df_filtered, "final_output.csv")
#
# Whether you use dplyr or SQL depends on your preference and data complexity.
###############################################################################


###############################################################################
# Takeaways:
# - Pivoting is crucial when your data layout isn’t suitable for analysis.
# - Joins let you combine separate data sources.
# - SQL can be a powerful alternative or complement to R’s native data
#   manipulation tools.
#
# In your future projects, large or relational data often benefit from a
# mix of R & SQL.
###############################################################################


###############################################################################
# Summary & Next Steps
#
# In Lesson 2, you’ve learned:
# 1. How to pivot data between wide and long formats.
# 2. How to merge data frames via dplyr joins.
# 3. Basic SQL usage in R with sqldf and DBI + RSQLite.
#
# What to Practice:
# - Use real datasets to practice pivoting (time series, repeated measures).
# - Combine two or more datasets to see how joins work.
# - Try writing SQL queries for simple operations (SELECT, WHERE, JOIN).
#
# Looking Ahead:
# - You can now handle advanced data workflows.
# - In your thesis project, consider whether you need SQL or R joins,
#   or pivoting.
# - Don't forget all the cleaning and EDA techniques from Lesson 1!
#
# End of Lesson 2
###############################################################################
