"{ Package: 'stx:goodies/petitparser' }"

PPParser subclass:#PPFailingParser
	instanceVariableNames:'message'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitParser-Parsers'
!


!PPFailingParser class methodsFor:'instance creation'!

message: aString
	^ self new setMessage: aString
! !


!PPFailingParser methodsFor:'accessing'!

message
	"Answer the error message of the receiving parser."

	^ message
! !

!PPFailingParser methodsFor:'initialization'!

setMessage: aString
	message := aString
! !

!PPFailingParser methodsFor:'pp-context'!

parseOn: aPPContext
	^ PPFailure message: message context: aPPContext
! !

!PPFailingParser methodsFor:'printing'!

printNameOn: aStream
	super printNameOn: aStream.
	aStream nextPutAll: ', '; print: message
! !

!PPFailingParser class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPFailingParser.st,v 1.4 2014-03-04 14:32:28 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPFailingParser.st,v 1.4 2014-03-04 14:32:28 cg Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id: PPFailingParser.st,v 1.4 2014-03-04 14:32:28 cg Exp $'
! !

