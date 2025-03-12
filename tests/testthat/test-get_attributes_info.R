test_that(
  "get_attributes_info() TESTING", {
    expect_equal(
      tryCatch(expr = get_attributes_info(path = "github/project/data/survey.shp"),
               error = function(e) NA_character_),
      NA_character_)
  }
)
