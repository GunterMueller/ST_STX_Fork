"{ Package: 'stx:goodies/magritte/morph' }"
!

!Magritte::MABooleanDescription class methodsFor:'*magritte-morph-defaults'!

defaultMorphClasses
	^ Array with: MACheckboxMorph with: MASingleSelectListMorph
! !

!Magritte::MAContainer methodsFor:'*magritte-morph-converting'!

asMorphOn: anObject
	^ self morphClass
		memento: (anObject mementoClass
			model: anObject
			description: self)
! !

!Magritte::MAContainer class methodsFor:'*magritte-morph-defaults'!

defaultMorphClasses
	^ Array with: MAContainerMorph
! !

!Magritte::MADescription methodsFor:'*magritte-morph-accessing'!

morphClass
	^ self propertyAt: #morphClass ifAbsent: [ self class defaultMorphClass ]
! !

!Magritte::MADescription methodsFor:'*magritte-morph-accessing'!

morphClass: aClass
	^ self propertyAt: #morphClass put: aClass
! !

!Magritte::MADescription methodsFor:'*magritte-morph-accessing'!

morphColor
	^ self propertyAt: #morphColor ifAbsent: [ self class defaultMorphColor ]
! !

!Magritte::MADescription methodsFor:'*magritte-morph-accessing'!

morphColor: aColor
	^ self propertyAt: #morphColor put: aColor
! !

!Magritte::MADescription class methodsFor:'*magritte-morph-defaults'!

defaultMorphClass
	^ self defaultMorphClasses notEmpty
		ifTrue: [ self defaultMorphClasses first ]
! !

!Magritte::MADescription class methodsFor:'*magritte-morph-defaults'!

defaultMorphClasses
	^ Array new
! !

!Magritte::MADescription class methodsFor:'*magritte-morph-defaults'!

defaultMorphColor
	^ Color white
! !

!Magritte::MADescription class methodsFor:'*magritte-morph-description'!

descriptionMorphClass
	^ MASingleOptionDescription new
		accessor: #morphClass;
		label: 'Morph Class';
		priority: 2000;
		reference: MAClassDescription new;
		options: self defaultMorphClasses;
		default: self defaultMorphClass;
		yourself
! !

!Magritte::MAElementDescription class methodsFor:'*magritte-morph-defaults'!

defaultMorphClasses
	^ Array with: MATextMorph
! !

!Magritte::MAFileDescription class methodsFor:'*magritte-morph-defaults'!

defaultMorphClasses
	^ Array with: MAFileMorph
! !

!Magritte::MAMemoDescription class methodsFor:'*magritte-morph-defaults'!

defaultMorphClasses
	^ Array with: MAMemoMorph
! !

!Magritte::MAMultipleOptionDescription class methodsFor:'*magritte-morph-defaults'!

defaultMorphClasses
	^ Array with: MAMultiSelectListMorph
! !

!Magritte::MAPasswordDescription class methodsFor:'*magritte-morph-default'!

defaultMorphClasses
	^ Array with: MAPasswordMorph
! !

!Magritte::MASingleOptionDescription class methodsFor:'*magritte-morph-defaults'!

defaultMorphClasses
	^ Array with: MASingleSelectListMorph
! !

!Object methodsFor:'*magritte-morph-converting'!

asMorph
	^ self description asMorphOn: self
! !

