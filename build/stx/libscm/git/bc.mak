# $Header$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_libscm_git.
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

LIBNAME=libstx_libscm_git
RESFILES=git.res



LOCALINCLUDES= -I$(INCLUDE_TOP)\stx\libview -I$(INCLUDE_TOP)\stx\libwidg -I$(INCLUDE_TOP)\stx\libview2 -I$(INCLUDE_TOP)\stx\libscm\common -I$(INCLUDE_TOP)\stx\goodies\sunit -I$(INCLUDE_TOP)\stx\libwidg2 -I$(INCLUDE_TOP)\stx\libbasic -I$(INCLUDE_TOP)\stx\libbasic3 -I$(INCLUDE_TOP)\stx\libsvn -I$(INCLUDE_TOP)\stx\libtool
LOCALDEFINES=

STCLOCALOPT=-package=$(PACKAGE) -I. $(LOCALINCLUDES) -headerDir=. $(STCLOCALOPTIMIZATIONS) $(STCWARNINGS) $(LOCALDEFINES)  -varPrefix=$(LIBNAME)
LOCALLIBS=

OBJS= $(COMMON_OBJS) $(WIN32_OBJS)

ALL::  classLibRule

classLibRule: $(OUTDIR) $(OUTDIR)$(LIBNAME).dll

!INCLUDE $(TOP)\rules\stdRules_bc

# build all prerequisite packages for this package
prereq:
	pushd ..\..\libbasic & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libbasic2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libcomp & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libview & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libdb & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libview2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libboss & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libdb\libodbc & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libdb\libsqlite & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\goodies\sunit & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libui & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libbasic3 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libwidg & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libview3 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\goodies\xml\vw & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libhtml & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libwidg2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libtool & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libcompat & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libtool2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libsvn & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\common & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\librun & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "





# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
$(OUTDIR)GitAttrType.$(O) GitAttrType.$(H): GitAttrType.st $(INCLUDE_TOP)\stx\libbasic\SharedPool.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitBlobHandle.$(O) GitBlobHandle.$(H): GitBlobHandle.st $(INCLUDE_TOP)\stx\libbasic\ExternalAddress.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitBranchType.$(O) GitBranchType.$(H): GitBranchType.st $(INCLUDE_TOP)\stx\libbasic\SharedPool.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitCheckoutStrategy.$(O) GitCheckoutStrategy.$(H): GitCheckoutStrategy.st $(INCLUDE_TOP)\stx\libbasic\SharedPool.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitCommand.$(O) GitCommand.$(H): GitCommand.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitCommitDialog.$(O) GitCommitDialog.$(H): GitCommitDialog.st $(INCLUDE_TOP)\stx\libscm\common\SCMAbstractCommitDialog.$(H) $(INCLUDE_TOP)\stx\libscm\common\SCMAbstractDialog.$(H) $(INCLUDE_TOP)\stx\libview2\SimpleDialog.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitCommitHandle.$(O) GitCommitHandle.$(H): GitCommitHandle.st $(INCLUDE_TOP)\stx\libbasic\ExternalAddress.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitConfigHandle.$(O) GitConfigHandle.$(H): GitConfigHandle.st $(INCLUDE_TOP)\stx\libbasic\ExternalAddress.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitCvarType.$(O) GitCvarType.$(H): GitCvarType.st $(INCLUDE_TOP)\stx\libbasic\SharedPool.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitDeltaType.$(O) GitDeltaType.$(H): GitDeltaType.st $(INCLUDE_TOP)\stx\libbasic\SharedPool.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitDiffListHandle.$(O) GitDiffListHandle.$(H): GitDiffListHandle.st $(INCLUDE_TOP)\stx\libbasic\ExternalAddress.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitErrorKlass.$(O) GitErrorKlass.$(H): GitErrorKlass.st $(INCLUDE_TOP)\stx\libbasic\SharedPool.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitFilemodeType.$(O) GitFilemodeType.$(H): GitFilemodeType.st $(INCLUDE_TOP)\stx\libbasic\SharedPool.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitIconLibrary.$(O) GitIconLibrary.$(H): GitIconLibrary.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitIndexHandle.$(O) GitIndexHandle.$(H): GitIndexHandle.st $(INCLUDE_TOP)\stx\libbasic\ExternalAddress.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitIndexerHandle.$(O) GitIndexerHandle.$(H): GitIndexerHandle.st $(INCLUDE_TOP)\stx\libbasic\ExternalAddress.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitIndexerStreamHandle.$(O) GitIndexerStreamHandle.$(H): GitIndexerStreamHandle.st $(INCLUDE_TOP)\stx\libbasic\ExternalAddress.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitLibraryObject.$(O) GitLibraryObject.$(H): GitLibraryObject.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitNoteHandle.$(O) GitNoteHandle.$(H): GitNoteHandle.st $(INCLUDE_TOP)\stx\libbasic\ExternalAddress.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitObjectHandle.$(O) GitObjectHandle.$(H): GitObjectHandle.st $(INCLUDE_TOP)\stx\libbasic\ExternalAddress.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitObjectType.$(O) GitObjectType.$(H): GitObjectType.st $(INCLUDE_TOP)\stx\libbasic\SharedPool.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitOdbHandle.$(O) GitOdbHandle.$(H): GitOdbHandle.st $(INCLUDE_TOP)\stx\libbasic\ExternalAddress.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitOdbObjectHandle.$(O) GitOdbObjectHandle.$(H): GitOdbObjectHandle.st $(INCLUDE_TOP)\stx\libbasic\ExternalAddress.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitOid.$(O) GitOid.$(H): GitOid.st $(INCLUDE_TOP)\stx\libbasic\ByteArray.$(H) $(INCLUDE_TOP)\stx\libbasic\UninterpretedBytes.$(H) $(INCLUDE_TOP)\stx\libbasic\ArrayedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitOidShortenHandle.$(O) GitOidShortenHandle.$(H): GitOidShortenHandle.st $(INCLUDE_TOP)\stx\libbasic\ExternalAddress.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitPackageModel.$(O) GitPackageModel.$(H): GitPackageModel.st $(INCLUDE_TOP)\stx\libscm\common\SCMAbstractPackageModel.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitPackageModelRegistry.$(O) GitPackageModelRegistry.$(H): GitPackageModelRegistry.st $(INCLUDE_TOP)\stx\libscm\common\SCMAbstractPackageModelRegistry.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitPrimitives.$(O) GitPrimitives.$(H): GitPrimitives.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitRefType.$(O) GitRefType.$(H): GitRefType.st $(INCLUDE_TOP)\stx\libbasic\SharedPool.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitReferenceHandle.$(O) GitReferenceHandle.$(H): GitReferenceHandle.st $(INCLUDE_TOP)\stx\libbasic\ExternalAddress.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitReflogEntryHandle.$(O) GitReflogEntryHandle.$(H): GitReflogEntryHandle.st $(INCLUDE_TOP)\stx\libbasic\ExternalAddress.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitReflogHandle.$(O) GitReflogHandle.$(H): GitReflogHandle.st $(INCLUDE_TOP)\stx\libbasic\ExternalAddress.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitRefspecHandle.$(O) GitRefspecHandle.$(H): GitRefspecHandle.st $(INCLUDE_TOP)\stx\libbasic\ExternalAddress.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitRemoteCompletionType.$(O) GitRemoteCompletionType.$(H): GitRemoteCompletionType.st $(INCLUDE_TOP)\stx\libbasic\SharedPool.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitRemoteHandle.$(O) GitRemoteHandle.$(H): GitRemoteHandle.st $(INCLUDE_TOP)\stx\libbasic\ExternalAddress.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitRepositoryHandle.$(O) GitRepositoryHandle.$(H): GitRepositoryHandle.st $(INCLUDE_TOP)\stx\libbasic\ExternalAddress.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitResetType.$(O) GitResetType.$(H): GitResetType.st $(INCLUDE_TOP)\stx\libbasic\SharedPool.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitRevwalkHandle.$(O) GitRevwalkHandle.$(H): GitRevwalkHandle.st $(INCLUDE_TOP)\stx\libbasic\ExternalAddress.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitSignatureQuery.$(O) GitSignatureQuery.$(H): GitSignatureQuery.st $(INCLUDE_TOP)\stx\libbasic\Query.$(H) $(INCLUDE_TOP)\stx\libbasic\Notification.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitSourceCodeManagementSettingsAppl2.$(O) GitSourceCodeManagementSettingsAppl2.$(H): GitSourceCodeManagementSettingsAppl2.st $(INCLUDE_TOP)\stx\libtool\AbstractSourceCodeManagementSettingsAppl.$(H) $(INCLUDE_TOP)\stx\libtool\AbstractSettingsApplication.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitSourceCodeManager2.$(O) GitSourceCodeManager2.$(H): GitSourceCodeManager2.st $(INCLUDE_TOP)\stx\libscm\common\SCMAbstractSourceCodeManager.$(H) $(INCLUDE_TOP)\stx\libbasic3\AbstractSourceCodeManager.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitStatusCodes.$(O) GitStatusCodes.$(H): GitStatusCodes.st $(INCLUDE_TOP)\stx\libbasic\SharedPool.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitStatusShowType.$(O) GitStatusShowType.$(H): GitStatusShowType.st $(INCLUDE_TOP)\stx\libbasic\SharedPool.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitStructure.$(O) GitStructure.$(H): GitStructure.st $(INCLUDE_TOP)\stx\libbasic\ExternalStructure.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalBytes.$(H) $(INCLUDE_TOP)\stx\libbasic\UninterpretedBytes.$(H) $(INCLUDE_TOP)\stx\libbasic\ArrayedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitSubmoduleHandle.$(O) GitSubmoduleHandle.$(H): GitSubmoduleHandle.st $(INCLUDE_TOP)\stx\libbasic\ExternalAddress.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitSubmoduleIgnoreType.$(O) GitSubmoduleIgnoreType.$(H): GitSubmoduleIgnoreType.st $(INCLUDE_TOP)\stx\libbasic\SharedPool.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitSubmoduleStatusType.$(O) GitSubmoduleStatusType.$(H): GitSubmoduleStatusType.st $(INCLUDE_TOP)\stx\libbasic\SharedPool.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitSubmoduleUpdateType.$(O) GitSubmoduleUpdateType.$(H): GitSubmoduleUpdateType.st $(INCLUDE_TOP)\stx\libbasic\SharedPool.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitTagHandle.$(O) GitTagHandle.$(H): GitTagHandle.st $(INCLUDE_TOP)\stx\libbasic\ExternalAddress.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitTreeEntryHandle.$(O) GitTreeEntryHandle.$(H): GitTreeEntryHandle.st $(INCLUDE_TOP)\stx\libbasic\ExternalAddress.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitTreeHandle.$(O) GitTreeHandle.$(H): GitTreeHandle.st $(INCLUDE_TOP)\stx\libbasic\ExternalAddress.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitTreebuilderHandle.$(O) GitTreebuilderHandle.$(H): GitTreebuilderHandle.st $(INCLUDE_TOP)\stx\libbasic\ExternalAddress.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitTreewalkModeType.$(O) GitTreewalkModeType.$(H): GitTreewalkModeType.st $(INCLUDE_TOP)\stx\libbasic\SharedPool.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)stx_libscm_git.$(O) stx_libscm_git.$(H): stx_libscm_git.st $(INCLUDE_TOP)\stx\libbasic\LibraryDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitAuthorQuery.$(O) GitAuthorQuery.$(H): GitAuthorQuery.st $(INCLUDE_TOP)\stx\libscm\git\GitSignatureQuery.$(H) $(INCLUDE_TOP)\stx\libbasic\Query.$(H) $(INCLUDE_TOP)\stx\libbasic\Notification.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitCheckoutOptions.$(O) GitCheckoutOptions.$(H): GitCheckoutOptions.st $(INCLUDE_TOP)\stx\libscm\git\GitCheckoutStrategy.$(H) $(INCLUDE_TOP)\stx\libscm\git\GitStructure.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalStructure.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalBytes.$(H) $(INCLUDE_TOP)\stx\libbasic\UninterpretedBytes.$(H) $(INCLUDE_TOP)\stx\libbasic\ArrayedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitCommitterQuery.$(O) GitCommitterQuery.$(H): GitCommitterQuery.st $(INCLUDE_TOP)\stx\libscm\git\GitSignatureQuery.$(H) $(INCLUDE_TOP)\stx\libbasic\Query.$(H) $(INCLUDE_TOP)\stx\libbasic\Notification.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitConfigFileStructure.$(O) GitConfigFileStructure.$(H): GitConfigFileStructure.st $(INCLUDE_TOP)\stx\libscm\git\GitStructure.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalStructure.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalBytes.$(H) $(INCLUDE_TOP)\stx\libbasic\UninterpretedBytes.$(H) $(INCLUDE_TOP)\stx\libbasic\ArrayedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitCvarMapStructure.$(O) GitCvarMapStructure.$(H): GitCvarMapStructure.st $(INCLUDE_TOP)\stx\libscm\git\GitStructure.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalStructure.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalBytes.$(H) $(INCLUDE_TOP)\stx\libbasic\UninterpretedBytes.$(H) $(INCLUDE_TOP)\stx\libbasic\ArrayedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitDiffDeltaStructure.$(O) GitDiffDeltaStructure.$(H): GitDiffDeltaStructure.st $(INCLUDE_TOP)\stx\libscm\git\GitStructure.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalStructure.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalBytes.$(H) $(INCLUDE_TOP)\stx\libbasic\UninterpretedBytes.$(H) $(INCLUDE_TOP)\stx\libbasic\ArrayedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitDiffFileStructure.$(O) GitDiffFileStructure.$(H): GitDiffFileStructure.st $(INCLUDE_TOP)\stx\libscm\git\GitStructure.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalStructure.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalBytes.$(H) $(INCLUDE_TOP)\stx\libbasic\UninterpretedBytes.$(H) $(INCLUDE_TOP)\stx\libbasic\ArrayedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitDiffOptionsStructure.$(O) GitDiffOptionsStructure.$(H): GitDiffOptionsStructure.st $(INCLUDE_TOP)\stx\libscm\git\GitStructure.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalStructure.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalBytes.$(H) $(INCLUDE_TOP)\stx\libbasic\UninterpretedBytes.$(H) $(INCLUDE_TOP)\stx\libbasic\ArrayedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitDiffRangeStructure.$(O) GitDiffRangeStructure.$(H): GitDiffRangeStructure.st $(INCLUDE_TOP)\stx\libscm\git\GitStructure.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalStructure.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalBytes.$(H) $(INCLUDE_TOP)\stx\libbasic\UninterpretedBytes.$(H) $(INCLUDE_TOP)\stx\libbasic\ArrayedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitError.$(O) GitError.$(H): GitError.st $(INCLUDE_TOP)\stx\libscm\git\GitErrorKlass.$(H) $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitErrorStructure.$(O) GitErrorStructure.$(H): GitErrorStructure.st $(INCLUDE_TOP)\stx\libscm\git\GitStructure.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalStructure.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalBytes.$(H) $(INCLUDE_TOP)\stx\libbasic\UninterpretedBytes.$(H) $(INCLUDE_TOP)\stx\libbasic\ArrayedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitIndex.$(O) GitIndex.$(H): GitIndex.st $(INCLUDE_TOP)\stx\libscm\git\GitObjectType.$(H) $(INCLUDE_TOP)\stx\libscm\git\GitLibraryObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitIndexEntryStructure.$(O) GitIndexEntryStructure.$(H): GitIndexEntryStructure.st $(INCLUDE_TOP)\stx\libscm\git\GitStructure.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalStructure.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalBytes.$(H) $(INCLUDE_TOP)\stx\libbasic\UninterpretedBytes.$(H) $(INCLUDE_TOP)\stx\libbasic\ArrayedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitIndexEntryUnmergedStructure.$(O) GitIndexEntryUnmergedStructure.$(H): GitIndexEntryUnmergedStructure.st $(INCLUDE_TOP)\stx\libscm\git\GitStructure.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalStructure.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalBytes.$(H) $(INCLUDE_TOP)\stx\libbasic\UninterpretedBytes.$(H) $(INCLUDE_TOP)\stx\libbasic\ArrayedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitIndexTimeStructure.$(O) GitIndexTimeStructure.$(H): GitIndexTimeStructure.st $(INCLUDE_TOP)\stx\libscm\git\GitStructure.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalStructure.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalBytes.$(H) $(INCLUDE_TOP)\stx\libbasic\UninterpretedBytes.$(H) $(INCLUDE_TOP)\stx\libbasic\ArrayedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitIndexerStatsStructure.$(O) GitIndexerStatsStructure.$(H): GitIndexerStatsStructure.st $(INCLUDE_TOP)\stx\libscm\git\GitStructure.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalStructure.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalBytes.$(H) $(INCLUDE_TOP)\stx\libbasic\UninterpretedBytes.$(H) $(INCLUDE_TOP)\stx\libbasic\ArrayedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitNoteDataStructure.$(O) GitNoteDataStructure.$(H): GitNoteDataStructure.st $(INCLUDE_TOP)\stx\libscm\git\GitStructure.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalStructure.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalBytes.$(H) $(INCLUDE_TOP)\stx\libbasic\UninterpretedBytes.$(H) $(INCLUDE_TOP)\stx\libbasic\ArrayedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitOdbBackendStructure.$(O) GitOdbBackendStructure.$(H): GitOdbBackendStructure.st $(INCLUDE_TOP)\stx\libscm\git\GitStructure.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalStructure.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalBytes.$(H) $(INCLUDE_TOP)\stx\libbasic\UninterpretedBytes.$(H) $(INCLUDE_TOP)\stx\libbasic\ArrayedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitOdbStreamStructure.$(O) GitOdbStreamStructure.$(H): GitOdbStreamStructure.st $(INCLUDE_TOP)\stx\libscm\git\GitStructure.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalStructure.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalBytes.$(H) $(INCLUDE_TOP)\stx\libbasic\UninterpretedBytes.$(H) $(INCLUDE_TOP)\stx\libbasic\ArrayedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitReference.$(O) GitReference.$(H): GitReference.st $(INCLUDE_TOP)\stx\libscm\git\GitLibraryObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitRemoteCallbacksStructure.$(O) GitRemoteCallbacksStructure.$(H): GitRemoteCallbacksStructure.st $(INCLUDE_TOP)\stx\libscm\git\GitStructure.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalStructure.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalBytes.$(H) $(INCLUDE_TOP)\stx\libbasic\UninterpretedBytes.$(H) $(INCLUDE_TOP)\stx\libbasic\ArrayedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitRemoteHeadStructure.$(O) GitRemoteHeadStructure.$(H): GitRemoteHeadStructure.st $(INCLUDE_TOP)\stx\libscm\git\GitStructure.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalStructure.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalBytes.$(H) $(INCLUDE_TOP)\stx\libbasic\UninterpretedBytes.$(H) $(INCLUDE_TOP)\stx\libbasic\ArrayedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitRepository.$(O) GitRepository.$(H): GitRepository.st $(INCLUDE_TOP)\stx\libscm\git\GitObjectType.$(H) $(INCLUDE_TOP)\stx\libscm\git\GitStatusCodes.$(H) $(INCLUDE_TOP)\stx\libscm\git\GitLibraryObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitRepositoryInitOptionsStructure.$(O) GitRepositoryInitOptionsStructure.$(H): GitRepositoryInitOptionsStructure.st $(INCLUDE_TOP)\stx\libscm\git\GitStructure.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalStructure.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalBytes.$(H) $(INCLUDE_TOP)\stx\libbasic\UninterpretedBytes.$(H) $(INCLUDE_TOP)\stx\libbasic\ArrayedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitRepositoryObject.$(O) GitRepositoryObject.$(H): GitRepositoryObject.st $(INCLUDE_TOP)\stx\libscm\git\GitLibraryObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitSignature.$(O) GitSignature.$(H): GitSignature.st $(INCLUDE_TOP)\stx\libscm\git\GitLibraryObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitSignatureStructure.$(O) GitSignatureStructure.$(H): GitSignatureStructure.st $(INCLUDE_TOP)\stx\libscm\git\GitStructure.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalStructure.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalBytes.$(H) $(INCLUDE_TOP)\stx\libbasic\UninterpretedBytes.$(H) $(INCLUDE_TOP)\stx\libbasic\ArrayedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitStatusOptionsStructure.$(O) GitStatusOptionsStructure.$(H): GitStatusOptionsStructure.st $(INCLUDE_TOP)\stx\libscm\git\GitStructure.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalStructure.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalBytes.$(H) $(INCLUDE_TOP)\stx\libbasic\UninterpretedBytes.$(H) $(INCLUDE_TOP)\stx\libbasic\ArrayedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitStringArray.$(O) GitStringArray.$(H): GitStringArray.st $(INCLUDE_TOP)\stx\libscm\git\GitStructure.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalStructure.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalBytes.$(H) $(INCLUDE_TOP)\stx\libbasic\UninterpretedBytes.$(H) $(INCLUDE_TOP)\stx\libbasic\ArrayedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitTimeStructure.$(O) GitTimeStructure.$(H): GitTimeStructure.st $(INCLUDE_TOP)\stx\libscm\git\GitStructure.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalStructure.$(H) $(INCLUDE_TOP)\stx\libbasic\ExternalBytes.$(H) $(INCLUDE_TOP)\stx\libbasic\UninterpretedBytes.$(H) $(INCLUDE_TOP)\stx\libbasic\ArrayedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitWorkingCopyEntry.$(O) GitWorkingCopyEntry.$(H): GitWorkingCopyEntry.st $(INCLUDE_TOP)\stx\libscm\git\GitStatusCodes.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitObject.$(O) GitObject.$(H): GitObject.st $(INCLUDE_TOP)\stx\libscm\git\GitObjectType.$(H) $(INCLUDE_TOP)\stx\libscm\git\GitRepositoryObject.$(H) $(INCLUDE_TOP)\stx\libscm\git\GitLibraryObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitRemote.$(O) GitRemote.$(H): GitRemote.st $(INCLUDE_TOP)\stx\libscm\git\GitObjectType.$(H) $(INCLUDE_TOP)\stx\libscm\git\GitRepositoryObject.$(H) $(INCLUDE_TOP)\stx\libscm\git\GitLibraryObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitWorkingCopy.$(O) GitWorkingCopy.$(H): GitWorkingCopy.st $(INCLUDE_TOP)\stx\libscm\git\GitStatusCodes.$(H) $(INCLUDE_TOP)\stx\libscm\git\GitRepositoryObject.$(H) $(INCLUDE_TOP)\stx\libscm\git\GitLibraryObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitCommit.$(O) GitCommit.$(H): GitCommit.st $(INCLUDE_TOP)\stx\libscm\git\GitObject.$(H) $(INCLUDE_TOP)\stx\libscm\git\GitRepositoryObject.$(H) $(INCLUDE_TOP)\stx\libscm\git\GitLibraryObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitTag.$(O) GitTag.$(H): GitTag.st $(INCLUDE_TOP)\stx\libscm\git\GitObject.$(H) $(INCLUDE_TOP)\stx\libscm\git\GitRepositoryObject.$(H) $(INCLUDE_TOP)\stx\libscm\git\GitLibraryObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GitTree.$(O) GitTree.$(H): GitTree.st $(INCLUDE_TOP)\stx\libscm\git\GitObject.$(H) $(INCLUDE_TOP)\stx\libscm\git\GitRepositoryObject.$(H) $(INCLUDE_TOP)\stx\libscm\git\GitLibraryObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)extensions.$(O): extensions.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic3\SourceCodeManagerUtilitiesForWorkspaceBasedManagers.$(H) $(INCLUDE_TOP)\stx\libbasic3\SourceCodeManagerUtilities.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line
