"{ Package: 'stx:goodies/petitparser/parsers/java' }"

"{ NameSpace: Smalltalk }"

PJCommentsNode subclass:#PJEndOfLineCommentsNode
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitJava-AST'
!

!PJEndOfLineCommentsNode class methodsFor:'as yet unclassified'!

comment: aString
	^(self new) comment: aString; yourself.
! !

!PJEndOfLineCommentsNode methodsFor:'as yet unclassified'!

comment: aString
	aString ifNotNil: [ comment := (aString collect: #asciiValue) asByteArray asString ].
	aString ifNil: [ comment := '' ]
!

printOn: aStream
	^	aStream 
		nextPutAll: 'EndOfLineComment value ==> ';
		nextPutAll: self comment.
 
! !

