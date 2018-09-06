"{ Package: 'stx:goodies/monticello' }"

Notification subclass:#MCChangeSelectionRequest
	instanceVariableNames:'patch label'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Versioning'
!


!MCChangeSelectionRequest methodsFor:'as yet unclassified'!

defaultAction
	^ (MCChangeSelector new patch: patch; label: label) showModally
!

label
	^ label
!

label: aString
	label _ aString
!

patch
	^ patch
!

patch: aPatch
	patch _ aPatch
! !

!MCChangeSelectionRequest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCChangeSelectionRequest.st,v 1.2 2012-09-11 21:01:10 cg Exp $'
! !
