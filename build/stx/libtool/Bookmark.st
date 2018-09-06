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

HierarchicalItem subclass:#Bookmark
	instanceVariableNames:'label icon'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Bookmarks'
!

Bookmark subclass:#Class
	instanceVariableNames:'className'
	classVariableNames:''
	poolDictionaries:''
	privateIn:Bookmark
!

Bookmark subclass:#File
	instanceVariableNames:'path'
	classVariableNames:''
	poolDictionaries:''
	privateIn:Bookmark
!

Bookmark subclass:#Folder
	instanceVariableNames:'name'
	classVariableNames:''
	poolDictionaries:''
	privateIn:Bookmark
!

Bookmark subclass:#Method
	instanceVariableNames:'className selector'
	classVariableNames:''
	poolDictionaries:''
	privateIn:Bookmark
!

Bookmark::Folder subclass:#Recent
	instanceVariableNames:'limit'
	classVariableNames:''
	poolDictionaries:''
	privateIn:Bookmark
!

Bookmark subclass:#Separator
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:Bookmark
!

Bookmark subclass:#URL
	instanceVariableNames:'url'
	classVariableNames:''
	poolDictionaries:''
	privateIn:Bookmark
!

!Bookmark class methodsFor:'documentation'!

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

!Bookmark class methodsFor:'instance creation'!

forClass: aClass

    ^Bookmark::Class new className: aClass name

    "
        Bookmark forClass: Collection
    "

    "Created: / 05-05-2011 / 23:05:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-05-2011 / 13:51:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

forClass: class selector: selector

    ^Bookmark::Method new className: class name selector: selector

    "
        Bookmark forMethod: Bookmark class >> #forMethod:
    "

    "Created: / 02-06-2011 / 23:21:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

forFile: aStringOrFilename

    ^Bookmark::File new path: aStringOrFilename asString

    "
        Bookmark forFile: '/etc/passwd'
    "

    "Created: / 20-06-2011 / 22:07:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

forFolderNamed: aString

    ^Bookmark::Folder new name: aString

    "
        Bookmark forClass: Collection
    "

    "Created: / 23-05-2011 / 10:02:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

forMethod: aMethod

    ^Bookmark::Method new className: aMethod mclass name selector: aMethod selector

    "
        Bookmark forMethod: Bookmark class >> #forMethod:
    "

    "Created: / 05-05-2011 / 23:05:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-05-2011 / 13:49:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

forRecent

    ^Bookmark::Recent new

    "
        Bookmark forRecent
    "

    "Created: / 03-06-2011 / 10:50:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

forUrl: url label: label

    ^Bookmark::URL new url: url; label: label

    "
        Bookmark forClass: Collection
    "

    "Created: / 08-06-2011 / 12:44:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

separator

    ^Bookmark::Separator new

    "
        Bookmark forRecent
    "

    "Created: / 03-06-2011 / 13:39:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Bookmark methodsFor:'accessing'!

/ label

    self do:[:e|e label = label ifTrue:[^e]].
    self error:'No child with label ''' , label , ''''.

    "Created: / 21-06-2011 / 08:49:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

flyByHelpText
    ^ nil
!

icon
    "superclass BookmarkEntry says that I am responsible to implement this method"
    
    icon isNil ifTrue:[ self initializeIcon ].
    ^ icon

    "Created: / 05-05-2011 / 22:52:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-11-2011 / 14:30:44 / cg"
!

label
    "superclass BookmarkEntry says that I am responsible to implement this method"
    
    label isNil ifTrue:[ self initializeLabel ].
    ^label isNil 
        ifTrue:[ self defaultLabel ]
        ifFalse: [ label ].

    "Created: / 05-05-2011 / 22:56:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-06-2011 / 11:56:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 18-11-2011 / 14:31:05 / cg"
!

label: aStringOrText

    label := aStringOrText.
    self model changed:  #label with: self

    "Created: / 02-06-2011 / 23:13:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-06-2011 / 10:46:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Bookmark methodsFor:'accessing-defaults'!

defaultLabel
    self subclassResponsibility

    "Created: / 02-06-2011 / 11:56:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Bookmark methodsFor:'basic adding & removing'!

basicAddAll:aList beforeIndex:anIndex

    aList do:[:each|each parent: self].
    ^super basicAddAll:aList beforeIndex:anIndex

    "Created: / 23-05-2011 / 14:10:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

basicRemoveFromIndex:startIndex toIndex:stopIndex 
    "remove the children from startIndex up to and including
     the child under stopIndex."
    
    |model notify 
     index  "{ Class:SmallInteger }"
     start  "{ Class:SmallInteger }"
     stop   "{ Class:SmallInteger }"
     size   "{ Class:SmallInteger }"|

    size := self children size.
    stop := stopIndex.
    start := startIndex.
    (stop <= size and:[ start between:1 and:stop ]) 
        ifFalse:[ ^ self subscriptBoundsError:index ].
    start == 1 
        ifTrue:[ notify := self ]
        ifFalse:
            [ stop == size 
                ifTrue:[ notify := self at:(start - 1) ]
                ifFalse:[ notify := nil ] ].
    (model := self model) notNil 
        ifTrue:
            [ index := model identityIndexOf:(children at:start).
            size := stop - start + 1. ]
        ifFalse:[ index := 0 ].
    children 
        from:start
        to:stop
        do:
            [:aChild | 
            index ~~ 0 ifTrue:[ size := size + aChild numberOfVisibleChildren ].
            aChild parent:nil ].
    children removeFromIndex:start toIndex:stop.
    index ~~ 0 
        ifTrue:[ model itemRemoveFromIndex:index toIndex:(index + size - 1) ].
    notify notNil ifTrue:[ notify changed ].

    "Created: / 23-05-2011 / 16:21:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Bookmark methodsFor:'change & update'!

changed: aspect with: param

    | model |

    super changed: aspect with: param.
    (model := self model) notNil ifTrue:
        [model changed: aspect with: param].

    "Created: / 23-05-2011 / 16:22:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Bookmark methodsFor:'converting'!

asMenu

    ^self asMenuUsingBuilder: BookmarkToolbarMenuBuilder new

    "Created: / 23-05-2011 / 10:32:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-06-2011 / 08:05:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-07-2011 / 11:38:21 / cg"
!

asMenuUsingBuilder: builder

    ^builder buildMenuFor: self

    "Created: / 21-06-2011 / 08:04:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 08-07-2011 / 11:37:19 / cg"
! !

!Bookmark methodsFor:'encoding & decoding'!

skippedInLiteralEncoding

    ^#(parent isExpanded height width icon)

    "Created: / 05-05-2011 / 23:08:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-06-2011 / 22:56:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Bookmark methodsFor:'navigation'!

switchToBookmarkIn: application

    application switchToBookmarkEntry: application

    "Created: / 05-05-2011 / 23:47:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Bookmark methodsFor:'printing & storing'!

printOn:aStream
    "append a printed representation of the receiver to the argument, aStream"

    aStream nextPutAll:'BKM['.
    self label printOn: aStream.
    aStream nextPut: $]

    "Modified: / 02-06-2011 / 11:08:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Bookmark methodsFor:'private'!

initializeIcon
    "Created: / 05-05-2011 / 22:57:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initializeLabel

    label := '--------'

    "Created: / 05-05-2011 / 22:56:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-06-2011 / 13:45:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Bookmark methodsFor:'testing'!

isClassBookmark

    ^false

    "Created: / 05-05-2011 / 23:44:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isFileBookmark

    ^false

    "Created: / 20-06-2011 / 23:40:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isFolderBookmark

    ^false

    "Created: / 23-05-2011 / 09:59:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isMethodBookmark

    ^false

    "Created: / 05-05-2011 / 23:44:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isRecentBookmark

    ^false

    "Created: / 03-06-2011 / 10:50:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isURLBookmark

    ^false

    "Created: / 20-06-2011 / 23:40:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Bookmark::Class methodsFor:'accessing'!

className

    ^className

    "Created: / 05-05-2011 / 23:55:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-05-2011 / 13:36:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

className: aString

    className := aString.

    (className endsWith: ' class') ifTrue:[
        className := className copyTo: (className size - 6)"/ ' class' size - 1
    ].

    className := className asSymbol.

    "Modified: / 18-10-2011 / 13:33:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

flyByHelpText
    ^ 'Goto ',className
! !

!Bookmark::Class methodsFor:'accessing-defaults'!

defaultLabel
    "superclass Bookmark says that I am responsible to implement this method"

    ^ 'Some Class...'

    "Modified: / 02-06-2011 / 11:59:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Bookmark::Class methodsFor:'comparing'!

= another

    ^(self class = another class) 
        and:[className = another className]

    "Created: / 05-05-2011 / 23:33:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-05-2011 / 13:59:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hash

    ^className hash bitXor: self class hash

    "Created: / 05-05-2011 / 23:32:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-05-2011 / 13:59:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Bookmark::Class methodsFor:'navigation'!

switchToBookmarkIn: application

    application switchToClass: (Smalltalk at: className asSymbol) selector: nil updateHistory: true

    "Created: / 05-05-2011 / 23:49:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-04-2012 / 10:59:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Bookmark::Class methodsFor:'private'!

initializeIcon

    | cls |
    cls :=  Smalltalk at: className asSymbol.
    cls notNil ifTrue:[icon := SystemBrowser iconForClass: cls].

    "Created: / 05-05-2011 / 23:01:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 30-06-2011 / 19:10:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 29-11-2011 / 11:20:52 / cg"
!

initializeLabel

    className isNil ifTrue:[^self].

    label := className copyFrom: (className lastIndexOf: $:) + 1

    "Created: / 05-05-2011 / 23:03:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-06-2011 / 11:57:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-11-2011 / 14:31:11 / cg"
! !

!Bookmark::Class methodsFor:'testing'!

isClassBookmark

    ^true

    "Created: / 05-05-2011 / 23:44:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Bookmark::Class methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitClass:self
! !

!Bookmark::File methodsFor:'accessing'!

flyByHelpText
    ^ 'Goto "', path , '"'
!

initializeLabel

    label := path asFilename baseName

    "Created: / 20-06-2011 / 22:09:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

path
    ^ path
!

path:something
    path := something.
! !

!Bookmark::File methodsFor:'accessing-defaults'!

defaultLabel
    "superclass Bookmark says that I am responsible to implement this method"

    ^ 'Some file...'

    "Modified: / 20-06-2011 / 22:08:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Bookmark::File methodsFor:'testing'!

isFileBookmark

    ^true

    "Created: / 20-06-2011 / 23:40:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Bookmark::File methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitFile:self
! !

!Bookmark::Folder methodsFor:'accessing'!

initializeIcon


    ^ icon := ToolbarIconLibrary directoryOpen22x24Icon1

    "Created: / 02-06-2011 / 12:10:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initializeLabel
    "superclass Bookmark says that I am responsible to implement this method"

    ^ label := self name

    "Created: / 23-05-2011 / 14:08:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-06-2011 / 11:52:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

label

    ^self name

    "Created: / 02-06-2011 / 11:51:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

label: aString

    self name: aString

    "Created: / 03-06-2011 / 10:45:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

name

    ^name ? 'New Folder...'

    "Created: / 23-05-2011 / 10:02:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-06-2011 / 11:52:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

name: aString

    name := aString.
    self model changed:  #label with: self

    "Created: / 23-05-2011 / 10:02:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-06-2011 / 10:46:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Bookmark::Folder methodsFor:'accessing-defaults'!

defaultLabel
    "superclass Bookmark says that I am responsible to implement this method"

    ^ 'New Folder...'

    "Modified: / 02-06-2011 / 11:58:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Bookmark::Folder methodsFor:'testing'!

isFolderBookmark

    ^true

    "Created: / 23-05-2011 / 10:00:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Bookmark::Folder methodsFor:'utilities'!

moveDown: child

    | index |
    index := children identityIndexOf: child.
    index = children size ifTrue:[^self].
    self removeIndex: index.  
    self add: child afterIndex: index.

    "Created: / 02-06-2011 / 11:04:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

moveIn: child

    | index folder |
    index := children identityIndexOf: child.
    index = children size ifTrue:[^self].
    folder := children at: index + 1.
    folder isFolderBookmark ifFalse:[^self].        
    self removeIndex: index. 
    folder addFirst: child

    "Created: / 03-06-2011 / 10:30:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

moveOut: child

    | index myindex |
    self parent isNil ifTrue:[^self].
    index := children identityIndexOf: child.
    myindex := self parent children identityIndexOf: self.
    self removeIndex: index. 
    self parent add: child afterIndex: myindex.

    "Created: / 03-06-2011 / 10:32:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-11-2011 / 14:31:15 / cg"
!

moveUp: child

    | index |
    index := children identityIndexOf: child.
    index = 1 ifTrue:[^self].
    self removeIndex: index. 
    self add: child beforeIndex: index - 1.

    "Created: / 02-06-2011 / 11:04:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sortChildrenAlphabetically
    self sort:[:a :b | a label < b label].
! !

!Bookmark::Folder methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitFolder:self
! !

!Bookmark::Method methodsFor:'accessing'!

className

    ^className

    "Created: / 05-05-2011 / 23:55:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-05-2011 / 13:36:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

className:aString
    className := aString.
!

className:classNameArg selector:selectorArg 
    className := classNameArg.
    selector := selectorArg.
!

flyByHelpText
    ^ className,' >> ',selector
!

selector
    ^ selector

!

selector: aSymbol
    selector := aSymbol

! !

!Bookmark::Method methodsFor:'accessing-defaults'!

defaultLabel
    "superclass Bookmark says that I am responsible to implement this method"

    ^ 'Some Method...'

    "Modified: / 02-06-2011 / 11:58:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Bookmark::Method methodsFor:'navigation'!

switchToBookmarkIn: application

    application 
        switchToClass: (Smalltalk classNamed: className) 
        selector: selector 
        updateHistory: true

    "Created: / 05-05-2011 / 23:49:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-07-2011 / 23:11:03 / cg"
    "Modified: / 06-04-2012 / 10:59:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Bookmark::Method methodsFor:'private'!

initializeLabel

    className isNil ifTrue:[^self].
    selector  isNil ifTrue:[^self].

    label :=
        (className copyFrom: ((className lastIndexOf: $:) + 1)) allBold ,
        ' » ' , (selector "asText allItalic")

    "Created: / 05-05-2011 / 23:04:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-06-2011 / 22:00:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-11-2011 / 14:31:19 / cg"
! !

!Bookmark::Method methodsFor:'testing'!

isMethodBookmark

    ^true

    "Created: / 05-05-2011 / 23:44:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Bookmark::Method methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitMethod:self
! !

!Bookmark::Recent methodsFor:'accessing'!

limit
    ^ limit ? 15

    "Modified: / 03-06-2011 / 10:51:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

limit:something
    limit := something.
! !

!Bookmark::Recent methodsFor:'testing'!

isFolderBookmark

    ^false

    "Created: / 03-06-2011 / 10:51:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isRecentBookmark

    ^true

    "Created: / 03-06-2011 / 10:51:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Bookmark::Recent methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitRecent:self
! !

!Bookmark::Separator methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitSeparator:self
! !

!Bookmark::URL methodsFor:'accessing'!

flyByHelpText
    ^ 'Goto "', url asString , '"'
!

url
    ^ url
!

url:aString
    url := aString.
! !

!Bookmark::URL methodsFor:'comparing'!

= another

    ^(self class = another class) 
        and:[label = another label
            and:[url = another url]].

    "Created: / 08-06-2011 / 15:11:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hash

    ^label asString hash bitXor:[url hash].

    "Created: / 08-06-2011 / 15:10:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Bookmark::URL methodsFor:'testing'!

isURLBookmark

    ^true

    "Created: / 20-06-2011 / 23:40:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Bookmark::URL methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitURL:self

    "Modified: / 16-06-2011 / 16:07:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Bookmark class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

