"{ Package: 'stx:goodies/magritte/seaside' }"

"{ NameSpace: Magritte }"

MASelectionColumn subclass:#MACheckboxColumn
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Seaside-Report'
!


!MACheckboxColumn methodsFor:'accessing-defaults'!

defaultSelection
	^ Set new
!

defaultStringDeselected
	^ self webdings: 'c'
!

defaultStringSelected
	^ self webdings: 'g'
! !

!MACheckboxColumn methodsFor:'actions'!

deselectRow: anObject
	self selection remove: anObject ifAbsent: nil
!

selectRow: anObject
	self selection add: anObject
! !

!MACheckboxColumn methodsFor:'rendering'!

renderCellFormContent: anObject on: html
	html checkbox
		value: (self isSelected: anObject);
		callback: [ :value | self selectRow: anObject value: value ]
! !

!MACheckboxColumn methodsFor:'testing'!

isSelected: anObject
	^ self selection includes: anObject
! !

!MACheckboxColumn class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/seaside/Magritte__MACheckboxColumn.st,v 1.2 2009-08-14 20:28:53 cg Exp $'
! !
