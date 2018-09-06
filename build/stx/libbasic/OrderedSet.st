"
 COPYRIGHT (c) 2001 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

Set subclass:#OrderedSet
	instanceVariableNames:'order'
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Sequenceable'
!

!OrderedSet class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2001 by eXept Software AG
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
    similar fashion to OrderedCollection.
    That is, I have both Set behavior (only keeping a single instance of
    an element) but I also remember the original order, in which elements
    were added.
    Therefore, this combines fast access/check/add via hashing with a defined 
    order when enumerating.

    [instance variables:]
        order <OrderedCollection>       Ordered collection of values reflecting the order 
                                        in the set. 

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

        s := OrderedSet new.
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

        s := OrderedSet new.
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

        s := OrderedSet new.
        s add:'one'.
        s addFirst:'two'.
        s addFirst:'three'.
        s add:'one'.
        s add:'two'.
        s add:'three'.
        s size.         
        s do:[:each | Transcript showCR:each].         
                                                                    [exEnd]
"
! !

!OrderedSet class methodsFor:'instance creation'!

new:anInteger
    ^ (super new:anInteger) initializeOrder:anInteger
! !

!OrderedSet methodsFor:'accessing'!

at:index
    "return the indexed instance variable with index, anInteger.
     Report an error, if the index is wrong."

    ^ order at:index

    "Modified: / 16.11.2001 / 10:27:40 / cg"
!

at:index ifAbsent:exceptionalValue
    "return the indexed instance variable with index, anInteger.
     If not present, return the value from exceptionalValue."

    ^ order at:index ifAbsent:exceptionalValue

    "Modified: / 16.11.2001 / 10:27:40 / cg"
!

order
    "returns the values in the order of their appearance"

    ^ order

    "
     |s|

     s := OrderedSet new.
     s add:'aaa'; add:'bbb'; add:'ccc'; add:'ddd'; add:'aaa'.
     s order
    "
! !

!OrderedSet methodsFor:'adding & removing'!

add:anObject 
    "Add anObject to the receiver (if not already included). 
     Also, remember in the order (i.e. add to the end)
     If anObject is already present in the set,
     the order will not be changed. (See also: #addLast:)"

    (super testAndAdd:anObject) ifFalse:[
        order add:anObject.
    ].
    ^ anObject

    "
        self new 
                add:1;
                add:2;
                add:nil;
                add:1;
                yourself
    "
!

addFirst:anObject 
    "Add anObject to the receiver (if not already included). 
     Also, remember in the order (i.e. add to the beginning)"

    |oldObject|

    (self includes:anObject) ifTrue:[
        "/ must either remove the old one from both and add the new one to both,
        "/ or ensure that the old one is also in the order.
        "/ otherwise, the constraint that the object in the set and the one in the order
        "/ must be identical could be broken.
        oldObject := order remove:anObject.
    ] ifFalse:[
        oldObject := super add:anObject.
    ].
    order addFirst:oldObject.
    ^ anObject

    "
        self new 
                addFirst:1;
                addFirst:nil;
                yourself
    "
!

addLast:anObject 
    "Add anObject to the receiver (if not already included). 
     Also, remember in the order (i.e. add to the end)
     If anAssociation is already present in the receiver,
     it will be moved to the end. (See also: #add:)"

    |oldObject|

    (self includes:anObject) ifTrue:[
        oldObject := order remove:anObject.
    ] ifFalse:[
        oldObject := super add:anObject.
    ].
    order add:oldObject.
    ^ anObject

    "
        self new 
                addLast:1;
                addLast:nil;
                yourself
    "
!

clearContents
    "remove all elements from the receiver, but do not shrink. Returns the receiver."

    super clearContents.
    order clearContents.
!

remove:oldObject ifAbsent:exceptionValueProvider
    "remove oldObject from the collection and return it.
     If it was not in the collection return the value of exceptionValueProvider.

     WARNING: do not remove elements while iterating over the receiver."

    |removedObject|

    removedObject := super remove:oldObject 
                           ifAbsent:[ ^ exceptionValueProvider value].      
    order removeIdentical:removedObject.

    ^ removedObject

    "
        OrderedSet new remove:nil
    "

    "Modified: / 16.11.2001 / 10:21:07 / cg"
!

removeAll
    "remove all elements from the receiver. Returns the receiver."

    super removeAll.
    self initializeOrder:0.

    "Created: / 16.11.2001 / 10:21:40 / cg"
!

removeFirst
    "remove the first object from the collection and return it.
     If it was not in the collection, raise an error.

     WARNING: do not remove elements while iterating over the receiver."

    ^ self removeFirstIfAbsent:[self emptyCollectionError].
!

removeFirstIfAbsent:exceptionalValue
    "remove the first object from the collection and return it.
     If it was not in the collection, return the value from exceptionalValue.

     WARNING: do not remove elements while iterating over the receiver."

    |element|

    order isEmpty ifTrue:[^ exceptionalValue value].
    element := order first.
    ^ self remove:element.
!

removeLast
    "remove the last object from the collection and return it.
     If it was not in the collection, raise an error.

     WARNING: do not remove elements while iterating over the receiver."

    ^ self removeLastIfAbsent:[self emptyCollectionError].
!

removeLastIfAbsent:exceptionalValue
    "remove the last object from the collection and return it.
     If it was not in the collection, return the value from exceptionalValue.

     WARNING: do not remove elements while iterating over the receiver."

    |lastElement|

    order isEmpty ifTrue:[^ exceptionalValue value].
    lastElement := order last.
    ^ self remove:lastElement.
!

safeRemove:oldObject ifAbsent:exceptionValueProvider
    "remove the element, oldObject from the collection.
     Return the element 
     (could be non-identical to oldObject, since I hash on equality, not on identity).
     If it was not in the collection return the value of exceptionValueProvider.

     In contrast to #remove:, this does not resize the underlying collection
     and therefore does NOT rehash & change the elements order.
     Therefor this can be used while enumerating the receiver,
     which is not possible if #remove: is used.

     WARNING: since no resizing is done, the physical amount of memory used
              by the container remains the same, although the logical size shrinks.
              You may want to manually resize the receiver using #emptyCheck.
              (after the loop)"

    |removedObject|

    removedObject := super safeRemove:oldObject ifAbsent:[^ exceptionValueProvider value].
    order removeIdentical:removedObject.

    ^ removedObject

    "Created: / 16.11.2001 / 10:23:48 / cg"
    "Modified: / 16.11.2001 / 10:24:03 / cg"
!

testAndAdd:anObject 
    "add the argument, anObject to the receiver.
     Answer true, if the element did already exist in the collection,
     false otherwise.
     Also, remember in the order (i.e. add to the end)
     If anObject is already present in the set,
     the order will not be changed. (See also: #addLast:)"

    (super testAndAdd:anObject) ifFalse:[
        order add:anObject.
        ^ false.
    ].
    ^ true
! !

!OrderedSet methodsFor:'converting'!

asNewOrderedSet
    "make sure to return a unique new set"

    "could be an instance of a subclass..."
    self class == OrderedSet ifTrue:[
        ^ self copy
    ].
    ^ super asOrderedSet
!

asOrderedSet
    "make sure to return a unique new set"

    "could be an instance of a subclass..."
    self class == OrderedSet ifTrue:[
        ^ self.
    ].
    ^ super asOrderedSet
! !

!OrderedSet methodsFor:'copying'!

postCopy
    "have to copy the keyArray too"

    super postCopy.
    order := order copy.

    "Created: / 16.11.2001 / 10:28:50 / cg"
! !

!OrderedSet methodsFor:'enumerating'!

do:aBlock 
    "Evaluate aBlock for each of the sets's values
     in the order they have been added."

    order do:aBlock

    "Modified: / 16.11.2001 / 10:04:00 / cg"
!

doWithIndex:aBlock 
    "Squeak/V'Age compatibility; 
     Evaluate aBlock for each of the sets's values and index
     in the order they have been added."

    order doWithIndex:aBlock

    "Created: / 09-11-2010 / 16:09:17 / cg"
!

reverseDo:aBlock 
    "Evaluate aBlock for each of the sets's values
     in the reverse order they have been added."

    order reverseDo:aBlock
! !

!OrderedSet methodsFor:'initialization'!

initializeOrder:count
    order := OrderedCollection new:count
! !

!OrderedSet methodsFor:'searching'!

findFirst:aBlock ifNone:exceptionValue
    "find the index of the first element, for which evaluation of the argument, aBlock returns true; 
     return its index or the value from exceptionValue if none detected.
     This is much like #detect:ifNone:, however, here an INDEX is returned,
     while #detect:ifNone: returns the element."

    ^ order findFirst:aBlock ifNone:exceptionValue.
!

indexOf:anObject
    ^ order indexOf:anObject.
! !

!OrderedSet class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

