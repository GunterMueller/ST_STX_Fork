"
 COPYRIGHT (c) 2008 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libview2' }"

"{ NameSpace: Smalltalk }"

BlockValue subclass:#BooleanBlockValue
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-Models'
!

!BooleanBlockValue class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2008 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!BooleanBlockValue methodsFor:'logical operations'!

& anotherBooleanValueHolder
    "return another valueHolder, which returns the logical and of myself and another valueHolder"

    ^ self class 
        forLogical:self and:anotherBooleanValueHolder

    "
     |b1 b2 a|

     b1 := BooleanValueHolder new.
     b2 := BooleanValueHolder new.
     a := b1 & b2.
     b1 value:false.
     b2 value:true.
     a value.      
     b1 value:true.
     a value.     
    "
!

logicalNot
    "return another valueHolder, which returns the logical not of myself"

    ^ self class forLogicalNot:self.

    "
     |b nb|

     b := BooleanValueHolder new.
     nb := b not.
     b value:true.
     nb value.     
     b value:false.
     nb value.     
    "
!

| anotherBooleanValueHolder
    "return another valueHolder, which returns the logical or of myself and another valueHolder"

    ^ self class 
        forLogical:self or:anotherBooleanValueHolder

    "
     |b1 b2 o|

     b1 := BooleanValueHolder new.
     b2 := BooleanValueHolder new.
     o := b1 | b2.
     b1 value:false.
     b2 value:false.
     o value.      
     b1 value:true.
     o value.     
    "

    "Modified (comment): / 27-07-2013 / 09:54:54 / cg"
! !

!BooleanBlockValue class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

