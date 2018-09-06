"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#FilenameTests
	instanceVariableNames:'filename'
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression'
!


!FilenameTests methodsFor:'running'!

tearDown
    filename notNil ifTrue:[
	filename exists ifTrue:[
	    filename remove
	]
    ].

    "Created: / 21-02-2013 / 17:56:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!FilenameTests methodsFor:'tests'!

test_01
    "
    Tests whether filenames are properly encoded before
    passed to an operating system (i.e. whether paths
    are string-type transparent)
    "

    | path |

    filename := 'abcd' asFilename.
    "Create the file"
    filename writingFileDo:[:s|].

    path := filename pathName.
    "Make sure it is all ascii"
    self assert: (path allSatisfy:[:c|c codePoint <= 127]).

    self assert: path asFilename exists.
    self assert: path asUnicode16String asFilename exists.
    self assert: path asUnicode32String asFilename exists.

    "Created: / 21-02-2013 / 17:45:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_01_unix
    "
    Tests whether filenames are properly encoded before
    passed to an operating system (i.e. whether paths
    are string-type transparent)

    This has been fixed in JV's stx:libbasic rev 7766f4524d50.

    See https://swing.fit.cvut.cz/hg/stx.libbasic/rev/7766f4524d50

    "

    | path locale |

    OperatingSystem isUNIXlike ifFalse:[ ^ self ].

    filename := 'unix' asFilename.
    "Create the file"
    filename writingFileDo:[:s|].

    path := filename pathName.
    "Make sure it is all ascii"
    self assert: (path allSatisfy:[:c|c codePoint <= 127]).

    "Now, pretend standard locale..."
    locale := OperatingSystem getEnvironment: 'LANG'.

    [
	OperatingSystem setEnvironment: 'LANG' to: 'C'.
	OperatingSystem initialize. "/reinitialize locale definitions

	self assert: path asFilename exists.
	self assert: path asUnicode16String asFilename exists.
	self assert: path asUnicode32String asFilename exists.

    ] ensure:[
	OperatingSystem setEnvironment: 'LANG' to: locale.
	OperatingSystem initialize. "/reinitialize locale definitions
    ]

    "Created: / 21-02-2013 / 17:56:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!FilenameTests class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

