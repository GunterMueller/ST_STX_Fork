"{ Package: 'stx:goodies/magritte/seaside' }"

"{ NameSpace: Magritte }"

MAComponentRenderer subclass:#MACssRenderer
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Seaside-Renderer'
!


!MACssRenderer methodsFor:'rendering'!

renderContainer: aDescription 
	html definitionList
		class: (self classFor: aDescription);
		with: [ super renderContainer: aDescription ]
!

renderControl: aDescription
	html definitionData
		class: (self classFor: aDescription);
		with: [ super renderControl: aDescription ]
!

renderGroup: aDescription
	super renderGroup: aDescription.
	group isNil ifTrue: [ ^ self ].
	html definitionTerm
		class: 'group';
		with: group
!

renderLabel: aDescription
	html definitionTerm
		title: aDescription comment;
		class: (self classFor: aDescription);
		with: [ super renderLabel: aDescription ]
! !

!MACssRenderer class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/seaside/Magritte__MACssRenderer.st,v 1.2 2009-08-14 20:29:17 cg Exp $'
! !
