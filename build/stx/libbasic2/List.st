"
 COPYRIGHT (c) 1996 by eXept Software AG
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

OrderedCollection subclass:#List
	instanceVariableNames:'dependents'
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Sequenceable'
!

!List class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1996 by eXept Software AG
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
    Lists are mostly like OrderedCollections, but keep their dependents
    locally (which is adding a bit of performance - not functionality).
    In addition, special change notifications are emitted, whenever
    a lists contents is changed.
    Some views (SelectionIn*View and DataSetView) react specially on
    those messages and perform optimized updates.
    (the change messages pass the range-of-change as parameter).

    In ST/X, most functionality is already provided by OrderedCollection,
    so there is not much new stuff found here.
    It has been mostly provided, for ST-80 compatibility,
    where it adds sorting capabilities.

    [caveat:]
        'List' is probably a bad name, which may confuse beginners.
        I have nothing in common with LinkedLists.
        Instances are just regular ordered collections, with the added benefit of
        sending out information about changes.
        Thus, they can be used as a model of textviews or selection list views,
        which need to redraw whenever the contents of the list changes.
        (and Lists not only send out change notifications when modified,
         but also include information about the range of changed elements.
         So the view can optimize its redraws)
        
    [see also:]
        Array OrderedCollection

    [author:]
        Claus Gittinger
"
! !

!List methodsFor:'accessing'!

at:anIndex put:anObject
    "set the element at index, to be anIndex.
     Return anObject (sigh).
     In contrast to OrderedCollection, Lists allow putting an object
     right after the last element and auto-grow in this case;
     however, putting 2 or more indices after the last element is 
     reported as an error."

    |idx "{ Class: SmallInteger }"|

    idx := anIndex + firstIndex - 1.
    ((anIndex < 1) or:[idx > lastIndex]) ifTrue:[
        idx == (lastIndex+1) ifTrue:[
            self makeRoomAtLast.
            lastIndex := lastIndex + 1.
        ] ifFalse:[
            ^ self subscriptBoundsError:anIndex
        ]
    ].
    
    contentsArray basicAt:idx put:anObject.
    dependents size ~~ 0 ifTrue:[self changed:#at: with:anIndex].
    ^ anObject

    "Modified: / 28.1.1998 / 16:44:49 / cg"
!

list
    ^ self
! !

!List methodsFor:'adding & removing'!

add:anObject
    "add the argument, anObject to the end of the collection
     Return the argument, anObject."

    super add:anObject.
    dependents notNil ifTrue:[self changed:#insert: with:(self size)].
    ^ anObject

    "Modified: / 29.1.1998 / 10:52:32 / cg"
!

add:anObject beforeIndex:index
    "add the argument, anObject to the end of the collection.
     Return the receiver (sigh - ST-80 compatibility)."

    super add:anObject beforeIndex:index.
    dependents notNil ifTrue:[self changed:#insert: with:index].
!

addAll:aCollection beforeIndex:index
    "insert all elements of the argument
     Return the receiver."

    super addAll:aCollection beforeIndex:index.
    dependents notNil ifTrue:[
        self changed: #insertCollection: with:(Array with:index with:(aCollection size))
    ]
!

addAll:aCollection from:startIndex to:endIndex beforeIndex:index
    "insert elements start to stop from the argument
     Return the receiver."

    |count idx|

    count := endIndex - startIndex + 1.
    idx := self makeRoomAtIndex:(index + firstIndex - 1) for:count.

    aCollection isSequenceable ifTrue:[
        "/ we are lucky - that thing can count & do bulk copies
        "/ notice: the above may change firstIndex
        contentsArray replaceFrom:idx to:(idx + count - 1) with:aCollection startingAt:startIndex.
    ] ifFalse:[
        self error:'collection must be sequenceable'
    ].
    dependents notNil ifTrue:[
        self changed: #insertCollection: with:(Array with:index with:count)
    ]

    "Modified: / 29.1.1998 / 10:52:57 / cg"
!

addAllLast:aCollection
    "add all elements of the argument, aCollection to the end of the collection.
     Return the argument, aCollection."

    self addAll:aCollection beforeIndex:self size + 1.
    ^ aCollection
!

addFirst:anObject
    "add the argument, anObject to the beginning of the collection.
     Return the argument, anObject."

    super addFirst:anObject.
    dependents notNil ifTrue:[self changed:#insert: with:1].
    ^ anObject

    "Modified: / 29.1.1998 / 10:53:09 / cg"
!

clearContents
    "remove all elements from the collection but keep the contentsArray.
     Useful for huge lists, if the contents will be rebuild soon (using #add:) 
     to a size which is similar to the lists current size.
     Returns the receiver."

     |prevSize|

     prevSize := self size.
     super clearContents.

     prevSize ~~ 0 ifTrue:[
        dependents notNil ifTrue:[
            self changed:#removeFrom: with:(Array with:1 with:prevSize)
        ]
     ]
!

removeAll
    "remove all elements from the collection.
     Returns the receiver."

     |prevSize|

     prevSize := self size.
     super removeAll.

     prevSize ~~ 0 ifTrue:[
        dependents notNil ifTrue:[
            self changed:#removeFrom: with:(Array with:1 with:prevSize)
        ]
     ]

    "Modified: / 29.1.1998 / 10:53:28 / cg"
!

removeAllSuchThat:aBlock
    "remove all elements that meet a test criteria as specified in aBlock.
     The argument, aBlock is evaluated for successive elements and all those,
     for which it returns true, are removed.
     Destructive: modifies the receiver.
     Return a collection containing the removed elements."

    |removedElements|

    removedElements := super removeAllSuchThat:aBlock.
    removedElements notEmpty ifTrue:[
        self changed.
    ].
    ^ removedElements.
!

removeFirst
    "remove the first element from the collection; return the element."

     |deletedObject|

     deletedObject := super removeFirst.
     dependents notNil ifTrue:[self changed:#remove: with:1].
     ^ deletedObject

    "Modified: / 29.1.1998 / 10:53:36 / cg"
!

removeFirst:n
    "remove the first n elements from the collection; 
     Return a collection containing the removed elements."

    |deletedObjects|

    deletedObjects := super removeFirst:n.
    dependents notNil ifTrue:[self changed:#removeFrom: with:(Array with:1 with:n)].
    ^ deletedObjects

    "Modified: / 29.1.1998 / 10:53:40 / cg"
!

removeFirstIfAbsent:exceptionBlock
    "remove the first element from the collection; return the element.
     If there is no element in the receiver collection, return the value from
     exceptionBlock."

    self size > 0 ifTrue:[ ^ self removeFirst ].
    ^ exceptionBlock value

    "Modified: / 21-10-2006 / 23:03:46 / cg"
!

removeFromIndex:startIndex toIndex:stopIndex
    "remove the elements stored under startIndex up to and including
     the elements under stopIndex.
     Return the receiver.
     Returning the receiver here is a historic leftover - it may change."

    |ret|

    stopIndex < startIndex ifTrue:[^ self].

    ret := super removeFromIndex:startIndex toIndex:stopIndex.
    dependents notNil ifTrue:[
        self changed:#removeFrom: with:(Array with:startIndex with:stopIndex).
    ].
    ^ ret

    "Modified: / 29.1.1998 / 10:54:03 / cg"
!

removeIdentical:anObject ifAbsent:exceptionBlock
    "remove the first element which is identical to anObject;
     if found, remove and return it; 
     if not, return the value from evaluating exceptionBlock.
     Uses identity compare (==) to search for the element."

    |index|

    index := self identityIndexOf:anObject.

    index == 0 ifTrue:[ ^ exceptionBlock value ].
    self removeFromIndex:index toIndex:index.
    ^ anObject

    "Modified: / 21-10-2006 / 23:03:29 / cg"
!

removeLast
    "remove the last element from the collection; return the element"

     |deletedObject|

     deletedObject :=  super removeLast.
     dependents notNil ifTrue:[self changed:#remove: with:(1 + self size)].
     ^ deletedObject

    "Modified: / 29.1.1998 / 10:54:15 / cg"
!

removeLast:n
    "remove the last n elements from the receiver collection. 
     Return a collection of removed elements."

    |deletedObjects stop|

    stop := self size.
    deletedObjects := super removeLast:n.
    dependents notNil ifTrue:[
        self changed:#removeFrom: with:(Array with:(stop - n + 1) with:stop).
    ].
    ^ deletedObjects

    "Modified: / 29.1.1998 / 10:54:25 / cg"
!

removeLastIfAbsent:exceptionBlock
    "remove the last element from the collection; return the element.
     If there is no element in the receiver collection, return the value from
     exceptionBlock."

    self size > 0 ifTrue:[ ^ self removeLast ].
    ^ exceptionBlock value

    "Modified: / 21-10-2006 / 23:03:53 / cg"
!

reset
    "logically remove all elements from the collection.
     That's almost the same as #removeAll, but keeps the contentsArray.
     Returns the receiver."

     |prevSize|

     prevSize := self size.
     super reset.

     prevSize ~~ 0 ifTrue:[
        dependents notNil ifTrue:[
            self changed:#removeFrom: with:(Array with:1 with:prevSize)
        ]
     ].
! !

!List methodsFor:'converting'!

asList
    ^ self

    "Created: 14.2.1997 / 16:25:55 / cg"
! !

!List methodsFor:'copying'!

skipInstvarIndexInDeepCopy:index
    "a helper for deepCopy; only indices for which this method returns
     false are copied in a deep copy."

    ^ index == 4    "/ skip dependents
! !

!List methodsFor:'dependents access'!

addDependent:anObject
    "make the argument, anObject be a dependent of the receiver."

    ^ self addNonWeakDependent:anObject
!

dependents 
    "return the dependents of the receiver"

    ^ dependents ? #()

    "Created: / 14.2.1997 / 16:05:49 / cg"
    "Modified: / 27.10.1997 / 19:37:33 / cg"
!

dependents:aCollection
    "set the dependents of the receiver"

    aCollection size == 0 ifTrue:[
        dependents := nil
    ] ifFalse:[
        dependents := aCollection.
    ].

    "Created: / 14.2.1997 / 16:05:58 / cg"
    "Modified: / 29.1.1998 / 10:54:52 / cg"
!

nonWeakDependents
    "return a Collection of dependents - empty if there is none.
     Since all dependencies are nonWeak in List, this is a dummy."

    ^ dependents ? #()
!

nonWeakDependents:newDeps
    "return a Collection of dependents - empty if there is none.
     Since all dependencies are nonWeak in List, this is a dummy."

    ^ self dependents:newDeps

    "Created: / 19.4.1996 / 10:29:43 / cg"
    "Modified: / 30.1.1998 / 14:06:12 / cg"
!

removeDependent:anObject
    "make the argument, anObject be independent of the receiver.
     Since all dependencies are nonWeak in Model, this is simply
     forwarded to removeDependent:"

    ^ self removeNonWeakDependent:anObject
! !

!List methodsFor:'filling & replacing'!

contents:aCollection
    "replace all elements in the receiver by aCollection,
     Redefined - can be done faster"

     |oldSize newSize|

     aCollection isSequenceable ifFalse:[
        ^ super contents:aCollection
     ].

     oldSize := self size.
     newSize := aCollection size.

     newSize < oldSize ifTrue:[
        self replaceFrom:1 to:newSize with:aCollection startingAt:1.
        self removeFromIndex:newSize+1 toIndex:oldSize.
     ] ifFalse:[
        newSize > oldSize ifTrue:[
            oldSize == 0 ifTrue:[
                self addAll:aCollection       
            ] ifFalse:[
                self replaceFrom:1 to:oldSize with:aCollection startingAt:1.
                self addAll:aCollection from:oldSize+1 to:newSize beforeIndex:oldSize+1        
            ]
        ] ifFalse:[
            "/ same size
            oldSize ~~ 0 ifTrue:[
                self replaceFrom:1 to:newSize with:aCollection startingAt:1.
            ]
        ]
     ].

     "
      |l|
      l := List new.
      l contents:#(1 2 3 4 5).
      l        

      |l|
      l := List new.
      l addAll:#(1 2 3 4 5).
      l contents:#(10 20 30).
      l       

      |l|
      l := List new.
      l addAll:#(1 2 3 4 5).
      l contents:#(10 20 30 40 50 60 70 80).
      l      

      |l|
      l := List new.
      l addAll:#(1 2 3 4 5).
      l contents:#(10 20 30 40 50).
      l      
     "
!

list:aCollection
    "replace all elements in the receiver by aCollection.
     For compatibility with other smalltalks 
     (allows List to be sometimes used as a ListPresenter in ported Dolphin apps)"

    self contents:aCollection

    "
     |l|
     l := List new.
     l list:#(1 2 3 4 5).
     l        

     |l|
     l := List new.
     l addAll:#(1 2 3 4 5).
     l list:#(10 20 30).
     l       

     |l|
     l := List new.
     l addAll:#(1 2 3 4 5).
     l list:#(10 20 30 40 50 60 70 80).
     l      

     |l|
     l := List new.
     l addAll:#(1 2 3 4 5).
     l list:#(10 20 30 40 50).
     l      
    "
!

replaceFrom:start to:stop with:aCollection startingAt:repStart
    "replace elements in the receiver between index start and stop,
     with elements  taken from replacementCollection starting at repStart.
     Redefined - can be done faster"

    stop < start ifTrue:[^ self].

    "/ see if there is really any change involved
    (self sameContentsFrom:start to:stop as:aCollection startingAt:repStart) ifTrue:[
        ^ self  "/ avoids useless change notifications
    ].

    super replaceFrom:start to:stop with:aCollection startingAt:repStart.

    dependents notNil ifTrue:[
        self changed:#replace: with:(Array with:start with:stop)
    ].

    "Modified: / 20.5.1998 / 15:20:17 / cg"
!

setContents:aCollection
    "replace the receiver's underlying collection by aCollection"

     aCollection isSequenceable ifFalse:[
        ^ super contents:aCollection
     ].

     contentsArray := aCollection.
     firstIndex := 1.
     lastIndex := aCollection size.
     self changed.
! !

!List methodsFor:'testing'!

isList
    "return true, if the receiver is some kind of list collection;
     true is returned here - the method is redefined from Object."

    ^ true

    "Modified: / 11.2.2000 / 01:37:36 / cg"
! !

!List class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

