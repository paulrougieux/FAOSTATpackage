# Usage:
# build the package's tarball, check and remove the ../FAOSTAT.Rcheck folder:
# make
# build the package's tarball and check (keep the ../FAOSTAT.Rcheck folder):
# make check
# generate the documentation:
# make docs
#
# This makefile was copied and apdapted from  yihui / knitr 
# https://github.com/yihui/knitr/blob/master/Makefile

# prepare the package for release
PKGNAME := $(shell sed -n "s/Package: *\([^ ]*\)/\1/p" DESCRIPTION)
PKGVERS := $(shell sed -n "s/Version: *\([^ ]*\)/\1/p" DESCRIPTION)
PKGSRC  := $(shell basename `pwd`)

all: docs check clean install

deps:
	tlmgr install pgf preview xcolor;\
	Rscript -e 'if (!require("Rd2roxygen")) install.packages("Rd2roxygen", repos="http://cran.rstudio.com")'

docs:
	R -q -e "devtools::document(roclets = c('rd', 'collate', 'namespace', 'vignette'))"

build:
	cd ..;\
	R CMD build $(PKGSRC)

install: build
	cd ..;\
	R CMD INSTALL $(PKGNAME)_$(PKGVERS).tar.gz

check: build
	cd ..;\
	R CMD check $(PKGNAME)_$(PKGVERS).tar.gz --as-cran

clean:
	cd ..;\
	$(RM) -r $(PKGNAME).Rcheck/
	
