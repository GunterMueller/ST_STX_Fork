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

BookmarkVisitor subclass:#BookmarkMenuBuilder
	instanceVariableNames:'resources menu stack toolbar'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Bookmarks'
!

!BookmarkMenuBuilder class methodsFor:'documentation'!

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

!BookmarkMenuBuilder class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!BookmarkMenuBuilder methodsFor:'accessing'!

menu

    ^ menu

    "Created: / 23-05-2011 / 10:43:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

resources:something
    resources := something.
! !

!BookmarkMenuBuilder methodsFor:'initialization'!

initialize

    menu := Menu new.
    stack := Stack with: menu.
    resources := ResourcePack new.

    "/ super initialize.   -- commented since inherited method does nothing

    "Modified: / 08-07-2011 / 13:49:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BookmarkMenuBuilder methodsFor:'utilities'!

menuItemAddBookmark:anObject 


    ^self menuItemAddBookmark:anObject labeled:'Add Bookmark Here'.

    "Modified: / 21-06-2011 / 08:00:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-07-2011 / 11:39:31 / cg"
!

menuItemAddBookmark:anObject labeled: label
    ^ (MenuItem 
        label:(resources string:label)
        itemValue:#menuAddBookmarkTo:
        argument:anObject)
        translateLabel:false.

    "Created: / 21-06-2011 / 07:59:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-07-2011 / 11:39:40 / cg"
!

menuItemFolder: folder

    ^ (MenuItem 
        label:folder label)
        translateLabel:false.

    "Created: / 21-06-2011 / 08:08:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

menuItemGotoBookmark:anObject 
    |icon label|

    label := anObject label.
    icon := anObject icon.
    icon notNil ifTrue:[ label := LabelAndIcon label:label icon:icon ].
    ^ (MenuItem
        label:label
        itemValue:#switchToBookmarkEntry:
        argument:anObject)
            activeHelpKey:(anObject flyByHelpText);
            translateLabel:false.

    "Created: / 21-06-2011 / 07:55:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 29-11-2011 / 11:21:20 / cg"
! !

!BookmarkMenuBuilder methodsFor:'visiting'!

buildMenuFor: anObject
    ^ self
        visit: anObject;
        menu

    "Created: / 02-06-2011 / 21:52:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 08-07-2011 / 11:37:42 / cg"
!

visitBookmark:anObject 
    |item|

    item := self menuItemGotoBookmark:anObject.
    stack top addItem:item

    "Created: / 23-05-2011 / 10:42:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-06-2011 / 07:55:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitFolder:anObject 
    |item submenu|

    anObject parent isNil 
        ifTrue:[ anObject children ? #() do:[:child | self visit:child ] ]
        ifFalse:
            [ item := self menuItemFolder: anObject.
            stack top addItem:item.
            submenu := Menu new.
            item submenu:submenu.
            stack push:submenu.
            anObject children ? #() do:[:child | self visit:child ].
            stack top hasItems ifTrue:[ stack top addSeparator ].
            item := self menuItemAddBookmark:anObject.
            stack top addItem:item.
            stack pop ].

    "Created: / 23-05-2011 / 10:38:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-06-2011 / 08:08:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitSeparator:anObject

    stack top addItem: MenuItem separator

    "Created: / 03-06-2011 / 13:41:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BookmarkMenuBuilder class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libtool/BookmarkMenuBuilder.st,v 1.10 2015-02-20 15:37:15 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libtool/BookmarkMenuBuilder.st,v 1.10 2015-02-20 15:37:15 cg Exp $'
!

version_SVN
    ^ '$Id: BookmarkMenuBuilder.st,v 1.10 2015-02-20 15:37:15 cg Exp $'
! !

