"
 Copyright (c) 2007-2010 Jan Vrany
 Copyright (c) 2009-2010 eXept Software AG

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the 'Software'), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
"
"{ Package: 'stx:libsvn' }"

"{ NameSpace: SVN }"

Object subclass:#OSProcess
	instanceVariableNames:'executable arguments environment workdir stdin stdout stderr
		exitValue runningLock'
	classVariableNames:''
	poolDictionaries:''
	category:'OS-Support'
!

!OSProcess class methodsFor:'documentation'!

copyright
"
 Copyright (c) 2007-2010 Jan Vrany
 Copyright (c) 2009-2010 eXept Software AG

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the 'Software'), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.

"
! !

!OSProcess class methodsFor:'others'!

version_CVS
    ^ '$Header$'
! !

!OSProcess class methodsFor:'private'!

asShellQuotedArgument: anObject

    | aString unquotedStream quotedStream |
    aString := anObject asString.

    (aString first = $' and: [aString last = $'])
        ifTrue:[^aString].

    (aString first = $" and: [aString last = $"])
        ifTrue:[^aString].

    (aString allSatisfy:
        [:char|char isSeparator not and: [(#($" $< $> $& $# $; $\) includes: char) not]])
            ifTrue:[^aString].

    unquotedStream := aString readStream.
    quotedStream := (String new: aString size + 10) writeStream.
    quotedStream nextPut: $".
    [ unquotedStream atEnd ] whileFalse:
        [|char|
        char := unquotedStream next.
        (#($" $\) includes: char) ifTrue:[quotedStream nextPut: $\].
        quotedStream nextPut: char].
    quotedStream nextPut: $".
    ^quotedStream contents.

    "
        OSProcess asShellQuotedArgument: 'Hello' .
        OSProcess asShellQuotedArgument: 'Hello world'  
        OSProcess asShellQuotedArgument: 'Hello'' world'   
        OSProcess asShellQuotedArgument: 'Hello
        World'
    "

    "Created: / 10-10-2008 / 12:32:18 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 02-06-2009 / 19:41:05 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!OSProcess methodsFor:'accessing'!

arguments
    ^ arguments ? #()

    "Created: / 15-03-2008 / 18:09:37 / janfrog"
!

arguments:something
    arguments := something.

    "Created: / 15-03-2008 / 18:09:37 / janfrog"
!

environment
    ^ environment

    "Created: / 15-03-2008 / 18:09:37 / janfrog"
!

environment:something
    environment := something.

    "Created: / 15-03-2008 / 18:09:37 / janfrog"
!

executable
    ^ executable

    "Created: / 15-03-2008 / 18:09:37 / janfrog"
!

executable:something
    executable := something.

    "Created: / 15-03-2008 / 18:09:37 / janfrog"
!

exitValue

    self waitFor.
    ^exitValue

    "Created: / 15-03-2008 / 18:08:00 / janfrog"
    "Modified: / 19-04-2008 / 12:25:56 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

stderr
    ^ stderr ? Stderr

    "Created: / 15-03-2008 / 18:21:05 / janfrog"
!

stderr:something
    stderr := something.

    "Created: / 15-03-2008 / 18:21:05 / janfrog"
!

stdin
    ^ stdin ? Stdin

    "Created: / 15-03-2008 / 18:21:05 / janfrog"
!

stdin:something
    stdin := something.

    "Created: / 15-03-2008 / 18:21:05 / janfrog"
!

stdout
    ^ stdout ? Transcript

    "Created: / 15-03-2008 / 18:21:05 / janfrog"
!

stdout:something
    stdout := something.

    "Created: / 15-03-2008 / 18:21:05 / janfrog"
!

workdir
    ^ workdir ? Filename defaultDirectory

    "Created: / 15-03-2008 / 18:09:37 / janfrog"
!

workdir:aStringOrFilename
    workdir := aStringOrFilename asString.

    "Created: / 15-03-2008 / 18:09:37 / janfrog"
    "Modified: / 09-04-2009 / 17:32:25 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!OSProcess methodsFor:'conversion'!

asShellCommandString

    | cmdStream |
    cmdStream := String new writeStream.
    cmdStream nextPutAll:self executable.
    self arguments do:
        [:arg|
        cmdStream space.
        cmdStream nextPutAll:(self asShellQuotedArgument: arg)].

    ^cmdStream contents utf8Encoded

    "Created: / 19-03-2008 / 12:34:59 / janfrog"
    "Modified: / 31-03-2008 / 14:09:05 / janfrog"
    "Modified: / 23-03-2009 / 10:09:55 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!OSProcess methodsFor:'operations'!

execute
    "
    self synchronized:
        [runningLock 
            ifNotNil:[self error:'Process already running']
            ifNil:[runningLock := Semaphore new:0]].
    [["
        OperatingSystem isMSWINDOWSlike"false"
            ifTrue: [self executeOnStupidPlatform]
            ifFalse:[self executeOnReasonablePlatform]
     "
    ] ensure:[runningLock signalForAll. runningLock := nil]] fork
    "

    "Created: / 15-03-2008 / 18:11:20 / janfrog"
    "Modified: / 19-03-2008 / 12:35:05 / janfrog"
    "Modified: / 08-06-2008 / 19:15:45 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 11-04-2010 / 13:04:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

waitFor

    "| lock |
    self synchronized:
        [runningLock 
            ifNil:[^self]
            ifNotNil:[lock := runningLock]].
    lock wait"

    "Created: / 15-03-2008 / 18:32:41 / janfrog"
    "Modified: / 08-06-2008 / 19:15:22 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!OSProcess methodsFor:'private'!

asShellQuotedArgument:arg
    ^ self class asShellQuotedArgument:arg

    "Created: / 10-10-2008 / 12:32:18 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

executeOnReasonablePlatform
    "
    self synchronized:
        [runningLock 
            ifNotNil:[self error:'Process already running']
            ifNil:[runningLock := Semaphore new:0]].
    [["
        (OperatingSystem
            executeCommand: self asShellCommandString
            inputFrom: self stdin
            outputTo: self stdout
            errorTo: self stderr
            auxFrom: nil
            environment: nil
            inDirectory: self workdir asString
            lineWise: (self stdout = self stderr)
            onError:[:value|exitValue := value code.false])
            ifTrue:[exitValue := 0]        
    "
    ] ensure:[runningLock signalForAll. runningLock := nil]] fork
    "

    "Modified: / 19-03-2008 / 12:35:05 / janfrog"
    "Modified: / 08-06-2008 / 19:15:45 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Created: / 11-04-2010 / 12:49:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

executeOnStupidPlatform

    "i.e., on MS Windows. For some reasons sometimes part
     of stdout bytes are lost. Arghh.
     To workaround it, redirect output to file and then
     read that file. Stupid & complicated kludge, sigh."

    | extStdoutF extStdout extStderrF extStderr |
    [extStdout := (extStdoutF := Filename newTemporary) writeStream.
    extStderr := (extStderrF := Filename newTemporary) writeStream.        
    (OperatingSystem
            executeCommand: self asShellCommandString
            inputFrom: self stdin
            outputTo: extStdout
            errorTo: extStderr
            auxFrom: nil
            environment: nil
            inDirectory: self workdir asString
            lineWise: (self stdout = self stderr)
            onError:[:value|exitValue := value code.false])
            ifTrue:[exitValue := 0]    
    ] ensure: [
        extStdout close. extStderr close.
        stdout nextPutAll: extStdoutF contentsAsString.
        stderr nextPutAll: extStderrF contentsAsString.
        "Windows are really stupid!! Sometimes they lock files
         longer than needed. Even same process is not allowed
         to work with them. Sigh sigh sigh..."
        [ extStdoutF remove ] on: Error do:
            [Delay waitForMilliseconds: 10.
            [ extStdoutF remove ] on: Error do:
                [Delay waitForMilliseconds: 50.
                [extStdoutF remove] on:Error do:["Givin up, Windows are shit"]]].
        "Same for stderr"
        [ extStderrF remove ] on: Error do:
            [Delay waitForMilliseconds: 10.
            [ extStderrF remove ] on: Error do:
                [Delay waitForMilliseconds: 20.
                [extStderrF remove] on:Error do:["Givin up, Windows are shit"]]]]

    "Created: / 11-04-2010 / 12:50:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-09-2010 / 23:41:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-03-2012 / 23:30:32 / jv"
! !

!OSProcess class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_SVN
    ^ '§Id: SVN__OSProcess.st 362 2011-08-08 13:07:42Z vranyj1 §'
! !
