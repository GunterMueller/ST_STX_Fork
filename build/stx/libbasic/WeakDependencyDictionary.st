"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 1997 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

WeakIdentityDictionary subclass:#WeakDependencyDictionary
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Weak'
!

!WeakDependencyDictionary class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997 by Claus Gittinger
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
    A specialized WeakIdentityDictionary, which 'knowns' how
    to get rid of obsolete entries. This is only used with the
    dependency mechanism.

    [author:]
	Claus Gittinger

    [See also:]
	WeakArray WeakIdentityDictionary WeakValueDictionary WeakIdentitySet
"
! !

!WeakDependencyDictionary methodsFor:'private'!

keyContainerOfSize:n
    "return a container for keys of size n.
     use WeakArrays here, but don't make me a dependent of it."

    ^ WeakArray new:n.

    "Modified: / 07-01-1997 / 17:01:15 / stefan"
    "Modified: / 04-08-2012 / 14:55:53 / cg"
! !

!WeakDependencyDictionary methodsFor:'special dependency support'!

removeEmptyDependencyValues
    "special entry for dependency management:
     remove any empty (due to finalization) value WeakArray elements."

    |index t wasBlocked deps o key originalKeyArray|

    "/ careful: this is sent by the finalizer at low prio.
    "/ be prepared for the receiver to change while we walk over
    "/ the value array here ...

"/ 'removeEmptyDependencyValues ...' printCR.

    originalKeyArray := keyArray.

    index := 1.
    [index <= keyArray size] whileTrue:[
	"/ get the size again - it could have changed

	wasBlocked := OperatingSystem blockInterrupts.

	keyArray ~~ originalKeyArray ifTrue:[
	    index := 1. "/ start over
	    "/ 'restart removeEmpty' infoPrintCR.
	    originalKeyArray := keyArray.
	].

	index <= keyArray size ifTrue:[
	    key := keyArray basicAt:index.
	    key class == SmallInteger ifTrue:[
		"/ that one is gone
		key := DeletedEntry.
		keyArray basicAt:index put:key.
		valueArray basicAt:index put:nil.
		tally := tally - 1.
	    ].

	    (key notNil and:[key ~~ DeletedEntry]) ifTrue:[
		deps := valueArray basicAt:index.
		deps notNil ifTrue:[
		    "/ is it an empty WeakArray ?

		    (deps isMemberOf:WeakArray) ifTrue:[
			t := deps findFirst:[:el | el notNil and:[el ~~ 0]].
			t == 0 ifTrue:[
			    "/ yes - nil it
			    valueArray basicAt:index put:nil.
			    keyArray basicAt:index put:DeletedEntry.
			    tally := tally - 1.
			]
		    ] ifFalse:[
		       "/ is it an empty WeakIdSet ?

		       (deps isMemberOf:WeakIdentitySet) ifTrue:[
			    (t := deps size) == 0 ifTrue:[
				"/ yes - nil it
				valueArray basicAt:index put:nil.
				keyArray basicAt:index put:DeletedEntry.
				tally := tally - 1.
"/                            ] ifFalse:[
"/                                t == 1 ifTrue:[
"/                                    "/ careful - it could actually be empty
"/                                    o := deps firstIfEmpty:nil.
"/                                    o notNil ifTrue:[
"/                                        "/ the set lost an object, and shrunk to size 1
"/                                        "/ can now use a WeakArray
"/                                        valueArray basicAt:index put:(WeakArray with:o)
"/                                    ] ifFalse:[
"/                                        key notNil ifTrue:[
"/                                            keyArray basicAt:index put:DeletedEntry.
"/                                            tally := tally - 1.
"/                                        ]
"/                                    ]
"/                                ]
			    ]
			]
		    ]
		] ifFalse:[
		    "/ 'oops: nil value for key' infoPrint. key infoPrintCR.
		    keyArray basicAt:index put:DeletedEntry.
		    tally := tally - 1.
		]
	    ]
	].

	wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
	index := index + 1.
    ].

"/ 'done' printCR.
    "
     Dependencies removeEmptyDependencyValues
    "

    "Created: 9.1.1997 / 00:00:28 / cg"
    "Modified: 27.3.1997 / 15:55:12 / cg"
! !

!WeakDependencyDictionary class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

