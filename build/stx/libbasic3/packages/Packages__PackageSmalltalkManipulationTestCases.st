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

AbstractTestCases subclass:#PackageSmalltalkManipulationTestCases
	instanceVariableNames:'packageManager defaultPackage'
	classVariableNames:''
	poolDictionaries:''
	category:'Package'
!

!PackageSmalltalkManipulationTestCases class methodsFor:'documentation'!

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
! !

!PackageSmalltalkManipulationTestCases methodsFor:'initialize / release'!

initialize

    packageManager ifNil:[
        packageManager := self packageManager.
    ].

    defaultPackage ifNil:[
        defaultPackage := packageManager defaultPackage.
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

    packageManager moveClass:QWERTY toPackage:defaultPackage.
    packageManager moveMethod:(class compiledMethodAt:#aDummyMethod) toPackage:defaultPackage.
    packageManager moveMethod:(class compiledMethodAt:#aDummyMethod2) toPackage:defaultPackage.
    packageManager moveMethod:(class compiledMethodAt:#aDummyMethod3) toPackage:defaultPackage.
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

    packageManager moveClass:QWERTZ toPackage:defaultPackage.
    packageManager moveMethod:(class compiledMethodAt:#aDummyMethod) toPackage:defaultPackage.
    packageManager moveMethod:(class compiledMethodAt:#aDummyMethod2) toPackage:defaultPackage.
    packageManager moveMethod:(class compiledMethodAt:#aDummyMethod3) toPackage:defaultPackage.
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

!PackageSmalltalkManipulationTestCases methodsFor:'test - creation'!

testClassCreation
    "tests that new classes are automatically included in workingPackage"
     | packagedClass |
    [
        "prerequisites"
        self assert:(Smalltalk classNamed:#QWERTZ2) isNil.

        self createClassNamed:#QWERTZ2.
        self assert:(packageManager workingPackage includesPackagedClassNamed:#QWERTZ2).
        packagedClass := (packageManager workingPackage packagedClassNamed:#QWERTZ2).
        self assert:(packagedClass isInSmalltalk)
    ] ensure:[
        (Smalltalk classNamed:#QWERTZ2) ifNotNil:[ 
            (Smalltalk classNamed:#QWERTZ2) removeFromSystem.
        ].
        self assert:(defaultPackage includesPackagedClassNamed:#QWERTZ2).
        self shouldnt:(packagedClass isInSmalltalk).
        packagedClass removeFromPackage.

        self shouldnt:(defaultPackage includesPackagedClassNamed:#QWERTZ2).
    ]
!

testClassCreation2
    "tests that new classes are automatically included in workingPackage"
     | packagedClass packageTestCases |
    [
        self shouldnt:(packageManager workingPackage includesPackagedClassNamed:#QWERTZ2).

        packageTestCases := packageManager newPackageNamed:#'packageTestCases'.
        packageManager workingPackage:packageTestCases.
        self createClassNamed:#QWERTZ2.
        self assert:(QWERTZ2 package == packageManager workingPackage name).


        self assert:(packageTestCases includesPackagedClassNamed:#QWERTZ2).
        packagedClass := (packageTestCases packagedClassNamed:#QWERTZ2).
        self assert:(packagedClass isInSmalltalk)
    ] ensure:[
        packageTestCases ifNotNil:[
            packageManager removePackageNamed:#'packageTestCases'.
        ].

        (Smalltalk classNamed:#QWERTZ2) ifNotNil:[ 
            (Smalltalk classNamed:#QWERTZ2) removeFromSystem.
        ].

        packageManager workingPackage:defaultPackage.
        self shouldnt:(packageManager workingPackage includesPackagedClassNamed:#QWERTZ2).
    ]

!

testClassRedefine
    "tests that new classes are automatically included in workingPackage"
     | packagedClass packageTestCases workingPackage newPackage |
    [
        packageTestCases := packageManager newPackageNamed:#'packageTestCases'.
        workingPackage := packageManager workingPackage.
        self createClassNamed:#QWERTZ2.
        self createMethodFor:QWERTZ2 source:'testBasicMethodCreation 1 + 1'.
        self createMethodFor:QWERTZ2 source:'testBasicMethodCreation 1 + 1'.
        self createMethodFor:QWERTZ2 source:'testBasicMethodCreation 1 + 1'.
        self assert:(QWERTZ2 package == packageManager workingPackage name).

        packageManager moveClass:QWERTZ2 toPackage:packageTestCases.
        self assert:(packageTestCases includesPackagedClassNamed:#QWERTZ2).
        packagedClass := (packageTestCases packagedClassNamed:#QWERTZ2).
        self assert:(packagedClass isInSmalltalk).

        self shouldnt:(workingPackage includesPackagedClassNamed:#QWERTZ2).

        self createClassNamed:#QWERTZ2 inheritsFrom:#Collection.
        newPackage := packageManager packageNamed:QWERTZ2 package.  

        self assert:(newPackage includesPackagedClassNamed:#QWERTZ2).
        packagedClass := (newPackage packagedClassNamed:#QWERTZ2).
        self assert:(packagedClass isInSmalltalk).

        workingPackage ~= newPackage ifTrue:[
            self shouldnt:(workingPackage includesPackagedClassNamed:#QWERTZ2).
        ].


        packageManager moveClass:QWERTZ2 toPackage:packageTestCases.
    ] ensure:[
        packageManager unloadPackageNamed:#'packageTestCases'.
        (Smalltalk classNamed:#QWERTZ2) ifNotNil:[ 
            (Smalltalk classNamed:#QWERTZ2) removeFromSystem.
        ].
    ]
!

testMethodCreation
    "tests that new methods are automatically included in workingPackage"
    self createMethodFor:QWERTZ source:'testBasicMethodCreation 1 + 1'.
    self assert:(packageManager workingPackage definesSelector:#testBasicMethodCreation forClassNamed:#QWERTZ)
!

testMethodRedefine
    "tests that redefined are automatically included in workingPackage when they are added to
    another package"
     | package1 method1 packageClassIsIn packageMethodIsIn |
    [
        package1 := packageManager newPackageNamed:#'package1'.

        self createClassNamed:#QWERTZ2.
        self createMethodFor:QWERTZ2 source:'testBasicMethodCreation 1 + 1'.
        method1 := QWERTZ2 compiledMethodAt:#testBasicMethodCreation.

        packageClassIsIn := packageManager packageNamed:QWERTZ2 package.
        packageMethodIsIn := packageManager packageNamed:method1 package.

        self assert:(packageMethodIsIn definesSelector:#testBasicMethodCreation forClassNamed:#QWERTZ2).
        self assert:(packageMethodIsIn isDependentOnMethodNamed:#testBasicMethodCreation forClassNamed:#QWERTZ2).

        packageManager addMethod:method1 toPackage:package1.
        self assert:(package1 definesSelector:#testBasicMethodCreation forClassNamed:#QWERTZ2).
        self assert:(package1 isDependentOnMethodNamed:#testBasicMethodCreation forClassNamed:#QWERTZ2).

        self createMethodFor:QWERTZ2 source:'testBasicMethodCreation 1 + 1'.

        method1 := QWERTZ2 compiledMethodAt:#testBasicMethodCreation.
        packageMethodIsIn := packageManager packageNamed:method1 package.

        self assert:(packageMethodIsIn definesSelector:#testBasicMethodCreation forClassNamed:#QWERTZ2).
        self assert:(packageMethodIsIn isDependentOnMethodNamed:#testBasicMethodCreation forClassNamed:#QWERTZ2).
        "sometimes the #keep is done automatically. #keep meaning when a method is created a signal is asked for
        and if not returned the method is either keep in the current project OR put into another one OR put into
        the working package"
        package1 ~=  packageMethodIsIn ifTrue:[
            self assert:(package1 definesSelector:#testBasicMethodCreation forClassNamed:#QWERTZ2).
            self shouldnt:(package1 isDependentOnMethodNamed:#testBasicMethodCreation forClassNamed:#QWERTZ2).
        ].

    ] ensure:[
        packageManager unloadPackageNamed:#'package1'.
        (Smalltalk classNamed:#QWERTZ2) ifNotNil:[ 
            (Smalltalk classNamed:#QWERTZ2) removeFromSystem.
        ].
    ]
!

testMethodRedefine2
    "tests that redefined are automatically included in workingPackage when they are moved to
    another package"
     | package1 method1 packageClassIsIn packageMethodIsIn |
    [
        package1 := packageManager newPackageNamed:#'package1'.

        self createClassNamed:#QWERTZ2.
        self createMethodFor:QWERTZ2 source:'testBasicMethodCreation 1 + 1'.
        method1 := QWERTZ2 compiledMethodAt:#testBasicMethodCreation.
        packageClassIsIn := packageManager packageNamed:QWERTZ2 package.
        packageMethodIsIn := packageManager packageNamed:method1 package.

        self assert:(packageMethodIsIn definesSelector:#testBasicMethodCreation forClassNamed:#QWERTZ2).
        self assert:(packageMethodIsIn isDependentOnMethodNamed:#testBasicMethodCreation forClassNamed:#QWERTZ2).

        packageManager moveMethod:method1 toPackage:package1.
        self assert:(package1 definesSelector:#testBasicMethodCreation forClassNamed:#QWERTZ2).
        self assert:(package1 isDependentOnMethodNamed:#testBasicMethodCreation forClassNamed:#QWERTZ2).

        self createMethodFor:QWERTZ2 source:'testBasicMethodCreation 1 + 1'.
        method1 := QWERTZ2 compiledMethodAt:#testBasicMethodCreation.
        packageMethodIsIn := packageManager packageNamed:method1 package.

        self assert:(packageMethodIsIn definesSelector:#testBasicMethodCreation forClassNamed:#QWERTZ2).
        self assert:(packageMethodIsIn isDependentOnMethodNamed:#testBasicMethodCreation forClassNamed:#QWERTZ2).
        package1 ~= packageMethodIsIn ifTrue:[
            self assert:(package1 definesSelector:#testBasicMethodCreation forClassNamed:#QWERTZ2).
            self shouldnt:(package1 isDependentOnMethodNamed:#testBasicMethodCreation forClassNamed:#QWERTZ2).
        ].

    ] ensure:[
        packageManager unloadPackageNamed:#'package1'.
        (Smalltalk classNamed:#QWERTZ2) ifNotNil:[ 
            (Smalltalk classNamed:#QWERTZ2) removeFromSystem.
        ].
    ]
!

testMethodRedefine3_cancel
    "tests that redefined methods that want to be kept in the cuurent package do so!!
    "
     | package1 method1 method2 packageClassIsIn packageMethodIsIn packageMethodWasIn |
    [
        package1 := packageManager newPackageNamed:#'package1'.
        self createClassNamed:#QWERTZ2.
        self createMethodFor:QWERTZ2 source:'testBasicMethodCreation 1 + 1'.

        method1 := QWERTZ2 compiledMethodAt:#testBasicMethodCreation.

        packageClassIsIn := packageManager packageNamed:QWERTZ2 package.
        packageMethodIsIn := packageManager packageNamed:method1 package.


        self assert:(packageMethodIsIn definesSelector:#testBasicMethodCreation forClassNamed:#QWERTZ2).
        self assert:(packageMethodIsIn isDependentOnMethodNamed:#testBasicMethodCreation forClassNamed:#QWERTZ2).

        packageManager moveMethod:method1 toPackage:package1.
        method1 := QWERTZ2 compiledMethodAt:#testBasicMethodCreation.

        packageMethodIsIn := packageManager packageNamed:method1 package.
        self assert:(packageMethodIsIn definesSelector:#testBasicMethodCreation forClassNamed:#QWERTZ2).
        self assert:(packageMethodIsIn isDependentOnMethodNamed:#testBasicMethodCreation forClassNamed:#QWERTZ2).

        packageMethodWasIn := packageMethodIsIn.

     method1 := QWERTZ2 compiledMethodAt:#testBasicMethodCreation.
     (Class methodRedefinitionSignal) handle:[:ex | 
                ex proceedWith:#cancel
        ] do:[
            self createMethodFor:QWERTZ2 source:'testBasicMethodCreation 1 + 1'.
            method2 := QWERTZ2 compiledMethodAt:#testBasicMethodCreation.
        ].

        self shouldnt:(method2 package = method1 package).

    ] ensure:[
        packageManager unloadPackageNamed:#'package1'.
        (Smalltalk classNamed:#QWERTZ2) ifNotNil:[ 
            (Smalltalk classNamed:#QWERTZ2) removeFromSystem.
        ].
    ]
!

testMethodRedefine3_continue
    "tests that redefined methods that want to be kept in the cuurent package do so!!
    "
     | package1 method1 packageClassIsIn packageMethodIsIn packageMethodWasIn |
    [
        package1 := packageManager newPackageNamed:#'package1'.
        self createClassNamed:#QWERTZ2.
        self createMethodFor:QWERTZ2 source:'testBasicMethodCreation 1 + 1'.

        method1 := QWERTZ2 compiledMethodAt:#testBasicMethodCreation.

        packageClassIsIn := packageManager packageNamed:QWERTZ2 package.
        packageMethodIsIn := packageManager packageNamed:method1 package.


        self assert:(packageMethodIsIn definesSelector:#testBasicMethodCreation forClassNamed:#QWERTZ2).
        self assert:(packageMethodIsIn isDependentOnMethodNamed:#testBasicMethodCreation forClassNamed:#QWERTZ2).

        method1 := QWERTZ2 compiledMethodAt:#testBasicMethodCreation.
        packageManager moveMethod:method1 toPackage:package1.
        method1 := QWERTZ2 compiledMethodAt:#testBasicMethodCreation.

        packageMethodIsIn := packageManager packageNamed:method1 package.
        self assert:(packageMethodIsIn definesSelector:#testBasicMethodCreation forClassNamed:#QWERTZ2).
        self assert:(packageMethodIsIn isDependentOnMethodNamed:#testBasicMethodCreation forClassNamed:#QWERTZ2).

        packageMethodWasIn := packageMethodIsIn.

       (Class methodRedefinitionSignal) handle:[:ex |
                ex proceedWith:#continue
        ] do:[
            self createMethodFor:QWERTZ2 source:'testBasicMethodCreation 1 + 1'.
            method1 := QWERTZ2 compiledMethodAt:#testBasicMethodCreation.
        ].

        packageMethodIsIn := packageManager packageNamed:method1 package.
        self assert:(packageMethodIsIn definesSelector:#testBasicMethodCreation forClassNamed:#QWERTZ2).
        self assert:(packageMethodIsIn isDependentOnMethodNamed:#testBasicMethodCreation forClassNamed:#QWERTZ2).

        packageMethodWasIn ~= packageMethodIsIn ifTrue:[
            self assert:(packageMethodIsIn definesSelector:#testBasicMethodCreation forClassNamed:#QWERTZ2).
            self shouldnt:(packageMethodWasIn isDependentOnMethodNamed:#testBasicMethodCreation forClassNamed:#QWERTZ2).
        ].

    ] ensure:[
        packageManager unloadPackageNamed:#'package1'.
        (Smalltalk classNamed:#QWERTZ2) ifNotNil:[ 
            (Smalltalk classNamed:#QWERTZ2) removeFromSystem.
        ].
    ]
!

testMethodRedefine3_keep
    "tests that redefined methods that want to be kept in the cuurent package do so!!
    "
     | package1 method1 packageClassIsIn packageMethodIsIn packageMethodWasIn |
    [
        package1 := packageManager newPackageNamed:#'package1'.
        self createClassNamed:#QWERTZ2.
        self createMethodFor:QWERTZ2 source:'testBasicMethodCreation 1 + 1'.

        method1 := QWERTZ2 compiledMethodAt:#testBasicMethodCreation.

        packageClassIsIn := packageManager packageNamed:QWERTZ2 package.
        packageMethodIsIn := packageManager packageNamed:method1 package.


        self assert:(packageMethodIsIn definesSelector:#testBasicMethodCreation forClassNamed:#QWERTZ2).
        self assert:(packageMethodIsIn isDependentOnMethodNamed:#testBasicMethodCreation forClassNamed:#QWERTZ2).

        method1 := QWERTZ2 compiledMethodAt:#testBasicMethodCreation.
        packageManager moveMethod:method1 toPackage:package1.
        method1 := QWERTZ2 compiledMethodAt:#testBasicMethodCreation.

        packageMethodIsIn := packageManager packageNamed:method1 package.
        self assert:(packageMethodIsIn definesSelector:#testBasicMethodCreation forClassNamed:#QWERTZ2).
        self assert:(packageMethodIsIn isDependentOnMethodNamed:#testBasicMethodCreation forClassNamed:#QWERTZ2).

        packageMethodWasIn := packageMethodIsIn.

       (Class methodRedefinitionSignal) handle:[:ex |
                ex proceedWith:#keep
        ] do:[
            self createMethodFor:QWERTZ2 source:'testBasicMethodCreation 1 + 1'.
            method1 := QWERTZ2 compiledMethodAt:#testBasicMethodCreation.
        ].

        packageMethodIsIn := packageManager packageNamed:method1 package.
        self assert:(packageMethodIsIn definesSelector:#testBasicMethodCreation forClassNamed:#QWERTZ2).
        self assert:(packageMethodIsIn isDependentOnMethodNamed:#testBasicMethodCreation forClassNamed:#QWERTZ2).

        packageMethodWasIn ~= packageMethodIsIn ifTrue:[
            self assert:(packageMethodIsIn definesSelector:#testBasicMethodCreation forClassNamed:#QWERTZ2).
            self shouldnt:(packageMethodWasIn isDependentOnMethodNamed:#testBasicMethodCreation forClassNamed:#QWERTZ2).
        ].

    ] ensure:[
        packageManager unloadPackageNamed:#'package1'.
        (Smalltalk classNamed:#QWERTZ2) ifNotNil:[ 
            (Smalltalk classNamed:#QWERTZ2) removeFromSystem.
        ].
    ]
! !

!PackageSmalltalkManipulationTestCases methodsFor:'test - fileIn type'!

testMethod_FileIn
    "I can across an error in the GUI builder when it tried to recompile a method on the class side!!
    it decided to change the package of the old class confusing the package completely!!
    "
     | package1 method1 packageClassIsIn packageMethodIsIn |
    [
        package1 := packageManager newPackageNamed:#'package1'.

        self createClassNamed:#QWERTZ2.
        self createMethodFor:QWERTZ2 source:'testBasicMethodCreation 1 + 1'.
        method1 := QWERTZ2 compiledMethodAt:#testBasicMethodCreation.

        packageClassIsIn := packageManager packageNamed:QWERTZ2 package.
        packageMethodIsIn := packageManager packageNamed:method1 package.

        self assert:(packageMethodIsIn definesSelector:#testBasicMethodCreation forClassNamed:#QWERTZ2).
        self assert:(packageMethodIsIn isDependentOnMethodNamed:#testBasicMethodCreation forClassNamed:#QWERTZ2).

        packageManager addMethod:method1 toPackage:package1.
        self assert:(package1 definesSelector:#testBasicMethodCreation forClassNamed:#QWERTZ2).
        self assert:(package1 isDependentOnMethodNamed:#testBasicMethodCreation forClassNamed:#QWERTZ2).

       " The test!!!!!! "
        self createMethodFor:QWERTZ2 source:'testBasicMethodCreation 1 + 1'.

        method1 := QWERTZ2 compiledMethodAt:#testBasicMethodCreation.
        packageMethodIsIn := packageManager packageNamed:method1 package.

        self assert:(packageMethodIsIn definesSelector:#testBasicMethodCreation forClassNamed:#QWERTZ2).
        self assert:(packageMethodIsIn isDependentOnMethodNamed:#testBasicMethodCreation forClassNamed:#QWERTZ2).
        "sometimes the #keep is done automatically. #keep meaning when a method is created a signal is asked for
        and if not returned the method is either keep in the current project OR put into another one OR put into
        the working package"
        package1 ~=  packageMethodIsIn ifTrue:[
            self assert:(package1 definesSelector:#testBasicMethodCreation forClassNamed:#QWERTZ2).
            self shouldnt:(package1 isDependentOnMethodNamed:#testBasicMethodCreation forClassNamed:#QWERTZ2).
        ].

    ] ensure:[
        packageManager unloadPackageNamed:#'package1'.
        (Smalltalk classNamed:#QWERTZ2) ifNotNil:[ 
            (Smalltalk classNamed:#QWERTZ2) removeFromSystem.
        ].
    ]
! !

!PackageSmalltalkManipulationTestCases methodsFor:'test - moving'!

obsolete_test_moveClass1
    "moving classes via change notification is now deprecated as i found it best to try and seperate
    the functionality on Smalltalk and the functionality of package handling.
    "
    "Move QWERTZ class from package1 to package 2. Then move the class back."
    | package1 package2 aName  |
    [
        package1 :=  packageManager newPackageNamed:#'package1'.
        package2 :=  packageManager newPackageNamed:#'package2'.

        packageManager addClass:QWERTZ toPackage:package1.

        self assert:(package1 includesPackagedClassNamed:#QWERTZ).
        self shouldnt:(package2 includesPackagedClassNamed:#QWERTZ).

        self assert:(package1 isDirty).
        self shouldnt:(package2 isDirty).

        "<simulatedChangeInBrowser>"
            "This change always moves the class away from the classes current owner"
            self assert:(aName := QWERTZ package) == package1 name.
            QWERTZ setPackage:package2 name.
            ChangeFaker classMovePackageChangeWithClass:QWERTZ oldPackageName:aName. 
        "</simulatedChangeInBrowser>"
        self assert:(package2 includesPackagedClassNamed:#QWERTZ).
        self assert:(package1 includesPackagedClassNamed:#QWERTZ).
        self assert:(package2 packagedClassNamed:#QWERTZ) isInSmalltalk.      
        self shouldnt:(package1 packagedClassNamed:#QWERTZ) isInSmalltalk.        
        self assert:(package2 isDependentOnClassNamed:#QWERTZ).     
        self shouldnt:(package1 isDependentOnClassNamed:#QWERTZ).       

        self assert:(package2 isDirty).
        self assert:(package1 isDirty).

        "<simulatedChangeInBrowser>"
            self assert:(aName := QWERTZ package) == package2 name.
            QWERTZ setPackage:package1 name.
            ChangeFaker classMovePackageChangeWithClass:QWERTZ oldPackageName:aName. 
        "</simulatedChangeInBrowser>"
        self shouldnt:(package2 isDependentOnClassNamed:#QWERTZ).    
        self assert:(package1 isDependentOnClassNamed:#QWERTZ).

        self assert:(package1 packagedClassNamed:#QWERTZ) isInSmalltalk. 
        self assert:(package2 isDirty).
        self assert:(package1 isDirty).
        self assert:((package1 blockedMethodsAtClassNamed:#QWERTZ) size == 0).
        packageManager addClass:QWERTZ toPackage:defaultPackage.
    ] ensure:[
        packageManager unloadPackageNamed:#'package1'.
        packageManager unloadPackageNamed:#'package2'.
    ].
!

obsolete_test_moveClass2
    "moving classes via change notification is now deprecated as i found it best to try and seperate
    the functionality on Smalltalk and the functionality of package handling.
    "
    "Move QWERTZ class to a new package named the same as the old package
    but with a 1 on the end. Then move the class back."
    | package1 package2 aName package3 |
    [
        package1 := packageManager newPackageNamed:#'package1'.
        package2 := packageManager newPackageNamed:#'package2'.
        package3 := packageManager newPackageNamed:#'package3'.

        packageManager addClass:QWERTZ toPackage:package1.
        packageManager addClass:QWERTZ toPackage:package2.
        packageManager addClass:QWERTZ toPackage:package3.

        self assert:(package1 includesPackagedClassNamed:#QWERTZ).
        self assert:(package2 includesPackagedClassNamed:#QWERTZ).
        self assert:(package3 includesPackagedClassNamed:#QWERTZ).

        self shouldnt:(package1 packagedClassNamed:#QWERTZ) isInSmalltalk.
        self shouldnt:(package2 packagedClassNamed:#QWERTZ) isInSmalltalk.
        self assert:(package3 packagedClassNamed:#QWERTZ) isInSmalltalk.

        self assert:(package1 isDirty).
        self assert:(package2 isDirty).
        self assert:(package3 isDirty).

        "<simulatedChangeInBrowser>"
            "This change always moves the class away from the classes current owner"
            self assert:(aName := QWERTZ package) == package3 name.
            QWERTZ setPackage:package2 name.
            ChangeFaker classMovePackageChangeWithClass:QWERTZ oldPackageName:aName. 
        "</simulatedChangeInBrowser>"
        self assert:(package2 includesPackagedClassNamed:#QWERTZ).
        self assert:(package3 includesPackagedClassNamed:#QWERTZ).

        self assert:(package2 packagedClassNamed:#QWERTZ) isInSmalltalk.         
        self shouldnt:(package3 packagedClassNamed:#QWERTZ) isInSmalltalk.         

        self assert:(package2 isDirty).
        self assert:(package3 isDirty).

        "<simulatedChangeInBrowser>"
            self assert:(aName := QWERTZ package) == package2 name.
            QWERTZ setPackage:package1 name.
            ChangeFaker classMovePackageChangeWithClass:QWERTZ oldPackageName:aName. 
        "</simulatedChangeInBrowser>"
        self assert:(package2 includesPackagedClassNamed:QWERTZ).
        self assert:(package1 includesPackagedClassNamed:QWERTZ).

        self assert:(package1 packagedClassNamed:#QWERTZ) isInSmalltalk.    
        self shouldnt:(package2 packagedClassNamed:#QWERTZ) isInSmalltalk.  

        self assert:(package3 isDirty).
        self assert:(package2 isDirty).
        self assert:(package1 isDirty).

    ] ensure:[
        packageManager unloadPackageNamed:#'package1'.
        packageManager unloadPackageNamed:#'package2'.
        packageManager unloadPackageNamed:#'package3'.
    ].
!

test_moveClass1
    "Move QWERTZ class from package1 to package 2. Then move the class back."
    | package1 aName  |
    [
        package1 :=  packageManager newPackageNamed:#'package1'.


        "<simulatedChangeInBrowser>"
            "This change always moves the class away from the classes current owner"
            self assert:(aName := QWERTZ package) == defaultPackage name.
            QWERTZ setPackage:package1 name.
            self should:[ChangeFaker classMovePackageChangeWithClass:QWERTZ oldPackageName:aName] raise:Error.
        "</simulatedChangeInBrowser>"
    ] ensure:[
        packageManager unloadPackageNamed:#'package1'.
    ].
!

test_moveMethod1
    "moving classes via change notification is now deprecated as i found it best to try and seperate
    the functionality on Smalltalk and the functionality of package handling.
    "
    "Move QWERTZ class from package1 to package 2. Then move the class back."
    | package1 aName  theMethod methodOwnedClass|
    [
        package1 :=  packageManager newPackageNamed:#'package1'.
        theMethod :=(QWERTZ compiledMethodAt:#'aDummyMethod').
        methodOwnedClass := QWERTZ.

        "<simulatedChangeInBrowser>"
            "This change always moves the method away from the classes current owner"
            self assert:(aName := theMethod package) == defaultPackage name.
            theMethod setPackage:package1 name.
            self should:[ChangeFaker methodMovePackageChangeWithMethod:theMethod class:methodOwnedClass oldPackageName:aName.]
                    raise:Error.
        "</simulatedChangeInBrowser>"
    ] ensure:[
        packageManager unloadPackageNamed:#'package1'.
    ].
! !

!PackageSmalltalkManipulationTestCases methodsFor:'test - removing'!

testClassRemove
    "Changes caught my the manager should not affect the packages state.
    So a class removal should remove the class in Smalltalk yet the package should still keep hold of the
    entire definition INCLUDING the methods it requires!!"
     | packagedClass packageTestCases|
    [
        packageTestCases := packageManager newPackageNamed:#'packageTestCases'.
        packageManager workingPackage:packageTestCases.

        self createClassNamed:#QWERTZ2.

        self assert:(packageManager workingPackage includesPackagedClassNamed:#QWERTZ2).
        packagedClass := (packageManager workingPackage packagedClassNamed:#QWERTZ2).
        self assert:(packagedClass isInSmalltalk).

        (Smalltalk classNamed:#QWERTZ2) ifNotNil:[ 
            (Smalltalk classNamed:#QWERTZ2) removeFromSystem.
        ].

        self shouldnt:(packagedClass isInSmalltalk).
        self assert:(packageManager workingPackage includesPackagedClassNamed:#QWERTZ2).


    ] ensure:[
        packageManager unloadPackageNamed:#'packageTestCases'.
        (Smalltalk classNamed:#QWERTZ2) ifNotNil:[ 
            (Smalltalk classNamed:#QWERTZ2) removeFromSystem.
        ].
    ]
!

testClassRemove2
    "Changes caught my the manager should not affect the packages state.
    So a class removal should remove the class in Smalltalk yet the package should still keep hold of the
    entire definition INCLUDING the methods it requires!!"
    "This one tests if the methods are still kept within the pacakge as packagedMethods"
    "WARNING!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! DONT correct during the debugger otherwise changes made could be removed!!!!!!"
     | packagedClass packageTestCases packagedMethod |
    [
        packageTestCases := packageManager newPackageNamed:#'packageTestCases'.
        packageManager workingPackage:packageTestCases.

        self createClassNamed:#QWERTZ2.
        self createMethodFor:QWERTZ2 source:'testBasicMethodCreation 1 + 1'.

        self assert:(packageTestCases includesPackagedClassNamed:#QWERTZ2).
        self assert:(packageTestCases definesSelector:#'testBasicMethodCreation' forClassNamed:#QWERTZ2).
        packagedClass := (packageTestCases packagedClassNamed:#QWERTZ2).
        self assert:(packagedClass isInSmalltalk).

        (Smalltalk classNamed:#QWERTZ2) ifNotNil:[ 
            (Smalltalk classNamed:#QWERTZ2) removeFromSystem.
        ].
        "test that the CLASS is removed from Smalltalk BUT the package still retains it!!"
        self assert:(packageTestCases includesPackagedClassNamed:#QWERTZ2).
        self assert:(packageTestCases definesSelector:#'testBasicMethodCreation' forClassNamed:#QWERTZ2).
        self shouldnt:(packagedClass isInSmalltalk).

        "test that the METHOD is removed from Smalltalk BUT the package still retains it!!"
        packagedMethod := (packageTestCases packagedMethodNamed:#'testBasicMethodCreation' forClassNamed:#QWERTZ2).
        self assert:(packagedMethod notNil).
        self shouldnt:(packagedMethod isInSmalltalk).
        

    ] ensure:[
        packageManager workingPackage:packageManager defaultPackage.
        packageManager unloadPackageNamed:#'packageTestCases'.
        (Smalltalk classNamed:#QWERTZ2) ifNotNil:[ 
            (Smalltalk classNamed:#QWERTZ2) removeFromSystem.
        ].
    ]
!

testClassRemove3
    "Changes caught my the manager should not affect the packages state.
    So a class removal should remove the class in Smalltalk yet the package should still keep hold of the
    entire definition INCLUDING the methods it requires!!"
    "This one tests if the methods are still kept within the pacakge as packagedMethods"
    "WARNING!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! DONT correct during the debugger otherwise changes made could be removed!!!!!!"
     | packagedClass package1 package2 packagedMethod1 packagedMethod2 method1 method2 |
    [
        package1 := packageManager newPackageNamed:#'package1'.
        package2 := packageManager newPackageNamed:#'package2'.

        self createClassNamed:#QWERTZ2.
        self createMethodFor:QWERTZ2 source:'testBasicMethodCreation 1 + 1'.
        self createMethodFor:QWERTZ2 source:'testBasicMethodCreation2 1 + 1'.
        method1 := QWERTZ2 compiledMethodAt:#testBasicMethodCreation.
        method2 := QWERTZ2 compiledMethodAt:#testBasicMethodCreation2.

        packageManager moveClass:QWERTZ2 toPackage:package1.
        "This blocks method2 from package1"
        packageManager moveMethod:method2 toPackage:package2.

        self assert:(package1 includesPackagedClassNamed:#QWERTZ2). 
        "package1 stores method2 as blocked"
        self shouldnt:(package1 definesSelector:method2 name forClassNamed:#QWERTZ2). 

        packagedClass := (package1 packagedClassNamed:#QWERTZ2). 
        self assert:packagedClass notNil.    
        self assert:(packagedClass isInSmalltalk).

        "Package2 should NOT define the class QWERTZ2 but should define method2 which should also be in Smalltalk!!"
        self shouldnt:(package2 includesPackagedClassNamed:#QWERTZ2).
        self assert:(package2 definesSelector:method2 name forClassNamed:#QWERTZ2).
        packagedMethod2 := (package2 packagedMethodNamed:method2 name forClassNamed:#QWERTZ2).
        self assert:(packagedMethod2 isInSmalltalk).

        (Smalltalk classNamed:#QWERTZ2) ifNotNil:[ 
            (Smalltalk classNamed:#QWERTZ2) removeFromSystem.
        ].
        "test that the CLASS is removed from Smalltalk BUT the package1 still retains it!!"
        self assert:(package1 includesPackagedClassNamed:#QWERTZ2).
        self assert:(package1 definesSelector:#'testBasicMethodCreation' forClassNamed:#QWERTZ2).
        self shouldnt:(packagedClass isInSmalltalk).

        "test that the METHOD is removed from Smalltalk BUT the package1 still retains it!!"
        self assert:(package1 definesSelector:method1 name forClassNamed:#QWERTZ2).
        packagedMethod1 := (package1 packagedMethodNamed:method1 name forClassNamed:#QWERTZ2).
        self assert:(packagedMethod1 notNil).
        self shouldnt:(packagedMethod1 isInSmalltalk).

        "test that the METHOD is removed from Smalltalk BUT the package2 still retains it!!"
        self assert:(package2 definesSelector:method2 name forClassNamed:#QWERTZ2).
        packagedMethod2 := (package2 packagedMethodNamed:method2 name forClassNamed:#QWERTZ2).
        self assert:(packagedMethod2 notNil).
        self shouldnt:(packagedMethod2 isInSmalltalk).


    ] ensure:[
        packageManager unloadPackageNamed:#'package1'.
        packageManager unloadPackageNamed:#'package2'.
        (Smalltalk classNamed:#QWERTZ2) ifNotNil:[ 
            (Smalltalk classNamed:#QWERTZ2) removeFromSystem.
        ].
    ]
!

testClassRemove4
    "Changes caught my the manager should not affect the packages state.
    So a class removal should remove the class in Smalltalk yet the package should still keep hold of the
    entire definition INCLUDING the methods it requires!!"
    "This one tests if the methods are still kept within the pacakge as packagedMethods"
     | packagedClass package1 package2 packagedMethod1 packagedMethod2 method1 method2 |
    [
        package1 := packageManager newPackageNamed:#'package1'.
        package2 := packageManager newPackageNamed:#'package2'.

        self createClassNamed:#QWERTZ2.
        self createMethodFor:QWERTZ2 source:'testBasicMethodCreation 1 + 1'.
        self createMethodFor:QWERTZ2 source:'testBasicMethodCreation2 1 + 1'.
        method1 := QWERTZ2 compiledMethodAt:#testBasicMethodCreation.
        method2 := QWERTZ2 compiledMethodAt:#testBasicMethodCreation2.

        packageManager moveClass:QWERTZ2 toPackage:package1.
        "This blocks method2 from package1"
        packageManager addMethod:method2 toPackage:package2.
        "method2 has been overridden in package1 by package2!!"

        self assert:(package1 includesPackagedClassNamed:#QWERTZ2).
        packagedClass := (package1 packagedClassNamed:#QWERTZ2).
        self assert:(packagedClass isInSmalltalk).

        "Method1 in package1 "
        self assert:(package1 definesSelector:method1 name forClassNamed:#QWERTZ2). 
        self assert:(package1 isDependentOnMethodNamed:method1 name forClassNamed:#QWERTZ2). 
        packagedMethod1 := (package1 packagedMethodNamed:method1 name forClassNamed:#QWERTZ2).  
        self assert:(packagedMethod1 isInSmalltalk).

        "Method2 in package1 is overridden but still own's a copy which it is not dependant on"
        self assert:(package1 definesSelector:method2 name forClassNamed:#QWERTZ2). 
        self shouldnt:(package1 isDependentOnMethodNamed:method2 name forClassNamed:#QWERTZ2). 
        packagedMethod2 := (package1 packagedMethodNamed:method2 name forClassNamed:#QWERTZ2).  
        self shouldnt:(packagedMethod2 isInSmalltalk).

        "Package2 should NOT define the class QWERTZ2 but should define method2 which should also be in Smalltalk!!"
        self shouldnt:(package2 includesPackagedClassNamed:#QWERTZ2).
        self assert:(package2 definesSelector:method2 name forClassNamed:#QWERTZ2).
        packagedMethod2 := (package2 packagedMethodNamed:method2 name forClassNamed:#QWERTZ2).
        self assert:(packagedMethod2 isInSmalltalk).

        (Smalltalk classNamed:#QWERTZ2) ifNotNil:[ 
            (Smalltalk classNamed:#QWERTZ2) removeFromSystem.
        ].
        "test that the CLASS is removed from Smalltalk BUT the package1 still retains it!!"
        self assert:(package1 includesPackagedClassNamed:#QWERTZ2).
        packagedClass := (package1 packagedClassNamed:#QWERTZ2).  
        self shouldnt:(packagedClass isInSmalltalk).

        "test that the METHOD1 is removed from Smalltalk BUT the package1 still retains it!!"
        self assert:(package1 definesSelector:method1 name forClassNamed:#QWERTZ2).
        self shouldnt:(package1 isDependentOnMethodNamed:method1 name forClassNamed:#QWERTZ2). 
        packagedMethod1 := (package1 packagedMethodNamed:method1 name forClassNamed:#QWERTZ2).
        self assert:(packagedMethod1 notNil).
        self shouldnt:(packagedMethod1 isInSmalltalk).

        "This that method2 is still overridden but still own's a copy which it is not dependant on"
        self assert:(package1 definesSelector:method2 name forClassNamed:#QWERTZ2). 
        self shouldnt:(package1 isDependentOnMethodNamed:method2 name forClassNamed:#QWERTZ2). 
        packagedMethod2 := (package1 packagedMethodNamed:method2 name forClassNamed:#QWERTZ2).
        self assert:(packagedMethod2 notNil).
        self shouldnt:(packagedMethod1 isInSmalltalk).

        "test that the METHOD is removed from Smalltalk BUT the package2 still retains it!!"
        self assert:(package2 definesSelector:method2 name forClassNamed:#QWERTZ2).
        self shouldnt:(package2 isDependentOnMethodNamed:method2 name forClassNamed:#QWERTZ2). 
        packagedMethod2 := (package2 packagedMethodNamed:method2 name forClassNamed:#QWERTZ2).
        self assert:(packagedMethod2 notNil).
        self shouldnt:(packagedMethod2 isInSmalltalk).


    ] ensure:[
        packageManager unloadPackageNamed:#'package1'.
        packageManager unloadPackageNamed:#'package2'.
        (Smalltalk classNamed:#QWERTZ2) ifNotNil:[ 
            (Smalltalk classNamed:#QWERTZ2) removeFromSystem.
        ].
    ]
!

testClassRemove5
    "Changes caught my the manager should not affect the packages state.
    So a class removal should remove the class in Smalltalk yet the package should still keep hold of the
    entire definition INCLUDING the methods it requires!!"
    "This one tests if the methods are still kept within the pacakge as packagedMethods"
     | packagedClass package1 package2 method1 |
    [
        package1 := packageManager newPackageNamed:#'package1'.
        package2 := packageManager newPackageNamed:#'package2'.

        self createClassNamed:#QWERTZ2.
        self createMethodFor:QWERTZ2 source:'testBasicMethodCreation 1 + 1'.
        self createMethodFor:QWERTZ2 source:'testBasicMethodCreation2 1 + 1'.
        method1 := QWERTZ2 compiledMethodAt:#testBasicMethodCreation.

        packageManager moveClass:QWERTZ2 toPackage:package1.

        packagedClass := (package1 packagedClassNamed:#QWERTZ2). 
        self assert:packagedClass notNil.    
        self assert:(packagedClass isInSmalltalk).
        self assert:(packagedClass packagedMethods size == 2).

        packageManager addClass:QWERTZ2 toPackage:package2.
        packagedClass := (package1 packagedClassNamed:#QWERTZ2). 
        self assert:packagedClass notNil.    
        self assert:(packagedClass packagedMethods size == 2).
        packagedClass packagedMethods do:[:aPackagedMethod |
            self assert:(aPackagedMethod isInSmalltalk).
        ].
        self shouldnt:(packagedClass isInSmalltalk).

        (Smalltalk classNamed:#QWERTZ2) ifNotNil:[ 
            (Smalltalk classNamed:#QWERTZ2) removeFromSystem.
        ].
        "package1 still has all the information it had before"
        packagedClass := (package1 packagedClassNamed:#QWERTZ2). 
        self assert:packagedClass notNil.    
        self assert:(packagedClass packagedMethods size == 2).
        packagedClass packagedMethods do:[:aPackagedMethod |
            self shouldnt:(aPackagedMethod isInSmalltalk).
        ].
        self shouldnt:(packagedClass isInSmalltalk).

        "test that the METHOD is removed from Smalltalk BUT the package2 still retains it!!"
        packagedClass := (package2 packagedClassNamed:#QWERTZ2). 
        self assert:packagedClass notNil.    
        self assert:(packagedClass packagedMethods size == 2).
        packagedClass packagedMethods do:[:aPackagedMethod |
            self shouldnt:(aPackagedMethod isInSmalltalk).
        ].
        self shouldnt:(packagedClass isInSmalltalk).



    ] ensure:[
        packageManager unloadPackageNamed:#'package1'.
        packageManager unloadPackageNamed:#'package2'.
        (Smalltalk classNamed:#QWERTZ2) ifNotNil:[ 
            (Smalltalk classNamed:#QWERTZ2) removeFromSystem.
        ].
    ]
!

testMethodRemove
    "Changes caught my the manager should not affect the packages state.
    So a class removal should remove the class in Smalltalk yet the package should still keep hold of the
    entire definition INCLUDING the methods it requires!!"
    "This one tests if the methods are still kept within the pacakge as packagedMethods"
    "WARNING!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! DONT correct during the debugger otherwise changes made could be removed!!!!!!"
     | package1 package2 packagedMethod1 method1  |
    [
        package1 := packageManager newPackageNamed:#'package1'.
        package2 := packageManager newPackageNamed:#'package2'.

        self createClassNamed:#QWERTZ2.
        self createMethodFor:QWERTZ2 source:'testBasicMethodCreation 1 + 1'.
        self createMethodFor:QWERTZ2 source:'testBasicMethodCreation2 1 + 1'.
        method1 := QWERTZ2 compiledMethodAt:#testBasicMethodCreation.

        packageManager moveClass:QWERTZ2 toPackage:package1.
        "This blocks method1 from package1"
        packageManager moveMethod:method1 toPackage:package2.

        self assert:(package1 includesPackagedClassNamed:#QWERTZ2). 
        "package1 stores method2 as blocked"
        self shouldnt:(package1 definesSelector:method1 name forClassNamed:#QWERTZ2). 


        "Package2 should NOT define the class QWERTZ2 but should define method2 which should also be in Smalltalk!!"
        self shouldnt:(package2 includesPackagedClassNamed:#QWERTZ2).
        self assert:(package2 definesSelector:method1 name forClassNamed:#QWERTZ2).
        packagedMethod1 := (package2 packagedMethodNamed:method1 name forClassNamed:#QWERTZ2).
        self assert:(packagedMethod1 isInSmalltalk).

        (Smalltalk classNamed:#QWERTZ2) ifNotNil:[        
            QWERTZ2 removeSelector:method1 name.
        ].
        "test that the CLASS is removed from Smalltalk BUT the package1 still retains it!!"
        self assert:(package1 includesPackagedClassNamed:#QWERTZ2).
        self shouldnt:(package1 definesSelector:#testBasicMethodCreation forClassNamed:#QWERTZ2).

        "test that the METHOD is still blocked in package1!!"
        self assert:(package2 definesSelector:#testBasicMethodCreation forClassNamed:#QWERTZ2).

        "test that the METHOD is removed from Smalltalk BUT the package2 still retains it!!"
        self assert:(package2 definesSelector:#testBasicMethodCreation forClassNamed:#QWERTZ2).
        packagedMethod1 := (package2 packagedMethodNamed:#testBasicMethodCreation forClassNamed:#QWERTZ2).
        self assert:(packagedMethod1 notNil).
        self shouldnt:(packagedMethod1 isInSmalltalk).


    ] ensure:[
        packageManager unloadPackageNamed:#'package1'.
        packageManager unloadPackageNamed:#'package2'.
        (Smalltalk classNamed:#QWERTZ2) ifNotNil:[ 
            (Smalltalk classNamed:#QWERTZ2) removeFromSystem.
        ].
    ]
!

testMethodRemove2
    "Changes caught my the manager should not affect the packages state.
    So a class removal should remove the class in Smalltalk yet the package should still keep hold of the
    entire definition INCLUDING the methods it requires!!"
    "This one tests if the methods are still kept within the pacakge as packagedMethods"
    "WARNING!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! DONT correct during the debugger otherwise changes made could be removed!!!!!!"
     | package1 package2 packagedMethod1 method1  |

    [
        "prerequisites"
        self assert:(Smalltalk classNamed:#QWERTZ2) isNil.

        package1 := packageManager newPackageNamed:#'package1'.
        package2 := packageManager newPackageNamed:#'package2'.

        self createClassNamed:#QWERTZ2.   
        self createMethodFor:QWERTZ2 source:'testBasicMethodCreation 1 + 1'.
        self createMethodFor:QWERTZ2 source:'testBasicMethodCreation2 1 + 1'.
        method1 := QWERTZ2 compiledMethodAt:#testBasicMethodCreation.

        packageManager moveClass:QWERTZ2 toPackage:package1.
        self assert:(package1 definesSelector:method1 name forClassNamed:#QWERTZ2). 
        self assert:(package1 isDependentOnMethodNamed:method1 name forClassNamed:#QWERTZ2). 

        "This blocks method1 from package1"
        packageManager addMethod:method1 toPackage:package2.

        self assert:(package1 includesPackagedClassNamed:#QWERTZ2). 
        "package1 stores method2 as overridden"
        self assert:(package1 definesSelector:method1 name forClassNamed:#QWERTZ2). 
        self shouldnt:(package1 isDependentOnMethodNamed:method1 name forClassNamed:#QWERTZ2). 


        "Package2 should NOT define the class QWERTZ2 but should define method2 which should also be in Smalltalk!!"
        self shouldnt:(package2 includesPackagedClassNamed:#QWERTZ2).
        self assert:(package2 definesSelector:method1 name forClassNamed:#QWERTZ2).
        packagedMethod1 := (package2 packagedMethodNamed:method1 name forClassNamed:#QWERTZ2).
        self assert:(packagedMethod1 isInSmalltalk).

        (Smalltalk classNamed:#QWERTZ2) ifNotNil:[        
            QWERTZ2 removeSelector:method1 name.
        ].
        "test that the CLASS is removed from Smalltalk BUT the package1 still retains it!!"
        self assert:(package1 includesPackagedClassNamed:#QWERTZ2).
        self assert:(package1 definesSelector:#testBasicMethodCreation forClassNamed:#QWERTZ2). 
        self shouldnt:(package1 isDependentOnMethodNamed:#testBasicMethodCreation forClassNamed:#QWERTZ2). 

        "test that the METHOD is still defined but overridden in package1!!"

        self assert:(package2 definesSelector:#testBasicMethodCreation forClassNamed:#QWERTZ2).
        self shouldnt:(package2 isDependentOnMethodNamed:#testBasicMethodCreation forClassNamed:#QWERTZ2). 

        "test that the METHOD is removed from Smalltalk BUT the package2 still retains it!!"
        self assert:(package2 definesSelector:#testBasicMethodCreation forClassNamed:#QWERTZ2).
        packagedMethod1 := (package2 packagedMethodNamed:#testBasicMethodCreation forClassNamed:#QWERTZ2).
        self assert:(packagedMethod1 notNil).
        self shouldnt:(packagedMethod1 isInSmalltalk).


    ] ensure:[
        (Smalltalk classNamed:#QWERTZ2) ifNotNil:[
                (Smalltalk classNamed:#QWERTZ2) removeFromSystem.
        ].
        packageManager unloadPackageNamed:#'package1'.
        packageManager unloadPackageNamed:#'package2'.
    ]
!

testMethodRemoveClassSide
    "Changes caught my the manager should not affect the packages state.
    So a class removal should remove the class in Smalltalk yet the package should still keep hold of the
    entire definition INCLUDING the methods it requires!!"
    "This one tests if the methods are still kept within the pacakge as packagedMethods"
     | package1 package2 packagedMethod1 method1  theClassName  workingPackage |
    [
        package1 := packageManager newPackageNamed:#'package1'.
        package2 := packageManager newPackageNamed:#'package2'.

        self createClassNamed:#QWERTZ2.
        workingPackage := packageManager packageNamed:QWERTZ2 package.
        self createMethodFor:QWERTZ2 class source:'testBasicMethodCreation 1 + 1'.
        self createMethodFor:QWERTZ2 class source:'testBasicMethodCreation2 1 + 1'.
        method1 := QWERTZ2 class compiledMethodAt:#testBasicMethodCreation.
        theClassName := (QWERTZ2 class name asSymbol).

        packageManager moveClass:QWERTZ2 toPackage:package1.

        self assert:(package1 includesPackagedClassNamed:theClassName). 
        self assert:(package1 definesSelector:method1 name forClassNamed:theClassName). 


        "This blocks method1 from package1"       
        packageManager moveMethod:method1 toPackage:package2.
        self assert:(package1 includesPackagedClassNamed:theClassName). 
        "package1 stores method2 as blocked"
        self shouldnt:(package1 definesSelector:method1 name forClassNamed:theClassName). 


        "Package2 should NOT define the class QWERTZ2 class but should define method2 which should also be in Smalltalk!!"
        self shouldnt:(package2 includesPackagedClassNamed:theClassName).
        self assert:(package2 definesSelector:method1 name forClassNamed:theClassName).
        packagedMethod1 := (package2 packagedMethodNamed:method1 name forClassNamed:theClassName).
        self assert:(packagedMethod1 isInSmalltalk).

        (Smalltalk classNamed:theClassName) ifNotNil:[        
           (Smalltalk classNamed:theClassName) removeSelector:method1 name.
        ].
        "test that the CLASS is removed from Smalltalk BUT the package1 still retains it!!"
        self assert:(package1 includesPackagedClassNamed:theClassName).
        self shouldnt:(package1 definesSelector:#testBasicMethodCreation forClassNamed:theClassName).

        "test that the METHOD is still blocked in package1!!"
        self assert:(package2 definesSelector:#testBasicMethodCreation forClassNamed:theClassName).

        "test that the METHOD is removed from Smalltalk BUT the package2 still retains it!!"
        self assert:(package2 definesSelector:#testBasicMethodCreation forClassNamed:theClassName).
        packagedMethod1 := (package2 packagedMethodNamed:#testBasicMethodCreation forClassNamed:theClassName).
        self assert:(packagedMethod1 notNil).
        self shouldnt:(packagedMethod1 isInSmalltalk).


    ] ensure:[
        packageManager unloadPackageNamed:#'package1'.
        packageManager unloadPackageNamed:#'package2'.
        (Smalltalk classNamed:theClassName) ifNotNil:[ 
            (Smalltalk classNamed:#QWERTZ2) removeFromSystem.
        ].
    ]
!

testMethodRemoveClassSide2
    "Changes caught my the manager should not affect the packages state.
    So a class removal should remove the class in Smalltalk yet the package should still keep hold of the
    entire definition INCLUDING the methods it requires!!"
    "This one tests if the methods are still kept within the pacakge as packagedMethods"
     | package1 package2 packagedMethod1 method1  theClassSideName |

    [
        "prerequisites"
        self assert:(Smalltalk classNamed:#QWERTZ2) isNil.

        package1 := packageManager newPackageNamed:#'package1'.
        package2 := packageManager newPackageNamed:#'package2'.

        self createClassNamed:#QWERTZ2.   
        theClassSideName := QWERTZ2 class name asSymbol.
        self createMethodFor:QWERTZ2 class source:'testBasicMethodCreation 1 + 1'.
        self createMethodFor:QWERTZ2 class source:'testBasicMethodCreation2 1 + 1'.
        method1 := QWERTZ2 class compiledMethodAt:#testBasicMethodCreation.

        packageManager moveClass:QWERTZ2 toPackage:package1.
        self assert:(package1 definesSelector:method1 name forClassNamed:theClassSideName). 
        self assert:(package1 isDependentOnMethodNamed:method1 name forClassNamed:theClassSideName). 

        "This blocks method1 from package1"
        packageManager addMethod:method1 toPackage:package2.

        self assert:(package1 includesPackagedClassNamed:theClassSideName). 
        "package1 stores method2 as overridden"
        self assert:(package1 definesSelector:method1 name forClassNamed:theClassSideName). 
        self shouldnt:(package1 isDependentOnMethodNamed:method1 name forClassNamed:theClassSideName). 


        "Package2 should NOT define the class but should define method2 which should also be in Smalltalk!!"
        self shouldnt:(package2 includesPackagedClassNamed:theClassSideName).
        self assert:(package2 definesSelector:method1 name forClassNamed:theClassSideName).
        packagedMethod1 := (package2 packagedMethodNamed:method1 name forClassNamed:theClassSideName).
        self assert:(packagedMethod1 isInSmalltalk).

        (Smalltalk classNamed:#QWERTZ2) ifNotNil:[        
            QWERTZ2 class removeSelector:method1 name. 
        ].
        "test that the CLASS is removed from Smalltalk BUT the package1 still retains it!!"
        self assert:(package1 includesPackagedClassNamed:theClassSideName).
        self assert:(package1 definesSelector:#testBasicMethodCreation forClassNamed:theClassSideName). 
        self shouldnt:(package1 isDependentOnMethodNamed:#testBasicMethodCreation forClassNamed:theClassSideName). 

        "test that the METHOD is still defined but overridden in package1!!"

        self assert:(package2 definesSelector:#testBasicMethodCreation forClassNamed:theClassSideName).
        self shouldnt:(package2 isDependentOnMethodNamed:#testBasicMethodCreation forClassNamed:theClassSideName). 

        "test that the METHOD is removed from Smalltalk BUT the package2 still retains it!!"
        self assert:(package2 definesSelector:#testBasicMethodCreation forClassNamed:theClassSideName).
        packagedMethod1 := (package2 packagedMethodNamed:#testBasicMethodCreation forClassNamed:theClassSideName).
        self assert:(packagedMethod1 notNil).
        self shouldnt:(packagedMethod1 isInSmalltalk).


    ] ensure:[
        (Smalltalk classNamed:#QWERTZ2) ifNotNil:[
                (Smalltalk classNamed:#QWERTZ2) removeFromSystem.
        ].
        packageManager unloadPackageNamed:#'package1'.
        packageManager unloadPackageNamed:#'package2'.
    ]
! !

!PackageSmalltalkManipulationTestCases class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic3/packages/PackageSmalltalkManipulationTestCases.st,v 1.6 2006/01/10 09:31:41 cg Exp $'
! !