"
 COPYRIGHT (c) 1997 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libview2' }"

"{ NameSpace: Smalltalk }"

Object subclass:#DropObject
	instanceVariableNames:'theObject displayObject'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-DragAndDrop'
!

DropObject class instanceVariableNames:'DisplayObject'

"
 No other class instance variables are inherited by this class.
"
!

DropObject subclass:#Class
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:DropObject
!

DropObject subclass:#Color
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:DropObject
!

DropObject subclass:#File
	instanceVariableNames:'info isHtmlFile isImageFile isPrintable'
	classVariableNames:''
	poolDictionaries:''
	privateIn:DropObject
!

DropObject::File subclass:#FileInArchive
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:DropObject
!

DropObject subclass:#Image
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:DropObject
!

DropObject subclass:#Method
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:DropObject
!

DropObject subclass:#Project
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:DropObject
!

DropObject subclass:#Text
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:DropObject
!

!DropObject class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997 by eXept Software AG
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
    instances of myself and subclasses wrap objects which are being
    dragged (and dropped).
    Any object can be dragged, but for some often encountered types,
    specialized subclasses are provided, which react to certain queries.

    [see also:]
        DragAndDropManager

    [author:]
        Claus Atzkern
"
! !

!DropObject class methodsFor:'instance creation'!

dropObjectClassFor:someThing
    "given something to drag&drop, return an appropriate
     dropObject class for it."
    
    "/ no, no visitor pattern here - I though about it and I think it sucks here.
    "/ reason: its al local and known here, which DropObjects I am willing to support.
    "/ addint double dispatch (acceptDropSourceVisitor:) adds a dependency to 6 other classes,
    "/ and worse: if I ever change my mind to allow for another one, I would have to change
    "/ that class as well (to add its (accept...) implementaion.
    "/ So, the typeSwitch below is OK.

    someThing isColor       ifTrue:[^ DropObject::Color].
    someThing isImageOrForm ifTrue:[^ DropObject::Image].
    someThing isFilename    ifTrue:[^ DropObject::File].
    someThing isString      ifTrue:[^ DropObject::Text].
    someThing isBehavior    ifTrue:[^ DropObject::Class].
    someThing isMethod      ifTrue:[^ DropObject::Method].
    ^ self
!

new:someThing
    "create an instance on something
    "
    |cls|

    cls := self dropObjectClassFor:someThing.
    ^ self newInstanceOf:cls for:someThing

    "Modified: 19.4.1997 / 17:19:55 / cg"
!

newClass:aClass
    "create an instance for a class (dragging a class from a browser)"

    ^ self newInstanceOf:DropObject::Class for:aClass
!

newColor:aColor
    "create an instance for a color (dragging a color from a bitmap editor)"

    ^ self newInstanceOf:DropObject::Color for:aColor

    "Modified: 19.4.1997 / 17:20:17 / cg"
!

newFile:aFilename
    "create an instance for a file or directory (dragging a file in a fileBrowser)"

    ^ self newInstanceOf:DropObject::File for:aFilename
!

newFileInArchive:aFilename
    "create an instance for a file or directory contained inside an archive
     (dragging a file from an archive shown in a fileBrowser)"

    ^ self newInstanceOf:DropObject::FileInArchive for:aFilename
!

newImage:anImageOrForm
    "create an instance for an image"

    ^ self newInstanceOf:DropObject::Image for:anImageOrForm

    "Modified: 19.4.1997 / 17:20:37 / cg"
!

newInstanceOf:aClass for:someThing
    "create an instance on something
    "
    ^ aClass new theObject:someThing

    "Modified: 19.4.1997 / 17:19:55 / cg"
!

newMethod:aMethod
    "create an instance for a method (dragging a method in a browser)"

    ^ self newInstanceOf:DropObject::Method for:aMethod
!

newProject:aPackageSymbol
    "create an instance for a package (dragging a package from a browser)"

    ^ self newInstanceOf:DropObject::Project for:aPackageSymbol
!

newText:aTextOrString
    "create an instance for some text (dragging some text from an editor)"

    ^ self newInstanceOf:DropObject::Text for:aTextOrString

    "Modified: 19.4.1997 / 17:20:46 / cg"
! !

!DropObject class methodsFor:'defaults'!

displayObject
    "return some object which is shown while dragging;
     here an image based upon my displayObjectName is returned.
     Either this method or #displayObjectName is usually redefined
     in subclasses"

    DisplayObject notNil ifTrue:[
        ^ DisplayObject
    ].
    DisplayObject := Smalltalk imageFromFileNamed:(self displayObjectName) forClass:self.
    ^ DisplayObject

    "Modified: 19.4.1997 / 13:04:05 / cg"
!

displayObject:aDisplayObject
    "set the object which is shown while dragging;
     this object must understand #displayOn:x:y: (i.e. the displayObject
     protocol). The object is kept per class for ALL future drag operations.
     Useful to change the default images in subclasses."

    DisplayObject := aDisplayObject

    "Modified: 19.4.1997 / 15:42:10 / cg"
!

displayObjectName
    "return the name of a bitmap image file, which is used 
     during a drag.
     Here, a dummy file is returned."

    ^ 'bitmaps/xpmBitmaps/plain_pixmaps/balloon3.xpm'

    "Modified: 19.4.1997 / 13:54:13 / cg"
! !

!DropObject methodsFor:'accessing'!

displayObject
    "return my graphical representation - here a default is returned"

    ^ displayObject notNil
        ifTrue:[ displayObject ]
        ifFalse:[ self class displayObject ]

    "Modified: / 18-07-2011 / 09:39:12 / cg"
!

displayObject:anObject
    "set my graphical representation"

    displayObject := anObject

!

theObject
    "return the real object represented by the receiver"

    ^ theObject

    "Modified: 19.4.1997 / 12:53:01 / cg"
!

theObject:something
    "set the real object represented by the receiver"

    theObject := something.

    "Modified: 19.4.1997 / 12:53:10 / cg"
! !

!DropObject methodsFor:'testing'!

isClassObject
    "return true, if the dropObject represents some class"

    ^ false
!

isColorObject
    "return true, if the dropObject represents a color"

    ^ false

    "Modified: 19.4.1997 / 12:52:36 / cg"
!

isFileInArchive
    ^ false
!

isFileObject
    "return true, if the dropObject represents some file or directory"

    ^ false

    "Modified: 19.4.1997 / 12:52:29 / cg"
!

isImageObject
    "return true, if the dropObject represents some image"

    ^ false

    "Modified: 19.4.1997 / 12:52:22 / cg"
!

isMethodObject
    "return true, if the dropObject represents some method"

    ^ false
!

isProjectObject
    "return true, if the dropObject represents some project"

    ^ false
!

isTextObject
    "return true, if the dropObject represents some text"

    ^ false

    "Modified: 19.4.1997 / 12:52:17 / cg"
! !

!DropObject::Class class methodsFor:'documentation'!

documentation
"
    I represent a class being dragged (from a browser's classList)
"
! !

!DropObject::Class methodsFor:'testing'!

isClassObject
    "return true, if the dropObject represents a class"

    ^ true
! !

!DropObject::Color class methodsFor:'defaults'!

displayObjectName
    "return the name of a bitmap image file, which is used 
     during a drag."

    ^ 'bitmaps/xpmBitmaps/misc_tools/color_wheel.xpm'

    "Modified: 19.4.1997 / 15:38:12 / cg"
! !

!DropObject::Color class methodsFor:'documentation'!

documentation
"
    I represent a color being dragged (from an image editor)
"
! !

!DropObject::Color methodsFor:'testing'!

isColorObject
    "return true, if the dropObject represents a color"

    ^ true

    "Modified: 19.4.1997 / 12:51:57 / cg"
! !

!DropObject::File class methodsFor:'defaults'!

displayObjectName
    "return the name of a bitmap image file, which is used 
     during a drag."

    ^ 'bitmaps/xpmBitmaps/document_images/xfm_file.xpm'

    "Modified: 19.4.1997 / 15:38:07 / cg"
! !

!DropObject::File class methodsFor:'documentation'!

documentation
"
    I represent a file being dragged (from a file browser)
"
! !

!DropObject::File methodsFor:'accessing'!

fetchFileInfo
    info isNil ifTrue:[
        info := theObject info
    ].
    ^ info
!

theObject:aPathname
    |f|

    f := aPathname asFilename.
"/    info := f info.

    super theObject:f

    "Modified: 19.4.1997 / 12:49:17 / cg"
! !

!DropObject::File methodsFor:'queries'!

asFilename
    theObject isFilename ifTrue:[^ theObject].

    ^ theObject asString asFilename

    "Created: / 13-10-2006 / 17:22:24 / cg"
!

exists
    "returns true if the file or directory exists"

    info isNil ifTrue:[ self fetchFileInfo ].
    ^ info notNil

    "Modified: 19.4.1997 / 12:49:30 / cg"
!

isDirectory
    "checks whether file is a directory"

    ^ self exists 
        and:[ self fetchFileInfo type == #directory ]
!

isHtmlFile
    "checks whether file is an html file"

    |mimeType|

    isHtmlFile isNil ifTrue:[
        isHtmlFile := self exists 
                        and:[ self isDirectory not
                        and:[ (mimeType := MIMETypes mimeTypeForFilename:(self asFilename)) notNil
                        and:[ mimeType isHtmlType ]]].

"/        isHtmlFile := self exists 
"/                        and:[ self isDirectory not
"/                        and:[ #( '.html' '.htm' '.HTML' '.HTM' ) includes: theObject suffix ]].
    ].
    ^ isHtmlFile
!

isImageFile
    "returns true if file is an image file"

    isImageFile isNil ifTrue:[
        isImageFile := self exists 
                        and:[self isDirectory not
                        and:[ Image isImageFileSuffix:(self asFilename suffix) ]].
    ].
    ^ isImageFile

    "Modified: 19.4.1997 / 12:50:58 / cg"
!

isPrintable
    "return true if file contains only printable characters (in the first 300 bytes)"
    
    |nChars stream buff size|

    nChars := 300.

    isPrintable isNil ifTrue:[
        isPrintable := false.

        (self exists and:[ self isDirectory not ]) ifTrue:[
            stream := self asFilename readStreamOrNil.
            stream notNil ifTrue:[
                buff := String new:nChars.
                size := stream nextBytes:nChars into:buff.
                stream close.

                (buff contains:[:char | char isPrintable not]) ifTrue:[
                    ^ false
                ].
            ].
            isPrintable := true
        ]
    ].
    ^ isPrintable
! !

!DropObject::File methodsFor:'testing'!

isFileObject
    "return true, if the dropObject represents a file- or directory"

    ^ true

    "Modified: 19.4.1997 / 12:51:49 / cg"
! !

!DropObject::FileInArchive class methodsFor:'documentation'!

documentation
"
    I represent a file being dragged from inside an archive (tar, zip,...) (from a file browser)
"
! !

!DropObject::FileInArchive methodsFor:'testing'!

isFileInArchive
    ^ true
! !

!DropObject::Image class methodsFor:'defaults'!

displayObjectName
    "return the name of a bitmap image file, which is used 
     during a drag."

    ^ 'bitmaps/xpmBitmaps/misc_tools/picture.xpm'

    "Modified: 19.4.1997 / 15:38:02 / cg"
! !

!DropObject::Image class methodsFor:'documentation'!

documentation
"
    I represent a bitmap image being dragged
"
! !

!DropObject::Image methodsFor:'testing'!

isImageObject
    "return true, if the dropObject represents an image"

    ^ true

    "Modified: 19.4.1997 / 12:51:28 / cg"
! !

!DropObject::Method class methodsFor:'documentation'!

documentation
"
    I represent a method image being dragged (from a browser's methodlist)
"
! !

!DropObject::Method methodsFor:'testing'!

isMethodObject
    "return true, if the dropObject represents a method"

    ^ true
! !

!DropObject::Project class methodsFor:'documentation'!

documentation
"
    I represent a project being dragged (from a browser's projectList)
"
! !

!DropObject::Project methodsFor:'testing'!

isProjectObject
    "return true, if the dropObject represents a project"

    ^ true
! !

!DropObject::Text class methodsFor:'defaults'!

displayObjectName
    ^ 'bitmaps/xpmBitmaps/document_images/yellow_file_text_grab.xpm'

    "Modified: 19.4.1997 / 15:40:33 / cg"
! !

!DropObject::Text class methodsFor:'documentation'!

documentation
"
    I represent text being dragged (via CTRL-drag from a textView)
"
! !

!DropObject::Text methodsFor:'testing'!

isTextObject
    "return true, if the dropObject represents some text"

    ^ true

    "Modified: 19.4.1997 / 12:52:08 / cg"
! !

!DropObject class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview2/DropObject.st,v 1.24 2015-02-04 23:15:25 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libview2/DropObject.st,v 1.24 2015-02-04 23:15:25 cg Exp $'
! !

