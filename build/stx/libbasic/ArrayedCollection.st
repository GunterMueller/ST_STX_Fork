"
 COPYRIGHT (c) 1989 by Claus Gittinger
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

SequenceableCollection subclass:#ArrayedCollection
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Abstract'
!

!ArrayedCollection class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1989 by Claus Gittinger
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
    ArrayedCollection is an abstract superclass for all collections where
    the elements can be accessed via an integer index,
    AND the collection is a fixed size collection.

    Those fixed size collections cannot easily grow, since they store the
    elements directly within the object and a grow operation can only be done
    by #becoming another object.
    (many other collections keep a reference to the physical container,
     which can be easily replaced)

    [Warning:]
        currently, ST/X supports growing fix-size collections
        (such as Arrays, ByteArrays and Strings).
        However, this is done in a very slow way (using #become).
        Become is a very slow operation in a direct-pointer Smalltalk system
        (which ST/X and many other 'modern' Smalltalks are).

        Therefore, you SHOULD rewrite any application that does this,
        to make use of OrderedCollections or any other collection which can grow fast.
        To remind you of that, a warning message is sent to stdErr,
        whenever such an operation is performed (see #grow).

        Also note that some other Smalltalk systems do NOT allow
        fix size collection to change their size, and that future
        ST/X versions may be changed to trigger an error
        (instead of a warning) in those situations.

    [author:]
        Claus Gittinger

    [see also:]
        OrderedCollection Array
"
! !

!ArrayedCollection class methodsFor:'instance creation'!

newFrom:aCollection 
    "Return an instance of me containing the same elements as aCollection."

    |newArray idx sz|

    sz := aCollection size.
    newArray := self new:sz.
    aCollection isSequenceable ifTrue:[
        newArray replaceFrom:1 to:sz with:aCollection startingAt:1
    ] ifFalse:[
        idx := 1.
        aCollection do:[:element | 
            newArray at:idx put:element.
            idx := idx + 1.
        ].
    ].
    ^ newArray

    "
     Array newFrom: #[1 2 3]
     #[1 2 3] as: Array      
     #[1 2 3] as: ByteArray  
     #($c  $h  $r) as: String 
     #($c  $h  $r) as: Text
    "
!

newWithSize:size
    "return a new collection of size.
     For variable size collections, this is different from #new:,
     in that #new: creates an empty collection with preallocated size,
     while #withSize: creates a non empty one."

    ^ self new:size.

    "
     (OrderedCollection new:10)  
     (OrderedCollection newWithSize:10) 
     (Array new:10) 
     (Array newWithSize:10) 
    "
!

with:element
    "return a new SequenceableCollection with one element:anObject"

    |newCollection|

    newCollection := self new:1.
    newCollection at:1 put:element.
    ^newCollection

    "
     OrderedCollection with:1
     SortedCollection with:99 
    "
!

with:first with:second
    "return a new SequenceableCollection with two elements"

    |newCollection|

    newCollection := self new:2.
    newCollection at:1 put:first; at:2 put:second.
    ^newCollection

    "
     OrderedCollection with:1 with:2
     SortedCollection with:99 with:3
     Array with:1 with:2
    "

    "Modified: 22.1.1997 / 19:35:43 / cg"
!

with:a1 with:a2 with:a3
    "return a new SequenceableCollection with three elements"

    |newCollection|

    newCollection := self new:3.
    newCollection at:1 put:a1; at:2 put:a2; at:3 put:a3.
    ^ newCollection

    "
     OrderedCollection with:1 with:2 with:3
     Array with:1 with:2 with:3
    "

    "Modified: 22.1.1997 / 19:35:47 / cg"
!

with:a1 with:a2 with:a3 with:a4
    "return a new SequenceableCollection with four elements"

    |newCollection|

    newCollection := self new:4.
    newCollection at:1 put:a1; at:2 put:a2; at:3 put:a3; at:4 put:a4.
    ^ newCollection

    "
     OrderedCollection with:1 with:2 with:3 with:4
     Array with:1 with:2 with:3 with:4
    "

    "Modified: 22.1.1997 / 19:35:52 / cg"
!

with:a1 with:a2 with:a3 with:a4 with:a5
    "return a new SequenceableCollection with five elements"

    |newCollection|

    newCollection := self new:5.
    newCollection at:1 put:a1; at:2 put:a2; at:3 put:a3; at:4 put:a4;
                  at:5 put:a5.
    ^ newCollection

    "
     OrderedCollection with:1 with:2 with:3 with:4 with:5
     Array with:1 with:2 with:3 with:4 with:5
    "

    "Modified: 22.1.1997 / 19:35:57 / cg"
!

with:a1 with:a2 with:a3 with:a4 with:a5 with:a6
    "return a new SequenceableCollection with six elements"

    |newCollection|

    newCollection := self new:6.
    newCollection at:1 put:a1; at:2 put:a2; at:3 put:a3; at:4 put:a4;
                  at:5 put:a5; at:6 put:a6.
    ^ newCollection

    "
     OrderedCollection with:1 with:2 with:3 with:4 with:5 with:6
     Array with:1 with:2 with:3 with:4 with:5 with:6
    "

    "Modified: 22.1.1997 / 19:36:03 / cg"
!

with:a1 with:a2 with:a3 with:a4 with:a5 with:a6 with:a7
    "return a new SequenceableCollection with seven elements"

    |newCollection|

    newCollection := self new:7.
    newCollection at:1 put:a1; at:2 put:a2; at:3 put:a3; at:4 put:a4;
                  at:5 put:a5; at:6 put:a6; at:7 put:a7.
    ^ newCollection

    "
     OrderedCollection with:1 with:2 with:3 with:4 with:5 with:6 with:7
     Array with:1 with:2 with:3 with:4 with:5 with:6 with:7
    "

    "Modified: 22.1.1997 / 19:36:20 / cg"
!

with:a1 with:a2 with:a3 with:a4 with:a5 with:a6 with:a7 with:a8
    "return a new SequenceableCollection with eight elements"

    |newCollection|

    newCollection := self new:8.
    newCollection at:1 put:a1; at:2 put:a2; at:3 put:a3; at:4 put:a4;
                  at:5 put:a5; at:6 put:a6; at:7 put:a7; at:8 put:a8.
    ^ newCollection

    "
     OrderedCollection with:1 with:2 with:3 with:4 with:5 with:6 with:7 with:8
     Array with:1 with:2 with:3 with:4 with:5 with:6 with:7 with:8
    "

    "Modified: 22.1.1997 / 19:35:21 / cg"
!

with:a1 with:a2 with:a3 with:a4 with:a5 with:a6 with:a7 with:a8 with:a9
    "return a new SequenceableCollection with nine elements"

    |newCollection|

    newCollection := self new:9.
    newCollection at:1 put:a1; at:2 put:a2; at:3 put:a3; at:4 put:a4;
                  at:5 put:a5; at:6 put:a6; at:7 put:a7; at:8 put:a8;
                  at:9 put:a9.
    ^ newCollection

    "
     OrderedCollection with:1 with:2 with:3 with:4 with:5 with:6 with:7 with:8 with:9
     Array with:1 with:2 with:3 with:4 with:5 with:6 with:7 with:8w ith:9
    "

    "Created: / 14-02-2012 / 17:43:07 / cg"
!

withAll:aCollection
    "return a new Collection with all elements taken from the argument,
     aCollection"

    |newCollection newSize
     index "{ Class: SmallInteger }" |

    newSize := aCollection size.
    newCollection := self new:newSize.
    aCollection isSequenceable ifTrue:[
        "/
        "/ aCollection has indexed elements
        "/ a block-replace may be faster
        "/
        newCollection replaceFrom:1 to:newSize with:aCollection startingAt:1
    ] ifFalse:[
        "/
        "/ must enumerate the elements individually
        "/
        index := 1.
        aCollection do:[:element |
            newCollection at:index put:element.
            index := index + 1
        ]
    ].
    ^ newCollection

    "
     OrderedCollection withAll:#(1 2 3 4 5)
     SortedCollection withAll:#(99 17 53 1 101) 
    "

    "Modified: 13.4.1996 / 12:14:38 / cg"
! !

!ArrayedCollection class methodsFor:'queries'!

growIsCheap
    "return true, if this collection can easily grow
     (i.e. without a need for become:).
     Since this is the superclass of all indexed fix-size collections,
     return false here."

    ^ false
!

isAbstract
    "Return if this class is an abstract class.
     True is returned for ArrayedCollection here; false for subclasses.
     Abstract subclasses must redefine this again."

    ^ self == ArrayedCollection
! !

!ArrayedCollection methodsFor:'adding & removing'!

addAll:aCollection
    "add all elements of the argument, aCollection to the receiver.
     Returns the argument, aCollection (sigh).

     Redefined here, to perform only a single slow grow operation"

    |mySize|

    mySize := self size.
    self grow:mySize + aCollection size.

    aCollection do:[:element |
        mySize := mySize + 1.
        self at:mySize put:element
    ].
    ^ aCollection

    "
        #(1 2 3 4) addAll:#(5 6 7 8); yourself
    "
!

removeAll
    "{ Pragma: +optSpace }"

    "remove all elements from the receiver. Returns the receiver.

     For ArrayedCollections (which are actually fixed-size collections),
     this is a slow operation, since a #become: is required to update
     all owners. Better use a collection which is prepared for growing
     (i.e. an OrderedCollection).
     We output a warning message here, to remind you about that."

    'ArrayedCollection [info]: slow removeAll operation (' infoPrint.
    self class name infoPrint. ')' infoPrintCR.

    self become:(self copyEmpty)

    "
     #(1 2 3 4 5) copy removeAll    
     #(1 2 3 4 5) removeAll    
    "

    "Modified: 10.1.1997 / 15:14:55 / cg"
! !

!ArrayedCollection methodsFor:'copying'!

copyEmptyAndGrow:size
    "return a new instance of the receiver's species with size
     nilled elements and any named instance variables copied."

    "Performance optimization for classes like Array, String, ...,
     which have no named instance vars"

    self class instSize == 0 ifTrue:[
        ^ self species new:size
    ].
    ^ super copyEmptyAndGrow:size
! !

!ArrayedCollection methodsFor:'error handling'!

fixedSizeError
    "{ Pragma: +optSpace }"

    "report an error that size of the collection cannot be changed.
     This is not used right now (instead, a warning is sent to stderr
     in the #grow method); however, future versions of ST/X may no longer
     allow fixed size collection to grow.
     Read the documentation on why things are that way ..."

    ^ self error:'cannot change size'

    "Modified: 18.7.1996 / 21:39:09 / cg"
! !

!ArrayedCollection methodsFor:'growing'!

grow:newSize
    "grow the receiver i.e. cut off everything after newSize.
     Warning: this may be a slow operation due to the use of become 
     - you should write your collection classes to avoid the use of become. 
     You have been warned."

    |newArray oldSize|

    oldSize := self size.
    (newSize ~~ oldSize) ifTrue:[
        InfoPrinting ifTrue:[
            "/
            "/ output a warning - you should rewrite your application
            "/ to use some collection which implements grow: more efficient
            "/ (i.e. use OrderedCollection instead of Array ..)
            "/
            'ArrayedCollection [warning]: slow grow operation (' errorPrint.
            self class name infoPrint. ') ' errorPrintCR.
            Context showWhereWeCameFrom.
        ].

        newArray := self species new:newSize.
        newArray replaceFrom:1 to:(newSize min:oldSize) with:self.
        self become:newArray.
    ]

    "
     #(1 2 3 4 5 6) add:7
     #(1 2 3 4 5 6) remove:5 
     #(1 2 3 4 5 6) copy grow:3  
     #(1 2 3 4 5 6) copy grow:10  
     'hello world' copy grow:5   
     'hello' copy grow:20   
    "

    "Modified: 10.1.1997 / 15:14:43 / cg"
! !


!ArrayedCollection methodsFor:'printing & storing'!

storeOn:aStream
    "output a printed representation (which can be re-read with readFrom:)
     onto the argument aStream. Redefined to output index access."

    |index "{ Class: SmallInteger }"|

    thisContext isRecursive ifTrue:[
        RecursiveStoreError raiseRequestWith:self.
        'ArrayedCollection [error]: storeOn: of self referencing collection.' errorPrintCR.
        aStream nextPutAll:'#recursive'.
        ^ self
    ].

    aStream nextPutAll:'(('; nextPutAll:self class name; nextPutAll:' new:'.
    self size printOn:aStream.
    aStream nextPutAll:')'.
    index := 1.
    self do:[:element |
        aStream nextPutAll:' at:'. index printOn:aStream. aStream nextPutAll:' put:('.
        element storeOn:aStream.
        aStream nextPutAll:');'.
        index := index + 1
    ].
    index > 1 ifTrue:[aStream nextPutAll:' yourself'].
    aStream nextPut:$)

    "
     (Array with:(1@2) with:(1->2)) storeString    
    "

    "Modified: 28.1.1997 / 00:39:59 / cg"
! !

!ArrayedCollection methodsFor:'queries'!

size
    "redefined to re-enable size->basicSize forwarding
     (it is caught in SequencableCollection)"

    ^ self basicSize
!

speciesForAdding
     "redefined here, since grow is not cheap.
      Used by functions which create a growing collection (see collect:with:, for example)"

    ^ OrderedCollection
! !

!ArrayedCollection class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

