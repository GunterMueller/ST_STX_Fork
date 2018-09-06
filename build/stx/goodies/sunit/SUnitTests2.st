"{ Package: 'stx:goodies/sunit' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#SUnitTests2
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SUnit-Smalltalk/X-Tests'
!

TestCase subclass:#TestCaseWithErrorInTearDown
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:SUnitTests2
!

!SUnitTests2 class methodsFor:'documentation'!

documentation
"
    More tests for SUnit. Uses St/X private classes.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!SUnitTests2 methodsFor:'tests'!

testErrorInTearDown

    | result |

    result := TestCaseWithErrorInTearDown buildSuite run.
    self assert: result errors size == 2.

    "Created: / 16-01-2012 / 20:07:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SUnitTests2::TestCaseWithErrorInTearDown class methodsFor:'testing'!

isAbstract

    "HACK: To prevent it being run by normal tools..."

    ^(thisContext sender selector == #buildSuite) not.

    "Created: / 16-01-2012 / 20:41:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SUnitTests2::TestCaseWithErrorInTearDown methodsFor:'running'!

tearDown

    10 perform: ' zork '

    "Created: / 16-01-2012 / 19:55:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SUnitTests2::TestCaseWithErrorInTearDown methodsFor:'tests'!

testFail

    self assert: false

    "Created: / 16-01-2012 / 19:54:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testPass

    self assert: true

    "Created: / 16-01-2012 / 19:54:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SUnitTests2 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/sunit/SUnitTests2.st,v 1.2 2012-08-02 20:56:07 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/sunit/SUnitTests2.st,v 1.2 2012-08-02 20:56:07 vrany Exp $'
! !

