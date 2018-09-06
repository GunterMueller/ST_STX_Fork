"
 COPYRIGHT (c) 2008 by Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libview2' }"

ValueHolder subclass:#BooleanValueHolder
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-Models'
!

!BooleanValueHolder class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2008 by Claus Gittinger
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
    a valueHolder holding a boolean.
    Mostly for documentation purposes and the assertion, that only boolean values
    are held. Also provides convenient logical operations.

    [author:]
        Claus Gittinger
"
!

examples 
"
                                                                        [exBegin]
     |b nb|

     b := BooleanValueHolder new.
     nb := b not.
     b value:true.
     nb value.     
     b value:false.
     nb value.     
                                                                        [exEnd]
"
! !

!BooleanValueHolder class methodsFor:'instance creation'!

new
    "return a new BooleanValueHolder holding false as initial value"

    ^ self with:false
! !

!BooleanValueHolder methodsFor:'accessing'!

setValue:aBoolean
    self assert:aBoolean isBoolean.
    value := aBoolean.
! !

!BooleanValueHolder methodsFor:'logical operations'!

& anotherBooleanValueHolder
    "return another valueHolder, which returns the logical and of myself and another valueHolder"

    ^ BooleanBlockValue 
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

    ^ BooleanBlockValue forLogicalNot:self.

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

    ^ BooleanBlockValue 
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

    "Modified (comment): / 27-07-2013 / 09:55:01 / cg"
! !

!BooleanValueHolder class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview2/BooleanValueHolder.st,v 1.4 2013-07-27 08:10:10 cg Exp $'
! !

