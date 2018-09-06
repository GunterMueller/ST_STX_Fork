"{ Package: 'stx:goodies/magritte' }"

"{ NameSpace: Magritte }"

MAValueHolder subclass:#MADescriptionHolder
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Model-Utility'
!


!MADescriptionHolder class methodsFor:'accessing'!

descriptionClasses
	^ OrderedCollection new
		add: MAStringDescription;
		add: MAMemoDescription;
		add: MASymbolDescription;
		add: MAPasswordDescription;
		add: MABooleanDescription;
		add: MASingleOptionDescription;
		add: MAMultipleOptionDescription;
		add: MAToOneRelationDescription;
		add: MAToManyRelationDescription;
		add: MANumberDescription;
		add: MADurationDescription;
		add: MADateDescription;
		add: MATimeDescription;
		add: MATimeStampDescription;
		add: MAColorDescription;
		add: MATokenDescription;
		add: MAFileDescription;
		add: MAClassDescription;
		add: MATableDescription;
		yourself
! !

!MADescriptionHolder class methodsFor:'api'!

groupOf: aClass
	(self groupText includes: aClass) ifTrue: [^'Text'].
	(self groupChoice includes: aClass) ifTrue: [^'Choice'].
	(self groupMagnitude includes: aClass) ifTrue: [^'Magnitude'].
	(self groupPick includes: aClass) ifTrue: [^'Pick'].
	(self groupMisc includes: aClass) ifTrue: [^'Miscellaneous'].
	^'Other'
! !

!MADescriptionHolder class methodsFor:'groups'!

groupChoice
	^Set new
		add: MABooleanDescription;
		add: MASingleOptionDescription;
		add: MAMultipleOptionDescription;
		add: MAToOneRelationDescription;
		add: MAToManyRelationDescription;
		yourself.
!

groupMagnitude
	^Set new
		add: MANumberDescription;
		add: MADurationDescription;
		add: MADateDescription;
		add: MATimeDescription;
		add: MATimeStampDescription;
		yourself.
!

groupMisc
	^Set new
		add: MAFileDescription;
		add: MAClassDescription;
		add: MATableDescription;
		yourself
!

groupPick
	^Set new
		add: MAColorDescription;
		add: MATokenDescription;
		yourself.
!

groupText
	^Set new
		add: MAStringDescription;
		add: MAMemoDescription;
		add: MASymbolDescription;
		add: MAPasswordDescription;
		yourself.
! !

!MADescriptionHolder class methodsFor:'meta'!

descriptionValue
	^ MASingleOptionDescription new
		options: self descriptionClasses;
		reference: MAClassDescription new;
		groupBy: #grouping;
		selectorAccessor: 'contents';
		label: 'Type';
		priority: 20;
		yourself
! !

!MADescriptionHolder methodsFor:'initialize-release'!

initialize
	super initialize.
	self contents: self class descriptionClasses first
! !

!MADescriptionHolder class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/Magritte__MADescriptionHolder.st,v 1.1 2009-07-29 14:50:41 cg Exp $'
! !
