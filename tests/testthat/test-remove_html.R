test_that("HTML tag removal works", {
  text <- "<!DOCTYPE html>
<html>
<body>
<h1>Test</h1>
<p>Some edge cases: 2<3, the value is   >2, < a, <> </p>
</body>
</html>"

  stripped <- remove_html(text)
  expect_identical(stripped, "Test Some edge cases: 2<3, the value is >2, < a, <>")

  stripped <- remove_html(text, squish = FALSE)
  expect_identical(stripped, "\n\n\nTest\nSome edge cases: 2<3, the value is   >2, < a, <> \n\n")

  # no leftover text
  stripped <- remove_html("<tag>")
  expect_identical(stripped, "")
})

test_that("argument checks work", {
  expect_error(remove_html(vec = list()), regexp = "'vec'", class = "expectation_failure")
  expect_error(remove_html(vec = NULL), regexp = "'vec'", class = "expectation_failure")
  expect_error(remove_html(vec = data.frame()), regexp = "'vec'", class = "expectation_failure")
  expect_error(remove_html(vec = 1), regexp = "'vec'", class = "expectation_failure")
  expect_error(remove_html(vec = TRUE), regexp = "'vec'", class = "expectation_failure")

  expect_error(remove_html(vec = "", squish = "TRUE"), regexp = "'squish'", class = "expectation_failure")
  expect_error(remove_html(vec = "", squish = 1), regexp = "'squish'", class = "expectation_failure")
  expect_error(remove_html(vec = "", squish = NA), regexp = "'squish'", class = "expectation_failure")
  expect_error(remove_html(vec = "", squish = NULL), regexp = "'squish'", class = "expectation_failure")
  expect_error(remove_html(vec = "", squish = c(TRUE, FALSE)), regexp = "'squish'", class = "expectation_failure")
})
