"
 COPYRIGHT (c) 1994 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"

"{ Package: 'stx:libbasic' }"

ExternalStream subclass:#UnboundedExternalStream
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Streams-External'
!

!UnboundedExternalStream class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1994 by Claus Gittinger
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
    This class provides common protocol for all external streams which are
    unbound in size (i.e. have no end). Examples of these are PipeStream,
    Sockets, TTYStreams etc.

    [author:]
	Claus Gittinger
"
! !

!UnboundedExternalStream methodsFor:'redefind basic'!

position
    "report an error that this stream has no concept of position"

    self shouldNotImplement
!

position:anInteger
    "report an error that this stream has no concept of position"

    self shouldNotImplement
!

size
    "report an error that this stream has no concept of size"

    self shouldNotImplement
! !

!UnboundedExternalStream class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/UnboundedExternalStream.st,v 1.9 2015-04-21 16:06:59 cg Exp $'
! !



