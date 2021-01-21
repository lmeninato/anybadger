.get_font_widths <- function(){
  m <- fastmap::fastmap()
  m1 <- fastmap::fastmap()
  m2 <- fastmap::fastmap()

  # c('DejaVu Sans', 'Verdana', 'Geneva', 'sans-serif'),
  m1$mset(.list = list('10' = 9, '11' = 10, '12' = 11))
  # c('Arial', 'Helvetica', 'sans-serif')
  m2$set('11', 8)

  m$mset(font_map1 = m1)
  m$mset(font_map2 = m2)
  invisible(m)
}

badge_defaults <- function(){
  config::get("default_template_values", file = get_sys("config.yml"))
}
