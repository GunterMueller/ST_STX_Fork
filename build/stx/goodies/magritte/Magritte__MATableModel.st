"{ Package: 'stx:goodies/magritte' }"

"{ NameSpace: Magritte }"

Object subclass:#MATableModel
	instanceVariableNames:'rowCount columnCount contents'
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Model-Models'
!

MATableModel comment:'I am a model class representing a table within the Magritte framework. Internally I store my cells within a flat array, however users may access data giving ''''row'''' and ''''column'''' coordinates with ==#at:at:== and ==#at:at:put:==. I can support reshaping myself, but of course this might lead to loss of data-cells.'
!


!MATableModel class methodsFor:'instance-creation'!

rows: aRowCount columns: aColumnCount
	^ self rows: aRowCount columns: aColumnCount contents: (Array new: aRowCount * aColumnCount)
!

rows: aRowCount columns: aColumnCount contents: anArray
	^ self new
		setRowCount: aRowCount;
		setColumnCount: aColumnCount;
		setContents: anArray;
		yourself
! !

!MATableModel methodsFor:'accessing'!

at: aRowIndex at: aColumnIndex
	"Answer the contents of ==aRowIndex== and ==aColumnIndex==. Raises an error if the coordinates are out of bounds."

	self checkAt: aRowIndex at: aColumnIndex.
	^ self uncheckedAt: aRowIndex at: aColumnIndex
!

at: aRowIndex at: aColumnIndex put: aValue
	"Set the contents of ==aRowIndex== and ==aColumnIndex==> to ==aValue==. Raises an error if the coordinates are out of bounds."

	self checkAt: aRowIndex at: aColumnIndex.
	^ self uncheckedAt: aRowIndex at: aColumnIndex put: aValue
!

columnCount
	"Answer the column count of the table."

	^ columnCount
!

contents
	^ contents
!

rowCount
	"Answer the row count of the table."

	^ rowCount
!

uncheckedAt: aRowIndex at: aColumnIndex
	^ self contents at: (self indexAt: aRowIndex at: aColumnIndex)
!

uncheckedAt: aRowIndex at: aColumnIndex put: aValue
	^ self contents at: (self indexAt: aRowIndex at: aColumnIndex) put: aValue
! !

!MATableModel methodsFor:'comparing'!

= aTable
	^ self species = aTable species
		and: [ self rowCount = aTable rowCount
		and: [ self columnCount = aTable columnCount
		and: [ self contents = aTable contents ] ] ]
!

hash
	^ self contents hash
! !

!MATableModel methodsFor:'copying'!

copyEmpty
	^ self class rows: self rowCount columns: self columnCount
!

copyRows: aRowCount columns: aColumnCount
	| table |
	table := self class rows: aRowCount columns: aColumnCount.
	1 to: (self rowCount min: aRowCount) do: [ :row |
		1 to: (self columnCount min: aColumnCount) do: [ :col |
			table
				uncheckedAt: row at: col
				put: (self uncheckedAt: row at: col) ] ].
	^ table
!

postCopy
	super postCopy.
	self setContents: self contents copy
! !

!MATableModel methodsFor:'enumeration'!

collect: aBlock
	| copy |
	copy := self copyEmpty.
	self do: [ :row :col :val |
		copy
			at: row at: col
			put: (aBlock value: row value: col value: val) ].
	^ copy
!

do: aBlock
	1 to: self rowCount do: [ :row |
		1 to: self columnCount do: [ :col |
			aBlock
				value: row value: col
				value: (self uncheckedAt: row at: col) ] ]
! !

!MATableModel methodsFor:'initialization'!

setColumnCount: anInteger
	columnCount := anInteger
!

setContents: anArray
	contents := anArray
!

setRowCount: anInteger
	rowCount := anInteger
! !

!MATableModel methodsFor:'operations'!

reshapeRows: aRowCount columns: aColumnCount
	"Change the size of the receiving table to ==aRowCount== times ==aColumnCount==, throwing away elements that are cut off and initializing empty cells with ==nil==."

	self setContents: (self copyRows: aRowCount columns: aColumnCount) contents.
	self setRowCount: aRowCount; setColumnCount: aColumnCount
! !

!MATableModel methodsFor:'private'!

checkAt: aRowIndex at: aColumnIndex
	(aRowIndex between: 1 and: self rowCount)
		ifFalse: [ self error: 'Row subscript out of range.' ].
	(aColumnIndex between: 1 and: self columnCount)
		ifFalse: [ self error: 'Column subscript out of range.' ]
!

indexAt: aRowIndex at: aColumnIndex
	^ (aRowIndex - 1) * self columnCount + aColumnIndex
!

pointAt: anIndex
	^ Point x: (anIndex - 1 // self columnCount + 1) y: (anIndex - 1 \\ self columnCount + 1)
! !

!MATableModel class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/Magritte__MATableModel.st,v 1.1 2009-07-29 14:48:30 cg Exp $'
! !
