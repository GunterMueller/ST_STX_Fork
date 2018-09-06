"{ Package: 'stx:libdb/nosql/sandstoneDb' }"

Object subclass:#SDActiveRecord
	instanceVariableNames:'id createdOn updatedOn version isNew'
	classVariableNames:'Store'
	poolDictionaries:''
	category:'DataBase-SandstoneDb-Core'
!

SDActiveRecord class instanceVariableNames:'lock'

"
 No other class instance variables are inherited by this class.
"
!

SDActiveRecord comment:''
!


!SDActiveRecord class methodsFor:'initialization'!

initialize
	"self initialize"
	
	Store := self defaultStore.
!

setStore: aStore 
	Store ifNotNil: [ Store ensureDown ].
	Store := aStore
! !

!SDActiveRecord class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!SDActiveRecord class methodsFor:'accessing'!

store
	^ Store
! !

!SDActiveRecord class methodsFor:'actions'!

commit: aBlock 
	^ Store commit: aBlock
!

coolDown
	lock := nil.
	self ensureReady
!

resetStoreForLoad
	self setStore: self store class new
!

warmUp
	
	Store ensureForClass: self.
	self ensureReady.
	Store recoverForClass: self
!

warmUpAllClasses
	
	SDActiveRecord
		allSubclassesDo: [ :each | self store ensureForClass: each ];
		allSubclassesDo: [ :each | each warmUp ]
! !

!SDActiveRecord class methodsFor:'actions private'!

ensureReady
	lock := Monitor new
! !

!SDActiveRecord class methodsFor:'defaults'!

defaultHashSize
	^ 100
!

defaultIdentityDictionary 
	^ IdentityDictionary new: self defaultHashSize 
!

defaultStore
	^ SDFileStore new
! !

!SDActiveRecord class methodsFor:'queries'!

atId: anId 
	"hitting this in a tight loop for a class with subclasses can be very expensive
	because allCaches has to concatenate all the subclasses caches into a new copy
	that contains all subclass records"
	^ self 
		atId: anId
		ifAbsent: [ nil ]
!

atId: anId ifAbsent: aHandler 
	"hitting this in a tight loop for a class with subclasses can be very expensive
	because allCaches has to concatenate all the subclasses caches into a new copy
	that contains all subclass records"
	^  Store forClass: self at: anId ifAbsent: aHandler
!

find: aBlock 
	^ self 
		find: aBlock
		ifAbsent: [ nil ]
!

find: aBlock ifAbsent: aHandler 
	^ Store forClass: self detect: aBlock ifNone: aHandler
!

find: aBlock ifPresent: aHandler 
	^ Store forClass: self detect: aBlock ifFound: aHandler
!

findAll
	^ (Store forClass: self) values
!

findAll: aBlock 
	^ ( Store forClass: self findAll: aBlock ) values
! !

!SDActiveRecord class methodsFor:'queries private'!

lock
	^ lock ifNil: [ lock := Monitor new ]
! !

!SDActiveRecord class methodsFor:'queries smalltalk style'!

detect: aBlock
	^ self find: aBlock 
!

detect: aBlock ifNone: alternateBlock
	^ self find: aBlock ifAbsent: alternateBlock 
!

do: aBlock
	"do on a copy in case the do modifies the collection I'm trying to iterate'"
	Store forClass: self do: aBlock
!

select: aBlock
	^ self findAll: aBlock 
!

values 
	^ self findAll 
! !

!SDActiveRecord methodsFor:'accessing'!

createdOn
	^ createdOn
!

id
	^ id
!

updatedOn
	^ updatedOn
!

version
	^ version
! !

!SDActiveRecord methodsFor:'actions'!

abortChanges
	"Rollback object to the last saved version"
	Store abortChanges: self.
!

critical: aBlock
	^ self class lock critical: aBlock
!

delete
	"I'm using monitors for locking so this can be wrapped in larger critical
	in your application code if you want more scope on the critical'"
	self critical: 
		[ self onBeforeDelete.
		Store removeObject: self.
		self onAfterDelete.
		self initialize ]
!

save
	"I'm using monitors for locking so this can be wrapped in larger critical
	in your application code if you want more scope on the critical'"
	| isFirstSave |
	^ self critical: 
		[ self validate.
		(isFirstSave := isNew) ifTrue: [ self onBeforeFirstSave ].
		self onBeforeSave.
		isFirstSave 
			ifTrue: [Store storeObject: self] 
			ifFalse: [Store updateObject: self].
		isFirstSave ifTrue: [ self onAfterFirstSave ].
		self onAfterSave.
		self ]
!

save: aBlock 
	^ self critical: 
		[ aBlock value.
		self save ]
!

validate
	"for subclasses to override and throw exceptions to prevent saves"
! !

!SDActiveRecord methodsFor:'comparing'!

= anObject 
	"asking the object isMemberOf ensures that if it's a proxy that message 
	will be forwarded to the real object.  Checking this condition in reverse
	anObject class, will fail because anObject class will be the ProxyClass"

	^ (anObject isMemberOf: self class) and: [ id = anObject id ]
! !

!SDActiveRecord methodsFor:'converting'!

asReferenceMarker
	isNew
		ifTrue: [ 
			"You may reach this point several times before you get the intended use of this framework. This is 
		expected **by design** to make atomic saves really small and consistent. Commits of active records
		which have other active records as parts (at any depth) are restricted intentionally. They are only 
		allowed when all its sub active records are previously commited.  
		
		Only the programmer knows the proper logical commit order for his data!! This is not a relational database
		or an object database, its a filesystem database meant only to make an image crash proof and files
		aren't transactional, if you absolutely need several objects to be atomically saved, then you should make 
		them all part of a single aggregate cluster, all of your objects should not be active records, only your aggregate 
		roots are active records.  
		
		For example, an Order would be an ActiveRecord while its LineItem's would simply inherit from Object.  The
		Order and all its line items would be atomically saved as a single file by Order id.  You could not query for
		a line item directly to update it, you would query for the order, its aggregate root, do your work, and 
		commit the order.  An aggregate root is the natural query and transactional boundry for the domain.
		See Eric Evans Domain Driven Design for more information about this way of thinking.
		
		Do not try to rig your objects up to cascade save, to do so is to be missing the point of this 
		framework: Simplicity. This is not an OODB where you call commit once and you hope everything
		magically saves correctly.  One record should not be saving another.  Saves are something best done
		in your controller methods explicitly.  Save your new objects first, then make one reference the other, then
		save the modified one again. This pattern is simple and it works without magic that will confuse you and it 
		will force you to confront failure scenarios where one record saves successfully but the other doesn't.  Trying 
		to hide this behind cascading saves only hides from the programmer the fact that each save is atomic but multiple 
		saves are not."
			SDCommitError
				signal:
					'An object is being saved while referencing an unsaved record of type ' , self class name
						, '.  You must save that record first!!' ].
	^ (SDRecordMarker new)
		id: id;
		className: self class name;
		yourself
! !

!SDActiveRecord methodsFor:'copying'!

postCopy
	super postCopy.
	id := UUID new asString36.
	createdOn := updatedOn := DateAndTime now.
	version := 0.
	isNew := true
! !

!SDActiveRecord methodsFor:'events'!

onAfterDelete
	"for overriding in subclasses to hook the objects lifecycle"
	
!

onAfterFirstSave
	"for overriding in subclasses to hook the objects lifecycle"
	
!

onAfterSave
	"for overriding in subclasses to hook the objects lifecycle"
	
!

onBeforeDelete
	"for overriding in subclasses to hook the objects lifecycle"
	
!

onBeforeFirstSave
	"for overriding in subclasses to hook the objects lifecycle"
	createdOn := DateAndTime now
!

onBeforeSave
	"for overriding in subclasses to hook the objects lifecycle"
	updatedOn := DateAndTime now.
	version := version + 1.
	isNew := false
!

onLoad
	"for overriding in subclasses to hook the objects lifecycle"
	
! !

!SDActiveRecord methodsFor:'initialize-release'!

initialize
        super initialize.
        id ifNil: [ id := UUID new printString "asString36" ].
        createdOn := updatedOn := DateAndTime now.
        version := 0.
        isNew := true
! !

!SDActiveRecord methodsFor:'serialization'!

sandstoneDeepCopy
	"Replaces the receiver (sub) active records 
	with Sandstone references where it is needed"
	^ self sandstoneDeepCopyVisits: self class defaultIdentityDictionary
!

sandstoneMarkReferences
	"Replaces the receiver (sub) active records 
	with Sandstone references where it is needed"
	^ self sandstoneMarkReferencesVisits: self class defaultIdentityDictionary
!

sandstoneResolveReferences
	"Replaces the receiver markers with
	active records where it is needed"
	^ self sandstoneResolveReferencesVisits: self class defaultIdentityDictionary
! !

!SDActiveRecord methodsFor:'testing'!

hash
	^ id hash
!

isNew
	"Only answers true before an objects first save."
	^ isNew ifNil: [ isNew := true ]
!

isSandstoneActiveRecord
	"Answers true if the receiver is a Sandstone Active Record."
	^ true
! !

!SDActiveRecord class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/sandstoneDb/SDActiveRecord.st,v 1.4 2013-04-17 23:18:47 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/sandstoneDb/SDActiveRecord.st,v 1.4 2013-04-17 23:18:47 cg Exp $'
! !


SDActiveRecord initialize!
