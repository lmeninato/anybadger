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
