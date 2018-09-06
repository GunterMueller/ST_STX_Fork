"
 COPYRIGHT (c) 2006 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic2' }"

"{ NameSpace: Smalltalk }"

Collection subclass:#SharedCollection
	instanceVariableNames:'accessLock realCollection'
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Support'
!

!SharedCollection class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
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
    Instances of this class provide synchronized access (of multiple processes) 
    to a collection.

    Notice: 
        the message-forwarding is done by catching subclassResponsibility and
        doesNotUnderstand errors.

    For performance, and for more complex operation-atomicy, more messages might need
    an explicit handling. 
    See the implementation of #at: / #at:put: and #size for examples.

    [auhor:]
        Claus Gittinger

    [see also:]
        Semaphore RecursionLock
        SharedQueue
        #synchronized: method in Object.
"
!

examples
"
                                        [exBegin]
        |c|

        c := SharedCollection for:(OrderedCollection new).
        c add:1.
        c add:2.
        c add:3.
        c addAll:#(4 5 6).
        c removeFirst.
        c removeLast.
        c inspect.
                                        [exEnd]

                                        [exBegin]
        |c|

        c := SharedCollection for:(Array new:10).
        c at:1 put:5.
        c replaceFrom:2 to:5 with:#(20 30 40 50).
        c inspect.
                                        [exEnd]
"
! !

!SharedCollection class methodsFor:'instance creation'!

for:aCollection
    ^ self new initializeFor:aCollection
! !

!SharedCollection methodsFor:'converting'!

asSharedCollection
    ^ self.
! !

!SharedCollection methodsFor:'copying'!

shallowCopy
    "analog to species - copy the real collection"

    |rslt|

    accessLock critical:[
        "get a consistent copy"
        rslt := realCollection shallowCopy
    ].
    ^ rslt.
! !

!SharedCollection methodsFor:'initialization'!

initializeFor:aCollection
    accessLock := RecursionLock new.
    realCollection := aCollection.
! !

!SharedCollection methodsFor:'message forwarding'!

add:anElement
    "add the argument, anObject to the receiver.
     Return the added element."

    |rslt|

    accessLock critical:[
        rslt := realCollection add:anElement
    ].
    ^ rslt
!

at:index
    |rslt|

    accessLock critical:[
        rslt := realCollection at:index
    ].
    ^ rslt
!

at:index put:value
    |rslt|

    accessLock critical:[
        rslt := realCollection at:index put:value
    ].
    ^ rslt
!

do:aBlock
    |rslt|

    accessLock critical:[
        rslt := realCollection do:aBlock
    ].
    ^ rslt

    "Created: / 22-11-2010 / 21:01:21 / cg"
!

doesNotUnderstand:aMessage
    "catches everything not understood by the collection protocol"

    |rslt|

    accessLock critical:[
        rslt := aMessage sendTo:realCollection
    ].
    ^ rslt

    "Modified: / 07-12-2006 / 17:38:30 / cg"
!

isEmpty
    |rslt|

    accessLock critical:[
        rslt := realCollection isEmpty
    ].
    ^ rslt

    "Created: / 22-11-2010 / 20:59:01 / cg"
!

notEmpty
    |rslt|

    accessLock critical:[
        rslt := realCollection notEmpty
    ].
    ^ rslt

    "Created: / 22-11-2010 / 20:59:06 / cg"
!

remove:someElement ifAbsent:aBlock
    |rslt|

    accessLock critical:[
        rslt := realCollection remove:someElement ifAbsent:aBlock
    ].
    ^ rslt

    "Created: / 25-01-2017 / 22:57:32 / stefan"
!

removeAllSuchThat:aBlock
    |rslt|

    accessLock critical:[
        rslt := realCollection removeAllSuchThat:aBlock
    ].
    ^ rslt

    "Created: / 22-11-2010 / 20:59:27 / cg"
!

removeIdentical:someElement ifAbsent:aBlock
    |rslt|

    accessLock critical:[
        rslt := realCollection removeIdentical:someElement ifAbsent:aBlock
    ].
    ^ rslt

    "Created: / 22-11-2010 / 21:00:33 / cg"
!

size
    |rslt|

    accessLock critical:[
        rslt := realCollection size
    ].
    ^ rslt
!

subclassResponsibility
    "catches every required message of the collection protocol"

    |msg rslt|

    msg := thisContext sender message.
    accessLock critical:[
        rslt := msg sendTo:realCollection
    ].
    ^ rslt
! !

!SharedCollection methodsFor:'queries'!

species
    "returns non shared collection's species"

    ^ realCollection species
! !

!SharedCollection methodsFor:'testing'!

isFixedSize
    "return true if the receiver cannot grow"

    ^ realCollection isFixedSize
! !

!SharedCollection class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

