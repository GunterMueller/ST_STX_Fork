"{ Package: 'stx:goodies/magritte' }"

"{ NameSpace: Magritte }"

Object subclass:#MADescriptionBuilder
	instanceVariableNames:'cache'
	classVariableNames:'Default'
	poolDictionaries:''
	category:'Magritte-Model-Utility'
!


!MADescriptionBuilder class methodsFor:'initialization'!

unload
	self default finalize.
	self default: nil
! !

!MADescriptionBuilder class methodsFor:'instance creation'!

new
	^ self basicNew initialize
! !

!MADescriptionBuilder class methodsFor:'accessing'!

default
	^ Default ifNil: [ Default := MANamedBuilder new ]
!

default: aBuilder
	Default := aBuilder
! !

!MADescriptionBuilder class methodsFor:'building'!

for: anObject
	^ self default for: anObject
! !

!MADescriptionBuilder methodsFor:'accessing'!

for: anObject
	^ cache at: anObject ifAbsentPut: [ self build: anObject ]
! !

!MADescriptionBuilder methodsFor:'actions'!

flush
	cache := IdentityDictionary new
!

register
"/        SystemChangeNotifier uniqueInstance
"/                notify: self ofSystemChangesOfItem: #method change: #Added using: #modified:;
"/                notify: self ofSystemChangesOfItem: #method change: #Modified using: #modified:;
"/                notify: self ofSystemChangesOfItem: #method change: #Removed using: #modified:
!

unregister
	SystemChangeNotifier uniqueInstance
		noMoreNotificationsFor: self
! !

!MADescriptionBuilder methodsFor:'events'!

modified: anEvent
	self flush
! !

!MADescriptionBuilder methodsFor:'initialization'!

finalize
	super finalize.
	self flush; unregister
!

initialize
	self flush; register
! !

!MADescriptionBuilder methodsFor:'private'!

build: anObject
	self subclassResponsibility
! !

!MADescriptionBuilder class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/Magritte__MADescriptionBuilder.st,v 1.2 2009-07-30 08:00:43 cg Exp $'
! !
