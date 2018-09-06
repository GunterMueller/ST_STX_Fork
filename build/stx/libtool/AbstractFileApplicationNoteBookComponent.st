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

ApplicationModel subclass:#AbstractFileApplicationNoteBookComponent
	instanceVariableNames:'sameFileIndex item type notifyChannel'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Tools-File'
!

!AbstractFileApplicationNoteBookComponent class methodsFor:'documentation'!

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
    [Author:]
        Christian Penk
"
! !

!AbstractFileApplicationNoteBookComponent class methodsFor:'defaults'!

tabStringFor:aApplicationType
    "the formatString shown in a tab (language translated)"

    ^ nil

    "Modified: / 01-03-2007 / 21:43:10 / cg"
!

tabStringFor:aApplicationType forContents:shownContents

    ^ nil

    "Created: / 01-03-2007 / 21:35:39 / cg"
! !

!AbstractFileApplicationNoteBookComponent class methodsFor:'queries'!

canOpenItem:anItem

"
    example:
    ^ (anItem suffix == 'cc')
"
    ^ false
!

isAbstract
    "Return if this class is an abstract class.
     True is returned here for myself only; false for subclasses.
     Abstract subclasses must redefine this again."

    ^ self == AbstractFileApplicationNoteBookComponent.
!

wantNewApplicationAnyway

    ^ true
! !

!AbstractFileApplicationNoteBookComponent methodsFor:'accessing'!

notify:msg
    self notifyChannel value:msg
!

notifyChannel
    notifyChannel isNil ifTrue:[
        self masterApplication notNil ifTrue:[
            notifyChannel := masterApplication notifyChannel.
        ] ifFalse:[
            notifyChannel := ValueHolder with:''.
        ].
    ].
    ^ notifyChannel
!

sameFileIndex

    ^ sameFileIndex
!

sameFileIndex:something

    sameFileIndex := something.
! !

!AbstractFileApplicationNoteBookComponent methodsFor:'actions'!

changeItem:anItem

    ^ self item:anItem.
!

doClose
    |master|

    "/ tell the NoteBookApplication to close me
    (master := self masterApplication) notNil ifTrue:[
        master closeSubCanvas:self.
        self release.
    ] ifFalse:[
        self closeRequest.
    ].
    ^ true
! !

!AbstractFileApplicationNoteBookComponent methodsFor:'aspects'!

cursorColLabelHolder
    ^ ''
!

cursorLineAndColumnLabelHolder
    ^ ''
!

cursorLineLabelHolder
    ^ ''
!

fileEncodingHolder
    ^ #'iso8859-1'
!

lockFileEncodingHolder
    ^ nil 
!

modeLabelHolder
    ^ ''
!

modeLabelMenu
    ^ nil

    "Created: / 11-09-2006 / 12:32:37 / cg"
! !

!AbstractFileApplicationNoteBookComponent methodsFor:'drag & drop support'!

doStartDrag:aDropSource in:aView
    "common code, used in subclasses"

    AbstractFileBrowser doStartDrag:aDropSource in:aView
"/ same code    
"/    |hdl|
"/
"/    hdl := DragAndDropManager new.
"/
"/    hdl disabledCursor:AbstractFileBrowser disabledCursorIcon.
"/    hdl enabledCursor:AbstractFileBrowser enabledCursorIcon.
"/    hdl alienCursor:nil.
"/
"/    hdl startDragFrom:aView dropSource:aDropSource offset:#topLeft
! !

!AbstractFileApplicationNoteBookComponent methodsFor:'queries'!

additionalInfo
    ^ ''

    "Created: / 24-10-2006 / 12:25:51 / cg"
!

closeButtonShown
    ^ false.

    "Created: / 27-01-2012 / 15:00:22 / cg"
!

cvsMenusAreShown
    ^ ConfigurableFeatures includesFeature: #CVSSupportEnabled
!

fileName
    item notNil ifTrue:[
        ^ item fileName.
    ].
    ^ nil
!

getDirWithoutFileName:aFileName

    | dir |
    aFileName isNil ifTrue:[
        ^ aFileName.    
    ].
    dir := aFileName asFilename.
    dir isDirectory ifFalse:[
        dir := dir directory.
    ].
    ^ dir.
!

getTabIcon
    "the item shown in a tab"

    ^ nil
!

getTabString
    "get the tab string from the application"

    |formatString valueString stream|

    stream := CharacterWriteStream on:''.

    valueString := self getTabValueString.
    valueString isNil ifTrue:[
        valueString := resources string:'<unnamed>'
    ].
    formatString := self class tabStringFor:type.
    formatString isNil ifTrue:[
        "/ default: take the class name
        formatString := self className.
    ].
    stream nextPutAll:(resources string:formatString with:valueString).

    ^ stream contents.

    "Modified: / 01-03-2007 / 21:45:02 / cg"
!

getTabStringEnd
    " get the tab string from the application list on the class side "

    | stream|

    self item notNil ifTrue:[
        stream := CharacterWriteStream new.
        self type = #directoryDescription ifTrue:[
            stream nextPutAll:self fileName directory baseName.
            stream space.
            stream nextPut:$[.
            stream nextPutAll:self fileName baseName.
            stream nextPut:$].
        ] ifFalse:[
            stream nextPutAll:self fileName baseName.
            stream space.
            self sameFileIndex notNil ifTrue:[
                stream nextPutAll:self sameFileIndex asString.
            ].
        ].
        ^ stream contents.
    ].
    ^ nil
!

getTabValueString
    "the item shown in a tab (not language translated)"

    |stream fn baseName|

    self item isNil ifTrue:[^ nil].

    stream := CharacterWriteStream on:''.

    fn := self fileName.
    baseName := fn baseName.
    self type = #directoryDescription ifTrue:[
        stream nextPutAll:(fn directory baseName).
        stream space.
        stream nextPut:$[.
        stream nextPutAll:baseName.
        stream nextPut:$].
    ] ifFalse:[
        stream nextPutAll:baseName.
        stream space.
        self sameFileIndex notNil ifTrue:[
            stream nextPutAll:self sameFileIndex asString.
        ].
    ].

    ^ stream contents

    "Created: / 01-03-2007 / 21:40:03 / cg"
!

isEmbeddedApplication

     ^ self masterApplication notNil
!

isModified

    ^ false
!

isTextEditor

    ^ false
!

item

    ^ item
!

item:anItem

    item := anItem.
    ^ true
!

presentation

    ^ nil
!

type

    ^ type
!

type:aType

    type := aType
!

wantChangeAnyWay

    ^ (self type == #directoryDescription)
! !

!AbstractFileApplicationNoteBookComponent methodsFor:'resources'!

resources
    masterApplication notNil ifTrue:[
        ^ masterApplication resources
    ].
    ^ super resources
! !

!AbstractFileApplicationNoteBookComponent class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

