"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#OS_OLE_Tests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'OS-Testing'
!

!OS_OLE_Tests class methodsFor:'documentation'!

documentation
"
    documentation to be added.

    [author:]
	cg (cg@FUSI)

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!OS_OLE_Tests methodsFor:'tests'!

test01_loadTypeLib
    "This is a demonstration testCase - it is meant to be removed eventually.
     This testCase will PASS.
     Double click on the TestCase class or open a TestRunner to see me checking...
     - please add more methods like this..."

    |handle|

    handle := OleCom::ITypeLib loadTypeLib:'C:\WINDOWS\system32\stdole32.tlb'.
    self assert: ( handle notNil ).
    "/ handle release.

    handle := OleCom::ITypeLib loadTypeLib:'c:\WINDOWS\system32\Macromed\Flash\swflash.ocx'.
    self assert: ( handle notNil ).
    "/ handle release.

    "
     self run:#test01_loadTypeLib
     self new test01_loadTypeLib
    "
!

test02_getTypeInfoCount
    "This is a demonstration testCase - it is meant to be removed eventually.
     This testCase will PASS.
     Double click on the TestCase class or open a TestRunner to see me checking...
     - please add more methods like this..."

    |handle numInfo|

    handle := OleCom::ITypeLib loadTypeLib:'C:\WINDOWS\system32\stdole32.tlb'.
    self assert: ( handle notNil ).

    numInfo := handle getTypeInfoCount.
    self assert: ( numInfo > 0 ).

    "/ handle release.

    "
     self run:#test02_getTypeInfoCount
     self new test02_getTypeInfoCount
    "
!

test03_coInitialize
    OleCom coInitialize.
    OleCom coUninitialize.

    "
     self run:#test03_coInitialize
     self new test03_coInitialize
    "
! !

!OS_OLE_Tests class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

