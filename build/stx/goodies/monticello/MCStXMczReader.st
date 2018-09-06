"{ Package: 'stx:goodies/monticello' }"

"{ NameSpace: Smalltalk }"

MCMczReader subclass:#MCStXMczReader
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-St/X Storing'
!

!MCStXMczReader methodsFor:'accessing'!

snapshot
    | snapshot |

    snapshot := super snapshot.
    snapshot := MCStXSnapshotPostReadTransformation transform: snapshot.
    ^ snapshot

    "Created: / 10-05-2015 / 05:45:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

