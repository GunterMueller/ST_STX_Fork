# $Header: /cvs/stx/stx/goodies/communication/bitTorrent/bc.mak,v 1.3 2013-05-28 10:23:22 cg Exp $
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_communication_bitTorrent.
#
# Warning: once you modify this file, do not rerun
# stmkmp or projectDefinition-build again - otherwise, your changes are lost.
#
# This file contains make rules for the win32 platform (using borland-bcc).
# It shares common definitions with the unix-make in Make.spec.
# The nt.mak supports the following targets:
#    bmake         - compile all st-files to a classLib (dll)
#    bmake clean   - clean all temp files
#    bmake clobber - clean all
#
#
TOP=..\..\..
INCLUDE_TOP=$(TOP)\..



!INCLUDE $(TOP)\rules\stdHeader_bc

!INCLUDE Make.spec

LIBNAME=libstx_goodies_communication_bitTorrent
RESFILES=bitTorrent.$(RES)



LOCALINCLUDES= -I$(INCLUDE_TOP)\stx\libbasic -I$(INCLUDE_TOP)\stx\goodies\communication
LOCALDEFINES=

STCLOCALOPT=-package=$(PACKAGE) -I. $(LOCALINCLUDES) -H. $(STCLOCALOPTIMIZATIONS) $(STCWARNINGS) $(LOCALDEFINES)  -varPrefix=$(LIBNAME)
LOCALLIBS=

OBJS= $(COMMON_OBJS) $(WIN32_OBJS)

ALL::  classLibRule

classLibRule: $(OUTDIR) $(OUTDIR)$(LIBNAME).dll

!INCLUDE $(TOP)\rules\stdRules_bc

# build all prerequisite packages for this package
prereq:
	pushd ..\..\..\libbasic & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\librun & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "




# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
$(OUTDIR)BitTorrentBDecoder.$(O) BitTorrentBDecoder.$(H): BitTorrentBDecoder.st $(INCLUDE_TOP)\stx\libbasic\Stream.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)BitTorrentBEncoder.$(O) BitTorrentBEncoder.$(H): BitTorrentBEncoder.st $(INCLUDE_TOP)\stx\libbasic\ObjectCoder.$(H) $(INCLUDE_TOP)\stx\libbasic\AspectVisitor.$(H) $(INCLUDE_TOP)\stx\libbasic\Visitor.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)BitTorrentTorrentFileContents.$(O) BitTorrentTorrentFileContents.$(H): BitTorrentTorrentFileContents.st $(INCLUDE_TOP)\stx\libbasic\Dictionary.$(H) $(INCLUDE_TOP)\stx\libbasic\Set.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)BitTorrentTorrentFileRecord.$(O) BitTorrentTorrentFileRecord.$(H): BitTorrentTorrentFileRecord.st $(INCLUDE_TOP)\stx\libbasic\Dictionary.$(H) $(INCLUDE_TOP)\stx\libbasic\Set.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)BitTorrentTorrentInfoRecord.$(O) BitTorrentTorrentInfoRecord.$(H): BitTorrentTorrentInfoRecord.st $(INCLUDE_TOP)\stx\libbasic\Dictionary.$(H) $(INCLUDE_TOP)\stx\libbasic\Set.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)stx_goodies_communication_bitTorrent.$(O) stx_goodies_communication_bitTorrent.$(H): stx_goodies_communication_bitTorrent.st $(INCLUDE_TOP)\stx\libbasic\LibraryDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line
