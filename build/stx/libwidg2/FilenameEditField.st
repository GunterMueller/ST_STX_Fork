"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 1994 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libwidg2' }"

"{ NameSpace: Smalltalk }"

EditField subclass:#FilenameEditField
	instanceVariableNames:'directoriesOnly filesOnly directory acceptOnExpand'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Text'
!

!FilenameEditField class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1994 by Claus Gittinger
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
    like a normal editField, but does filename-completion on the last word of
    the contents, when TAB is pressed.
    Filename completion ignores regular files if directoriesOnly is true,
    and ignores directories, if filesOnly is true. Both default to false.

    [author:]
        Claus Gittinger
"
!

examples
"
    |t f b v|

    v := ValueHolder with:'c:\'.

    t := StandardSystemView new.
    f := FilenameEditField in:t.
    f origin:10@10 corner:1.0@30.
    f model:v.

    b := Button in:t.
    b label:'Check'.
    b action:[ 
                Transcript show:'field: '; showCR: f contents. 
                Transcript show:'model: '; showCR: v value. 
             ].
    b origin:10@40.
    t open.
    
"
! !

!FilenameEditField methodsFor:'accessing'!

acceptOnExpand
    "return the autoAccept on filename expansion (pressing tab key) flag.
     The default is true, which means that an expand accepts"

    ^ acceptOnExpand

    "Modified: / 20-10-2010 / 17:49:23 / cg"
!

acceptOnExpand:aBoolean
    "set/clear autoAccept on filename expansion (pressing tab key).
     The default is true, which means that an expand accepts"

    acceptOnExpand := aBoolean

    "Modified: / 20-10-2010 / 17:49:11 / cg"
!

contents:someText
    "redefined to add a trailing file-separator if the displayed
     filename is a directory"

    ^ self
        contents:someText 
        addSeparatorToDirectories:true
!

contents:someText addSeparatorToDirectories:doAddSeparator
    "optionally add a trailing file-separator if the displayed
     filename is a directory."

    |newText f nm|

    newText := someText.
    doAddSeparator ifTrue:[
        directoriesOnly ifFalse:[
            someText notEmptyOrNil ifTrue:[
                f := someText asFilename.
                (f exists and:[f "asAbsoluteFilename" isDirectory]) ifTrue:[
                    nm := f name.
                    (nm endsWith:f separator) ifFalse:[
                        newText := nm copyWith:f separator
                    ]
                ]
            ].
        ].
    ].
    super contents:newText.
    self cursorToEndOfLine.

    "Modified: / 08-11-2007 / 11:54:05 / cg"
!

directoriesOnly
    <resource: #obsolete>
    "set to expand names for directories only"

    self obsoleteMethodWarning.
    directoriesOnly := true.
!

directoriesOnly:aBoolean
    "control if only directories can be choosen"

    directoriesOnly := aBoolean.
    directoriesOnly ifTrue:[
        filesOnly := false.
    ].
!

directory
    ^ directory

    "Modified: 7.9.1995 / 10:12:40 / claus"
!

directory:aFilename
    aFilename isNil ifTrue:[
        directory := Filename currentDirectory
    ] ifFalse:[
        directory := aFilename asFilename
    ]
    "Modified: 7.9.1995 / 10:12:55 / claus"
!

filesOnly
    <resource: #obsolete>
    "set to expand names for files only"

    self obsoleteMethodWarning.
    filesOnly := true.
!

filesOnly:aBoolean
    "control if only files can be choosen"

    filesOnly := aBoolean.
    filesOnly ifTrue:[
        directoriesOnly := false.
    ].
!

initialText:aString selected:aBoolean
    "redefined to move the cursor to the end 
     - that's the most interesting part of a filename
    "

    super initialText:aString selected:aBoolean.
    self cursorToEndOfLine.
!

showsDirectoriesOnly
    "return if expanding names for directories only"

    ^ directoriesOnly

    "Modified: 6.9.1995 / 20:35:30 / claus"
!

showsFilesOnly
    "return if expanding names for files only"

    ^ filesOnly

    "Modified: 6.9.1995 / 20:34:57 / claus"
! !

!FilenameEditField methodsFor:'actions'!

doFilenameCompletionFor:aString
    |newString isMultiMatch canonContents|

    isMultiMatch := false.
    canonContents := Filename canonicalize:aString.

    newString := Filename 
                    filenameCompletionFor:canonContents 
                    directory:directory 
                    directoriesOnly:directoriesOnly 
                    filesOnly:filesOnly 
                    ifMultiple:[:dir |
"/                                dir asFilename isDirectory ifTrue:[
"/                                    self changed:#directory with:dir.
"/                                ].
                        isMultiMatch := true.
                        self flash.
                    ].

    "/ chose the one, if there is only one
    newString asFilename pathName = canonContents ifTrue:[
        directory := canonContents asFilename.
        (directory exists 
         and:[directory isDirectory 
         and:[directory directoryContents size = 1 ]]) ifTrue:[
            newString := (directory construct:(directory directoryContents first)) pathName.        
        ] ifFalse:[
            self flash.
        ]
    ].

    self contents:newString addSeparatorToDirectories:isMultiMatch not.

    "Modified (comment): / 23-01-2012 / 18:24:34 / cg"
! !

!FilenameEditField methodsFor:'event handling'!

keyPress:key x:x y:y
    "handle tab for filename completion.
     Bug: it completes the last word; it should complete the
          word before the cursor."

    <resource: #keyboard ( #Tab #FilenameCompletion ) >

    |oldContents newContents|

    enabled ifTrue:[
        ((key == entryCompletionCharacter) or:[key == #FilenameCompletion]) ifTrue:[
            oldContents := self contents.
            oldContents isNil ifTrue:[
                oldContents := ''
            ] ifFalse:[
                oldContents := oldContents asString
            ].

            self entryCompletionBlock value:oldContents.

            newContents := self contents.
            newContents isNil ifTrue:[
                newContents := ''
            ] ifFalse:[
                newContents := newContents asString
            ].
            newContents ~= oldContents ifTrue:[
                self textChanged.
                acceptOnExpand ifTrue:[
                    self accept 
                ]
            ].
            ^ self
        ]
    ].
    super keyPress:key x:x y:y.

    "Modified: / 06-03-2007 / 21:40:52 / cg"
! !

!FilenameEditField methodsFor:'initialization'!

initialize
    super initialize.

    acceptOnExpand := true.
    directoriesOnly := filesOnly := false.
    directory := Filename currentDirectory.

    self 
        entryCompletionBlock:[:contents |
            self doFilenameCompletionFor:contents.
        ].

    "Modified: 7.9.1995 / 10:20:46 / claus"
    "Modified: 7.9.1997 / 23:51:47 / cg"
!

mapped
    "redefined to move the cursor to the end 
     - that's the most interesting part of a filename
    "
    super mapped.
"/    self cursorToEndOfLine.
    self makeCursorVisible.
! !

!FilenameEditField class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

