#' Search FAOSTAT tables 
#' 
#' Get full list of datasets from the FAOSTAT database with the Code, Dataset Name and Topic.
#' 
#' @param code character code of the dataset, listed as DatasetCode
#' @param dataset character name of the dataset (or part of the name), listed as DatasetName in the output data frame
#' @param topic character topic from list
#' @param latest boolean sort list by latest updates
#' @param full boolean, return the full table with all columns
#' @examples 
#' \dontrun{
#' # Find information about all datasets
#' FAOsearch()    
#' # Find information about the forestry dataset
#' FAOsearch(code="FT")    
#' # Find information about datasets whose titles contain the word "Flows"
#' FAOsearch(dataset="Flows")
#' }
#' @export

FAOsearch = function(code = NULL, dataset = NULL, topic = NULL, latest = FALSE, full = FALSE){

# Try downloading latest version from Fenix Services (host of FAOSTAT data), if fails due to connection error, use local .rdata version included with package within /data folder
    download_from_fenix <- try(wfp_identifier <- XML::xmlToDataFrame(XML::xmlParse(
                                            "http://fenixservices.fao.org/faostat/static/bulkdownloads/datasets_E.xml"), 
                                            stringsAsFactors = F), silent = TRUE) 
    
    if(!is.null(code)){
        wfp_identifier <- wfp_identifier[code == wfp_identifier[,"DatasetCode"],]}
    if(!is.null(dataset)){
        wfp_identifier <- wfp_identifier[grep(dataset, wfp_identifier[,"DatasetName"]),]}
    if(!is.null(topic)){
        wfp_identifier <- wfp_identifier[grep(topic, wfp_identifier[,"Topic"]),]}
    if(latest == TRUE){
        wfp_identifier <- wfp_identifier[order(wfp_identifier$DateUpdate, decreasing = TRUE),]}
    if(full == FALSE){
        return(wfp_identifier[,c("DatasetCode",
                          "DatasetName",
                          "DateUpdate")])}
    if(full == TRUE){
        return(wfp_identifier)}
    else(return("Invalid query"))
}
