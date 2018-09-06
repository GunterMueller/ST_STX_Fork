"
 COPYRIGHT (c) 1994 by Claus Gittinger
 COPYRIGHT (c) 2016 Jan Vrany
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libcomp' }"

"{ NameSpace: Smalltalk }"

Object subclass:#Switch
	instanceVariableNames:'expressions values default'
	classVariableNames:''
	poolDictionaries:''
	category:'Programming-Support'
!

!Switch class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1994 by Claus Gittinger
 COPYRIGHT (c) 2016 Jan Vrany
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
     OBSOLETE: do not use it, it is slow. You can also consider the Squeak extension Object>>#caseOf:
     from the libcompat package.

     This class provides a switch-expression facility.
     Consider this a demo example, nested if's are much more
     efficient.

     example:

        |a b|

        a := 1.
        b := 2.

        (Switch new)
            if:[a > b] then:['a is greater than b'];
            if:[a < b] then:['a is less than b'];
            otherwise:['a same as b'];
            value
    "
! !

!Switch class methodsFor:'instance creation'!

new
    ^ self basicNew initialize
! !

!Switch methodsFor:'cases'!

if:expr then:block
    expressions add:expr.
    values add:block
!

otherwise:block
    default := block
! !

!Switch methodsFor:'evaluation'!

value
    1 to:expressions size do:[:index |
	(expressions at:index) value ifTrue:[
	    ^ (values at:index) value
	]
    ].
    ^ default value
! !

!Switch methodsFor:'initialization'!

initialize
    expressions := OrderedCollection new.
    values := OrderedCollection new.
! !

!Switch class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcomp/Switch.st,v 1.8 2013-08-06 09:50:31 stefan Exp $'
! !

