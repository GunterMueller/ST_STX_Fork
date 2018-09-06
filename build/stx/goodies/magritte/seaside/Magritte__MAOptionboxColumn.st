"{ Package: 'stx:goodies/magritte/seaside' }"

"{ NameSpace: Magritte }"

MASelectionColumn subclass:#MAOptionboxColumn
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Seaside-Report'
!


!MAOptionboxColumn methodsFor:'accessing-defaults'!

defaultSelection
	^ nil
!

defaultStringDeselected
	^ self webdings: '&nbsp;'
!

defaultStringSelected
	^ self webdings: 'a'
! !

!MAOptionboxColumn methodsFor:'actions'!

deselectRow: anObject
	self selection: nil
!

selectRow: anObject
	self selection: anObject
! !

!MAOptionboxColumn methodsFor:'private'!

radioGroupFor: html
	"This is a very bad thing, you might never have seen in your own life. Very strange things might happen here, but for now it mostly does what we need."

	| renderer |
	renderer := self propertyAt: #radioGroupRenderer ifAbsentPut: nil.
	renderer == html
		ifTrue: [ ^ self propertyAt: #radioGroupCallback ]
		ifFalse: [
			self propertyAt: #radioGroupRenderer put: html.
			^ self propertyAt: #radioGroupCallback put: html radioGroup ]
! !

!MAOptionboxColumn methodsFor:'rendering'!

renderCellFormContent: anObject on: html
	html radioButton
		group: (self radioGroupFor: html);
		selected: (self isSelected: anObject);
		callback: [ self selectRow: anObject ]
! !

!MAOptionboxColumn methodsFor:'testing'!

isSelected: anObject
	^ self selection == anObject
! !

!MAOptionboxColumn class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/seaside/Magritte__MAOptionboxColumn.st,v 1.3 2009-08-15 17:29:50 sr Exp $'
! !
