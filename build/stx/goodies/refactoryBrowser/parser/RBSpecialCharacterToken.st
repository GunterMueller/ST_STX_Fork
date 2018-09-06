"{ Package: 'stx:goodies/refactoryBrowser/parser' }"

RBValueToken subclass:#RBSpecialCharacterToken
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Scanner'
!


!RBSpecialCharacterToken methodsFor:'private'!

length
	^1
! !

!RBSpecialCharacterToken methodsFor:'testing'!

isSpecial
	^true
! !

!RBSpecialCharacterToken class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/parser/RBSpecialCharacterToken.st,v 1.6 2003-09-23 10:44:51 cg Exp $'
! !
