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

XMLObject subclass:#WCEntryInfo
	instanceVariableNames:'path url root kind revision author date'
	classVariableNames:''
	poolDictionaries:''
	category:'SVN-Working copy'
!

!WCEntryInfo class methodsFor:'documentation'!

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

!WCEntryInfo class methodsFor:'others'!

version_CVS
    ^ '$Header$'
! !

!WCEntryInfo methodsFor:'accessing'!

author
    ^ author
!

author:something
    author := something.
!

date
    ^ date
!

date:something
    date := something.
!

kind
    ^ kind
!

kind:something
    kind := something.
!

path
    ^ path
!

path:something
    path := something.
!

revision
    ^ revision
!

revision:something
    revision := something.
!

root
    ^ root
!

url
    ^ url
! !

!WCEntryInfo methodsFor:'initialization'!

readFromXml: xmlNode
    | commit |

    path := xmlNode @ 'path'.
    kind := xmlNode @ 'kind'.
    url := (xmlNode / 'url') characterData.
    root := (xmlNode / 'repository' / 'root') characterData.
    commit := xmlNode / 'commit'.
    commit notEmptyOrNil ifTrue:[
        revision := (commit @ 'revision') asNumber.
        author := (commit / 'author') characterData.
        date := Timestamp readISO8601From: (commit / 'date') characterData.
    ] ifFalse:[
        revision := (xmlNode @ 'revision') asNumber.
    ].

    "Modified: / 06-04-2008 / 21:36:51 / janfrog"
    "Created: / 15-06-2009 / 12:23:09 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 18-01-2012 / 22:24:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!WCEntryInfo class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_SVN
    ^ '§Id: SVN__WCEntryInfo.st 363 2011-08-08 13:49:48Z vranyj1 §'
! !
