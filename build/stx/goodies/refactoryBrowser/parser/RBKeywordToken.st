"{ Package: 'stx:goodies/refactoryBrowser/parser' }"

RBValueToken subclass:#RBKeywordToken
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Scanner'
!


!RBKeywordToken methodsFor:'testing'!

isKeyword
	^true
!

isMetaVariable
        <resource: #obsolete>
        ^value first == RBScanner metaVariableCharacter
!

isPatternVariable
	^value first == RBScanner patternVariableCharacter
! !

!RBKeywordToken class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/parser/RBKeywordToken.st,v 1.7 2006-02-23 14:55:07 cg Exp $'
! !
