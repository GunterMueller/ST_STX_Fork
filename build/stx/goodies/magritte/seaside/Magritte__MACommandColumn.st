"{ Package: 'stx:goodies/magritte/seaside' }"

"{ NameSpace: Magritte }"

MAActionColumn subclass:#MACommandColumn
	instanceVariableNames:'commands'
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Seaside-Report'
!


!MACommandColumn methodsFor:'accessing'!

commands
	^ commands
!

commands: aCollection
	commands := aCollection
! !

!MACommandColumn methodsFor:'actions'!

addCommand: aBlock text: aString
	self commands add: aBlock -> aString
!

addCommandOn: anObject selector: aSelector
	self addCommandOn: anObject selector: aSelector text: aSelector allButLast asCapitalizedPhrase
!

addCommandOn: anObject selector: aSelector text: aString
	self addCommand: (MessageSend receiver: anObject selector: aSelector) text: aString
! !

!MACommandColumn methodsFor:'initialization'!

initialize
	super initialize.
	self commands: OrderedCollection new
! !

!MACommandColumn methodsFor:'rendering'!

renderCellFormContent: anObject on: html
	self commands
		do: [ :each |
			html submitButton
				callback: [ each key value: anObject ];
				text: each value ]
		separatedBy: [ html space ]
!

renderCellLinkContent: anObject on: html
	self commands
		do: [ :each |
			html anchor
				callback: [ each key value: anObject ];
				with: each value ]
		separatedBy: [ html space ]
! !

!MACommandColumn class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/seaside/Magritte__MACommandColumn.st,v 1.2 2009-08-14 20:29:47 cg Exp $'
! !
