"{ Package: 'stx:goodies/petitparser' }"

"{ NameSpace: Smalltalk }"

PPDelegateParser subclass:#PPFlattenParser
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitParser-Parsers'
!


!PPFlattenParser methodsFor:'hooks'!

create: aCollection start: aStartInteger stop: aStopInteger
	^ aCollection copyFrom: aStartInteger to: aStopInteger
! !

!PPFlattenParser methodsFor:'parsing'!

parseOn: aPPContext
	| start element |
	start := aPPContext position.
	element := parser parseOn: aPPContext.
	element isPetitFailure ifTrue: [ ^ element ].
	^ self on: aPPContext stream collection start: start + 1 stop: aPPContext position value: element
! !

!PPFlattenParser methodsFor:'private'!

on: aCollection start: aStartInteger stop: aStopInteger value: anObject
	^ aCollection copyFrom: aStartInteger to: aStopInteger
! !

!PPFlattenParser class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPFlattenParser.st,v 1.4 2014-03-04 14:32:30 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPFlattenParser.st,v 1.4 2014-03-04 14:32:30 cg Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id: PPFlattenParser.st,v 1.4 2014-03-04 14:32:30 cg Exp $'
! !

