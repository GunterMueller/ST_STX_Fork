"
 COPYRIGHT (c) 1994 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"


ValueHolder subclass:#RangeAdaptor
	instanceVariableNames:'subject rangeStart rangeStop grid'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-Models'
!

!RangeAdaptor class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1994 by eXept Software AG
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
    Range Adaptor is a kind of UpdateAdaptor that can be used to turn an 
    arbitrary number (either an Integer or a Float) into a Float normalized between
    0 and 1.
"


!

examples
"
    scale values 0..1 in the RA to 0..100 in the original model:
                                                                [exBegin]
    |m r|

    m := 0 asValue.
    r := RangeAdaptor on:m start:0 stop:100 grid:1.
    m inspect.
    r inspect.
                                                                [exEnd]
"


! !

!RangeAdaptor class methodsFor:'instance creation'!

on:aSubject start:aStart stop:aStop grid:aGrid
    |inst|

    inst := self new.

    inst subject:aSubject. 
    inst rangeStart:aStart.
    inst rangeStop:aStop.
    inst grid:aGrid.
    ^ inst

    "Modified: 11.10.1997 / 16:29:35 / cg"
!

on:aSubject stop:aStop

    ^ self on:aSubject start:0 stop:aStop grid:nil

!

on:aSubject stop:aStop grid:aGrid

    ^ self on:aSubject start:0 stop:aStop grid:aGrid

! !

!RangeAdaptor methodsFor:'accessing'!

grid
    "return the value of the instance variable 'grid' (automatically generated)"

    ^ grid!

grid:something
    "set the value of the instance variable 'grid' (automatically generated)"

    grid := something.!

rangeStart
    "return the value of the instance variable 'rangeStart' (automatically generated)"

    ^ rangeStart!

rangeStart:something
    "set the value of the instance variable 'rangeStart' (automatically generated)"

    rangeStart := something.!

rangeStop
    "return the value of the instance variable 'rangeStop' (automatically generated)"

    ^ rangeStop!

rangeStop:something
    "set the value of the instance variable 'rangeStop' (automatically generated)"

    rangeStop := something.!

setValue:aNumber
    "physically set my value, without change notifications
    "
    |n|

    n := aNumber.

    subject notNil ifTrue:[
        n := (aNumber * (rangeStop - rangeStart)) + rangeStart.
        grid notNil ifTrue:[n := n roundTo:grid].
        subject setValue:n.
    ].
    super setValue:n
!

subject
    ^ subject

!

subject:aValue

    dependents notNil ifTrue:[
        subject notNil ifTrue:[subject removeDependent:self].
        aValue  notNil ifTrue:[subject addDependent:self].
    ].
    subject := aValue

!

value
    "return my value"

    (subject isNil or:[rangeStart == rangeStop]) ifTrue:[
        ^ 0
    ].
    ^ (subject value  - rangeStart) asFloat / (rangeStop - rangeStart)


!

value:aNumber
    "physically set my value, without change notifications
    "
    |oldValue|

    oldValue := subject value.

    super value:aNumber.

    subject value ~~ oldValue ifTrue:[
        subject changed:#value
    ]
! !

!RangeAdaptor methodsFor:'actions'!

decrement
    "deccrement my value by grid"

    (grid notNil and:[subject notNil]) ifTrue:[
        self value:((subject value - grid) max:rangeStart)
    ]

    "Modified: / 27.7.1998 / 09:53:37 / cg"
!

increment
    "increment my value by grid"

    (grid notNil and:[subject notNil]) ifTrue:[
        self value:((subject value + grid) min:rangeStop)
    ]

    "Modified: / 27.7.1998 / 09:53:28 / cg"
! !

!RangeAdaptor methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    "translate an update from the model into a #value-change
     via my depenedents ..."

    something == #value ifTrue:[
        self changed:#value
    ]
! !

!RangeAdaptor methodsFor:'dependents access'!

addDependent:anObject
    "make the argument, anObject be a dependent of the receiver"

    (subject notNil and:[dependents isNil]) ifTrue:[
        subject addDependent:self
    ].
    super addDependent:anObject

!

release
    "remove all dependencies from the receiver
    "
    (subject notNil and:[dependents notNil]) ifTrue:[
        subject removeDependent:self
    ].
    super release.
!

removeDependent:anObject
    "make the argument, anObject be independent of the receiver
    "
    dependents notNil ifTrue:[
        super removeDependent:anObject.

        dependents isNil ifTrue:[
            subject removeDependent:self
        ]
    ].

! !

!RangeAdaptor methodsFor:'initialization'!

initialize

    super initialize.
    rangeStart := 0.
    rangeStop  := 0.

! !

!RangeAdaptor methodsFor:'private'!

setSubjectsValue:aNewValue

    subject value:aNewValue.
    self changed:#value

! !

!RangeAdaptor class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview2/RangeAdaptor.st,v 1.3 2000-02-05 14:21:30 cg Exp $'
! !
