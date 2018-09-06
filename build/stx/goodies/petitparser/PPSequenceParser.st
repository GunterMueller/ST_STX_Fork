"{ Package: 'stx:goodies/petitparser' }"

"{ NameSpace: Smalltalk }"

PPListParser subclass:#PPSequenceParser
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitParser-Parsers'
!



!PPSequenceParser methodsFor:'*petitcompiler'!

map: aBlock
	^ aBlock numArgs = self children size
		ifTrue: [ self ==> [ :nodes | aBlock valueWithArguments: nodes ] ]
		ifFalse: [ self error: aBlock numArgs asString , ' arguments expected.' ]
! !


!PPSequenceParser methodsFor:'operations'!

, aRule
	^ self copyWith: aRule
!

permutation: anArrayOfIntegers
	"Answer a permutation of the receivers sequence."
	
	anArrayOfIntegers do: [ :index |
		(index isInteger and: [ index between: 1 and: parsers size ])
			ifFalse: [ self error: 'Invalid permutation index: ' , index printString ] ].
	^ self ==> [ :nodes | anArrayOfIntegers collect: [ :index | nodes at: index ] ]
! !

!PPSequenceParser methodsFor:'parsing'!

parseOn: aPPContext
	"This is optimized code that avoids unnecessary block activations, do not change."
	
	| memento elements element |
	memento := aPPContext remember.
	elements := Array new: parsers size.
	1 to: parsers size do: [ :index |
		element := (parsers at: index) 
			parseOn: aPPContext.
		element isPetitFailure ifTrue: [
			aPPContext restore: memento.
			^ element ].
		elements at: index put: element ].
	^ elements
! !

!PPSequenceParser class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPSequenceParser.st,v 1.4 2014-03-04 14:33:25 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPSequenceParser.st,v 1.4 2014-03-04 14:33:25 cg Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id: PPSequenceParser.st,v 1.4 2014-03-04 14:33:25 cg Exp $'
! !

