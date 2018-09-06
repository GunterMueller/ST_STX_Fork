"
 Copyright (c) 2007-2012 Tony Garnock-Jones

 This code is based on Squeak's DiffMerge package
 written by Tony Garnock-Jones. Original project's web site:

 http://www.squeaksource.com/DiffMerge

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

Object subclass:#Diff3Hunk
	instanceVariableNames:'side oldChunk newChunk'
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Sequenceable-Diff'
!

Diff3Hunk comment:'A Diff3Hunk represents a change from the ancestor to either the left or the right branch as part of a three-way merge.
Instance Variables
	newChunk:	<DiffChunk> The new content chunk
	oldChunk:	<DiffChunk> The old (ancestral) content chunk
	side:		<Symbol> Either #left or #right
'
!

!Diff3Hunk class methodsFor:'documentation'!

copyright
"
 Copyright (c) 2007-2012 Tony Garnock-Jones

 This code is based on Squeak's DiffMerge package
 written by Tony Garnock-Jones. Original project's web site:

 http://www.squeaksource.com/DiffMerge

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
!

documentation
"
    A Diff3Hunk represents a change from the ancestor to either the left or the right branch as part of a three-way merge.

    Instance Variables
        newChunk:       <DiffChunk> The new content chunk
        oldChunk:       <DiffChunk> The old (ancestral) content chunk
        side:           <Symbol> Either #left or #right

    [author:]
        Tony Garnock-Jones <tonyg@lshift.com>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!Diff3Hunk class methodsFor:'as yet unclassified'!

side: aSelector entry: anAssociation
	^ self new side: aSelector; oldChunk: anAssociation key; newChunk: anAssociation value
! !

!Diff3Hunk methodsFor:'accessing'!

newChunk
	^ newChunk
!

newChunk: anObject
	newChunk := anObject
!

oldChunk
	^ oldChunk
!

oldChunk: anObject
	oldChunk := anObject
!

side
	^ side
!

side: anObject
	side := anObject
! !

!Diff3Hunk methodsFor:'comparing'!

<= otherHunk
	^ (oldChunk < otherHunk oldChunk) or:
		[(otherHunk oldChunk = oldChunk) and: [side = #left]]
! !

!Diff3Hunk methodsFor:'printing & storing'!

printOn:aStream
    "append a printed representation of the receiver to the argument, aStream"

    super printOn:aStream.
    aStream nextPutAll:' side: '.
    side printOn:aStream.
    aStream nextPutAll:' old: '.
    oldChunk printOn:aStream.
    aStream nextPutAll:' new: '.
    newChunk printOn:aStream.

    "Modified: / 20-03-2012 / 17:56:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Diff3Hunk class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

