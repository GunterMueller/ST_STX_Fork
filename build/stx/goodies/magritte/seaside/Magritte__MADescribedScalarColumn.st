"{ Package: 'stx:goodies/magritte/seaside' }"

"{ NameSpace: Magritte }"

MADescribedColumn subclass:#MADescribedScalarColumn
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Seaside-Report'
!


!MADescribedScalarColumn methodsFor:'actions'!

valueFor: aRow
	^aRow
! !

!MADescribedScalarColumn methodsFor:'rendering'!

renderCellContent: anObject on: html
	html render: (self description reference toString: (self valueFor: anObject))
! !

!MADescribedScalarColumn class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/seaside/Magritte__MADescribedScalarColumn.st,v 1.2 2009-08-14 20:28:37 cg Exp $'
! !
