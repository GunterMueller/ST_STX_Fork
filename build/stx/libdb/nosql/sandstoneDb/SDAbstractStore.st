"{ Package: 'stx:libdb/nosql/sandstoneDb' }"

Object subclass:#SDAbstractStore
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-SandstoneDb-Core'
!

SDAbstractStore comment:'I''m an abstract store to define what''s necessary to plug in a new method of storing active records.  When records are stored, they are already sliced out of the graph and have markers for any other references placed in them.  The store can serialize however it sees fit, but when loading, before returning the version from the store, it should resolve the references.'''
!


!SDAbstractStore class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!SDAbstractStore class methodsFor:'actions'!

install
	"convience method for quickly installing a new store"

	[ SDActiveRecord
		setStore: self new;
		warmUpAllClasses ] forkAt: Processor userBackgroundPriority named: 'loading new store'
! !

!SDAbstractStore methodsFor:'actions'!

abortChanges: anObject
	self subclassResponsibility
!

commit: aBlock
	self subclassResponsibility
!

ensureDown
!

ensureForClass: aClass 
	"at startUp, the store is sent this message to tell it to make sure it's ready to run, a
	file store for instance may want to make sure it's directories exist"
	self subclassResponsibility
!

loadClass: aClass atId: anId 
	"Given a class and an Id, the store is expected to load a fresh copy of the object 
	from it's persistent medium'"
	self subclassResponsibility
!

recoverForClass: aClass
	"The store is expected to loop through all it's stored instances of a class and
	load them via cachedLoadFrom: on the class which will dispatch back to 
	loadObjectOfClass:atId on the store when a cached version of the object is not found.
	This happens once per class at system startup"
	self subclassResponsibility
!

removeObject: anObject 
	self subclassResponsibility
!

storeObject: anObject 
	self subclassResponsibility
!

updateObject: anObject 
	self subclassResponsibility
! !

!SDAbstractStore methodsFor:'defaults'!

defaultCacheSize
	^ 10000
! !

!SDAbstractStore methodsFor:'delegated queries'!

forClass: aClass 
	self subclassResponsibility
!

forClass: aClass at: anId ifAbsent: aHandler
	self subclassResponsibility
!

forClass: aClass detect: aBlock ifFound: aHandler
	self subclassResponsibility
!

forClass: aClass detect: aBlock ifNone: aHandler
	self subclassResponsibility
!

forClass: aClass do: aBlock
	self subclassResponsibility
!

forClass: aClass findAll: aBlock
	self subclassResponsibility
! !

!SDAbstractStore class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/sandstoneDb/SDAbstractStore.st,v 1.3 2013-04-17 23:18:47 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/sandstoneDb/SDAbstractStore.st,v 1.3 2013-04-17 23:18:47 cg Exp $'
! !

