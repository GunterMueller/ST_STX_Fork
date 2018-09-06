"{ Package: 'stx:goodies/refactoryBrowser/parser' }"

RBLiteralToken subclass:#RBLiteralByteArrayToken
	instanceVariableNames:'elementTokens'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Scanner'
!


!RBLiteralByteArrayToken methodsFor:'accessing'!

elementTokens
    ^ elementTokens
!

elementTokens:something
    elementTokens := something.
! !

!RBLiteralByteArrayToken class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/parser/RBLiteralByteArrayToken.st,v 1.2 2003-09-23 10:45:05 cg Exp $'
! !
