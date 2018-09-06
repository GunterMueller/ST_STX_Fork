"
 COPYRIGHT (c) 1999 by eXept Software AG
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

ValueHolder subclass:#ValueHolderWithWeakDependents
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-Models'
!

!ValueHolderWithWeakDependents class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1999 by eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!ValueHolderWithWeakDependents methodsFor:'dependents access'!

addDependent:anObject
    "make the argument, anObject be a weak dependent of the receiver"

    |wasBlocked|

    wasBlocked := OperatingSystem blockInterrupts.
    [
	|deps dep|

	deps := dependents.
	"/
	"/ store the very first dependent directly in
	"/ the dependents instVar
	"/
	(deps isNil and:[anObject isCollection not]) ifTrue:[
	    dependents := WeakArray with:anObject
	] ifFalse:[
	    deps class == WeakArray ifTrue:[
		dep := deps at:1.
		dep ~~ anObject ifTrue:[
		    (dep isNil or:[dep class == SmallInteger]) ifTrue:[
			deps at:1 put:anObject
		    ] ifFalse:[
			self dependents:(WeakIdentitySet with:dep with:anObject)
		    ]
		]
	    ] ifFalse:[
		deps add:anObject
	    ]
	]
    ] ensure:[
	wasBlocked ifFalse:[
	    OperatingSystem unblockInterrupts
	]
    ]

    "Modified: 8.1.1997 / 23:40:30 / cg"
!

dependentsDo:aBlock
    "evaluate aBlock for all of my dependents"

    |deps|

    deps := dependents.
    deps size ~~ 0 ifTrue:[
	deps do:[:d |
		    (d notNil and:[d class ~~ SmallInteger]) ifTrue:[
			aBlock value:d
		    ]
		]
    ].

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
        |deps n dep|

        deps := dependents.
        deps size ~~ 0 ifTrue:[
            "/ to save a fair amount of memory in case of
            "/ many dependencies, we store a single dependent in
            "/ a WeakArray, and switch to a WeakSet if more dependents are
            "/ added. Here we have to do the inverse ...

            deps class == WeakArray ifTrue:[
                ((dep := deps at:1) == anObject
                 or:[dep isNil
                 or:[dep class == SmallInteger]]) ifTrue:[
                    dependents := nil
                ]
            ] ifFalse:[
                dep := deps remove:anObject ifAbsent:[].
                "if dep is nil, nothing has changed"
                dep notNil ifTrue:[
                    (n := deps size) == 0 ifTrue:[
                        dependents := nil
                    ] ifFalse:[
                        n == 1 ifTrue:[
                            dep := deps firstIfEmpty:nil.
                            dep notNil ifTrue:[
                                deps := WeakArray with:dep
                            ] ifFalse:[
                                deps := nil
                            ].
                            dependents := deps.
                        ]
                    ]
                ].
            ]
        ]
    ] ensure:[
        wasBlocked ifFalse:[
            OperatingSystem unblockInterrupts
        ]
    ]

    "Modified: / 26.1.1998 / 19:51:50 / cg"
! !

!ValueHolderWithWeakDependents class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

