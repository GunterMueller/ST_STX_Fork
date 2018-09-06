"{ Package: 'stx:goodies/communication/dolphinHTTP' }"

SZReadWriteSocketStream subclass:#SZLoggingSocketStream
	instanceVariableNames:'logStream lastOperation'
	classVariableNames:''
	poolDictionaries:''
	category:'Dolphin-Spt-HTTP-Support'
!

SZLoggingSocketStream comment:'I can be used in place of a SwazooStream. I logs everything read and written to me.
'
!


!SZLoggingSocketStream methodsFor:'accessing'!

log
	^logStream contents
!

next: count 
        | ans |
        ans := super next: count.
        self doLogRead: [logStream nextPutAll: ans asString].
        ^ans

    "Created: / 05-10-2011 / 17:05:30 / cg"
!

next: count into: aSequenceableCollection startingAt: startAt
        | ans |
        ans := super 
                                next: count
                                into: aSequenceableCollection
                                startingAt: startAt.
        self doLogRead: [logStream nextPutAll: ans asString].
        ^ans

    "Modified: / 05-10-2011 / 17:09:43 / cg"
!

next: size putAll: aSequenceableCollection startingAt: start
        | ans |
        ans := super 
                                next: size
                                putAll: aSequenceableCollection
                                startingAt: start.
        self doLogWrite: [logStream nextPutAll: aSequenceableCollection asString].
        ^ans

    "Modified: / 05-10-2011 / 17:09:47 / cg"
!

nextPutAll:aCollection
        | ans |
        ans := super nextPutAll:aCollection.
        self doLogWrite: [logStream nextPutAll: aCollection asString].
        ^ans

    "Created: / 05-10-2011 / 17:06:34 / cg"
!

readStream: aReadStream writeStream: aWriteStream
	super readStream: aReadStream writeStream: aWriteStream.
	self resetLogStream.
! !

!SZLoggingSocketStream methodsFor:'accessing-bytes'!

nextBytes: aNumber
        | ans |
        ans := super nextBytes: aNumber.
        self doLogRead: [logStream nextPutAll: ans asString].
        ^ans

    "Modified: / 05-10-2011 / 17:09:22 / cg"
!

nextPutByte: anInteger
        | ans |
        ans := super nextPutByte: anInteger.
        self doLogWrite: [logStream nextPut: (Character value: anInteger)].
        ^ans

    "Modified: / 05-10-2011 / 17:09:30 / cg"
!

nextPutBytes: aByteArray
        | ans |
        ans := super nextPutBytes: aByteArray.
        self doLogWrite: [logStream nextPutAll: aByteArray asString].
        ^ans

    "Modified: / 05-10-2011 / 17:09:34 / cg"
! !

!SZLoggingSocketStream methodsFor:'accessing-string'!

next
        | ans |
        ans := super next.
        self doLogRead: [logStream nextPut: ans].
        ^ans

    "Modified: / 05-10-2011 / 17:09:16 / cg"
!

nextByte
        | ans |
        ans := super nextByte.
        self doLogRead: [logStream nextPutAll: ans printString].
        ^ans

    "Created: / 05-10-2011 / 17:05:44 / cg"
! !

!SZLoggingSocketStream methodsFor:'operations'!

doLog: operation
	logStream notNil ifTrue: [operation value]
!

doLogRead: operation
        logStream notNil ifTrue: [
            lastOperation == #read ifFalse:[
                lastOperation notNil ifTrue:[ logStream cr ].
                logStream nextPutLine:'*********** Read ************'.
                lastOperation := #read.
            ].
            operation value
        ]

    "Created: / 05-10-2011 / 17:09:00 / cg"
!

doLogWrite: operation
        logStream notNil ifTrue: [
            lastOperation == #write ifFalse:[
                lastOperation notNil ifTrue:[ logStream cr ].
                logStream nextPutLine:'*********** Write ************'.
                lastOperation := #write.
            ].
            operation value
        ]

    "Created: / 05-10-2011 / 17:09:09 / cg"
!

resetLogStream
	logStream := WriteStream on: String new.
! !

!SZLoggingSocketStream class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/SZLoggingSocketStream.st,v 1.2 2011-10-05 16:22:36 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/SZLoggingSocketStream.st,v 1.2 2011-10-05 16:22:36 cg Exp $'
! !
