get_sys <- function(...){
  system.file(..., package = "anybadger")
}

fill_values <- function(x, y){
  for (key in names(x)){
    val <- x[[key]]
    if (!is.null(val) && key %in% names(y)){
      y[key] <- val
    }
  }

  y
}

get_font_width <- function(font, size){
  if (font == 'DejaVu Sans,Verdana,Geneva,sans-serif'){
    return(size - 1)
  } else {
    return(8)
  }
}

badge_defaults <- function(){
  config::get("default_template_values", file = get_sys("config.yml"))
}

#' @importFrom magrittr extract2
#' @importFrom glue glue
lookup_color_hex <- function(color){
  if (startsWith(color, "#")){
    return(color)
  }
  color <- tolower(color)
  res <- config::get("colors", file = get_sys("config.yml")) %>%
    extract2(color)

  if (is.null(res)){
    stop(glue("Color not found: {color}"))
  }

  as.character(res)
}
