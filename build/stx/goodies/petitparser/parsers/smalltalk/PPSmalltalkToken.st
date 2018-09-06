"{ Package: 'stx:goodies/petitparser/parsers/smalltalk' }"

PPToken subclass:#PPSmalltalkToken
	instanceVariableNames:'comments'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitSmalltalk-Core'
!


!PPSmalltalkToken methodsFor:'accessing'!

comments
	^ comments
!

comments: anArray
	comments := anArray
! !

!PPSmalltalkToken methodsFor:'compatiblity'!

length
	^ self size
! !

!PPSmalltalkToken class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

