#!/bin/sh

for i in *.xml; do
	echo -n "Updating $i..."
	xmlwf -d canonical $i;
	echo done
done
