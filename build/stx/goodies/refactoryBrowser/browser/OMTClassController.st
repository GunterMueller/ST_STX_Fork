"{ Package: 'stx:goodies/refactoryBrowser/browser' }"

ControllerWithMenu subclass:#OMTClassController
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-OMT-Diagram'
!

OMTClassController comment:'OMTClassController is the controller for the OMTClassView. It both passes input down to its subwidgets, and processes input outside of its subwidgets.'
!


!OMTClassController methodsFor:'private'!

controlActivity
	self controlToNextLevel.
	super controlActivity
! !

!OMTClassController class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/browser/OMTClassController.st,v 1.5 2003-09-23 10:45:48 cg Exp $'
! !
