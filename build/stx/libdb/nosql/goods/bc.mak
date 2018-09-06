# $Header: /cvs/stx/stx/libdb/nosql/goods/bc.mak,v 1.12 2013-03-31 12:19:12 cg Exp $
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_libdb_nosql_goods.
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

LIBNAME=libstx_libdb_nosql_goods
RESFILES=goods.$(RES)



LOCALINCLUDES= -I$(INCLUDE_TOP)\stx\libbasic2 -I$(INCLUDE_TOP)\stx\libview -I$(INCLUDE_TOP)\stx\libbasic
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
	pushd ..\..\..\libview & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "






clean::
	del *.$(CSUFFIX)

# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
$(OUTDIR)KKAbstractWriteBarrier.$(O) KKAbstractWriteBarrier.$(H): KKAbstractWriteBarrier.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)KKCache.$(O) KKCache.$(H): KKCache.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)KKCachePolicy.$(O) KKCachePolicy.$(H): KKCachePolicy.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)KKClassDescriptor.$(O) KKClassDescriptor.$(H): KKClassDescriptor.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)KKClassMapper.$(O) KKClassMapper.$(H): KKClassMapper.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)KKClassRecord.$(O) KKClassRecord.$(H): KKClassRecord.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)KKCommitFailure.$(O) KKCommitFailure.$(H): KKCommitFailure.st $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)KKConcurrencyPolicy.$(O) KKConcurrencyPolicy.$(H): KKConcurrencyPolicy.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)KKConnection.$(O) KKConnection.$(H): KKConnection.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)KKDatabase.$(O) KKDatabase.$(H): KKDatabase.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)KKDictionary.$(O) KKDictionary.$(H): KKDictionary.st $(INCLUDE_TOP)\stx\libbasic\Dictionary.$(H) $(INCLUDE_TOP)\stx\libbasic\Set.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)KKDirtySet.$(O) KKDirtySet.$(H): KKDirtySet.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)KKDocumentation.$(O) KKDocumentation.$(H): KKDocumentation.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)KKFieldContainer.$(O) KKFieldContainer.$(H): KKFieldContainer.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)KKFieldRecord.$(O) KKFieldRecord.$(H): KKFieldRecord.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)KKFieldType.$(O) KKFieldType.$(H): KKFieldType.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)KKGoodsUpdateCounter.$(O) KKGoodsUpdateCounter.$(H): KKGoodsUpdateCounter.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)KKIdentityBTree.$(O) KKIdentityBTree.$(H): KKIdentityBTree.st $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)KKIdentitySet.$(O) KKIdentitySet.$(H): KKIdentitySet.st $(INCLUDE_TOP)\stx\libbasic\Set.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)KKIsolationLevel.$(O) KKIsolationLevel.$(H): KKIsolationLevel.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)KKLockFailed.$(O) KKLockFailed.$(H): KKLockFailed.st $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)KKObjectProxy.$(O) KKObjectProxy.$(H): KKObjectProxy.st $(INCLUDE_TOP)\stx\libbasic\ProtoObject.$(H) $(STCHDR)
$(OUTDIR)KKObjectRecord.$(O) KKObjectRecord.$(H): KKObjectRecord.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)KKOrderedCollection.$(O) KKOrderedCollection.$(H): KKOrderedCollection.st $(INCLUDE_TOP)\stx\libbasic\OrderedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)KKPlatform.$(O) KKPlatform.$(H): KKPlatform.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)KKSet.$(O) KKSet.$(H): KKSet.st $(INCLUDE_TOP)\stx\libbasic\Set.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)KKTestDocumentation.$(O) KKTestDocumentation.$(H): KKTestDocumentation.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)KKTransport.$(O) KKTransport.$(H): KKTransport.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)stx_libdb_nosql_goods.$(O) stx_libdb_nosql_goods.$(H): stx_libdb_nosql_goods.st $(INCLUDE_TOP)\stx\libbasic\LibraryDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)KKAllocationCache.$(O) KKAllocationCache.$(H): KKAllocationCache.st $(INCLUDE_TOP)\stx\libdb\nosql\goods\KKCache.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)KKBlobField.$(O) KKBlobField.$(H): KKBlobField.st $(INCLUDE_TOP)\stx\libdb\nosql\goods\KKFieldType.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)KKBooleanField.$(O) KKBooleanField.$(H): KKBooleanField.st $(INCLUDE_TOP)\stx\libdb\nosql\goods\KKFieldType.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)KKClassCache.$(O) KKClassCache.$(H): KKClassCache.st $(INCLUDE_TOP)\stx\libdb\nosql\goods\KKCache.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)KKDoubleField.$(O) KKDoubleField.$(H): KKDoubleField.st $(INCLUDE_TOP)\stx\libdb\nosql\goods\KKFieldType.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)KKEmptyWriteBarrier.$(O) KKEmptyWriteBarrier.$(H): KKEmptyWriteBarrier.st $(INCLUDE_TOP)\stx\libdb\nosql\goods\KKAbstractWriteBarrier.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)KKFixedArrayContainer.$(O) KKFixedArrayContainer.$(H): KKFixedArrayContainer.st $(INCLUDE_TOP)\stx\libdb\nosql\goods\KKFieldContainer.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)KKFloatField.$(O) KKFloatField.$(H): KKFloatField.st $(INCLUDE_TOP)\stx\libdb\nosql\goods\KKFieldType.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)KKImmutableGoodsUpdateCounter.$(O) KKImmutableGoodsUpdateCounter.$(H): KKImmutableGoodsUpdateCounter.st $(INCLUDE_TOP)\stx\libdb\nosql\goods\KKGoodsUpdateCounter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)KKKeyCache.$(O) KKKeyCache.$(H): KKKeyCache.st $(INCLUDE_TOP)\stx\libdb\nosql\goods\KKCache.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)KKLRUCachePolicy.$(O) KKLRUCachePolicy.$(H): KKLRUCachePolicy.st $(INCLUDE_TOP)\stx\libdb\nosql\goods\KKCachePolicy.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)KKManualWriteBarrier.$(O) KKManualWriteBarrier.$(H): KKManualWriteBarrier.st $(INCLUDE_TOP)\stx\libdb\nosql\goods\KKAbstractWriteBarrier.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)KKNonWriteBarrier.$(O) KKNonWriteBarrier.$(H): KKNonWriteBarrier.st $(INCLUDE_TOP)\stx\libdb\nosql\goods\KKAbstractWriteBarrier.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)KKOptimisticLockPolicy.$(O) KKOptimisticLockPolicy.$(H): KKOptimisticLockPolicy.st $(INCLUDE_TOP)\stx\libdb\nosql\goods\KKConcurrencyPolicy.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)KKPessimisticLockPolicy.$(O) KKPessimisticLockPolicy.$(H): KKPessimisticLockPolicy.st $(INCLUDE_TOP)\stx\libdb\nosql\goods\KKConcurrencyPolicy.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)KKReadWriteIsolationLevel.$(O) KKReadWriteIsolationLevel.$(H): KKReadWriteIsolationLevel.st $(INCLUDE_TOP)\stx\libdb\nosql\goods\KKIsolationLevel.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)KKRecordCache.$(O) KKRecordCache.$(H): KKRecordCache.st $(INCLUDE_TOP)\stx\libdb\nosql\goods\KKCache.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)KKReferenceField.$(O) KKReferenceField.$(H): KKReferenceField.st $(INCLUDE_TOP)\stx\libdb\nosql\goods\KKFieldType.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)KKSingleFieldContainer.$(O) KKSingleFieldContainer.$(H): KKSingleFieldContainer.st $(INCLUDE_TOP)\stx\libdb\nosql\goods\KKFieldContainer.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)KKStringField.$(O) KKStringField.$(H): KKStringField.st $(INCLUDE_TOP)\stx\libdb\nosql\goods\KKFieldType.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)KKStructureContainer.$(O) KKStructureContainer.$(H): KKStructureContainer.st $(INCLUDE_TOP)\stx\libdb\nosql\goods\KKFieldContainer.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)KKThreadSafeDatabase.$(O) KKThreadSafeDatabase.$(H): KKThreadSafeDatabase.st $(INCLUDE_TOP)\stx\libdb\nosql\goods\KKDatabase.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)KKUnboundedCachePolicy.$(O) KKUnboundedCachePolicy.$(H): KKUnboundedCachePolicy.st $(INCLUDE_TOP)\stx\libdb\nosql\goods\KKCachePolicy.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)KKUnsignedIntegerField.$(O) KKUnsignedIntegerField.$(H): KKUnsignedIntegerField.st $(INCLUDE_TOP)\stx\libdb\nosql\goods\KKFieldType.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)KKVariableClassDescriptor.$(O) KKVariableClassDescriptor.$(H): KKVariableClassDescriptor.st $(INCLUDE_TOP)\stx\libdb\nosql\goods\KKClassDescriptor.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)KKVariableFieldContainer.$(O) KKVariableFieldContainer.$(H): KKVariableFieldContainer.st $(INCLUDE_TOP)\stx\libdb\nosql\goods\KKFieldContainer.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)KKWriteWriteIsolationLevel.$(O) KKWriteWriteIsolationLevel.$(H): KKWriteWriteIsolationLevel.st $(INCLUDE_TOP)\stx\libdb\nosql\goods\KKIsolationLevel.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)KKConflictFreeLockPolicy.$(O) KKConflictFreeLockPolicy.$(H): KKConflictFreeLockPolicy.st $(INCLUDE_TOP)\stx\libdb\nosql\goods\KKPessimisticLockPolicy.$(H) $(INCLUDE_TOP)\stx\libdb\nosql\goods\KKConcurrencyPolicy.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)KKSignedIntegerField.$(O) KKSignedIntegerField.$(H): KKSignedIntegerField.st $(INCLUDE_TOP)\stx\libdb\nosql\goods\KKUnsignedIntegerField.$(H) $(INCLUDE_TOP)\stx\libdb\nosql\goods\KKFieldType.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)KKStringArrayField.$(O) KKStringArrayField.$(H): KKStringArrayField.st $(INCLUDE_TOP)\stx\libdb\nosql\goods\KKReferenceField.$(H) $(INCLUDE_TOP)\stx\libdb\nosql\goods\KKFieldType.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)KKStringDescriptor.$(O) KKStringDescriptor.$(H): KKStringDescriptor.st $(INCLUDE_TOP)\stx\libdb\nosql\goods\KKVariableClassDescriptor.$(H) $(INCLUDE_TOP)\stx\libdb\nosql\goods\KKClassDescriptor.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)KKMetaclassDescriptor.$(O) KKMetaclassDescriptor.$(H): KKMetaclassDescriptor.st $(INCLUDE_TOP)\stx\libdb\nosql\goods\KKStringDescriptor.$(H) $(INCLUDE_TOP)\stx\libdb\nosql\goods\KKVariableClassDescriptor.$(H) $(INCLUDE_TOP)\stx\libdb\nosql\goods\KKClassDescriptor.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)KKSymbolDescriptor.$(O) KKSymbolDescriptor.$(H): KKSymbolDescriptor.st $(INCLUDE_TOP)\stx\libdb\nosql\goods\KKStringDescriptor.$(H) $(INCLUDE_TOP)\stx\libdb\nosql\goods\KKVariableClassDescriptor.$(H) $(INCLUDE_TOP)\stx\libdb\nosql\goods\KKClassDescriptor.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)extensions.$(O): extensions.st $(INCLUDE_TOP)\stx\libbasic\Behavior.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\Boolean.$(H) $(INCLUDE_TOP)\stx\libbasic\Character.$(H) $(INCLUDE_TOP)\stx\libbasic\Magnitude.$(H) $(INCLUDE_TOP)\stx\libbasic\Float.$(H) $(INCLUDE_TOP)\stx\libbasic\LimitedPrecisionReal.$(H) $(INCLUDE_TOP)\stx\libbasic\Number.$(H) $(INCLUDE_TOP)\stx\libbasic\ArithmeticValue.$(H) $(INCLUDE_TOP)\stx\libbasic\Metaclass.$(H) $(INCLUDE_TOP)\stx\libbasic\ClassDescription.$(H) $(INCLUDE_TOP)\stx\libbasic\SmallInteger.$(H) $(INCLUDE_TOP)\stx\libbasic\Integer.$(H) $(INCLUDE_TOP)\stx\libbasic\String.$(H) $(INCLUDE_TOP)\stx\libbasic\CharacterArray.$(H) $(INCLUDE_TOP)\stx\libbasic\UninterpretedBytes.$(H) $(INCLUDE_TOP)\stx\libbasic\ArrayedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Timestamp.$(H) $(INCLUDE_TOP)\stx\libbasic\AbstractTime.$(H) $(INCLUDE_TOP)\stx\libbasic2\UUID.$(H) $(INCLUDE_TOP)\stx\libbasic\ByteArray.$(H) $(INCLUDE_TOP)\stx\libbasic\UndefinedObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Class.$(H) $(INCLUDE_TOP)\stx\libview\Color.$(H) $(INCLUDE_TOP)\stx\libbasic\OrderedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\Set.$(H) $(INCLUDE_TOP)\stx\libbasic\Symbol.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line
