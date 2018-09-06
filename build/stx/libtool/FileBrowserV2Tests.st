"
 COPYRIGHT (c) 2002 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#FileBrowserV2Tests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Tools-File'
!

!FileBrowserV2Tests class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2002 by eXept Software AG
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
        Christian Penk (penk@bierfix)

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!FileBrowserV2Tests methodsFor:'initialize / release'!

setUp
    "common setup - invoked before testing"

    super setUp
!

tearDown
    "common cleanup - invoked after testing"

    super tearDown
! !

!FileBrowserV2Tests methodsFor:'tests'!

createBigDirectory

    | testDir |

    testDir := Filename homeDirectory construct:'Test'.
    (Filename homeDirectory construct:'Test') makeDirectory.
    1 to:5 do:[: id1|
        1 to:50 do:[: id2|
            1 to:50 do:[: id3|
                (testDir construct:('file', id1 asString, '.', id2 asString,'.', id3 asString)) writeStream
            ]
        ].
    ]
"
FileBrowserV2Tests new createBigDirectory
Dialog requestFileName:'test' default:nil pattern:'*' fromDirectory:'/home/penk/Test'
"
!

removeBigDirectory

    (Filename homeDirectory construct:'Test') recursiveRemove.

"
FileBrowserV2Tests new removeBigDirectory
"
!

testBigDirectory
!

testDirectoryHistory
    "Just a demonstration testCase.
     Double click on the TestCase class or open a TestRunner to see me checking...
     - please add more methods like this..."

    |history|

    history := AbstractFileBrowser directoryHistoryClass new.
    history resetForwardBackward.
    self shouldnt: (history canBackward).
    history addToHistory:'1'.
    self shouldnt:(history canBackward).
    self shouldnt:(history canForward).
    history addToHistory:'2'.
    self should:(history canBackward).
    history addToHistory:'3'.
    self should:(history canBackward).
    self shouldnt: (history canForward).
    self should: ((history goBackward) = '2').
    self should: ((history goBackward) = '1').
    self should: (history canForward).
    self should: ((history goForward) = '2').
    self should: (history canForward).

    

    "
     self run:#testDirectoryHistory
    "
!

testDosFiles

    | file stream|

    file := Filename currentDirectory asAbsoluteFilename construct:'foobar~1'.
    stream := file writeStream.
    self should:file exists.
    stream close.
    file remove.

"
self new testDosFiles   
"
!

testFileItem
    "Just a demonstration testCase.
     Double click on the TestCase class or open a TestRunner to see me checking...
     - please add more methods like this..."

    | file item|

    file := Filename homeDirectory construct:'work/stx/doc/online/english/index.html'.
    file exists ifTrue:[
        item := DirectoryContentsBrowser itemClass fileName:file.
        self should:(item mimeType = 'text/html').
    ].

    "
     self run:#testFileItem
    "
!

testHardLink
    "Just a demonstration testCase.
     Double click on the TestCase class or open a TestRunner to see me checking...
     - please add more methods like this..."

    |browser|

    browser := FileBrowserV2 new.
    
    self should: ( browser isKindOf:AbstractFileBrowser ).
    self should: ( browser respondsTo:#newHardLink ).
    
"/    self should: [ o at:0 ] raise:Error.

    "
     self run:#testHardLink
    "
! !

!FileBrowserV2Tests class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libtool/FileBrowserV2Tests.st,v 1.9 2003/10/02 12:22:11 penk Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

