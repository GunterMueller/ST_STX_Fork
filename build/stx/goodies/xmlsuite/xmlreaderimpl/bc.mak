# $Header$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_xmlsuite_xmlreaderimpl.
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
TOP=..\..\..
INCLUDE_TOP=$(TOP)\..



!INCLUDE $(TOP)\rules\stdHeader_bc

!INCLUDE Make.spec

LIBNAME=libstx_goodies_xmlsuite_xmlreaderimpl
MODULE_PATH=goodies\xmlsuite\xmlreaderimpl
RESFILES=xmlreaderimpl.$(RES)



LOCALINCLUDES= -I$(INCLUDE_TOP)\stx\goodies\xml\vw -I$(INCLUDE_TOP)\stx\goodies\xmlsuite\core -I$(INCLUDE_TOP)\stx\libbasic
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
	pushd ..\..\xml\vw & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libbasic2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libview & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libview2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libwidg & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libwidg2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\core & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "







test: $(TOP)\goodies\builder\reports\NUL
	pushd $(TOP)\goodies\builder\reports & $(MAKE_BAT)
	$(TOP)\goodies\builder\reports\report-runner.bat -D . -r Builder::TestReport -p $(PACKAGE)
        
clean::
	del *.$(CSUFFIX)


# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
$(OUTDIR)XMLv2__VWSAXBuilder.$(O) XMLv2__VWSAXBuilder.$(H): XMLv2__VWSAXBuilder.st $(INCLUDE_TOP)\stx\goodies\xml\vw\NodeBuilder.$(H) $(INCLUDE_TOP)\stx\goodies\xml\vw\SAXBuilder.$(H) $(INCLUDE_TOP)\stx\goodies\xml\vw\XMLNodeBuilder.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)XMLv2__VWXMLReader.$(O) XMLv2__VWXMLReader.$(H): XMLv2__VWXMLReader.st $(INCLUDE_TOP)\stx\goodies\xml\vw\StreamWrapper.$(H) $(INCLUDE_TOP)\stx\goodies\xml\vw\XMLParser.$(H) $(INCLUDE_TOP)\stx\goodies\xml\vw\XMLParserStX.$(H) $(INCLUDE_TOP)\stx\goodies\xmlsuite\core\XMLv2__XMLReader.$(H) $(INCLUDE_TOP)\stx\libbasic\Link.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)stx_goodies_xmlsuite_xmlreaderimpl.$(O) stx_goodies_xmlsuite_xmlreaderimpl.$(H): stx_goodies_xmlsuite_xmlreaderimpl.st $(INCLUDE_TOP)\stx\libbasic\LibraryDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line

# **Must be at end**

# Enforce recompilation of package definition class if Mercurial working
# copy state changes. Together with --guessVersion it ensures that package
# definition class always contains correct binary revision string.
!IFDEF HGROOT
$(OUTDIR)stx_goodies_xmlsuite_xmlreaderimpl.$(O): $(HGROOT)\.hg\dirstate
!ENDIF
