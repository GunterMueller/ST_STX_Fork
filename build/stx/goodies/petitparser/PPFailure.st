"{ Package: 'stx:goodies/petitparser' }"

Object subclass:#PPFailure
	instanceVariableNames:'message context position'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitParser-Core'
!


!PPFailure class methodsFor:'instance creation'!

message: aString
	^ self basicNew initializeMessage: aString 
!

message: aString at: anInteger
	"One should not use this method if the furthest failure is supposed to be reported correctly"
	^ self basicNew initializeMessage: aString at: anInteger
!

message: aString context: aPPContext
	^ self basicNew initializeMessage: aString context: aPPContext
!

message: aString context: aPPContext at: position
	^ self basicNew initializeMessage: aString context: aPPContext position: position
! !

!PPFailure methodsFor:'accessing'!

message
	"Answer a human readable error message of this parse failure."
	
	^ message
!

position
	"Answer the position in the source string that caused this parse failure."

	^ position
! !

!PPFailure methodsFor:'initialization'!

initializeMessage: aString	
	message := aString.
!

initializeMessage: aString at: anInteger
	"One should not use this method if the furthest failure is supposed to be reported correctly"
	message := aString.
	position := anInteger.
!

initializeMessage: aString context: aPPContext
	self initializeMessage: aString context:  aPPContext position: aPPContext position
!

initializeMessage: aString context: aPPContext position: anInteger
	message := aString.
	context := aPPContext.
	position := anInteger.
	
	"record the furthest failure encountered while parsing the input stream "
	aPPContext noteFailure: self.	
! !

!PPFailure methodsFor:'printing'!

printOn: aStream
	aStream nextPutAll: self message; nextPutAll: ' at '; print: self position
! !

!PPFailure methodsFor:'testing'!

isPetitFailure
	"I am the only class that should implement this method to return true."

	^ true
! !

!PPFailure class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPFailure.st,v 1.3 2012-05-04 22:08:15 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPFailure.st,v 1.3 2012-05-04 22:08:15 vrany Exp $'
!

version_SVN
    ^ '§Id: PPFailure.st 2 2010-12-17 18:44:23Z vranyj1 §'
! !

