"{ Package: 'stx:goodies/refactoryBrowser/parser' }"

RBValueToken subclass:#RBSTXPrimitiveCodeToken
	instanceVariableNames:'stopPosition'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Scanner'
!


!RBSTXPrimitiveCodeToken class methodsFor:'instance creation'!

value: aString start: startInteger stop:stopInteger
        ^self new value: aString start: startInteger stop:stopInteger
!

value: aString start: startInteger stop:stopInteger lineNumber:lineNumberArg
        ^self new value: aString start: startInteger stop:stopInteger lineNumber:lineNumberArg
! !

!RBSTXPrimitiveCodeToken methodsFor:'accessing'!

value: aString start: startInteger stop:stopInteger
    value := aString.
    sourcePointer := startInteger.
    stopPosition := stopInteger
!

value: aString start: startInteger stop:stopInteger lineNumber:lineNumberArg
    value := aString.
    sourcePointer := startInteger.
    stopPosition := stopInteger.
    lineNumber := lineNumberArg.
    "/ self assert:(lineNumber notNil).
! !

!RBSTXPrimitiveCodeToken methodsFor:'testing'!

isSTXPrimitiveCode
    ^ true
! !

!RBSTXPrimitiveCodeToken class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/parser/RBSTXPrimitiveCodeToken.st,v 1.4 2006-02-16 18:31:41 cg Exp $'
! !
