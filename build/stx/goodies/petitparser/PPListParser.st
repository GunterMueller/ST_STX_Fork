"{ Package: 'stx:goodies/petitparser' }"

PPParser subclass:#PPListParser
	instanceVariableNames:'parsers'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitParser-Parsers'
!


!PPListParser class methodsFor:'instance creation'!

with: aParser
	^ self withAll: (Array with: aParser)
!

with: aFirstParser with: aSecondParser
	^ self withAll: (Array with: aFirstParser with: aSecondParser)
!

withAll: aCollection
	^ self basicNew initialize;
		setParsers: aCollection
! !




!PPListParser methodsFor:'accessing'!

children
	^ parsers
! !

!PPListParser methodsFor:'copying'!

copyWith: aParser
	^ self species withAll: (parsers copyWith: aParser)
!

postCopy
	super postCopy.
	parsers := parsers copy
! !

!PPListParser methodsFor:'initialization'!

initialize
	super initialize.
	self setParsers: #()
!

setParsers: aCollection
	parsers := aCollection asArray
! !

!PPListParser class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPListParser.st,v 1.4 2014-03-04 14:32:58 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPListParser.st,v 1.4 2014-03-04 14:32:58 cg Exp $'
!

version_SVN
    ^ '$Id: PPListParser.st,v 1.4 2014-03-04 14:32:58 cg Exp $'
! !

