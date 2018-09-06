"{ Package: 'stx:goodies/sunit' }"

TestFailure subclass:#TestSkipped
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SUnit-Preload'
!


!TestSkipped methodsFor:'handling'!

sunitAnnounce: aTestCase toResult: aTestResult
        aTestResult addSkipped: aTestCase.
        self sunitExitWith: false.
! !

!TestSkipped class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/sunit/TestSkipped.st,v 1.1 2013-04-03 13:25:08 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/sunit/TestSkipped.st,v 1.1 2013-04-03 13:25:08 cg Exp $'
! !

