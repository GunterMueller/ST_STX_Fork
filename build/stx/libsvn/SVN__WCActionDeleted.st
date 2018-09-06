"
 Copyright (c) 2007-2010 Jan Vrany
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
"{ Package: 'stx:libsvn' }"

"{ NameSpace: SVN }"

WCAction subclass:#WCActionDeleted
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SVN-Working copy'
!

!WCActionDeleted class methodsFor:'documentation'!

copyright
"
 Copyright (c) 2007-2010 Jan Vrany
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

!WCActionDeleted class methodsFor:'accessing'!

actionName
    "Superclass says that I am responsible to implement this method"

    ^'D'

    "Created: / 16-03-2008 / 08:49:10 / janfrog"
! !

!WCActionDeleted class methodsFor:'others'!

version_CVS
    ^ '$Header$'
! !

!WCActionDeleted methodsFor:'accessing'!

icon

    ^SVN::IconLibrary delete

    "Created: / 24-06-2009 / 15:07:57 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!WCActionDeleted methodsFor:'processing'!

processEntry: entry using: processor 
    "
             Double dispath to a processor, passing an entry"
    
    processor processDeletedEntry: entry

    "Modified: / 27-08-2009 / 08:50:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!WCActionDeleted methodsFor:'testing'!

isDeleted

    ^true

    "Created: / 17-08-2009 / 19:47:07 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!WCActionDeleted class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_SVN
    ^ '§Id: SVN__WCActionDeleted.st 363 2011-08-08 13:49:48Z vranyj1 §'
! !
