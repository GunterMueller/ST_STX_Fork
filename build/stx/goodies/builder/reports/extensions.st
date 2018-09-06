"{ Package: 'stx:goodies/builder/reports' }"!

!TestCase methodsFor:'accessing'!

nameForHDTestReport

    ^(self class package asString replaceAll: $: with: $.; replaceAll: $/ with: $.) , '.' , self name

    "
        Object nameForHDTestReport    
        SVN::Repository nameForHDTestReport
    "

    "Created: / 01-04-2011 / 16:09:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-04-2011 / 13:36:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TestCase methodsFor:'accessing'!

selectorForHDTestReport

	^testSelector

! !

!TestCase methodsFor:'accessing'!

timeout
    "Returns a default timeout (sec) for the test.
     If nil is returned, no timeout enforced.

    Note that the timeout is set only when running under
    report runner, interactive tools does not use it"

    | method |
    method := self class lookupMethodFor: testSelector.
    method annotationsAt:#timeout: do:[:annotation|
         ^annotation arguments first
    ].
    ^120"sec - default timeout"

    "Created: / 12-01-2012 / 17:48:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-09-2018 / 09:04:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TestCase class methodsFor:'testing'!

isJUnitTestCaseProxy

	^false

! !

!TestCase class methodsFor:'testing'!

isTestletTestCaseProxy

	^false

! !

!stx_goodies_builder_reports class methodsFor:'documentation'!

extensionsVersion_HG

    ^ '$Changeset: <not expanded> $'
! !
