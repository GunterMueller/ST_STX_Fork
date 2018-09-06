"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 1989 by Claus Gittinger
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

NonPositionableExternalStream subclass:#PipeStream
	instanceVariableNames:'commandString osProcess'
	classVariableNames:'BrokenPipeSignal'
	poolDictionaries:''
	category:'Streams-External'
!

!PipeStream primitiveDefinitions!
%{
#include "stxOSDefs.h"

#if defined(__win32__)
# undef UNIX_LIKE
# define MSDOS_LIKE
#endif

#ifndef _STDIO_H_INCLUDED_
# include <stdio.h>
# define _STDIO_H_INCLUDED_
#endif

#ifndef _ERRNO_H_INCLUDED_
# include <errno.h>
# define _ERRNO_H_INCLUDED_
#endif

#ifndef transputer
# include <sys/types.h>
# include <sys/stat.h>
#endif

/*
 * on some systems errno is a macro ... check for it here
 */
#ifndef errno
 extern errno;
#endif

#ifdef LINUX
# define BUGGY_STDIO_LIB
#endif

%}
! !

!PipeStream primitiveFunctions!
%{

/*
 * no longer needed - popen is useless ...
 */
#undef NEED_POPEN_WITH_VFORK

/*
 * some systems (i.e. ultrix) use fork;
 * we're better off with a popen based on vfork ...
 */
#ifdef NEED_POPEN_WITH_VFORK

static int popen_pid = 0;

FILE *
popen(command, type)
/* const */ char *command;
/* const */ char *type;
{
    int pipes[2];
    int itype = (strcmp(type, "w") == 0 ? 1 : 0);

    if (pipe(pipes) == -1)
	return NULL;

    switch (popen_pid = vfork()) {
    case -1:
	(void)close(pipes[0]);
	(void)close(pipes[1]);
	return NULL;

    case 0:
	if (itype) {
	    dup2(pipes[0], fileno(stdin));
	    close(pipes[1]);
	} else {
	    dup2(pipes[1], fileno(stdout));
	    close(pipes[0]);
	}
	execl("/bin/sh", "/bin/sh", "-c", command, 0);
	console_fprintf(stderr, "PipeStream [warning]: execlp failed in popen\n");
	_exit(-1);
	/* NOTREACHED */

    default:
	    if (itype) {
		close(pipes[0]);
		return fdopen(pipes[1], "w");
	    } else {
		close(pipes[1]);
		return fdopen(pipes[0], "r");
	    }
    }
}

int
pclose(str)
FILE *str;
{
    int pd = 0;
    int status;
    int err;

    err = fclose(str);

    do {
	if ((pd = wait(&status)) == -1)
	{
		err = EOF;
		break;
	}
    } while (pd !=  popen_pid);

    if (err == EOF)
	return  -1;

    if (status)
	status >>= 8;   /* exit status in high byte */

    return status;
}

#endif /* NEED_POPEN_WITH_VFORK */

%}
! !

!PipeStream class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1989 by Claus Gittinger
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
    Pipestreams allow reading or writing from/to a unix or dos command.
    For example, to get a stream reading the output of an 'ls -l'
    command, a PipeStream can be created with:

	PipeStream readingFrom:'ls -l'

    the characters of the command's output can be read using the
    standard stream messages, such as next, nextLine etc.

    Example for writing to a command:

	PipeStream writingTo:'cat >/tmp/x'

    Bidirectional pipestreams (supporting both reading an writing) may be used for filters:

	PipeStream bidirectionalFor:'sed -e ''s/Hello/Greetings/'''

    Buffered pipes do not work with Linux - the stdio library seems to be
    buggy (trying to restart the read ...)

    [author:]
	Claus Gittinger

    [see also:]
	ExternalStream FileStream Socket
	OperatingSystem
"
! !

!PipeStream class methodsFor:'initialization'!

initialize
    "setup the signal"

    BrokenPipeSignal isNil ifTrue:[
	BrokenPipeSignal := WriteError newSignalMayProceed:true.
	BrokenPipeSignal nameClass:self message:#brokenPipeSignal.
	BrokenPipeSignal notifierString:'write on a pipe with no one to read'.
    ]
! !

!PipeStream class methodsFor:'instance creation'!

bidirectionalFor:commandString
    "create and return a new bidirectonal pipeStream which can both be written to
     and read from the unix command given by commandString.
     The commands error output is send to my own error output."

    ^ self
	bidirectionalFor:commandString
	errorDisposition:#stderr
	inDirectory:nil

    "
	|p|

	p := PipeStream bidirectionalFor:'cat -u'.
	p nextPutAll:'Wer ist der Bürgermeister von Wesel'; cr.
	Transcript showCR:p nextLine.
	p close
    "

    "
	|p|

	p := PipeStream bidirectionalFor:'sed -e ''s/Hello/Greetings/'''.
	p nextPutAll:'Hello world'; cr.
	p shutDownOutput.
	Transcript showCR:p nextLine.
	p close
    "

    "
	|p|

	p := PipeStream bidirectionalFor:'wc'.
	p nextPutAll:'Hello world'; cr.
	p shutDownOutput.
	Transcript showCR:p nextLine.
	p close
    "
!

bidirectionalFor:commandString errorDisposition:errorDisposition inDirectory:aDirectory
    "create and return a new bidirectonal pipeStream which can both be written to
     and read from the unix command given by commandString.
     The directory will be changed to aDirectory while
     executing the command. Use this if a command is to be
     executed in another directory, to avoid any OS dependencies
     in your code.

     errorDisposition may be one of #discard, #inline or #stderr (default).
     #discard causes stderr to be discarded (/dev/null),
     #inline causes it to be written to smalltalks own stdout and
     #stderr causes it to be written to smalltalks own stderr.
     Nil is treated like #stderr"

    ^ self basicNew
	openPipeFor:commandString
	withMode:#'r+'
	errorDisposition:errorDisposition
	inDirectory:aDirectory
!

readingFrom:commandString
    "create and return a new pipeStream which can read from the unix command
     given by commandString.
     The commands error output is send to my own error output."

    ^ self
        readingFrom:commandString
        errorDisposition:#stderr
        inDirectory:nil

    "unix:
        PipeStream readingFrom:'ls -l'.
    "

    "
        |p|

        p := PipeStream readingFrom:'ls -l'.
        Transcript showCR:p nextLine.
        p close
    "


    "
        |p|

        p := PipeStream readingFrom:'echo error >&2'.
        Transcript showCR:p nextLine.
        p close
    "

    "
        |s|
        s := PipeStream readingFrom:'sh -c sleep\ 600'.
        (Delay forSeconds:2) wait.
        s abortAndClose
    "

    "
        |p|
        p := PipeStream readingFrom:'dir'.
        Transcript showCR:p nextLine.
        p close
    "

    "Windows:
        PipeStream readingFrom:'dir'.
    "
    "
        |p|
        p := PipeStream readingFrom:'dir'.
        Transcript showCR:p nextLine.
        p close
    "

    "Modified: 24.4.1996 / 09:09:25 / stefan"
!

readingFrom:commandString errorDisposition:errorDisposition inDirectory:aDirectory
    "similar to #readingFrom, but changes the directory while
     executing the command. Use this if a command is to be
     executed in another directory, to avoid any OS dependencies
     in your code.
     errorDisposition may be one of #discard, #inline or #stderr (default).
     #discard causes stderr to be discarded (/dev/null),
     #inline causes it to be merged into the PipeStream and
     #stderr causes it to be written to smalltalks own stderr.
     Nil is treated like #stderr"

    ^ self basicNew
        openPipeFor:commandString
        withMode:#r
        errorDisposition:errorDisposition
        inDirectory:aDirectory


    "
        |p|

        p := PipeStream readingFrom:'bla' errorDisposition:Transcript inDirectory:nil.
        Transcript showCR:p nextLine.
        p close
    "

    "
        |p|

        p := PipeStream readingFrom:'bla' errorDisposition:#inline inDirectory:nil.
        Transcript showCR:p nextLine.
        p close
    "
!

readingFrom:commandString inDirectory:aDirectory
    "similar to #readingFrom, but changes the directory while
     executing the command. Use this if a command is to be
     executed in another directory, to avoid any OS dependencies
     in your code.
     The commands error output is send to my own error output."

     ^ self
	readingFrom:commandString
	errorDisposition:#stderr
	inDirectory:aDirectory

    " UNIX:
	|p|

	p := PipeStream readingFrom:'ls -l' inDirectory:'/etc'.
	Transcript showCR:p upToEnd.
	p close
    "
    "WINDOOF:
	|p|

	p := PipeStream readingFrom:'dir'.
	Transcript showCR:p upToEnd.
	p close
   "
!

writingTo:commandString
    "create and return a new pipeStream which can write to the unix command
     given by command."

    ^ self
	writingTo:commandString errorDisposition:#stderr inDirectory:nil

    "unix:
	 PipeStream writingTo:'sort'
    "
!

writingTo:commandString errorDisposition:errorDisposition inDirectory:aDirectory
    "similar to #writingTo, but changes the directory while
     executing the command. Use this if a command is to be
     executed in another directory, to avoid any OS dependencies
     in your code.
     errorDisposition may be one of #discard, #inline or #stderr (default).
     #discard causes stderr to be discarded (/dev/null),
     #inline causes it to be written to smalltalks own stdout and
     #stderr causes it to be written to smalltalks own stderr.
     Nil is treated like #stderr"

    ^ self basicNew
	openPipeFor:commandString
	withMode:#w
	errorDisposition:errorDisposition
	inDirectory:aDirectory
!

writingTo:commandString inDirectory:aDirectory
    "create and return a new pipeStream which can write to the unix command
     given by commandString. The command is executed in the given directory."

    ^ self
	writingTo:commandString errorDisposition:#stderr inDirectory:aDirectory

    "unix:
	 PipeStream writingTo:'sort'
    "
! !

!PipeStream class methodsFor:'Signal constants'!

brokenPipeSignal
    "return the signal used to handle SIGPIPE unix-signals.
     Since SIGPIPE is asynchronous, we can't decide which smalltalk process
     should handle BrokenPipeSignal. So the system doesn't raise
     BrokenPipeSignal for SIGPIPE any longer."

    ^ BrokenPipeSignal

    "Modified: 24.9.1997 / 09:43:23 / stefan"
! !

!PipeStream class methodsFor:'utilities'!

outputFromCommand:aCommand
    "open a pipe reading from aCommand and return the complete output as a string.
     If the command cannot be executed, return nil.
     The command's current directory will be the smalltalk current directory."

    ^ self outputFromCommand:aCommand inDirectory:nil

    "
     PipeStream outputFromCommand:'ls -l'
    "
!

outputFromCommand:aCommand inDirectory:aDirectoryOrNil
    "open a pipe reading from aCommand and return the complete output as a string.
     If the command cannot be executed, return nil.
     The current directory of the command will be aDirectoryOrNil or the smalltalk's current directory (if nil)"

    |p cmdOutput|

    p := self readingFrom:aCommand inDirectory:aDirectoryOrNil.
    p isNil ifTrue:[^ nil].

    [
	cmdOutput := p contentsAsString.
    ] ensure:[
	p close.
    ].
    ^ cmdOutput

    "
     PipeStream outputFromCommand:'ls -l' inDirectory:nil
     PipeStream outputFromCommand:'ls -l' inDirectory:'/'
     PipeStream outputFromCommand:'ls -l' inDirectory:'/etc'
    "
! !

!PipeStream methodsFor:'accessing'!

commandString
    "return the command string"

    ^ commandString
!

exitStatus
    "return the exitStatus"

    osProcess isNil ifTrue:[
        ^ nil.
    ].
    ^ osProcess exitStatus.
    
    "Created: 28.12.1995 / 14:54:41 / stefan"
!

pid
    "return pid"

    osProcess isNil ifTrue:[
        ^ nil.
    ].
    ^ osProcess pid.

    "Created: 28.12.1995 / 14:54:30 / stefan"
! !

!PipeStream methodsFor:'closing'!

abortAndClose
    "close the Stream and terminate the command"

    self unregisterForFinalization.

    "terminate first under windows"
    OperatingSystem isMSDOSlike ifTrue:[
        self terminatePipeCommand.
        self closeFile.
        ^ self.
    ].

    "terminate last under unix"
    self closeFile.
    self terminatePipeCommand.
!

close
    "low level close
     This waits for the command to finish.
     Use abortAndClose for a fast (nonBlocking) close."

    handle notNil ifTrue:[
        super close.
        "/ wait for the pipe-command to terminate.
        self waitForPipeCommandWithTimeout:nil.
    ].

    "Modified: / 12.9.1998 / 16:51:04 / cg"
!

shutDown
    <resource: #obsolete>
    "this is a historic leftover kept for backward compatibility.
     The name collides with the same name in Socket, which does
     not hard terminate the connection."

    self abortAndClose.
!

shutDownOutput
    "signal to the pipestream's command, that no more data will be sent"

    |fd|

    self isOpen ifTrue:[
	fd := self fileDescriptor.
	fd notNil ifTrue:[
	    OperatingSystem shutdownBidirectionalPipeOutput:fd.
	].
    ].
! !

!PipeStream methodsFor:'finalization'!

finalize
    "redefined to avoid blocking in close."

    self abortAndClose
! !

!PipeStream methodsFor:'private'!

openPipeFor:aCommandString withMode:rwMode errorDisposition:errorDisposition inDirectory:aDirectory
    "open a pipe to the OS command in commandString;
     rwMode may be 'r' or 'w' or 'r+'.
     errorDisposition controls where the stdErr output should go,
     and may be one of #discard, #inline or #stderr (default).
     #discard causes stderr to be discarded (/dev/null),
     #inline causes it to be written to smalltalks own stdout and
     #stderr causes it to be written to smalltalks own stderr.
     Nil is treated like #stderr"

    |pipeArray remotePipeEnd nullOutput errorNumber myPipeEnd result|

    handle notNil ifTrue:[
        "the pipe was already open ...
         this should (can) not happen."
        ^ self errorAlreadyOpen
    ].

    rwMode = #r ifTrue:[
        mode := #readonly. didWrite := false.
        position := 0.      "only reading - can keep track of position"
    ] ifFalse:[rwMode = #'r+' ifTrue:[
        mode := #readwrite. didWrite := true.
    ] ifFalse:[
        mode := #writeonly. didWrite := true.
        position := 0.      "only writing - can keep track of position"
    ]].

    lastErrorNumber := nil.
    commandString := aCommandString.
    "stdio lib does not work with blocking pipes and interrupts
     for WIN, Linux, Solaris and probably any other UNIX"
    buffered := false.
    hitEOF := false.
    binary := false.

    osProcess := OSProcess new 
                    command:aCommandString;
                    directory:aDirectory.

    mode == #readwrite ifTrue:[
        pipeArray := self class makeBidirectionalPipe.
        pipeArray isNil ifTrue:[
            lastErrorNumber := errorNumber := OperatingSystem currentErrorNumber.
            ^ self openError:errorNumber.
        ].
        myPipeEnd := pipeArray at:1.
        remotePipeEnd := pipeArray at:2.
        osProcess inStream:remotePipeEnd.
        osProcess outStream:remotePipeEnd.
    ] ifFalse:[
        pipeArray := self class makePipe.
        pipeArray isNil ifTrue:[
            lastErrorNumber := errorNumber := OperatingSystem currentErrorNumber.
            ^ self openError:errorNumber.
        ].

        mode == #readonly ifTrue:[
            "redirect stdout of subprocess to write to pipe"
            myPipeEnd := pipeArray at:1.
            remotePipeEnd := pipeArray at:2.
            osProcess outStream:remotePipeEnd.
        ] ifFalse:[
            "redirect stdin of subprocess to read from pipe"
            myPipeEnd := pipeArray at:2.
            remotePipeEnd := pipeArray at:1.
            osProcess inStream:remotePipeEnd.
        ].
    ].

    errorDisposition == #discard ifTrue:[
        nullOutput := Filename nullDevice writeStream.
        osProcess errorStream:nullOutput.
    ] ifFalse:[(errorDisposition == #inline or:[errorDisposition == #stdout]) ifTrue:[
        osProcess errorStream:osProcess outStream.
    ] ifFalse:[(errorDisposition == #stderr or:[errorDisposition isNil]) ifTrue:[
        osProcess errorStream:Stderr.
    ] ifFalse:[errorDisposition isStream ifTrue:[
        osProcess errorStream:errorDisposition.
    ]]]].

    mode ~~ #readonly ifTrue:[
        osProcess terminateActionBlock:[
                "writing doesn't make sense - there is no reader any longer"
                mode == #readwrite ifTrue:[
                    "... but allow to read the rest of the command's output"
                    self shutDownOutput.
                ] ifFalse:[mode == #writeonly ifTrue:[
                    self closeFile.
                ]].
           ].
    ].

    result := osProcess startProcess.

    "subprocess has been created.
     close unused filedescriptors"
    remotePipeEnd notNil ifTrue:[
        remotePipeEnd close.
    ].
    nullOutput notNil ifTrue:[
        nullOutput close
    ].

    result ifTrue:[
        "successfull creation of subprocesss"
        handle := myPipeEnd handle.
        handleType := myPipeEnd handleType.
        myPipeEnd unregisterForFinalization.    "make sure filedesciptor is not closed by finalizer"
        myPipeEnd := nil.
    ] ifFalse:[
        "the pipe open failed for some reason ...
         ... this may be either due to an invalid command string,
         or due to the system running out of memory (when forking
         the unix process)"
        lastErrorNumber := OperatingSystem lastErrorNumber.
        myPipeEnd close.
        ^ self openError:lastErrorNumber.
    ].

    self registerForFinalization.

    "Modified: / 23.4.1996 / 17:05:59 / stefan"
    "Modified: / 28.1.1998 / 14:47:34 / md"
    "Created: / 19.5.1999 / 12:28:54 / cg"
!

terminatePipeCommand
    osProcess notNil ifTrue:[
        osProcess terminateGroup.
    ].
!

waitForPipeCommandWithTimeout:seconds
    "wait for the pipe command to terminate itself.
     Return true, if a timeout occurred."

    osProcess notNil ifTrue:[
        ^ osProcess finishSema waitWithTimeout:seconds.
    ].
    ^ false
! !

!PipeStream class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


PipeStream initialize!
