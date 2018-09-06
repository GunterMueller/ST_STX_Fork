#
# DO NOT EDIT 
# automatically generated from Make.proto
#
# $Header: /cvs/stx/stx/libbasic3/vms.mak,v 1.4 1999/09/18 14:10:24 cg Exp $
#
TOP=..
LIBNAME=libbasic3
STCOPT="+optspace2 -warnNonStandard"
STCLOCALOPT=-package=stx:$(LIBNAME) $(COMMONSYMBOLS) $(SEPINITCODE) $(RELOCINSTVARS) -varPrefix=$(LIBNAME)
ALL: $(LIBDIR)\$(LIBNAME).olb

OBJS=\
  $(OUTDIR)Change.$(O) \
  $(OUTDIR)ClassChange.$(O) \
  $(OUTDIR)ClassCommentChange.$(O) \
  $(OUTDIR)ClassDefinitionChange.$(O) \
  $(OUTDIR)ClassPrimitiveChange.$(O) \
  $(OUTDIR)ClassInstVarDefinitionChange.$(O) \
  $(OUTDIR)ClassPrimitiveDefinitionsChange.$(O) \
  $(OUTDIR)ClassPrimitiveFunctionsChange.$(O) \
  $(OUTDIR)ClassPrimitiveVariablesChange.$(O) \
  $(OUTDIR)MethodChange.$(O) \
  $(OUTDIR)MethodCategoryChange.$(O) \
  $(OUTDIR)MethodPrivacyChange.$(O) \
  $(OUTDIR)DoItChange.$(O) \
  $(OUTDIR)ChangeSet.$(O) \
  $(OUTDIR)HistoryManager.$(O) \
  $(OUTDIR)MessageTally.$(O) \
  $(OUTDIR)CallChain.$(O) \
  $(OUTDIR)ProfileTree.$(O) \
  $(OUTDIR)MessageTracer.$(O) \
  $(OUTDIR)WrappedMethod.$(O) \
  $(OUTDIR)AbstractSourceCodeManager.$(O) \
  $(OUTDIR)CVSSourceCodeManager.$(O) \


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
$(OUTDIR)AbstractSourceCodeManager.$(O) AbstractSourceCodeManager.$(H): AbstractSourceCodeManager.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)CVSSourceCodeManager.$(O) CVSSourceCodeManager.$(H): CVSSourceCodeManager.st $(STCHDR)  ../include/AbstractSourceCodeManager.$(H)  ../include/Object.$(H) 
$(OUTDIR)CallChain.$(O) CallChain.$(H): CallChain.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)Change.$(O) Change.$(H): Change.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)ChangeSet.$(O) ChangeSet.$(H): ChangeSet.st $(STCHDR)  ../include/OrderedCollection.$(H)  ../include/SequenceableCollection.$(H)  ../include/Collection.$(H)  ../include/Object.$(H) 
$(OUTDIR)ClassChange.$(O) ClassChange.$(H): ClassChange.st $(STCHDR)  ../include/Change.$(H)  ../include/Object.$(H) 
$(OUTDIR)ClassCommentChange.$(O) ClassCommentChange.$(H): ClassCommentChange.st $(STCHDR)  ../include/ClassChange.$(H)  ../include/Change.$(H)  ../include/Object.$(H) 
$(OUTDIR)ClassDefinitionChange.$(O) ClassDefinitionChange.$(H): ClassDefinitionChange.st $(STCHDR)  ../include/ClassChange.$(H)  ../include/Change.$(H)  ../include/Object.$(H) 
$(OUTDIR)ClassInstVarDefinitionChange.$(O) ClassInstVarDefinitionChange.$(H): ClassInstVarDefinitionChange.st $(STCHDR)  ../include/ClassChange.$(H)  ../include/Change.$(H)  ../include/Object.$(H) 
$(OUTDIR)ClassOrganizer.$(O) ClassOrganizer.$(H): ClassOrganizer.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)ClassPrimitiveChange.$(O) ClassPrimitiveChange.$(H): ClassPrimitiveChange.st $(STCHDR)  ../include/ClassChange.$(H)  ../include/Change.$(H)  ../include/Object.$(H) 
$(OUTDIR)ClassPrimitiveDefinitionsChange.$(O) ClassPrimitiveDefinitionsChange.$(H): ClassPrimitiveDefinitionsChange.st $(STCHDR)  ../include/ClassPrimitiveChange.$(H)  ../include/ClassChange.$(H)  ../include/Change.$(H)  ../include/Object.$(H) 
$(OUTDIR)ClassPrimitiveFunctionsChange.$(O) ClassPrimitiveFunctionsChange.$(H): ClassPrimitiveFunctionsChange.st $(STCHDR)  ../include/ClassPrimitiveChange.$(H)  ../include/ClassChange.$(H)  ../include/Change.$(H)  ../include/Object.$(H) 
$(OUTDIR)ClassPrimitiveVariablesChange.$(O) ClassPrimitiveVariablesChange.$(H): ClassPrimitiveVariablesChange.st $(STCHDR)  ../include/ClassPrimitiveChange.$(H)  ../include/ClassChange.$(H)  ../include/Change.$(H)  ../include/Object.$(H) 
$(OUTDIR)ClassRemoveChange.$(O) ClassRemoveChange.$(H): ClassRemoveChange.st $(STCHDR)  ../include/ClassChange.$(H)  ../include/Change.$(H)  ../include/Object.$(H) 
$(OUTDIR)ClassRenameChange.$(O) ClassRenameChange.$(H): ClassRenameChange.st $(STCHDR)  ../include/ClassChange.$(H)  ../include/Change.$(H)  ../include/Object.$(H) 
$(OUTDIR)DoItChange.$(O) DoItChange.$(H): DoItChange.st $(STCHDR)  ../include/Change.$(H)  ../include/Object.$(H) 
$(OUTDIR)FlatDirectorySourceCodeManager.$(O) FlatDirectorySourceCodeManager.$(H): FlatDirectorySourceCodeManager.st $(STCHDR) 
$(OUTDIR)HierarchicalDirectorySourceCodeManager.$(O) HierarchicalDirectorySourceCodeManager.$(H): HierarchicalDirectorySourceCodeManager.st $(STCHDR) 
$(OUTDIR)HistoryManager.$(O) HistoryManager.$(H): HistoryManager.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)MessageTally.$(O) MessageTally.$(H): MessageTally.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)MessageTracer.$(O) MessageTracer.$(H): MessageTracer.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)MethodCategoryChange.$(O) MethodCategoryChange.$(H): MethodCategoryChange.st $(STCHDR)  ../include/MethodChange.$(H)  ../include/ClassChange.$(H)  ../include/Change.$(H)  ../include/Object.$(H) 
$(OUTDIR)MethodCategoryRenameChange.$(O) MethodCategoryRenameChange.$(H): MethodCategoryRenameChange.st $(STCHDR)  ../include/ClassChange.$(H)  ../include/Change.$(H)  ../include/Object.$(H) 
$(OUTDIR)MethodChange.$(O) MethodChange.$(H): MethodChange.st $(STCHDR)  ../include/ClassChange.$(H)  ../include/Change.$(H)  ../include/Object.$(H) 
$(OUTDIR)MethodPrivacyChange.$(O) MethodPrivacyChange.$(H): MethodPrivacyChange.st $(STCHDR)  ../include/MethodChange.$(H)  ../include/ClassChange.$(H)  ../include/Change.$(H)  ../include/Object.$(H) 
$(OUTDIR)MethodRemoveChange.$(O) MethodRemoveChange.$(H): MethodRemoveChange.st $(STCHDR)  ../include/ClassChange.$(H)  ../include/Change.$(H)  ../include/Object.$(H) 
$(OUTDIR)NameSpaceCreationChange.$(O) NameSpaceCreationChange.$(H): NameSpaceCreationChange.st $(STCHDR)  ../include/Change.$(H)  ../include/Object.$(H) 
$(OUTDIR)NonVersioningSourceCodeManager.$(O) NonVersioningSourceCodeManager.$(H): NonVersioningSourceCodeManager.st $(STCHDR)  ../include/AbstractSourceCodeManager.$(H)  ../include/Object.$(H) 
$(OUTDIR)ProfileTree.$(O) ProfileTree.$(H): ProfileTree.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)RCSSourceCodeManager.$(O) RCSSourceCodeManager.$(H): RCSSourceCodeManager.st $(STCHDR)  ../include/AbstractSourceCodeManager.$(H)  ../include/Object.$(H) 
$(OUTDIR)SimulatedClassPool.$(O) SimulatedClassPool.$(H): SimulatedClassPool.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)SystemOrganizer.$(O) SystemOrganizer.$(H): SystemOrganizer.st $(STCHDR)  ../include/Object.$(H) 
$(OUTDIR)WrappedMethod.$(O) WrappedMethod.$(H): WrappedMethod.st $(STCHDR)  ../include/Method.$(H)  ../include/CompiledCode.$(H)  ../include/ExecutableFunction.$(H)  ../include/Object.$(H) 
# ENDMAKEDEPEND
