"{ Package: 'stx:goodies/magritte' }"

"{ NameSpace: Magritte }"

MAReferenceDescription subclass:#MATableDescription
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Model-Description'
!

MATableDescription comment:'I am a description of tables, their cells and labels. I hold a reference to the description of my cells, that are all described using the same description. Possible values include instances of *MATableModel*.'
!



!MATableDescription class methodsFor:'accessing'!

label
	^ 'Table'
! !

!MATableDescription class methodsFor:'accessing-defaults'!

defaultColumnLabels
	^ OrderedCollection with: 'a' with: 'b' with: 'c'
!

defaultRowLabels
	^ OrderedCollection with: '1' with: '2' with: '3'
! !

!MATableDescription class methodsFor:'accessing-description'!

descriptionColumnLabels
	^ MAMemoDescription new
		accessor: #columnLabelsTextual;
		label: 'Column Labels';
		priority: 250;
		yourself
!

descriptionDefault
	^ nil
!

descriptionRequired
	^ nil
!

descriptionRowLabels
	^ MAMemoDescription new
		accessor: #rowLabelsTextual;
		label: 'Row Labels';
		priority: 250;
		yourself
! !

!MATableDescription class methodsFor:'testing'!

isAbstract
	^ false
! !

!MATableDescription methodsFor:'accessing'!

columnCount
	^ self columnLabels size
!

kind
	^ MATableModel
!

rowCount
	^ self rowLabels size
! !

!MATableDescription methodsFor:'accessing-properties'!

columnLabels
	^ self propertyAt: #columnLabels ifAbsent: [ self class defaultColumnLabels ]
!

columnLabels: aCollection
	self propertyAt: #columnLabels put: aCollection
!

rowLabels
	^ self propertyAt: #rowLabels ifAbsent: [ self class defaultRowLabels ]
!

rowLabels: aCollection
	self propertyAt: #rowLabels put: aCollection
! !

!MATableDescription methodsFor:'accessing-textual'!

columnLabelsTextual
	^ (MAStringDescription new toStringCollection: self columnLabels)
		asMultilineString
!

columnLabelsTextual: aString
	self columnLabels: (MAStringDescription new fromStringCollection: aString lines)
!

rowLabelsTextual
	^ (MAStringDescription new toStringCollection: self rowLabels)
		asMultilineString
!

rowLabelsTextual: aString
	self rowLabels: (MAStringDescription new fromStringCollection: aString lines)
! !

!MATableDescription methodsFor:'validation-private'!

validateSpecific: anObject
	super validateSpecific: anObject.
	(anObject rowCount ~= self rowCount or: [ anObject columnCount ~= self columnCount ])
		ifTrue: [ MAKindError description: self signal: self kindErrorMessage ]
! !

!MATableDescription methodsFor:'visiting'!

acceptMagritte: aVisitor
	aVisitor visitTableDescription: self
! !

!MATableDescription class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/Magritte__MATableDescription.st,v 1.2 2009-08-14 20:05:10 cg Exp $'
! !
