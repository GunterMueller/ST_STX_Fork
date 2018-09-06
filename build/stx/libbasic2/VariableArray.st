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

ArrayedCollection subclass:#VariableArray
	instanceVariableNames:'tally contentsArray'
	classVariableNames:''
	poolDictionaries:''
	category:'Obsolete'
!

!VariableArray class methodsFor:'documentation'!

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
    VariableArrays can grow and shrink - in contrast to Arrays which are
    fixed in size. 
    WARNING: Do not use this class for new applications - its a historic 
	     leftover from times when no OrderedCollection existed.

    Use OrderedCollection, which offers more functionality, and is even
    a bit faster in some operations.
"
! !

!VariableArray class methodsFor:'instance creation'!

new
    "return a new VariableArray - with size 0"

    ^ (self basicNew) setInitialContents:(Array new:10)
!

new:size
    "return a new VariableArray"

    ^ (self basicNew) setContents:(Array new:size)
! !

!VariableArray methodsFor:'accessing'!

at:index
    "return the element at index"

    (index between:1 and:tally) ifFalse:[
	^ self subscriptBoundsError:index
    ].
    ^ contentsArray at:index
!

at:index put:anObject
    "set the element at index"

    (index between:1 and:tally) ifFalse:[
	^ self subscriptBoundsError:index
    ].
    ^ contentsArray at:index put:anObject
! !

!VariableArray methodsFor:'enumerating'!

do:aBlock
    "evaluate the argument, aBlock for each element
     in the collection"

    contentsArray from:1 to:tally do:aBlock
!

from:start to:stop do:aBlock
    "evaluate the argument, aBlock for some elements
     in the collection"

    (stop <= tally) ifTrue:[
	contentsArray from:start to:stop do:aBlock
    ] ifFalse:[
	super from:start to:stop do:aBlock
    ]
! !

!VariableArray methodsFor:'filling & replacing'!

replaceFrom:start to:stop with:aCollection startingAt:repStart
    "reimplemented for speed
     - can use Arrays fast replace if aCollection is Array or VariableArray"

    |col|

    col := aCollection.
    (aCollection isKindOf:VariableArray) ifTrue:[
	((stop - start + repStart) <= aCollection size) ifTrue:[
	    col := aCollection getContents
	]
    ].
    (col isMemberOf:Array) ifTrue:[
	(stop <= tally) ifTrue:[
	    contentsArray replaceFrom:start to:stop with:col startingAt:repStart.
	    ^ self
	]
    ].
    ^ super replaceFrom:start to:stop with:aCollection startingAt:repStart
! !

!VariableArray methodsFor:'grow & shrink'!

add:anElement
    "add anElement to the end of the array"

    |newSize "{ Class: SmallInteger }" |

    newSize := tally + 1.
    (newSize <= contentsArray size) ifTrue:[
	tally := newSize
    ] ifFalse:[
	self grow:newSize
    ].
    contentsArray at:tally put:anElement
!

grow:newSize
    "grow to newSize"

    |newArray|

    (newSize == tally) ifTrue:[^ self].

    (newSize > tally) ifTrue:[
	(newSize > contentsArray size) ifTrue:[
	    newArray := Array new:(newSize * 2).
	    newArray replaceFrom:1 to:tally with:contentsArray startingAt:1.
	    contentsArray := newArray
	]
    ] ifFalse:[
	contentsArray from:(newSize + 1) to:tally put:nil
    ].
    tally := newSize
! !

!VariableArray methodsFor:'inquiries'!

isFixedSize
    "return true if the receiver cannot grow - this will vanish once
     Arrays and Strings learn how to grow ..."

    ^ false
!

size
    "return the number of array elements"

    ^ tally
! !

!VariableArray methodsFor:'kludges'!

shallowCopy:anArray
    "return a shallow copy of the receiver
     have to kludge the kludge ... - shallow copy the contents array"

    |newText|

    newText := self class new.
    newText setContents:(contentsArray shallowCopy).
    ^ newText
! !

!VariableArray methodsFor:'private'!

getContents
    "return the contents array"

    ^ contentsArray
!

setContents:anArray
    "set the contents array"

    tally := anArray size.
    contentsArray := anArray
!

setInitialContents:anArray
    "set the contents array but make size zero"

    tally := 0.
    contentsArray := anArray
! !

!VariableArray methodsFor:'removing'!

removeFromIndex:startIndex toIndex:endIndex
    "remove the elements stored at indexes between startIndex and endIndex"

    |newSize|

    (endIndex >= tally) ifTrue:[
	self grow:(startIndex - 1)
    ] ifFalse:[
	newSize := tally - endIndex + startIndex - 1.
	contentsArray replaceFrom:startIndex to:newSize with:contentsArray startingAt:(endIndex + 1).
	self grow:newSize
    ]
! !

!VariableArray methodsFor:'testing'!

identityIndexOf:anElement startingAt:start
    "search the collection for anElement starting search at index start
     using == for compares.
     if found, return the index otherwise return 0"

    |index|

    (start > tally) ifFalse:[
	index := contentsArray identityIndexOf:anElement startingAt:start.
	index == 0 ifFalse:[
	    (index between:1 and:tally) ifTrue:[
		^ index
	    ]
	]
    ].
    ^ 0
!

includes:anObject
    "return true, if the receiver contains the argument, anObject"

    ^ contentsArray includes:anObject
!

indexOf:anElement startingAt:start
    "search the collection for anElement starting search at index start
     using = for compares.
     if found, return the index otherwise return 0"

    |index|

    (start > tally) ifFalse:[
	index := contentsArray indexOf:anElement startingAt:start.
	index == 0 ifFalse:[
	    (index between:1 and:tally) ifTrue:[
		^ index
	    ]
	]
    ].
    ^ 0
!

occurrencesOf:anObject
    "return the number of occurrences of anObject in the receiver"

    ^ contentsArray occurrencesOf:anObject
! !

!VariableArray class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic2/VariableArray.st,v 1.15 1999-09-08 21:28:27 cg Exp $'
! !
