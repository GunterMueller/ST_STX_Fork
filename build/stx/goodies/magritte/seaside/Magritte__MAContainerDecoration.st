"{ Package: 'stx:goodies/magritte/seaside' }"

"{ NameSpace: Magritte }"

MAComponentDecoration subclass:#MAContainerDecoration
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Seaside-Decorations'
!


!MAContainerDecoration methodsFor:'accessing'!

buttons
	"Answer a collection of associations. The key is either a symbol that will be performed on the decorated component or a one-argument block that will be executed with the component as argument. The value is the button label."
	
	self subclassResponsibility
!

default
	^ self buttons first key
! !

!MAContainerDecoration methodsFor:'actions'!

execute: anObject
	anObject isSymbol
		ifFalse: [ anObject value: self component ]
		ifTrue: [ self component perform: anObject ]
! !

!MAContainerDecoration methodsFor:'rendering'!

renderButtonsOn: html
	html div class: 'buttons'; with: [
		self buttons do: [ :each |
			html submitButton
				accessKey: each value first;
				callback: [ self execute: each key ];
				text: each value ] ]
!

renderContentOn: html
	html form
		class: 'magritte';
		multipart: self isMultipart;
		defaultAction: [ self execute: self default ];
		with: [ self renderOwnerOn: html; renderButtonsOn: html ]
! !

!MAContainerDecoration methodsFor:'testing'!

isMultipart
	^ self component isMultipart
! !

!MAContainerDecoration class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/seaside/Magritte__MAContainerDecoration.st,v 1.2 2009-08-14 20:28:49 cg Exp $'
! !
