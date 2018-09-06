"{ Package: 'stx:goodies/magritte' }"

"{ NameSpace: Magritte }"

Object subclass:#MAProxyObject
	instanceVariableNames:'realSubject'
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Model-Utility'
!

MAProxyObject comment:'I represent an abstract proxy object, to be refined by my subclasses.'
!


!MAProxyObject class methodsFor:'instance creation'!

on: anObject
	^ self basicNew realSubject: anObject
! !

!MAProxyObject methodsFor:'accessing'!

realSubject
	^ realSubject
!

realSubject: anObject
	realSubject := anObject
! !

!MAProxyObject methodsFor:'copying'!

copy
	"It doesn't make sense to copy proxies in most cases, the real-subject needs to be looked up and will probably return a new instance on every call anyway."

	^ self
! !

!MAProxyObject methodsFor:'printing'!

printOn: aStream
	"Print the receiver on ==aStream== but within square-brackets to show that it is a proxied instance."

	aStream nextPut: $[; print: self realSubject; nextPut: $]
!

printString
	^ String streamContents: [ :stream | self printOn: stream ]
! !

!MAProxyObject methodsFor:'private'!

doesNotUnderstand: aMessage
	^ self realSubject
		perform: aMessage selector
		withArguments: aMessage arguments
!

isMorph
	"Answer ==false==, since I am no morph. Squeak is calling this method after image-startup and might lock if I do not answer to this message."

	^ false
! !

!MAProxyObject methodsFor:'testing'!

isNil
	"This method is required to properly return ==true== if the ==realSubject== is ==nil==."

	^ self realSubject isNil
! !

!MAProxyObject class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/Magritte__MAProxyObject.st,v 1.2 2014-09-23 19:15:05 vrany Exp $'
! !

