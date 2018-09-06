"
 COPYRIGHT (c) 2010 by Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic3' }"

Array variableSubclass:#TraceBuffer
	instanceVariableNames:'accessLock writeIndex'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Debugging-Support'
!

!TraceBuffer class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2010 by Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"

    "Created: / 30-11-2010 / 16:21:33 / cg"
!

documentation
"
    simple round robin tracebuffer for system debugging.
"

    "Created: / 30-11-2010 / 16:21:57 / cg"
!

examples
"
    |buffer|

    buffer := self new:100.
    buffer dumpLast:5 on:Transcript.
    buffer trace:1.
    buffer trace:2.
    buffer trace:3.
    buffer dumpLast:5 on:Transcript.
    buffer trace:4.
    buffer trace:5.
    buffer dumpLast:5 on:Transcript.
    buffer trace:6.
    buffer trace:7.
    buffer trace:8.
    buffer dumpLast:5 on:Transcript.
"

    "Created: / 30-11-2010 / 16:11:55 / cg"
! !

!TraceBuffer class methodsFor:'instance creation'!

new:n
    "return an initialized instance"

    ^ (self basicNew:n*2) initialize.

    "Created: / 30-11-2010 / 16:13:25 / cg"
! !

!TraceBuffer methodsFor:'dumping'!

dumpLast:n on:aStream
    |count idx entry time|

    count := 0.
    idx := writeIndex.

    aStream showCR:'-----------------'.
    [
        [ count <= n ] whileTrue:[
            idx == 0 ifTrue:[
                idx := self size.
                idx == 0 ifTrue:[ ^ self ].
            ].
            time := self at:idx.
            entry := self at:idx-1.
            entry isNil ifTrue:[^ self ].
            aStream show:time; show:' '; showCR:entry.
            idx := idx - 2.
            count := count + 1.
        ].
    ] ensure:[
        aStream showCR:'-----------------'.
    ]

    "Created: / 30-11-2010 / 16:10:00 / cg"
! !

!TraceBuffer methodsFor:'initialization'!

initialize  
    writeIndex := 0.
    accessLock := Semaphore forMutualExclusion.

    "Created: / 30-11-2010 / 16:06:47 / cg"
! !

!TraceBuffer methodsFor:'tracing'!

trace:something
    accessLock critical:[
        writeIndex == self size ifTrue:[
            writeIndex := 0.
        ].
        self at:writeIndex+1 put:something.
        self at:writeIndex+2 put:(OperatingSystem getMicrosecondTime).
        writeIndex := writeIndex + 2.
    ].

    "Created: / 30-11-2010 / 16:07:52 / cg"
! !

!TraceBuffer class methodsFor:'documentation'!

version_CVS
    ^ '§Header: /cvs/stx/stx/libbasic3/TraceBuffer.st,v 1.2 2010/12/03 09:08:31 stefan Exp §'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '§Id: TraceBuffer.st 1909 2012-03-31 00:14:49Z vranyj1 §'
! !

