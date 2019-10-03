#!/bin/sh

mkdir -vp dist
rsync -va assets/ dist/
java -jar saxon9he.jar -xsl:spv.xsl -s:$SVN_DIR/pulfa/eads/mss/C1491.EAD.xml -o:dist/C1491.html
