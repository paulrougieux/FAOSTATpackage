#' Search FAOSTAT domains, datasets, elements, indicators, and items 
#' 
#' Get full list of datasets from the FAOSTAT database with the Code, Dataset Name and Topic.
#' 
#' @param code character code of the dataset, listed as DatasetCode
#' @param dataset character name of the dataset (or part of the name), listed as DatasetName in the output data frame
#' @param topic character topic from list
#' @param latest boolean sort list by latest updates
#' @param full boolean, TRUE returns the full table with all columns
#' @examples 
#' \dontrun{
#' # Find information about all datasets
#' fao_metadata <- FAOsearch()    
#' # Find information about the forestry dataset
#' FAOsearch(code="FO")
#' # Find information about datasets whose titles contain the word "Flows"
#' FAOsearch(dataset="Flows", full = FALSE)
#' }
#' @export search_datasets 
#' @export FAOsearch

 search_datasets = function(code, dataset, latest = TRUE){
    
    if (deparse(match.call()[[1]]) == "FAOsearch") {
        .Deprecated("search_fao", msg = "FAOsearch has deprecated been replaced by search_datasets as the old API doesn't work anymore. 
                search_datasets was called instead")
    }
    
    search_data <- get_fao("/domains")
    
    data <- rbindlist(content(search_data)[["data"]], fill = TRUE)
    metadata <- content(search_data)[["metadata"]]
    
    if(!missing(code)){
        data <- data[code %chin% get("code", envir = parent.frame()),]
    }
    if(!missing(dataset)){
        data <- data[dataset %chin% get("dataset", envir = parent.frame()),]
    }
        
    if(latest){
        data <- data[order(date_update)]
    }
    
    data <- as.data.frame(data)
    
    attr(data, "query_metadata") <- metadata
    
    return(data)
}

FAOsearch <- search_datasets
