#
# DO NOT EDIT 
# automatically generated from Make.proto
#
# $Header: /cvs/stx/stx/libboss/vms.mak,v 1.1 1999-09-18 15:03:07 cg Exp $
#
TOP=..
LIBNAME=libboss
STCOPT="+optinline +optinline2 -warnNonStandard"
STCLOCALOPT=-package=stx:$(LIBNAME) $(COMMONSYMBOLS) $(SEPINITCODE) $(RELOCINSTVARS) -varPrefix=$(LIBNAME)
ALL: $(LIBDIR)\$(LIBNAME).olb

OBJS=\
  $(OUTDIR)ObsoleteObject.$(O) \
  $(OUTDIR)BinaryObjectStorage.$(O) \
  $(OUTDIR)BinaryIOManager.$(O) \
  $(OUTDIR)BinaryInputManager.$(O) \
  $(OUTDIR)BinaryOutputManager.$(O) \


theLib:: $(LIBNAME).olb
	write sys$output "making class objects ..."
	$(MAKE) objs
	$(MAKE) libinit
	write sys$output "classlibrary $(LIBNAME).olb made."

$(LIBNAME).olb:
	write sys$output "creating initial $(LIBNAME).olb ..."
	lib/cre $(LIBNAME).olb

objs:  $(OBJS1)



# BEGINMAKEDEPEND
$(OUTDIR)BinaryIOManager.$(O) BinaryIOManager.$(H): BinaryIOManager.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)BinaryInputManager.$(O) BinaryInputManager.$(H): BinaryInputManager.st $(STCHDR)  ../include/BinaryIOManager.$(H)  ../include/Object.$(H) 
$(OUTDIR)BinaryObjectStorage.$(O) BinaryObjectStorage.$(H): BinaryObjectStorage.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)BinaryOutputManager.$(O) BinaryOutputManager.$(H): BinaryOutputManager.st $(STCHDR)  ../include/BinaryIOManager.$(H)  ../include/Object.$(H)  ../include/IdentityDictionary.$(H)  ../include/Dictionary.$(H)  ../include/Set.$(H)  ../include/Collection.$(H) 
$(OUTDIR)ObsoleteObject.$(O) ObsoleteObject.$(H): ObsoleteObject.st $(STCHDR) 
# ENDMAKEDEPEND
