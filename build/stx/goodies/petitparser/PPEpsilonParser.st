"{ Package: 'stx:goodies/petitparser' }"

PPParser subclass:#PPEpsilonParser
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitParser-Parsers'
!


!PPEpsilonParser methodsFor:'*petitanalyzer-testing'!

isNullable
	^ true
! !

!PPEpsilonParser methodsFor:'parsing'!

parseOn: aStream
	^ nil
! !

!PPEpsilonParser class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPEpsilonParser.st,v 1.4 2014-03-04 14:32:27 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPEpsilonParser.st,v 1.4 2014-03-04 14:32:27 cg Exp $'
!

version_SVN
    ^ '$Id: PPEpsilonParser.st,v 1.4 2014-03-04 14:32:27 cg Exp $'
! !

