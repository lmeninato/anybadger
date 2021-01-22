fill_values <- function(x, y){
  purrr::walk2(names(x), x, function(key, val){
    if (!is.null(val) && key %in% names(y)){
      y[key] <<- val
    }
  })

  y
}
