"{ Package: 'stx:goodies/magritte/seaside' }"

"{ NameSpace: Magritte }"

MADescribedColumn subclass:#MAToggleColumn
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Seaside-Report'
!


!MAToggleColumn methodsFor:'rendering'!

renderCellContent: anObject on: html
	| value |
	value := self valueFor: anObject.
	html anchor
		callback: [ anObject write: value not using: self description ];
		with: (self description toString: value)
! !

!MAToggleColumn class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/seaside/Magritte__MAToggleColumn.st,v 1.2 2009-08-14 20:29:34 cg Exp $'
! !
