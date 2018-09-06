"{ Package: 'stx:goodies/monticello' }"

"{ NameSpace: Smalltalk }"

MCPatchBrowser subclass:#MCChangeSelector
	instanceVariableNames:'kept'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-UI'
!


!MCChangeSelector methodsFor:'as yet unclassified'!

buttonSpecs
	^ #((Select select 'Select these changes')
		 (Cancel cancel 'Cancel the operation')
		)
!

cancel
	self answer: nil
!

defaultLabel
	^ 'Change Selector'
!

innerButtonRow
	^ self buttonRow:
		#(('Select All' selectAll 'select all changes')
		  ('Select None' selectNone 'select no changes'))
!

kept
	^ kept ifNil: [kept _ Set new]
!

listSelectionAt: aNumber
	^ self kept includes: (self items at: aNumber)
!

listSelectionAt: aNumber put: aBoolean
	| item |
	item _ self items at: aNumber.
	aBoolean
		ifTrue: [self kept add: item ]
		ifFalse: [self kept remove: item ifAbsent: []]
!

select
	self answer: (MCPatch operations: kept)
!

selectAll
	kept addAll: self items.
	self changed: #list
!

selectNone
	kept _ Set new.
	self changed: #list
!

widgetSpecs
	Preferences annotationPanes ifFalse: [ ^#(
		((buttonRow) (0 0 1 0) (0 0 0 30))
		((multiListMorph:selection:listSelection:menu: list selection listSelectionAt: methodListMenu:) (0 0 1 0.4) (0 30 0 0))
		((innerButtonRow) (0 0.4 1 0.4) (0 0 0 30))
		((textMorph: text) (0 0.4 1 1) (0 30 0 0))
		)].

	^ #(
		((buttonRow) (0 0 1 0) (0 0 0 30))
		((multiListMorph:selection:listSelection:menu: list selection listSelectionAt: methodListMenu:) (0 0 1 0.4) (0 30 0 0))
		((innerButtonRow) (0 0.4 1 0.4) (0 0 0 30))
		((textMorph: annotations) (0 0.4 1 0.4) (0 30 0 60))
		((textMorph: text) (0 0.4 1 1) (0 60 0 0))
		)
! !

!MCChangeSelector class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCChangeSelector.st,v 1.2 2012-09-11 21:01:15 cg Exp $'
! !

