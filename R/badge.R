#' @importFrom glue glue
#' @export
Badge <- R6::R6Class("Badge",
  public = list(
    initialize = function(label = NULL,
                          value = NULL,
                          font_name = NULL,
                          font_size = NULL,
                          thresholds = NULL,
                          default_color = NULL,
                          text_color = NULL,
                          svg_template_path = NULL){
      private$label <- label
      private$value <- value
      if (is.null(svg_template_path)){
        private$svg_template <- readLines(get_sys("svg_template"))
      } else {
        if (!file.exists(svg_template_path)){
          stop("Please pass in valid svg template path.")
        }
        private$svg_template <- readLines(svg_template_path)
      }
    },
    create_svg = function(path = "default_badge.svg"){
      res <- private$svg_template
      bd <- badge_defaults()
      purrr::walk2(names(bd), bd, function(key, value){
        key <- gsub("_", " ", key)
        res <<- stringr::str_replace_all(res,
                                         paste0("\\{\\{ ", key," \\}\\}"),
                                         as.character(value))
      })

      writeLines(text = res, con = path)
      res
    }
  ),
  private = list(
    label = NULL,
    value = NULL,
    font_name = NULL,
    font_size = NULL,
    thresholds = NULL,
    default_color = NULL,
    text_color = NULL,
    svg_template = NULL,
    svg_output = NULL
  )
)

# label <- 'my label'
# value_text <- '123.123'
#
# lines <- get_sys("svg_template") %>%
#   readLines() %>%
#   stringr::str_replace_all(lines, "\\{\\{ badge width \\}\\}", '71') %>%
#   stringr::str_replace_all(lines,
#                            "\\{\\{ font name \\}\\}",
#                            'DejaVu Sans,Verdana,Geneva,sans-serif') %>%
#   stringr::str_replace_all(lines, "\\{\\{ font size \\}\\}", '11') %>%
#   stringr::str_replace_all(lines, "\\{\\{ label \\}\\}", label) %>%
#   stringr::str_replace_all(lines, "\\{\\{ value \\}\\}", value_text)






