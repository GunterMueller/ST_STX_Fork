"{ Package: 'stx:goodies/petitparser/parsers/java' }"

"{ NameSpace: Smalltalk }"

PJSyntaxNode subclass:#PJCommentsNode
	instanceVariableNames:'comment'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitJava-AST'
!

!PJCommentsNode class methodsFor:'as yet unclassified'!

comment: aString
	^(self new) comment: aString; yourself.
! !

!PJCommentsNode methodsFor:'as yet unclassified'!

acceptVisitor: aVisitor
	^ aVisitor visitCommentsNode: self
!

comment
^ comment.
!

comment: aString 
	comment := aString.
!

printOn: aStream
	^	aStream 
		nextPutAll: 'comment value ==> ';
		nextPutAll: self comment.
  
! !

