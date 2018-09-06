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
"{ Package: 'stx:libtool' }"

"{ NameSpace: Smalltalk }"

Magnitude subclass:#SyntaxElement
	instanceVariableNames:'start stop type value next prev node'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-CodeView-Syntax'
!

!SyntaxElement class methodsFor:'documentation'!

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

!SyntaxElement class methodsFor:'instance creation'!

from: start to: stop

    ^self new
        start: start;
        stop: stop.

    "Created: / 14-02-2010 / 13:13:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

from: start to: stop type: type

    ^self new
        start: start;
        stop: stop;
        type: type

    "Created: / 14-02-2010 / 14:09:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

from: start to: stop type: type value: value

    ^self new
        start: start;
        stop: stop;
        type: type;
        value: value

    "Created: / 14-02-2010 / 17:41:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

from: start to: stop type: type value: value assigned:assigned

    ^self new
        start: start;
        stop: stop;
        type: type;
        value: value;
        assigned: assigned

    "Created: / 14-02-2010 / 17:41:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SyntaxElement methodsFor:'accessing'!

firstElementInChain
    |first prev|

    first := self.
    [ (prev := first previousElement) notNil ] whileTrue:[
        first := prev.
    ].
    ^ first

    "Created: / 21-08-2011 / 09:51:35 / cg"
!

lastElementInChain
    |last next|

    last := self.
    [ (next := last nextElement) notNil ] whileTrue:[
        last := next.
    ].
    ^ last
!

next
    <resource: #obsolete>
    "/ please use nextElement: - this is easier to find in the browser

    ^ next
!

next:aSyntaxElement
    <resource: #obsolete>
    "/ please use nextElement: - this is easier to find in the browser

    next := aSyntaxElement.
    next previousElement: self.

    "Modified: / 14-02-2010 / 17:44:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

nextElement
    ^ next

    "Created: / 21-08-2011 / 09:47:11 / cg"
!

nextElement:aSyntaxElement
    next := aSyntaxElement.
    next previousElement: self.

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
    <resource: #obsolete>
    "/ please use nextElement: - this is easier to find in the browser

    ^ prev
!

prev:aSyntaxElement
    <resource: #obsolete>
    "/ please use nextElement: - this is easier to find in the browser

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
    ^ start
!

start:anInteger
    start := anInteger.
!

stop
    ^ stop
!

stop:anInteger
    stop := anInteger.
!

type
    ^ type
!

type:aSymbol
    type := aSymbol.
!

value
    ^ value
!

value:anObject
    value := anObject.
! !

!SyntaxElement methodsFor:'comparing'!

< anObject
    anObject isNumber ifTrue:[^stop < anObject].
    "/ anObject class == self class ifFalse:[^false].

    ^stop < anObject stop

    "Created: / 14-02-2010 / 13:39:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 27-07-2012 / 21:53:22 / cg"
!

= anObject
    anObject class == self class ifFalse:[^false].

    ^start == (anObject start) and:
        [stop == (anObject stop) and:
            [type == (anObject type)]].

    "Created: / 14-02-2010 / 13:33:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 27-07-2012 / 21:53:24 / cg"
!

hash
    ^start hash bitXor:[stop hash bitXor:[type hash]].

    "Created: / 14-02-2010 / 13:30:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 27-07-2012 / 21:53:28 / cg"
! !

!SyntaxElement methodsFor:'double dispatching'!

lessFromInteger:anInteger
    ^ self stop < anInteger

    "Created: / 14-02-2010 / 13:49:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 27-07-2012 / 21:53:33 / cg"
! !

!SyntaxElement methodsFor:'printing & storing'!

printOn:aStream
    "append a printed representation of the receiver to the argument, aStream"

    super printOn:aStream.
    aStream nextPutAll:'('.
    type printOn: aStream.
    aStream nextPutAll:' -> '.
    value printOn:aStream.
    aStream nextPut:$[.
    start printOn:aStream.
    aStream nextPutAll:' .. '.
    stop printOn:aStream.
    aStream nextPut:$].
    aStream nextPut:$).

    "Modified: / 25-06-2010 / 13:20:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-08-2011 / 09:33:51 / cg"
! !

!SyntaxElement methodsFor:'queries'!

assigned
    ^ false.
!

isInBlockScope:aBlockScopeOrNil
    ^ node notNil and:[ node block == aBlockScopeOrNil ]
!

isInSameBlockScopeAs:anotherElement
    ^  node notNil and:[ anotherElement isInBlockScope:node block ]
!

isSelector
    ^ type == #selector

    "Created: / 21-08-2011 / 09:09:19 / cg"
!

isSelf
    ^ type == #self

    "Created: / 21-08-2011 / 09:31:20 / cg"
!

isVariableOrSelf
    ^ self isVariable or:[self isSelf]

    "Created: / 21-08-2011 / 09:31:33 / cg"
! !

!SyntaxElement methodsFor:'testing'!

isClassVariable
    ^ node notNil and:[node isVariable and:[node isClassVariable]]
!

isGlobal
    ^ node notNil and:[ node isGlobal ]
!

isInstanceVariable
    ^ node notNil and:[node isVariable and:[node isInstanceVariable]]

    "Created: / 01-07-2013 / 21:54:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isVariable
    ^ node notNil and:[ node isVariable ]

    "Created: / 21-08-2011 / 09:09:00 / cg"
    "Modified: / 16-02-2012 / 19:24:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SyntaxElement class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

