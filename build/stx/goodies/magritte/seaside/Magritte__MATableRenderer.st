"{ Package: 'stx:goodies/magritte/seaside' }"

"{ NameSpace: Magritte }"

MAComponentRenderer subclass:#MATableRenderer
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Seaside-Renderer'
!


!MATableRenderer methodsFor:'rendering'!

renderContainer: aDescription 
	html table
		class: (self classFor: aDescription);
		with: [super renderContainer: aDescription]
!

renderControl: aDescription
	html tableData
		class: (self classFor: aDescription);
		with: [ super renderControl: aDescription ]
!

renderElement: aDescription
	aDescription group = group
		ifFalse: [ self renderGroup: aDescription ].
	html tableRow: [ 
		self renderLabel: aDescription.
		self renderControl: aDescription ]
!

renderGroup: aDescription
	super renderGroup: aDescription.
	group isNil ifTrue: [ ^ self ].
	html tableRow class: 'group'; with: [ 
		html tableHeading
			colSpan: 2;
			with: group ]
!

renderLabel: aDescription
	html tableHeading
		title: aDescription comment;
		class: (self classFor: aDescription);
		with: [ super renderLabel: aDescription ]
! !

!MATableRenderer class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/seaside/Magritte__MATableRenderer.st,v 1.2 2009-08-14 20:29:31 cg Exp $'
! !
