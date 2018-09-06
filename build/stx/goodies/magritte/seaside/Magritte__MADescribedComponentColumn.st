"{ Package: 'stx:goodies/magritte/seaside' }"

"{ NameSpace: Magritte }"

MADescribedColumn subclass:#MADescribedComponentColumn
	instanceVariableNames:'component'
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Seaside-Report'
!

MADescribedComponentColumn comment:'This column uses the component of a description to render the cell value.'
!


!MADescribedComponentColumn methodsFor:'accessing'!

component
	component isNil ifTrue: [
		component := self description componentClass new
			setDescription: self description;
			yourself ].
	^component
! !

!MADescribedComponentColumn methodsFor:'readme'!

NOW
	" very experimental ... use only if you're willing to fix bugs
	  this only works for readonly views without callbacks
	  on the positive side: only one component per column is created "
! !

!MADescribedComponentColumn methodsFor:'rendering'!

renderCellContent: anObject on: html
	self component setMemento: (anObject mementoClass
			model: anObject
			description: self description asContainer).
	self component renderViewerOn: html
! !

!MADescribedComponentColumn class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/seaside/Magritte__MADescribedComponentColumn.st,v 1.2 2009-08-14 20:29:24 cg Exp $'
! !
