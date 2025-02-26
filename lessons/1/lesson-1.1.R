###############################################################################
# Lesson 1: Data Import, Cleaning, and Basic EDA in R
#
# Author: Petr Čala
# Date: 2025-02-26
#
# Lesson 1 Notebook
#
# Welcome to our first 4-hour block! In this lesson, we will cover:
# 1. Environment Setup and Package Installation
# 2. Basic Recap of R Commands
# 3. Data Import & Export
# 4. Data Exploration and Summary
# 5. Data Cleaning & Preprocessing (missing values, renaming columns,
#    data type conversions, etc.)
# 6. Basic Exploratory Data Analysis (simple statistics and plots)
#
# By the end, you should feel comfortable handling a basic data cleaning
# workflow and generating a few quick insights from your dataset.
###############################################################################


###############################################################################
# 1. Environment Setup
#
# We'll load the libraries we need. If any of these libraries are missing,
# you can install them with install.packages("package_name").
###############################################################################

# If you need to install:
# install.packages("tidyverse")
# install.packages("skimr")  # Optional, but nice for data summaries

library(tidyverse)
library(skimr) # For a more detailed summary


###############################################################################
# Check Your Working Directory
# Instructor Note: Make sure all students have their working directory set
# to a folder where their CSV file is located (or where they plan to save outputs).
###############################################################################

# This shows your current working directory:
getwd()

# If needed, set your working directory (uncomment & modify the path):
# setwd("path/to/your/folder")


###############################################################################
# 2. (Optional) Create Example CSV
#
# If you want to distribute a prepared CSV, you can skip this.
# Otherwise, run the following code to simulate a small “messy” dataset
# in your current directory.
###############################################################################

## Create a small random dataset and write it to CSV:
set.seed(123) # For reproducibility

# Example: We'll simulate data about some hypothetical employees
employee_data <- data.frame(
  ID = 1:15,
  Name = c(
    "Alice", "Bob", "Carla", "David", "Elena",
    "Frank", "Georgia", "Henry", "Ivy", "John",
    "Kate", "Luke", "Mona", "Nick", "Olivia"
  ),
  Age = c(25, 34, 28, NA, 42, 51, 29, 33, 41, 38, NA, 23, 27, 45, 36),
  Department = c(
    "Marketing", "Marketing", "Sales", "HR", "Sales",
    "Sales", "Marketing", "IT", "IT", "HR",
    "HR", "NA", "Marketing", "IT", "NA"
  ),
  Salary = c(
    50000, 60000, 55000, 45000, 65000, 70000,
    52000, 80000, 75000, 48000, 46000, 40000,
    53000, 81000, 42000
  ),
  Performance_Score = c(
    "Good", "Excellent", "Fair", "Excellent",
    "Good", "Good", "Fair", "Excellent",
    "Good", "Fair", "Good", "NA", "Fair",
    "Excellent", "NA"
  ),
  stringsAsFactors = FALSE
)

# Write to CSV
write_csv(employee_data, "messy_data.csv")

# Check the file
list.files(pattern = "messy_data.csv")


###############################################################################
# 3. Data Import
#
# Now, let’s load the dataset we just created (or provided) in CSV format.
###############################################################################

# Replace "messy_data.csv" with your actual CSV file name if different
df <- read_csv("messy_data.csv")

# Let's see the first few rows
head(df)

# Let's quickly inspect the structure
str(df)


###############################################################################
# 4. Basic Recap of R & Exploratory Data Checks
#
# 4.1 Summaries
###############################################################################

# Basic summary
summary(df)

# More detailed summary using skimr (if installed)
skim(df)


###############################################################################
# 4.2 Viewing the Data
#
# Tip: In Jupyter, you can just print df or head(df).
# In RStudio, View(df) opens a spreadsheet-like viewer.
###############################################################################

# For a larger view in a separate tab (works best in RStudio):
# View(df)


###############################################################################
# 5. Data Cleaning & Preprocessing
#
# We’ll walk through renaming columns, dealing with missing values,
# and converting data types if needed.
#
# 5.1 Renaming Columns
###############################################################################

df <- df %>%
  rename(
    PerfScore = Performance_Score
  )

# Check new names
names(df)


###############################################################################
# 5.2 Handling Missing Values
#
# 1. Identify Missing Values using is.na():
###############################################################################

colSums(is.na(df))

###############################################################################
# 2. Deciding What to Do:
#    - We might remove rows with too many missing values.
#    - Or we might impute them (e.g., replace them with the mean/median).
#    - For this example, let’s remove rows where Department is NA:
###############################################################################

# Example: remove rows with missing "Department"
df <- df %>%
  filter(!is.na(Department))

# Re-check for missing values
colSums(is.na(df))

###############################################################################
# 3. Imputing (Example on Age):
#    - Let’s replace missing Age values with the mean Age:
###############################################################################

mean_age <- mean(df$Age, na.rm = TRUE)
df$Age <- ifelse(is.na(df$Age), mean_age, df$Age)

# Check again
colSums(is.na(df))

# Instructor Note: Discuss pros/cons of removing vs. imputing data.
# Transparency is crucial for journalists.


###############################################################################
# 5.3 Data Type Conversion
#
# Sometimes columns should be factors or numeric.
# Let’s ensure Department and PerfScore are factors:
###############################################################################

df <- df %>%
  mutate(
    Department = as.factor(Department),
    PerfScore  = as.factor(PerfScore)
  )

# Check again
str(df)


###############################################################################
# 6. Basic Transformations with dplyr
#
# 6.1 Selecting and Filtering
###############################################################################

# Select specific columns
df_selected <- df %>%
  select(Name, Department, Salary)

head(df_selected)

# Filter rows based on a condition
df_sales <- df %>%
  filter(Department == "Sales")

df_sales


###############################################################################
# 6.2 Mutating (Creating New Columns)
###############################################################################

# Create a new column "Salary_in_Thousands"
df <- df %>%
  mutate(
    Salary_in_Thousands = Salary / 1000
  )

head(df)


###############################################################################
# 6.3 Grouping and Summarizing
###############################################################################

# Average salary by department
df %>%
  group_by(Department) %>%
  summarise(
    Avg_Salary = mean(Salary, na.rm = TRUE),
    Count = n()
  )


###############################################################################
# 7. Basic Exploratory Data Analysis (EDA)
#
# 7.1 Quick Statistical Checks
###############################################################################

# Summaries for numeric columns
summary(df$Salary)
summary(df$Age)


###############################################################################
# 7.2 Simple Plots with ggplot2
###############################################################################

# Histogram of Age
ggplot(df, aes(x = Age)) +
  geom_histogram(bins = 5, fill = "skyblue", color = "black") +
  labs(title = "Distribution of Age", x = "Age", y = "Count")

# Bar plot of Department distribution
ggplot(df, aes(x = Department)) +
  geom_bar(fill = "orange", color = "black") +
  labs(title = "Number of Employees per Department", x = "Department", y = "Count")


###############################################################################
# 7.3 Boxplot to Check Salary Distribution
###############################################################################

ggplot(df, aes(x = Department, y = Salary)) +
  geom_boxplot(fill = "lightgreen") +
  labs(title = "Salary Distribution by Department", x = "Department", y = "Salary")


###############################################################################
# 8. Exporting the Cleaned Dataset
###############################################################################

write_csv(df, "cleaned_data.csv")

# Confirm it exists
list.files(pattern = "cleaned_data.csv")


###############################################################################
# 9. Summary & Next Steps
#
# - What We Did:
#   1. Reviewed library loading and working directory checking.
#   2. Read CSV dataset ("messy_data.csv").
#   3. Explored the data structure, found missing values, and handled them.
#   4. Renamed columns, converted data types, and created new columns.
#   5. Performed basic EDA (histograms, bar plots, boxplots).
#   6. Exported our cleaned dataset.
#
# - Next:
#   In the next session, we’ll look at more advanced reshaping, data merging,
#   and an introduction to SQL in R.
#
# Instructor Tip: Encourage students to apply these steps on any dataset
# relevant to their thesis or final project.
###############################################################################


###############################################################################
# End of Lesson 1
###############################################################################

# Additional Notes for Instructors:
# 1. Data Size: Keep datasets small for quick class demos.
# 2. Student Engagement: Encourage modifying code & exploring different
#    ways of handling missing data.
# 3. Make It Real: Use real datasets if possible (e.g., from data.gov).
# 4. Troubleshooting: Allocate time for read/write permissions, working
#    directories, or missing package issues.
#
# By the end of this, students have a foundation for basic data manipulation
# and EDA in R. Next: data reshaping, merging (joins), and basic SQL queries.
###############################################################################
