# $Header: /cvs/stx/stx/libdb/nosql/sandstoneDb/bc.mak,v 1.5 2013-04-17 23:18:47 cg Exp $
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_sandstoneDb.
#
# Warning: once you modify this file, do not rerun
# stmkmp or projectDefinition-build again - otherwise, your changes are lost.
#
# Notice, that the name bc.mak is historical (from times, when only borland c was supported).
# This file contains make rules for the win32 platform using either borland-bcc or visual-c.
# It shares common definitions with the unix-make in Make.spec.
# The bc.mak supports the following targets:
#    bmake         - compile all st-files to a classLib (dll)
#    bmake clean   - clean all temp files
#    bmake clobber - clean all
#
# Historic Note:
#  this used to contain only rules to make with borland
#    (called via bmake, by "make.exe -f bc.mak")
#  this has changed; it is now also possible to build using microsoft visual c
#    (called via vcmake, by "make.exe -f bc.mak -DUSEVC")
#
TOP=..\..
INCLUDE_TOP=$(TOP)\..



!INCLUDE $(TOP)\rules\stdHeader_bc

!INCLUDE Make.spec

LIBNAME=libstx_libdb_nosql_sandstoneDb
RESFILES=sandstoneDb.$(RES)



LOCALINCLUDES= -I$(INCLUDE_TOP)\stx\libcompat -I$(INCLUDE_TOP)\stx\libbasic
LOCALDEFINES=

STCLOCALOPT=-package=$(PACKAGE) -I. $(LOCALINCLUDES) -headerDir=. $(STCLOCALOPTIMIZATIONS) $(STCWARNINGS) $(LOCALDEFINES)  -varPrefix=$(LIBNAME)
LOCALLIBS=

OBJS= $(COMMON_OBJS) $(WIN32_OBJS)

ALL::  classLibRule

classLibRule: $(OUTDIR) $(OUTDIR)$(LIBNAME).dll

!INCLUDE $(TOP)\rules\stdRules_bc

# build all mandatory prerequisite packages (containing superclasses) for this package
prereq:
	pushd ..\..\libbasic & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libbasic2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libbasic3 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libview & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libui & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libview2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libwidg & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libwidg2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libcompat & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "






clean::
	del *.$(CSUFFIX)

# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
$(OUTDIR)SDAbstractStore.$(O) SDAbstractStore.$(H): SDAbstractStore.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SDActiveRecord.$(O) SDActiveRecord.$(H): SDActiveRecord.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SDCheckPointer.$(O) SDCheckPointer.$(H): SDCheckPointer.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SDConcurrentDictionary.$(O) SDConcurrentDictionary.$(H): SDConcurrentDictionary.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SDError.$(O) SDError.$(H): SDError.st $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SDRecordMarker.$(O) SDRecordMarker.$(H): SDRecordMarker.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SDSerializer.$(O) SDSerializer.$(H): SDSerializer.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)stx_libdb_nosql_sandstoneDb.$(O) stx_libdb_nosql_sandstoneDb.$(H): stx_libdb_nosql_sandstoneDb.st $(INCLUDE_TOP)\stx\libbasic\LibraryDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SDBOSSSerializer.$(O) SDBOSSSerializer.$(H): SDBOSSSerializer.st $(INCLUDE_TOP)\stx\libdb\nosql\sandstoneDb\SDSerializer.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SDCachedStore.$(O) SDCachedStore.$(H): SDCachedStore.st $(INCLUDE_TOP)\stx\libdb\nosql\sandstoneDb\SDAbstractStore.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SDCommitError.$(O) SDCommitError.$(H): SDCommitError.st $(INCLUDE_TOP)\stx\libdb\nosql\sandstoneDb\SDError.$(H) $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SDFuelSerializer.$(O) SDFuelSerializer.$(H): SDFuelSerializer.st $(INCLUDE_TOP)\stx\libdb\nosql\sandstoneDb\SDSerializer.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SDLoadError.$(O) SDLoadError.$(H): SDLoadError.st $(INCLUDE_TOP)\stx\libdb\nosql\sandstoneDb\SDError.$(H) $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SDSmartRefStreamSerializer.$(O) SDSmartRefStreamSerializer.$(H): SDSmartRefStreamSerializer.st $(INCLUDE_TOP)\stx\libdb\nosql\sandstoneDb\SDSerializer.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SDFileStore.$(O) SDFileStore.$(H): SDFileStore.st $(INCLUDE_TOP)\stx\libdb\nosql\sandstoneDb\SDCachedStore.$(H) $(INCLUDE_TOP)\stx\libdb\nosql\sandstoneDb\SDAbstractStore.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SDMemoryStore.$(O) SDMemoryStore.$(H): SDMemoryStore.st $(INCLUDE_TOP)\stx\libdb\nosql\sandstoneDb\SDCachedStore.$(H) $(INCLUDE_TOP)\stx\libdb\nosql\sandstoneDb\SDAbstractStore.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)extensions.$(O): extensions.st $(INCLUDE_TOP)\stx\libbasic\ArrayedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\Boolean.$(H) $(INCLUDE_TOP)\stx\libbasic\Character.$(H) $(INCLUDE_TOP)\stx\libbasic\Magnitude.$(H) $(INCLUDE_TOP)\stx\libbasic\Class.$(H) $(INCLUDE_TOP)\stx\libbasic\ClassDescription.$(H) $(INCLUDE_TOP)\stx\libbasic\Behavior.$(H) $(INCLUDE_TOP)\stx\libbasic\Dictionary.$(H) $(INCLUDE_TOP)\stx\libbasic\Set.$(H) $(INCLUDE_TOP)\stx\libbasic\FileDirectory.$(H) $(INCLUDE_TOP)\stx\libcompat\InstructionStream.$(H) $(INCLUDE_TOP)\stx\libbasic\Integer.$(H) $(INCLUDE_TOP)\stx\libbasic\Number.$(H) $(INCLUDE_TOP)\stx\libbasic\ArithmeticValue.$(H) $(INCLUDE_TOP)\stx\libbasic\Semaphore.$(H) $(INCLUDE_TOP)\stx\libcompat\SmartRefStream.$(H) $(INCLUDE_TOP)\stx\libbasic\String.$(H) $(INCLUDE_TOP)\stx\libbasic\CharacterArray.$(H) $(INCLUDE_TOP)\stx\libbasic\UninterpretedBytes.$(H) $(INCLUDE_TOP)\stx\libbasic\UndefinedObject.$(H) $(INCLUDE_TOP)\stx\libcompat\DataStream.$(H) $(INCLUDE_TOP)\stx\libcompat\RWBinaryOrTextStream.$(H) $(INCLUDE_TOP)\stx\libbasic\ReadWriteStream.$(H) $(INCLUDE_TOP)\stx\libbasic\WriteStream.$(H) $(INCLUDE_TOP)\stx\libbasic\PositionableStream.$(H) $(INCLUDE_TOP)\stx\libbasic\PeekableStream.$(H) $(INCLUDE_TOP)\stx\libbasic\Stream.$(H) $(INCLUDE_TOP)\stx\libbasic\Complex.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line
