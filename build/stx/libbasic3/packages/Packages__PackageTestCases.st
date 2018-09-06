"
 COPYRIGHT (c) 2003 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"

"{ Package: 'stx:libbasic3' }"

"{ NameSpace: Packages }"

AbstractTestCases subclass:#PackageTestCases
	instanceVariableNames:'packageManager workingPackage'
	classVariableNames:''
	poolDictionaries:''
	category:'Package'
!

!PackageTestCases class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2003 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

documentation
"
    documentation to be added.

    [author:]
         (james@miraculix)

    [instance variables:]

    [class variables:]

    [see also:]

"
!

history
    "Created: / 24.1.2003 / 16:15:21 / james"
! !

!PackageTestCases methodsFor:'initialize / release'!

initialize

    packageManager ifNil:[
        packageManager := self packageManager.
    ].

    workingPackage ifNil:[
        workingPackage := packageManager workingPackage.
    ].
!

setUp
    "common setup - invoked before testing"
    super setUp.
    self setUpUsedClasses.
!

setUpAllForQWERTY
    | class copyQWERTYDic|
    
    (class := Smalltalk at:#QWERTY) ifNil:[
        self createClassNamed:#QWERTY. 
        (class := Smalltalk at:#QWERTY).
    ].
    (class compiledMethodAt:#aDummyMethod) ifNil:[
        self createMethodFor:QWERTY source:'aDummyMethod 1 + 1.'.
    ].
    (class compiledMethodAt:#aDummyMethod2) ifNil:[
        self createMethodFor:QWERTY source:'aDummyMethod2 1 + 1.'.
    ].
    (class compiledMethodAt:#aDummyMethod3) ifNil:[
        self createMethodFor:QWERTY source:'aDummyMethod3 1 + 1.'.
    ].

    copyQWERTYDic := QWERTY methodDictionary copy.
    copyQWERTYDic removeKey:#aDummyMethod.
    copyQWERTYDic removeKey:#aDummyMethod2.
    copyQWERTYDic removeKey:#aDummyMethod3.
    copyQWERTYDic keysAndValuesDo:[:key :value |
       QWERTY methodDictionary removeKey:key.
    ].


    packageManager moveClass:QWERTY toPackage:workingPackage.
    packageManager moveMethod:(class compiledMethodAt:#aDummyMethod) toPackage:workingPackage.
    packageManager moveMethod:(class compiledMethodAt:#aDummyMethod2) toPackage:workingPackage.
    packageManager moveMethod:(class compiledMethodAt:#aDummyMethod3) toPackage:workingPackage.
!

setUpAllForQWERTZ
    | class copyQWERTZDic|
    (class := Smalltalk at:#QWERTZ) ifNil:[
        self createClassNamed:#QWERTZ.
        (class := Smalltalk at:#QWERTZ)
    ].


    (class compiledMethodAt:#aDummyMethod) ifNil:[
        self createMethodFor:QWERTZ source:'aDummyMethod 1 + 1.'.
    ].
    (class compiledMethodAt:#aDummyMethod2) ifNil:[
        self createMethodFor:QWERTZ source:'aDummyMethod2 1 + 1.'.
    ].
    (class compiledMethodAt:#aDummyMethod3) ifNil:[
        self createMethodFor:QWERTZ source:'aDummyMethod3 1 + 1.'.
    ].

    copyQWERTZDic := QWERTZ methodDictionary copy.
    copyQWERTZDic removeKey:#aDummyMethod.
    copyQWERTZDic removeKey:#aDummyMethod2.
    copyQWERTZDic removeKey:#aDummyMethod3.
    copyQWERTZDic keysAndValuesDo:[:key :value |
       QWERTZ methodDictionary removeKey:key.
    ].

    packageManager moveClass:QWERTZ toPackage:workingPackage.
    packageManager moveMethod:(class compiledMethodAt:#aDummyMethod) toPackage:workingPackage.
    packageManager moveMethod:(class compiledMethodAt:#aDummyMethod2) toPackage:workingPackage.
    packageManager moveMethod:(class compiledMethodAt:#aDummyMethod3) toPackage:workingPackage.
!

setUpUsedClasses
    "common setup - invoked before testing"
    |  |
    self setUpAllForQWERTZ.
    self setUpAllForQWERTY.                
!

tearDown
    "common cleanup - invoked after testing"

    "move class package to where it was"
    super tearDown
! !

!PackageTestCases methodsFor:'test - accessing'!

test_classNames
    | packageTestCases |
    [
        packageTestCases := packageManager newPackageNamed:#'packageTestCases'.
        packageManager moveClass:QWERTZ toPackage:packageTestCases.
        packageManager moveClass:QWERTY toPackage:packageTestCases.

        self assert:(packageTestCases classNames includesAll:#(#QWERTZ #QWERTY)).
        self assert:(packageTestCases isDirty).
    ] ensure:
    [
        packageTestCases ifNotNil:[
            packageManager removePackage:packageTestCases.
        ].
    ]
!

test_isDirty
    | packageTestCases |
    [
        packageTestCases := packageManager newPackageNamed:#'packageTestCases'.
        packageManager moveClass:QWERTZ toPackage:packageTestCases.
        self assert:(packageTestCases isDirty).
    ] ensure:
    [
        packageTestCases ifNotNil:[
            packageManager removePackage:packageTestCases.
        ].
    ]
! !

!PackageTestCases methodsFor:'test - adding and removing'!

test_addMethod
    | packageTestCases |

    [
        "setting up the test"
        packageTestCases := packageManager newPackageNamed:#'packageTestCases'.

        packageManager moveClass:QWERTZ toPackage:packageTestCases.
        packageTestCases isDirty:false.   "i am telling it a fib here "
        "prerequisites to test"
        self assert:((packageTestCases blockedMethodsAtClassNamed:#QWERTZ) size == 0).
        self shouldnt:(packageTestCases isDirty).
        self assert:(packageTestCases isInstalled).

        "add a method for QWERTZ and test that the package adds a blocked method, as
        the method is from the workingPackage "
        self createMethodFor:QWERTZ source:'aDummyMethodTest_test_addMethod2 1 + 1.'.   
        self assert:((packageTestCases blockedMethodsAtClassNamed:#QWERTZ) size == 1).
        self assert:(packageTestCases isInstalled).
        self shouldnt:(packageTestCases isDirty).

        self assert:(QWERTZ compiledMethodAt:#aDummyMethodTest_test_addMethod2) package == workingPackage name.

    ] ensure:
    [
        packageTestCases ifNotNil:[
            packageManager removePackage:packageTestCases.
        ].

        QWERTZ methodDictionary removeKey:#aDummyMethodTest_test_addMethod2 ifAbsent:["do nothing"].
    ]
!

test_addMethod2
    "
    check that when a method is added to a new package and then added back to the old package
    that 
    1) the oldPackage has got the method and has not got any overriddenMethods
    2) the 'newPackage' has got the method registered as an overriddenMethod
    "
    | packageTestCases packageTestCases2 aMethodToOverride|

    [
        "setting up the test"
        packageTestCases := packageManager newPackageNamed:#'packageTestCases'.
        packageTestCases2 := packageManager newPackageNamed:#'packageTestCases2'.

        packageManager moveClass:QWERTZ toPackage:packageTestCases.
        packageTestCases isDirty:false.   "i am telling it a fib here "
        "prerequisites to test"
        self shouldnt:(packageTestCases isDirty).
        aMethodToOverride :=  QWERTZ methodDictionary values first.
        "add a method for QWERTZ and test that the package adds a blocked method, as
        the method is from the workingPackage "

        packageManager addMethod:aMethodToOverride toPackage:packageTestCases2.

       "Tests for packageTestCases"
        self assert:(packageTestCases overriddenChangesIncludesMethodName:aMethodToOverride name forClassNamed:#QWERTZ).
        self shouldnt:(packageTestCases isDirty).  "it is overridden not dirty"

        "Tests for packageTestCases2"
        self assert:(packageTestCases2 definesSelector:aMethodToOverride name forClassNamed:#QWERTZ).
        self assert:(packageTestCases2 isDirty).  "was not there before so is dirty!!"
        self shouldnt:(packageTestCases2 overriddenChangesIncludesMethodName:aMethodToOverride name forClassNamed:#QWERTZ).

        packageManager addMethod:aMethodToOverride toPackage:packageTestCases.

       "Tests for packageTestCases"
        self assert:(packageTestCases isDirty).  "a new version of the method is added!!"
        self shouldnt:(packageTestCases overriddenChangesIncludesMethodName:aMethodToOverride name forClassNamed:#QWERTZ).

        "Tests for packageTestCases2"
        self assert:(packageTestCases2 overriddenChangesIncludesMethodName:aMethodToOverride name forClassNamed:#QWERTZ).
        self assert:(packageTestCases2 isDirty).

    ] ensure:
    [
        packageTestCases ifNotNil:[
            packageManager removePackage:packageTestCases.
        ].
        packageTestCases ifNotNil:[
            packageManager removePackage:packageTestCases2.
        ].

        QWERTZ methodDictionary removeKey:#aDummyMethodTest_test_addMethod2 ifAbsent:["do nothing"].
    ]
!

test_moveMethod
    | packageTestCases method1 method2|
    "prerequisites to test"

    [
        packageTestCases := packageManager newPackageNamed:#'packageTestCases'.
        method1 := (QWERTZ compiledMethodAt:#aDummyMethod).
        method2 := (QWERTZ compiledMethodAt:#aDummyMethod2).

        self shouldnt:(packageTestCases isDirty).

        packageManager moveMethod:method1 toPackage:packageTestCases.
        packageManager moveMethod:method2 toPackage:packageTestCases.

        self assert:(packageTestCases isDirty).
        self assert:(packageTestCases isInstalled).
        self assert:(packageTestCases definesSelector:method1 name forClassNamed:method1 mclass name).
        self assert:(packageTestCases definesSelector:method2 name forClassNamed:method2 mclass name).

    ] ensure:
    [
        packageTestCases ifNotNil:[
            packageManager removePackage:packageTestCases.
        ].
    ]
!

test_packagedClass_isInSmalltalk
    | package1 package2|
    "prerequisites to test"

    [
        package1 := Package packageManager newPackageNamed:#'package1'.
        package2 := Package packageManager newPackageNamed:#'package2'. 

        packageManager moveClassNamed:#QWERTZ fromPackage:workingPackage toPackage:package1.
        self assert:(package1 packagedClassNamed:#QWERTZ) isInSmalltalk.

        packageManager addClass:QWERTZ toPackage:package2.

        self assert:(package2 packagedClassNamed:#QWERTZ) isInSmalltalk.
        self shouldnt:(package1 packagedClassNamed:#QWERTZ) isInSmalltalk.
        
        (package2 packagedClassNamed:#QWERTZ) .

    ] ensure:
    [
        package1 ifNotNil:[
            packageManager unloadPackageNamed:#'package1'.
        ].
        package2 ifNotNil:[
            packageManager unloadPackageNamed:#'package2'.
        ].
    ]
! !

!PackageTestCases methodsFor:'test - moving'!

obsolete_test_moveMethod1
    "moving classes via change notification is now deprecated as i found it best to try and seperate
    the functionality on Smalltalk and the functionality of package handling.
    "
    "Move QWERTZ class from package1 to package 2. Then move the class back."
    | package1 package2 aName  theMethod methodOwnedClass|
    [
        package1 :=  packageManager newPackageNamed:#'package1'.
        package2 :=  packageManager newPackageNamed:#'package2'.
        theMethod :=(QWERTZ compiledMethodAt:#'aDummyMethod').
        methodOwnedClass := QWERTZ.

        packageManager addMethod:theMethod toPackage:package1.

        self assert:(package1 definesSelector:#'aDummyMethod' forClassNamed:#QWERTZ).
        self shouldnt:(package2 definesSelector:#'aDummyMethod' forClassNamed:#QWERTZ).

        self assert:(package1 isDirty).
        self shouldnt:(package2 isDirty).

        "<simulatedChangeInBrowser>"
            "This change always moves the method away from the classes current owner"
            self assert:(aName := theMethod package) == package1 name.
            theMethod setPackage:package2 name.
            ChangeFaker methodMovePackageChangeWithMethod:theMethod class:methodOwnedClass oldPackageName:aName.
        "</simulatedChangeInBrowser>"
        self assert:(package1 definesSelector:#'aDummyMethod' forClassNamed:#QWERTZ).
        self assert:(package2 definesSelector:#'aDummyMethod' forClassNamed:#QWERTZ).

        self assert:(package2 packagedMethodNamed:#'aDummyMethod' forClassNamed:#QWERTZ) isInSmalltalk.      
        self shouldnt:(package1 packagedMethodNamed:#'aDummyMethod' forClassNamed:#QWERTZ) isInSmalltalk.     

        self assert:(package2 isDependentOnMethodNamed:#'aDummyMethod' forClassNamed:#QWERTZ).     
        self shouldnt:(package1 isDependentOnMethodNamed:#'aDummyMethod' forClassNamed:#QWERTZ).       

        self assert:(package2 isDirty).
        self assert:(package1 isDirty).

        "<simulatedChangeInBrowser>"
            "This change always moves the method away from the classes current owner"
            self assert:(aName := theMethod package) == package2 name.
            theMethod setPackage:package1 name.
            ChangeFaker methodMovePackageChangeWithMethod:theMethod class:methodOwnedClass oldPackageName:aName.
        "</simulatedChangeInBrowser>"
        self assert:(package1 isDependentOnMethodNamed:#'aDummyMethod' forClassNamed:#QWERTZ).     
        self shouldnt:(package2 isDependentOnMethodNamed:#'aDummyMethod' forClassNamed:#QWERTZ).       

        self shouldnt:(package2 packagedMethodNamed:#'aDummyMethod' forClassNamed:#QWERTZ) isInSmalltalk.      
        self assert:(package1 packagedMethodNamed:#'aDummyMethod' forClassNamed:#QWERTZ) isInSmalltalk.

        self assert:(package2 isDirty).
        self assert:(package1 isDirty).

        packageManager addClass:QWERTZ toPackage:defaultPackage.
    ] ensure:[
        packageManager unloadPackageNamed:#'package1'.
        packageManager unloadPackageNamed:#'package2'.
    ].
! !

!PackageTestCases class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic3/packages/PackageTestCases.st,v 1.5 2006/01/10 09:31:48 cg Exp $'
! !