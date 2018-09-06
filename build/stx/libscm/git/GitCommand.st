"{ Package: 'stx:libscm/git' }"

Object subclass:#GitCommand
	instanceVariableNames:'workingDirectory'
	classVariableNames:'GitExecutable'
	poolDictionaries:''
	category:'SCM-Git-Internal'
!

GitCommand subclass:#clone
	instanceVariableNames:'url path'
	classVariableNames:''
	poolDictionaries:''
	privateIn:GitCommand
!

GitCommand subclass:#push
	instanceVariableNames:'remote refspec'
	classVariableNames:''
	poolDictionaries:''
	privateIn:GitCommand
!

!GitCommand class methodsFor:'documentation'!

documentation
"
    A simple wrapper for git command line tool. git command is called
    in cases there is no native nor libgit2 implementation for given
    operation (yet).

    Individual commands are wrapped in my private classes.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!GitCommand class methodsFor:'instance creation'!

clone
    ^clone new

    "Created: / 01-10-2012 / 00:09:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

new
    ^ self basicNew initialize.

    "Created: / 16-03-2008 / 07:45:22 / janfrog"
!

push
    ^push new

    "Created: / 30-09-2012 / 23:46:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitCommand class methodsFor:'accessing'!

verbose

    ^ UserPreferences current svnVerbose

    "Created: / 19-03-2008 / 12:29:47 / janfrog"
    "Modified: / 19-03-2009 / 14:00:50 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified (format): / 27-12-2011 / 16:00:06 / dundee"
!

verbose:aBoolean

    UserPreferences current svnVerbose:aBoolean

    "Created: / 19-03-2008 / 12:29:59 / janfrog"
    "Modified: / 19-03-2009 / 14:00:59 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified (format): / 27-12-2011 / 16:00:13 / dundee"
! !

!GitCommand class methodsFor:'commands'!

clone: url to: stringOfFilename
    self clone
        url: url;
        path: stringOfFilename asFilename asAbsoluteFilename pathName;
        execute

    "Created: / 01-10-2012 / 00:06:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitCommand methodsFor:'accessing'!

workingDirectory
    ^workingDirectory notNil ifTrue:[
        workingDirectory
    ] ifFalse: [
        Filename currentDirectory pathName
    ]

    "Created: / 11-05-2011 / 08:26:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 27-12-2011 / 15:54:08 / dundee"
    "Modified: / 01-10-2012 / 14:38:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

workingDirectory:aStringOrFilename
    aStringOrFilename asFilename isDirectory ifFalse:[
        self error:'Working directory does not exist'.
        ^self.
    ].    
    workingDirectory := aStringOrFilename asString.

    "Modified: / 01-10-2012 / 14:38:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitCommand methodsFor:'executing'!

execute
    | pipe output pid environment sema status retval |

    pipe := NonPositionableExternalStream makePipe.
    output := pipe first.
    environment := OperatingSystem getEnvironment copy.

    environment at:'LANG' put:'C'.
    sema := Semaphore new name: 'waiting for git command to finish'.
    Processor monitor:[
        pid := OperatingSystem exec:(self executable) withArguments:(self arguments)
            environment:environment
            fileDescriptors:{0 . pipe second fileDescriptor . pipe second fileDescriptor}
            fork:true 
            newPgrp:false 
            inDirectory:self workingDirectory
    ] action:[:stat |
        status := stat.
        sema signal.
    ].
    

    pipe second close.
    pid isNil ifTrue:[
        self error:'Cannot execute git command'.
        output close.
        ^ self.
    ].
    retval := self parse: output.
    sema wait.
    status success ifFalse:[
        GitError raiseErrorString: 'git command failed'.
    ].
    ^retval

    "
        SVNv2::Command info: 'https://swing.fit.cvut.cz/svn/stx/libsvn'
    "

    "Created: / 11-05-2011 / 07:45:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-12-2011 / 19:22:00 / dundee"
    "Modified (format): / 27-12-2011 / 15:53:54 / dundee"
    "Modified: / 01-10-2012 / 14:06:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitCommand methodsFor:'private'!

arguments

    ^ OrderedCollection streamContents:[:s |
        s nextPut:self executable.
        self argumentsGlobalOn:s.
        s nextPut:self command.
        self argumentsCommandOn:s.
    ].

    "Created: / 11-05-2011 / 07:58:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 27-12-2011 / 15:47:23 / dundee"
!

argumentsCommandOn:stream
    "Called to get command specific options"

    self shouldImplement

    "Created: / 11-05-2011 / 07:58:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 27-12-2011 / 15:46:59 / dundee"
!

argumentsGlobalOn:arg
    "Called to get global options"

    "Created: / 11-05-2011 / 07:58:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 27-12-2011 / 15:47:10 / dundee"
    "Modified: / 30-09-2012 / 23:43:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

command
    "Returns the git 'command' option, i.e. commit,
     push, pull, ..."

    ^self class nameWithoutPrefix

    "
        GitCommand::push basicNew command
    "

    "Created: / 11-05-2011 / 07:58:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 27-12-2011 / 15:47:17 / dundee"
    "Modified: / 30-09-2012 / 23:37:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

executable
    | h |

    GitExecutable notNil ifTrue:[^ GitExecutable].

    OperatingSystem isMSWINDOWSlike ifTrue:[
"/        h := Win32OperatingSystem registryEntry 
"/                key:'HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\App Paths\svn.exe'.
"/        h notNil ifTrue:[GitExecutable := h valueNamed:''].
"/        GitExecutable notEmptyOrNil ifTrue:[^ GitExecutable]
        GitExecutable := OperatingSystem pathOfCommand:'git'.
        ^GitExecutable
    ].

    OperatingSystem isUNIXlike ifTrue:[
        GitExecutable := OperatingSystem pathOfCommand:'git'.    
        ^GitExecutable
    ].

    self error:'Git executable not found!!'.


    "
     GitExecutable := nil.
     self basicNew executable
    "

    "Created: / 11-05-2011 / 07:59:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-12-2011 / 22:48:33 / dundee"
    "Modified (format): / 27-12-2011 / 15:51:06 / dundee"
    "Modified: / 01-10-2012 / 00:10:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parse: stream

    "Parses output of svn 'command' option, i.e. commit,
     log, update, checkout, etc."

    ^ self subclassResponsibility

    "Created: / 11-05-2011 / 07:58:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 17-12-2011 / 17:02:41 / dundee"
! !

!GitCommand::clone methodsFor:'accessing'!

path
    ^ path
!

path:something
    path := something.
!

url
    ^ url
!

url:something
    url := something.
! !

!GitCommand::clone methodsFor:'private'!

argumentsCommandOn:stream
    "Called to get command specific options"

    stream nextPut: url; nextPut: path

    "Created: / 01-10-2012 / 00:04:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parse:stream
    "superclass GitCommand says that I am responsible to implement this method"

    ^ ''

    "Modified: / 01-10-2012 / 00:11:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitCommand::push methodsFor:'accessing'!

refspec
    ^ refspec
!

refspec:something
    refspec := something.
!

remote
    ^ remote
!

remote:something
    remote := something.
! !

!GitCommand::push methodsFor:'private'!

argumentsCommandOn:stream
    "Called to get command specific options"

    stream nextPut: remote.
    refspec notNil ifTrue:[
        stream nextPut: refspec.
    ]

    "Created: / 30-09-2012 / 23:44:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parse:stream
    "superclass GitCommand says that I am responsible to implement this method"

    ^ ''

    "Modified: / 01-10-2012 / 00:11:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitCommand class methodsFor:'documentation'!

version_GIT
    "Never, ever change this method. Ask JV or CG why"
    ^thisContext method mclass theNonMetaclass instVarNamed: #revision
!

version_SVN
    ^ '$Id$'
! !
