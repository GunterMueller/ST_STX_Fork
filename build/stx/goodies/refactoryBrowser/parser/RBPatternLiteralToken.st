"{ Package: 'stx:goodies/refactoryBrowser/parser' }"

RBLiteralToken subclass:#RBPatternLiteralToken
	instanceVariableNames:'recurse'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Scanner'
!


!RBPatternLiteralToken methodsFor:'accessing'!

recurse
    ^ recurse
!

recurse:something
    recurse := something.
! !

!RBPatternLiteralToken methodsFor:'testing'!

isPatternLiteral
    ^ true
! !

!RBPatternLiteralToken class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/parser/RBPatternLiteralToken.st,v 1.2 2012-08-09 08:43:28 cg Exp $'
! !
