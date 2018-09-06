# $Header: /cvs/stx/stx/libdb/nosql/goods/Make.spec,v 1.12 2013-03-31 12:18:45 cg Exp $
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_libdb_nosql_goods.
#
# Warning: once you modify this file, do not rerun
# stmkmp or projectDefinition-build again - otherwise, your changes are lost.
#
# This file contains specifications which are common to all platforms.
#

# Do NOT CHANGE THESE DEFINITIONS
# (otherwise, ST/X will have a hard time to find out the packages location from its packageID,
#  to find the source code of a class and to find the library for a package)
MODULE=stx
MODULE_DIR=libdb/nosql/goods
PACKAGE=$(MODULE):$(MODULE_DIR)


# Argument(s) to the stc compiler (stc --usage).
#  -headerDir=. : create header files locally
#                (if removed, they will be created as common
#  -Pxxx       : defines the package
#  -Zxxx       : a prefix for variables within the classLib
#  -Dxxx       : defines passed to to CC for inline C-code
#  -Ixxx       : include path passed to CC for inline C-code
#  +optspace   : optimized for space
#  +optspace2  : optimized more for space
#  +optspace3  : optimized even more for space
#  +optinline  : generate inline code for some ST constructs
#  +inlineNew  : additionally inline new
#  +inlineMath : additionally inline some floatPnt math stuff
#
# ********** OPTIONAL: MODIFY the next line(s) ***
# STCLOCALOPTIMIZATIONS=+optinline +inlineNew
# STCLOCALOPTIMIZATIONS=+optspace3
STCLOCALOPTIMIZATIONS=+optspace3


# Argument(s) to the stc compiler (stc --usage).
#  -warn            : no warnings
#  -warnNonStandard : no warnings about ST/X extensions
#  -warnEOLComments : no warnings about EOL comment extension
#  -warnPrivacy     : no warnings about privateClass extension
#
# ********** OPTIONAL: MODIFY the next line(s) ***
# STCWARNINGS=-warn
# STCWARNINGS=-warnNonStandard
# STCWARNINGS=-warnEOLComments
STCWARNINGS=-warnNonStandard

COMMON_CLASSES= \
	KKAbstractWriteBarrier \
	KKCache \
	KKCachePolicy \
	KKClassDescriptor \
	KKClassRecord \
	KKCommitFailure \
	KKConcurrencyPolicy \
	KKConnection \
	KKDatabase \
	KKDirtySet \
	KKDocumentation \
	KKFieldContainer \
	KKFieldRecord \
	KKFieldType \
	KKGoodsUpdateCounter \
	KKIsolationLevel \
	KKLockFailed \
	KKObjectProxy \
	KKObjectRecord \
	KKPlatform \
	KKTestDocumentation \
	KKTransport \
	stx_libdb_nosql_goods \
	KKAllocationCache \
	KKBlobField \
	KKBooleanField \
	KKClassCache \
	KKDoubleField \
	KKEmptyWriteBarrier \
	KKFixedArrayContainer \
	KKFloatField \
	KKImmutableGoodsUpdateCounter \
	KKKeyCache \
	KKLRUCachePolicy \
	KKManualWriteBarrier \
	KKNonWriteBarrier \
	KKOptimisticLockPolicy \
	KKPessimisticLockPolicy \
	KKReadWriteIsolationLevel \
	KKRecordCache \
	KKReferenceField \
	KKSingleFieldContainer \
	KKStringField \
	KKStructureContainer \
	KKThreadSafeDatabase \
	KKUnboundedCachePolicy \
	KKUnsignedIntegerField \
	KKVariableClassDescriptor \
	KKVariableFieldContainer \
	KKWriteWriteIsolationLevel \
	KKConflictFreeLockPolicy \
	KKSignedIntegerField \
	KKStringArrayField \
	KKStringDescriptor \
	KKMetaclassDescriptor \
	KKSymbolDescriptor \
	KKDictionary \
	KKIdentityBTree \
	KKIdentitySet \
	KKOrderedCollection \
	KKSet \
	KKClassMapper \




COMMON_OBJS= \
    $(OUTDIR_SLASH)KKAbstractWriteBarrier.$(O) \
    $(OUTDIR_SLASH)KKCache.$(O) \
    $(OUTDIR_SLASH)KKCachePolicy.$(O) \
    $(OUTDIR_SLASH)KKClassDescriptor.$(O) \
    $(OUTDIR_SLASH)KKClassRecord.$(O) \
    $(OUTDIR_SLASH)KKCommitFailure.$(O) \
    $(OUTDIR_SLASH)KKConcurrencyPolicy.$(O) \
    $(OUTDIR_SLASH)KKConnection.$(O) \
    $(OUTDIR_SLASH)KKDatabase.$(O) \
    $(OUTDIR_SLASH)KKDirtySet.$(O) \
    $(OUTDIR_SLASH)KKDocumentation.$(O) \
    $(OUTDIR_SLASH)KKFieldContainer.$(O) \
    $(OUTDIR_SLASH)KKFieldRecord.$(O) \
    $(OUTDIR_SLASH)KKFieldType.$(O) \
    $(OUTDIR_SLASH)KKGoodsUpdateCounter.$(O) \
    $(OUTDIR_SLASH)KKIsolationLevel.$(O) \
    $(OUTDIR_SLASH)KKLockFailed.$(O) \
    $(OUTDIR_SLASH)KKObjectProxy.$(O) \
    $(OUTDIR_SLASH)KKObjectRecord.$(O) \
    $(OUTDIR_SLASH)KKPlatform.$(O) \
    $(OUTDIR_SLASH)KKTestDocumentation.$(O) \
    $(OUTDIR_SLASH)KKTransport.$(O) \
    $(OUTDIR_SLASH)stx_libdb_nosql_goods.$(O) \
    $(OUTDIR_SLASH)KKAllocationCache.$(O) \
    $(OUTDIR_SLASH)KKBlobField.$(O) \
    $(OUTDIR_SLASH)KKBooleanField.$(O) \
    $(OUTDIR_SLASH)KKClassCache.$(O) \
    $(OUTDIR_SLASH)KKDoubleField.$(O) \
    $(OUTDIR_SLASH)KKEmptyWriteBarrier.$(O) \
    $(OUTDIR_SLASH)KKFixedArrayContainer.$(O) \
    $(OUTDIR_SLASH)KKFloatField.$(O) \
    $(OUTDIR_SLASH)KKImmutableGoodsUpdateCounter.$(O) \
    $(OUTDIR_SLASH)KKKeyCache.$(O) \
    $(OUTDIR_SLASH)KKLRUCachePolicy.$(O) \
    $(OUTDIR_SLASH)KKManualWriteBarrier.$(O) \
    $(OUTDIR_SLASH)KKNonWriteBarrier.$(O) \
    $(OUTDIR_SLASH)KKOptimisticLockPolicy.$(O) \
    $(OUTDIR_SLASH)KKPessimisticLockPolicy.$(O) \
    $(OUTDIR_SLASH)KKReadWriteIsolationLevel.$(O) \
    $(OUTDIR_SLASH)KKRecordCache.$(O) \
    $(OUTDIR_SLASH)KKReferenceField.$(O) \
    $(OUTDIR_SLASH)KKSingleFieldContainer.$(O) \
    $(OUTDIR_SLASH)KKStringField.$(O) \
    $(OUTDIR_SLASH)KKStructureContainer.$(O) \
    $(OUTDIR_SLASH)KKThreadSafeDatabase.$(O) \
    $(OUTDIR_SLASH)KKUnboundedCachePolicy.$(O) \
    $(OUTDIR_SLASH)KKUnsignedIntegerField.$(O) \
    $(OUTDIR_SLASH)KKVariableClassDescriptor.$(O) \
    $(OUTDIR_SLASH)KKVariableFieldContainer.$(O) \
    $(OUTDIR_SLASH)KKWriteWriteIsolationLevel.$(O) \
    $(OUTDIR_SLASH)KKConflictFreeLockPolicy.$(O) \
    $(OUTDIR_SLASH)KKSignedIntegerField.$(O) \
    $(OUTDIR_SLASH)KKStringArrayField.$(O) \
    $(OUTDIR_SLASH)KKStringDescriptor.$(O) \
    $(OUTDIR_SLASH)KKMetaclassDescriptor.$(O) \
    $(OUTDIR_SLASH)KKSymbolDescriptor.$(O) \
    $(OUTDIR_SLASH)KKDictionary.$(O) \
    $(OUTDIR_SLASH)KKIdentityBTree.$(O) \
    $(OUTDIR_SLASH)KKIdentitySet.$(O) \
    $(OUTDIR_SLASH)KKOrderedCollection.$(O) \
    $(OUTDIR_SLASH)KKSet.$(O) \
    $(OUTDIR_SLASH)KKClassMapper.$(O) \
    $(OUTDIR_SLASH)extensions.$(O) \



