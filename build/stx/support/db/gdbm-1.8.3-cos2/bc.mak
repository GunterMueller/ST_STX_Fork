# Makefile for libgdbm

# This makefile is suitable for Borland C.
# Written by Claus Gittinger

CC= bcc32
# You may need to adjust these cc options:
# INCL=-Ic:\borland\bcc55\include -Ic:\programme\borland\bcc55\include -Ie:\programme\borland\bcc55\include -Ic:\tools\bcc55\include
INCL=-I. -I$(BCB)\include
CFLAGS=-DWIN32 -O2 -w-par -w-stu -w-ccc -w-rch -k -y -v $(INCL)

# -O2 enables full code optimization (for pre-3.0 Borland C++, use -O -G -Z).
# -w-par suppresses warnings about unused function parameters
# -w-stu suppresses warnings about incomplete structures
# -w-ccc suppresses warnings about compile-time-constant conditions
# -w-rch suppresses warnings about unreachable code

# SYSDEPMEM= jmemdos.obj jmemdosa.obj
# SYSDEPMEMLIB= +jmemdos.obj +jmemdosa.obj
SYSDEPMEM=
SYSDEPMEMLIB=

OUTDIR=objbc\\

OBJ1=$(OUTDIR)dbminit.obj $(OUTDIR)delete.obj $(OUTDIR)fetch.obj $(OUTDIR)store.obj $(OUTDIR)seq.obj $(OUTDIR)close.obj

OBJ2=$(OUTDIR)dbmopen.obj $(OUTDIR)dbmdelete.obj $(OUTDIR)dbmfetch.obj $(OUTDIR)dbmstore.obj $(OUTDIR)dbmseq.obj \
     $(OUTDIR)dbmclose.obj $(OUTDIR)dbmdirfno.obj $(OUTDIR)dbmpagfno.obj $(OUTDIR)dbmrdonly.obj

OBJ3=$(OUTDIR)gdbmopen.obj $(OUTDIR)gdbmdelete.obj $(OUTDIR)gdbmfetch.obj $(OUTDIR)gdbmstore.obj $(OUTDIR)gdbmclose.obj \
	$(OUTDIR)gdbmreorg.obj $(OUTDIR)gdbmseq.obj $(OUTDIR)gdbmsync.obj $(OUTDIR)gdbmerrno.obj $(OUTDIR)gdbmexists.obj $(OUTDIR)gdbmfdesc.obj \
	$(OUTDIR)gdbmsetopt.obj $(OUTDIR)bucket.obj $(OUTDIR)falloc.obj $(OUTDIR)findkey.obj $(OUTDIR)global.obj $(OUTDIR)hash.obj $(OUTDIR)update.obj \
	$(OUTDIR)version.obj

OBJS= $(OBJ1) $(OBJ2) $(OBJ3)

all: objbc\NUL autoconf.h $(OBJS) objbc\libdb1_6.lib

objbc\NUL:
    md objbc

objbc\libdb1_6.lib: $(OBJS) bc.mak
	-del objbc\libdb1_6.lib
	tlib objbc\libdb1_6.lib @&&!
+$(OUTDIR)dbminit.obj +$(OUTDIR)delete.obj +$(OUTDIR)fetch.obj +$(OUTDIR)store.obj +$(OUTDIR)seq.obj +$(OUTDIR)close.obj  \
+$(OUTDIR)dbmopen.obj +$(OUTDIR)dbmdelete.obj +$(OUTDIR)dbmfetch.obj +$(OUTDIR)dbmstore.obj +$(OUTDIR)dbmseq.obj          \
+$(OUTDIR)dbmclose.obj +$(OUTDIR)dbmdirfno.obj +$(OUTDIR)dbmpagfno.obj +$(OUTDIR)dbmrdonly.obj \
+$(OUTDIR)gdbmopen.obj +$(OUTDIR)gdbmdelete.obj +$(OUTDIR)gdbmfetch.obj +$(OUTDIR)gdbmstore.obj +$(OUTDIR)gdbmclose.obj \
+$(OUTDIR)gdbmreorg.obj +$(OUTDIR)gdbmseq.obj +$(OUTDIR)gdbmsync.obj +$(OUTDIR)gdbmerrno.obj +$(OUTDIR)gdbmexists.obj +$(OUTDIR)gdbmfdesc.obj \
+$(OUTDIR)gdbmsetopt.obj +$(OUTDIR)bucket.obj +$(OUTDIR)falloc.obj +$(OUTDIR)findkey.obj +$(OUTDIR)global.obj +$(OUTDIR)hash.obj +$(OUTDIR)update.obj \
+$(OUTDIR)version.obj
!

autoconf.h:  autoconf.h.win32.in
	copy autoconf.h.win32.in autoconf.h

tests:  testgdbm testdbm testndbm tdbm tndbm

testgdbm: testgdbm.obj getopt.obj
	$(CC) testgdbm.obj getopt.obj objbc\libdb1_6.lib

testdbm: testdbm.obj getopt.obj
	$(CC) testdbm.obj getopt.obj objbc\libdb1_6.lib

testndbm: testndbm.obj getopt.obj
	$(CC) testndbm.obj getopt.obj objbc\libdb1_6.lib

conv2gdbm: conv2gdbm.obj getopt.obj
	$(CC) conv2gdbm.obj getopt.obj objbc\libdb1_6.lib

.c.obj:
	$(CC) -c  $(CFLAGS) -o$*.obj $<

clean:
	- del objbc\*.obj
	- del objbc\libjpeg.lib
	- del autoconf.h
