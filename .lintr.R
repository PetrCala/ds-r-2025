# nolint start: indentation_linter, undesirable_function_linter, unused_declared_object.

linters <- c(
  lintr::all_linters(
    # https://lintr.r-lib.org/reference/index.html#individual-linters
    #
    # Set indentation to 8 spaces
    indentation_linter = lintr::indentation_linter(2L),
    # Check that all commas are followed by spaces, but do not have spaces before them.
    commas_linter = lintr::commas_linter(allow_trailing = FALSE),
    # Check that all comments are preceded by a space
    object_name_linter = lintr::object_name_linter(
      styles = c("snake_case", "SNAKE_CASE", "dotted.case", "camelCase")
    ),
    # Disable the default lintr object usage - replace with box imports
    object_usage_linter = NULL,
    # All lines should be less than 120 characters
    line_length_linter = lintr::line_length_linter(NULL), # 120L, 160L,...
    # Disable commented code linter
    commented_code_linter = NULL,
    # Disable the forbidden access through $ linter
    extraction_operator_linter = NULL,
    # Disable cyclocompexity linter
    cyclocomp_linter = NULL,
    # Disable the string boundary linter - grepl usage, startsWith,...
    string_boundary_linter = NULL,
    # Turn off linting for several functions otherwise flagged as undesirable
    undesirable_function_linter = lintr::undesirable_function_linter(
      fun = lintr::modify_defaults(
        defaults = lintr::default_undesirable_functions,
        library = NULL # The library function is great for simple demonstrations
      )
    ),
    # Disable the implicit integer linter
    implicit_integer_linter = NULL,
    # Trailing whitespace does not matter
    trailing_whitespace_linter = NULL
  )
)

exclusions <- list(
  "tests/",
  "archive/"
)

gc() # Clean up memory

# nolint end.
