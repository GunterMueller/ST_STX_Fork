#
# DO NOT EDIT
# automagically generated from Make.proto (by make nt.mak)
#
TOP=..\..\..\stx

#
!INCLUDE $(TOP)\rules\stdHeader_bc
#
!INCLUDE Make.spec
#
STCLOCALOPT=-package=$(PACKAGE) $(SEPINITCODE) $(RELOCINSTVARS) -varPrefix=$(LIBNAME)

ALL:  $(OUTDIR) $(LIBDIR)\$(LIBNAME).lib $(OUTDIR)$(LIBNAME).dll


!INCLUDE $(TOP)\rules\stdRules_bc

#
# additional rules
#

# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
# ENDMAKEDEPEND --- do not remove this line
