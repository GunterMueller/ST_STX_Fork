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

Status subclass:#StatusUnversioned
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SVN-Status'
!

!StatusUnversioned class methodsFor:'documentation'!

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

!StatusUnversioned class methodsFor:'others'!

version_CVS
    ^ '$Header$'
! !

!StatusUnversioned methodsFor:'accessing'!

icon
    "Superclass SVN::WCEntryStatus says that I am responsible to implement this method"

    ^IconLibrary question_ov

    "Created: / 11-04-2008 / 11:06:02 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

id
    ^ $?

    "Modified: / 17-08-2009 / 11:21:31 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

name
    "Superclass says that I am responsible to implement this method"
    
    ^ 'unversioned'

    "Created: / 15-03-2008 / 22:16:43 / janfrog"
! !

!StatusUnversioned methodsFor:'testing'!

isUnversioned

    ^true

    "Created: / 15-03-2008 / 22:29:20 / janfrog"
!

isUnversionedOrIgnoredOrMissing

    ^true

    "Created: / 08-02-2012 / 18:38:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!StatusUnversioned class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_SVN
    ^ '§Id: SVN__StatusUnversioned.st 362 2011-08-08 13:07:42Z vranyj1 §'
! !
