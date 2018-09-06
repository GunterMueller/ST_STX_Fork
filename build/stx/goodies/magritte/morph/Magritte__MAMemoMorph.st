"{ Package: 'stx:goodies/magritte/morph' }"

"{ NameSpace: Magritte }"

MAElementMorph subclass:#MAMemoMorph
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Morph-Model'
!


!MAMemoMorph methodsFor:'accessing'!

annotation
	^ self string
!

enabled
	^ true
!

selected
	^ (self value ifNil: [ self description default ]) ifNil: [ false ]
!

selected: aBoolean
	self value: aBoolean 
! !

!MAMemoMorph methodsFor:'private'!

buildMorphEditor
	"The selector #annotation should be #string instead, but we use this one and dispatch since this prevents morphic to draw a thin red border around changed fields. Stupid hack, really, but doesn't work otherwise."

	^ (PluggableTextMorph on: self text: #annotation accept: #string:)
		height: 400;
		hResizing: #spaceFill;
		borderColor: #inset;
		borderWidth: 1;
		yourself
! !

!MAMemoMorph class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/morph/Magritte__MAMemoMorph.st,v 1.1 2009-07-29 17:56:01 cg Exp $'
! !
