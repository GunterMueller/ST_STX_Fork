"{ Package: 'stx:goodies/monticello' }"

Exception subclass:#MCNoChangesException
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Versioning'
!


!MCNoChangesException methodsFor:'as yet unclassified'!

defaultAction
	self inform: 'No changes'
! !

!MCNoChangesException class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCNoChangesException.st,v 1.2 2012-09-11 21:13:40 cg Exp $'
! !
