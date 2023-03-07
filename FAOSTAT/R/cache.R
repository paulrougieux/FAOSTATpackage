#' Cache files read in by the API
#' 
#' 
#' 

cache_data <- function(name, data, reset = FALSE, environment = .FAOSTATenv){
  if(!is.null(environment[[name]])) return(invisible(NULL))
  
  assign(name, data, envir = environment)
  
  return(invisible(name))
}