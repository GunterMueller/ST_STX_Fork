"
 COPYRIGHT (c) 2017 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool/tests' }"

"{ NameSpace: Tools }"

TestCase subclass:#NewSystemBrowserTests
	instanceVariableNames:'browser browserInteractor'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Browsers-New-Tests'
!

!NewSystemBrowserTests class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2017 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!NewSystemBrowserTests methodsFor:'mocks'!

foo
    ^ 1

    "Created: / 07-08-2017 / 16:07:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!NewSystemBrowserTests methodsFor:'running'!

setUp
    Screen current isNil ifTrue:[
    	Smalltalk openDisplay.
    ].
    self skipIf:Screen current isNil description:'No display connection'.
    Smalltalk loadPackage:'stx:goodies/sunit/ext/ui'.
    super setUp.

    browser := Tools::NewSystemBrowser new.
    browser open.
    browserInteractor := browser interactor.
    MessageTracer untraceMethod: (self class >> #foo)

    "Add your own code here..."

    "Modified: / 15-10-2017 / 21:54:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tearDown
    browser closeDownViews.
    browser := browserInteractor := nil.
    MessageTracer untraceMethod: (self class >> #foo)


    "Add your own code here..."

    "Created: / 07-08-2017 / 16:25:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!NewSystemBrowserTests methodsFor:'tests'!

test_issue_108_a

    self assert: (self class >> #foo) mclass == self class.
    self assert: (self class >> #foo) isWrapped not.

    browserInteractor do:[ browser switchToClass: self class selector: #foo ].
    self assert: browser theSingleSelectedMethod == (self class >> #foo).
    "
    browser selectedMethods onChangeEvaluate: [ self halt ]
    "
    browserInteractor do:[ browser  debugMenuTrace ].
    self assert: (self class >> #foo) == (browser theSingleSelectedMethod).
    self assert: (self class >> #foo) mclass == self class.
    self assert: (self class >> #foo) isWrapped.
    self assert: (self class >> #foo) originalMethod isWrapped not.

    browserInteractor do:[ browser  debugMenuTraceSender ].
    self assert: (self class >> #foo) == (browser theSingleSelectedMethod).
    self assert: (self class >> #foo) mclass == self class.
    self assert: (self class >> #foo) isWrapped.
    self assert: (self class >> #foo) originalMethod isWrapped not.

    browserInteractor do:[ browser  debugMenuRemoveBreakOrTrace ].
    self assert: (self class >> #foo) == (browser theSingleSelectedMethod).
    self assert: (self class >> #foo) mclass == self class.
    self assert: (self class >> #foo) isWrapped not.

    "Created: / 07-08-2017 / 16:07:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-10-2017 / 23:25:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_issue_108_b

    self assert: (self class >> #foo) mclass == self class.
    self assert: (self class >> #foo) isWrapped not.

    browserInteractor do:[ browser switchToClass: self class selector: #foo ].
    self assert: browser theSingleSelectedMethod == (self class >> #foo).
    "
    browser selectedMethods onChangeEvaluate: [ self halt ]
    (browser builder findComponentAt:#MethodList) application selectedMethodNameIndices onChangeEvaluate: [ self halt ].
    "
    browserInteractor do:[ browser  debugMenuBreakPoint ].
    self assert: (self class >> #foo) == (browser theSingleSelectedMethod).
    self assert: (self class >> #foo) mclass == self class.
    self assert: (self class >> #foo) isWrapped.
    self assert: (self class >> #foo) originalMethod isWrapped not.

    browserInteractor do:[ browser  debugMenuRemoveBreakOrTrace ].
    self assert: (self class >> #foo) == (browser theSingleSelectedMethod).
    self assert: (self class >> #foo) mclass == self class.
    self assert: (self class >> #foo) isWrapped not.

    "Created: / 15-10-2017 / 22:30:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!NewSystemBrowserTests class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

