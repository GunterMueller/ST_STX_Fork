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

Entry subclass:#WCEntry
	instanceVariableNames:'wc status include'
	classVariableNames:''
	poolDictionaries:''
	category:'SVN-Working copy'
!

!WCEntry class methodsFor:'documentation'!

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

!WCEntry class methodsFor:'instance creation'!

path: aString

    ^self new
        path: aString;
        yourself

    "Created: / 27-08-2009 / 08:19:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readFromXml: aXMLNode

    self assert: (aXMLNode isKindOf: XML::Node).
    ^self new readFromXml: aXMLNode

    "Created: / 18-08-2009 / 14:27:46 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!WCEntry class methodsFor:'others'!

version_CVS
    ^ '$Header$'
! !

!WCEntry methodsFor:'accessing'!

directory

    ^self file directory

    "Created: / 23-11-2009 / 17:29:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

file

    ^wc path / path

    "Created: / 23-11-2009 / 17:29:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileMergeLeft
    "Base"

    | files revs |
    files := self directory directoryContentsAsFilenamesMatching: (path , '*.r*').
    files size = 0 ifTrue:[^nil].
    files size ~= 2 ifTrue:[self error:'Unfinished/interrupted merge in working copy?'].
    revs := files collect:[:each|(each suffix select:[:char|char isDigit]) asNumber].
    ^revs first < revs second
        ifTrue:[files first]
        ifFalse:[files second]

    "Created: / 23-11-2009 / 17:32:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-12-2009 / 21:24:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileMergeRight
    "To be merged"

    | files revs |
    files := self directory directoryContentsAsFilenamesMatching: (path , '*.r*').
    files size = 0 ifTrue:[^nil].
    files size ~= 2 ifTrue:[self error:'Unfinished/interrupted merge in working copy?'].
    revs := files collect:[:each|(each suffix select:[:char|char isDigit]) asNumber].
    ^revs first > revs second
        ifTrue:[files first]
        ifFalse:[files second]

    "Created: / 23-11-2009 / 17:32:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-12-2009 / 21:23:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileMergeWorking

    | files |
    files := self directory directoryContentsAsFilenamesMatching: (path , '.working').
    files size = 0 ifTrue:[
    files := self directory directoryContentsAsFilenamesMatching: (path , '.mine')].
    files size = 0 ifTrue:[^nil].
    files size > 1 ifTrue:[self error:'Unfinished/interrupted merge in working copy?'].
    ^files anyOne

    "Created: / 23-11-2009 / 17:32:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-12-2009 / 16:05:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

include
    "Returns true if the entry should be included in commit, false otherwise"

    ^ include

    "Modified (comment): / 07-02-2012 / 23:04:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

include:aBoolean
    "Sets whether the entry should be included in commit or not"

    include := aBoolean.

    "Modified (comment): / 07-02-2012 / 23:04:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

kind

    kind ifNil:
        [self file exists
            ifFalse:
                [kind  := NodeKindUnknown instance]
            ifTrue:
                [self file isDirectory
                    ifTrue:[kind := NodeKindDir instance]
                    ifFalse:[kind := NodeKindFile instance]]].
    ^kind

    "Created: / 24-11-2009 / 09:29:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readStream

    ^self asFilename readStream

    "Created: / 27-08-2009 / 09:52:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

status
    ^ status

    "Created: / 17-08-2009 / 17:39:47 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

wc
    ^ wc
!

wc:aSVNWorkingCopy
    wc := aSVNWorkingCopy.
! !

!WCEntry methodsFor:'actions - svn'!

revert

    wc revert: (Array with: self path).
    status := StatusNormal instance

    "Created: / 05-12-2009 / 20:14:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-02-2010 / 19:47:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!WCEntry methodsFor:'conversion'!

asChangeSet

   ^ChangeSet fromFile: self file pathName

    "Created: / 26-11-2009 / 19:49:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

asFilename

   ^self file

    "Created: / 27-08-2009 / 09:52:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-11-2009 / 17:29:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!WCEntry methodsFor:'initialization'!

readFromXml: xmlNode

    include := true.
    path := xmlNode @ 'path'.
    status := Status withName: (xmlNode / 'wc-status' @ 'item').
    (status isUnversioned or:[status isAdded or:[status isExternal or:[status isMissing]]]) ifFalse:
        [| commitNode |
        commitNode := xmlNode / 'wc-status' / 'commit'.
        revision := (commitNode first
                        valueOfAttribute: 'revision' 
                        ifAbsent:[self error:'No revision attribute!!']) asNumber.
        author := (commitNode / 'author') characterData.
        date := Timestamp readISO8601From: (commitNode / 'date') characterData]

    "Modified: / 06-04-2008 / 21:36:51 / janfrog"
    "Created: / 18-08-2009 / 14:28:19 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 07-02-2012 / 23:04:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!WCEntry methodsFor:'presentation'!

pathText

    ^status isNormal
        ifTrue:[path]
        ifFalse:[path asText allBold]

    "Created: / 11-04-2008 / 11:28:03 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

statusIcon
    ^ status icon

    "Created: / 17-08-2009 / 17:40:17 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!WCEntry methodsFor:'printing & storing'!

printOn: stream

    stream 
        space; nextPutAll: 'path:     '; nextPutAll: path; cr;
        space; nextPutAll: 'status:   '; nextPutAll: status printString; cr.
    (status notNil and:[status isUnversioned not]) ifTrue:[
        stream
        space; nextPutAll: 'revision: '; nextPutAll: revision printString; cr;        
        space; nextPutAll: 'author:   '; nextPutAll: author ? '<unknown>'; cr;            
        space; nextPutAll: 'date:     '; nextPutAll: date printString; cr]

    "Created: / 16-03-2008 / 08:18:05 / janfrog"
    "Modified: / 11-04-2008 / 09:47:51 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!WCEntry methodsFor:'testing'!

isDirEntry

    ^kind isDir

    "Created: / 27-08-2009 / 08:38:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isFileEntry

    ^kind isFile

    "Created: / 27-08-2009 / 08:26:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!WCEntry class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_SVN
    ^ '§Id: SVN__WCEntry.st 363 2011-08-08 13:49:48Z vranyj1 §'
! !
