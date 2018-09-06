"
 COPYRIGHT (c) 1992 by Claus Gittinger
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

Object subclass:#Model
	instanceVariableNames:'dependents'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-Models'
!

!Model class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1992 by Claus Gittinger
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
    Models are things which represent information models, i.e. something
    which holds the data for user interface components and on which these operate.
    Basically, instances keep track of which components depend on them and 
    inform the dependents of any changes.

    The Model class itself is abstract and not too useful, see subclasses,
    especially, ValueHolder and SelectionInList.

    Notice:
      Actually the Model class is not really needed; since the dependency
      mechanism is inherited by Object, you can take any object as a model.
      However, instances of Model (and subclasses) keep the dependents locally
      in an instance variable; thus speeding up access a bit.

    [Instance variables:]
        dependents      <Collection>    those objects which depend on me.
                                        To save some storage, a single dependent 
                                        is kept directly here.
                                        Otherwise, if there are multiple dependents,
                                        a collection of dependents is held here.

    [author:]
        Claus Gittinger

    [see also:]
        ValueHolder SelectionInList
        ( introduction to view programming :html: programming/viewintro.html#MVC )
"
! !

!Model class methodsFor:'queries'!

isAbstract
    ^ self == Model
! !

!Model methodsFor:'converting'!

skippedInLiteralEncoding
    "return a Collection with elements which are skipped in the encoding"

    ^ OrderedCollection with:#dependents
! !

!Model methodsFor:'copying'!

postCopy
    "release dependents after copying"

    self dependents:nil
!

skipInstvarIndexInDeepCopy:index
    "a helper for deepCopy; only indices for which this method returns
     false are copied in a deep copy."

    ^ index == 1    "/ skip dependents
! !

!Model methodsFor:'dependents access'!

addDependent:anObject
    "make the argument, anObject be a dependent of the receiver"

    |wasBlocked|

    wasBlocked := OperatingSystem blockInterrupts.
    [
        |deps|

        deps := dependents.
        "/
        "/ store the very first dependent directly in
        "/ the dependents instVar
        "/
        (deps isNil and:[anObject isCollection not]) ifTrue:[
            dependents := anObject
        ] ifFalse:[
            "/
            "/ store more dependents in the dependents collection
            "/
            deps isCollection ifTrue:[
                deps add:anObject
            ] ifFalse:[
                deps == anObject ifFalse:[
                    deps isNil ifTrue:[
                        dependents := (IdentitySet with:anObject)
                    ] ifFalse:[
                        dependents := (IdentitySet with:deps with:anObject)
                    ]
                ]
            ]
        ]
    ] ensure:[
        wasBlocked ifFalse:[
            OperatingSystem unblockInterrupts
        ]
    ]

    "Modified: 8.1.1997 / 23:40:30 / cg"
!

dependents
    "return a Collection of dependents"

    dependents isNil ifTrue:[^ #()].
    dependents isCollection ifTrue:[
        ^ dependents
    ].
    ^ IdentitySet with:dependents

    "Modified: / 26.1.1998 / 11:18:24 / cg"
!

dependents:aCollection
    "set the collection of dependents"

    |dep|

    aCollection size == 1 ifTrue:[
        dep := aCollection first.
        dep isCollection ifFalse:[
            dependents := aCollection first.
            ^ self
        ]
    ].
    dependents := aCollection

    "Modified: 19.4.1996 / 12:23:05 / cg"
!

dependentsDo:aBlock
    "evaluate aBlock for all of my dependents"

    |deps|

    deps := dependents.
    deps notNil ifTrue:[
        deps isCollection ifTrue:[
            deps size == 1 ifTrue:[
                aBlock value:deps anElement
            ] ifFalse:[
                deps copy do:aBlock
            ]
        ] ifFalse:[
            aBlock value:deps
        ]
    ]
!

release
    "remove all dependencies from the receiver"

    dependents := nil

    "Modified: 19.4.1996 / 10:31:35 / cg"
!

removeDependent:anObject
    "make the argument, anObject be independent of the receiver"

    |wasBlocked|

    "/ must do this save from interrupts, since the dependents collection
    "/ is possibly accessed from multiple threads.
    "/ Used to use #valueUninterruptably here; inlined that code for slightly
    "/ faster execution.

    wasBlocked := OperatingSystem blockInterrupts.
    [
        |deps sz dep|

        deps := dependents.
        deps notNil ifTrue:[
            deps isCollection ifTrue:[
                dep := deps remove:anObject ifAbsent:[].
                "if dep is nil, nothing has changed"
                dep notNil ifTrue:[
                    (sz := deps size) == 0 ifTrue:[
                        dependents := nil
                    ] ifFalse:[
                        sz == 1 ifTrue:[
                            (dep := deps first) isCollection ifFalse:[
                                dependents := dep
                            ]
                        ]
                    ].
                ].
            ] ifFalse:[
                deps == anObject ifTrue:[
                    dependents := nil
                ]
            ]
        ]
    ] ensure:[
        wasBlocked ifFalse:[
            OperatingSystem unblockInterrupts
        ]
    ]

    "Modified: 8.1.1997 / 23:41:39 / cg"
! !

!Model methodsFor:'dependents access (non weak)'!

addNonWeakDependent:anObject
    "make the argument, anObject be a dependent of the receiver.
     Since all dependencies are nonWeak in Model, this is simply
     forwarded to addDependent:"

    ^ self addDependent:anObject

    "Created: 19.4.1996 / 10:28:53 / cg"
!

interests
    "return a Collection of interests - empty if there is none.
     Here, we use the normal dependents collection for interests."

    ^ self dependents

    "Created: / 19.4.1996 / 12:28:23 / cg"
    "Modified: / 14.10.1996 / 22:19:58 / stefan"
    "Modified: / 30.1.1998 / 14:07:43 / cg"
!

nonWeakDependents
    "return a Collection of dependents - empty if there is none.
     Since all dependencies are nonWeak in Model, this is a dummy."

    ^ self dependents

    "Created: / 19.4.1996 / 10:29:43 / cg"
    "Modified: / 30.1.1998 / 14:06:17 / cg"
!

removeNonWeakDependent:anObject
    "make the argument, anObject be independent of the receiver.
     Since all dependencies are nonWeak in Model, this is simply
     forwarded to removeDependent:"

    ^ self removeDependent:anObject

    "Created: 19.4.1996 / 12:19:40 / cg"
! !

!Model class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

