"
 COPYRIGHT (c) 1996-2015 by Claus Gittinger

 New code and modifications done at SWING Research Group [1]:

 COPYRIGHT (c) 2010-2015 by Jan Vrany, Jan Kurs and Marcel Hlopko
                            SWING Research Group, Czech Technical University in Prague

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 [1] Code written at SWING Research Group contains a signature
     of one of the above copright owners. For exact set of such code,
     see the differences between this version and version stx:libjava
     as of 1.9.2010
"
"{ Package: 'stx:libjava' }"

Object subclass:#JavaNativeMemory
	instanceVariableNames:'chunks defaultMallocatedMemoryChunkSize'
	classVariableNames:'DefaultMallocatedMemoryChunkSize'
	poolDictionaries:''
	category:'Languages-Java-Support'
!

Object subclass:#MallocatedMemoryChunk
	instanceVariableNames:'base size data flist alist'
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaNativeMemory
!

Link subclass:#FreeListEntry
	instanceVariableNames:'start stop'
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaNativeMemory::MallocatedMemoryChunk
!

!JavaNativeMemory class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1996-2015 by Claus Gittinger

 New code and modifications done at SWING Research Group [1]:

 COPYRIGHT (c) 2010-2015 by Jan Vrany, Jan Kurs and Marcel Hlopko
                            SWING Research Group, Czech Technical University in Prague

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 [1] Code written at SWING Research Group contains a signature
     of one of the above copright owners. For exact set of such code,
     see the differences between this version and version stx:libjava
     as of 1.9.2010

"
! !

!JavaNativeMemory class methodsFor:'initialization'!

initialize
    "Invoked at system start or when the class is dynamically loaded."

    "/ please change as required (and remove this comment)

    DefaultMallocatedMemoryChunkSize := 1024 * 1024"1MB"

    "Modified: / 10-07-2012 / 18:54:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaNativeMemory class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!JavaNativeMemory methodsFor:'accessing'!

defaultMallocatedMemoryChunkSize
    ^ defaultMallocatedMemoryChunkSize
!

defaultMallocatedMemoryChunkSize:something
    defaultMallocatedMemoryChunkSize := something.
! !

!JavaNativeMemory methodsFor:'accessing-tests'!

chunks
    "For tests only!!!!!!"
    ^chunks

    "Created: / 11-07-2012 / 09:13:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaNativeMemory methodsFor:'allocation'!

free: address
    (self chunkFor: address) free: address

    "Created: / 10-07-2012 / 18:57:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

malloc: size
    | address chunk |

    chunks do:[:each|
        address := each malloc: size.
        address notNil ifTrue:[ ^ address ]
    ].
    size > defaultMallocatedMemoryChunkSize ifTrue:[
        self breakPoint: #jv.
        chunk := MallocatedMemoryChunk new: size.
    ] ifFalse:[
        chunk := MallocatedMemoryChunk new: defaultMallocatedMemoryChunkSize
    ].
    chunk base: (chunks isEmpty ifTrue:[0] ifFalse:[chunks last base + chunks last size]).
    chunks add: chunk.
    address := chunk malloc: size.
    ^address

    "Created: / 10-07-2012 / 18:45:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaNativeMemory methodsFor:'byte access'!

byteAt:address
    ^(self chunkFor: address) byteAt: address

    "Created: / 09-12-2010 / 17:32:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

byteAt:address put: value
    (self chunkFor: address) byteAt: address put: value

    "Created: / 10-07-2012 / 19:01:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doubleAt:address
    ^(self chunkFor: address) doubleAt: address

    "Created: / 11-07-2012 / 10:13:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doubleAt:address put: value
    (self chunkFor: address) doubleAt: address put: value

    "Created: / 11-07-2012 / 10:13:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sint64At:address
    "Returns signed 64bit integer at given address"
    ^(self chunkFor: address) sint64At: address

    "Created: / 16-07-2012 / 16:00:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sint64At:address put: value
    "Stores signed 64bit integer at given address"
    ^(self chunkFor: address) sint64At: address put: value

    "Created: / 16-07-2012 / 16:00:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaNativeMemory methodsFor:'byte transfer'!

bcopy: dstAddr length: length from: bytearray offset: offset
    (self chunkFor: dstAddr) bcopy: dstAddr length: length from: bytearray offset: offset

    "Created: / 11-07-2012 / 10:34:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

bcopy: srcAddr length: length into: bytearray offset: offset
    (self chunkFor: srcAddr) bcopy: srcAddr length: length into: bytearray offset: offset

    "Created: / 11-07-2012 / 10:32:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

bcopy: srcAddr to: dstAddr length: length
    "The bcopy... method copies n bytes from src to dest.  The result is correct, 
      even when both areas overlap."

    | srcChunk dstChunk |
    srcChunk := self chunkFor: srcAddr.
    dstChunk := self chunkFor: dstAddr.

    srcChunk == dstChunk ifTrue:[
        "/Easy, same chunk
        srcChunk bcopy: srcAddr to: dstAddr length: length.
        ^self.
    ].
    "/ Worse, different chunks...
    self breakPoint: #jv.
    self shouldImplement.

    "Created: / 11-07-2012 / 10:21:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

memset: s value: c length: n
    "The memset() function fills the first n bytes of the memory area pointed to by s with 
     the constant byte c"

     (self chunkFor: s) memset: s value: c length: n

    "Created: / 11-07-2012 / 10:27:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaNativeMemory methodsFor:'error reporting'!

errorSegmentationViolation: message
    self error: message

    "Created: / 10-07-2012 / 18:59:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaNativeMemory methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."

    "/ please change as required (and remove this comment)
    chunks := OrderedCollection new.
    defaultMallocatedMemoryChunkSize := DefaultMallocatedMemoryChunkSize
    "/ super initialize.   -- commented since inherited method does nothing

    "Modified: / 11-07-2012 / 09:11:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaNativeMemory methodsFor:'private'!

chunkFor: address
    ^chunks 
        detect:[:chunk|address between: chunk base + 1 and: chunk base + chunk size]
        ifNone:[ self errorSegmentationViolation: 'No chunk for address ', address printString ].

    "Created: / 10-07-2012 / 18:57:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaNativeMemory::MallocatedMemoryChunk class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self new: 1024 * 1024"1MB"

    "Modified: / 10-07-2012 / 18:36:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

new: size
    "return an initialized instance"

    ^ self basicNew initializeWithSize: size

    "Created: / 10-07-2012 / 18:36:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaNativeMemory::MallocatedMemoryChunk methodsFor:'accessing'!

base
    ^ base
!

base:something
    base := something.
!

size
    ^ size
!

size:something
    size := something.
! !

!JavaNativeMemory::MallocatedMemoryChunk methodsFor:'accessing-tests'!

data
    "For tests only!!!!!!"
    ^ data

    "Modified (comment): / 11-07-2012 / 10:01:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaNativeMemory::MallocatedMemoryChunk methodsFor:'allocation'!

free: gaddress

    "Frees the memory"

    | address aentry aentryPrev |

    address := gaddress - base.
    aentry := alist.
    aentryPrev := nil.
    [ aentry notNil and:[aentry start ~~ address ] ] whileTrue:[
        aentryPrev := aentry.
        aentry := aentry next.
    ].
    aentry isNil ifTrue:[
        self errorFreeingUnallocatedMemory: 'Never allocated'.
        ^self.
    ].

    "/Remove from allocated list
    aentryPrev notNil ifTrue:[
        aentryPrev next: aentry next.
    ] ifFalse:[
        alist := aentry next.
    ].

    flist := self insert: aentry into: flist join: true.

    "/Insert free entry

    "Created: / 07-12-2010 / 23:33:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

malloc: sz

    "Allocate new chunk of memory, size bytes long"

    | fentry aentry |
    fentry := flist.
    [ fentry notNil and:[fentry size < sz] ] whileTrue:[
        fentry := fentry next.
    ].
    fentry isNil ifTrue:[
        ^nil "Not enough memory in this chunk or too fragmented"
    ].

    "/ create allocation entry
    aentry := FreeListEntry new 
                start: fentry start;
                stop:  fentry start + sz - 1.

    "/Update free entry
    (fentry start + sz) > size ifTrue:[
        "No more free memory in this chunk"
        flist := nil
    ] ifFalse:[
        fentry start: fentry start + sz.
    ].
    alist := self insert: aentry into: alist join: false.

    ^aentry start + base

    "Created: / 07-12-2010 / 23:25:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaNativeMemory::MallocatedMemoryChunk methodsFor:'byte access'!

byteAt:address
    ^data at: address - base

    "Created: / 09-12-2010 / 17:32:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

byteAt:address put: value
    data at: address - base put: value

    "Created: / 10-07-2012 / 19:01:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doubleAt:address 
    ^data doubleAt: address - base

    "Created: / 11-07-2012 / 10:12:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doubleAt:address put: value
    data doubleAt: address - base put: value

    "Created: / 11-07-2012 / 10:12:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sint64At:address
    "Returns signed 64bit integer at given address"

    ^data longLongAt: address

    "Created: / 16-07-2012 / 16:00:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sint64At:address put: value
    "Stores signed 64bit integer at given address"

    ^ data longLongAt: address put: value.

    "Created: / 16-07-2012 / 16:00:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaNativeMemory::MallocatedMemoryChunk methodsFor:'byte transfer'!

bcopy: dstAddr length: length from: bytearray offset: offset

    data replaceBytesFrom: dstAddr - base to: dstAddr - base + length - 1 with: bytearray startingAt: offset + 1

    "Created: / 11-07-2012 / 10:36:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

bcopy: srcAddr length: length into: bytearray offset: offset

    bytearray replaceBytesFrom: offset + 1 to: offset + length with: data startingAt: srcAddr - base

    "Created: / 11-07-2012 / 10:33:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

bcopy: srcAddr to: dstAddr length: length
    "The bcopy... method copies n bytes from src to dest.  The result is correct, 
      even when both areas overlap."

    srcAddr == dstAddr ifTrue:[ ^ self ].
    srcAddr < dstAddr ifTrue:[
        (srcAddr + length - 1) < dstAddr ifTrue:[
            "/No overlap"
            data replaceBytesFrom: dstAddr - base to: dstAddr - base + length - 1
                            with: data
                      startingAt: srcAddr - base.
        ] ifFalse:[
            "/Overlap
            self breakPoint: #jv.
            self shouldImplement
        ].
    ] ifFalse:[
        data replaceBytesFrom: dstAddr - base to: dstAddr - base + length - 1
                        with: data
                  startingAt: srcAddr - base.
    ]

    "Created: / 11-07-2012 / 10:22:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

memset: s value: c length: n
    "The memset() function fills the first n bytes of the memory area pointed to by s with 
     the constant byte c"

     data from: s - base to: s - base + n - 1  put: c

    "Created: / 11-07-2012 / 10:27:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaNativeMemory::MallocatedMemoryChunk methodsFor:'error reporting'!

errorFreeingUnallocatedMemory: message
    self error: message

    "Created: / 10-07-2012 / 18:40:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

errorOutOfMemory: message
    JavaVM throwOutOfMemoryError: message

    "Created: / 10-07-2012 / 18:38:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

errorSegmentationViolation: message
    self error: message

    "Created: / 10-07-2012 / 19:00:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaNativeMemory::MallocatedMemoryChunk methodsFor:'initialization'!

initializeWithSize: sz
    "Invoked when a new instance is created."

    size := sz.
    data:= ByteArray new: sz.
    flist := FreeListEntry new start: 1; stop: sz.
    alist := nil.


    "/ super initialize.   -- commented since inherited method does nothing

    "Created: / 10-07-2012 / 18:37:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaNativeMemory::MallocatedMemoryChunk methodsFor:'private'!

insert: entry into: list join: join
    "Inserts an entry into given list. Returns new
    list. If join is true, possibly adjacent entries are joined"

    | current prev |

    list isNil ifTrue:[ ^ entry ].
    current := list.
    prev := nil.
    [ current notNil and:[ current stop < entry start ] ] whileTrue:[
        prev := current.
        current := current next.
    ].
    prev isNil ifTrue:[
        entry next: current join: join.
        ^entry.
    ].
    prev next: entry join: join.
    entry next: current join: join.
    ^list

    "Created: / 09-07-2012 / 11:29:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaNativeMemory::MallocatedMemoryChunk::FreeListEntry methodsFor:'accessing'!

next
    ^nextLink

    "Created: / 09-07-2012 / 11:57:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

next: next
    self next: next join: false.

    "Created: / 09-07-2012 / 11:58:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

size
    ^stop

    "Created: / 09-07-2012 / 10:49:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

start
    ^ start

    "Created: / 09-07-2012 / 11:23:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

start:something
    start := something.
!

stop
    ^ stop

    "Created: / 09-07-2012 / 11:23:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

stop:something
    stop := something.
! !

!JavaNativeMemory::MallocatedMemoryChunk::FreeListEntry methodsFor:'printing & storing'!

printOn:aStream
    "append a printed representation if the receiver to the argument, aStream"

    super printOn:aStream.
    aStream nextPutAll:'('.
    start printOn:aStream.
    aStream nextPutAll:'..'.
    stop printOn:aStream.
    aStream nextPutAll:')'.

    "Modified: / 09-07-2012 / 11:54:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaNativeMemory::MallocatedMemoryChunk::FreeListEntry methodsFor:'utilities'!

next: next join: join
    (join and:[next notNil]) ifTrue:[
        stop + 1 == next start ifTrue:[
            stop := next stop.
            (nextLink notNil and:[stop + 1 == nextLink start]) ifTrue:[
                stop := nextLink stop.
                nextLink := nextLink next.
            ].
            ^self
        ].
    ].
    nextLink := next.

    "Created: / 09-07-2012 / 11:49:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaNativeMemory class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaNativeMemory.st,v 1.8 2015-03-20 12:08:00 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !


JavaNativeMemory initialize!
