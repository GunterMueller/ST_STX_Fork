"
 Copyright (c) 2007-2010 Jan Vrany, SWING Research Group, Czech Technical University in Prague
 Copyright (c) 2009-2010 eXept Software AG

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the 'Software'), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
"
"{ Package: 'stx:libtool' }"

"{ NameSpace: Smalltalk }"

HierarchicalList subclass:#BookmarkList
	instanceVariableNames:'fileName'
	classVariableNames:'BrowserBookmarks WorkspaceBookmarks WebBookmarks FileBookmarks'
	poolDictionaries:''
	category:'Interface-Bookmarks'
!

!BookmarkList class methodsFor:'documentation'!

copyright
"
 Copyright (c) 2007-2010 Jan Vrany, SWING Research Group, Czech Technical University in Prague
 Copyright (c) 2009-2010 eXept Software AG

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the 'Software'), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
"
! !

!BookmarkList class methodsFor:'instance creation'!

decodeFromLiteralArray:anArray

    (anArray size == 3 and: [anArray second == #root:]) ifFalse:[
        self breakPoint: #jv. 
        ^ super decodeFromLiteralArray:anArray
    ].

    ^self new root: anArray third decodeAsLiteralArray

    "Created: / 23-05-2011 / 14:28:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

new
    "return an initialized instance"

    ^ super new initialize.

    "Modified: / 23-05-2011 / 13:57:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readFrom: aStream onError: aBlock
    | litArray |

    ^ [
        litArray := Compiler evaluate: aStream contents asString.
        litArray decodeAsLiteralArray.
    ] on: Error do: [
        aBlock value.
    ]

    "Created: / 23-05-2011 / 15:58:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readFromFile: aStringOrFilename
    ^ self readFromFile: aStringOrFilename onError:[:reason | self error:reason]
!

readFromFile: aStringOrFilename onError: aBlock
    | bookmarks file pathName|

    file := aStringOrFilename asFilename.
    pathName := file pathName.
    file exists ifFalse: [^ aBlock valueWithOptionalArgument:('File does %1 not exist' bindWith: pathName)].
    bookmarks := self readFrom: file readStream onError: [^aBlock value].
    bookmarks isNil ifTrue: [^ aBlock valueWithOptionalArgument:('Cannot parse %1 not exist' bindWith: pathName)].
    bookmarks fileName: pathName.
    ^bookmarks

    "Created: / 23-05-2011 / 16:32:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-06-2011 / 19:43:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-11-2011 / 14:32:24 / cg"
! !

!BookmarkList class methodsFor:'accessing'!

forFileBrowser
    FileBookmarks isNil ifTrue:[
        self initializeFileBookmarks
    ].
    ^ FileBookmarks

    "Created: / 04-04-2012 / 12:04:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

forSystemBrowser

    BrowserBookmarks isNil ifTrue:
        [self initializeBrowserBookmarks].
    ^BrowserBookmarks

    "Created: / 23-05-2011 / 10:10:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

forWebBrowser

    WebBookmarks isNil ifTrue:
        [self initializeWebBookmarks].
    ^WebBookmarks

    "Created: / 08-06-2011 / 12:15:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

forWorkspace

    WorkspaceBookmarks isNil ifTrue:
        [self initializeWorkspaceBookmarks].
    ^WorkspaceBookmarks

    "Created: / 20-06-2011 / 22:11:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BookmarkList class methodsFor:'accessing - defaults'!

defaultLabelForMyWorkspaces

    ^'My Workspaces'

    "Created: / 21-06-2011 / 08:35:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

defaultLabelForRecent

    ^'Recent'

    "Created: / 21-06-2011 / 08:35:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BookmarkList class methodsFor:'class initialization'!

initializeBrowserBookmarks

    | file  |
    file := Filename defaultDirectory / 'browser-bookmarks.rc'.
    BrowserBookmarks := self readFromFile: file onError:[nil].
    BrowserBookmarks notNil ifTrue:[^self].    

    file := Filename homeDirectory / '.smalltalk' / 'browser-bookmarks.rc'.
    BrowserBookmarks := self readFromFile: file onError:[nil].
    BrowserBookmarks notNil ifTrue:[^self].    

    BrowserBookmarks := self new fileName: file pathName.

    "Created: / 23-05-2011 / 10:06:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-05-2011 / 16:35:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 29-11-2011 / 11:21:06 / cg"
!

initializeFileBookmarks

    | file  |
    file := Filename defaultDirectory / 'file-bookmarks.rc'.
    FileBookmarks := self readFromFile: file onError:[nil].
    FileBookmarks notNil ifTrue:[^self].    

    file := Filename homeDirectory / '.smalltalk' / 'file-bookmarks.rc'.
    FileBookmarks := self readFromFile: file onError:[nil].
    FileBookmarks notNil ifTrue:[^self].    

    FileBookmarks := self new fileName: file pathName.

    "Created: / 04-04-2012 / 12:05:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initializeWebBookmarks

    | file  |
    file := Filename defaultDirectory / 'web-bookmarks.rc'.
    WebBookmarks := self readFromFile: file onError:[nil].
    WebBookmarks notNil ifTrue:[^self].    

    file := Filename homeDirectory / '.smalltalk' / 'web-bookmarks.rc'.
    WebBookmarks := self readFromFile: file onError:[nil].
    WebBookmarks notNil ifTrue:[^self].    

    WebBookmarks := self new fileName: file pathName.

    "Created: / 08-06-2011 / 12:15:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 29-11-2011 / 11:21:10 / cg"
!

initializeWorkspaceBookmarks

    | file  |
    file := Filename defaultDirectory / 'workspace-bookmarks.rc'.
    WorkspaceBookmarks := self readFromFile: file onError:[nil].
    WorkspaceBookmarks notNil ifTrue:[^self].    

    file := Filename homeDirectory / '.smalltalk' / 'workspace-bookmarks.rc'.
    WorkspaceBookmarks := self readFromFile: file onError:[nil].
    WorkspaceBookmarks notNil ifTrue:[^self].    

    WorkspaceBookmarks := self new fileName: file pathName.
    WorkspaceBookmarks root add: 
            ((Bookmark forFolderNamed: self defaultLabelForMyWorkspaces)
                add: (Bookmark forFile: WorkspaceApplication defaultMyWorkspaceDotWspFile pathName);
                yourself).

    "
        WorkspaceBookmarks := nil.
        BookmarkList initializeWorkspaceBookmarks.
    "

    "
        WorkspaceBookmarks := nil.
    "

    "Created: / 20-06-2011 / 22:10:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-06-2011 / 08:46:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 29-11-2011 / 11:21:16 / cg"
! !

!BookmarkList methodsFor:'accessing'!

/ label

    ^ self root / label

    "Created: / 21-06-2011 / 08:49:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileName
    ^ fileName
!

fileName:aString
    fileName := aString.
! !

!BookmarkList methodsFor:'accessing - special folders'!

myWorkspaces

    ^self / self class defaultLabelForMyWorkspaces

    "
        BookmarkList forWorkspace myWorkspaces      
    "

    "Created: / 21-06-2011 / 08:53:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BookmarkList methodsFor:'change & update'!

changed:aParameter with:anArgument

    super changed:aParameter with:anArgument.
    "/self save.

    "Created: / 23-05-2011 / 16:13:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-06-2011 / 13:35:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BookmarkList methodsFor:'collection protocol'!

add: item 

    ^root add: item

    "Created: / 23-05-2011 / 10:49:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-05-2011 / 13:45:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

contains: anObject

    ^root contains: anObject

    "Created: / 23-05-2011 / 10:44:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-05-2011 / 13:46:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

remove: item ifAbsent: block

    ^root remove: item

    "Created: / 23-05-2011 / 10:47:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-05-2011 / 13:48:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BookmarkList methodsFor:'converting'!

asMenu

    ^root asMenu

    "Created: / 23-05-2011 / 10:31:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

asMenuUsingBuilder: builderClass

    ^self root asMenuUsingBuilder: builderClass

    "Created: / 21-06-2011 / 08:05:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

literalArrayEncoding

    ^Array 
        with: self className
        with: #root:
        with: root literalArrayEncoding

    "Created: / 23-05-2011 / 14:23:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BookmarkList methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."

    super initialize.

    showRoot := false.
    self root: (Bookmark forFolderNamed: '<bookmarks>').

    "Modified: / 23-05-2011 / 13:56:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BookmarkList methodsFor:'loading & saving'!

save
    |f|

    (fileName notNil 
        and:[ (f := fileName asFilename) exists not or:[ f isWritable ] ]) 
            ifTrue:[ self saveOn:fileName ].

    "Created: / 23-05-2011 / 16:38:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

saveOn: aStringOrFilename

    aStringOrFilename asFilename writingFileDo:
        [:s|s nextPutAll: self literalArrayEncoding storeString].

    "Created: / 23-05-2011 / 16:39:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BookmarkList methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitBookmarkList:self
! !

!BookmarkList class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

