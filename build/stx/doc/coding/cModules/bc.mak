# $Header: /cvs/stx/stx/doc/coding/cModules/bc.mak,v 1.3 2016-06-03 13:24:24 sr Exp $
#
# manually generated
# Warning: do not rerun
# stmkmp or projectDefinition-build again - otherwise, your changes are lost.
#
TOP=..\..\..
INCLUDE_TOP=$(TOP)\..
LIBNAME=libstx_doc_coding_cModules
LOCALINCLUDES=-I$(INCLUDE_TOP)\stx\libbasic
STCLOCALOPT=-package=$(PACKAGE) -I. $(LOCALINCLUDES) $(STCLOCALOPTIMIZATIONS) $(STCWARNINGS) $(LOCALDEFINES) -headerDir=. -varPrefix=$(LIBNAME)
CLINK_LIBS=import32.lib $(RT_LIB)

!include "Make.spec"

CLASSES= \
	CModuleDemo

OBJS= \
    $(OUTDIR_SLASH)CModuleDemo.$(O)

!INCLUDE $(TOP)\rules\stdHeader_bc

# !INCLUDE Make.spec


all::  classLibRule $(COBJS) demoCLib1.dll demoCLib2.dll demoCLib3.dll

classLibRule: $(OUTDIR) $(OUTDIR)$(LIBNAME).dll

!INCLUDE $(TOP)\rules\stdRules_bc

clean::
	-del CModuleDemo.c

clobber::
	-del demoCLib1.dll demoCLib2.dll demoCLib3.dll

demoCLib1.dll: demo1.$(O)
	$(MAKE_BAT) -DCLIB="demoCLib1" -DCOBJS="demo1.$(O)" cLibRule

demoCLib2.dll: demo2.$(O)
	$(MAKE_BAT) -DCLIB="demoCLib2" -DCOBJS="demo2.$(O)" cLibRule

demoCLib3.dll: demo3.$(O)
	$(MAKE_BAT) -DCLIB="demoCLib3" -DCOBJS="demo3.$(O)" cLibRule

# USEBC=$(USEBC) USEVC=$(USEVC) USEMINGW64=$(USEMINGW64) USEMINGW32=$(USEMINGW32)

# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
$(OUTDIR)CModuleDemo.$(O) CModuleDemo.$(H): CModuleDemo.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line
