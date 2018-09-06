"
 COPYRIGHT (c) 2010 by Jan Vrany, SWING Research Group. CTU in Prague
              All Rights Reserved

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
"{ Package: 'stx:goodies/smallsense' }"

"{ NameSpace: SmallSense }"

Magnitude subclass:#ParseTreeIndexEntry
	instanceVariableNames:'next prev start stop node'
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Core-Index'
!

!ParseTreeIndexEntry class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2010 by Jan Vrany, SWING Research Group. CTU in Prague
              All Rights Reserved

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

!ParseTreeIndexEntry methodsFor:'accessing'!

assigned
    ^false

    "Created: / 01-07-2013 / 21:53:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

firstElementInChain
    |first prev|

    first := self.
    [ (prev := first previousElement) notNil ] whileTrue:[
        first := prev.
    ].
    ^ first

    "Created: / 21-08-2011 / 09:51:35 / cg"
!

name
    ^node isVariable ifTrue:[node name] ifFalse:[nil]

    "Created: / 01-07-2013 / 21:56:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-10-2013 / 12:22:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

next
    ^ next
!

next:aSyntaxElement
    next := aSyntaxElement.
    next prev: self.

    "Modified: / 14-02-2010 / 17:44:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

nextElement
    ^ next

    "Created: / 21-08-2011 / 09:47:11 / cg"
!

nextElement:aSyntaxElement
    next := aSyntaxElement.
    next prev: self.

    "Modified: / 14-02-2010 / 17:44:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 21-08-2011 / 09:47:15 / cg"
!

node
    ^ node
!

node:something
    node := something.
!

prev
    ^ prev
!

prev:aSyntaxElement
    prev := aSyntaxElement.
!

previousElement
    ^ prev

    "Created: / 21-08-2011 / 09:47:23 / cg"
!

previousElement:aSyntaxElement
    prev := aSyntaxElement.

    "Created: / 21-08-2011 / 09:47:28 / cg"
!

start
    ^ start notNil ifTrue:[start] ifFalse:[node startPosition]

    "Modified: / 24-09-2013 / 03:01:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

start:something
    start := something.
!

stop
    ^ stop notNil ifTrue:[stop] ifFalse:[node endPosition]

    "Modified: / 24-09-2013 / 03:01:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

stop:something
    stop := something.
! !

!ParseTreeIndexEntry methodsFor:'comparing'!

< anObject

    anObject isNumber ifTrue:[^self stop < anObject].
    anObject class == self class ifFalse:[^false].

    ^self stop < anObject start

    "Created: / 14-02-2010 / 13:39:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

= anObject

    anObject class == self class ifFalse:[^false].

    ^self start == (anObject start) and:
        [self stop == (anObject stop) and:
            [self node class == (anObject node class)]].

    "Created: / 14-02-2010 / 13:33:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hash

    ^self start hash bitXor:[self stop hash bitXor:[node class hash]].

    "Created: / 14-02-2010 / 13:30:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ParseTreeIndexEntry methodsFor:'double dispatching'!

lessFromInteger:anInteger

    ^self stop < anInteger

    "Created: / 14-02-2010 / 13:49:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ParseTreeIndexEntry methodsFor:'printing & storing'!

printOn:aStream
    "append a printed representation if the receiver to the argument, aStream"

    super printOn:aStream.
    aStream nextPutAll:'('.
    self start printOn: aStream.
    aStream nextPutAll: ' - '.
    self stop printOn: aStream.
    aStream space.
    node class name printOn: aStream.
    aStream nextPut:$).

    "Modified: / 21-08-2011 / 09:33:51 / cg"
    "Modified: / 30-09-2013 / 09:12:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ParseTreeIndexEntry methodsFor:'testing'!

isClassVariable
    ^ node isVariable and:[node isClassVariable]
!

isGlobal
    ^ node isGlobal

    "Created: / 24-09-2013 / 02:50:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isInstanceVariable
    ^node isVariable and:[node isInstanceVariable]

    "Created: / 01-07-2013 / 21:54:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isSelector
    ^ node isSelector

    "Created: / 21-08-2011 / 09:09:19 / cg"
    "Modified: / 24-09-2013 / 02:57:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isSelf
    ^ node isSelf

    "Created: / 21-08-2011 / 09:31:20 / cg"
    "Modified: / 16-02-2012 / 19:25:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isVariable
    ^ node isVariable

    "Created: / 21-08-2011 / 09:09:00 / cg"
    "Modified: / 16-02-2012 / 19:24:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isVariableOrSelf
    ^ self isVariable or:[self isSelf]

    "Created: / 21-08-2011 / 09:31:33 / cg"
! !

!ParseTreeIndexEntry class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/smallsense/SmallSense__ParseTreeIndexEntry.st,v 1.2 2015-02-06 08:56:30 stefan Exp $'
!

version_CVS
    ^ '$Path: stx/goodies/smallsense/SmallSense__ParseTreeIndexEntry.st, Version: 1.0, User: stefan, Time: 2015-02-06T09:56:01.970+01$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

