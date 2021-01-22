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
    #' @param svg_template_path todo
    #' @param label_text_color todo
    #' @param value_text_color todo
    #' @param color todo
    #'
    #' @return null
    #'
    #' @examples
    #' b <- Badge$new()
    initialize = function(label = NULL,
                          value = NULL,
                          thresholds = NULL,
                          font_name = NULL,
                          font_size = NULL,
                          label_text_color = NULL,
                          value_text_color = NULL,
                          color = NULL,
                          svg_template_path = NULL){

      private$user_vals = list("label" = label,
                               "value" = value,
                               "font_name" = font_name,
                               "font_size" = font_size,
                               "thresholds" = thresholds,
                               "label_text_color" = label_text_color,
                               "value_text_color" = value_text_color,
                               "color" = color)

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
      badge_vals <- badge_defaults()
      badge_vals <- fill_values(private$user_vals, badge_vals)
      purrr::walk2(names(badge_vals), badge_vals, function(key, value){
        key <- gsub("_", " ", key)
        res <<- gsub(paste0("\\{\\{ ", key," \\}\\}"),
                     as.character(value),
                     res)
      })

      writeLines(text = res, con = path)
      invisible(res)
    }
  ),
  private = list(
    # user set vals
    user_vals = list(),
    thresholds = NULL,

    # calculated vals
    font_width = NULL,
    color_split_pos = NULL,
    label_anchor = NULL,
    value_anchor = NULL,

    # outputs
    svg_template = NULL,
    svg_output = NULL,

    set_font_width = function(){

    },
    set_color_split_position = function(){

    },
    set_anchors = function(){
      # set value and label anchors
    },
    set_anchor_shadows = function(){
      # set value and label anchor shadows
    },
    set_badge_width = function(){

    },
    # Based on the following SO answer:
    # https://stackoverflow.com/a/16008023/625252
    get_approx_string_width = function(){

    }
  )
)
