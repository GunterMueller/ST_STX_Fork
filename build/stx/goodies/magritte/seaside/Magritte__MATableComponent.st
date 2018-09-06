"{ Package: 'stx:goodies/magritte/seaside' }"

"{ NameSpace: Magritte }"

MAElementComponent subclass:#MATableComponent
	instanceVariableNames:'descriptionTable componentTable'
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Seaside-Components'
!


!MATableComponent class methodsFor:'testing'!

isAbstract
	^ false
! !

!MATableComponent methodsFor:'accessing'!

componentTable
	^ componentTable ifNil: [ componentTable := self buildComponentTable ]
!

dataTable
	self value isNil
		ifTrue: [ self value: self buildDataTable ]
		ifFalse: [
			(self value rowCount = self description rowCount
				and: [ self value columnCount = self description columnCount ]) ifFalse: [
					self value: (self value
						copyRows: self description rowCount
						columns: self description columnCount) ] ].
	^ self value
!

descriptionTable
	^ descriptionTable ifNil: [ descriptionTable := self buildDescriptionTable ]
! !

!MATableComponent methodsFor:'accessing-dynamic'!

children
	^ self componentTable contents
! !

!MATableComponent methodsFor:'private'!

buildComponentTable
	^ self descriptionTable collect: [ :row :col :each |
		each componentClass
			memento: self
			description: each
			parent: self ]
!

buildDataTable
	^ MATableModel
		rows: self description rowCount
		columns: self description columnCount
!

buildDescriptionTable
	^ self dataTable collect: [ :row :col :each |
		self description reference copy
			accessor: MANullAccessor new;
			label: row asString , '/' , col asString;
			propertyAt: #row put: row;
			propertyAt: #column put: col;
			yourself ]
!

readUsing: aDescription
	^ self dataTable
		at: (aDescription propertyAt: #row)
		at: (aDescription propertyAt: #column)
!

write: anObject using: aDescription
	^ self dataTable
		at: (aDescription propertyAt: #row)
		at: (aDescription propertyAt: #column)
		put: anObject
! !

!MATableComponent methodsFor:'rendering'!

renderViewerOn: html 
	html table
		id: self labelId;
		with: 
			[ html tableRow: 
				[ html tableHeading: nil.
				self description columnLabels do: [ :each | html tableHeading: each ] ].
			self description rowLabels keysAndValuesDo: 
				[ :rindex :row | 
				html tableRow: 
					[ html tableHeading: row.
					self description columnLabels keysAndValuesDo: 
						[ :cindex :col | 
						html tableData: (self componentTable 
								uncheckedAt: rindex
								at: cindex) ] ] ] ]
! !

!MATableComponent methodsFor:'testing'!

hasLabelId
	^ true
! !

!MATableComponent class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/seaside/Magritte__MATableComponent.st,v 1.2 2009-08-14 20:26:12 cg Exp $'
! !
