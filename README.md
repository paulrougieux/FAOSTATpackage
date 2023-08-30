FAOSTAT
=======
[![CRAN
version](http://www.r-pkg.org/badges/version/FAOSTAT)](http://cran.rstudio.com/web/packages/FAOSTAT/index.html)
[![CRAN RStudio mirror downloads](http://cranlogs.r-pkg.org/badges/FAOSTAT)](http://cran.r-project.org/web/packages/FAOSTAT/index.html)

This repository contains all the files to build the FAOSTAT package.

# NOTE: This package is currently under development at:
# https://gitlab.com/paulrougieux/faostatpackage/

If you have an issue, could you kindly report it with a reproducible example including
input code and error output on the gitlab issue page
https://gitlab.com/paulrougieux/faostatpackage/-/issues


# Installation

The package can be installed from CRAN:

```r
install.packages("FAOSTAT")
```

To get the latest changes, install the development version via the following code.

```r
remotes::install_gitlab(repo = "paulrougieux/faostatpackage/FAOSTAT")
```

Different versions can be installed by specifying the **ref** part of the repo argument
as such `paulrougieux/faostatpackage/FAOSTAT@ref`.


# Documentation

A vignette and function documentation are available and please use them:

```r
library(FAOSTAT)
vignette(topic = "FAOSTAT")
help(get_faostat_bulk)
help(read_fao)
```

The vignette is also visible on CRAN at
https://cran.r-project.org/web/packages/FAOSTAT/vignettes/FAOSTAT.pdf


# Usage example

There are 2 ways to access FAOSTAT data:

1. From bulk downloads files
2. Through the API

The FAOSTAT packages provide two different functions

1. get_faostat_bulk to read from bulk download files. This is what you wnat.
2. read_fao to read from the API (see function documentation and examples provided)


Example using the `get_faostat_bulk()` function to load crop production data for all
products in all countries and all available years

```r
# Create a folder to store the data
data_folder <- "data_raw"
dir.create(data_folder)

# Load crop production data
crop_production <- get_faostat_bulk(code = "QCL", data_folder = data_folder)

# Cache the file i.e. save the data frame in the serialized RDS format for faster load time later.
saveRDS(crop_production, "data_raw/crop_production_e_all_data.rds")
# Now you can load your local version of the data from the RDS file
crop_production <- readRDS("data_raw/crop_production_e_all_data.rds")
```

Example of the `read_fao()` function to download data for a specific product in a
specific country from the API:


```r
# Get data for Cropland (6620) Area (5110) in Antigua and Barbuda (8) in 2017
df = read_fao(area_codes = "8", element_codes = "5110", item_codes = "6620", year_codes = "2017")
# Load cropland area for a range of year
df = read_fao(area_codes = "106", element_codes = "5110", item_codes = "6620", year_codes = 2010:2020)
```




# WARNING

The FAOSTAT API on which this package was based has changed in 2017. As of 2020, The
main interest of this package lies in the updated functions to search and download data
from the FAOSTAT bulk download facility:

    FAOsearch
    get_faostat_bulk
    read_fao

Look at the help of those functions and data sets for more information.
Some functions might not work or give a depreciation warning.

# Alternative

There is also @muuankarski 's take on the FAOSTAT bulk download here:
https://github.com/muuankarski/faobulk
He also created functions to parse the FAOSTAT xml files and download data.


