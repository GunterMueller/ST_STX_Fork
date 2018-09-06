"{ Package: 'stx:goodies/magritte/morph' }"

"{ NameSpace: Magritte }"

MAMemoMorph subclass:#MATextMorph
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Morph-Model'
!


!MATextMorph methodsFor:'private'!

buildMorphEditor
	^ UITheme current 
		newTextEntryIn: nil 
		for: self  
		get: #selected  
		set: #selected: 
		class: String
		getEnabled: #enabled 
		help: self description comment
! !

!MATextMorph class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/morph/Magritte__MATextMorph.st,v 1.1 2009-07-29 17:56:27 cg Exp $'
! !
