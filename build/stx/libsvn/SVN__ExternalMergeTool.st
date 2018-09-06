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

Object subclass:#ExternalMergeTool
	instanceVariableNames:'tempDir textA labelA textB labelB textC labelC textMerged'
	classVariableNames:''
	poolDictionaries:''
	category:'SVN-Diff-External'
!

!ExternalMergeTool class methodsFor:'documentation'!

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

!ExternalMergeTool class methodsFor:'others'!

version_CVS
    ^ '$Header$'
! !

!ExternalMergeTool class methodsFor:'testing'!

isAvailable
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
! !

!ExternalMergeTool methodsFor:'accessing'!

labelA
    ^ labelA ? 'A'
!

labelA:aString
    labelA := aString.
!

labelB
    ^ labelB ? 'B'
!

labelB:aString
    labelB := aString.
!

labelC
    ^ labelC ? 'C'
!

labelC:aString
    labelC := aString.
!

textA
    ^ textA
!

textA:aString
    textA := aString.
!

textB
    ^ textB
!

textB:aString
    textB := aString.
!

textC
    ^ textC
!

textC:aString
    textC := aString.
!

textMerged
    ^ textMerged
! !

!ExternalMergeTool methodsFor:'merging'!

merge

    tempDir := Filename newTemporaryDirectory.
    [self 
        save: textA as: tempDir / 'a.txt';
        save: textB as: tempDir / 'b.txt';
        save: textC as: tempDir / 'c.txt'.

    self runExternalProgram.
    (tempDir / 'merged.txt') exists ifTrue:
        [textMerged := (tempDir / 'merged.txt') readStream contents asString].
    ] ensure:
        [tempDir recursiveRemove.
        tempDir := nil]
! !

!ExternalMergeTool methodsFor:'private'!

runExternalProgram

    self subclassResponsibility
!

save: aString as: aFilename

    | s |
    s := aFilename asFilename writeStream.
    [s nextPutAll: aString]
        ensure:[s close]
! !

!ExternalMergeTool class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_SVN
    ^ '§Id: SVN__ExternalMergeTool.st 363 2011-08-08 13:49:48Z vranyj1 §'
! !
