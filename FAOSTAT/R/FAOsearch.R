##' Search FAOSTAT tables 
##' 
##' Get full list of datasets from the FAOSTAT database with the Code, Dataset Name and Topic.
##' 
##' @param code Specific 2-3 character code for dataset, listed as DatasetCode
##' @param dataset Name of dataset, listed as DatasetName
##' @param topic Dataset topic from list
##' @param latest Sort list by latest updates
##' @param full defaults False, return the full table with all columns
##' 
##' @export

FAOsearch = function(code = NULL, dataset = NULL, topic = NULL, latest = FALSE, full = FALSE){
# Try downloading up to date FAO metatable, else load local cached table from /data
    wfp_identifier <- NULL
    fao_metaTable_updated = fao_metaTable_updated       #loads fao_metaTable_update to provide latest updated dataset when no connection out

# Try downloading latest version from Fenix Services (host of FAOSTAT data), if fails due to connection error, use local .rdata version included with package within /data folder
    download_from_fenix <- try(wfp_identifier <- XML::xmlToDataFrame(XML::xmlParse(
                                            "http://fenixservices.fao.org/faostat/static/bulkdownloads/datasets_E.xml"), 
                                            stringsAsFactors = F), silent = TRUE) 
        if (class(download_from_fenix) == "try-error")   {  
            cat(paste("Using local cached version instead, latest update on", last(sort(fao_metaTable_updated$DateUpdate)), "\n"))
            wfp_identifier <- fao_metaTable_updated
        }
    
    if(!is.null(code)){
        wfp_identifier <- wfp_identifier[code == wfp_identifier[,"DatasetCode"],]}
    if(!is.null(dataset)){
        wfp_identifier <- wfp_identifier[grep(dataset, wfp_identifier[,"DatasetName"]),]}
    if(!is.null(topic)){
        wfp_identifier <- wfp_identifier[grep(topic, wfp_identifier[,"Topic"]),]}
    if(latest == T){
        wfp_identifier <- results[order(results$DateUpdate, decreasing = T),]}
    if(full == F){
        return(wfp_identifier[,c("DatasetCode",
                          "DatasetName",
                          "DateUpdate")])}
    if(full == T){
        return(wfp_identifier)}
    else(return("Invalid query"))
}
