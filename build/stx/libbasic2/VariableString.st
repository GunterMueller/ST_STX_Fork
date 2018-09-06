"
 COPYRIGHT (c) 1993 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"

ArrayedCollection subclass:#VariableString
	instanceVariableNames:'contents'
	classVariableNames:''
	poolDictionaries:''
	category:'Obsolete'
!

!VariableString class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1993 by Claus Gittinger
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
    VariableStrings can grow and shrink - in contrast to Strings which are
    fixed in size - this may change in the future.

    WARNING: This class is a historic leftover and will vanish soon.
	     Dont use it.
"
! !

!VariableString class methodsFor:'instance creation'!

copyFrom:aString
    "return a new VariableString with contents copied from the argument"

    ^ self basicNew setContents:(String copyFrom:aString)
!

new
    "return a new VariableString - with size 0"

    ^ self new:0
!

new:size
    "return a new VariableString"

    ^ (self basicNew) setContents:(String new:size)
! !

!VariableString methodsFor:'accessing'!

at:index
    "return the element at index"

    ^ contents at:index
!

at:index put:anObject
    "set the element at index"

    ^ contents at:index put:anObject
! !

!VariableString methodsFor:'converting'!

asStringCollection
    ^ contents asStringCollection
! !

!VariableString methodsFor:'copying'!

postCopy
    contents := contents copy
! !

!VariableString methodsFor:'error handling'!

doesNotUnderstand:aMessage
    "this is funny: all message we do not understand, are passed
     on to the string - so we do not have to care for all
     possible messages ...(thanks to the Message class)"

     ^ contents perform:(aMessage selector)
	  withArguments:(aMessage arguments)
! !

!VariableString methodsFor:'filling & replacing'!

replaceFrom:start to:stop with:aCollection startingAt:repStart
    "reimplemented for speed
     - can use Strings fast replace if aCollection
       is String or VariableString"

    |col|

    col := aCollection.
    (aCollection isKindOf:VariableString) ifTrue:[
	((stop - start + repStart) <= aCollection size) ifTrue:[
	    col := aCollection getContents
	]
    ].
    (col isMemberOf:String) ifTrue:[
	(stop <= (contents size)) ifTrue:[
	    contents replaceFrom:start to:stop with:col startingAt:repStart.
	    ^ self
	]
    ].
    ^ super replaceFrom:start to:stop with:aCollection startingAt:repStart
! !

!VariableString methodsFor:'grow & shrink'!

grow:newSize
    |old oldSize|

    oldSize := contents size.
    (newSize < oldSize) ifTrue:[
	contents := contents copyTo:newSize
    ] ifFalse:[
	(newSize > oldSize) ifTrue:[
	    old := contents.
	    (newSize > (oldSize * 2)) ifTrue:[
		contents := String new:newSize
	    ] ifFalse:[
		contents := String new:(oldSize * 2)
	    ].
	    contents replaceFrom:1 to:oldSize
			    with:old startingAt:1
	]
    ]
! !

!VariableString methodsFor:'private'!

getContents
    "return the contents array"

    ^ contents
!

setContents:aString
    "set the contents"

    contents := aString
! !

!VariableString methodsFor:'queries'!

isFixedSize
    "return true if the receiver cannot grow - this will vanish once
     Arrays and Strings learn how to grow ..."

    ^ false
!

size
    ^ contents size
! !

!VariableString class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic2/VariableString.st,v 1.17 1999-09-08 21:28:21 cg Exp $'
! !
