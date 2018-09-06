"{ Package: 'stx:goodies/refactoryBrowser/changes' }"

AddClassChange subclass:#InteractiveAddClassChange
	instanceVariableNames:'controller definedClass'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Change Objects'
!


!InteractiveAddClassChange class methodsFor:'instance creation'!

definition: aString for: aController 
	^(self definition: aString)
		controller: aController;
		yourself
! !

!InteractiveAddClassChange methodsFor:'accessing'!

definedClass
	^definedClass
! !

!InteractiveAddClassChange methodsFor:'private'!

controller
	^controller
!

controller: aController 
	controller := aController
!

primitiveExecute
	definedClass := super primitiveExecute
! !

!InteractiveAddClassChange class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/changes/InteractiveAddClassChange.st,v 1.3 2003-09-23 10:44:17 cg Exp $'
! !
