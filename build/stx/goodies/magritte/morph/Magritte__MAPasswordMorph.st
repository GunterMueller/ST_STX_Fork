"{ Package: 'stx:goodies/magritte/morph' }"

"{ NameSpace: Magritte }"

MATextMorph subclass:#MAPasswordMorph
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Morph-Model'
!


!MAPasswordMorph methodsFor:'private'!

buildMorphEditor
	^ super buildMorphEditor
		font: (StrikeFont passwordFontSize: 12);
		yourself
! !

!MAPasswordMorph class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/morph/Magritte__MAPasswordMorph.st,v 1.1 2009-07-29 17:57:21 cg Exp $'
! !
