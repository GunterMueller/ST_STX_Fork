"{ Package: 'stx:libdb/nosql/sandstoneDb' }"

SDAbstractStore subclass:#SDCachedStore
	instanceVariableNames:'cache'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-SandstoneDb-Core'
!


!SDCachedStore methodsFor:'actions'!

abortChanges: anObject 
	| diskVersion |
	anObject critical: 
		[ self 
			removeCachedOfClass: anObject class
			from: anObject id.
		diskVersion := self 
			cachedLoadOfClass: anObject class
			from: anObject id.
		diskVersion 
			ifNil: 
				[ self 
					addCachedOfClass: anObject class
					at: anObject id
					put: anObject ]
			ifNotNil: [ anObject becomeForward: diskVersion ] ]
!

addCachedOfClass: aClass at: anId put: anObject
	(cache at: aClass) at: anId put: anObject
!

ensureForClass: aClass
	cache 
		at: aClass 
		ifAbsentPut: [ SDConcurrentDictionary on: (Dictionary new: self defaultCacheSize) ]
!

forClass: aClass at: anId ifAbsent: aHandler
	aClass withAllSubclasses
		do: [ :class | ((cache at: class) at: anId ifAbsent: [ nil ]) 
			ifNotNilDo: [ :result | ^ result ] ].
	^ aHandler value
!

removeCachedOfClass: aClass from: anId 
	"calling delete multiple times shouldn't cause an error"
	^ (cache at: aClass) removeKey: anId
		ifAbsent: [ nil ]
!

removeObject: anObject
	self removeCachedOfClass: anObject class from: anObject id
!

storeObject: anObject 
	self 
		addCachedOfClass: anObject class
		at: anObject id
		put: anObject.
! !

!SDCachedStore methodsFor:'delegated queries'!

familyForClass: aClass 
	^ aClass allSubclasses 
		inject: (cache at: aClass) 
		into: [ :sum :subclass | sum , (cache at: subclass)  ]
!

forClass: aClass 
	^ (self familyForClass: aClass) 
!

forClass: aClass detect: aBlock ifFound: aHandler
	aClass withAllSubclasses
		do: [ :class | 
			((cache at: class) detect: aBlock ifNone: [ nil ])
				ifNotNilDo: [ :found | 
					aHandler value: found.
					^ found ] ].
	^ nil
!

forClass: aClass detect: aBlock ifNone: aHandler 
	aClass withAllSubclasses
		do: [ :class | 
			((cache at: class) detect: aBlock ifNone: [ nil ])
				ifNotNilDo: [ :found | ^ found ] ].
	^ aHandler value
!

forClass: aClass do: aBlock
	aClass withAllSubclasses do: [ :class | (cache at: class) do: aBlock ]
!

forClass: aClass findAll: aBlock 
	| result |
	result := Dictionary new.
	aClass withAllSubclasses do: [:class | 
		result addAll: ((cache at: class) select: aBlock) ].
	^ result
! !

!SDCachedStore methodsFor:'initialize-release'!

initialize
	super initialize.
	self initializeCache
!

initializeCache
	cache := Dictionary new
! !

!SDCachedStore methodsFor:'queries'!

cachedLoadOfClass: aClass from: anId
	^ (cache at: aClass)
		at: anId
		ifAbsent: [ 
			(self loadClass: aClass atId: anId)
				ifNotNilDo: [ :it | 
					"seems I have to make sure to cache the object before I can resolve 
				it's references so any backreferences to it don't try and load from 
				disk again''"
					(cache at: aClass) at: anId put: it.
					it sandstoneResolveReferences ] ]
! !

!SDCachedStore class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/sandstoneDb/SDCachedStore.st,v 1.3 2013-04-17 23:18:47 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/sandstoneDb/SDCachedStore.st,v 1.3 2013-04-17 23:18:47 cg Exp $'
! !

