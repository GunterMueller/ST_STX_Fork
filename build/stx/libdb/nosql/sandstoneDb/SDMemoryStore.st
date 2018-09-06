"{ Package: 'stx:libdb/nosql/sandstoneDb' }"

SDCachedStore subclass:#SDMemoryStore
	instanceVariableNames:''
	classVariableNames:'Cache Instances'
	poolDictionaries:''
	category:'DataBase-SandstoneDb-Store'
!


!SDMemoryStore class methodsFor:'initialization'!

initialize
	"self initialize"
	Instances := Dictionary new
	
! !

!SDMemoryStore methodsFor:'actions'!

commit: aBlock
	self shouldNotImplement
!

loadClass: aClass atId: anId 
	^ (Instances at: anId) sandstoneResolveReferences
!

recoverForClass: aClass 
	
	"Instances keysDo: [:e | self cachedLoadOfClass: aClass from: e]"

	(Instances associationsSelect: [ :a | a value class == aClass ]) 
		keysDo: [ :e |  self cachedLoadOfClass: aClass from:  e ]
!

removeObject: anObject 
	super removeObject: anObject.
	Instances removeKey: anObject id ifAbsent: []
!

storeObject: anObject 
	super storeObject: anObject.
	Instances 
		at: anObject id
		put: anObject sandstoneDeepCopy sandstoneMarkReferences
!

updateObject: anObject
	self storeObject: anObject
! !

!SDMemoryStore class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/sandstoneDb/SDMemoryStore.st,v 1.4 2013-04-17 23:18:47 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/sandstoneDb/SDMemoryStore.st,v 1.4 2013-04-17 23:18:47 cg Exp $'
! !


SDMemoryStore initialize!
