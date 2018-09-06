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

XMLObject subclass:#RevisionLogEntry
	instanceVariableNames:'revision author date message changedPaths'
	classVariableNames:''
	poolDictionaries:''
	category:'SVN-Repository'
!

!RevisionLogEntry class methodsFor:'documentation'!

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

!RevisionLogEntry class methodsFor:'others'!

version_CVS
    ^ '$Header$'
! !

!RevisionLogEntry methodsFor:'accessing'!

author
    ^ author

    "Created: / 19-04-2008 / 12:26:50 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

author:something
    author := something.

    "Created: / 19-04-2008 / 12:26:50 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

changedPaths
    ^ changedPaths ? #()

    "Modified: / 24-06-2009 / 15:10:48 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

date
    ^ date

    "Created: / 19-04-2008 / 12:26:50 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

date:something
    date := something.

    "Created: / 19-04-2008 / 12:26:50 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

message
    ^ message

    "Created: / 19-04-2008 / 12:26:50 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

message:something
    message := something.

    "Created: / 19-04-2008 / 12:26:50 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

revision
    ^ revision

    "Created: / 19-04-2008 / 12:26:50 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

revision:something
    revision := something.

    "Created: / 19-04-2008 / 12:26:50 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!RevisionLogEntry methodsFor:'instance creation'!

readFromXml: xml
    revision := SVN::Revision number: xml @ 'revision'.
    author := (xml / 'author') characterData.
    date := Timestamp readISO8601From: (xml / 'date') characterData.
    message := (xml / 'msg') characterData.
    changedPaths := 
        ((xml / 'paths' / 'path')
            collect: [:e | WCActionNotification readFromXml: e ])
            asSortedCollection:[:e1 :e2|e1 path < e2 path]

    "Created: / 11-04-2008 / 13:27:47 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 18-08-2009 / 14:38:48 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 25-06-2010 / 10:25:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RevisionLogEntry class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_SVN
    ^ '§Id: SVN__RevisionLogEntry.st 363 2011-08-08 13:49:48Z vranyj1 §'
! !
