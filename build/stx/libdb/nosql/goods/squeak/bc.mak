# $Header: /cvs/stx/stx/libdb/nosql/goods/squeak/bc.mak,v 1.5 2013-03-28 11:32:05 cg Exp $
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_libdb_nosql_goods_squeak.
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
TOP=..\..\..\..
INCLUDE_TOP=$(TOP)\..



!INCLUDE $(TOP)\rules\stdHeader_bc

!INCLUDE Make.spec

LIBNAME=libstx_libdb_nosql_goods_squeak
RESFILES=squeak.$(RES)



LOCALINCLUDES= -I$(INCLUDE_TOP)\stx\libview -I$(INCLUDE_TOP)\stx\libdb\nosql\goods -I$(INCLUDE_TOP)\stx\libdb\nosql\goods\tests -I$(INCLUDE_TOP)\stx\libbasic
LOCALDEFINES=

STCLOCALOPT=-package=$(PACKAGE) -I. $(LOCALINCLUDES) -headerDir=. $(STCLOCALOPTIMIZATIONS) $(STCWARNINGS) $(LOCALDEFINES)  -varPrefix=$(LIBNAME)
LOCALLIBS=

OBJS= $(COMMON_OBJS) $(WIN32_OBJS)

ALL::  classLibRule

classLibRule: $(OUTDIR) $(OUTDIR)$(LIBNAME).dll

!INCLUDE $(TOP)\rules\stdRules_bc

# build all mandatory prerequisite packages (containing superclasses) for this package
prereq:
	pushd ..\..\..\libbasic & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libbasic2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libbasic3 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libview & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd .. & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libui & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libview2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\sunit & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libwidg & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\tests & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libwidg2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libcompat & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "





..\KKVariableClassDescriptor.$(H):
    pushd .. \
    & $(STC) $(FFLAGS) $(STCFLAGS) $(STC_MSGFORMAT) $(DBGFLAGS) $(DEFS) -C -headerOnly KKVariableClassDescriptor.st \
    & popd

..\KKStringDescriptor.$(H):
    pushd .. \
    & $(STC) $(FFLAGS) $(STCFLAGS) $(STC_MSGFORMAT) $(DBGFLAGS) $(DEFS) -C -headerOnly KKStringDescriptor.st \
    & popd

..\KKClassDescriptor.$(H):
    pushd .. \
    & $(STC) $(FFLAGS) $(STCFLAGS) $(STC_MSGFORMAT) $(DBGFLAGS) $(DEFS) -C -headerOnly KKClassDescriptor.st \
    & popd

..\KKMetaclassDescriptor.$(H):
    pushd .. \
    & $(STC) $(FFLAGS) $(STCFLAGS) $(STC_MSGFORMAT) $(DBGFLAGS) $(DEFS) -C -headerOnly KKMetaclassDescriptor.st \
    & popd


clean::
	del *.$(CSUFFIX)

# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
$(OUTDIR)KKPackageExporter.$(O) KKPackageExporter.$(H): KKPackageExporter.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)KKSqueakClassMapper.$(O) KKSqueakClassMapper.$(H): KKSqueakClassMapper.st $(INCLUDE_TOP)\stx\libdb\nosql\goods\tests\KKClassMapper.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)KKSqueakPlatform.$(O) KKSqueakPlatform.$(H): KKSqueakPlatform.st $(INCLUDE_TOP)\stx\libdb\nosql\goods\KKPlatform.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)KKSqueakTCPSocketTransport.$(O) KKSqueakTCPSocketTransport.$(H): KKSqueakTCPSocketTransport.st $(INCLUDE_TOP)\stx\libdb\nosql\goods\KKTransport.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)stx_libdb_nosql_goods_squeak.$(O) stx_libdb_nosql_goods_squeak.$(H): stx_libdb_nosql_goods_squeak.st $(INCLUDE_TOP)\stx\libbasic\LibraryDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)extensions.$(O): extensions.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Character.$(H) $(INCLUDE_TOP)\stx\libbasic\Magnitude.$(H) $(INCLUDE_TOP)\stx\libdb\nosql\goods\KKIdentitySet.$(H) $(INCLUDE_TOP)\stx\libbasic\Set.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libdb\nosql\goods\KKMetaclassDescriptor.$(H) $(INCLUDE_TOP)\stx\libdb\nosql\goods\KKStringDescriptor.$(H) $(INCLUDE_TOP)\stx\libdb\nosql\goods\KKVariableClassDescriptor.$(H) $(INCLUDE_TOP)\stx\libdb\nosql\goods\KKClassDescriptor.$(H) $(INCLUDE_TOP)\stx\libbasic\Metaclass.$(H) $(INCLUDE_TOP)\stx\libbasic\ClassDescription.$(H) $(INCLUDE_TOP)\stx\libbasic\Behavior.$(H) $(INCLUDE_TOP)\stx\libbasic\Timestamp.$(H) $(INCLUDE_TOP)\stx\libbasic\AbstractTime.$(H) $(INCLUDE_TOP)\stx\libview\Color.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line
