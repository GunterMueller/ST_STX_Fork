"{ Package: 'stx:libdb/nosql/sandstoneDb' }"

Object subclass:#SDConcurrentDictionary
	instanceVariableNames:'lock dictionary'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-SandstoneDb-Core'
!

SDConcurrentDictionary comment:'A SDConcurrentDictionary is just a dictionary wrapper so I can wrap a critical around mutating methods I need in ActiveRecord'
!


!SDConcurrentDictionary class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
!

on: aDictionary 
	^ self new
		dictionary: aDictionary;
		yourself
! !

!SDConcurrentDictionary methodsFor:'accessing'!

associationsDo: aBlock
	^ lock critical: [ dictionary associationsDo: aBlock ]
!

at: aKey
	^ lock critical: [ dictionary at: aKey ]
!

at: aKey ifAbsent: aBlock 
	^ lock critical: 
		[ dictionary 
			at: aKey
			ifAbsent: aBlock ]
!

at: aKey ifAbsentPut: aBlock 
	^ lock critical: 
		[ dictionary 
			at: aKey
			ifAbsentPut: aBlock ]
!

at: aKey put: aValue 
	^ lock critical: 
		[ dictionary 
			at: aKey
			put: aValue ]
!

detect: aBlock ifNone: aHandler
	^ lock critical: [ dictionary detect: aBlock ifNone: aHandler ]
!

dictionary
	^ dictionary
!

dictionary: anObject
	dictionary := anObject
!

do: aBlock
	^ lock critical: [ dictionary do: aBlock ]
!

keys
	^ lock critical: [ dictionary keys ]
!

keysAndValuesDo: aBlock
	^ lock critical: [ dictionary keysAndValuesDo: aBlock ]
!

keysDo: aBlock
	^ lock critical: [ dictionary keysDo: aBlock ]
!

select: aBlock
	^ lock critical: [ dictionary select: aBlock  ]
!

values
	^ lock critical: [ dictionary values ]
! !

!SDConcurrentDictionary methodsFor:'copying'!

, aCollection 
	^ lock critical: [ self class on: dictionary , aCollection ]
! !

!SDConcurrentDictionary methodsFor:'initialization'!

initialize
	super initialize.
	"I'm using a Monitor rather than a Semaphor here because I need to support 
	reentrant operations by the same process, a Semaphor is too low level"
	lock := Monitor new
! !

!SDConcurrentDictionary methodsFor:'removing'!

removeAll
	^ lock
		critical: [self keys copy
				do: [:e | self removeKey: e]]
!

removeKey: aKey
	^ lock critical: 
		[ dictionary 
			removeKey: aKey ]
!

removeKey: aKey ifAbsent: aBlock 
	^ lock critical: 
		[ dictionary 
			removeKey: aKey
			ifAbsent: aBlock ]
! !

!SDConcurrentDictionary methodsFor:'testing'!

includesKey: aKey
	^ lock critical: [ dictionary includesKey: aKey ]
! !

!SDConcurrentDictionary class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/sandstoneDb/SDConcurrentDictionary.st,v 1.3 2013-04-17 23:18:47 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/sandstoneDb/SDConcurrentDictionary.st,v 1.3 2013-04-17 23:18:47 cg Exp $'
! !

