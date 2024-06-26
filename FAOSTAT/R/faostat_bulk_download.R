#' @title Download bulk data from the faostat website
#' https://www.fao.org/faostat/en/#data
#'
#' @description 
#' \itemize{
#'  \item \code{get_faostat_bulk()} loads the given data set code and returns a data frame.
#'  \item \code{download_faostat_bulk()} loads data from the given url and saves it to a compressed zip file.
#'  \item \code{read_faostat_bulk()} Reads the compressed .csv .zip file into a data frame.
#'  More precisely it unzips the archive. 
#'  Reads the main csv file within the archive.
#'  The main file has the same name as the name of the archive. 
#'  Note: the zip archive might also contain metadata files about Flags and Symbols.
#' }
#' In general you should load the data with the function \code{get_faostat_bulk()} and a dataset code.
#' The other functions are lower level functions that you can use as an alternative. 
#' You can also explore the datasets and find their download URLs
#' on the FAOSTAT website. Explore the website to find out the data you are interested in
#' \url{https://www.fao.org/faostat/en/#data}
#' Copy a "bulk download" url, 
#' for example they are located in the right menu on the "crops" page
#' \url{https://www.fao.org/faostat/en/#data/QC}
#' Note that faostat bulk files with names ending with "normalized" are in long format 
#' with a year column instead of one column for each year.
#' The long format is preferable for data analysis and this is the format 
#' returned by the  \code{get_faostat_bulk()} function. 
#' @author Paul Rougieux
#' @param url_bulk character url of the faostat bulk zip file to download
#' @param data_folder character path of the local folder where to download the data
#' @examples 
#' \dontrun{
#'
#' # Create a folder to store the data
#' data_folder <- "data_raw"
#' dir.create(data_folder)
#' 
#' # Load crop production data
#' crop_production <- get_faostat_bulk(code = "QCL", data_folder = data_folder)
#' 
#' # Cache the file i.e. save the data frame in the serialized RDS format for faster load time later.
#' saveRDS(crop_production, "data_raw/crop_production_e_all_data.rds")
#' # Now you can load your local version of the data from the RDS file
#' crop_production <- readRDS("data_raw/crop_production_e_all_data.rds")
#'
#'
#' # Use the lower level functions to download zip files, 
#' # then read the zip files in separate function calls.
#' # In this example, to avoid a warning about "examples lines wider than 100 characters"
#' # the url is split in two parts: a common part 'url_bulk_site' and a .zip file name part.
#' # In practice you can enter the full url directly as the `url_bulk`  argument.
#' # Notice also that I have choosen to load global data in long format (normalized).
#' url_bulk_site <- "https://fenixservices.fao.org/faostat/static/bulkdownloads"
#' url_crops <- file.path(url_bulk_site, "crop_production_E_All_Data_(Normalized).zip")
#' url_forestry <- file.path(url_bulk_site, "Forestry_E_All_Data_(Normalized).zip")
#' # Download the files
#' download_faostat_bulk(url_bulk = url_forestry, data_folder = data_folder)
#' download_faostat_bulk(url_bulk = url_crops, data_folder = data_folder)
#' 
#' # Read the files and assign them to data frames 
#' crop_production <- read_faostat_bulk("data_raw/crop_production_E_All_Data_(Normalized).zip")
#' forestry <- read_faostat_bulk("data_raw/Forestry_E_All_Data_(Normalized).zip")
#'  
#' # Save the data frame in the serialized RDS format for fast reuse later.
#' saveRDS(crop_production, "data_raw/crop_production_e_all_data.rds")
#' saveRDS(forestry,"data_raw/forestry_e_all_data.rds")
#' }
#' @export

download_faostat_bulk <- function(url_bulk, data_folder = "."){
    file_name <- basename(url_bulk)
    download.file(url_bulk, file.path(data_folder, file_name))
}

#' @rdname download_faostat_bulk
#' @param zip_file_name character name of the zip file to read
#' @param encoding parameter passed to `read.csv`.
#' @param rename_element boolean Rename the element column to snake case. To
#' facilitate the use of elements as column names later when the data frame
#' gets reshaped to a wider format. Replace non alphanumeric characters by
#' underscores.
#' @return data frame of FAOSTAT data
#' @export
read_faostat_bulk <- function(zip_file_name, 
                              encoding="latin1", 
                              rename_element=TRUE){
    # The main csv file shares the name of the archive
    csv_file_name <- gsub(".zip$",".csv", basename(zip_file_name))
    # Read the csv file within the zip file
    df <- read.csv(unz(zip_file_name, csv_file_name),
                   stringsAsFactors = FALSE,
                   encoding=encoding)
    # Rename columns to lower case 
    # and replace non alphanumeric characters by underscores.
    names(df) <- to_snake(names(df))
    if(rename_element & "element" %in% names(df)){
        df$element <- to_snake(df$element)
    }
    return(df)
}


#' @rdname download_faostat_bulk
#' @param code character. Dataset code
#' @param subset character. Use \code{read_bulk_metadata}. Request all data,
#'   normalised data or region
#' @return data frame of FAOSTAT data
#' @export
get_faostat_bulk <- function(code, data_folder = tempdir(), subset = "All Data Normalized"){
    
    dir.create(data_folder, showWarnings = FALSE, recursive = TRUE)
    
    # Load information about the given dataset code 
    metadata <- read_bulk_metadata(dataset_code = code)
    
    metadata_url = metadata[metadata$FileContent == subset, "URL"]
    
    # Use the result of the search to download the data and assign it to a data frame 
    download_faostat_bulk(url_bulk = metadata_url, data_folder = data_folder)
    output <- read_faostat_bulk(file.path(data_folder, basename(metadata_url)))
    return(output)
}

#' @rdname download_faostat_bulk
#' @param dataset_code character. Dataset code
#' @return data frame of FAOSTAT data 
#' @export

read_bulk_metadata <- function(dataset_code){
    metadata_req <- get_fao(paste0("/bulkdownloads/", dataset_code))
    metadata <- content(metadata_req)
    
    meta_metadata <- metadata$metadata
    data <- metadata$data
    out <- as.data.frame(rbindlist(lapply(data, as.data.table)))
    
    attr(out, "metadata") <- meta_metadata
    
    return(out)
}

