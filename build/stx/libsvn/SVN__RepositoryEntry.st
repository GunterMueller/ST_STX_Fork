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

Entry subclass:#RepositoryEntry
	instanceVariableNames:'size branch'
	classVariableNames:''
	poolDictionaries:''
	category:'SVN-Repository'
!

!RepositoryEntry class methodsFor:'documentation'!

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

!RepositoryEntry class methodsFor:'instance creation'!

readFromXml: anXMLNode

    ^self new readFromXml: anXMLNode

    "Created: / 18-08-2009 / 17:24:10 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-08-2009 / 08:51:48 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!RepositoryEntry class methodsFor:'others'!

version_CVS
    ^ '$Header$'
! !

!RepositoryEntry methodsFor:'accessing'!

branch
    ^ branch
! !

!RepositoryEntry methodsFor:'initialization'!

readFromXml: anXMLNode

    kind := (NodeKind withName: anXMLNode @ 'kind').
    path := (anXMLNode / 'name') characterData.
    revision := SVN::Revision number: ((anXMLNode / 'commit' ) first @ 'revision').
    date := Timestamp readISO8601From: (anXMLNode / 'commit' / 'date') characterData.
    author := (anXMLNode / 'commit' / 'author') characterData.
    size := (anXMLNode / 'size') characterData.
    size isNilOrEmptyCollection ifFalse:[size := size asInteger]

    "Created: / 19-08-2009 / 08:52:10 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-08-2009 / 15:07:46 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

setBranch: aBranch

    branch := aBranch

    "Created: / 18-08-2009 / 13:15:16 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!RepositoryEntry class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_SVN
    ^ '§Id: SVN__RepositoryEntry.st 363 2011-08-08 13:49:48Z vranyj1 §'
! !
