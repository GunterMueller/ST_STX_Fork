"{ Package: 'stx:goodies/monticello' }"

"{ NameSpace: Smalltalk }"

Object subclass:#MCSnapshotOptions
	instanceVariableNames:'includeExtrasForSTX'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Base'
!

!MCSnapshotOptions methodsFor:'accessing'!

includeExtrasForSTX    
    
    "/ do not default to true here, as the version is snapshotted twice in order to
    "/ update the version-strings, and we don not need this stuff in the first round!!
    ^ includeExtrasForSTX ? false

    "Modified: / 07-09-2015 / 15:22:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

includeExtrasForSTX:aBoolean
    includeExtrasForSTX := aBoolean.
! !

