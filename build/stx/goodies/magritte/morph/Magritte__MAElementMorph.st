"{ Package: 'stx:goodies/magritte/morph' }"

"{ NameSpace: Magritte }"

MADescriptionMorph subclass:#MAElementMorph
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Morph-Model'
!


!MAElementMorph methodsFor:'accessing'!

string
	^ self description toString: self value
!

string: aString
	| value |
	value := [ self description fromString: aString asString ]
		ifError: [ aString ].
	self value: value; changed: #string
!

value
	^ self memento readUsing: self description
!

value: anObject
	self memento write: anObject using: self description.
	self changed: #value
! !

!MAElementMorph methodsFor:'private'!

buildMorph
	| result |
	result := self rectangleMorph
		layoutInset: 1 @ 1;
		listDirection: #leftToRight;
		addMorphBack: self buildMorphLabel;
		addMorphBack: super buildMorph;
		yourself.
	self description hasComment
		ifTrue: [ result setBalloonText: self description comment ].
	self description isRequired
		ifTrue: [ result addMorphBack: self buildMorphRequired ].
	^ result
!

buildMorphLabel
	^ self stringMorph
		contents: self description label , ':';
		width: 100;
		yourself
!

buildMorphRequired
	^ self stringMorph
		contents: ' *';
		color: Color red;
		yourself
!

buildMorphView
	^ self stringMorph
		contents: self string;
		yourself
! !

!MAElementMorph class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/morph/Magritte__MAElementMorph.st,v 1.1 2009-07-29 17:56:08 cg Exp $'
! !
