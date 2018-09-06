"{ Package: 'stx:goodies/magritte/morph' }"

"{ NameSpace: Magritte }"

Model subclass:#MADescriptionMorph
	instanceVariableNames:'memento description parent morph'
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Morph-Model'
!


!MADescriptionMorph class methodsFor:'instance creation'!

memento: aMemento
	^ self memento: aMemento description: aMemento description
!

memento: aMemento description: aDescription
	^ self memento: aMemento description: aDescription parent: nil
!

memento: aMemento description: aDescription parent: aComponent
	^ self new
		setMemento: aMemento;
		setDescription: aDescription;
		setParent: aComponent;
		yourself
! !

!MADescriptionMorph methodsFor:'accessing'!

description
	^ description
!

memento
	^ memento
!

morph
	^ morph ifNil: [ morph := self buildMorph ]
!

parent
	^ parent
! !

!MADescriptionMorph methodsFor:'accessing-configuration'!

defaultBackgroundColor
	^ self description morphColor
!

defaultSpacerSize
	^ 5
! !

!MADescriptionMorph methodsFor:'accessing-dynamic'!

model
	^ self memento model
!

root
	^ self parent isNil
		ifTrue: [ self ]
		ifFalse: [ self parent root ]
! !

!MADescriptionMorph methodsFor:'actions'!

commit
	self memento commit
!

reset
	self memento reset
!

validate
	"Flushes the cached state of some morphic elements (such as text-morphs) to the memento and then does the validation. I don't know of a better flush the morphic contents (happy flickering), probably morphic is just too limited to customize that easily or I am too dumb to find out."

	self morph allMorphsDo: [ :each |
		(each respondsTo: #accept)
			ifTrue: [ each accept ] ].
	self memento validate
! !

!MADescriptionMorph methodsFor:'initialization'!

setDescription: aDescription
	description := aDescription
!

setMemento: aMemento
	memento := aMemento
!

setParent: aMorph
	parent := aMorph
! !

!MADescriptionMorph methodsFor:'private'!

buildMorph
	^ self description isReadonly
		ifTrue: [ self buildMorphView ]
		ifFalse: [ self buildMorphEditor ]
!

buildMorphEditor
	^ self buildMorphView
!

buildMorphView
	self subclassResponsibility
! !

!MADescriptionMorph methodsFor:'private-morphic'!

buttonState
	^ true
!

perform: selector orSendTo: otherTarget
	^ (self respondsTo: selector)
		ifTrue: [ self perform: selector ]
		ifFalse: [ otherTarget perform: selector ]
! !

!MADescriptionMorph methodsFor:'prototypes'!

barMorph: anArray
	| bar |
	bar := self rectangleMorph
		hResizing: #spaceFill;
		vResizing: #spaceFill;
		listDirection: #leftToRight;
		listCentering: #center;
		wrapCentering: #bottomRight;
		cellInset: self defaultSpacerSize;
		yourself.
	anArray do: [ :selector |
		bar addMorphBack: (self buttonMorph: selector) ].
	^ bar
!

buttonMorph: aSelector
	| button |
	button := PluggableButtonMorph
		on: self
		getState: #buttonState
		action: aSelector.
	button
		label: aSelector;
		hResizing: #spaceFill;
		shortcutCharacter: aSelector first.
	^ button
!

rectangleMorph
	^ RectangleMorph new
		borderWidth: 0;
		color: Color transparent;
		layoutPolicy: TableLayout new;
		cellPositioning: #topLeft;
		vResizing: #shrinkWrap;
		hResizing: #spaceFill;
		yourself
!

stringMorph
	^ StringMorph new
!

windowMorph
	^ SystemWindow labelled: self description label
! !

!MADescriptionMorph class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/morph/Magritte__MADescriptionMorph.st,v 1.1 2009-07-29 17:56:17 cg Exp $'
! !
