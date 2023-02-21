#' Access FAOSTAT API
#'
#' Uses the same functionality as the web interface to pull data from the
#' FAOSTAT API. Contains most of its parameters. Currently only works for
#' datasets that have area, item, element and year. Values for Chinese countries
#' are not yet deduplicated.
#'
#' @param area_codes character. FAOSTAT area codes
#' @param element_codes character. FAOSTAT element codes
#' @param item_codes character. FAOSTAT item codes
#' @param year character. Vector of desired years
#' @param area_format character. Desired area code type in output (input still
#'   needs to use FAOSTAT codes)
#' @param item_format character. Item code
#' @param dataset character. FAO dataset desired, e.g. RL, FBS
#' @param metadata_cols character. Metadata columns to include in output
#' @param include_na logical. Whether to include NAs for combinations of dimensions with no data
#' @param language character. 2 letter language code for output labels
#' @param base_url character. Base URL for API
#' 
#' @return data.frame in long format (wide not yet supported). Contains attributes for the URL and parameters used.
#' 
#' @examples
#' 
#' # Get data for Cropland (6620) Area (5110) in Antigua and Barbuda (8), 2017
#' getFAO("8", "5110", "6620", "2017")
#' 
#' @export

getFAO <- function(area_codes, element_codes, item_codes, year_codes, 
                   area_format = c("M49", "FAO", "ISO2", "ISO3"),
                   item_format = c("CPC", "FAO"),
                   dataset = "RL", 
                   metadata_cols = c("codes", "units", "flags", "notes"),
                   include_na = FALSE,
                   language = c("en", "fr", "es"),
                   base_url = "https://fenixservices.fao.org/faostat/api/v1/"){
  
  coll <- function(string){
    paste0(string, collapse = ",")
  }
  
  language = match.arg(language, several.ok = FALSE)
  area_format = match.arg(area_format, several.ok = FALSE)
  item_format = match.arg(item_format, several.ok = FALSE)
  
  area_coll     = coll(area_codes)
  item_coll     = coll(item_codes)
  element_coll  = coll(element_codes)
  year_coll     = coll(year_codes)
  
  params <- list(
    area = area_coll, #These are FAO codes even if displayed in M49
    area_cs = area_format,
    element = element_coll,
    item = item_coll, #I think these are FAO codes too, but they _happen_ to match for CPC
    item_cs = item_format,
    year = year_coll,
    show_codes = "codes" %in% metadata_cols,
    show_unit = "units" %in% metadata_cols,
    show_flags = "flags" %in% metadata_cols,
    show_notes = "notes" %in% metadata_cols,
    null_values = include_na,
    # pivot = FALSE,
    # no_records = return_n_records_only,  # Used to only return the number of records
    # page_number = 1,   # For pagination
    # page_size = 100,   # Number of records for pagination
    datasource = "DB4",
    output_type = "objects" #csv is also a possibility
    #latest_year = 1 # Will give the latest year available
  )
  
  #Call to check for no records then get data
  
  final_url <- paste0(base_url, language, "/data/", dataset)
  
  resp <- httr::GET(final_url, query = params)
  
  
  if (status_code(resp) != 200) {
    if (status_code(resp) == 404) {
      stop("Error 404 - resource not found. Is something wrong with the URL?")
    }
    stop("Request failed")
  }
  
  resp_content <- content(resp)
  
  resp_list <- lapply(resp_content$data, as.data.frame)
  
  ret <- do.call(rbind, resp_list)
  
  #TODO Add China replacement function 
  #TODO Replace this kludgy fix with something that provides an empty table
  if(is.null(ret)){
    stop("Data is empty")
  }
  
  attr(ret, "url") <- final_url
  attr(ret, "params") <- params
  
  return(ret)
}
