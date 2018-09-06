"{ Package: 'stx:goodies/magritte/seaside' }"

"{ NameSpace: Magritte }"

MAActionColumn subclass:#MASelectionColumn
	instanceVariableNames:'selection'
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Seaside-Report'
!


!MASelectionColumn methodsFor:'accessing'!

selection
	selection isNil
		ifTrue: [ self selection: self defaultSelection ].
	^ selection
!

selection: anObject
	selection := anObject
! !

!MASelectionColumn methodsFor:'accessing-defaults'!

defaultSelection
	self subclassResponsibility
!

defaultStringDeselected
	self subclassResponsibility
!

defaultStringSelected
	self subclassResponsibility
! !

!MASelectionColumn methodsFor:'accessing-settings'!

stringDeselected
	^ self propertyAt: #stringDeselected ifAbsent: [ self defaultStringDeselected ]
!

stringDeselected: aString
	self propertyAt: #stringDeselected put: aString
!

stringSelected
	^ self propertyAt: #stringSelected ifAbsent: [ self defaultStringSelected ]
!

stringSelected: aString
	self propertyAt: #stringSelected put: aString
! !

!MASelectionColumn methodsFor:'actions'!

deselectRow: anObject
	self subclassResponsibility
!

refresh
	super refresh.
	self selection: self defaultSelection
!

selectRow: anObject
	self subclassResponsibility
!

selectRow: anObject value: aBoolean
	aBoolean
		ifTrue: [ self selectRow: anObject ]
		ifFalse: [ self deselectRow: anObject ]
! !

!MASelectionColumn methodsFor:'private'!

webdings: aString
	^ [ :html | html span style: 'font-family: Webdings'; with: [ html html: aString ] ]
! !

!MASelectionColumn methodsFor:'rendering'!

renderCellLinkContent: anObject on: html
	| selected |
	selected := self isSelected: anObject.
	html anchor
		class: (selected isNil ifFalse: [ 'selected' ]);
		callback: [ self selectRow: anObject value: selected not ];
		with: (selected
			ifTrue: [ self stringSelected ]
			ifFalse: [ self stringDeselected ])
! !

!MASelectionColumn methodsFor:'testing'!

isSelected: anObject
	self subclassResponsibility
! !

!MASelectionColumn class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/seaside/Magritte__MASelectionColumn.st,v 1.2 2009-08-14 20:28:57 cg Exp $'
! !
