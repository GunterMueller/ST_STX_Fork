# whole makefile does not work (don't know exactly why
# phase2.xml raises exception and tests.st has to be
# run manualy from the command line (at least it worked
# in the time this text was written :o)
default: tests.st

outdir=output
p1f=${outdir}/phase1.xml
p2f=${outdir}/phase2.xml
completef=${outdir}/tests.st
catalog=XQTSCatalog.xml

split:
	awk -f split.awk ${completef}
	mv -f *st ${outdir}/

tests.st: phase2.xml
	xsltproc phase2.xsl ${p2f} > ${completef}

phase2.xml: phase1.xml
	xmllint --xinclude ${p1f} > ${p2f}

phase1.xml: check_xqts_root check_outdir $(XQTS_ROOT)/${catalog}
	xsltproc  --stringparam xqts-root $(XQTS_ROOT) phase1.xsl $(XQTS_ROOT)/${catalog} > ${p1f} 

check_xqts_root:
ifndef XQTS_ROOT
	@echo "XQTS_ROOT variable not defined"
	@echo "usage: make XQTS_ROOT=<path to XQTS>"
endif

check_outdir:
	@if [ -d ${outdir} ]; \
		then \
			echo "${outdir} directory found...";  \
		else \
			echo "${outdir} directory NOT found. Creating ..."; \
			mkdir ${outdir}; \
		fi

clean:
	rm -rf ${outdir}


.PHONY:	check_xqts_root
