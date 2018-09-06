"{ Package: 'stx:goodies/magritte/seaside' }"

"{ NameSpace: Magritte }"

MAContainerDecoration subclass:#MAFormDecoration
	instanceVariableNames:'buttons'
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Seaside-Decorations'
!

MAFormDecoration comment:'I surround the owning component with a XHTML form element and render the form buttons.'
!


!MAFormDecoration class methodsFor:'instance creation'!

buttons: aCollection
	^ self new
		addButtons: aCollection;
		yourself
! !

!MAFormDecoration methodsFor:'accessing'!

buttons
	^ buttons
!

buttons: aCollection
	buttons := aCollection
! !

!MAFormDecoration methodsFor:'actions'!

addButton: aSymbol
	self addButton: aSymbol label: (self labelForSelector: aSymbol)
!

addButton: aSymbolOrOneArgumentBlock label: aString
	self buttons add: aSymbolOrOneArgumentBlock -> aString
!

addButtons: aCollection
	aCollection do: [ :each |
		each isVariableBinding
			ifFalse: [ self addButton: each ]
			ifTrue: [ self addButton: each key label: each value ] ]
! !

!MAFormDecoration methodsFor:'initialization'!

initialize
	super initialize.
	self buttons: OrderedCollection new
! !

!MAFormDecoration class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/seaside/Magritte__MAFormDecoration.st,v 1.2 2009-08-14 20:28:32 cg Exp $'
! !
