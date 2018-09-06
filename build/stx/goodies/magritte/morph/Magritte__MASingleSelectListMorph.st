"{ Package: 'stx:goodies/magritte/morph' }"

"{ NameSpace: Magritte }"

MAListMorph subclass:#MASingleSelectListMorph
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Morph-Model'
!


!MASingleSelectListMorph methodsFor:'accessing'!

selected
	^ self options indexOf: self value
!

selected: anInteger
	self value: (self options at: anInteger ifAbsent: [ nil ]).
	self changed: #selected
! !

!MASingleSelectListMorph methodsFor:'private'!

buildMorphEditor
	^ (PluggableListMorph on: self list: #strings selected: #selected changeSelected: #selected:)
		hResizing: #spaceFill;
		borderColor: #inset;
		borderWidth: 1;
		yourself
! !

!MASingleSelectListMorph class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/morph/Magritte__MASingleSelectListMorph.st,v 1.1 2009-07-29 17:55:17 cg Exp $'
! !
