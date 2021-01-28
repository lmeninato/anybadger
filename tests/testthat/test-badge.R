library(xml2)

local_temp_file <- function(env = parent.frame()){
  tmp <- tempfile()
  withr::defer(unlink(tmp), envir = env)
  tmp
}

test_badge_creation <- function(svg_path, ...){
  create_badge(svg_path, ...)

  xml_doc <- read_xml(svg_path)
  expect_s3_class(xml_doc, "xml_document")
  xml_doc
}

test_that("badge creation works", {
  tmp <- local_temp_file()

  x <- test_badge_creation(tmp,
                      label = "Pipeline",
                      value = "Passing")

  default_badge <- get_sys("testsvg", "pipeline_badge_test.svg") %>%
    read_xml()

  expect_equal(x, default_badge)

  x <- test_badge_creation(tmp,
                             label = "Pipeline",
                             value = "Passing",
                             color = "blue")

  test_color_badge <- get_sys("testsvg", "test_color.svg") %>%
    read_xml()

  expect_equal(x, test_color_badge)

  # test alternate font
  test_badge_creation(tmp,
                      label = "Pipeline",
                      value = "Passing",
                      font_name = 'Arial, Helvetica, sans-serif')

  # test color passes through correctly
  res <- test_badge_creation(tmp,
                             label = "Pipeline",
                             value = "Passing",
                             color = "orange") %>%
    xml_child(3) %>%
    xml_child(2) %>%
    as_list() %>%
    attributes()

  expect_equal(res$fill, "#fe7d37")

  # alternate svg template path
  test_badge_creation(tmp,
                      label = "Pipeline",
                      value = "Passing",
                      svg_template_path = get_sys("svg_template"))
})

test_that("catch invalid svg template path", {
  expect_error(
    Badge$new(label = "Pipeline",
              value = "Passing",
              svg_template_path = "bad_path")
  )
})

test_that("catch non valid characters", {
  tmp <- local_temp_file()

  expect_error({
    create_badge(tmp,
                 label = "Pipeline",
                 value = "asdn \t \n")
  })
})
