"
 COPYRIGHT (c) 1997 eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

InterestConverter subclass:#WeakInterestConverter
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-Models'
!

!WeakInterestConverter class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997 eXept Software AG
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
    these are much like InterestConverters; however, the reference to
    the destination is weak, which allows for them to be garbage collected.

    [author:]
        Claus Gittinger
"
! !

!WeakInterestConverter class methodsFor:'instance creation'!

destination:anObject selector:aSelector
    "create & return an interestConverter, which sends aSelector
     to anObject when a change notification arrives"

    ^ self basicNew destination:anObject selector:aSelector

    "Created: 21.5.1997 / 14:08:49 / cg"
!

destination:anObject selector:aSelector aspect:aspect
    "create & return an interestConverter, which sends aSelector
     to anObject when a change notification for aspect arrives"

    ^ self basicNew destination:anObject selector:aSelector aspect:aspect

    "Created: 21.5.1997 / 14:08:49 / cg"
! !

!WeakInterestConverter methodsFor:'accessing'!

aspect
    "return my aspect (if any)"

    ^ aspect

    "Created: 21.5.1997 / 14:08:49 / cg"
!

destination
    "return my destination"

    ^ destination at:1
!

destination:dest selector:sel
    "set destination and selector"

    destination := WeakArray with:dest.
    selector := sel

    "Created: 21.5.1997 / 14:08:49 / cg"
!

destination:dest selector:sel aspect:a
    "set destination, selector and aspect"

    destination := WeakArray with:dest.
    selector := sel.
    aspect := a

    "Created: 21.5.1997 / 14:08:49 / cg"
! !

!WeakInterestConverter methodsFor:'change & update'!

update:something with:aParameter from:someObject
    |realDestination|

    (aspect isNil or:[aspect == something]) ifTrue:[
        realDestination := destination at:1.
        realDestination notNil ifTrue:[
            realDestination perform:selector
        ]
    ]

    "Modified: 8.3.1996 / 22:41:53 / cg"
    "Created: 21.5.1997 / 14:08:49 / cg"
! !

!WeakInterestConverter class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/WeakInterestConverter.st,v 1.4 2011-09-29 11:19:04 cg Exp $'
! !
