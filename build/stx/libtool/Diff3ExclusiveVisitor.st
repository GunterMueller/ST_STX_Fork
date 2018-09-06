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

Diff3InclusiveVisitor subclass:#Diff3ExclusiveVisitor
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Sequenceable-Diff'
!

Diff3ExclusiveVisitor comment:'A Diff3ExclusiveVisitor is used by Diff3 to construct a three-way SequenceableCollection merge that resolves "false conflicts" (a.k.a "accidental clean merges") by accepting the changed text as a non-conflict in the merge result.
-- 
Copyright (c) 2008 Tony Garnock-Jones <tonyg@lshift.net>
Copyright (c) 2008 LShift Ltd. <query@lshift.net>
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction,including without limitation the rights to use, copy, modify, merge,publish, distribute, sublicense, and/or sell copies of the Software,and to permit persons to whom the Software is furnished to do so,subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
'
!

!Diff3ExclusiveVisitor class methodsFor:'documentation'!

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
    A Diff3ExclusiveVisitor is used by Diff3 to construct a three-way SequenceableCollection 
    merge that resolves 'false conflicts' (a.k.a 'accidental clean merges') by accepting the 
    changed text as a non-conflict in the merge result.

    [author:]
        Tony Garnock-Jones <tonyg@lshift.com>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!Diff3ExclusiveVisitor methodsFor:'as yet unclassified'!

isTrueConflictBetween: left and: right
	"A conflict is 'false' when, from a particular ancestral snippet, both the left and right branches have changed to have the same contents. In some circumstances this can be treated as a clean merge; in others, it's actually an exception that needs to be dealt with. See http://revctrl.org/AccidentalCleanMerge."
	left length = right length ifFalse: [^true].
	(left extractFrom: (files at: #left)) = (right extractFrom: (files at: #right)) ifFalse: [^true].
	^false
!

left: left original: original right: right
	(self isTrueConflictBetween: left and: right)
		ifTrue: [super left: left original: original right: right]
		ifFalse: [self side: #left chunk: left]
! !

!Diff3ExclusiveVisitor class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libtool/Diff3ExclusiveVisitor.st,v 1.2 2014-02-25 07:00:15 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libtool/Diff3ExclusiveVisitor.st,v 1.2 2014-02-25 07:00:15 cg Exp $'
! !

