setup({
  tmp <<- tempfile()
})

teardown({
  unlink(tmp)
})

test_that("default badge works", {
  # use text fixtures later...
  b <- Badge$new(label = "Pipeline",
                 value = "Passing")
  res <- b$create_svg(path = tmp)

  # check valid svg file?
  expect_length(res, 23)
})
