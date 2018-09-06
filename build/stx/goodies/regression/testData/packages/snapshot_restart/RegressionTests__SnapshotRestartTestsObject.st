"{ Package: 'stx:goodies/regression/testData/packages/snapshot_restart' }"

"{ NameSpace: RegressionTests }"

Object subclass:#SnapshotRestartTestsObject
	instanceVariableNames:''
	classVariableNames:'RememberedBlock'
	poolDictionaries:''
	category:'tests-Regression'
!


!SnapshotRestartTestsObject class methodsFor:'initialization'!

initialize

    RememberedBlock := [:value | value + 13 ]

    "Created: / 23-07-2012 / 18:13:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SnapshotRestartTestsObject methodsFor:'methods'!

addSimple: increment to: value

    ^value + increment

    "Created: / 23-07-2012 / 18:16:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addThirteenUsingRememberedBlockTo: value

    | b |
    b := RememberedBlock.
    ^b value: value

    "Created: / 23-07-2012 / 18:22:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addUsingBlock: increment to: value

    | b |
    b := [:v| increment + v].
    ^b value: value

    "Created: / 23-07-2012 / 18:17:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SnapshotRestartTestsObject class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !


SnapshotRestartTestsObject initialize!
