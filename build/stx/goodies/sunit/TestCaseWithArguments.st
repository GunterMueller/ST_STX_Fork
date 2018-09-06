"{ Package: 'stx:goodies/sunit' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#TestCaseWithArguments
	instanceVariableNames:'testArguments'
	classVariableNames:''
	poolDictionaries:''
	category:'SUnit-Base'
!

!TestCaseWithArguments class methodsFor:'documentation'!

documentation
"
    allows for an argument to be passed to the testCase-method.

    To do so, redefine buildAdditionalTestsInSuite:suite,
    to add more tests by sending
        addTest:(self testSelector: testArguments )

    Useful for example, if you want to evaluate a suite's-test method on each file in some directory,
    but still want to see the results as individual runs (to allow for a rerun-defects)

    [author:]
        cg@exept.de
"
! !

!TestCaseWithArguments class methodsFor:'instance creation'!

selector: aSymbol argument: arg
	^self new
	    setTestSelector: aSymbol
	    setTestArguments: (Array with:arg)
!

selector: aSymbol arguments: args
	^self new
	    setTestSelector: aSymbol
	    setTestArguments: args
! !

!TestCaseWithArguments class methodsFor:'building suites'!

buildAdditionalTestsInSuite:suite
    self subclassResponsibility
!

buildSuite
    |suite|

    suite := super buildSuite.
    self buildAdditionalTestsInSuite:suite.
    ^ suite
! !

!TestCaseWithArguments class methodsFor:'queries'!

isAbstract
    "Override to true if a TestCase subclass is Abstract and should not have
     TestCase instances built from it"

    ^ self == TestCaseWithArguments
! !

!TestCaseWithArguments methodsFor:'printing'!

getTestName
    testArguments isEmptyOrNil ifTrue:[^testSelector].
    ^testSelector , '(' , testArguments first printString , ')'.
!

printOn: aStream
	aStream nextPutAll: self name.
	aStream nextPutAll: '>>'.
	testSelector printOn: aStream.
	testSelector numArgs > 0 ifTrue:[
	    aStream nextPutAll: ' ('.
	    testArguments printOn: aStream.
	    aStream nextPutAll: ')'.
	].
! !

!TestCaseWithArguments methodsFor:'private'!

performTest
    self perform:(testSelector asSymbol) withArguments:(testArguments)
!

setTestSelector:aSymbol setTestArguments: args
    testSelector := aSymbol.
    testArguments := args
! !

!TestCaseWithArguments class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

