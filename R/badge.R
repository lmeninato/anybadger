#' The Badge class is used to create badges.
#'
#' It is likely easier to use the \code{\link{create_badge}}
#' to create the badge svg in a single step.
#'
#'
#' @importFrom glue glue
#' @importFrom purrr map_dbl reduce
#' @export
Badge <- R6::R6Class("Badge",
  portable = T,
  public = list(

    #' @description
    #' Badge constructor
    #'
    #' Used to create badge object.
    #'
    #' @param label left hand side of badge, e.g. "pipeline" in pipeline status badge
    #' @param value right hand side of badge, e.g. "passing" in pipeline status badge
    #' @param color to view available colors:
    #'   \code{config::get("colors", file = anybadger:::get_sys("config.yml")) }
    #'   alternatively you can also pass in the hex of your desired color. For instance,
    #'   "#fe7d37" or "orange", either is accepted.
    #' @param num_padding_chars NULL, can be passed in, but calculated automatically based on text length
    #' @param font_name NULL, valid svg font will work, but sizing might be off
    #' @param font_size NULL, if passng custom svg font
    #' @param thresholds TODO, thresholds are not implemented yet, coming soon!
    #' @param svg_template_path NULL, to use a different template in svg (not recommended)
    #' @param label_text_color NULL, set this to change the label text color
    #' @param value_text_color NULL, set this to change the value text color
    #'
    #' @return NULL
    #'
    #' @examples
    #' tmp <- tempfile()
    #' b <- Badge$new(label = "Pipeline",
    #'                value = "Passing")
    #' b$create_svg(tmp)
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
      private$user_vals = list(
        "label" = label,
        "value" = value,
        "color" = lookup_color_hex(color),
        "font_name" = font_name,
        "font_size" = font_size,
        "label_text_color" = lookup_color_hex(label_text_color),
        "value_text_color" = lookup_color_hex(value_text_color)
      )

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
    #' Fills in the svg template
    #'
    #' @param path file path to save badge svg to
    #'
    #' @return invisibly returns the svg text
    #'
    #' @examples
    #' tmp <- tempfile()
    #' b <- Badge$new(label = "Any",
    #'                value = "Badger")
    #' b$create_svg(tmp)
    #'
    create_svg = function(path = "default_badge.svg"){
      res <- private$svg_template
      badge_vals <- private$get_badge_vals()

      for (key in names(badge_vals)){
        key <- gsub("_", " ", key)
        value <- badge_vals[key]
        res <- gsub(paste0("\\{\\{ ", key," \\}\\}"),
                    as.character(value),
                    res)
      }

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

#' Create badge svg
#'
#' @param path path to save svg to
#' @param ... parameters to pass to @seealso [Badge]
#'
#' @return svg text
#' @export
#'
#' @examples
#' tmp <- tempfile()
#' create_badge(tmp, label = "any", value = "badger", color = "fuchsia")
#'
create_badge <- function(path, ...){
  b <- Badge$new(...)
  b$create_svg(path)
}
