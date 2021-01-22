test_that("fill values into list works", {
  x <- list("a"=1, "b"=2, "c"=3)
  y <- list("a"=NULL, "b"=1, "c"=3, "d" =4)

  y <- fill_values(x,y)
  expect_equal(y, list("a"=1, "b"=2, "c"=3, "d"=4))

  x <- list("a"=1, "b"=NULL, "c"=3)
  y <- list("a"=NULL, "b"=1, "c"=3, "d" =4)

  y <- fill_values(x,y)
  expect_equal(y, list("a"=1, "b"=1, "c"=3, "d"=4))
})
