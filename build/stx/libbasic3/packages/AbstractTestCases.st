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

TestCase subclass:#AbstractTestCases
	instanceVariableNames:''
	classVariableNames:'ClearUpFiles'
	poolDictionaries:''
	category:'Package-TestCases'
!

Notification subclass:#PackageTestCaseNotification
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:AbstractTestCases
!

!AbstractTestCases class methodsFor:'documentation'!

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
    "Created: / 30.1.2003 / 10:54:54 / james"
! !

!AbstractTestCases methodsFor:'factory'!

packageTestCaseNotification
    ^ PackageTestCaseNotification
! !

!AbstractTestCases methodsFor:'helpers'!

aDolphinTestFilePac
    ^ '~/AvatarChat.pac' asFilename.
!

assertSmalltalkIncludesAllClassNames:aCollectionOfSymbols 
    aCollectionOfSymbols do:[:aSymbol |
        self shouldnt:((Smalltalk at:aSymbol ifAbsent:[nil]) == nil).
    ].
!

assertSmalltalkIncludesAllLooseMethods:aCollectionOfLooseMethods

    aCollectionOfLooseMethods do:[:aPackagedMethod |   | class |
        class := (Smalltalk at:aPackagedMethod mclass name).
        self assert:(class methodDictionary keys includes:aPackagedMethod name).
    ].
!

createMethodFor:aClass source:aString
    aClass
        compile:aString
        classified:'aDummyClassification'
        notifying:nil.
!

createTestCaseDirectory
    "create the testcase directory if i"
    | testCaseDirectory |
    (testCaseDirectory := self testCaseDirectory) exists ifFalse:[
        testCaseDirectory makeDirectory.
    ].
!

createTestCaseFilenameFor:aFilenameOrString 
    ^ self testCaseDirectory filenameFor:aFilenameOrString asFilename
!

initializePackageManager
    PackageManager initialize.
!

packageManager
    ^ PackageManager smalltalkPackageManager
!

removeClassNamed:aSymbol 
    (Smalltalk at:aSymbol) ifNotNil:[
        ^ (Smalltalk at:aSymbol) removeFromSystem.
    ]
!

shouldntSmalltalkIncludesAllClassNames:aCollectionOfSymbols 
    aCollectionOfSymbols do:[:aSymbol |
        self assert:((Smalltalk at:aSymbol ifAbsent:[nil]) == nil).
    ].

!

shouldntSmalltalkIncludesAllLooseMethods:aCollectionOfLooseMethods

    aCollectionOfLooseMethods do:[:aMethod |  | class|
        class := (Smalltalk classNamed:aMethod className).
        "if class is nil then the test has also passed"
        class ifNotNil:[
            self shouldnt:(class methodDictionary keys includes:aMethod name).
        ].

    ].
!

testCaseDirectory
    ^ (Filename named:'~/work/stx/testCases/')
! !

!AbstractTestCases methodsFor:'initialize / release'!

setUp
    "common setup - invoked before testing"
    self initialize.
    super setUp
!

tearDown
    "common cleanup - invoked after testing"

    super tearDown
! !

!AbstractTestCases methodsFor:'instance creation'!

createClassNamed:aClassName 
    self createClassNamed:aClassName inheritsFrom:#Object
!

createClassNamed:aClassName inheritsFrom:anInheritingClassName
    ^ (Smalltalk at:anInheritingClassName) 
        subclass:aClassName
        instanceVariableNames:''
        classVariableNames:''
        poolDictionaries:''
        category:'AAAAA'
        classInstanceVariableNames:''
! !

!AbstractTestCases methodsFor:'queries'!

clearUpFiles
    ClearUpFiles ifNil:[
        ClearUpFiles := false.
    ].

    ^ ClearUpFiles
! !

!AbstractTestCases class methodsFor:'documentation'!

version
    ^ '$Header: /var/local/cvs/stx/libbasic3/packages/AbstractTestCases.st,v 1.3 2006-01-10 09:29:37 cg Exp $'
! !
