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

Object subclass:#BookmarkVisitor
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Bookmarks'
!

!BookmarkVisitor class methodsFor:'documentation'!

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

!BookmarkVisitor methodsFor:'visiting'!

visit:anObject 
    "visit anObject (visitor pattern).
     The object should call back one of my visitXXXX methods."

    ^ anObject acceptVisitor:self
!

visitBookmark:anObject 

    self subclassResponsibility

    "Created: / 23-05-2011 / 10:41:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitBookmarkList:anObject 
    "dispatched back from the visited bookmarkList-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self visit:anObject root

    "Modified: / 02-06-2011 / 21:53:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitClass:anObject 

    ^self visitBookmark: anObject

    "Modified: / 23-05-2011 / 10:41:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitFile:anObject 
    ^ self visitBookmark:anObject
!

visitFolder:anObject 

    ^self visitBookmark: anObject

    "Modified: / 23-05-2011 / 10:41:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitMethod:anObject 

    ^self visitBookmark: anObject

    "Modified: / 23-05-2011 / 10:42:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitRecent:anObject 
    ^ self visitFolder:anObject
!

visitSeparator:anObject 
    ^ self visitBookmark:anObject
!

visitURL:anObject 

    ^self visitBookmark: anObject

    "Created: / 16-06-2011 / 16:08:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BookmarkVisitor class methodsFor:'documentation'!

version_CVS
    ^ '§Header: /cvs/stx/stx/libtool/BookmarkVisitor.st,v 1.2 2011/07/03 18:00:43 cg Exp §'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id: BookmarkVisitor.st 7854 2012-01-30 17:49:41Z vranyj1 $'
! !

