"{ Package: 'stx:libdb/nosql/goods' }"

LibraryDefinition subclass:#stx_libdb_nosql_goods
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!

!stx_libdb_nosql_goods class methodsFor:'documentation'!

versions_monticello
    "/ this version has been (im)ported from:
    ^ #(
        'GOODS-cds.137'
        'GOODSPlatformSqueak-cds.6'
        'GOODSTrackingCollections-cds.2'
        'GOODSCollections-cds.1'
    )
! !

!stx_libdb_nosql_goods class methodsFor:'description'!

excludedFromPreRequisites
    "list all packages which should be ignored in the automatic
     preRequisites scan. See #preRequisites for more."

    ^ #(
	#'stx:libdb/nosql/goods/tests'    "KKClassMapper - referenced by Object class>>goodsFieldDescriptors "
    )
!

includedInPreRequisites
    "list all packages which should be added to the automatic
     preRequisites scan. See #preRequisites for more."

    ^ #(
	#'stx:libdb/nosql/goods/stx'
    )
!

mandatoryPreRequisites
    "list all required mandatory packages.
     Packages are mandatory, if they contain superclasses of the package's classes
     or classes which are extended by this package.
     This list can be maintained manually or (better) generated and
     updated by scanning the superclass hierarchies
     (the browser has a menu function for that)
     However, often too much is found, and you may want to explicitely
     exclude individual packages in the #excludedFromPreRequisites method."

    ^ #(
	#'stx:libbasic'    "GenericException - superclass of KKLockFailed "
	#'stx:libbasic2'    "UUID - extended "
	#'stx:libview'    "Color - extended "
    )
!

preRequisites
    "list all required packages.
     This list can be maintained manually or (better) generated and
     updated by scanning the superclass hierarchies and looking for
     global variable accesses. (the browser has a menu function for that)
     Howevery, often too much is found, and you may want to explicitely
     exclude individual packages in the #excludedFromPrerequisites method."

    ^ #(
	#'stx:libbasic'    "Behavior - superclass of extended Metaclass "
	#'stx:libbasic2'    "UUID - extended "
	#'stx:libview'    "Color - extended "
    )
!

referencedPreRequisites
    "list all packages containing classes referenced by the packages's members.
     This list can be maintained manually or (better) generated and
     updated by looking for global variable accesses
     (the browser has a menu function for that)
     However, often too much is found, and you may want to explicitely
     exclude individual packages in the #excludedFromPreRequisites method."

    ^ #(
    )
!

subProjects
    ^ #(
	#'stx:libdb/nosql/goods/stx'
    )
! !

!stx_libdb_nosql_goods class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
	"<className> or (<className> attributes...) in load order"
	KKAbstractWriteBarrier
	KKCache
	KKCachePolicy
	KKClassDescriptor
	KKClassRecord
	KKCommitFailure
	KKConcurrencyPolicy
	KKConnection
	KKDatabase
	KKDirtySet
	KKDocumentation
	KKFieldContainer
	KKFieldRecord
	KKFieldType
	KKGoodsUpdateCounter
	KKIsolationLevel
	KKLockFailed
	KKObjectProxy
	KKObjectRecord
	KKPlatform
	KKTestDocumentation
	KKTransport
	#'stx_libdb_nosql_goods'
	KKAllocationCache
	KKBlobField
	KKBooleanField
	KKClassCache
	KKDoubleField
	KKEmptyWriteBarrier
	KKFixedArrayContainer
	KKFloatField
	KKImmutableGoodsUpdateCounter
	KKKeyCache
	KKLRUCachePolicy
	KKManualWriteBarrier
	KKNonWriteBarrier
	KKOptimisticLockPolicy
	KKPessimisticLockPolicy
	KKReadWriteIsolationLevel
	KKRecordCache
	KKReferenceField
	KKSingleFieldContainer
	KKStringField
	KKStructureContainer
	KKThreadSafeDatabase
	KKUnboundedCachePolicy
	KKUnsignedIntegerField
	KKVariableClassDescriptor
	KKVariableFieldContainer
	KKWriteWriteIsolationLevel
	KKConflictFreeLockPolicy
	KKSignedIntegerField
	KKStringArrayField
	KKStringDescriptor
	KKMetaclassDescriptor
	KKSymbolDescriptor
	KKDictionary
	KKIdentityBTree
	KKIdentitySet
	KKOrderedCollection
	KKSet
	KKClassMapper
    )
!

extensionMethodNames
    "lists the extension methods which are to be included in the project.
     Entries are pairwise elements, consisting of class-name and selector."

    ^ #(
        Behavior goodsIsImmutable
        Boolean goodsIsImmediateValue
        Boolean goodsWriteTaggedOn:
        Character goodsIsImmediateValue
        Float goodsIsImmediateValue
        Float goodsWriteTaggedOn:
        Metaclass visualworksName
        Object goodsChanged
        Object goodsChanged:
        Object goodsChangedAfter:
        Object goodsHasChangeTracking
        Object goodsIsImmediateValue
        Object goodsIsImmutable
        Object goodsUpdate
        Object xxxIsProxy
        Object yourClass
        SmallInteger goodsIsImmediateValue
        SmallInteger goodsWriteTaggedOn:
        String goodsIsImmutable
        Timestamp goodsIsImmutable
        UUID goodsIsImmutable
        UndefinedObject goodsIsImmediateValue
        'Boolean class' goodsDescriptor
        'Class class' goodsDescriptorClass
        'Color class' goodsTransientFields
        'Object class' goodsDescriptor
        'Object class' goodsDescriptorClass
        'Object class' goodsFieldDescriptorNamed:
        'Object class' goodsFieldDescriptors
        'Object class' goodsTransientFields
        'Object class' goodsVariableFieldDescriptor
        'OrderedCollection class' arrayDescriptor
        'Set class' arrayDescriptor
        'Set class' tallyDescriptor
        'SmallInteger class' goodsDescriptor
        'String class' goodsDescriptorClass
        'Symbol class' goodsDescriptorClass
        Character goodsWriteTaggedOn:
        Metaclass goodsDescriptor
    )
! !

!stx_libdb_nosql_goods class methodsFor:'description - project information'!

applicationIconFileName
    "Return the name (without suffix) of an icon-file (the app's icon); will be included in the rc-resource file"

    ^ nil
    "/ ^ self applicationName
!

companyName
    "Return a companyname which will appear in <lib>.rc"

    ^ 'eXept Software AG'
!

description
    "Return a description string which will appear in vc.def / bc.def"

    ^ 'Smalltalk/X Class library'
!

legalCopyright
    "Return a copyright string which will appear in <lib>.rc"

    ^ 'Copyright Claus Gittinger 1988-2012\nCopyright eXept Software AG 1998-2012'
!

productInstallDirBaseName
    "Returns a default installDir which will appear in <app>.nsi.
     This is usually not the one you want to keep"

    ^ (self package asCollectionOfSubstringsSeparatedByAny:':/') last
!

productName
    "Return a product name which will appear in <lib>.rc"

    ^ 'Smalltalk/X'
! !

!stx_libdb_nosql_goods class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/stx_libdb_nosql_goods.st,v 1.16 2013-04-01 20:02:41 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/stx_libdb_nosql_goods.st,v 1.16 2013-04-01 20:02:41 cg Exp $'
! !

