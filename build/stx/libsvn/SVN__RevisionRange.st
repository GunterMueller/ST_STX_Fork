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

Object subclass:#RevisionRange
	instanceVariableNames:'start stop'
	classVariableNames:''
	poolDictionaries:''
	category:'SVN-Core'
!

!RevisionRange class methodsFor:'documentation'!

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

!RevisionRange class methodsFor:'instance creation'!

from: start to: stop

    ^self new from: start to: stop

    "Created: / 15-10-2011 / 17:12:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RevisionRange methodsFor:'initialization'!

from: r1 to: r2

    start := r1.
    stop := r2

    "Created: / 15-10-2011 / 17:13:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RevisionRange methodsFor:'printing & storing'!

printOn:aStream
    "append a printed representation of the receiver to the argument, aStream"

    start printOn: aStream.
    aStream nextPut:$:.
    stop printOn: aStream.

    "Created: / 15-03-2008 / 23:23:23 / janfrog"
    "Modified: / 15-10-2011 / 17:13:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RevisionRange class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !
