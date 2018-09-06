# $Header: /cvs/stx/stx/libboss/bc.mak,v 1.40 2013-05-28 10:32:49 cg Exp $
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_libboss.
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
TOP=..
INCLUDE_TOP=$(TOP)\..


# see stdHeader_bc for LIBBOSS_BASE
LIB_BASE=$(LIBBOSS_BASE)


!INCLUDE $(TOP)\rules\stdHeader_bc

!INCLUDE Make.spec

LIBNAME=libstx_libboss
RESFILES=libboss.$(RES)



LOCALINCLUDES= -I$(INCLUDE_TOP)\stx\libview -I$(INCLUDE_TOP)\stx\libbasic2 -I$(INCLUDE_TOP)\stx\libbasic
LOCALDEFINES=

STCLOCALOPT=-package=$(PACKAGE) -I. $(LOCALINCLUDES) -H. $(STCLOCALOPTIMIZATIONS) $(STCWARNINGS) $(LOCALDEFINES) $(COMMONSYMBOLS) -varPrefix=$(LIBNAME)
LOCALLIBS=

OBJS= $(COMMON_OBJS) $(WIN32_OBJS)

ALL::  classLibRule

classLibRule: $(OUTDIR) $(OUTDIR)$(LIBNAME).dll

!INCLUDE $(TOP)\rules\stdRules_bc

# build all prerequisite packages for this package
prereq:
	pushd ..\libbasic & bmake "CFLAGS_LOCAL=$(GLOBALDEFINES) "
#        pushd ..\librun & bmake "CFLAGS_LOCAL=$(GLOBALDEFINES) "




# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
$(OUTDIR)BinaryIOManager.$(O) BinaryIOManager.$(H): BinaryIOManager.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)BinaryObjectStorage.$(O) BinaryObjectStorage.$(H): BinaryObjectStorage.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ObsoleteObject.$(O) ObsoleteObject.$(H): ObsoleteObject.st $(STCHDR)
$(OUTDIR)stx_libboss.$(O) stx_libboss.$(H): stx_libboss.st $(INCLUDE_TOP)\stx\libbasic\LibraryDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)BinaryInputManager.$(O) BinaryInputManager.$(H): BinaryInputManager.st $(INCLUDE_TOP)\stx\libboss\BinaryIOManager.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)BinaryOutputManager.$(O) BinaryOutputManager.$(H): BinaryOutputManager.st $(INCLUDE_TOP)\stx\libboss\BinaryIOManager.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\IdentityDictionary.$(H) $(INCLUDE_TOP)\stx\libbasic\Dictionary.$(H) $(INCLUDE_TOP)\stx\libbasic\Set.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(STCHDR)
$(OUTDIR)extensions.$(O): extensions.st $(INCLUDE_TOP)\stx\libbasic\Float.$(H) $(INCLUDE_TOP)\stx\libbasic\LimitedPrecisionReal.$(H) $(INCLUDE_TOP)\stx\libbasic\Number.$(H) $(INCLUDE_TOP)\stx\libbasic\ArithmeticValue.$(H) $(INCLUDE_TOP)\stx\libbasic\Magnitude.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\String.$(H) $(INCLUDE_TOP)\stx\libbasic\CharacterArray.$(H) $(INCLUDE_TOP)\stx\libbasic\ByteArray.$(H) $(INCLUDE_TOP)\stx\libbasic\UninterpretedBytes.$(H) $(INCLUDE_TOP)\stx\libbasic\ArrayedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libview\Color.$(H) $(INCLUDE_TOP)\stx\libview\Font.$(H) $(INCLUDE_TOP)\stx\libview\FontDescription.$(H) $(INCLUDE_TOP)\stx\libbasic\Class.$(H) $(INCLUDE_TOP)\stx\libbasic\ClassDescription.$(H) $(INCLUDE_TOP)\stx\libbasic\Behavior.$(H) $(INCLUDE_TOP)\stx\libview\Image.$(H) $(INCLUDE_TOP)\stx\libbasic\MethodDictionary.$(H) $(INCLUDE_TOP)\stx\libbasic\KeyedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\ExecutableFunction.$(H) $(INCLUDE_TOP)\stx\libbasic\Symbol.$(H) $(INCLUDE_TOP)\stx\libbasic\Method.$(H) $(INCLUDE_TOP)\stx\libbasic\CompiledCode.$(H) $(INCLUDE_TOP)\stx\libbasic\False.$(H) $(INCLUDE_TOP)\stx\libbasic\Boolean.$(H) $(INCLUDE_TOP)\stx\libbasic\Character.$(H) $(INCLUDE_TOP)\stx\libbasic\UndefinedObject.$(H) $(INCLUDE_TOP)\stx\libview\Form.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\DeviceGraphicsContext.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsContext.$(H) $(INCLUDE_TOP)\stx\libbasic\Smalltalk.$(H) $(INCLUDE_TOP)\stx\libbasic\Unicode16String.$(H) $(INCLUDE_TOP)\stx\libbasic\TwoByteString.$(H) $(INCLUDE_TOP)\stx\libbasic\True.$(H) $(INCLUDE_TOP)\stx\libbasic\Set.$(H) $(INCLUDE_TOP)\stx\libbasic2\Unicode32String.$(H) $(INCLUDE_TOP)\stx\libbasic2\FourByteString.$(H) $(INCLUDE_TOP)\stx\libbasic\Block.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libbasic\SmallInteger.$(H) $(INCLUDE_TOP)\stx\libbasic\Integer.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line
