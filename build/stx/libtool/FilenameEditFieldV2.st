"{ Encoding: utf8 }"

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

ComboBoxView subclass:#FilenameEditFieldV2
	instanceVariableNames:'directoriesOnly filesOnly directory acceptOnExpand activeMenu
		completitionList'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Tools-File'
!

!FilenameEditFieldV2 class methodsFor:'documentation'!

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
    like a normal editField, but does filename-completion on the last word of
    the contents, when TAB is pressed.
    Filename completion ignores regular files if directoriesOnly is true,
    and ignores directories, if filesOnly is true. Both default to false.

    [author:]
        Claus Gittinger
"
! !

!FilenameEditFieldV2 methodsFor:'accessing'!

acceptOnExpand
    "return the autoAccept on filename expansion flag.
     The default is true, which means that an expand accepts"

    ^ acceptOnExpand
!

acceptOnExpand:aBoolean
    "set/clear autoAccept on filename expansion.
     The default is true, which means that an expand accepts"

    acceptOnExpand := aBoolean
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

    |f n|

    n := someText.
    doAddSeparator ifTrue:[
        directoriesOnly ifFalse:[
            someText notNil ifTrue:[
                f := someText asFilename.
                (f exists and:[f isDirectory]) ifTrue:[
                    (f name endsWith:f separator) ifFalse:[
                        n := f name copyWith:f separator
                    ]
                ]
            ].
        ].
    ].
    super contents:n
!

directoriesOnly
    "set to expand names for directories only"

    directoriesOnly := true.
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
    "set to expand names for files only"

    filesOnly := true.
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

!FilenameEditFieldV2 methodsFor:'initialization'!

initialize
    |myEditor|

    super initialize.

    acceptOnExpand := true.
    directoriesOnly := filesOnly := false.
    directory := Filename currentDirectory.
"/    self menuButton visibilityChannel:(false asValue).
    myEditor := self editor.

    myEditor entryCompletionBlock: [:contents |
        |newString isMultiMatch canonContents|

        isMultiMatch := false.
        canonContents := Filename canonicalize:contents.
        newString := Filename 
                        filenameCompletionFor:canonContents 
                        directory:directory 
                        directoriesOnly:directoriesOnly 
                        filesOnly:filesOnly 
                        ifMultiple:[:dir | ]
                        forMultipleDo:[:dir :matchSet |
                            matchSet notEmpty ifTrue:[
                                myEditor contents:dir name.
                                completitionList := matchSet asList.
                                self action:[: string |  | newFile |
                                    string isString ifTrue:[
                                        newFile := string asFilename.
                                        (newFile exists and:[newFile isDirectory]) ifTrue:[
                                            (newFile name endsWith:newFile separator) ifFalse:[
                                                 myEditor contents:(newFile name copyWith:newFile separator)
                                            ].
                                        ].
                                    ]
                                ].
                                self pullMenu.
                                completitionList := nil.
                                isMultiMatch := true.
                            ].
                        ].
        isMultiMatch ifFalse:[
            newString asFilename pathName = canonContents ifTrue:[
                [self flash] fork.
            ].

            self contents:newString addSeparatorToDirectories:isMultiMatch not.
            myEditor cursorToEndOfLine.
        ]
    ].

    "Modified: 7.9.1995 / 10:20:46 / claus"
    "Modified: 7.9.1997 / 23:51:47 / cg"
!

realize
    "redefined to move the cursor to the end 
     - that's the most interesting part of a filename
    "
    super realize.
    self editor cursorToEndOfLine.

    "Created: 24.7.1997 / 18:21:51 / cg"
! !

!FilenameEditFieldV2 methodsFor:'menu'!

processEvent:anEvent
    "catch keyEvents in pulled menu (see redefined pullMenu-method).
     Return true, if I have eaten the event"

    <resource: #keyboard (#BackSpace )>

    activeMenu notNil ifTrue:[
        anEvent isKeyPressEvent ifTrue:[
            "/ typing into the pulled menu behaves like typing into the field
            "/ followed by a TAB (to reopen the menu)
            (anEvent key isCharacter 
            or:[ anEvent key == #BackSpace]) ifTrue:[
                "/ activeMenu windowGroup removePreEventHook:self.
                field dispatchEvent:anEvent.

                WindowGroup leaveSignal raiseRequest.
                self error:'should not be reached'.
            ].
        ].
    ].
    ^ false.
!

pullMenu
    "pull the menu - triggered from the button"

    |menu origin plug acceptOnLostFocus|
    
    completitionList notNil ifTrue:[
        self list:completitionList
    ] ifFalse:[
        self list:(listHolder value collect:[:el| el path]).
    ].
    menu := self createPullDownMenuForList:list.

    menu backgroundColor:self editor backgroundColor.

    origin := self graphicsDevice translatePoint:(0 @ self height) fromView:self toView:nil.

    "/ need a callBack when the menu becomes visible, to add an eventHook to
    "/ its windowGroup.
    "/ cannot do this here, since the windowgroup is created later and there is no other
    "/ callback or hook from modal views.

    menu addDependent:(plug := Plug new 
                        respondTo:#'update:with:from:' 
                        with:[:a :b :c | menu windowGroup notNil 
                                                ifTrue:[menu windowGroup addPreEventHook:self].
                                         menu removeDependent:plug]).
    activeMenu := menu.
    "prevent editfield from acceptOnLostFocus events so no accept happen while menue is open"
    acceptOnLostFocus := field acceptOnLostFocus. 
    field acceptOnLostFocus:false.
    menu sensor addEventListener:self.
    menu showAt:origin.
    field acceptOnLostFocus:acceptOnLostFocus.
    activeMenu := nil.
    pullDownButton turnOff.
! !

!FilenameEditFieldV2 class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

