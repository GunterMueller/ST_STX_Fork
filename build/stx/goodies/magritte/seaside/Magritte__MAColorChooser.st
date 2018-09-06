"{ Package: 'stx:goodies/magritte/seaside' }"

"{ NameSpace: Magritte }"

MAComponent subclass:#MAColorChooser
	instanceVariableNames:'color'
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Seaside-Core'
!

MAColorChooser comment:'MAColorComponent use me to display a beautiful palette'
!


!MAColorChooser class methodsFor:'instance creation'!

color: aColor
	^ self new
		color: aColor;
		yourself
! !

!MAColorChooser class methodsFor:'testing'!

isAbstract
	^ false
! !

!MAColorChooser methodsFor:'accessing'!

color
	^ color
!

color: aColor
	color := aColor
! !

!MAColorChooser methodsFor:'accessing-dynamic'!

palette
	^ Color oldColorPaletteForDepth: 16 extent: 200 @ 100
! !

!MAColorChooser methodsFor:'actions'!

cancel
	self answer: nil
!

save
	self answer: self color
! !

!MAColorChooser methodsFor:'rendering'!

renderContentOn: html
	html map
		callback: [ :point | self answer: (self palette colorAt: point) ];
		with: [ html image form: self palette ]
! !

!MAColorChooser class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/seaside/Magritte__MAColorChooser.st,v 1.2 2009-08-14 20:27:57 cg Exp $'
! !
