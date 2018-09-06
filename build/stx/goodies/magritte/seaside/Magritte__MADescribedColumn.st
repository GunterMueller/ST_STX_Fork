"{ Package: 'stx:goodies/magritte/seaside' }"

"{ NameSpace: Magritte }"

MAColumn subclass:#MADescribedColumn
	instanceVariableNames:'description'
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Seaside-Report'
!


!MADescribedColumn methodsFor:'accessing'!

description
	^ description
!

description: aDescription
	description := aDescription.
	accessor := aDescription accessor
! !

!MADescribedColumn methodsFor:'accessing-defaults'!

defaultCascade
	self shouldNotImplement
!

defaultComment
	^ self description comment
!

defaultLabel
	^ self description label
!

defaultSorter
	^ (self description isSortable and: [ self description isRequired ])
		ifTrue: [ super defaultSorter ]
!

defaultTitle
	^ self description label
!

defaultVisible
	^ self description isVisible
! !

!MADescribedColumn methodsFor:'actions'!

stringFor: anObject
	^ self description toString: anObject
!

valueFor: aRow
	^ (super valueFor: aRow) ifNil: [ self description default ]
! !

!MADescribedColumn methodsFor:'exporting'!

exportContent: anObject index: aNumber on: aStream
	super exportContent: (self description toString: anObject) index: aNumber on: aStream
! !

!MADescribedColumn methodsFor:'initialization'!

setDescription: aDescription
	description := aDescription
! !

!MADescribedColumn methodsFor:'rendering'!

renderCellContent: anObject on: html
	html render: (self description toString: (self valueFor: anObject))
! !

!MADescribedColumn class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/seaside/Magritte__MADescribedColumn.st,v 1.2 2009-08-14 20:28:45 cg Exp $'
! !
