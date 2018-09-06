"/ Script meant to be called from jenkins (or similar build tools)
"/
"/ runs a number of tests from the stx:goodies/regression package (see list below)
"/ execute this script using the following command line:
"/
"/ stx --noBanner -I --execute SelfTestRunner.st
"/   use --debug to debug failed test cases.
"/
"/ to use with jenkins (+ jUnit plugin):
"/ use the following buildscript (in jenkins):
"/ (after checkout of stx)
"/      cd stx
"/      call bmake
"/      cd goodies\selftest
"/      ..\..\projects\smalltalk\stx.com --noBanner -I --execute SelfTestRunner.st
"/

"/ tell the system, where stx is...
ParserFlags initializeSTCFlagsForTopDirectory:'..\..\stx'.

Object infoPrinting:false.
ObjectMemory infoPrinting:false.
!

Stdout showCR:'Loading required packages...'.
Smalltalk loadPackage:'stx:goodies/sunit'.
self assert:(TestCase notNil and:[TestCase isLoaded]).
Smalltalk loadPackage:'stx:libcompat'.
Smalltalk loadPackage:'stx:libjavascript'.
(Smalltalk at:#'RegressionTests::ClassAndMethodCompilingTestCase') isNil ifTrue:[
    Smalltalk fileInClass:'RegressionTests::ClassAndMethodCompilingTestCase' package:'stx:goodies/regression'
].
!

Stdout showCR:'Loading RegressionTests::QuickTestRunner...'.
(Smalltalk fileInClass:'RegressionTests::QuickTestRunner' package:'stx:goodies/regression')
notNil ifFalse:[
    Stderr showCR:'failed to load RegressionTests::QuickTestRunner.'.
    Smalltalk exit:1.
].
(Smalltalk classNamed:'RegressionTests::QuickTestRunner') isNil ifTrue:[
    Stderr showCR:'failed to load RegressionTests::QuickTestRunner.'.
    Smalltalk exit:1.
].
!

Stdout showCR:'Running QuickTestRunner suite...'.
!

RegressionTests::QuickTestRunner start.
Smalltalk exit:0.
