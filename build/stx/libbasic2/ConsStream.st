"
 COPYRIGHT (c) 2003 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic2' }"

Stream subclass:#ConsStream
	instanceVariableNames:'list'
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Linked'
!

!ConsStream class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2003 by eXept Software AG
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
    A stream on a list (of conses)
    Conses are not heavily used by Smalltalk (actually: not at all).
    Consider this a demo class.

    [author:]
        Claus Gittinger (Dec 2003)

    [see also:]

"
!

examples
"
                                                                            [exBegin]
    |list s|

    list := Cons fromArray:#(1 2 3 4).   
    s := list readStream.
    [s atEnd] whileFalse:[
        Transcript showCR:(s next).
    ].
                                                                            [exEnd]
                                                                            [exBegin]
    |gen allNumbers s|

    gen := [:n | LazyCons car:n cdr:[ gen value:n+1 ]].
    allNumbers := gen value:1.

    s := allNumbers readStream.
    100 timesRepeat:[
        Transcript showCR:(s next).
    ].
                                                                            [exEnd]
"
! !

!ConsStream class methodsFor:'instance creation'!

on:aCons
    ^ self basicNew list:aCons
! !

!ConsStream methodsFor:'accessing'!

list:something
    list := something.
! !

!ConsStream methodsFor:'reading'!

atEnd
    ^ list isNil 
!

next
    |rslt|

    list isNil ifTrue:[
        ^ self pastEndRead
    ].
    rslt := list car.
    list := list cdr.
    ^ rslt
! !

!ConsStream class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic2/ConsStream.st,v 1.4 2011-09-27 09:42:44 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic2/ConsStream.st,v 1.4 2011-09-27 09:42:44 cg Exp $'
! !
