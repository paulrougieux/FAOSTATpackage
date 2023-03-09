#' Search FAOSTAT domains, datasets, elements, indicators, and items 
#' 
#' Get full list of datasets from the FAOSTAT database with the Code, dataset name and updates.
#' 
#' @param code character. Codes of desired datasets, listed as DatasetCode
#' @param dataset character. Name of the dataset (or part of the name), listed as label in the output data frame
#' @param latest logical. Sort list by latest updates
#' @examples 
#' \dontrun{
#' # Find information about all datasets
#' fao_metadata <- search_datasets()    
#' # Find information about the forestry dataset
#' search_datasets(code="FO")
#' # Find information about datasets whose titles contain the word "Flows"
#' search_datasets(dataset="Flows")
#' }
#' 
#' @return A data.frame with the columns:
#'  code, label, date_update, note_update, release_current, state_current, year_current, release_next, state_next, year_next
#' @export 

 search_datasets = function(code, dataset, latest = TRUE){
    
    if (deparse(match.call()[[1]]) == "FAOsearch") {
        .Deprecated("search_fao", msg = "FAOsearch has deprecated been replaced by search_datasets as the old API doesn't work anymore. 
                search_datasets was called instead")
    }
    
     if(length(dataset > 1)){
         warning("More than 1 values was supplied to dataset, only the first will be used")
         dataset <- dataset[1]
     }
     
    search_data <- get_fao("/domains")
    
    data <- rbindlist(content(search_data)[["data"]], fill = TRUE)
    metadata <- content(search_data)[["metadata"]]
    
    if(!missing(code)){
        data <- data[code %chin% get("code", envir = parent.frame()),]
    }
    if(!missing(dataset)){
        data <- data[grepl(get("dataset", envir = parent.frame()), dataset),]
    }
        
    if(latest){
        data <- data[order(date_update)]
    }
    
    data <- as.data.frame(data)
    
    attr(data, "query_metadata") <- metadata
    
    return(data)
 }
 
 #' @rdname search_datasets
 #' @export
 #' 

FAOsearch <- search_datasets
