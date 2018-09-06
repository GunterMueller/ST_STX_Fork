"{ Package: 'stx:goodies/monticello' }"

MCMock subclass:#MCMockDependentItem
	instanceVariableNames:'name provides requires'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Mocks'
!


!MCMockDependentItem methodsFor:'as yet unclassified'!

<= other
	^ self name <= other name
!

name

	^ name
!

name: aString

	name := aString
!

provides: anArray

	provides := anArray
!

provisions

	^ provides ifNil: [#()]
!

requirements

	^ requires ifNil: [#()]
!

requires: anArray

	requires := anArray
! !

!MCMockDependentItem methodsFor:'squeak compatibility'!

< other
        ^ self <= other

    "Created: / 25-08-2009 / 12:04:23 / Jaroslav Havlin <havlij6@fel.cvut.cz>"
! !

!MCMockDependentItem class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCMockDependentItem.st,v 1.5 2012-09-11 21:24:25 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCMockDependentItem.st,v 1.5 2012-09-11 21:24:25 cg Exp $'
!

version_SVN
    ^ '§Id: MCMockDependentItem.st 5 2010-08-29 07:30:29Z vranyj1 §'
! !
