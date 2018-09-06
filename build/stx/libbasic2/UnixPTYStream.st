"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 1998 by eXept Software AG
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

PipeStream subclass:#UnixPTYStream
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'OS-Unix'
!

!UnixPTYStream class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1998 by eXept Software AG
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
    These are much like PipeStreams, but allow bi-directional communication
    with a Unix command. (i.e. everything written to the PTYStream is seen
    by the commands standard-input, everything written by the command to its
    stdErr or stdOut can be read from me.

    In addition, sending control characters (such as INTR or QUIT),
    will be handled by the command as a signal (unless the command changed
    its standard input to raw mode).

    [author:]
        Claus Gittinger

    [see also:]
        TerminalView
        PipeStream ExternalStream FileStream Socket
        OperatingSystem
"

!

examples
"
  that one is not special (could be done with a PipeStream):
                                                                [exBegin]
    |pty|

    pty := UnixPTYStream to:'ls -l'.
    [pty atEnd] whileFalse:[
        Transcript showCR:(pty nextLine).
    ].
    pty close.
                                                                [exEnd]


  prove (done with a PipeStream):
                                                                [exBegin]
    |pty|

    pty := PipeStream readingFrom:'ls -l'.
    [pty atEnd] whileFalse:[
        Transcript showCR:(pty nextLine).
    ].
    pty close.
                                                                [exEnd]


  but that one is not possible with a PipeStream
  (simulating an editor session):
                                                                [exBegin]
    |pty|

    pty := UnixPTYStream to:'ed'.
    [
        [pty atEnd] whileFalse:[
            Transcript showCR:(pty nextLine).
        ].
        pty close.
    ] forkAt:9.

    pty nextPutLine:'r Make.proto'.
    pty nextPutLine:'1,2d'.
    pty nextPutLine:'1,$s/#/+++++++/'.
    pty nextPutLine:'w xxx'.
    pty nextPutLine:'q'.
                                                                [exEnd]


  and that one is even better ...
  (simulating a login session):
                                                                [exBegin]
    |pty password command|

    pty := UnixPTYStream to:'ssh 127.0.0.1'.
    [
        [pty atEnd] whileFalse:[
            Transcript show:(pty next).
        ].
        pty close.
    ] forkAt:9.

    password := Dialog requestPassword:'password'.
    pty nextPutLine:password.
    command := Dialog request:'command'.
    pty nextPutLine:command.
    pty nextPutLine:'exit'.
                                                                [exEnd]

"
! !

!UnixPTYStream class methodsFor:'instance creation'!

to:commandString
    "create and return a new ptyStream which can read/write to the unix command
     given by commandString."

    ^ (self basicNew) to:commandString

    "unix:
         UnixPTYStream to:'sh'
    "

    "Modified: / 9.7.1998 / 18:26:31 / cg"
! !

!UnixPTYStream class methodsFor:'blocked instance creation'!

readingFrom:commandString
    ^ self shouldNotImplement

    "Created: / 9.7.1998 / 18:25:09 / cg"
    "Modified: / 9.7.1998 / 18:25:34 / cg"
!

readingFrom:commandString errorDisposition:handleError inDirectory:aDirectory
    ^ self shouldNotImplement

    "Modified: / 9.7.1998 / 18:25:31 / cg"
!

readingFrom:commandString inDirectory:aDirectory
    ^ self shouldNotImplement

    "Created: / 9.7.1998 / 18:25:38 / cg"
!

writingTo:commandString
    ^ self shouldNotImplement

    "Created: / 9.7.1998 / 18:25:42 / cg"
!

writingTo:commandString inDirectory:aDirectory
    ^ self shouldNotImplement

    "Created: / 9.7.1998 / 18:25:46 / cg"
! !

!UnixPTYStream methodsFor:'private'!

openPTYFor:aCommandString withMode:openMode inDirectory:aDirectory
    "open a pty to the unix command in commandString"

    |ptyFdArray slaveFd masterFd env remotePipeEnd result osProcess|

    handle notNil ifTrue:[
        "the pipe was already open ...
         this should (can) not happen."
        ^ self errorAlreadyOpen
    ].
        
    lastErrorNumber := nil.
    "stdio lib does not work with blocking pipes and interrupts
     for WIN, Linux, Solaris and probably any other UNIX"
    buffered := false.
    hitEOF := false.
    binary := false.
    
    ptyFdArray := OperatingSystem makePTYPair.
    ptyFdArray isNil ifTrue:[
        lastErrorNumber := OperatingSystem lastErrorNumber.
        ^ self openError:lastErrorNumber.
    ].

    masterFd := ptyFdArray at:1.
    slaveFd := ptyFdArray at:2.

    remotePipeEnd := self class forFileDescriptor:slaveFd mode:#readwrite buffered:false handleType:#pipeFilePointer.

    env := Dictionary new.
    env at:'TERM'  put:'dumb'.
    env at:'SHELL' put:'/bin/sh'.

    osProcess := OSProcess new 
                    command:aCommandString;
                    directory:aDirectory;
                    environment:env;
                    inStream:remotePipeEnd;
                    outStream:remotePipeEnd;
                    errorStream:remotePipeEnd.

    result := osProcess startProcess.

    remotePipeEnd notNil ifTrue:[
        remotePipeEnd close.
    ].

    result ifTrue:[
        self setFileHandle:masterFd mode:openMode.
    ] ifFalse:[
        "the pipe open failed for some reason ...
         ... this may be either due to an invalid command string,
         or due to the system running out of memory (when forking
         the unix process)"
        lastErrorNumber := OperatingSystem lastErrorNumber.
        OperatingSystem closeFd:masterFd.
        ^ self openError:lastErrorNumber.
    ].

    self registerForFinalization.

    "Created: / 9.7.1998 / 20:21:42 / cg"
    "Modified: / 9.7.1998 / 20:28:31 / cg"
!

to:command
    "setup the receiver to read/write to command"

    mode := #readwrite. didWrite := true.
    ^ self openPTYFor:command withMode:ReadWriteMode inDirectory:nil

    "Created: / 9.7.1998 / 18:27:40 / cg"
    "Modified: / 9.7.1998 / 20:22:39 / cg"
! !

!UnixPTYStream methodsFor:'testing'!

atEnd
    ReadErrorSignal handle:[:ex |
        ex return
    ] do:[
        ^ super atEnd.
    ].
    ^ true

    "Created: / 9.7.1998 / 20:29:03 / cg"
    "Modified: / 9.7.1998 / 20:29:48 / cg"
! !

!UnixPTYStream class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

