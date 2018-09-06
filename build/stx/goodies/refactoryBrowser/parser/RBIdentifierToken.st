"{ Package: 'stx:goodies/refactoryBrowser/parser' }"

RBValueToken subclass:#RBIdentifierToken
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Scanner'
!


!RBIdentifierToken methodsFor:'testing'!

isIdentifier
	^true
!

isMetaVariable
        <resource: #obsolete>
        ^value first == RBScanner metaVariableCharacter
!

isPatternVariable
	^value first == RBScanner patternVariableCharacter
! !

!RBIdentifierToken class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/parser/RBIdentifierToken.st,v 1.7 2006-02-23 14:54:56 cg Exp $'
! !
