"{ Package: 'stx:libcompat' }"

Object subclass:#PseudoClass
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-Squeak'
!


!PseudoClass methodsFor:'*monticello'!

asClassDefinition
	^ MCClassDefinition
		name: self name
		superclassName: self superclass name
		category: self category 
		instVarNames: self instVarNames
		classVarNames: self classVarNames asSortedCollection
		poolDictionaryNames: self poolDictionaryNames
		classInstVarNames: self class instVarNames
		type: self typeOfClass
		comment: self organization classComment	 asString
		commentStamp: self organization commentStamp	
! !

!PseudoClass methodsFor:'*monticello-override'!

isMeta
	^false
! !

!PseudoClass class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/PseudoClass.st,v 1.2 2006-11-22 17:08:20 cg Exp $'
! !
