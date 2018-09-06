"{ Package: 'stx:goodies/petitparser' }"

PPParser subclass:#PPUnresolvedParser
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitParser-Tools'
!


!PPUnresolvedParser methodsFor:'parsing'!

parseOn: aStream
	self error: self printString , ' need to be resolved before execution.'
! !

!PPUnresolvedParser methodsFor:'testing'!

isUnresolved
	^ true
! !

!PPUnresolvedParser class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPUnresolvedParser.st,v 1.3 2012-05-04 22:02:32 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPUnresolvedParser.st,v 1.3 2012-05-04 22:02:32 vrany Exp $'
!

version_SVN
    ^ '§Id: PPUnresolvedParser.st 2 2010-12-17 18:44:23Z vranyj1 §'
! !
