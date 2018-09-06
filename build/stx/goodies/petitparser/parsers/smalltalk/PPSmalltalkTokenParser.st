"{ Package: 'stx:goodies/petitparser/parsers/smalltalk' }"

PPTokenParser subclass:#PPSmalltalkTokenParser
	instanceVariableNames:''
	classVariableNames:'SeparatorPredicate'
	poolDictionaries:''
	category:'PetitSmalltalk-Core'
!

PPSmalltalkTokenParser comment:'A parser that knows how to skip comments and whitespace in Smalltalk and how to instantiate tokens.'
!


!PPSmalltalkTokenParser class methodsFor:'initialization'!

initialize
	SeparatorPredicate := PPCharSetPredicate on: [ :char | char isSeparator ]
! !


!PPSmalltalkTokenParser methodsFor:'parsing'!

parseComments: anArray on: aPPContext
	| start comments |
	comments := anArray.
	[ [ aPPContext atEnd not and: [ SeparatorPredicate value: aPPContext uncheckedPeek ] ]
		whileTrue: [ aPPContext next ].
	 aPPContext atEnd not and: [ aPPContext uncheckedPeek = $" ] ] whileTrue: [
		aPPContext next.
		start := aPPContext position.
		aPPContext upTo: $".
		comments := comments copyWith: (start to: aPPContext position) ].
	^ comments
!

parseOn: aPPContext
	| memento comments token |
	memento := aPPContext remember.
	comments := self
		parseComments: #()
		on: aPPContext.
	token := super parseOn: aPPContext.
	token isPetitFailure ifTrue: [
		aPPContext restore: memento.
		^ token ].
	comments := self
		parseComments: comments
		on: aPPContext.
	^ token comments: comments
! !

!PPSmalltalkTokenParser methodsFor:'private'!

defaultTokenClass
	^ PPSmalltalkToken
! !

!PPSmalltalkTokenParser class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


PPSmalltalkTokenParser initialize!
