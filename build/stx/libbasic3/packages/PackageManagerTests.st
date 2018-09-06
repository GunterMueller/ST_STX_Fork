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

AbstractTestCases subclass:#PackageManagerTests
	instanceVariableNames:'packageManager defaultPackage'
	classVariableNames:''
	poolDictionaries:''
	category:'Package-Managers'
!

!PackageManagerTests class methodsFor:'documentation'!

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

!PackageManagerTests methodsFor:'initialize / release'!

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
    copyQWERTYDic := QWERTY methodDictionary copy.
    copyQWERTYDic removeKey:#aDummyMethod ifAbsent:[].
    copyQWERTYDic removeKey:#aDummyMethod2 ifAbsent:[].
    copyQWERTYDic removeKey:#aDummyMethod3 ifAbsent:[].
    copyQWERTYDic keysAndValuesDo:[:key :value |
       QWERTY methodDictionary removeKey:key.
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

    copyQWERTZDic := QWERTZ methodDictionary copy.
    copyQWERTZDic removeKey:#aDummyMethod ifAbsent:[].
    copyQWERTZDic removeKey:#aDummyMethod2 ifAbsent:[].
    copyQWERTZDic removeKey:#aDummyMethod3 ifAbsent:[].
    copyQWERTZDic keysAndValuesDo:[:key :value |
       QWERTZ methodDictionary removeKey:key.
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

!PackageManagerTests methodsFor:'test - adding and removing'!

test_addClass_toPackage
    | packageTestCases oldPackage|
    "prerequisites to test"
    "QWERTZ is in workingPackage"
    self assert:(packageManager packageNamed:(QWERTZ package)) == defaultPackage.
    [
        "set up"
        oldPackage := packageManager newPackageNamed:#'oldPackage'.       
        packageManager moveClass:QWERTZ toPackage:oldPackage.

        packageTestCases := packageManager newPackageNamed:#'packageTestCases'.
        oldPackage :=  packageManager packageNamed:(QWERTZ package).
        packageManager addClass:QWERTZ toPackage:packageTestCases.

        self assert: (packageTestCases isDirty).
        self assert: (packageTestCases isInstalled).
        self assert: (packageTestCases packagedClassNamed:#QWERTZ) notNil.
        self assert: (packageTestCases packagedClassNamed:#QWERTZ) isInSmalltalk.    
        self assert: (oldPackage packagedClassNamed:#QWERTZ) notNil.         
        self shouldnt: (oldPackage packagedClassNamed:#QWERTZ) isInSmalltalk.           

    ] ensure:
    [
        packageTestCases ifNotNil:[
            packageManager removePackage:packageTestCases.
       ].
        oldPackage ifNotNil:[
            packageManager removePackage:oldPackage.
       ].
    ]
!

test_addMethod_toPackage
    |method1 method2 packageTestCases|
    "prerequisites to test"
    "none at the moment"
    [
        packageTestCases := packageManager newPackageNamed:#'packageTestCases'.
        method1 := (QWERTZ compiledMethodAt:#aDummyMethod).
        method2 := (QWERTZ compiledMethodAt:#aDummyMethod2).

        packageManager addMethod:method1 toPackage:packageTestCases.
        packageManager addMethod:method2 toPackage:packageTestCases.

        self assert:(packageTestCases isDirty).
        self assert:(packageTestCases isInstalled).
    ] ensure:
    [
        packageTestCases ifNotNil:[
            packageManager removePackage:packageTestCases.
        ].
    ]
!

test_moveMethod_toPackage
    | packageTestCases method1 method2|
    "prerequisites to test"

    [
        packageTestCases := packageManager newPackageNamed:#'packageTestCases'.
        method1 := (QWERTZ compiledMethodAt:#aDummyMethod).
        method2 := (QWERTZ compiledMethodAt:#aDummyMethod2).
        packageManager moveMethod:method1 toPackage:packageTestCases.
        packageManager moveMethod:method2 toPackage:packageTestCases.

        self assert:(packageTestCases isDirty).
        self assert:(packageTestCases isInstalled).

    ] ensure:
    [
        packageTestCases ifNotNil:[
            packageManager removePackage:packageTestCases.
        ].
    ]
!

test_removeClassNamed_fromPackage
    | packageTestCases |
    "prerequisites to test"

    [
        packageTestCases := packageManager newPackageNamed:#'packageTestCases'.
        packageManager moveClass:QWERTZ toPackage:packageTestCases. 
        packageManager removeClassNamed:#QWERTZ fromPackage:packageTestCases.

        "test the class was completely removed!!"
        self assert:(Smalltalk at:#QWERTZ) notNil.

        "test that the package was changed"
        self assert:(packageTestCases isDirty).
        "test that the package still is installed"
        self assert:(packageTestCases isInstalled).
        "test that the class was removed from packageTestCases"
        self shouldnt:(packageTestCases includesPackagedClassNamed:#QWERTZ).

        "the class was moved where. Check it is here"
        self assert:(packageManager defaultPackage includesPackagedClassNamed:#QWERTZ).
    ] ensure:
    [
        packageTestCases ifNotNil:[
            packageManager removePackage:packageTestCases.
        ].
    ]
!

test_removeClass_fromPackage
    "to test that when a "
    | oldPackage |
    [
        "pre-setup"
            "i expect setUp should do this!!"
        self assert:(packageManager defaultPackage includesPackagedClassNamed:#QWERTZ).
        oldPackage := Package packageManager newPackageNamed:#'oldPackage'.
        packageManager moveClassNamed:#QWERTZ fromPackage:defaultPackage toPackage:oldPackage.

        "prerequisites"
        self shouldnt: (packageManager defaultPackage includesPackagedClassNamed:#QWERTZ).
        self assert: (oldPackage includesPackagedClassNamed:#QWERTZ).
        self shouldnt: (defaultPackage includesPackagedClassNamed:#QWERTZ).

        "check that the added class in oldPackage is in smalltalk
         and that that oldPackage has a packaged class representing it."
        self assert: (oldPackage packagedClassNamed:#QWERTZ) notNil.
        self assert: (oldPackage packagedClassNamed:#QWERTZ) isInSmalltalk.

        packageManager removeClassNamed:#QWERTZ fromPackage:oldPackage.

        "check that oldPackage has NOT got a packaged class representing it."
        self assert: (oldPackage packagedClassNamed:#QWERTZ) isNil.
        "check that the deleted class is then stored in workingClass"
        self assert: (defaultPackage packagedClassNamed:#QWERTZ) notNil.
        self assert: (defaultPackage packagedClassNamed:#QWERTZ) isInSmalltalk.        

    ] ensure:
    [
        oldPackage ifNotNil:[
            packageManager removePackage:oldPackage.
        ].
    ].
!

test_removeClass_fromPackage2
    "Test:
    When the manager removes the responsibility of a class from a package via:
        PackageManager>>removeClass:fromPackage:

    If a package overid another package with a class, and this package was
    deleted, the overriden information has to be updated.

    Sequence of events
        package1 owns class1
        package2 overrides class1
            package2 owns class1
            package1 stores class1 as overriddenBy: package2
        packageManager remove:class1 from:package2
            'at the moment'
            package2 no longer owns class1
            package stores class1 as overriddenBy:package2 'WRONG!!!!'

    There are two ways of going from here:

        1)  package1 brings its version forward redefining the smalltalk version
        2)  defaultPackage now owns this definition of class1 and package1 must update
            this change.

    I choose (2) as (1) may confuse the user. (2) has the advanatage that the Smalltalk
    dictionary does not change - and is what i would expect...
    "
    | package1 package2 |
    "i expect setUp should do this!!"
    self assert:(defaultPackage includesPackagedClassNamed:#QWERTZ).
    [
        "pre-setup"
        package1 := Package packageManager newPackageNamed:#'package1'.
        package2 := Package packageManager newPackageNamed:#'package2'. 
        packageManager moveClassNamed:#QWERTZ fromPackage:defaultPackage toPackage:package1.

        "prerequisites"
        self shouldnt: (defaultPackage includesPackagedClassNamed:#QWERTZ).
        self assert: (package1 includesPackagedClassNamed:#QWERTZ).

        "check that the added class in package1 is in smalltalk
         and that that package1 has a packaged class representing it."
        self assert: (package1 packagedClassNamed:#QWERTZ) notNil.
        self assert: (package1 packagedClassNamed:#QWERTZ) isInSmalltalk.

        "package2 overrides the responsibility of QWERTZ"
        packageManager addClass:QWERTZ toPackage:package2.
        "package2 should be responsible for QWERTZ and package1 should store that
        it was package2 that overrid the change"
        self assert: (package1 packagedClassNamed:#QWERTZ) notNil.
        self shouldnt: (package1 packagedClassNamed:#QWERTZ) isInSmalltalk.
        self assert: (package2 packagedClassNamed:#QWERTZ) notNil.
        self assert: (package2 packagedClassNamed:#QWERTZ) isInSmalltalk.
        self assert:(package1 overriddenClassNamesByPackage:package2) size == 1.
        self assert:(package1 overriddenClassNamesByPackage:package2) first == #QWERTZ. 

        "remove the class from the package2. This should make all the responsibilities
        go to defaultPackage in packageManager."  
        packageManager removeClassNamed:#QWERTZ fromPackage:package2.

        self assert: (package1 packagedClassNamed:#QWERTZ) notNil.
        self shouldnt: (package1 packagedClassNamed:#QWERTZ) isInSmalltalk.    

        self assert: (package2 packagedClassNamed:#QWERTZ) isNil.
        self assert:(package1 overriddenClassNamesByPackage:package2) size == 0.

        self assert:(package1 overriddenClassNamesByPackage:defaultPackage) size == 1.
        self assert:(package1 overriddenClassNamesByPackage:defaultPackage) first == #QWERTZ. 

        "check that the deleted class is then stored in workingClass"
        self assert: (defaultPackage packagedClassNamed:#QWERTZ) notNil.
        self assert: (defaultPackage packagedClassNamed:#QWERTZ) isInSmalltalk.        

    ] ensure:
    [
        package1 ifNotNil:[
            packageManager removePackage:package1.
        ].
        package2 ifNotNil:[
            packageManager removePackage:package2.
        ].
    ].
!

test_removeClass_fromPackage3
    "to test that when a "
    | package1 |
    [
        "pre-setup"
            "i expect setUp should do this!!"
        self assert:(packageManager defaultPackage includesPackagedClassNamed:#QWERTZ).
        package1 := Package packageManager newPackageNamed:#'package1'.
        packageManager moveClassNamed:#QWERTZ fromPackage:defaultPackage toPackage:package1.

        "prerequisites"
        self shouldnt: (packageManager defaultPackage includesPackagedClassNamed:#QWERTZ).
        self assert: (package1 includesPackagedClassNamed:#QWERTZ).
        self shouldnt: (defaultPackage includesPackagedClassNamed:#QWERTZ).

        "check that the added class in package1 is in smalltalk
         and that that package1 has a packaged class representing it."
        self assert: (package1 packagedClassNamed:#QWERTZ) notNil.
        self assert: (package1 packagedClassNamed:#QWERTZ) isInSmalltalk.

        packageManager removeClassNamed:#QWERTZ fromPackage:package1.

        "check that package1 has NOT got a packaged class representing it."
        self assert: (package1 packagedClassNamed:#QWERTZ) isNil.
        "check that the deleted class is then stored in workingClass"
        self assert: (defaultPackage packagedClassNamed:#QWERTZ) notNil.
        self assert: (defaultPackage packagedClassNamed:#QWERTZ) isInSmalltalk.  
        self assert:((defaultPackage packagedClassNamed:#QWERTZ) packagedMethods size == 3).
        self assert: (package1 packagedMethods at:#QWERTZ ifAbsent:[nil]) isNil.
    ] ensure:
    [
        package1 ifNotNil:[
            packageManager removePackage:package1.
        ].
    ].
!

test_removeMethod_fromPackage
    |method1 method2 packageTestCases|
    "prerequisites to test"

    [
        packageTestCases := packageManager newPackageNamed:#'packageTestCases'.
        method1 := (QWERTZ compiledMethodAt:#aDummyMethod).
        method2 := (QWERTZ compiledMethodAt:#aDummyMethod2).

        packageManager moveClass:QWERTZ toPackage:packageTestCases.

        packageManager moveMethod:method1 toPackage:packageTestCases.
        packageManager moveMethod:method2 toPackage:packageTestCases.

        self packageManager removeMethod:method2 fromPackage:packageTestCases.

        self assert:(packageTestCases includesPackagedClassNamed:#QWERTZ).
        self assert:(Smalltalk at:#QWERTZ) notNil.
        self assert:(packageTestCases isDirty).
        self assert:(packageTestCases isInstalled).
    ] ensure:
    [
        packageTestCases ifNotNil:[
            packageManager removePackage:packageTestCases.
        ].
    ]
!

test_removePackage
    "Test:
    When the manager removes the responsibility of a class from a package via:
        PackageManager>>removeClass:fromPackage:

    If a package overid another package with a class, and this package was
    deleted, the overriden information has to be updated.

    Sequence of events
        package1 owns class1
        package2 overrides class1
        package3 overrides class1
            package3 owns class1
            package2 stores class1 as overriddenBy: package3
            package1 stores class1 as overriddenBy: package2

        packageManager removePackage:package2
            'at the moment '
            package stores class1 as overriddenBy:package2 'WRONG!!!!'
            package3 owns class1

    "
    | package1 package2 package3 |
    "i expect setUp should do this!!"
    self assert:(packageManager workingPackage includesPackagedClassNamed:#QWERTZ).
    [
        "pre-setup"
        package1 := Package packageManager newPackageNamed:#'package1'.
        package2 := Package packageManager newPackageNamed:#'package2'.
        package3 := Package packageManager newPackageNamed:#'package3'.
        packageManager moveClassNamed:#QWERTZ fromPackage:defaultPackage toPackage:package1.

        "prerequisites"
        self shouldnt: (packageManager workingPackage includesPackagedClassNamed:#QWERTZ).
        self assert: (package1 includesPackagedClassNamed:#QWERTZ).

        "check that the added class in oldPackage is in smalltalk
         and that that oldPackage has a packaged class representing it."
        self assert: (package1 packagedClassNamed:#QWERTZ) notNil.
        self assert: (package1 packagedClassNamed:#QWERTZ) isInSmalltalk.

        "package2 overrides the responsibility of QWERTZ"
        packageManager addClass:QWERTZ toPackage:package2.
        "package2 should be responsible for QWERTZ and package1 should store that
        it was package2 that overrid the change"
        self assert: (package1 packagedClassNamed:#QWERTZ) notNil.
        self shouldnt: (package1 packagedClassNamed:#QWERTZ) isInSmalltalk.
        self assert: (package2 packagedClassNamed:#QWERTZ) notNil.
        self assert: (package2 packagedClassNamed:#QWERTZ) isInSmalltalk.
        self assert:(package1 overriddenClassNamesByPackage:package2) size == 1.
        self assert:(package1 overriddenClassNamesByPackage:package2) first == #QWERTZ.

        "package3 overrides the responsibility of QWERTZ"
        packageManager addClass:QWERTZ toPackage:package3.
        "package3 should be responsible for QWERTZ and package2 should store that
        it was package2 that overrid the change and package1 should store that package2
        overrid its changes"
        self assert: (package1 packagedClassNamed:#QWERTZ) notNil.
        self shouldnt: (package1 packagedClassNamed:#QWERTZ) isInSmalltalk.
        self assert: (package2 packagedClassNamed:#QWERTZ) notNil.
        self shouldnt: (package2 packagedClassNamed:#QWERTZ) isInSmalltalk.

        self assert: (package3 packagedClassNamed:#QWERTZ) notNil.
        self assert: (package3 packagedClassNamed:#QWERTZ) isInSmalltalk.

        self assert:(package1 overriddenClassNamesByPackage:package2) size == 1.
        self assert:(package1 overriddenClassNamesByPackage:package2) first == #QWERTZ. 
        self assert:(package2 overriddenClassNamesByPackage:package3) size == 1.
        self assert:(package2 overriddenClassNamesByPackage:package3) first == #QWERTZ. 

        "remove the package package2. This should make all the responsibilities
        stay in package3!!"
        packageManager unloadPackage:package2. 
        self assert: (package1 packagedClassNamed:#QWERTZ) notNil.
        self shouldnt: (package1 packagedClassNamed:#QWERTZ) isInSmalltalk.    
        self assert:(package1 overriddenClassNamesByPackage:package2) size == 0.
        self assert:(package1 overriddenClassNamesByPackage:defaultPackage) size == 0.

        self shouldnt: (packageManager includesPackage:package2).

        "check that the deleted class is then stored in package3"
        self assert:(package1 overriddenClassNamesByPackage:package3) size == 1.
        self assert:(package1 overriddenClassNamesByPackage:package3) first == #QWERTZ. 

    ] ensure:
    [
        package1 ifNotNil:[
            packageManager removePackageNamed:#'package1'.
        ].
        (packageManager includesPackage:package2) ifTrue:[
            packageManager removePackageNamed:#'package2'.
        ].
        package3 ifNotNil:[
            packageManager removePackageNamed:#'package3'.
        ].
    ].
! !

!PackageManagerTests methodsFor:'test - moving'!

test_addClass_PackageError
    "Move QWERTZ class to the default package that already knows it!! it should complain"
    [
        self should:[packageManager addClass:QWERTZ toPackage:defaultPackage] raise:PackageError

    ] ensure:[
    ].
!

test_addClass_Packaged_Error2
    "A class can only be added to a package when it doesnt have a class with the same name.
    if it does a PackageError occurs!!"
    | package1 package2|
    [
        package1 := packageManager newPackageNamed:#'package1'.
        package2 := packageManager newPackageNamed:#'package2'.

        self shouldnt:(package1 isDirty).
        self shouldnt:(package2 isDirty).

        "Add the class to package1 and package2 and then attempt to add it to package1 again"
        packageManager addClass:QWERTZ toPackage:package1.
        self assert:(package1 packagedClassNamed:#QWERTZ) isInSmalltalk.   
        self shouldnt:(package2 includesPackagedClassNamed:#QWERTZ).   

        packageManager addClass:QWERTZ toPackage:package2.
        self shouldnt:(package1 packagedClassNamed:#QWERTZ) isInSmalltalk.      
        self assert:(package2 packagedClassNamed:#QWERTZ) isInSmalltalk. 

        "QWERTZ is already in Smalltalk assigned to package2"
        self should:[packageManager addClass:QWERTZ toPackage:package2] raise:PackageError.
        "The state should stay the same as before this action was carried out"
        self shouldnt:(package1 packagedClassNamed:#QWERTZ) isInSmalltalk.      
        self assert:(package2 packagedClassNamed:#QWERTZ) isInSmalltalk.  

        "QWERTZ is already in Smalltalk but assigned to package2" 
        packageManager addClass:QWERTZ toPackage:package1.
        "QWERTZ is assigned to package 1"
        self shouldnt:(package2 packagedClassNamed:#QWERTZ) isInSmalltalk.      
        self assert:(package1 packagedClassNamed:#QWERTZ) isInSmalltalk.       

        packageManager addClass:QWERTZ toPackage:defaultPackage.
    ] ensure:[
        packageManager unloadPackageNamed:#'package1'.
        packageManager unloadPackageNamed:#'package2'.
    ].
!

test_moveClass1
    "Move QWERTZ class to a new package named the same as the old package
    but with a 1 on the end. Then move the class back."
    | package1 package2|
    [
        package1 := packageManager newPackageNamed:#'package1'.
        package2 := packageManager newPackageNamed:#'package2'.

        self shouldnt:(package1 isDirty).
        self shouldnt:(package2 isDirty).

        "Make the representation of QWERTZ is in the default package and
        have overriddenPackagedClasses in package1 and package2!!"
        packageManager addClass:QWERTZ toPackage:package1.
        packageManager addClass:QWERTZ toPackage:package2.      
        packageManager addClass:QWERTZ toPackage:defaultPackage.

        self assert:(QWERTZ package == defaultPackage name).

        self assert:(package1 overriddenClassChangesIncludesClassNamed:#QWERTZ).
        self assert:(package2 overriddenClassChangesIncludesClassNamed:#QWERTZ).

        self assert:(package1 includesPackagedClassNamed:#QWERTZ).
        self assert:(package2 includesPackagedClassNamed:#QWERTZ).

        self assert:(package1 isDirty).
        self assert:(package2 isDirty).

        "It is in defaultPackage"
        self shouldnt:(package1 packagedClassNamed:#QWERTZ) isInSmalltalk. 
        self shouldnt:(package2 packagedClassNamed:#QWERTZ) isInSmalltalk. 

        "<tested method>"
            self should:[packageManager moveClassNamed:#QWERTZ fromPackage:package1 toPackage:package2] raise:PackageError. 
            "If a class already owns a preresentation of a class by the same name it must be removed
             BEFORE the above action can take place. The state should remain the same as before"
        "</tested method>"

        self assert:(package1 overriddenClassChangesIncludesClassNamed:#QWERTZ).
        self assert:(package2 overriddenClassChangesIncludesClassNamed:#QWERTZ).

        self assert:(package1 includesPackagedClassNamed:#QWERTZ).
        self assert:(package2 includesPackagedClassNamed:#QWERTZ).

        self assert:(package1 isDirty).
        self assert:(package2 isDirty).
        "It is in defaultPackage"
        self shouldnt:(package1 packagedClassNamed:#QWERTZ) isInSmalltalk. 
        self shouldnt:(package2 packagedClassNamed:#QWERTZ) isInSmalltalk. 

        "<tested method with it removed from package2>"
           packageManager removeClassNamed:#QWERTZ fromPackage:package2.
           packageManager moveClassNamed:#QWERTZ fromPackage:package1 toPackage:package2. 
        "</tested method>"

        self assert:(package2 includesPackagedClassNamed:#QWERTZ).
        self shouldnt:(package1 includesPackagedClassNamed:#QWERTZ).
        self shouldnt:(package2 packagedClassNamed:#QWERTZ) isInSmalltalk. 
        self assert:(QWERTZ package == defaultPackage name).

        self assert:(package2 isDirty).
        self assert:(package1 isDirty).

        "<tested method>"
            packageManager moveClassNamed:#QWERTZ fromPackage:package2 toPackage:package1. 
        "</tested method>>"
        self shouldnt:(package2 includesPackagedClassNamed:#QWERTZ).
        self assert:(package1 includesPackagedClassNamed:#QWERTZ).
        self shouldnt:(package1 packagedClassNamed:#QWERTZ) isInSmalltalk. 

        self assert:(package2 isDirty).
        self assert:(package1 isDirty).

        "<tested method>"
            self should:[packageManager moveClassNamed:#QWERTZ fromPackage:package1 toPackage:defaultPackage] raise:PackageError. 
        "</tested method>>"
    ] ensure:[
        packageManager unloadPackageNamed:#'package2'.
        packageManager unloadPackageNamed:#'package1'.
    ].
!

test_moveClass2
    "Move QWERTZ class to a new package named the same as the old package
    but with a 1 on the end. Then move the class back."
    | package1 package2|
    [
        package1 := packageManager packageNamed:#'package1' ifAbsent:[
            packageManager newPackageNamed:#'package1'
        ]. 
        package2 := packageManager packageNamed:#'package2'ifAbsent:[
            packageManager newPackageNamed:#'package2'
        ]. 
        self shouldnt:(package1 isDirty).
        self shouldnt:(package2 isDirty).

        "Make the representation of QWERTZ is in the default package and
        have overriddenPackagedClasses in package1 and package2!!"
        packageManager addClass:QWERTZ toPackage:package1.

        self assert:(QWERTZ package == package1 name).
        self assert:(package1 includesPackagedClassNamed:#QWERTZ).
        self assert:(package1 packagedClassNamed:#QWERTZ) isInSmalltalk.

        self assert:(package1 isDirty).

        "<tested method>"  "here package1 'owns' the class in smalltalk. After the method has been evaluated
          package2 should 'own' the class in smalltalk"
            packageManager moveClassNamed:#QWERTZ fromPackage:package1 toPackage:package2. 
        "</tested method>"

        self assert:(package2 includesPackagedClassNamed:#QWERTZ).
        self shouldnt:(package1 includesPackagedClassNamed:#QWERTZ).

        self assert:(package2 packagedClassNamed:#QWERTZ) isInSmalltalk.    

        self assert:(QWERTZ package == package2 name).

        self assert:(package2 isDirty).
        self assert:(package1 isDirty).


        "<tested method>"
            packageManager addClass:QWERTZ toPackage:defaultPackage.
        "</tested method>"

    ] ensure:[
        packageManager unloadPackage:package2.
        packageManager unloadPackage:package1.
    ].
! !

!PackageManagerTests class methodsFor:'documentation'!

version
    ^ '$Header: /var/local/cvs/stx/libbasic3/packages/PackageManagerTests.st,v 1.4 2006-01-10 09:31:56 cg Exp $'
! !
