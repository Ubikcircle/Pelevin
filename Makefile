OUTPUT?=./schemas/
SOURCE?=$(wildcard connections/*.yaml)
STYLE?=dark

DPROC?=sfdp
XPROC?=xsltproc --stringparam stylesheet $(STYLE) processors/generateDOT.xsl -
YPROC?=php -f processors/generateXML.php

all: gif png svg

gif png svg:
	$(foreach name, $(SOURCE), $(YPROC) $(name) | $(XPROC) 2>/dev/null | $(DPROC) -T$@ -o$(OUTPUT)/$(notdir $(name:.yaml=.$@);))
