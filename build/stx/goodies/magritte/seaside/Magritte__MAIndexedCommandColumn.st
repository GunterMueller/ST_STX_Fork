"{ Package: 'stx:goodies/magritte/seaside' }"

"{ NameSpace: Magritte }"

MACommandColumn subclass:#MAIndexedCommandColumn
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Seaside-Report'
!


!MAIndexedCommandColumn methodsFor:'accessing-defaults'!

defaultFormat
	^ MessageSend receiver: self selector: #renderCellContent:on:index:
! !

!MAIndexedCommandColumn methodsFor:'rendering'!

renderCellContent: anObject on: html index: anInteger
	self commands
		do: [ :each |
			html anchor
				callback: [ each key valueWithArguments: (Array
					with: anObject
					with: anInteger) ];
				with: each value ]
		separatedBy: [ html space ]
! !

!MAIndexedCommandColumn class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/seaside/Magritte__MAIndexedCommandColumn.st,v 1.2 2009-08-14 20:29:06 cg Exp $'
! !
