# $Header$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_libjava_experiments.
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

LIBNAME=libstx_libjava_experiments
MODULE_PATH=libjava\experiments
RESFILES=stx_libjava_experimentsWINrc.$(RES)



LOCALINCLUDES= -I$(INCLUDE_TOP)\stx\libbasic -I$(INCLUDE_TOP)\stx\libjava
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
	pushd .. & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "




java_clean:
	ant -f java\build.xml clean

clean:: java_clean


java_compile:
	ant -f java\build.xml compile

ALL:: java_compile





test: $(TOP)\goodies\builder\reports\NUL
	pushd $(TOP)\goodies\builder\reports & $(MAKE_BAT)
	$(TOP)\goodies\builder\reports\report-runner.bat -D . -r Builder::TestReport -p $(PACKAGE)
        
clean::
	-del *.$(CSUFFIX)


# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
$(OUTDIR)JavaByteCodeInterpreter.$(O) JavaByteCodeInterpreter.$(C) JavaByteCodeInterpreter.$(H): JavaByteCodeInterpreter.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libjava\JavaByteCodeProcessor.$(H) $(STCHDR)
$(OUTDIR)JavaMethodWrapperCompiler.$(O) JavaMethodWrapperCompiler.$(C) JavaMethodWrapperCompiler.$(H): JavaMethodWrapperCompiler.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libjava\Java.$(H) $(STCHDR)
$(OUTDIR)NoReflectionObject.$(O) NoReflectionObject.$(C) NoReflectionObject.$(H): NoReflectionObject.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PersonSample.$(O) PersonSample.$(C) PersonSample.$(H): PersonSample.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SampleHandler.$(O) SampleHandler.$(C) SampleHandler.$(H): SampleHandler.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SetSample.$(O) SetSample.$(C) SetSample.$(H): SetSample.st $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\Set.$(H) $(STCHDR)
$(OUTDIR)stx_libjava_experiments.$(O) stx_libjava_experiments.$(C) stx_libjava_experiments.$(H): stx_libjava_experiments.st $(INCLUDE_TOP)\stx\libbasic\LibraryDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(STCHDR)
$(OUTDIR)JavaByteCodeSteppableInterpreter.$(O) JavaByteCodeSteppableInterpreter.$(C) JavaByteCodeSteppableInterpreter.$(H): JavaByteCodeSteppableInterpreter.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libjava\JavaByteCodeProcessor.$(H) $(INCLUDE_TOP)\stx\libjava\experiments\JavaByteCodeInterpreter.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line

# **Must be at end**

# Enforce recompilation of package definition class if Mercurial working
# copy state changes. Together with --guessVersion it ensures that package
# definition class always contains correct binary revision string.
!IFDEF HGROOT
$(OUTDIR)stx_libjava_experiments.$(O): $(HGROOT)\.hg\dirstate
!ENDIF
