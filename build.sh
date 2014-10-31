#!/bin/sh

name=${1:-links}

for t in svg png
do
	php -f generateXML.php | xsltproc generateDOT.xsl - | sfdp -T$t -o$name.$t
done
