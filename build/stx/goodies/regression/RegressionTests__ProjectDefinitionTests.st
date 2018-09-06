"{ Encoding: utf8 }"

"
 COPYRIGHT (c) Claus Gittinger / eXept Software AG
 COPYRIGHT (c) 2016-2017 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#ProjectDefinitionTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression'
!

!ProjectDefinitionTests class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) Claus Gittinger / eXept Software AG
 COPYRIGHT (c) 2016-2017 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!ProjectDefinitionTests methodsFor:'running'!

tearDown
    | classes methods |

    "Also, wipe out all mocks"
    classes := OrderedCollection new.
    methods := OrderedCollection new.
    Smalltalk allClassesDo:[:cls|
	(cls package notNil and:[cls package startsWith:'stx:goodies/regression/testData']) ifTrue:[
	    classes add: cls
	] ifFalse:[
	    cls methodsDo:[:m|(m package notNil and:[m package startsWith:'stx:goodies/regression/testData']) ifTrue:[methods add: m]].
	    cls class methodsDo:[:m|(m package notNil and:[m package startsWith:'stx:goodies/regression/testData']) ifTrue:[methods add: m]].
	]
    ].
    Class withoutUpdatingChangesDo:[
	classes do:[:cls|Smalltalk removeClass: cls].
	methods do:[:m|m mclass removeSelector: m selector]
    ].

    "Created: / 22-03-2013 / 11:31:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectDefinitionTests methodsFor:'tests - regression'!

test_issue63_01

    | classes1 classes2 code |

    classes1 := stx_libbasic classNamesAndAttributes.
    code := stx_libbasic classNamesAndAttributes_code_ignoreOldEntries: false ignoreOldDefinition: false.
    classes2 := Compiler evaluate: (code copyFrom: 'classNamesAndAttributes' size + 1).

    self assert: (classes1 \ classes2) isEmpty.
    self assert: (classes2 \ classes1) isEmpty.

    "Created: / 20-07-2017 / 17:36:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 24-07-2017 / 21:05:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_issue63_02u
    "
    Issue #63: Test if platform-specific attribute is preserved
    across class renames.

    See https://swing.fit.cvut.cz/projects/stx-jv/ticket/63
    "    

    | pkg pkgDef classes code |

    self skipIf: OperatingSystem isUNIXlike not description: 'This test in UNIX specific'.

    pkg := 'stx:goodies/regression/testData/packages/p2platform_specific_classes'.
    Smalltalk loadPackage: pkg.
    pkgDef := ProjectDefinition definitionClassForPackage: pkg.
    classes := pkgDef classNamesAndAttributes.
    self assert: (classes includes: #(UnixSpecificClass unix)).
    self assert: (classes includes: #(VMSSpecificClass vms)).
    self assert: (classes includes: #(Win32SpecificClass win32)).
    self assert: (Smalltalk includesKey: #UnixSpecificClass).
    self assert: (Smalltalk includesKey: #Win32SpecificClass) not.
    self assert: (Smalltalk includesKey: #VMSSpecificClass) not.


    Smalltalk renameClass: (Smalltalk at: #UnixSpecificClass) to: #XXXXSpecificClass.
    code := pkgDef classNamesAndAttributes_code_ignoreOldEntries: false ignoreOldDefinition: false.
    classes := Compiler evaluate: (code copyFrom: 'classNamesAndAttributes' size + 1).
    self assert: (classes includes: #(XXXXSpecificClass unix)).
    self assert: (classes includes: #(VMSSpecificClass vms)).
    self assert: (classes includes: #(Win32SpecificClass win32)).

    Smalltalk renameClass: (Smalltalk at: #XXXXSpecificClass) to: #YYYYSpecificClass.
    code := pkgDef classNamesAndAttributes_code_ignoreOldEntries: false ignoreOldDefinition: false.
    classes := Compiler evaluate: (code copyFrom: 'classNamesAndAttributes' size + 1).
    self assert: (classes includes: #(YYYYSpecificClass unix)).
    self assert: (classes includes: #(VMSSpecificClass vms)).
    self assert: (classes includes: #(Win32SpecificClass win32)).

    Smalltalk renameClass: (Smalltalk at: #YYYYSpecificClass) to: #UnixSpecificClass.
    code := pkgDef classNamesAndAttributes_code_ignoreOldEntries: false ignoreOldDefinition: false.
    classes := Compiler evaluate: (code copyFrom: 'classNamesAndAttributes' size + 1).
    self assert: (classes includes: #(UnixSpecificClass unix)).
    self assert: (classes includes: #(VMSSpecificClass vms)).
    self assert: (classes includes: #(Win32SpecificClass win32)).

    Smalltalk renameClass: (Smalltalk at: #UnixSpecificClass) to: #ZZZZSpecificClass.
    code := pkgDef classNamesAndAttributes_code_ignoreOldEntries: false ignoreOldDefinition: false.
    classes := Compiler evaluate: (code copyFrom: 'classNamesAndAttributes' size + 1).
    self assert: (classes includes: #(ZZZZSpecificClass unix)).
    self assert: (classes includes: #(VMSSpecificClass vms)).
    self assert: (classes includes: #(Win32SpecificClass win32)).

    "Created: / 26-07-2017 / 22:57:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-07-2017 / 10:49:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_issue63_02w
    "
    Issue #63: Test if platform-specific attribute is preserved
    across class renames.

    See https://swing.fit.cvut.cz/projects/stx-jv/ticket/63
    "    

    | pkg pkgDef classes code |

    self skipIf: OperatingSystem isMSWINDOWSlike not description: 'This test in Windows specific'.

    pkg := 'stx:goodies/regression/testData/packages/p2platform_specific_classes'.
    Smalltalk loadPackage: pkg.
    pkgDef := ProjectDefinition definitionClassForPackage: pkg.
    classes := pkgDef classNamesAndAttributes.
    self assert: (classes includes: #(UnixSpecificClass unix)).
    self assert: (classes includes: #(VMSSpecificClass vms)).
    self assert: (classes includes: #(Win32SpecificClass win32)).
    self assert: (Smalltalk includesKey: #UnixSpecificClass) not.
    self assert: (Smalltalk includesKey: #Win32SpecificClass).
    self assert: (Smalltalk includesKey: #VMSSpecificClass) not.


    Smalltalk renameClass: (Smalltalk at: #Win32SpecificClass) to: #XXXXSpecificClass.
    code := pkgDef classNamesAndAttributes_code_ignoreOldEntries: false ignoreOldDefinition: false.
    classes := Compiler evaluate: (code copyFrom: 'classNamesAndAttributes' size + 1).
    self assert: (classes includes: #(UnixSpecificClass unix)).
    self assert: (classes includes: #(VMSSpecificClass vms)).
    self assert: (classes includes: #(XXXXSpecificClass win32)).

    Smalltalk renameClass: (Smalltalk at: #XXXXSpecificClass) to: #YYYYSpecificClass.
    code := pkgDef classNamesAndAttributes_code_ignoreOldEntries: false ignoreOldDefinition: false.
    classes := Compiler evaluate: (code copyFrom: 'classNamesAndAttributes' size + 1).
    self assert: (classes includes: #(UnixSpecificClass unix)).
    self assert: (classes includes: #(VMSSpecificClass vms)).
    self assert: (classes includes: #(YYYYSpecificClass win32)).

    Smalltalk renameClass: (Smalltalk at: #YYYYSpecificClass) to: #Win32SpecificClass.
    code := pkgDef classNamesAndAttributes_code_ignoreOldEntries: false ignoreOldDefinition: false.
    classes := Compiler evaluate: (code copyFrom: 'classNamesAndAttributes' size + 1).
    self assert: (classes includes: #(UnixSpecificClass unix)).
    self assert: (classes includes: #(VMSSpecificClass vms)).
    self assert: (classes includes: #(Win32SpecificClass win32)).

    Smalltalk renameClass: (Smalltalk at: #Win32SpecificClass) to: #ZZZZSpecificClass.
    code := pkgDef classNamesAndAttributes_code_ignoreOldEntries: false ignoreOldDefinition: false.
    classes := Compiler evaluate: (code copyFrom: 'classNamesAndAttributes' size + 1).
    self assert: (classes includes: #(UnixSpecificClass unix)).
    self assert: (classes includes: #(VMSSpecificClass vms)).
    self assert: (classes includes: #(ZZZZSpecificClass win32)).

    "Created: / 27-07-2017 / 10:51:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectDefinitionTests methodsFor:'tests - utf8'!

test_filein_01
    "
    Test of filein of a class with non-ASCII/ISO8859-1 chars
    "
    | file |

    file := (Smalltalk getPackageDirectoryForPackage: self class package) / 'testData' / 'packages' / 'p1utf8' / 'ProjectDefinitionTestsP1UTF8Bar.st'.
    self assert: file exists.

    file fileIn.

    self assert: (Smalltalk at:#ProjectDefinitionTestsP1UTF8Bar) notNil.
    self assert: (Smalltalk at:#ProjectDefinitionTestsP1UTF8Bar) new zork size = 38.
    self assert: (Smalltalk at:#ProjectDefinitionTestsP1UTF8Bar) new zork = 'Příliš žluťoučký kůň úpěl ďábelské ódy'.

    "Created: / 22-03-2013 / 11:39:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_filein_01b
    "
    Test of filein of a class with non-ASCII/ISO8859-1 chars
    "
    | file |

    file := (Smalltalk getPackageDirectoryForPackage: self class package) / 'testData' / 'packages' / 'p1utf8' / 'ProjectDefinitionTestsP1UTF8Bar.st'.
    self assert: file exists.

    file contents asString readStream fileIn.

    self assert: (Smalltalk at:#ProjectDefinitionTestsP1UTF8Bar) notNil.
    self assert: (Smalltalk at:#ProjectDefinitionTestsP1UTF8Bar) new zork size = 38.
    self assert: (Smalltalk at:#ProjectDefinitionTestsP1UTF8Bar) new zork = 'Příliš žluťoučký kůň úpěl ďábelské ódy'.

    "Created: / 25-03-2013 / 22:51:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_filein_03
    "
    Test of filein of a extension with non-ASCII/ISO8859-1 chars
    "
    | file |

    file := (Smalltalk getPackageDirectoryForPackage: self class package) / 'testData' / 'packages' / 'p1utf8' / 'extensions.st'.
    self assert: file exists.

    file fileIn.

    self assert: nil zork size = 38.
    self assert: nil zork = 'Příliš žluťoučký kůň úpěl ďábelské ódy'.

    "Created: / 22-03-2013 / 11:40:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_loadPackage_utf8_01
    "
    Test of filein of a extension with non-ASCII/ISO8859-1 chars
    "

    Transcript showCR:'loading p1utf8 package...'.
    [
	Smalltalk loadPackage: 'stx:goodies/regression/testData/packages/p1utf8'.
    ] ifCurtailed:[
	thisContext fullPrintAll
    ].
    Transcript showCR:'done.'.

    self assert: (Smalltalk at:#ProjectDefinitionTestsP1UTF8Bar) notNil.
    self assert: (Smalltalk at:#ProjectDefinitionTestsP1UTF8Bar) new zork size = 38.
    self assert: (Smalltalk at:#ProjectDefinitionTestsP1UTF8Bar) new zork = 'Příliš žluťoučký kůň úpěl ďábelské ódy'.

    self assert: nil zork size = 38.
    self assert: nil zork = 'Příliš žluťoučký kůň úpěl ďábelské ódy'.

    Transcript showCR:'test done.'.
    Smalltalk unloadPackage: 'stx:goodies/regression/testData/packages/p1utf8'.

    "Created: / 22-03-2013 / 11:44:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectDefinitionTests methodsFor:'tests-obsolete'!

test1
    self skipIf:true description:'obsolete and outdated'.

    DAPASX::DapasXProject compileClassNames.
    self assert:(DAPASX::DapasXProject classNames asSortedCollection = DAPASX::DapasXProject searchForClassesNamesWithProject asSortedCollection)

    "Modified: / 09-08-2006 / 18:22:16 / fm"
! !

!ProjectDefinitionTests class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

