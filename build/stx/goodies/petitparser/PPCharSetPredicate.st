"{ Package: 'stx:goodies/petitparser' }"

"{ NameSpace: Smalltalk }"

Object subclass:#PPCharSetPredicate
	instanceVariableNames:'block classification'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitParser-Tools'
!


!PPCharSetPredicate class methodsFor:'instance creation'!

on: aBlock
	^ self basicNew initializeOn: aBlock
! !

!PPCharSetPredicate methodsFor:'evaluating'!

value: aCharacter
	| index |
	index := aCharacter asInteger.
	index == 0
		ifTrue: [ ^ block value: aCharacter ].
	index > 255
		ifTrue: [ ^ block value: aCharacter ].
	^ classification at: index
! !

!PPCharSetPredicate methodsFor:'initialization'!

initializeOn: aBlock
	block := aBlock.
	classification := Array new: 255.
	1 to: classification size do: [ :index |
		classification at: index put: (block
			value: (Character codePoint: index)) ]
! !

!PPCharSetPredicate class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPCharSetPredicate.st,v 1.3 2012-05-04 22:09:50 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPCharSetPredicate.st,v 1.3 2012-05-04 22:09:50 vrany Exp $'
!

version_SVN
    ^ '§Id: PPCharSetPredicate.st 4 2010-12-18 17:02:23Z kursjan §'
! !

