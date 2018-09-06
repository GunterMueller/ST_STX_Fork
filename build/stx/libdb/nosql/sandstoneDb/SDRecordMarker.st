"{ Package: 'stx:libdb/nosql/sandstoneDb' }"

Object subclass:#SDRecordMarker
	instanceVariableNames:'id className'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-SandstoneDb-Core'
!

SDRecordMarker comment:'I exist to mark a reference to another object in the serialized file, I''m replaced by a real object when I''m deserialized.  I''m basically a manually invoked proxy being used because getting a real proxy that inherits from ProtoObject to serialize seemed hurculean.'
!


!SDRecordMarker methodsFor:'accessing'!

className
	^ className
!

className: anObject
	className := anObject
!

id
	^ id
!

id: anObject
	id := anObject
! !

!SDRecordMarker methodsFor:'converting'!

asOriginalObject
	"this needs to call cachedLoadFrom not findById in order to allow cycles in 
	the serialized graph this allows an object that references an unloaded object 
	during the loadAll to force it's load instead of failing"
	| origClass |
	origClass := Smalltalk at: className.
	"I'm checking inheritsFrom: here so that any classes that used to be 
	activeRecords but aren't anymore that had serialized instances are 
	caught and return nil when resolved rather than blow up.  This happens
	often during development when you're changing your model a lot"
	^ (origClass inheritsFrom: SDActiveRecord) 
		ifTrue: [ SDActiveRecord store cachedLoadOfClass: (Smalltalk at: className)  from: id ]
		ifFalse: [ nil ]
! !

!SDRecordMarker methodsFor:'testing'!

isSandstoneMarker
	^ true
! !

!SDRecordMarker class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/sandstoneDb/SDRecordMarker.st,v 1.3 2013-04-17 23:18:47 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/sandstoneDb/SDRecordMarker.st,v 1.3 2013-04-17 23:18:47 cg Exp $'
! !

