"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TSTreeTests subclass:#TSMultiTreeTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-Collections'
!


!TSMultiTreeTests methodsFor:'as yet unclassified'!

tstreeClass
    ^ TSMultiTree

    "Created: / 26-04-2014 / 11:46:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TSMultiTreeTests methodsFor:'tests'!

test_multiple_01

    | matches |

    tree at: 'Object' put: 1.
    tree at: 'Object' put: 2.

    matches := tree matchesForPrefix: 'Obj'.
    self assert: matches size == 2.
    self assert: (matches includes: 1).
    self assert: (matches includes: 2)

    "Created: / 26-04-2014 / 11:39:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_multiple_02

    | values |

    tree := self tstreeClass new.
    tree at: 'Object' put: 1.
    tree at: 'Object' put: 2.

    values := tree values.
    self assert: values size == 2.
    self assert: (values includes: 1).
    self assert: (values includes: 2)

    "Created: / 26-04-2014 / 11:41:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_multiple_03a

    | values |

    tree := self tstreeClass new.
    tree at: 'Object' put: 1.
    tree at: 'Object' put: 1.

    values := tree values.
    self assert: values size == 1.
    self assert: (values includes: 1).

    "Created: / 26-04-2014 / 12:09:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_multiple_03b

    | values |

    tree := self tstreeClass new.
    tree at: 'Object' put: 1.
    tree at: 'Object' put: 2.
    tree at: 'Object' put: 1.

    values := tree values.
    self assert: values size == 2.
    self assert: (values includes: 1).
    self assert: (values includes: 2).

    "Created: / 26-04-2014 / 12:09:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TSMultiTreeTests class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

