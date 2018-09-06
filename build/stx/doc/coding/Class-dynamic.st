"{ NameSpace: CodingExamples }"

Object subclass:#Stack
	instanceVariableNames:'contents'
	classVariableNames:''
	poolDictionaries:''
	category:'examples-Classes-dynamic'
!

Stack subclass:#EmptyStack
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:Stack
!

!Stack class methodsFor:'documentation'!

documentation
"
    'dynamic inheritance change' - demonstration
    --------------------------------------------

    this is a little demo of dynamic change in inheritance - its
    not a very good example, and (in smalltalk) dynamically changing
    inheritance is somewhat uncommon .... (in contrast to self)
    So this is NOT an example of good programming style, but instead
    a little demo (and test) that it can be done ....

    Here, we a Stack-class and a subclass called EmptyStack.
    Instances change their class Stack <-> EmptyStack, whenever their 
    emptyness state changes.

    The interesting things is that the emptyCheck is fully done
    by dynamic inheritance - instead of checking the contents.
    (also the pop in Stack does not need an empty check, while a pop
     in EmptyStack is an unconditional error)


    Note:
        this is an academic example - not caring for performance (message
        lookup caches) and style (readability and debuggability).
        We do not recommend this coding style in normal applications.
"



!

examples
"
    Try this:
                                                                [exBegin]
    |s|

    s := Stack new.      
    Transcript cr.
    Transcript show:'(Stack new) -> '; showCR:s.
    s push:1.
    s push:2.
    Transcript show:'after push: '; showCR:s.
    Transcript show:'empty: '; showCR:(s isEmpty).
    Transcript show:'size: '; showCR:(s size).
    s pop.
    s pop.
    Transcript show:'after pop: '; showCR:s.
    Transcript show:'empty: '; showCR:(s isEmpty).
    Transcript show:'size: ';  showCR:(s size).
                                                                [exEnd]
"



! !

!Stack class methodsFor:'instance creation'!

new
    ^ super new initContents
! !

!Stack methodsFor:'accessing'!

pop
    "no need to check for empty content here"

    |o|

    o := contents removeLast.
    contents isEmpty ifTrue:[
        "I became an empty stack"
        self changeClassTo:EmptyStack
    ].
    ^ o

    "Modified: 23.1.1997 / 00:33:35 / cg"
!

push:anObject
    contents addLast:anObject
! !

!Stack methodsFor:'private'!

initContents
    contents := OrderedCollection new.

    "I am actually an empty stack"
    self changeClassTo:EmptyStack
! !

!Stack methodsFor:'testing'!

isEmpty
    "newer empty - no need to check here"

    ^ false

    "Modified: 23.1.1997 / 00:33:19 / cg"
!

size
    ^ contents size
! !

!Stack::EmptyStack methodsFor:'accessing'!

pop
    "no need to check contents here - always empty"

    ^ self error:'empty stack'

    "Created: 23.1.1997 / 00:32:27 / cg"
    "Modified: 23.1.1997 / 00:33:51 / cg"
!

push:anObject
    "no longer an empty stack"
    self changeClassTo:Stack.
    self push:anObject

    "Created: 23.1.1997 / 00:32:19 / cg"
! !

!Stack::EmptyStack methodsFor:'testing'!

isEmpty
    "always empty - no need to check here"

    ^ true

    "Created: 23.1.1997 / 00:32:43 / cg"
    "Modified: 23.1.1997 / 00:33:02 / cg"
!

size
    "always empty - no need to check here"

    ^ 0

    "Created: 23.1.1997 / 00:32:49 / cg"
    "Modified: 23.1.1997 / 00:33:06 / cg"
! !

!Stack class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/doc/coding/Class-dynamic.st,v 1.7 1997-01-22 23:45:58 cg Exp $'
! !
