# Makefile for zlib -- Tiny C Compiler
#

USETCC=1
!undef USEBC
!undef USEVC
!undef USELCC

!include ..\..\rules\stdHeader_bc

BINDIR=$(TCCDIR)\\

# optional build flags
LOC =

OUTDIR=objtcc\\

# variables
STATICLIB = $(OUTDIR)zlib.lib
SHAREDLIB = $(OUTDIR)zlib1.dll
IMPLIB    = zdll.lib

CC = "$(BINDIR)tcc"
AS = "$(BINDIR)ml"
LD = "$(BINDIR)tcc"
AR = "$(BINDIR)lib"
RC = "$(BINDIR)rc"
CFLAGS  = $(LOC)
ASFLAGS = -coff
LDFLAGS =
ARFLAGS = -nologo
RCFLAGS = /dWIN32 /r

OBJS = $(OUTDIR)adler32.$(O) $(OUTDIR)compress.$(O) $(OUTDIR)crc32.$(O) $(OUTDIR)deflate.$(O) $(OUTDIR)gzio.$(O) $(OUTDIR)infback.$(O) \
       $(OUTDIR)inffast.$(O) $(OUTDIR)inflate.$(O) $(OUTDIR)inftrees.$(O) $(OUTDIR)trees.$(O) $(OUTDIR)uncompr.$(O) $(OUTDIR)zutil.$(O)
OBJA =


# targets
#all: $(STATICLIB) $(SHAREDLIB) $(IMPLIB) \
#     example.exe minigzip.exe example_d.exe minigzip_d.exe

all: cleanup $(OUTDIR)NUL $(STATICLIB)

full:: all

cleanup:
	-del *.$(O)

$(OUTDIR)NUL:
	md $(OUTDIR)

$(STATICLIB): $(OUTDIR)NUL $(OBJS) $(OBJA)
	$(CC) -r -o $@ $(OBJS)

$(IMPLIB): $(SHAREDLIB)

xxx$(SHAREDLIB): win32/zlib.def $(OBJS) $(OBJA) zlib1.res
	$(LD) $(LDFLAGS) -def:win32/zlib.def -dll -implib:$(IMPLIB) \
	  -out:$@ $(OBJS) $(OBJA) zlib1.res

$(SHAREDLIB): win32/zlib.def $(OBJS) $(OBJA)
	$(LD) $(LDFLAGS) \
	  -shared -o $@ $(OBJS) $(OBJA)

.c.$(O):
	$(CC) -c $(CFLAGS) $(SYS_INCL) $<
	copy *.$(O) $(OUTDIR)
	-del *.$(O)

.asm.$(O):
	$(AS) -c $(ASFLAGS) $<

$(OUTDIR)adler32.$(O): adler32.c zlib.h zconf.h

$(OUTDIR)compress.$(O): compress.c zlib.h zconf.h

$(OUTDIR)crc32.$(O): crc32.c zlib.h zconf.h crc32.h

$(OUTDIR)deflate.$(O): deflate.c deflate.h zutil.h zlib.h zconf.h

$(OUTDIR)gzio.$(O): gzio.c zutil.h zlib.h zconf.h

$(OUTDIR)infback.$(O): infback.c zutil.h zlib.h zconf.h inftrees.h inflate.h \
	     inffast.h inffixed.h

$(OUTDIR)inffast.$(O): inffast.c zutil.h zlib.h zconf.h inftrees.h inflate.h \
	     inffast.h

$(OUTDIR)inflate.$(O): inflate.c zutil.h zlib.h zconf.h inftrees.h inflate.h \
	     inffast.h inffixed.h

$(OUTDIR)inftrees.$(O): inftrees.c zutil.h zlib.h zconf.h inftrees.h

$(OUTDIR)trees.$(O): trees.c zutil.h zlib.h zconf.h deflate.h trees.h

$(OUTDIR)uncompr.$(O): uncompr.c zlib.h zconf.h

$(OUTDIR)zutil.$(O): zutil.c zutil.h zlib.h zconf.h

example.$(O): example.c zlib.h zconf.h

minigzip.$(O): minigzip.c zlib.h zconf.h

zlib1.res: win32/zlib1.rc
	$(RC) $(RCFLAGS) /fo$@ win32/zlib1.rc


# testing
test: example.exe minigzip.exe
	example
	echo hello world | minigzip | minigzip -d

testdll: example_d.exe minigzip_d.exe
	example_d
	echo hello world | minigzip_d | minigzip_d -d


# cleanup
clean:
	-del $(OUTDIR)*.$(O) $(OUTDIR)*.$(LIB)
	-del $(IMPLIB)
	-del *.$(O)
	-del *.res
	-del *.exp
	-del *.exe
	-del foo.gz

clobber: clean
	-rmdir /s /q objbc
	-rmdir /s /q objvc
	-rmdir /s /q objlcc
	-rmdir /s /q objtcc
