"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#SunitXMLOutputTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression'
!

!SunitXMLOutputTest class methodsFor:'documentation'!

documentation
"
    consists of failing (by purpose) tests,
    to see if the backtrace and exception reporting works
    if sUnit results are rendered in xml and then presented by jenkins
"
! !

!SunitXMLOutputTest methodsFor:'testing'!

test01_shouldBeOK_01
    self assert:true.

    "
     self new test01_shouldBeOK_01
    "
!

test02_shouldBeOK_02
    self should:[ self error ] raise:Error

    "
     self new test02_shouldBeOK_02
    "
!

test03_shouldError_01
    self error.

    "
     self new test03_shouldError_01
    "
!

test04_shouldError_02
    self error:'this is an error message'.

    "
     self new test04_shouldError_02
    "
!

test05_shouldError_03
    |d|

    d := 0.
    Transcript showCR:'expect a division by zero error soon...'.
    Transcript showCR:(5 / d).

    "
     self new test05_shouldError_03
    "
!

test06_shouldFail
    self assert:false.

    "
     self new test06_shouldFail
    "
! !

!SunitXMLOutputTest class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

