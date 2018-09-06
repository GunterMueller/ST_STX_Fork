"{ Package: 'stx:goodies/magritte/seaside' }"

"{ NameSpace: Magritte }"

MASingleSelectionComponent subclass:#MASelectListComponent
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Seaside-Components'
!

MASelectListComponent comment:'I display a simple list to allow the user to choose one element from the list. I am one of the two seaside components to render MASingleSelectionDescription.'
!


!MASelectListComponent class methodsFor:'testing'!

isAbstract
	^ false
! !

!MASelectListComponent methodsFor:'accessing-model'!

groups
	"The options objects are assumed to understand the 'groupBy' selector supplied by the description object. Keep the global ordering intact."

	| groups group |
	groups := OrderedCollection new.
	self options do: [ :option | 
		option isNil ifFalse: [
			group := self description groupBy read: option.
			(groups
				detect: [ :each | each key = group ]
				ifNone: [ groups addLast: group -> OrderedCollection new ])
					value addLast: option ] ].
	^ groups
! !

!MASelectListComponent methodsFor:'rendering'!

renderEditorForUngroupedOn: html
	html select
		id: self labelId;
		list: self options;
		selected: self value;
		callback: [ :value | self value: value ];
		labels: [ :value | self labelForOption: value ]
!

renderEditorOn: html
	self description isGrouped
		ifTrue: [ self renderEditorForGroupedOn: html ]
		ifFalse: [ self renderEditorForUngroupedOn: html ]
! !

!MASelectListComponent methodsFor:'rendering-grouped'!

renderEditorForGroupedOn: html 
	html select 
		id: self labelId;
		selected: self value;
		callback: [ :value | self value: value ];
		with: [ self renderGroupsOn: html ]
!

renderGroupsOn: html
	^ self groups do: [ :association |
		html optionGroup
			label: association key;
			with: [ 
				association value
					do: [ :option | self renderOption: option on: html ] ] ]
!

renderOption: option on: html
	^ html option
		selected: self value = option;
		callback: [ self value: option ];
		with: (self labelForOption: option)
! !

!MASelectListComponent methodsFor:'testing'!

hasLabelId
	^ self isReadonly not
! !

!MASelectListComponent class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/seaside/Magritte__MASelectListComponent.st,v 1.2 2009-08-14 20:25:12 cg Exp $'
! !
