"
 COPYRIGHT (c) 2006 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool' }"

"{ NameSpace: Smalltalk }"

SortedCollection subclass:#ParseTreeIndex
	instanceVariableNames:'tree source'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-CodeView-Syntax'
!

SyntaxElement subclass:#Element
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:ParseTreeIndex
!

!ParseTreeIndex class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

documentation
"
    For given parse tree, a ParseTreeIndex provides an
    fast access to individual (leave) nodes by keeping
    an index. Used by CodeView2 for various queries

    Experimental

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!ParseTreeIndex methodsFor:'accessing'!

source
    ^ source
!

source:something
    source := something.
!

tree
    ^ tree
!

tree:aParseNode
    tree := aParseNode.
! !

!ParseTreeIndex methodsFor:'utilities'!

newElementFor: aParseNode

    ^(Element new node: aParseNode)

    "Created: / 16-02-2012 / 21:00:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ParseTreeIndex::Element class methodsFor:'documentation'!

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

!ParseTreeIndex::Element methodsFor:'accessing'!

assigned
    | p |

    ^ node isVariableNode 
        and:[(p := node parent) notNil
            and:[p isAssignment
                and:[p variable == node]]].

    "Created: / 01-07-2013 / 21:53:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-02-2014 / 20:52:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

name
    ^node isVariable ifTrue:[node name] ifFalse:[nil]

    "Created: / 01-07-2013 / 21:56:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

start
    ^ node startPosition

    "Modified: / 16-02-2012 / 20:56:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

stop
    ^ node endPosition

    "Modified: / 16-02-2012 / 20:56:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

value
    ^node name
! !

!ParseTreeIndex::Element methodsFor:'comparing'!

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

!ParseTreeIndex::Element methodsFor:'printing & storing'!

printOn:aStream
    "append a printed representation of the receiver to the argument, aStream"

    super printOn:aStream.
    aStream nextPutAll:'('.
    node class name printOn: aStream.
    aStream nextPut:$).

    "Modified: / 21-08-2011 / 09:33:51 / cg"
    "Modified: / 16-02-2012 / 19:23:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ParseTreeIndex::Element methodsFor:'testing'!

isSelector
    ^ node class == SelectorNode

    "Created: / 21-08-2011 / 09:09:19 / cg"
    "Modified: / 16-02-2012 / 21:04:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isSelf
    ^ node isSelf

    "Created: / 21-08-2011 / 09:31:20 / cg"
    "Modified: / 16-02-2012 / 19:25:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ParseTreeIndex class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

