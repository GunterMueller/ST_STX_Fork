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

BookmarkMenuBuilder subclass:#BookmarkAddMenuBuilder
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Bookmarks'
!

!BookmarkAddMenuBuilder class methodsFor:'documentation'!

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

!BookmarkAddMenuBuilder methodsFor:'visiting'!

visitBookmark:anObject

    "Nothing to do"

    "Created: / 02-06-2011 / 21:43:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitFolder:anObject

    | addItem item submenu |

    addItem := self menuItemAddBookmark: anObject. 

    anObject parent isNil
        ifTrue:[
            stack top addItem: addItem.
            anObject children ? #() do: [:child|self visit: child].
        ] ifFalse:[
            item := MenuItem label: anObject label.
            stack top addItem: item.
            submenu := Menu new.
            item submenu: submenu.
            stack push: submenu.
            stack top addItem: addItem.
            anObject children ? #() do: [:child|self visit: child].
            stack pop
    ].

    "Created: / 02-06-2011 / 21:50:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-06-2011 / 08:00:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitSeparator:anObject

    "Created: / 03-06-2011 / 17:12:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BookmarkAddMenuBuilder class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libtool/BookmarkAddMenuBuilder.st,v 1.3 2013-08-31 17:41:47 cg Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id: BookmarkAddMenuBuilder.st,v 1.3 2013-08-31 17:41:47 cg Exp $'
! !

