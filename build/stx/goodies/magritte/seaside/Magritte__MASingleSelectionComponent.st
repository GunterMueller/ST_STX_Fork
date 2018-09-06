"{ Package: 'stx:goodies/magritte/seaside' }"

"{ NameSpace: Magritte }"

MAOptionComponent subclass:#MASingleSelectionComponent
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Seaside-Components'
!


!MASingleSelectionComponent methodsFor:'accessing'!

options
	^ self description allOptionsWith: self value
! !

!MASingleSelectionComponent methodsFor:'rendering'!

renderViewerOn: html
	html render: (self labelForOption: self value)
! !

!MASingleSelectionComponent class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/seaside/Magritte__MASingleSelectionComponent.st,v 1.2 2009-08-14 20:25:36 cg Exp $'
! !
