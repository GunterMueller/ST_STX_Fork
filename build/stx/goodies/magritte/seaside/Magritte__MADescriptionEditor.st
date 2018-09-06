"{ Package: 'stx:goodies/magritte/seaside' }"

"{ NameSpace: Magritte }"

MAExampleEditor subclass:#MADescriptionEditor
	instanceVariableNames:'example selected selectedComponent'
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Seaside-Examples'
!


!MADescriptionEditor class methodsFor:'initialization'!

initialize
	self registerAsApplication: 'magritte/editor'
! !

!MADescriptionEditor methodsFor:'accessing'!

example
	^ example ifNil: [ example := self defaultExampleInstance ]
! !

!MADescriptionEditor methodsFor:'accessing-configuration'!

defaultDescription
	^ MAContainer new
!

defaultDescriptionClasses
	^ OrderedCollection new
		add: MAStringDescription;
		add: MAMemoDescription;
		add: MASymbolDescription;
		add: MAPasswordDescription;
		add: nil;
		add: MABooleanDescription;
		add: MASingleOptionDescription;
		add: MAMultipleOptionDescription;
		add: MAToOneRelationDescription;
		add: MAToManyRelationDescription;
		add: nil;
		add: MANumberDescription;
		add: MADurationDescription;
		add: MADateDescription;
		add: MATimeDescription;
		add: MATimeStampDescription;
		add: nil;
		add: MAColorDescription;
		add: MATokenDescription;
		add: nil;
		add: MAFileDescription;
		add: MAClassDescription;
		add: MATableDescription;
		yourself
!

defaultExampleInstance
	^ MAAdaptiveModel description: self description
! !

!MADescriptionEditor methodsFor:'actions'!

preview
	self call: (self example asComponent
		addMessage: self description label;
		addValidatedForm;
		yourself)
! !

!MADescriptionEditor methodsFor:'actions-items'!

addDescription: aDescription
	| element |
	element := self call: (self
		buildEditorFor: aDescription
		titled: 'Add ' , aDescription class label).
	element isNil ifTrue: [ ^ self ].
	self description add: element.
	self refresh
!

editDescription: aDescription
	self call: (self
		buildEditorFor: aDescription
		titled: 'Edit ' , aDescription class label).
	self refresh
!

removeDescription: aDescription
	self description remove: aDescription.
	self refresh
! !

!MADescriptionEditor methodsFor:'initialize-release'!

initialize
	super initialize.
	selected :=  MADescriptionHolder new.
	selectedComponent := selected asComponent
! !

!MADescriptionEditor methodsFor:'private'!

buildReport
	^ (MAReport rows: self description children description: MAElementDescription description)
		addColumn: (MAColumn new
			cascade: #( description label );
			title: 'Kind';
			yourself);
		addColumn: (MACommandColumn new
			addCommandOn: self selector: #editDescription: text: 'edit';
			addCommandOn: self selector: #moveUp: text: 'up';
			addCommandOn: self selector: #moveDown: text: 'down';
			addCommandOn: self selector: #removeDescription: text: 'remove';
			yourself);
		yourself
! !

!MADescriptionEditor methodsFor:'rendering'!

children
	^super children copyWith: selectedComponent
!

renderButtonsOn: html
	html submitButton
		callback: [
			selectedComponent save.
			selected contents isNil
				ifFalse: [ self addDescription: selected contents new ] ];
		text: 'Add'.
	super renderButtonsOn: html
! !

!MADescriptionEditor class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/seaside/Magritte__MADescriptionEditor.st,v 1.2 2009-08-14 20:29:13 cg Exp $'
! !

MADescriptionEditor initialize!
