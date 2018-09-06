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

Status subclass:#StatusAdded
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SVN-Status'
!

!StatusAdded class methodsFor:'documentation'!

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

!StatusAdded class methodsFor:'others'!

version_CVS
    ^ '$Header$'
! !

!StatusAdded methodsFor:'accessing'!

icon
    "Superclass SVN::WCEntryStatus says that I am responsible to implement this method"

    ^IconLibrary added_ov

    "Created: / 11-04-2008 / 11:06:02 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

id
    ^ $A

    "Created: / 17-08-2009 / 11:17:40 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

name
    "Superclass says that I am responsible to implement this method"
    
    ^ 'added'

    "Created: / 19-03-2008 / 18:39:09 / janfrog"
! !

!StatusAdded methodsFor:'testing'!

isAdded

    ^true

    "Created: / 19-03-2008 / 18:40:10 / janfrog"
! !

!StatusAdded class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_SVN
    ^ '�Id: SVN__StatusAdded.st 363 2011-08-08 13:49:48Z vranyj1 �'
! !