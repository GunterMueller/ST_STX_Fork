"
 COPYRIGHT (c) 2007 by eXept Software AG
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

SimpleView subclass:#FilenameWidgetWithHistory
	instanceVariableNames:'fileNameEntryField browseButton history directoriesOnly filesOnly
		dialogTitle initialDirectoryHolder baseDirectory'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Interactors'
!

!FilenameWidgetWithHistory class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2007 by eXept Software AG
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
    A Filename InputField with history-list and a browse-button, which opens a file dialog.

    [author:]
        Claus Gittinger

    [see also:]
        ComboBoxView
        FilenameEditField
        FilenameComboBoxView
"
!

examples
"
                                                                        [exBegin]
     |top b|

     top := StandardSystemView new.
     top extent:(300 @ 200).

     b := FilenameWidgetWithHistory in:top.
     b origin:(0.0 @ 0.0) corner:(1.0 @ 0.0).
     b bottomInset:(b preferredExtent y negated).

     top open.
                                                                        [exEnd]
"
! !

!FilenameWidgetWithHistory methodsFor:'accessing'!

acceptOnExpand:aBoolean
    fileNameEntryField acceptOnExpand:aBoolean

    "Created: / 20-10-2010 / 17:49:54 / cg"
!

baseDirectory
    ^ baseDirectory
!

baseDirectory:something
    baseDirectory := something.
!

contents
    ^ fileNameEntryField contents

    "Created: / 20-10-2010 / 17:51:07 / cg"
!

dialogTitle:something
    "set the dialogs title"

    dialogTitle := something.
!

directoriesOnly:aBoolean
    "if true, directories are selectable only.
     If both filesOnly and directoriesOnly are false, which is the default, 
     anything is selectable."

    directoriesOnly := aBoolean.
    directoriesOnly ifTrue:[
        filesOnly := false.
    ].
    fileNameEntryField notNil ifTrue:[
        fileNameEntryField directoriesOnly:aBoolean
    ].
!

filesOnly:aBoolean
    "if true, files are selectable only.
     If both filesOnly and directoriesOnly are false, which is the default, 
     anything is selectable."

    filesOnly := aBoolean.
    filesOnly ifTrue:[
        directoriesOnly := false.
    ].
    fileNameEntryField notNil ifTrue:[
        fileNameEntryField filesOnly:aBoolean
    ].
!

historyList
    history isNil ifTrue:[
        history := ValueHolder with:nil
    ].
    ^ history
!

historyList:aCollection
    "set the history - useful when two or more such fields shall share a common history"

    self historyList value: aCollection
!

initialDirectoryHolder
    "can be used to force the file-dialog into some initial directory"

    ^ initialDirectoryHolder
!

model
    ^ fileNameEntryField model
!

model:aFilenameHolder
    fileNameEntryField model:aFilenameHolder.
!

selectAllInitially
    fileNameEntryField selectAllInitially

    "Created: / 20-10-2010 / 17:50:23 / cg"
! !

!FilenameWidgetWithHistory methodsFor:'accessing-channels'!

acceptChannel:aValueHolder
    fileNameEntryField acceptChannel:aValueHolder.
!

backgroundChannel
    ^ fileNameEntryField backgroundChannel

    "Created: / 17-11-2016 / 21:34:10 / cg"
!

backgroundChannel:aValueHolder
    fileNameEntryField backgroundChannel:aValueHolder.

    "Created: / 17-11-2016 / 21:32:04 / cg"
!

enableChannel:aValueHolder
    fileNameEntryField enableChannel:aValueHolder.
    browseButton enableChannel:aValueHolder.
!

foregroundChannel
    ^ fileNameEntryField foregroundChannel

    "Created: / 17-11-2016 / 21:34:17 / cg"
!

foregroundChannel:aValueHolder
    fileNameEntryField foregroundChannel:aValueHolder.

    "Created: / 17-11-2016 / 21:32:11 / cg"
!

modifiedChannel:aValueHolder
    fileNameEntryField modifiedChannel:aValueHolder.

    "Created: / 05-10-2011 / 14:59:48 / cg"
! !

!FilenameWidgetWithHistory methodsFor:'accessing-editField attributes'!

acceptIfUnchanged:aBoolean
    fileNameEntryField acceptIfUnchanged:aBoolean
!

acceptOnLeave:aBoolean
    fileNameEntryField acceptOnLeave:aBoolean
!

acceptOnLostFocus:aBoolean
    fileNameEntryField acceptOnLostFocus:aBoolean
!

acceptOnPointerLeave:aBoolean
    fileNameEntryField acceptOnPointerLeave:aBoolean
!

acceptOnReturn:aBoolean
    fileNameEntryField acceptOnReturn:aBoolean
!

acceptOnTab:aBoolean
    fileNameEntryField acceptOnTab:aBoolean
!

contents:aString
    fileNameEntryField contents:aString
!

immediateAccept:aBoolean
    fileNameEntryField immediateAccept:aBoolean
!

maxChars:aBoolean
    fileNameEntryField maxChars:aBoolean
!

readOnly:aBoolean
    fileNameEntryField readOnly:aBoolean
! !

!FilenameWidgetWithHistory methodsFor:'initialization'!

initialize
    super initialize.

    directoriesOnly := filesOnly := false.
    initialDirectoryHolder := ValueHolder with:nil.

    self initializeFilenameField.
    fileNameEntryField layout:(LayoutFrame
                                  leftFraction:0 offset:0 
                                  rightFraction:1 offset:-22 
                                  topFraction:0 offset:0 
                                  bottomFraction:1 offset:0).

    self initializeBrowseButton.
    browseButton layout:(LayoutFrame
                                  leftFraction:1 offset:-22 
                                  rightFraction:1 offset:-2 
                                  topFraction:0 offset:0 
                                  bottomFraction:1 offset:0).

    "Modified: / 02-11-2010 / 19:50:33 / cg"
!

initializeBrowseButton
    browseButton := Button in:self.
    browseButton label:'...'.
    browseButton action:[ self browseForFileOrDirectory ].

    "Created: / 02-11-2010 / 19:50:21 / cg"
!

initializeFilenameField
    fileNameEntryField := FilenameComboBoxView in:self.
    fileNameEntryField listHolder:(self historyList).

    "Created: / 19-10-2010 / 16:20:09 / cg"
! !

!FilenameWidgetWithHistory methodsFor:'queries'!

preferredExtent
    "/ If I have an explicit preferredExtent..
    explicitExtent notNil ifTrue:[
        ^ explicitExtent
    ].
    "/ If I have a cached preferredExtent value..
    preferredExtent notNil ifTrue:[
        ^ preferredExtent
    ].

    preferredExtent := (fileNameEntryField preferredWidth + browseButton preferredWidth)
                       @
                       (fileNameEntryField preferredHeight "max: browseButton preferredExtent y").
    ^ preferredExtent
! !

!FilenameWidgetWithHistory methodsFor:'user actions'!

browseForDestinationDirectory
    <resource: #obsolete>
    self obsoleteMethodWarning.
    self browseForFileOrDirectory
!

browseForFileOrDirectory
    |path |

    Dialog modifyingBoxWith:[:box |
        |holder|

        holder := box perform:#browsemenuItemVisibleHolder ifNotUnderstood:[nil].
        holder notNil ifTrue:[
            holder value:true
        ]
    ] do:[
        |title defaultPath defaultDir|

        title := dialogTitle notNil 
                    ifTrue:[ dialogTitle ]
                    ifFalse:[
                        resources string:(
                            directoriesOnly 
                                ifTrue:[ 'Select Directory' ]
                                ifFalse:[ 
                                    filesOnly
                                        ifTrue:[ 'Select File' ]
                                        ifFalse:[ 'Select Path' ]])].

        defaultPath := (self model notNil)
                            ifTrue:[ self model value ]
                            ifFalse:[ fileNameEntryField contents ].

        defaultPath notEmptyOrNil ifTrue:[
            defaultPath asFilename isAbsolute ifFalse:[
                baseDirectory notNil ifTrue:[
                    defaultPath := baseDirectory asFilename construct:defaultPath.
                ].
            ].
            defaultDir := defaultPath asFilename directory.
        ] ifFalse:[     
            defaultDir := initialDirectoryHolder value.
        ].
        path := Dialog 
                    requestFileName:title
                    default:defaultPath
                    fromDirectory:defaultDir.
    ].
    path isEmptyOrNil ifTrue:[ ^ self ].
    path := path asFilename.

    baseDirectory notNil ifTrue:[
        (path pathName startsWith:baseDirectory asFilename pathName) ifTrue:[
            path := (path pathName copyFrom:(baseDirectory asFilename pathName size + 2)) asFilename.
        ].
    ].        

    initialDirectoryHolder value:path directory.
    path := path pathName.

    "/ lastDirectoryHolder value:path directory.
    self model notNil ifTrue:[
        self model value:path.
    ].
    fileNameEntryField contents:path.

    "Modified: / 08-02-2011 / 09:24:51 / cg"
! !

!FilenameWidgetWithHistory class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

