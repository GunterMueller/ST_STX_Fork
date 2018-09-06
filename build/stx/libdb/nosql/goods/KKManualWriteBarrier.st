"{ Package: 'stx:libdb/nosql/goods' }"

KKAbstractWriteBarrier subclass:#KKManualWriteBarrier
	instanceVariableNames:'dirtyObjects registeredObjects database'
	classVariableNames:'BarrierRegistry'
	poolDictionaries:''
	category:'DataBase-GOODS-WriteBarrier'
!

KKManualWriteBarrier comment:'I am a write barrier that requires that objects explicitly notify me when any of their instance variables (or indexed variables) change.  Notification comes by sending the #goodsChanged or #goodsChanged: message in Object.  I am /very limited/ in my usefulness because of this design.  An OrderedCollection, for example, does not send these change notifications so it could not be referenced (stored or retrieved from database) in a session that is using me as a write barrier.  Some collection classes that support the manual write barrier are available in the TrackingCollections class category.'
!


!KKManualWriteBarrier class methodsFor:'*goodsplatformsqueak'!

initialize
        "self initialize"
        Smalltalk isSmalltalkX ifTrue:[
        ] ifFalse:[
            Smalltalk addToStartUpList: self.
        ].
        self startUp.
!

startUp
        Smalltalk isSmalltalkX ifTrue:[
            BarrierRegistry := Registry new
        ] ifFalse:[
            BarrierRegistry := WeakRegistry new
        ]
! !

!KKManualWriteBarrier class methodsFor:'private-change notification'!

barrierTracking: anObject
	^self barrierRegistry detect: [:each |
		each notNil and: [each isTracking: anObject]] ifNone: []
!

objectChanged: anObject with: anArgument
	| barrier |
	barrier := self barrierTracking: anObject.
	barrier ifNotNil: [barrier modified: anObject]
! !

!KKManualWriteBarrier class methodsFor:'private-registration'!

barrierRegistry
	^BarrierRegistry
!

register: anInstance
        Smalltalk isSmalltalkX ifTrue:[
            self barrierRegistry register: anInstance
        ] ifFalse:[
            self barrierRegistry add: anInstance
        ]
! !

!KKManualWriteBarrier methodsFor:'api'!

add: anObject
	"anObject goodsHasChangeTracking ifFalse: [self error: 'This object does not track changes.']."
	registeredObjects at: anObject put: true
!

clearDirtySet
	dirtyObjects := IdentitySet new
!

database: aDatabase
	database := aDatabase
!

dirtySet
	^dirtyObjects
!

isTracking: anObject
	^registeredObjects includesKey: anObject
!

markClean: anObject
	"remove anObject from our list of dirty objects."

	(dirtyObjects includes: anObject) ifTrue:
		[dirtyObjects remove: anObject]
!

modified: anObject
	(dirtyObjects includes: anObject) ifFalse:
		[dirtyObjects add: anObject.
		self announceChangeOf: anObject]
! !

!KKManualWriteBarrier methodsFor:'initialize-release'!

initialize
	super initialize.
	dirtyObjects := IdentitySet new.
	registeredObjects := KKPlatform default weakIdentityKeyDictionary.
	self register.
!

register
	self class register: self
!

release
	dirtyObjects := nil.
	registeredObjects := nil.
	super release
! !

!KKManualWriteBarrier methodsFor:'private'!

announceChangeOf: anObject
	database ifNotNil: [database objectChanged: anObject]
! !

!KKManualWriteBarrier class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKManualWriteBarrier.st,v 1.5 2013-03-31 12:06:12 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKManualWriteBarrier.st,v 1.5 2013-03-31 12:06:12 cg Exp $'
! !


KKManualWriteBarrier initialize!
