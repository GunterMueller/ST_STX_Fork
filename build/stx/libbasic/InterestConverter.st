"
 COPYRIGHT (c) 1996 by Claus Gittinger / eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

Object subclass:#InterestConverter
	instanceVariableNames:'destination selector aspect'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-Models'
!

!InterestConverter class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1996 by Claus Gittinger / eXept Software AG
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
    instances convert update messages into messages as setup via
    #onChangeSend:to:.
    This is a temporary kludge and will be replaced by a more intelligent
    DependencyCollection class in the future.

    [author:]
        Claus Gittinger
"
!

examples
"
  #onChangeSend:to / #retractInterestsIn:
  interested in any change:
                                                                        [exBegin]
    |p b|

    b := [Transcript showCR:'--> notification: point has changed'].

    p := Point new.
    p onChangeSend:#value to:b.
    Delay waitForSeconds:1.
    Transcript showCR:'sending change ...'.
    p changed.
    Transcript showCR:'retracting ...'.
    p retractInterestsFor:b.
    Delay waitForSeconds:1.
    Transcript showCR:'sending change ...'.
    p changed.
                                                                        [exEnd]



  #expressInterestIn:for:sendBack / #retractInterestIn:for:
  interested in a specific change:
                                                                        [exBegin]
     |p b|

     b := [Transcript showCR:'the point changed'].

     p := Point new.
     Transcript showCR:'interest in #foo'.
     p expressInterestIn:#foo for:b sendBack:#value.
     p x:1.
     Transcript showCR:'now changing #bar'.
     p changed:#bar.
     Transcript cr.

     Delay waitForSeconds:1.
     Transcript showCR:'now changing #foo'.
     p changed:#foo.
     Transcript cr.

     Delay waitForSeconds:1.
     Transcript showCR:'no more interest in #foo'.
     p retractInterestIn:#foo for:b.
     Transcript showCR:'now changing #foo'.
     p changed:#foo.
     Transcript cr.

     Delay waitForSeconds:1.
     Transcript showCR:'interest in #bar now'.
     p expressInterestIn:#bar for:b sendBack:#value.
     Transcript showCR:'now changing #foo'.
     p changed:#foo.
     Transcript showCR:'now changing #bar'.
     p changed:#bar.
     Transcript cr.

     Delay waitForSeconds:1.
     Transcript showCR:'interest in #foo now'.
     p expressInterestIn:#foo for:b sendBack:#value.
     Transcript showCR:'now changing #foo'.
     p changed:#foo.
     Transcript showCR:'now changing #bar'.
     p changed:#bar.
     Transcript cr.

     Delay waitForSeconds:1.
     Transcript showCR:'no more interests'.
     p retractInterestsFor:b.
     Transcript showCR:'now changing #foo'.
     p changed:#foo.
     Transcript showCR:'now changing #bar'.
     p changed:#bar.
     Transcript cr.
                                                                        [exEnd]
"
! !

!InterestConverter class methodsFor:'instance creation'!

destination:anObject selector:aSelector
    "create & return an interestConverter, which sends aSelector
     to anObject when a change notification arrives"

    ^ self basicNew destination:anObject selector:aSelector

    "Modified: 21.5.1997 / 11:59:08 / cg"
!

destination:anObject selector:aSelector aspect:aspect
    "create & return an interestConverter, which sends aSelector
     to anObject when a change notification for aspect arrives"

    ^ self basicNew destination:anObject selector:aSelector aspect:aspect

    "Modified: 21.5.1997 / 11:59:26 / cg"
! !

!InterestConverter methodsFor:'accessing'!

aspect
    "return my aspect (if any)"

    ^ aspect

    "Created: 8.3.1996 / 23:00:37 / cg"
    "Modified: 21.5.1997 / 11:59:43 / cg"
!

destination
    ^ destination

    "Created: 7.3.1996 / 10:57:01 / cg"
!

destination:dest selector:sel
    destination := dest.
    selector := sel

    "Created: 7.3.1996 / 10:49:13 / cg"
!

destination:dest selector:sel aspect:a
    destination := dest.
    selector := sel.
    aspect := a

    "Created: 8.3.1996 / 22:42:03 / cg"
!

selector
    ^ selector

    "Created: 7.3.1996 / 10:57:01 / cg"
! !

!InterestConverter methodsFor:'change & update'!

update:something with:aParameter from:someObject
    (aspect isNil or:[aspect == something]) ifTrue:[
        (selector numArgs) == 0 ifTrue:[
            destination perform:selector
        ] ifFalse:[
            destination perform:selector withOptionalArgument:something and:aParameter and:someObject
        ]
    ]

    "Created: 7.3.1996 / 10:14:30 / cg"
    "Modified: 8.3.1996 / 22:41:53 / cg"
! !

!InterestConverter methodsFor:'printing'!

displayOn:aGCOrStream
    "Compatibility
     append a printed desription on some stream (Dolphin,  Squeak)
     OR:
     display the receiver in a graphicsContext at 0@0 (ST80).
     This method allows for any object to be displayed in some view
     (although the fallBack is to display its printString ...)"

    "/ what a kludge - Dolphin and Squeak mean: printOn: a stream;
    "/ ST/X (and some old ST80's) mean: draw-yourself on a GC.
    aGCOrStream isStream ifFalse:[
        ^ super displayOn:aGCOrStream.
    ].

    aGCOrStream 
        nextPutAll:self class name;
        nextPutAll:'(sending '.

    selector storeOn:aGCOrStream.
    aGCOrStream nextPutAll:' to '.
    destination printOn:aGCOrStream.
    aGCOrStream nextPut:$).
! !

!InterestConverter methodsFor:'testing'!

isInterestConverter
    ^ true
! !

!InterestConverter class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/InterestConverter.st,v 1.16 2012-08-03 15:52:54 stefan Exp $'
! !
