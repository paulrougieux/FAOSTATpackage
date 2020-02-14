FAOSTAT
=======
[![travis-ci-build-status](https://travis-ci.org/mkao006/FAOSTATpackage.svg?branch=master)](https://travis-ci.org/mkao006/FAOSTATpackage)
[![codecov.io](https://codecov.io/github/mkao006/FAOSTATpackage/coverage.svg?branch=master)](https://codecov.io/github/mkao006/FAOSTATpackage?branch=master)
[![CRAN version](http://www.r-pkg.org/badges/version/FAOSTAT)](http://cran.rstudio.com/web/packages/FAOSTAT/index.html)
[![CRAN RStudio mirror downloads](http://cranlogs.r-pkg.org/badges/FAOSTAT)](http://cran.r-project.org/web/packages/FAOSTAT/index.html)

This repository contains all the files to build the FAOSTAT package.

# NOTE: This package is currently under development at :
# https://github.com/paulrougieux/FAOSTATpackage 

# WARNING 
the FAOSTAT API on which this package was based has changed in 2017 and this
package hasn't been working since then. 

As of February 2020, The main interest of this package lies in the updated functions to download data
from the bulk download:

    download_faostat_bulk
    read_faostat_bulk

And in the mapping tables:

    FAOcountryProfile
    FAOmetaTable
    FAOregionProfile

Look at the help of those functions and data sets for more information.

Otherwise there is also @muuankarski 's take on the FAOSTAT bulk download here:
https://github.com/muuankarski/faobulk
He created functions to parse the FAOSTAT xml files, I might include them at
some point here.

I will fix more in the summer of 2020.

==============================================================================

The package can be installed from CRAN:

```r
install.packages("FAOSTAT")
```

or install the develop version via the following link, different
version can be installed by specifying the **ref** argument.

```r
library(devtools)
install_github(repo = "paulrougieux/FAOSTATpackage", subdir = "FAOSTAT")
```

Vignettes and demos are available and please make use of them:

```r
vignette(topic = "FAOSTAT")
demo(topic = "FAOSTATdemo")
```

