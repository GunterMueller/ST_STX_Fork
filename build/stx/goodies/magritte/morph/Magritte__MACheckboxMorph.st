"{ Package: 'stx:goodies/magritte/morph' }"

"{ NameSpace: Magritte }"

MAElementMorph subclass:#MACheckboxMorph
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Morph-Model'
!


!MACheckboxMorph methodsFor:'actions'!

enabled
	^ true
!

selected
	^ (self value ifNil: [ self description default ]) ifNil: [ false ]
!

selected: aBoolean
	self value: aBoolean 
! !

!MACheckboxMorph methodsFor:'private'!

buildMorphEditor
	^ UITheme current 
		newCheckboxIn: nil
		for: self
		getSelected: #selected
		setSelected: #selected:
		getEnabled: #enabled
		label: self description label 
		help: self description comment
! !

!MACheckboxMorph class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/morph/Magritte__MACheckboxMorph.st,v 1.2 2009-08-14 20:20:12 cg Exp $'
! !
