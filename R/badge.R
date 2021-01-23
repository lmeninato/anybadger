#' Add documentation
#' @importFrom glue glue
#' @importFrom purrr map_dbl reduce
#' @export
Badge <- R6::R6Class("Badge",
  portable = T,
  public = list(

    #' @description
    #' Documentation here
    #'
    #' @param label todo
    #' @param value todo
    #' @param color todo
    #' @param num_padding_chars todo
    #' @param font_name todo
    #' @param font_size todo
    #' @param thresholds todo
    #' @param svg_template_path todo
    #' @param label_text_color todo
    #' @param value_text_color todo
    #'
    #' @return null
    #'
    #' @examples
    #' b <- Badge$new(label = "Pipeline",
    #'                value = "Passing")
    initialize = function(label,
                          value,
                          color = '#4c1',
                          num_padding_chars = 0.5,
                          thresholds = NULL,
                          font_name = 'DejaVu Sans,Verdana,Geneva,sans-serif',
                          font_size = 11,
                          label_text_color = '#fff',
                          value_text_color = '#fff',
                          svg_template_path = NULL){
      private$user_vals = list("label" = label,
                               "value" = value,
                               "color" = color,
                               "font_name" = font_name,
                               "font_size" = font_size,
                               "label_text_color" = label_text_color,
                               "value_text_color" = value_text_color)

      private$num_padding_chars <- num_padding_chars
      private$thresholds <- thresholds

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
      badge_vals <- private$get_badge_vals()
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
    num_padding_chars = NULL,

    # calculated vals
    font_width = NULL, # not used in svg template

    value_width = NULL,
    badge_width = NULL,
    color_split_x = NULL,
    label_anchor = NULL,
    value_anchor = NULL,
    label_anchor_shadow = NULL,
    value_anchor_shadow = NULL,
    # outputs
    svg_template = NULL,
    svg_output = NULL,

    get_badge_vals = function(){
      private$calculate_badge_vals()
      calc_vals <- list(value_width = private$value_width,
                   badge_width = private$badge_width,
                   color_split_x = private$color_split_x,
                   label_anchor = private$label_anchor,
                   value_anchor = private$value_anchor,
                   label_anchor_shadow = private$label_anchor_shadow,
                   value_anchor_shadow = private$value_anchor_shadow)
      default_vals <- badge_defaults()
      res <- fill_values(calc_vals, default_vals)
      fill_values(private$user_vals, res)
    },

    calculate_badge_vals = function(){
      private$set_font_width()
      private$set_badge_width()
      private$set_color_split_position()
      private$set_anchors()
      private$set_anchor_shadows()
    },

    set_font_width = function(){
      if (!is.null(private$user_vals$font_name)){
        private$font_width <- get_font_width(private$user_vals$font_name,
                                             private$user_vals$font_size)
      }
    },

    set_badge_width = function(){
      get_width = function(label){
        str_width <- label %>%
          private$get_approx_string_width(private$font_width) %>%
          as.integer()
        padding <- 2.0*private$num_padding_chars*private$font_width
        str_width + padding
      }
      label_width <- get_width(private$user_vals$label)
      private$value_width <- get_width(private$user_vals$value)
      private$badge_width <- label_width + private$value_width
    },

    set_color_split_position = function(){
      private$color_split_x <- private$badge_width - private$value_width
    },

    set_anchors = function(){
      split_pos <- private$color_split_x
      private$label_anchor <- split_pos/2
      private$value_anchor <- split_pos + (private$badge_width - split_pos)/2
    },

    set_anchor_shadows = function(){
      private$label_anchor_shadow <- private$label_anchor+1
      private$value_anchor_shadow <- private$value_anchor+1
    },

    # Based on the following SO answer:
    # https://stackoverflow.com/a/16008023/625252
    get_approx_string_width = function(text, font_width){
      size = 0

      char_width_percentages = list(
        "lij|' "= 40.0,
        '![]fI.,:;/\\t'= 50.0,
        '`-(){}r"'= 60.0,
        '*^zcsJkvxy'= 70.0,
        'aebdhnopqug#$L+<>=?_~FZT0123456789'= 70.0,
        'BSPEAKVXY&UwNRCHD'= 70.0,
        'QGOMm%W@'= 100.0
      )

      text %>%
        strsplit(split = "") %>%
        unlist() %>%
        map_dbl(function(c){
          pct_index <- which(
            grepl(c, names(char_width_percentages), fixed = TRUE)
          )
          if (length(pct_index) == 0){
            stop("Please use ASCII characters only (no control characters either).")
          }
          res <- char_width_percentages[pct_index] %>%
            as.numeric()
          res/100*font_width
        }) %>%
        sum()
    }
  )
)
