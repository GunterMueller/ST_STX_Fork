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

Object subclass:#Diff3InclusiveVisitor
	instanceVariableNames:'result okLines files'
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Sequenceable-Diff'
!

Diff3InclusiveVisitor comment:'A Diff3InclusiveVisitor is used by Diff3 to construct a three-way SequenceableCollection merge that treats "false conflicts" (a.k.a "accidental clean merges") as true conflicts.
Instance Variables
	files:		Used to extract the elements for each part of the result
	okLines:		Used to buffer up lists of non-conflicting elements
	result:		Accumulator
-- 
Copyright (c) 2008 Tony Garnock-Jones <tonyg@lshift.net>
Copyright (c) 2008 LShift Ltd. <query@lshift.net>
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction,including without limitation the rights to use, copy, modify, merge,publish, distribute, sublicense, and/or sell copies of the Software,and to permit persons to whom the Software is furnished to do so,subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
'
!

!Diff3InclusiveVisitor class methodsFor:'documentation'!

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
    A Diff3InclusiveVisitor is used by Diff3 to construct a three-way SequenceableCollection merge that treats 'false conflicts' 
    (a.k.a 'accidental clean merges') as true conflicts.

    Instance Variables
        files:          Used to extract the elements for each part of the result
        okLines:                Used to buffer up lists of non-conflicting elements
        result:                 Accumulator

    [author:]
        Tony Garnock-Jones <tonyg@lshift.com>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!Diff3InclusiveVisitor class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!Diff3InclusiveVisitor methodsFor:'as yet unclassified'!

files: aDictionary
	files := aDictionary
!

flushOk
	okLines isEmpty ifFalse: [
		result add: #ok -> okLines asArray.
		okLines := OrderedCollection new].
!

initialize
	result := OrderedCollection new.
	okLines := OrderedCollection new.
!

left: left original: original right: right
        | c |
        self flushOk.
        c := Diff3::Conflict new.
        c left: (left extractFrom: (files at: #left)).
        c original: (original extractFrom: (files at: #original)).
        c right: (right extractFrom: (files at: #right)).
        result add: #conflict -> c.

    "Modified: / 16-03-2012 / 19:20:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

result
	self flushOk.
	^ result asArray
!

side: aSelector chunk: aChunk
	okLines addAll: (aChunk extractFrom: (files at: aSelector)).
! !

!Diff3InclusiveVisitor class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libtool/Diff3InclusiveVisitor.st,v 1.2 2014-02-25 07:00:21 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libtool/Diff3InclusiveVisitor.st,v 1.2 2014-02-25 07:00:21 cg Exp $'
! !

