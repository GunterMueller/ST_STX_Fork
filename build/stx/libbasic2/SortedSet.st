"
 COPYRIGHT (c) 2012 by eXept Software AG
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

OrderedSet subclass:#SortedSet
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Sequenceable'
!

!SortedSet class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2012 by eXept Software AG
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
    I am a subclass of Set whose elements are ordered in a
    similar fashion to SortedCollection.
    That is, I have both Set behavior (only keeping a single instance of
    an element) but I also remember the sort order.

    I have one additional instance variable:

    order <SortedCollection>        Sorted collection of values reflecting the order 
                                    in the set. 

    [caveat:]
        a tree may be a better choice, 
        as although the set shows O(1) behavior when adding,
        the sortedCollection does not (especially as inserting is expensive). 
        A balanced tree would show O(lg n) behavior.

    [author:]
        Claus Gittinger

    [see also:]
        OrderedCollection 
        Dictionary OrderedDictionary
        Set Bag
"
!

examples
"
                                                                    [exBegin]
        |s|

        s := SortedSet new.
        s add:'one'.
        s add:'two'.
        s add:'one'.
        s add:'two'.
        s add:'three'.
        s size.         
        s do:[:each | Transcript showCR:each].         
                                                                    [exEnd]


                                                                    [exBegin]
        |s|

        s := SortedSet new.
        s add:'one'.
        s add:'two'.
        s add:'one'.
        s add:'two'.
        s add:'three'.
        s remove:'one'.
        s size.         
        s do:[:each | Transcript showCR:each].         
                                                                    [exEnd]

                                                                    [exBegin]
        |s|

        s := SortedSet new.
        s add:'one'.
        s add:'two'.
        s add:'three'.
        s add:'one'.
        s add:'two'.
        s add:'three'.
        s size.         
        Transcript showCR:s.         
        s removeFirst.
        Transcript showCR:s.         
        s removeFirst.
        Transcript showCR:s.         
        s removeFirst.
        Transcript showCR:s.         
                                                                    [exEnd]
"
! !

!SortedSet class methodsFor:'instance creation'!

sortBlock:aBlock
    "return a new sortedSet, whe the sort order is defined by aBlock.
     This must be a two-argument block which returns true if its arg1 has to come before
     its arg2 in the collection."

    ^ self new setSortBlock:aBlock

    "Created: / 06-08-2012 / 12:34:29 / cg"
! !

!SortedSet methodsFor:'accessing'!

sortBlock
    ^ order sortBlock
! !

!SortedSet methodsFor:'adding & removing'!

addFirst:anObject 
    "blocked; only the sort order determines the order"

    self shouldNotImplement

    "Modified: / 06-08-2012 / 12:37:23 / cg"
!

addLast:anObject 
    "blocked; only the sort order determines the order"

    self shouldNotImplement

    "Modified: / 06-08-2012 / 12:37:30 / cg"
! !

!SortedSet methodsFor:'enumerating'!

collect:aBlock
    "for each element in the receiver, evaluate the argument, aBlock
     and return a new collection with the results"

    |newCollection|

    newCollection := self speciesForAdding new.
    newCollection setSortBlock:self sortBlock.
    self do:[:element | newCollection add:(aBlock value:element)].
    ^ newCollection

    "
     #(1 2 3 4) collect:[:e | e odd]   
     (1 to:10) collect:[:e | e even]     
    "

    "Modified: / 07-08-2010 / 16:26:40 / cg"
!

select:aBlock
    "return a new collection with all elements from the receiver, for which
     the argument aBlock evaluates to true.
     See also: #removeAllFoundIn: and #removeAllSuchThat:"

    |newCollection|

    newCollection := self speciesForAdding new.
    newCollection setSortBlock:self sortBlock.
    self do:[:each |
        (aBlock value:each) ifTrue:[newCollection add:each].
    ].
    ^ newCollection

    "
     #(1 2 3 4) select:[:e | e odd]   
     (1 to:10) select:[:e | e even]     
    "

    "Modified: / 07-08-2010 / 16:26:40 / cg"
! !

!SortedSet methodsFor:'initialization'!

initializeOrder:anInteger
    order := SortedCollection new:anInteger

    "Created: / 06-08-2012 / 12:33:31 / cg"
!

setSortBlock:aBlock
    order sortBlock:aBlock

    "Created: / 06-08-2012 / 12:35:07 / cg"
! !

!SortedSet class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

