"{ Package: 'stx:goodies/sunit' }"

"{ NameSpace: Smalltalk }"

Exception subclass:#TestFailure
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SUnit-Preload'
!

!TestFailure class methodsFor:'documentation'!

documentation
"
    'TestFailure is raised when the boolean parameter of an assert: ... or deny: ... call is the opposite of what the assertion claims.


"
! !

!TestFailure methodsFor:'Camp Smalltalk'!

sunitAnnounce: aTestCase toResult: aTestResult
        aTestResult addFailure: aTestCase detail: self.
        self sunitExitWith: false.

    "Modified: / 03-08-2011 / 17:33:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TestFailure methodsFor:'handling'!

handleFailureWith:something
    "non-resumable test failure. Abort the test suite"

    ^ self returnWith:something
! !

!TestFailure class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

