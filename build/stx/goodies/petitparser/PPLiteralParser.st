"{ Package: 'stx:goodies/petitparser' }"

PPParser subclass:#PPLiteralParser
	instanceVariableNames:'literal message'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitParser-Parsers'
!


!PPLiteralParser class methodsFor:'instance creation'!

on: anObject
	^ self on: anObject message: anObject printString , ' expected'
!

on: anObject message: aString
	^ self new initializeOn: anObject message: aString
! !


!PPLiteralParser methodsFor:'accessing'!

literal
	"Answer the parsed literal."

	^ literal
!

message
	"Answer the failure message."
	
	^ message
! !

!PPLiteralParser methodsFor:'initialization'!

initializeOn: anObject message: aString
	literal := anObject.
	message := aString
! !

!PPLiteralParser methodsFor:'operators'!

caseInsensitive
	"Answer a parser that can parse the receiver case-insensitive."
	
	self subclassResponsibility
! !

!PPLiteralParser methodsFor:'printing'!

printNameOn: aStream
	super printNameOn: aStream.
	aStream nextPutAll: ', '; print: literal
! !

!PPLiteralParser class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPLiteralParser.st,v 1.4 2014-03-04 14:33:03 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPLiteralParser.st,v 1.4 2014-03-04 14:33:03 cg Exp $'
!

version_SVN
    ^ '$Id: PPLiteralParser.st,v 1.4 2014-03-04 14:33:03 cg Exp $'
! !

