#' Add documentation
#' @importFrom glue glue
#' @export
Badge <- R6::R6Class("Badge",
  portable = T,
  public = list(

    #' @description
    #' Documentation here
    #'
    #' @param label todo
    #' @param value todo
    #' @param font_name todo
    #' @param font_size todo
    #' @param thresholds todo
    #' @param default_color todo
    #' @param text_color todo
    #' @param svg_template_path todo
    #'
    #' @return null
    #'
    #' @examples
    #' b <- Badge$new()
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

    #' @description
    #' Todo
    #'
    #' @param path todo
    #'
    #' @return todo
    #'
    #' @examples
    #' \dontrun{
    #' b <- Badge$new()
    #' b$create_svg()
    #' }
    create_svg = function(path = "default_badge.svg"){
      res <- private$svg_template
      bd <- badge_defaults()
      purrr::walk2(names(bd), bd, function(key, value){
        key <- gsub("_", " ", key)
        res <<- gsub(paste0("\\{\\{ ", key," \\}\\}"),
                     as.character(value),
                     res)
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
