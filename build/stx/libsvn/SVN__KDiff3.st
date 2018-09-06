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

ExternalMergeTool subclass:#KDiff3
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SVN-Diff-External'
!

!KDiff3 class methodsFor:'documentation'!

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

!KDiff3 class methodsFor:'others'!

version_CVS
    ^ '$Header$'
! !

!KDiff3 class methodsFor:'testing'!

isAvailable

    ^OperatingSystem canExecuteCommand: 'kdiff3'
! !

!KDiff3 methodsFor:'private'!

runExternalProgram

    OperatingSystem
        executeCommand: 
            (String streamContents:
                [:cmd|
                cmd 
                    nextPutAll: 'kdiff3'; space;
                    nextPutAll: '-m'; space;
                    nextPutAll: '-o merged.txt'; space;
                    nextPutAll: '-L'; space; nextPut:$'; nextPutAll: self labelA; nextPut:$'; space;
                    nextPutAll: '-L'; space; nextPut:$'; nextPutAll: self labelB; nextPut:$'; space;
                    nextPutAll: '-L'; space; nextPut:$'; nextPutAll: self labelC; nextPut:$'; space;
                    nextPutAll: 'a.txt'; space;
                    nextPutAll: 'b.txt'; space;
                    nextPutAll: 'c.txt'])
        inDirectory: tempDir pathName
! !

!KDiff3 class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_SVN
    ^ '�Id: SVN__KDiff3.st 362 2011-08-08 13:07:42Z vranyj1 �'
! !