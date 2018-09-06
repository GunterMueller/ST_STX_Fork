"{ Package: 'stx:goodies/refactoryBrowser/parser' }"

"{ NameSpace: Smalltalk }"

RBToken subclass:#RBValueToken
	instanceVariableNames:'value'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Scanner'
!


!RBValueToken class methodsFor:'instance creation'!

value: aString start: anInteger 
	^self new value: aString start: anInteger
!

value: aString start: anInteger lineNumber: tokenLineNumber
        ^self new value: aString start: anInteger lineNumber: tokenLineNumber
! !

!RBValueToken methodsFor:'accessing'!

value
	^value
!

value: anObject
        value := anObject
! !

!RBValueToken methodsFor:'initialization & release'!

value: aString start: startInteger 
        "/ self assert:startInteger notNil.

        value := aString.
        sourcePointer := startInteger
!

value: aString start: startInteger lineNumber: tokenLineNumber
        self assert:startInteger notNil.
        self assert:(tokenLineNumber notNil).

        value := aString.
        sourcePointer := startInteger.
        lineNumber := tokenLineNumber.
! !

!RBValueToken methodsFor:'printing'!

printOn: aStream
	super printOn: aStream.
	aStream nextPut: $(.
	value printOn: aStream.
	aStream nextPutAll: ')'
! !

!RBValueToken methodsFor:'private'!

length
	^value size
! !

!RBValueToken class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/parser/RBValueToken.st,v 1.11 2014-12-31 16:44:39 cg Exp $'
! !

