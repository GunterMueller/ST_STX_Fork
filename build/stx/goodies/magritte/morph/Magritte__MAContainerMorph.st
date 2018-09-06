"{ Package: 'stx:goodies/magritte/morph' }"

"{ NameSpace: Magritte }"

MADescriptionMorph subclass:#MAContainerMorph
	instanceVariableNames:'children answer'
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Morph-Model'
!


!MAContainerMorph methodsFor:'accessing'!

children
	^ children
! !

!MAContainerMorph methodsFor:'actions'!

cancel
	self reset; answer: nil
!

save
	[ self validate ]
		on: MAValidationError
		do: [ :err | ^ self inform: err asString ].
	self commit; answer: self model
! !

!MAContainerMorph methodsFor:'answering'!

answer: anObject
	answer ifNotNil: [ answer value: anObject ].
	self morph delete
!

onAnswer: aBlock
	answer := aBlock
! !

!MAContainerMorph methodsFor:'decorating'!

addButtons
	self addButtons: #( save cancel )
!

addButtons: anArray
	morph := self rectangleMorph
		addMorphBack: self morph;
		addMorphBack: (self barMorph: anArray);
		yourself
!

addWindow
	| scrollPane |
	scrollPane := ScrollPane new.
	scrollPane scroller addMorph: self morph.	


	morph := self windowMorph
		model: self;
		vResizing: #shrinkWrap;
		addMorph: (scrollPane layoutInset: 5 @ 5)
			frame: (0 @ 0 corner: 1 @ 1);
		yourself
! !

!MAContainerMorph methodsFor:'initialization'!

setChildren: aCollection
	children := aCollection
!

setDescription: aDescription
	super setDescription: aDescription.
	self setChildren: self buildChildren
! !

!MAContainerMorph methodsFor:'morphic'!

callInHand
	| result |
	result := nil.
	self onAnswer: [ :value | result := value ].
	self openInHand; waitUntilClosed.
	^ result
!

callInWorld
	| result |
	result := nil.
	self onAnswer: [ :value | result := value ].
	self openInWorld; waitUntilClosed.
	^ result
!

openInHand
	^ self morph openInHand
!

openInWorld
	^ self morph openInWorld
!

waitUntilClosed
	[ self morph world notNil ]
		whileTrue: [ self morph outermostWorldMorph doOneCycle ]
! !

!MAContainerMorph methodsFor:'private'!

buildChildren
	^ Array streamContents: [ :stream |
		self description do: [ :each |
			each isVisible ifTrue: [
				stream nextPut: (each morphClass
					memento: self memento
					description: each
					parent: self) ] ] ]
!

buildMorphView
	| result |
	result := self rectangleMorph
		setBalloonText: self description comment;
		listDirection: #topToBottom;
		cellInset: 3;
		yourself.
	self children do: [ :each |
		result addMorphBack: each morph ].
	^ result
! !

!MAContainerMorph class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/morph/Magritte__MAContainerMorph.st,v 1.2 2009-08-14 20:20:41 cg Exp $'
! !
