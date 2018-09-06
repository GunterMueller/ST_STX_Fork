"
 COPYRIGHT (c) Claus Gittinger / eXept Software AG
 COPYRIGHT (c) 2016 Jan Vrany
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

TestCase subclass:#Win32OperatingSystemTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-RuntimeSystem'
!

!Win32OperatingSystemTest class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) Claus Gittinger / eXept Software AG
 COPYRIGHT (c) 2016 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!Win32OperatingSystemTest methodsFor:'release'!

setUp
    self skipIf: OperatingSystem isMSWINDOWSlike not description: 'Windows specific tests'.
    super setUp

    "Created: / 28-12-2016 / 22:12:14 / jv"
! !

!Win32OperatingSystemTest methodsFor:'tests'!

testMutex
    |handle alreadyExists lastErrorCode handleAndLastErrorCode|

    handleAndLastErrorCode := Win32OperatingSystem createMutexNamed: UUID new printString.
    handle := handleAndLastErrorCode first.
    handle isNil ifTrue:[^ self].
    lastErrorCode := handleAndLastErrorCode second.
    self assert: lastErrorCode == 0.
    alreadyExists := (lastErrorCode == 5 "ERROR_ACCESS_DENIED" or:[ lastErrorCode == 183 "ERROR_ALREADY_EXISTS"]).
    alreadyExists ifTrue:[
        Transcript showCR: 'Mutex already exists!!'.
        ^ self.
    ].
    [
        Transcript showCR: 'Mutex created!!'.
        Win32OperatingSystem waitForSingleObject: handle.
        Delay waitForSeconds:0.5. "/ self halt.
        Win32OperatingSystem releaseMutex: handle.
    ] ensure:[
        Win32OperatingSystem primCloseHandle: handle.
        Transcript showCR: 'Mutex closed!!'.
    ].


    "
     self new testMutex
    "

    "Modified: / 28-06-2018 / 09:14:35 / jv"
!

testRegistry
    |k hasContentType|

    k := OperatingSystem registryEntry key:'HKEY_CLASSES_ROOT\MIME\Database\'.
    self assert:(k notNil).

    hasContentType := false.
    k subKeyNamesAndClassesDo:[:nm :clsNm |
        "/ Transcript showCR:nm.
        nm = 'Content Type' ifTrue:[hasContentType := true].
    ].
    self assert:hasContentType.

    "/ k subKeysDo:[:k | Transcript showCR:k].

    "
     self new testRegistry
    "

    "Modified: / 28-12-2016 / 22:13:43 / jv"
!

testRegistry02a
    | root key |

    root :=OperatingSystem registryEntry key:'HKEY_CURRENT_USER'.
    root deleteSubKeyNamed: testSelector.

    self assert:(root subKeyNamed: testSelector) isNil.
    self deny: (root deleteSubKeyNamed: testSelector).

    key := root createSubKeyNamed:testSelector.
    self assert: key notNil.
    self assert:(root subKeyNamed: testSelector) notNil.

    self assert: (root deleteSubKeyNamed:testSelector).
    self assert:(root subKeyNamed: testSelector) isNil.
    self deny: (root deleteSubKeyNamed: testSelector).

    "Created: / 28-12-2016 / 23:14:15 / jv"
    "Modified: / 05-01-2017 / 21:45:20 / jv"
! !

!Win32OperatingSystemTest class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

