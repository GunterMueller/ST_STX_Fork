"{ Package: 'stx:libcompat' }"

CharacterAttributes subclass:#VariableCharacterAttributes
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-ST80'
!


!VariableCharacterAttributes methodsFor:'accessing'!

tfAsScreenFontStyle

	| fs |
	fs := (self updatedQueryFor: Screen default defaultFontPolicy) tfAsFontStyle.
	doScaling ifTrue: [ fs pixelSize: (fs pixelSize * self scalingFactor) rounded ].
	^ fs
! !

!VariableCharacterAttributes class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libcompat/VariableCharacterAttributes.st,v 1.1 2009-10-02 00:01:34 cg Exp $'
! !
