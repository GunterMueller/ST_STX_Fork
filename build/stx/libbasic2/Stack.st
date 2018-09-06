"
 COPYRIGHT (c) 1996 by Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic2' }"

"{ NameSpace: Smalltalk }"

OrderedCollection subclass:#Stack
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Ordered'
!

!Stack class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1996 by Claus Gittinger
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
    A simple implementation of a Stack.

    Notice, this is simply syntactic sugar - all functionality is
    already provided by the OrderedCollection class 
    (addLast <==> push / removeLast <==> pop / last <==> top)

    [author:]
        Stefan Vogel

    [see also:]
        OrderedCollection Queue
"
!

examples
"
  push-push-....
                                                                [exBegin]
    |aStack|

    aStack := Stack new.
    Transcript showCR:aStack.
    Transcript showCR:'push 1: '.
    aStack push:1.
    Transcript showCR:'push 2: '.
    aStack push:2.
    Transcript showCR:'push 3: '.
    aStack push:3.
    Transcript showCR:aStack.
    Transcript show:'pop: '; showCR:(aStack pop).
    Transcript show:'pop: '; showCR:(aStack pop).
    Transcript show:'pop: '; showCR:(aStack pop).
    Transcript showCR:aStack.
                                                                [exEnd]

  popping too many:
                                                                [exBegin]
    |aStack|

    aStack := Stack new.
    aStack push:1.

    aStack pop.
    aStack pop.
                                                                [exEnd]
"
! !

!Stack class methodsFor:'instance creation'!

new

    ^ self new:100
! !

!Stack methodsFor:'accessing'!

pop
    "Answer the object on top of the stack."

    ^ self removeLast
!

pop: numElem 
    "Pop and discard top numElems and answer the receiver.
     Caveat: pop: is a misleading name; should propably be called drop:"

    self removeLast:numElem
!

push: anObject 
    "Push anObject onto the top of the stack."

    ^ self add:anObject
!

top
    "Answer (without removing) the object on top of the stack."

    ^ self last
! !

!Stack methodsFor:'enumerating'!

do: aBlock
    "Evaluate aBlock for each object on the stack, from top to bottom."

    super reverseDo:aBlock
!

reverseDo: aBlock
    "Evaluate aBlock for each object on the stack, from bottom to top."

    super do:aBlock
! !

!Stack class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic2/Stack.st,v 1.10 2015-02-03 14:17:52 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic2/Stack.st,v 1.10 2015-02-03 14:17:52 cg Exp $'
! !

