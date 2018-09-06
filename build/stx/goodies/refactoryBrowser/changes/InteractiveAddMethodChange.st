"{ Package: 'stx:goodies/refactoryBrowser/changes' }"

AddMethodChange subclass:#InteractiveAddMethodChange
	instanceVariableNames:'controller definedSelector'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Change Objects'
!


!InteractiveAddMethodChange class methodsFor:'instance creation'!

compile: aString in: aBehavior classified: aProtocol for: aController 
	^(self 
		compile: aString
		in: aBehavior
		classified: aProtocol)
		controller: aController;
		yourself
!

compile: aString in: aClass for: aController 
	^(self compile: aString in: aClass)
		controller: aController;
		yourself
! !

!InteractiveAddMethodChange methodsFor:'accessing'!

definedSelector
	^definedSelector
! !

!InteractiveAddMethodChange methodsFor:'private'!

controller
	^controller
!

controller: aController 
	controller := aController
!

primitiveExecute
	^definedSelector := super primitiveExecute
! !

!InteractiveAddMethodChange class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/changes/InteractiveAddMethodChange.st,v 1.3 2003-09-23 10:47:59 cg Exp $'
! !
