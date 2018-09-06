"{ Package: 'stx:goodies/petitparser/parsers/java' }"

"{ NameSpace: Smalltalk }"

PPToken subclass:#PPJavaToken
	instanceVariableNames:'comments'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitJava-Core'
!

!PPJavaToken methodsFor:'accessing'!

comments
	^ comments
!

comments: anObject
	comments := anObject
! !

!PPJavaToken methodsFor:'compatibility'!

length 

	^ self size
! !

