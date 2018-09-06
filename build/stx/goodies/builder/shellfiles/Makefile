M4=m4
SCRIPTS=build_mercurial.sh

all: $(SCRIPTS)

%.sh: %.sh.in common.sh.in
	$(M4) -P $< > $@
