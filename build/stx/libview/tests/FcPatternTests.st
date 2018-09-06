"
 COPYRIGHT (c) 2016 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libview/tests' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#FcPatternTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Graphics-Support-FontConfig-Tests'
!

!FcPatternTests class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2016 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!FcPatternTests methodsFor:'running'!

setUp
    self skipIf: (Smalltalk at: #FcPattern) isNil description: 'FcPattern class not available'

    "Created: / 17-02-2016 / 14:16:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-03-2016 / 07:52:51 / jv"
! !

!FcPatternTests methodsFor:'tests'!

test_01
    | p |

    p := FcPattern new.
    self assert: (p at: 'x' ifAbsent:[ 1 ]) = 1.
    p at: 'x' put: 10.
    self assert: (p at: 'x') = 10.
    p at: 'x' add: 20.
    self assert: (p at: 'x') = #(10 20).
    p at: 'x' add: 30 append: false.
    self assert: (p at: 'x') = #(30 10 20).
    p release.
    self should: [ p at: 'x' put: 10 ] raise: Object primitiveFailureSignal

    "Created: / 17-02-2016 / 13:58:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_02
    | p1 p2 |

    p1 := FcPattern new.
    p1 at: 'x' put: 10.

    p2 := FcPattern new.
    p2 at: 'x' put: 10.

    self assert: p1 hash == p2 hash.
    self assert: p1 = p2.

    p1 removeKey: 'x'.
    self assert: p1 ~= p2.

    p2 removeKey: 'x'.
    self assert: p1 = p2.

    "Created: / 17-02-2016 / 14:57:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_03
    | p1 p2 |

    p1 := FcPattern new.
    p1 at: 'x' put: 10.

    p2 := p1 copy.
    self assert: (p1 at: 'x') = 10.
    self assert: (p2 at: 'x') = 10.

    p1 removeKey: 'x'.
    self assert: (p2 at: 'x') = 10.

    p1 release.
    self assert: (p2 at: 'x') = 10.

    "Created: / 17-02-2016 / 14:58:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_04
    | p1 |

    p1 := FcPattern new.
    self assert: p1 asString = ''.

    p1 at: 'family' put: 'Helvetica'.
    self assert: p1 asString = 'Helvetica'.

    "Created: / 17-02-2016 / 15:01:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!FcPatternTests class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

