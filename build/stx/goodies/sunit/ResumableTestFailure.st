"{ Package: 'stx:goodies/sunit' }"

"{ NameSpace: Smalltalk }"

TestFailure subclass:#ResumableTestFailure
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SUnit-Preload'
!

!ResumableTestFailure class methodsFor:'documentation'!

documentation
"
   Sometimes it is useful to see when debugging (and/or to log when running) the results from several assertions in a test.  Example:

	#(‘same’ ‘*’ ‘*.txt’ ‘a*c’) with: #(‘same’ ‘any’ ‘some.txt’ ‘abc’) do:
		[:eachMeta :eachString |
		self assert: (eachMeta match: eachString)
			description: (‘<1s> does not match <2s>’ expandMacrosWith: eachMeta with: eachString)
			resumable: true].

Raising a ResumableTestFailure means that all the assertions will be run (if the test case is logging, this will print out a message to the log for each one that fails).  When debugging, the user can hit ''proceed'' to continue the test and see which other expressions do not match.'


"
! !

!ResumableTestFailure methodsFor:'Camp Smalltalk'!

handleFailureWith:something
    "resumable test failure. Continue with the test suite"

    ^ self resumeWith:something
!

mayProceed

    ^ true
!

sunitExitWith: aValue

	^self resume: aValue
! !

!ResumableTestFailure class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/sunit/ResumableTestFailure.st,v 1.2 2011-06-29 19:15:49 cg Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '�Id: ResumableTestFailure.st 204 2010-09-11 15:21:51Z vranyj1 �'
! !

