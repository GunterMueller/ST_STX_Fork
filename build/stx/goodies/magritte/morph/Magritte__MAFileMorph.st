"{ Package: 'stx:goodies/magritte/morph' }"

"{ NameSpace: Magritte }"

MAElementMorph subclass:#MAFileMorph
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Morph-Model'
!


!MAFileMorph methodsFor:'actions'!

choose
	| stream |
	stream := FileList2 modalFileSelector.
	stream isNil ifTrue: [ ^ self ].
	stream binary.
	self value: (self description kind new
		contents: stream contents;
		filename: stream localName;
		yourself)
! !

!MAFileMorph methodsFor:'private'!

buildMorphEditor
	^ self buttonMorph: #choose
! !

!MAFileMorph class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/morph/Magritte__MAFileMorph.st,v 1.1 2009-07-29 17:56:39 cg Exp $'
! !
