"{ Package: 'stx:goodies/magritte/seaside' }"

"{ NameSpace: Magritte }"

MAColumn subclass:#MAActionColumn
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Seaside-Report'
!


!MAActionColumn methodsFor:'accessing'!

useLinks
	^ self propertyAt: #useLinks ifAbsent: [ self defaultUseLinks ]
!

useLinks: aBoolean
	self propertyAt: #useLinks put: aBoolean
! !

!MAActionColumn methodsFor:'accessing-defaults'!

defaultLabel
	^ String new
!

defaultTitle
	^ String new
!

defaultUseLinks
	^ true
! !

!MAActionColumn methodsFor:'rendering'!

renderCellContent: anObject on: html
	self useLinks
		ifTrue: [ self renderCellLinkContent: anObject on: html ]
		ifFalse: [ self renderCellFormContent: anObject on: html ]
!

renderCellFormContent: anObject on: html
	self subclassResponsibility
!

renderCellLinkContent: anObject  on: html
	self subclassResponsibility
! !

!MAActionColumn class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/seaside/Magritte__MAActionColumn.st,v 1.2 2009-08-14 20:29:20 cg Exp $'
! !
