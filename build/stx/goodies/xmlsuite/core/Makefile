#
# DO NOT EDIT
#
# make uses this file (Makefile) only, if there is no
# file named "makefile" (lower-case m) in the same directory.
# My only task is to generate the real makefile and call make again.
# Thereafter, I am no longer used and needed.
#

.PHONY: run

run: makefile
	$(MAKE) -f makefile

#only needed for the definition of $(TOP)
include Make.proto

makefile: mf

mf:
	$(TOP)/rules/stmkmf
