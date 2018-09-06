"{ Package: 'stx:libdb/nosql/goods' }"

KKCache subclass:#KKClassCache
	instanceVariableNames:'cache keys classes'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-GOODS-Cache'
!

KKClassCache comment:''
!


!KKClassCache methodsFor:'initializing'!

initializeWithDatabase: aDatabase
	super initializeWithDatabase: aDatabase.
	cache := Dictionary new.
	keys := Dictionary new
! !

!KKClassCache methodsFor:'private'!

at: aKey
	^ cache at: aKey ifAbsent: [self loadDescriptorAt: aKey]
!

at: aKey put: aClassDescriptor
        cache at: aKey put: aClassDescriptor.
        keys at: aClassDescriptor put: aKey.
        ^ aClassDescriptor
!

findClassForObject: anObject
        | descr storedDescr association |
        descr := anObject class goodsDescriptor.

        "Here's where we will detect new classes and schema change.  Our keys dictionary has, as its keys, the class descriptions of classes we've encountered.  If none of the class descriptions in this dictionary match descr, then we've never encountered this type of things before (either its shape changed or we've simply not loaded this class from GOODS)."
        association := keys
                associationAt: descr
                ifAbsent: [ nil ].
        storedDescr := association ifNotNil: [ association key ].
        ^ storedDescr ifNil: [ self storeDescriptor: descr ]
!

loadDescriptorAt: aKey
	|descr|
	descr := self connection classAt: aKey.
	descr id: aKey.
	self at: aKey put: descr.
	^ descr
!

storeDescriptor: aClassDescriptor
	| id |
	id := self connection putClass: aClassDescriptor.
	aClassDescriptor id: id.
	self at: id put: aClassDescriptor.
	^ aClassDescriptor
! !

!KKClassCache methodsFor:'public'!

cacheClassesDuring: aBlock
	classes := Dictionary new.
	^ aBlock ensure: [classes := nil]
!

classForObject: anObject
    classes isNil 
            ifTrue: [^ self findClassForObject: anObject. ]
            ifFalse: [ ^ classes at: anObject class ifAbsentPut: [self findClassForObject: anObject] ].
! !

!KKClassCache class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKClassCache.st,v 1.5 2013-03-31 12:02:26 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKClassCache.st,v 1.5 2013-03-31 12:02:26 cg Exp $'
! !

