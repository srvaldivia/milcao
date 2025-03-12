test_that(
  "find_shapes() TESTING", {
    expect_equal(
      tryCatch(expr = find_shapes(path = "github/project/data"),
               error = function(e) NA_character_),
      NA_character_)
  }
)
