"
 COPYRIGHT (c) 2013 by Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libview2' }"

ApplicationModel subclass:#ApplicationWithFileHistory
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Framework'
!

ApplicationWithFileHistory class instanceVariableNames:'fileHistory'

"
 The following class instance variables are inherited by this class:

	ApplicationModel - ClassResources
	Model - 
	Object - 
"
!

!ApplicationWithFileHistory class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2013 by Claus Gittinger
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
    Support code for applications with a persistent history of 
    previously opened files.

    [author:]
        Claus Gittinger

    [see also:]
        StandardSystemView
        WindowGroup DeviceWorkstation
"
! !

!ApplicationWithFileHistory class methodsFor:'file history support'!

addToFileHistory:aFilename
    |fileHistory|

    fileHistory := self fileHistory.
    fileHistory synchronized:[
        fileHistory addFirst:aFilename asFilename.
        fileHistory size > self fileHistorySize ifTrue:[
            fileHistory removeLast.
        ].
        self makeFileHistoryPersistent
    ]

    "Modified: / 09-11-2010 / 16:07:14 / cg"
!

directoryForFileHistory
    ^ Filename homeDirectory / '.smalltalk' / (self nameWithoutPrefix)

    "
     self directoryForFileHistory
    "
!

fetchFileHistoryFromPersistentStore
    |k index value dir fn|

    fileHistory := OrderedSet new.

    OperatingSystem isMSWINDOWSlike ifTrue:[
        k := self registryKeyForFileHistory.
        index := 1.
        [
            value := k valueNamed:(index printString).
            value notNil
        ] whileTrue:[
            fileHistory add:value asFilename.
            index := index + 1
        ].
    ] ifFalse:[
        dir := self directoryForFileHistory.
        dir exists ifTrue:[
            fn := dir / 'history'.
            fn exists ifTrue:[
                fileHistory addAll:(fn contents collect:[:s | s asFilename])
            ]
        ]
    ]
!

fileHistory
    fileHistory isNil ifTrue:[
        self initializeFileHistory
    ].
    ^ fileHistory
!

fileHistorySize
    "defines the number of remembered files in the history"

    ^ 20.
!

initializeFileHistory
    fileHistory := OrderedSet new.
    self fetchFileHistoryFromPersistentStore.
!

makeFileHistoryPersistent
    |k index dir fn|

    OperatingSystem isMSWINDOWSlike ifTrue:[
        k := self registryKeyForFileHistory.
        fileHistory doWithIndex:[:filePath :index |
            k valueNamed:(index printString) put:filePath asFilename pathName.
        ].

        "/ remove the remaining keys
        index := fileHistory size + 1.
        [
            k deleteValueNamed:(index printString)
        ] whileTrue:[
            index := index + 1
        ].
    ] ifFalse:[
        (dir := self directoryForFileHistory) exists ifFalse:[
            dir recursiveMakeDirectory
        ].
        fn := dir / 'history'.
        fn contents:(fileHistory collect:[:fn | fn pathName]).
    ]
!

registryKeyForApplication
    "HKEY_CURRENT_USER\Software\Exept\SmalltalkX\<appname>"

    |k_software k_exept k_stx k_app keyName|

    OperatingSystem isMSWINDOWSlike ifTrue:[
        keyName := self nameWithoutPrefix.

        k_software := Win32OperatingSystem registryEntry key:'HKEY_CURRENT_USER\Software\'.
        (k_exept := k_software subKeyNamed:'Exept') isNil ifTrue:[
            k_exept := k_software createSubKeyNamed:'Exept'
        ].
        (k_stx := k_exept subKeyNamed:'SmalltalkX') isNil ifTrue:[
            k_stx := k_exept createSubKeyNamed:'SmalltalkX'
        ].
        (k_app := k_stx subKeyNamed:keyName) isNil ifTrue:[
            k_app := k_stx createSubKeyNamed:keyName
        ].
        ^ k_app
    ].

    ^ nil

    "
     self registryKeyForApplication 
    "

    "Created: / 11-01-2011 / 19:58:26 / cg"
!

registryKeyForFileHistory
    "HKEY_CURRENT_USER\Software\Exept\SmalltalkX\<appName>\History"

    |k_app k_history|

    OperatingSystem isMSWINDOWSlike ifTrue:[
        k_app := self registryKeyForApplication.
        (k_history := k_app subKeyNamed:'History') isNil ifTrue:[
            k_history := k_app createSubKeyNamed:'History'
        ].
        ^ k_history
    ].

    ^ nil

    "
     self registryKeyForFileHistory
    "
! !

!ApplicationWithFileHistory class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview2/ApplicationWithFileHistory.st,v 1.1 2013-09-05 22:23:55 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libview2/ApplicationWithFileHistory.st,v 1.1 2013-09-05 22:23:55 cg Exp $'
! !

