"
stx:libscm - a new source code management library for Smalltalk/X
Copyright (C) 2012-2015 Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
"{ Package: 'stx:libscm/mercurial' }"

"{ NameSpace: Smalltalk }"

Object subclass:#HGCommand
	instanceVariableNames:'workingDirectory result error errors blocker errorReader
		outputReader'
	classVariableNames:'HGCommandString HGExecutable HGExecutableArguments HGVersion
		HGVersionIsGreaterOrEqualThan_2_4
		HGVersionIsGreaterOrEqualThan_2_5
		HGVersionIsGreaterOrEqualThan_3_3
		HGVersionIsGreaterOrEqualThan_4_1'
	poolDictionaries:'HGDebugFlags'
	category:'SCM-Mercurial-Internal'
!

HGCommand subclass:#add
	instanceVariableNames:'paths'
	classVariableNames:''
	poolDictionaries:''
	privateIn:HGCommand
!

HGCommand subclass:#bookmark
	instanceVariableNames:'revision name'
	classVariableNames:''
	poolDictionaries:''
	privateIn:HGCommand
!

HGCommand subclass:#bookmark_delete
	instanceVariableNames:'revision name'
	classVariableNames:''
	poolDictionaries:''
	privateIn:HGCommand
!

HGCommand subclass:#branches
	instanceVariableNames:'active closed'
	classVariableNames:''
	poolDictionaries:''
	privateIn:HGCommand
!

HGCommand subclass:#cat
	instanceVariableNames:'path revision destination'
	classVariableNames:''
	poolDictionaries:''
	privateIn:HGCommand
!

HGCommand subclass:#clone
	instanceVariableNames:'url path update'
	classVariableNames:''
	poolDictionaries:''
	privateIn:HGCommand
!

HGCommand subclass:#commit
	instanceVariableNames:'message files author date amend'
	classVariableNames:''
	poolDictionaries:''
	privateIn:HGCommand
!

HGCommand subclass:#heads
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:HGCommand
!

HGCommand subclass:#help
	instanceVariableNames:'topic'
	classVariableNames:''
	poolDictionaries:''
	privateIn:HGCommand
!

HGCommand subclass:#init
	instanceVariableNames:'path'
	classVariableNames:''
	poolDictionaries:''
	privateIn:HGCommand
!

HGCommand subclass:#locate
	instanceVariableNames:'revision'
	classVariableNames:''
	poolDictionaries:''
	privateIn:HGCommand
!

HGCommand subclass:#log
	instanceVariableNames:'start stop path childrenOnly idsOnly revsets limit hidden'
	classVariableNames:''
	poolDictionaries:''
	privateIn:HGCommand
!

HGCommand subclass:#merge
	instanceVariableNames:'revision tool'
	classVariableNames:''
	poolDictionaries:''
	privateIn:HGCommand
!

HGCommand subclass:#mv
	instanceVariableNames:'source destination'
	classVariableNames:''
	poolDictionaries:''
	privateIn:HGCommand
!

HGCommand subclass:#pull
	instanceVariableNames:'url'
	classVariableNames:''
	poolDictionaries:''
	privateIn:HGCommand
!

HGCommand subclass:#push
	instanceVariableNames:'url force'
	classVariableNames:''
	poolDictionaries:''
	privateIn:HGCommand
!

HGCommand subclass:#remove
	instanceVariableNames:'force paths'
	classVariableNames:''
	poolDictionaries:''
	privateIn:HGCommand
!

HGCommand subclass:#resolve
	instanceVariableNames:'tool mark unmark files'
	classVariableNames:''
	poolDictionaries:''
	privateIn:HGCommand
!

HGCommand subclass:#resolve__list
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:HGCommand
!

HGCommand subclass:#share
	instanceVariableNames:'source destination update'
	classVariableNames:''
	poolDictionaries:''
	privateIn:HGCommand
!

HGCommand subclass:#showconfig
	instanceVariableNames:'key'
	classVariableNames:''
	poolDictionaries:''
	privateIn:HGCommand
!

HGCommand subclass:#status
	instanceVariableNames:'paths'
	classVariableNames:''
	poolDictionaries:''
	privateIn:HGCommand
!

HGCommand subclass:#update
	instanceVariableNames:'revision'
	classVariableNames:''
	poolDictionaries:''
	privateIn:HGCommand
!

HGCommand subclass:#version
	instanceVariableNames:'executable arguments'
	classVariableNames:''
	poolDictionaries:''
	privateIn:HGCommand
!

!HGCommand class methodsFor:'documentation'!

copyright
"
stx:libscm - a new source code management library for Smalltalk/X
Copyright (C) 2012-2015 Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
!

documentation
"
    A wrapper for hg command line tool. Individual commands are wrapped in
    my private classes.

    HGCommand is part of internal implementation and subject to change.
    Therefore it should not be used by user code. Use classed and APIs in
    SCM-Mercurial-Core instead.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!HGCommand class methodsFor:'accessing'!

hgCommand
    "Returns hg command to use. Contrary to #hgCommand, this method
     does not validate the command. If no command is configured 
     (via user preferences) not it could be found on standard places,
     `nil` is returned."

    | command |

    HGCommandString notNil ifTrue:[ 
        command := HGCommandString 
    ] ifFalse:[
        command := UserPreferences current hgCommand.
        command notNil ifTrue:[
            command := command asString.
        ]
    ].
    command isNil ifTrue:[ 
        command := OperatingSystem pathOfCommand:'hg'.
    ].
    command isNil ifTrue:[
        | guesses |
        guesses := #().
        OperatingSystem isMSWINDOWSlike ifTrue:[
            guesses := #(
                'C:\Program Files\TortoiseHg\hg.exe'
                'C:\Program Files\Mercurial\hg.exe'
                'C:\Program Files (x86)\TortoiseHg\hg.exe'
                'C:\Program Files (x86)\Mercurial\hg.exe'                
            ).
        ].
        command := guesses detect: [ :guess | guess asFilename exists ] ifNone:[ nil ].
    ].
    ^ command

    "
     HGExecutable := nil.
     self basicNew executable
    "

    "Created: / 19-11-2012 / 21:48:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-05-2016 / 00:00:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hgCommand: command
    HGCommandString := command notNil ifTrue:[ command asString ] ifFalse:[ nil ].
    HGExecutable := HGExecutableArguments := HGVersion := nil.
    HGVersionIsGreaterOrEqualThan_2_4 := HGVersionIsGreaterOrEqualThan_2_5 := 
        HGVersionIsGreaterOrEqualThan_3_3 := HGVersionIsGreaterOrEqualThan_4_1 := nil.


    "
    HGCommand hgCommand: '/usr/src/mercurial-2.4/hg'
    HGCommand hgCommand: '/usr/bin/hg'
    HGCommand hgCommand: 'hg'
    HGCommand hgCommand: nil
    "

    "Created: / 19-11-2012 / 21:49:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 29-03-2018 / 15:54:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hgCommandValidate: command
    "Given a `command`, checks whether it is a valid hg command.
     Returns absolute path to hg binary and global arguments (if any)
     or raise an HGInvalidExecutableError or HGInvalidVersionError
     if `command` is not valid hg command."

    | tokens executable executableAsFilename arguments version |

    command isNil ifTrue:[  
        HGInvalidExecutableError raiseErrorString:('''hg'' executable not configured and not found in standard places!!').
        ^ nil
    ].
    command asFilename exists ifTrue:[
        executable := command.
        arguments := #().   
    ] ifFalse:[
        tokens := (HGCommandParser on: command readStream) parseShellCommand.
        executable := tokens first.
        arguments := tokens copyFrom: 2.
    ].
    executableAsFilename := executable asFilename.
    executableAsFilename isAbsolute ifFalse:[
        executableAsFilename := executableAsFilename asAbsoluteFilename.
        executableAsFilename exists ifTrue:[
            executable := executableAsFilename pathName.
        ] ifFalse:[
            "/ Also try to find specified command along PATH, maybe somebody
            "/ just typed 'hg' in...
            executable  := (OperatingSystem pathOfCommand: executable).
            executable isNil ifTrue:[
                HGInvalidExecutableError raiseErrorString:('''hg'' executable (%1) not found!!' bindWith: command).
                ^ nil
            ] ifFalse:[
                executableAsFilename := executable asFilename.
            ].
        ]
    ].
    executableAsFilename exists ifFalse:[
        HGInvalidExecutableError raiseErrorString:('Specified ''hg'' executable (%1) does not exists!!' bindWith: executable).
        ^ nil
    ].
    executableAsFilename isDirectory ifTrue:[
        HGInvalidExecutableError raiseErrorString:('Specified ''hg'' executable (%1) is actually a directory!!' bindWith: executable).
        ^ nil
    ].
    executableAsFilename isExecutable ifFalse:[
        HGInvalidExecutableError raiseErrorString:('Specified ''hg'' executable (%1) is cannot be executed!!' bindWith: executable).
        ^ nil
    ].
    [
        version := self hgVersionOf: executable arguments: arguments.
    ] on: Error do:[:ex |
        HGInvalidExecutableError newException
            parameter: ex;
            messageText: 'Failed to check version: ', ex description;
            raise.
        ^ nil
    ].
    (self hgVersionIsSupported: version) ifFalse:[
        HGInvalidVersionError newException
            parameter: version;
            messageText: ('Unsuported Mercurial version (%1)' bindWith: ((version collect:[:e|e printString]) asStringWith:$.));
            raise.
        ^ nil
    ].
    ^ { executable . arguments }

    "Created: / 21-02-2014 / 08:50:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-07-2014 / 20:00:56 / jv"
    "Modified: / 23-04-2016 / 19:51:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hgVersion
    "Return mercurial version installed on this compiter"

    HGVersion isNil ifTrue:[
        HGVersion := self hgVersionOf: self hgExecutable arguments: self hgExecutableArguments
    ].
    ^ HGVersion

    "
     HGCommand hgVersion
    "

    "Created: / 19-11-2012 / 20:14:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-01-2013 / 05:07:58 / jv"
    "Modified: / 17-07-2014 / 15:09:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hgVersion: versionA isGreaterOrEqualThan: versionB
    1 to: (versionA size min: versionB size) do:[:i | 
        (versionA at: i) < (versionB at: i) ifTrue:[ 
            ^ false.
        ].
        (versionA at: i) > (versionB at: i) ifTrue:[ 
            ^ true.
        ].
    ].
    ^ versionA size >= versionB size

    "
     HGCommand hgVersion: #(3 0) isGreaterOrEqualThan: #(2 5).
     HGCommand hgVersion: #(3 0) isGreaterOrEqualThan: #(2 5 1).
     HGCommand hgVersion: #(3 0) isGreaterOrEqualThan: #(3 0).
     HGCommand hgVersion: #(3 0 1) isGreaterOrEqualThan: #(3 0). 
     HGCommand hgVersion: #(3 0)  isGreaterOrEqualThan: #(3 0 1).
     HGCommand hgVersion: #(2 3)  isGreaterOrEqualThan: #(2 4).     
    "

    "Created: / 04-11-2014 / 14:12:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 01-12-2014 / 20:37:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hgVersionIsGreaterOrEqualThan: versionB
    ^ self hgVersion: self hgVersion isGreaterOrEqualThan: versionB

    "Created: / 04-11-2014 / 14:16:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hgVersionIsGreaterOrEqualThan_2_4
    HGVersionIsGreaterOrEqualThan_2_4 isNil ifTrue:[
        HGVersionIsGreaterOrEqualThan_2_4 := self hgVersionIsGreaterOrEqualThan:#( 2 4 ).
    ].
    ^ HGVersionIsGreaterOrEqualThan_2_4

    "Created: / 27-11-2014 / 23:16:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-03-2016 / 17:22:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hgVersionIsGreaterOrEqualThan_2_5
    HGVersionIsGreaterOrEqualThan_2_5 isNil ifTrue:[
        HGVersionIsGreaterOrEqualThan_2_5 := self hgVersionIsGreaterOrEqualThan:#( 2 5 ).
    ].
    ^ HGVersionIsGreaterOrEqualThan_2_5

    "Created: / 25-03-2016 / 17:23:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hgVersionIsGreaterOrEqualThan_3_3
    HGVersionIsGreaterOrEqualThan_3_3 isNil ifTrue:[
        HGVersionIsGreaterOrEqualThan_3_3 := self hgVersionIsGreaterOrEqualThan:#( 3 3 ).
    ].
    ^ HGVersionIsGreaterOrEqualThan_3_3

    "Created: / 14-09-2015 / 05:42:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-03-2016 / 17:23:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hgVersionIsGreaterOrEqualThan_4_1
    HGVersionIsGreaterOrEqualThan_4_1 isNil ifTrue:[
        HGVersionIsGreaterOrEqualThan_4_1 := self hgVersionIsGreaterOrEqualThan:#( 4 1 ).
    ].
    ^ HGVersionIsGreaterOrEqualThan_4_1

    "Created: / 28-03-2018 / 15:31:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hgVersionIsSupported
    ^ self hgVersionIsSupported:self hgVersion

    "
     HGCommand mercurialVersionIsSupported"
    "Created: / 19-11-2012 / 20:34:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hgVersionIsSupported:version
    ^ self hgVersionsSupported
        anySatisfy:[:vsn |
            ((vsn at:1) == #'*' or:[ (vsn at:1) == (version at:1) ])
                and:[
                    ((vsn at:2) == #'*' or:[ (vsn at:2) == (version at:2) ])
                        and:[ ((vsn at:3) == #'*' or:[ (vsn at:1) == (version at:3) ]) ]
                ]
        ].

    "
     HGCommand mercurialVersionIsSupported: #(2 3 2)
     HGCommand mercurialVersionIsSupported: #(2 0 1)
     HGCommand mercurialVersionIsSupported: #(1 9 1)
     HGCommand mercurialVersionIsSupported: #(1 0 0)
     HGCommand mercurialVersionIsSupported: #(2 4 nil)"
    "Created: / 19-11-2012 / 20:31:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hgVersionOf: executable arguments: arguments
    "Return mercurial version if passed executable "

    ^version new
        executable: executable;
        arguments: arguments;
        execute

    "
     HGCommand hgVersion
    "

    "Created: / 17-07-2014 / 15:08:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hgVersionsSupported
    "Return a list of mercurial version supported bu this
     implementation"

    ^ #( 
        (1 9 #'*')     "1.9 - will wanish"
        (2 #'*' #'*')  "2.x"
        (3 #'*' #'*')  "3.x"
        (4 #'*' #'*')  "4.x"
    )

    "Created: / 19-11-2012 / 20:26:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

verbose

    ^ UserPreferences current hgVerbose

    "Created: / 19-03-2008 / 12:29:47 / janfrog"
    "Modified: / 19-03-2009 / 14:00:50 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified (format): / 27-12-2011 / 16:00:06 / dundee"
    "Modified: / 17-10-2012 / 13:05:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

verbose:aBoolean

    UserPreferences current hgVerbose:aBoolean

    "Created: / 19-03-2008 / 12:29:59 / janfrog"
    "Modified: / 19-03-2009 / 14:00:59 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified (format): / 27-12-2011 / 16:00:13 / dundee"
    "Modified: / 17-10-2012 / 13:05:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommand class methodsFor:'accessing-private'!

hgExecutable
    "Returns absolute path to hg executable to use. This method
     does validate the HG command (whether exists and it's of a 
     supported version. If validation fails, a HGCommandError is
     thrown."

    HGExecutable isNil ifTrue:[
        | command executableAndArguments |
        command := self hgCommand.
        executableAndArguments := self hgCommandValidate: command.
        HGExecutable := executableAndArguments first.
        HGExecutableArguments := executableAndArguments second.
    ].
    ^ HGExecutable

    "
     HGExecutable := nil.
     self basicNew executable
    "

    "Created: / 17-07-2014 / 10:16:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 23-04-2016 / 19:27:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hgExecutableArguments
    "Returns an array of (global) arguments to be passed hg executable"

    HGExecutableArguments isNil ifTrue:[
        HGExecutable := nil.
        self hgExecutable.
    ].
    ^ HGExecutableArguments



    "
     HGExecutable := nil.
     self basicNew executable
    "

    "Created: / 17-07-2014 / 11:16:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommand class methodsFor:'commands'!

add
    ^add new

    "Created: / 15-11-2012 / 00:06:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

bookmark
    "raise an error: this method should be implemented (TODO)"

    ^ bookmark new

    "Created: / 20-03-2014 / 17:25:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

bookmark_delete

    ^ bookmark_delete new

    "Created: / 21-03-2014 / 01:14:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

branches
    ^branches new

    "Created: / 27-11-2012 / 19:56:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

cat
    ^cat new

    "Created: / 17-11-2012 / 00:16:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

clone
    ^clone new

    "Created: / 01-10-2012 / 00:09:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

commit
    ^commit new

    "Created: / 12-11-2012 / 22:40:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

heads
    ^heads new

    "Created: / 27-11-2012 / 21:32:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

init
    ^init new

    "Created: / 13-02-2014 / 12:37:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

locate
    ^locate new

    "Created: / 16-11-2012 / 22:36:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

log
    ^log new

    "Created: / 13-11-2012 / 09:00:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

merge
    ^merge new

    "Created: / 14-01-2013 / 16:03:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

mv
    ^mv new

    "Created: / 15-11-2012 / 00:22:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

pull
    ^pull new

    "Created: / 27-11-2012 / 23:30:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

push
    ^push new

    "Created: / 30-09-2012 / 23:46:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

remove
    ^remove new

    "Created: / 15-11-2012 / 00:06:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

resolve
    ^resolve new

    "Created: / 14-01-2013 / 18:20:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

resolve__list
    ^resolve__list new

    "Created: / 14-01-2013 / 16:42:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

share
    ^share new

    "Created: / 25-08-2015 / 01:50:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

showconfig
    ^showconfig new

    "Created: / 06-12-2012 / 20:24:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

status
    ^status new

    "Created: / 23-10-2012 / 11:10:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

update
    ^update new

    "Created: / 21-11-2012 / 00:23:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommand class methodsFor:'commands-shortcuts'!

clone: url to: stringOfFilename
    self clone
        url: url;
        path: stringOfFilename asFilename asAbsoluteFilename pathName;
        execute

    "Created: / 01-10-2012 / 00:06:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

init: aStringOrFilename
    ^ self init path: aStringOrFilename; yourself

    "Created: / 13-02-2014 / 12:37:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommand class methodsFor:'testing'!

isAvailable
    "Return true, it `hg` command is present and of a supported
     version, false otherwise."
    
    HGExecutable isNil ifTrue:[
        [ self hgExecutable ] on:HGCommandError do:[ ^ false ].
    ].
    ^ HGExecutable notNil

    "
     HGCommand hgAvailable"
    "Created: / 23-04-2016 / 22:05:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommand methodsFor:'accessing'!

result
    ^ result
!

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
!

workingDirectoryOrNil
    ^workingDirectory

    "Created: / 04-03-2013 / 10:04:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommand methodsFor:'accessing-internal'!

blocker
    ^ blocker
!

errorReader
    ^ errorReader
!

errors
    ^ errors
!

outputReader
    ^ outputReader
! !

!HGCommand methodsFor:'error reporting'!

propagate: anException
    "Propagates the error to the process that invoked #execute.
     Used by sub-processes to signal errors to the caller"

    self assert: anException isException.

    Trace ifTrue:[
        Logger log: 'cmd: propagating: ' , anException class name , ' - ', anException description severity: #trace facility: 'HG'.
    ].
    Debug ifTrue:[
        anException isNotification ifFalse:[
            | wasResumable |  

            anException suspendedContext notNil ifTrue:[
                anException suspendedContext fullPrintAllOn: Transcript.
            ].
            "/ When debugging, open a debugger here so the user may check the 
            "/ stack and actual variable values in debugger.
            Debugger enter.
        ].
    ].
    errors nextPut: anException.

    "Created: / 04-02-2013 / 21:29:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2014 / 00:08:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-07-2014 / 08:21:15 / jv"
!

signal
    "Signal all propagated exceptions to the caller"

    | ex |

    [ (ex := errors nextOrNil) notNil ] whileTrue:[
        Trace ifTrue:[
            Logger log: 'cmd: signalling: ' , ex description severity: #trace facility: 'HG'.
        ].
        (ex isNotification or:[ex isResumable == true]) ifTrue:[
            ex raiseRequest
        ] ifFalse:[
            ex raise
        ]
    ].

    "Created: / 04-02-2013 / 21:33:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-08-2013 / 08:51:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommand methodsFor:'executing'!

execute
    | stdoutPipe stdout stderrPipe stderr pid environment status exe args spin |

    self initialize.

    stdoutPipe := NonPositionableExternalStream makePipe.
    stdout := stdoutPipe first.

    stderrPipe := NonPositionableExternalStream makePipe.
    stderr := stderrPipe first.

    environment := OperatingSystem isUNIXlike
                    ifTrue:[OperatingSystem getEnvironment copy]
                    ifFalse:[environment := Dictionary new].
    environment at: 'HGEDITOR' put: 'true'.
    environment at:'LANG' put:'C'.
    environment at:'LC_MESSAGES' put:'C'.

    exe := self executable.
    args := self arguments.

    "/ Empty arguments are not supported. They make no sense anyway,
    "/ perhaps except for commit message. But empty commit messages
    "/ aren't supported by Mercurial itself.
    "/ Just be defensive and make sure none of them is empty...
    args do:[:arg | self assert: arg notEmptyOrNil ].

    OperatingSystem isMSWINDOWSlike ifTrue:[
        (exe endsWith:'.bat') ifTrue:[
            | cmd |
            cmd := OperatingSystem pathOfCommand:'cmd'.
            args := #( '/C' ) , args.
            exe := cmd.
        ].
        args := String streamContents:[:s|
            args
                do:[:each | self quoteShellCommandParameter: each asForCmdOn: s ]
                separatedBy: [ s space ]
        ]
    ].


    Processor monitor:[
        Trace ifTrue:[
            Logger log: 'cmd: executing: ' , (args isString ifTrue:[args] ifFalse:[args asStringWith:' ']) severity: #trace facility: 'HG'.
        ].
        pid := OperatingSystem exec: exe withArguments:args
            environment:environment
            fileDescriptors:{0 . stdoutPipe second fileDescriptor . stderrPipe second fileDescriptor}
            fork:true
            newPgrp:false
            inDirectory:self workingDirectory
    ] action:[:stat |
        Trace ifTrue:[
            Logger log: 'cmd: command finished with code ' , stat code printString severity: #trace facility: 'HG'.
        ].
        status := stat.
        blocker signal.
    ].


    stdoutPipe second close.
    stderrPipe second close.
    pid isNil ifTrue:[
        stdout close.
        stderr close.
        HGCommandError raiseErrorString: 'cannot execute hg command'.
        ^ self.
    ].
    OperatingSystem isUNIXlike ifTrue:[
        "/JV: Q: Why this is necessary?
        stdout readWaitWithTimeoutMs: 10.
        stderr readWaitWithTimeoutMs: 10.
    ].
    Debug ifTrue:[
        OperatingSystem isUNIXlike ifTrue:[
            "/ Transcript showCR:'hg stderr:'; showCR:stderr contents asString.
            stdout := stdout contents asString readStream.
            stderr := stderr contents asString readStream.
        ] ifFalse:[
            | buffer |

            buffer := (String new: 100) writeStream.
            [ stdout atEnd ] whileFalse:[
                buffer nextPut: stdout next.
            ].
            stdout := buffer contents readStream.
            buffer := String new writeStream.
            [ stderr atEnd ] whileFalse:[
                buffer nextPut: stderr next.
            ].
            stderr := buffer contents readStream.
        ]
    ].

    self spawnErrorReaderOn: stderr.
    self spawnOutputReaderOn: stdout.

    spin := SemaphoreSet with: blocker with: errors readSemaphore.

    [
        [ spin wait ~~ blocker ] whileTrue:[ self signal ]
    ] ensure:[
        stderr close.
        stdout close.
    ].
    self signal.
    Trace ifTrue:[
        Logger log: 'returning' severity: #trace facility: 'HG'.
    ].
    ^self status: status result: result

    "Created: / 11-05-2011 / 07:45:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-12-2011 / 19:22:00 / dundee"
    "Modified (format): / 27-12-2011 / 15:53:54 / dundee"
    "Modified: / 14-11-2012 / 13:41:57 / jv"
    "Modified: / 15-11-2014 / 00:10:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

executeOnRepository: anHGRepository
    workingDirectory isNil ifTrue:[
        workingDirectory := anHGRepository pathName
    ].
    ^self execute.

    "Created: / 03-03-2013 / 20:34:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

quoteShellCommandParameter: parameter asForCmdOn: stream
    "Quotes the parameter as neccesary on Windows"

    "/ Adapted version of ArgvQuote,
    "/ see http://blogs.msdn.com/b/twistylittlepassagesallalike/archive/2011/04/23/everyone-quotes-arguments-the-wrong-way.aspx

    | parameterS |

    stream nextPut: $".
    parameterS := parameter readStream.
    [ parameterS atEnd ] whileFalse:[
        | numBackSlashes |

        numBackSlashes := 0.

        [ parameterS atEnd not and:[ parameterS peek == $\ ] ] whileTrue:[
            numBackSlashes := numBackSlashes + 1.
            parameterS next.
        ].
        parameterS atEnd ifTrue:[
            "/ Escape all backslashes, but let the terminating
            "/ double quotation mark we add below be interpreted
            "/ as a metacharacter.
            stream next: numBackSlashes * 2 put: $\
        ] ifFalse:[
            parameterS peek == $" ifTrue:[
                "/ Escape all backslashes and the following
                "/ double quotation mark.
                stream next: numBackSlashes * 2 put: $\.
                stream nextPut: $\.
                stream nextPut: $".
            ] ifFalse:[
                "/ Backslashes aren't special here.
                stream next: numBackSlashes put: $\.               
                stream nextPut: parameterS peek.
            ].
            parameterS next.
        ].
    ].
    stream nextPut: $".
! !

!HGCommand methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."

    "/ please change as required (and remove this comment)
    "/ workingDirectory := nil.
    "/ result := nil.
    "/ error := nil.
    "/ workers := nil.
    "/ errors := nil.

    errors := SharedQueue new.
    blocker := (Semaphore new:-2) name: 'Waiting for hg command to finish'.



    "/ super initialize.   -- commented since inherited method does nothing

    "Modified: / 03-03-2013 / 19:50:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommand methodsFor:'private'!

arguments

    ^ OrderedCollection streamContents:[:s |
        s nextPut: self executable.
        s nextPutAll: self class hgExecutableArguments ? #().
        s nextPut: '--noninteractive'.
        
        "/ We must enable share extension to make sure bookmarks
        "/ work fine. This should be safe as share extension is
        "/ distributed with mercurial since 1.3 (which is not supported
        "/ by libscm) so it's always available

	s nextPut: '--config'.
	s nextPut: 'extensions.share='.
        self argumentsGlobalOn:s.
        s nextPut:self command.
        self argumentsCommandOn:s.
    ].

    "Created: / 11-05-2011 / 07:58:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 27-12-2011 / 15:47:23 / dundee"
    "Modified: / 17-07-2014 / 15:25:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

argumentsCommandOn:stream
    "Called to get command specific options"

    self subclassResponsibility

    "Created: / 11-05-2011 / 07:58:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 27-12-2011 / 15:46:59 / dundee"
    "Modified: / 16-11-2012 / 22:31:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

argumentsGlobalOn:stream
    "Called to get global options"


    "Created: / 11-05-2011 / 07:58:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 27-12-2011 / 15:47:10 / dundee"
    "Modified: / 30-09-2012 / 23:43:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-11-2016 / 20:02:13 / jenkins"
!

command
    "Returns the hg 'command' option, i.e. commit,
     push, pull, ..."

    ^self class nameWithoutPrefix

    "
        HGCommand::push basicNew command
    "

    "Created: / 11-05-2011 / 07:58:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 27-12-2011 / 15:47:17 / dundee"
    "Modified: / 30-09-2012 / 23:37:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 08-02-2014 / 11:41:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

executable
    ^ self class hgExecutable

    "Modified: / 17-07-2014 / 10:16:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseError:stream
    "Parses output of 'hg' command, i.e. commit, log, update, checkout,
     etc."

    ^ (self parserOn: stream) parseError.

    "Created: / 04-02-2013 / 11:59:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseOutput:stream
    "Parses output of 'hg' command, i.e. commit, log, update, checkout,
     etc."

    ^ self subclassResponsibility

    "Created: / 11-05-2011 / 07:58:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 17-12-2011 / 17:02:41 / dundee"
    "Modified (comment): / 17-10-2012 / 13:14:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parserOn: aStream
    "Returns an HGCommandParser initialized on given stream."

    ^HGCommandParser for: self on: aStream

    "Created: / 04-02-2013 / 12:17:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-02-2013 / 14:14:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

spawn:block name: name
    "Spawn a new background thread executing given block"

    | worker |

    worker := [
        Trace ifTrue:[
            Logger log: 'cmd: worker ''', name , ''' spawned' severity: #trace facility: 'HG'.
        ].
        block on: Error do:[:ex|
            self propagate:ex
        ]
    ] newProcess.
    worker addExitAction:[
        Trace ifTrue:[
            Logger log: 'cmd: worker ''', name , ''' finished' severity: #trace facility: 'HG'.
        ].
        blocker notNil ifTrue:[blocker signal].
    ].
    worker resume.
    worker name: name.
    ^worker

    "Created: / 03-03-2013 / 16:56:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2013 / 19:42:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 17-07-2014 / 07:31:58 / jv"
!

spawnErrorReaderOn: stderr
    errorReader isNil ifTrue:[
        errorReader := self spawn: [
            "/ Workaround for bug in PipeStream on Windows.
            "/ Should be removed once PipeStreamTest>>testReadPipe6 gets fixed        
            stderr atEnd.
            self parseError:  stderr 
        ] name: 'Error reader'.
        errorReader priority: errorReader priority + 1.
    ].

    "Created: / 03-03-2013 / 16:59:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-03-2013 / 11:42:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

spawnOutputReaderOn: stdout
    outputReader isNil ifTrue:[
        outputReader := self spawn: [ 
            "/ Workaround for bug in PipeStream on Windows.
            "/ Should be removed once PipeStreamTest>>testReadPipe6 gets fixed        
            stdout atEnd. 
            result := self parseOutput: stdout 
        ] name: 'Output reader'.
    ]

    "Created: / 03-03-2013 / 17:00:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

status: status result: res
    "Called when hg command finishes, passing it's status and result from parser"

    status success  ifFalse:[
        HGCommandError raiseErrorString: ('hg command failed (status %1)' expandMacrosWith: status code) .
    ].
    ^res

    "Created: / 15-11-2012 / 17:04:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-03-2013 / 22:32:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommand methodsFor:'queries'!

modifiesRepository
    "Return true if this command may modify the repository,
     such as by adding/removing changesets, changing bookmarks,
     heads and so on, False otherwise."

    ^ self subclassResponsibility

    "Created: / 11-10-2015 / 07:27:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommand::add methodsFor:'accessing'!

paths
    ^ paths
!

paths:something
    paths := something.
! !

!HGCommand::add methodsFor:'private'!

argumentsCommandOn:stream
    "Called to get command specific options"

    paths isEmptyOrNil ifTrue:[
        self error: 'No paths given'
    ].
    stream nextPutAll: paths

    "Created: / 15-11-2012 / 00:05:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseOutput:stream
    "Parses output of 'hg' command, i.e. commit, log, update, checkout,
     etc."

    ^ nil

    "Modified: / 15-11-2012 / 00:38:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommand::add methodsFor:'queries'!

modifiesRepository
    "Return true if this command may modify the repository,
     such as by adding/removing changesets, changing bookmarks,
     heads and so on, False otherwise."

    ^ false

    "Modified (format): / 11-10-2015 / 07:28:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommand::bookmark methodsFor:'accessing'!

name
    ^ name
!

name:something
    name := something.
!

revision
    ^ revision
!

revision:something
    revision := something.
! !

!HGCommand::bookmark methodsFor:'private'!

argumentsCommandOn:stream
    revision notNil ifTrue:[
        stream
            nextPut: '-r';
            nextPut: (revision hasRevnoOnly ifTrue:[revision revno printString] ifFalse:[revision printStringWithoutNumber]).
    ].
    stream
        nextPut: name.

    "Created: / 20-03-2014 / 17:26:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-11-2014 / 16:03:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseError:stream
    ^ (self parserOn: stream) parseErrorBookmark

    "Created: / 20-03-2014 / 17:27:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseOutput:stream
    "Parses output of 'hg' command, i.e. commit, log, update, checkout,
     etc."

    ^ nil

    "Created: / 20-03-2014 / 17:27:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommand::bookmark methodsFor:'queries'!

modifiesRepository
    "Return true if this command may modify the repository,
     such as by adding/removing changesets, changing bookmarks,
     heads and so on, False otherwise."

    ^ true

    "Modified: / 11-10-2015 / 07:28:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommand::bookmark_delete methodsFor:'accessing'!

name
    ^ name
!

name:something
    name := something.
! !

!HGCommand::bookmark_delete methodsFor:'private'!

argumentsCommandOn:stream
    stream
        nextPut: '--delete';
        nextPut: name.

    "Created: / 20-03-2014 / 17:26:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-03-2014 / 01:14:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

command
    "Returns the hg 'command' option, i.e. commit,
     push, pull, ..."

    ^ 'bookmark'

    "
        HGCommand::push basicNew command
    "

    "Created: / 21-03-2014 / 01:21:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseError:stream
    ^ (self parserOn: stream) parseErrorBookmark

    "Created: / 20-03-2014 / 17:27:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseOutput:stream
    "Parses output of 'hg' command, i.e. commit, log, update, checkout,
     etc."

    ^ nil

    "Created: / 20-03-2014 / 17:27:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommand::bookmark_delete methodsFor:'queries'!

modifiesRepository
    "Return true if this command may modify the repository,
     such as by adding/removing changesets, changing bookmarks,
     heads and so on, False otherwise."

    ^ true

    "Modified: / 11-10-2015 / 07:29:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommand::branches methodsFor:'accessing'!

active
    ^ active
!

active:aBoolean
    active := aBoolean.
!

closed
    ^ closed
!

closed:aBoolean
    closed := aBoolean.
! !

!HGCommand::branches methodsFor:'private'!

argumentsCommandOn:stream
    "Called to get command specific options"

    active == true ifTrue:[
        stream nextPut:'--active'
    ].
    closed == true ifTrue:[
        stream nextPut:'--closed'
    ].

    "Created: / 27-11-2012 / 19:54:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseError:stream
    ^ (self parserOn: stream) parseErrorBranches.

    "Created: / 06-02-2013 / 19:20:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseOutput:stream
    "Parses output of 'hg' command, i.e. commit, log, update, checkout,
     etc."

    ^ (self parserOn:stream) parseCommandBranches

    "Created: / 27-11-2012 / 19:55:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommand::branches methodsFor:'queries'!

modifiesRepository
    "Return true if this command may modify the repository,
     such as by adding/removing changesets, changing bookmarks,
     heads and so on, False otherwise."

    ^ false

    "Modified: / 11-10-2015 / 07:29:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommand::cat methodsFor:'accessing'!

destination
    ^ destination
!

destination:aStringOrFilename
    destination := aStringOrFilename.
!

path
    ^ path
!

path:something
    path := something.
!

revision
    ^ revision
!

revision:something
    revision := something.
! !

!HGCommand::cat methodsFor:'executing'!

execute
    "
    A hacked version of #execute that returns a open read
    stream to read directly from 'hg cat' stdout...

    "

    | pipe output pid environment sema args sout exec |

    destination notNil ifTrue:[
        ^ super execute.
    ].

    pipe := NonPositionableExternalStream makePipe.
    output := pipe first.

    OperatingSystem isUNIXlike ifTrue:[
        environment := OperatingSystem getEnvironment copy.
    ] ifFalse:[
        environment := Dictionary new.
    ].
    environment at:'LANG' put:'C'.

    args := self arguments.
    OperatingSystem isMSWINDOWSlike ifTrue:[
        args := String streamContents:[:s|
            args
                do:[:each | s nextPut:$"; nextPutAll: each; nextPut: $"]
                separatedBy: [ s space ]
        ]
    ].

    sout := pipe second.
    sema := Semaphore new name: 'Waiting for hg command to finish'.
    exec := [
        pid := OperatingSystem exec:(self executable) withArguments:args
                environment:environment
                fileDescriptors:{0 . sout fileDescriptor . pipe second fileDescriptor}
                fork:true
                newPgrp:false
                inDirectory:self workingDirectory.
    ].

    destination notNil ifTrue:[
        Processor
            monitor:exec
            action:[:stat |
                sema signal.
            ].
    ] ifFalse:[
        exec value
    ].


    pipe second close.
    sout close.
    pid isNil ifTrue:[
        HGCommandError raiseErrorString: 'cannot execute hg command'.
        output close.
        ^ self.
    ].
    ^ output.

    "Created: / 17-11-2012 / 00:13:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-07-2014 / 16:46:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommand::cat methodsFor:'private'!

argumentsCommandOn:stream
    "Called to get command specific options"

    path isNil ifTrue:[
        self error:'No path specified'
    ].
    revision isNil ifTrue:[
        self error:'No revision specified'
    ].
    destination notNil ifTrue:[
        stream nextPut: '-o'.
        stream nextPut: destination asFilename pathName.
    ].

    stream nextPut:'--rev'; nextPut: revision asString.
    stream nextPut:path

    "Modified: / 06-07-2014 / 16:45:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseOutput:stream
    "Parses output of 'hg' command, i.e. commit, log, update, checkout,
     etc."

    "/ Nothing to do...

    "Modified: / 06-07-2014 / 16:53:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommand::cat methodsFor:'queries'!

modifiesRepository
    "Return true if this command may modify the repository,
     such as by adding/removing changesets, changing bookmarks,
     heads and so on, False otherwise."

    ^ false

    "Modified: / 11-10-2015 / 07:29:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommand::clone methodsFor:'accessing'!

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

!HGCommand::clone methodsFor:'private'!

argumentsCommandOn:stream
    "Called to get command specific options"
    update == false ifTrue:[
        stream nextPut:'--noupdate'.
    ].
    stream nextPut: url; nextPut: path.

    "Created: / 01-10-2012 / 00:04:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-11-2012 / 00:17:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseOutput:stream
    "superclass Command says that I am responsible to implement this method"

    ^ nil

    "Modified: / 14-11-2012 / 22:42:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommand::clone methodsFor:'queries'!

modifiesRepository
    "Return true if this command may modify the repository,
     such as by adding/removing changesets, changing bookmarks,
     heads and so on, False otherwise."

    ^ false

    "Modified: / 11-10-2015 / 07:29:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommand::commit methodsFor:'accessing'!

amend
    ^ amend
!

amend:aBoolean
    amend := aBoolean.
!

author
    ^ author
!

author:aString
    author := aString.
!

date
    ^ date
!

date:aTimestampOrString
    date := aTimestampOrString.
!

files
    ^ files
!

files:something
    files := something.
!

message
    ^ message
!

message:something
    message := something.
! !

!HGCommand::commit methodsFor:'executing'!

execute
    message isEmptyOrNil ifTrue:[ 
        ^ HGCommitError raiseErrorString: 'empty commit message'.  
    ].
    ^ super execute

    "Created: / 16-11-2014 / 23:50:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommand::commit methodsFor:'private'!

argumentsCommandOn:stream
    "Called to get command specific options"

    author notNil ifTrue:[
        stream nextPut:'--user'; nextPut: author
    ].
    date notNil ifTrue:[
        stream nextPut:'--date'.
        date isTimestamp ifTrue:[
            stream nextPut: (date printStringFormat: '%(year)-%(month)-%(day) %H:%m:%S')
        ] ifFalse:[
            stream nextPut: date asString
        ]
    ].
    amend == true ifTrue:[
        stream nextPut:'--amend'.
    ].

    stream nextPut:'-m'; nextPut: message.
    files notNil ifTrue:[
        stream nextPutAll: files
    ].

    "Created: / 12-11-2012 / 22:38:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-12-2012 / 15:32:51 / jv"
    "Modified: / 25-08-2015 / 16:04:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseError:stream
    "Parses output of 'hg' command, i.e. commit, log, update, checkout,
     etc."

    ^ (self parserOn: stream) parseErrorCommit.

    "Created: / 04-02-2013 / 12:28:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseOutput:stream
    "superclass HGCommand says that I am responsible to implement this method"
    "Nothing to do"
    "Modified: / 12-11-2012 / 22:38:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

status: status result: result
    "Called when hg command finishes, passing it's status and result from parser"

    (status code ~~ 0 and:[status code ~~ 1]) ifTrue:[
        HGCommandError raiseErrorString: ('hg command failed (status %1)' expandMacrosWith: status code) .
    ].
    ^result

    "Created: / 15-11-2012 / 17:06:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommand::commit methodsFor:'queries'!

modifiesRepository
    "Return true if this command may modify the repository,
     such as by adding/removing changesets, changing bookmarks,
     heads and so on, False otherwise."

    ^ true

    "Modified: / 11-10-2015 / 07:29:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommand::heads methodsFor:'private'!

argumentsCommandOn:stream
    "Called to get command specific options"

    stream
        nextPut:'--template';
        nextPut:HGCommandParser templateHeads.

    "Created: / 27-11-2012 / 21:30:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseOutput:stream
    "Parses output of 'hg' command, i.e. commit, log, update, checkout,
     etc."

    ^ (self parserOn:stream) parseCommandHeads

    "Created: / 27-11-2012 / 21:30:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

status: status result: res
    "Called when hg command finishes, passing it's status and result from parser"
    status code == 1 ifTrue:[
        ^#()
    ].
    status success  ifFalse:[
        HGCommandError raiseErrorString: ('hg command failed (status %1)' expandMacrosWith: status code) .
    ].
    ^res

    "Created: / 15-11-2012 / 17:04:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-03-2013 / 19:35:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommand::heads methodsFor:'queries'!

modifiesRepository
    "Return true if this command may modify the repository,
     such as by adding/removing changesets, changing bookmarks,
     heads and so on, False otherwise."

    ^ false

    "Modified: / 11-10-2015 / 07:29:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommand::help methodsFor:'private'!

argumentsCommandOn:stream
    "Called to get command specific options"

    ^ self shouldNotImplement

    "Modified: / 11-10-2015 / 07:31:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseOutput:stream
    "Parses output of 'hg' command, i.e. commit, log, update, checkout,
     etc."

    ^ self shouldImplement
! !

!HGCommand::help methodsFor:'queries'!

modifiesRepository
    "Return true if this command may modify the repository,
     such as by adding/removing changesets, changing bookmarks,
     heads and so on, False otherwise."

    ^ false

    "Modified: / 11-10-2015 / 07:30:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommand::init methodsFor:'accessing'!

path
    ^ path
!

path:aStringOrFilename
    path := aStringOrFilename.
! !

!HGCommand::init methodsFor:'private'!

argumentsCommandOn:stream
    stream nextPut: path asFilename asAbsoluteFilename pathName
    
    "Created: / 13-02-2014 / 12:36:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseOutput:stream
    "Parses output of 'hg' command, i.e. commit, log, update, checkout,
     etc."

    ^ nil

    "Created: / 13-02-2014 / 12:36:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommand::init methodsFor:'queries'!

modifiesRepository
    "Return true if this command may modify the repository,
     such as by adding/removing changesets, changing bookmarks,
     heads and so on, False otherwise."

    ^ true

    "Modified: / 11-10-2015 / 07:30:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommand::locate methodsFor:'accessing'!

revision
    ^ revision
!

revision:rev
    revision := rev.
! !

!HGCommand::locate methodsFor:'private'!

argumentsCommandOn:stream
    "Called to get command specific options"

    "/stream nextPut:'--print0'.
    revision notNil ifTrue:[
        stream nextPut: '--rev'; nextPut: revision printString.
    ].

    "Modified: / 16-12-2012 / 00:09:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseOutput:stream
    "Parses output of 'hg' command, i.e. commit, log, update, checkout,
     etc."

    ^ (self parserOn:stream) parseCommandLocate

    "Modified: / 16-11-2012 / 22:33:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommand::locate methodsFor:'queries'!

modifiesRepository
    "Return true if this command may modify the repository,
     such as by adding/removing changesets, changing bookmarks,
     heads and so on, False otherwise."

    ^ false

    "Modified: / 11-10-2015 / 07:30:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommand::log methodsFor:'accessing'!

childrenOnly
    ^ childrenOnly
!

childrenOnly:aBoolean
    childrenOnly := aBoolean.
!

hidden
    ^ hidden
!

hidden:aBoolean
    hidden := aBoolean.
!

idsOnly
    ^ idsOnly
!

idsOnly:aBoolean
    idsOnly := aBoolean.
!

limit
    ^ limit
!

limit:anInteger
    limit := anInteger.
!

path
    ^ path
!

path:aString
    path := aString.
!

revset: revset
    revsets isNil ifTrue:[revsets := OrderedCollection new].
    revsets add: revset.

    "Created: / 22-01-2013 / 16:16:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

revsets: aCollection
    revsets isNil ifTrue:[
        revsets := aCollection
    ] ifFalse:[
        revsets addAll: aCollection
    ].

    "Created: / 22-01-2013 / 16:21:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommand::log methodsFor:'private'!

argumentsCommandOn:stream
    "Called to get command specific options"

    | template |

    template := HGCommand hgVersionIsGreaterOrEqualThan_2_4
                    ifTrue:[ HGCommandParser templateLog ]
                    ifFalse:[ HGCommandParser templateLogForVersionLessThan2_4 ].

    path isNil ifTrue:[
        revsets isEmptyOrNil ifTrue:[
            self error:'No revisions given'.
        ].
        revsets do:[:revset|
            | string |

            string := revset asString.
            string isEmptyOrNil ifTrue:[ string := ':' "All changes" ].

            stream nextPut:'--rev'.
            stream nextPut:string
        ].
    ] ifFalse:[
        stream nextPut: '--follow'.
    ].
    idsOnly == true ifTrue:[
        template := HGCommandParser templateLogIdsOnly.
    ].

    childrenOnly == true ifTrue:[
        template := HGCommandParser templateLogChildren.
    ].

    HGCommand hgVersionIsGreaterOrEqualThan_2_4 ifFalse:[ 
        stream nextPut:'--debug'.
    ].
    stream
        nextPut:'--template';
        nextPut:template.
    limit notNil ifTrue:[
        stream
            nextPut: '-l';
            nextPut: limit printString
    ].

    path notNil ifTrue:[
        stream nextPut: path.
    ].

    "Created: / 13-11-2012 / 09:05:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-11-2014 / 23:24:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

argumentsGlobalOn:stream
    "Called to get global options"

    super argumentsGlobalOn:stream.
    hidden == true ifTrue:[
        "/ --hidden is supported since 2.5
        HGCommand hgVersionIsGreaterOrEqualThan_2_5 ifTrue:[
            stream nextPut: '--hidden'
        ].
    ].

    "Created: / 22-03-2016 / 20:02:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-03-2016 / 17:25:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseOutput:stream
    "Parses output of 'hg' command, i.e. commit, log, update, checkout,
     etc."

    childrenOnly == true ifTrue:[
        ^ (self parserOn:stream) parseCommandLogChildren.
    ].
    ^ idsOnly ~~ true
        ifTrue:[ (self parserOn:stream) parseCommandLog ]
        ifFalse:[ (self parserOn:stream) parseCommandLogIdsOnly ]

    "Created: / 13-11-2012 / 09:05:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-02-2014 / 22:12:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommand::log methodsFor:'queries'!

modifiesRepository
    "Return true if this command may modify the repository,
     such as by adding/removing changesets, changing bookmarks,
     heads and so on, False otherwise."

    ^ false

    "Modified: / 11-10-2015 / 07:30:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommand::merge methodsFor:'accessing'!

revision
    ^ revision
!

revision:something
    revision := something.
!

tool
    ^ tool
!

tool:aString
    tool := aString.
! !

!HGCommand::merge methodsFor:'private'!

argumentsCommandOn:stream
    "Called to get command specific options"

    revision notNil ifTrue:[
        stream nextPut:'--rev'; nextPut: revision asString.
    ].

    revision notNil ifTrue:[
        stream nextPut:'--tool'; nextPut: tool asString.
    ].

    "Modified: / 14-01-2013 / 15:40:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseOutput:stream
    "Parses output of 'hg' command, i.e. commit, log, update, checkout,
     etc."

    ^ (self parserOn:stream) parseCommandMerge

    "Modified: / 14-01-2013 / 16:00:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

status: status result: result
    "Called when hg command finishes, passing it's status and result from parser"

    (status code ~~ 0 and:[status code ~~ 1]) ifTrue:[
        HGCommandError raiseErrorString: ('hg command failed (status %1)' expandMacrosWith: status code) .
    ].
    ^result

    "Created: / 14-01-2013 / 16:05:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommand::merge methodsFor:'queries'!

modifiesRepository
    "Return true if this command may modify the repository,
     such as by adding/removing changesets, changing bookmarks,
     heads and so on, False otherwise."

    ^ false

    "Modified: / 11-10-2015 / 07:30:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommand::mv methodsFor:'accessing'!

destination
    ^ destination
!

destination:something
    destination := something.
!

source
    ^ source
!

source:something
    source := something.
! !

!HGCommand::mv methodsFor:'private'!

argumentsCommandOn:stream
    "Called to get command specific options"

    source isNil ifTrue:[
        self error:'No source'
    ].
    source asFilename exists ifFalse:[
        self error:('(Source does not exist (%1)' bindWith: source)
    ].
    destination isNil ifTrue:[
        self error:'No destination'
    ].
    stream nextPut: source asString; nextPut: destination.

    "Created: / 15-11-2012 / 00:21:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseOutput:stream
    "Parses output of 'hg' command, i.e. commit, log, update, checkout,
     etc."

    ^ nil

    "Modified: / 15-11-2012 / 00:38:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommand::mv methodsFor:'queries'!

modifiesRepository
    "Return true if this command may modify the repository,
     such as by adding/removing changesets, changing bookmarks,
     heads and so on, False otherwise."

    ^ false

    "Modified: / 11-10-2015 / 07:30:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommand::pull methodsFor:'accessing'!

url
    ^ url
!

url:aString
    url := aString.
! !

!HGCommand::pull methodsFor:'private'!

argumentsCommandOn:stream
    "Called to get command specific options"

    url notNil ifTrue:[
        stream nextPut: url.
    ].

    "Created: / 30-09-2012 / 23:44:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-11-2012 / 09:56:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseOutput:stream
    "superclass HGCommand says that I am responsible to implement this method"

    ^ (self parserOn:stream) parseCommandPull

    "Modified: / 04-02-2013 / 15:35:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

status: status result: res
    "Called when hg command finishes, passing it's status and result from parser"

    (status code == 1) ifTrue:[
        "/ For whatever reason, Mercurial 2.1 returns exit statis
        "/ of 1 if no changes has been found. No other release does it.
        HGCommand hgVersion = #(2 1 nil) ifTrue:[ ^ res ].
    ].
    (status code ~~ 0) ifTrue:[
        HGCommandError raiseErrorString: ('hg command failed (status %1)' expandMacrosWith: status code) .
    ].
    res isNil ifTrue:[
        HGCommandError raiseErrorString: ('hg command failed (no output)' expandMacrosWith: status code) .
    ].
    ^ res

    "Created: / 15-11-2012 / 17:06:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommand::pull methodsFor:'queries'!

modifiesRepository
    "Return true if this command may modify the repository,
     such as by adding/removing changesets, changing bookmarks,
     heads and so on, False otherwise."

    ^ true

    "Modified: / 11-10-2015 / 07:30:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommand::push methodsFor:'accessing'!

force
    ^ force
!

force:something
    force := something.
!

url
    ^ url
!

url:remote
    url := remote.
! !

!HGCommand::push methodsFor:'private'!

argumentsCommandOn:stream
    "Called to get command specific options"


    stream nextPut: (url ? 'default').

    force == true ifTrue:[
        stream nextPut:'--force'
    ]

    "Created: / 30-09-2012 / 23:44:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 29-01-2013 / 15:42:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseError:stream
    "Parses output of 'hg' command, i.e. commit, log, update, checkout,
     etc."

    ^ (self parserOn: stream) parseErrorPush.

    "Created: / 04-02-2013 / 12:53:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseOutput:stream
    "superclass HGCommand says that I am responsible to implement this method"

    ^ (self parserOn:stream) parseCommandPush

    "Modified: / 10-12-2012 / 02:15:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

status: status result: res
    "Called when hg command finishes, passing it's status and result from parser"

    (status code ~~ 0 and:[status code ~~ 1]) ifTrue:[
        HGCommandError raiseErrorString: ('hg command failed (status %1)' expandMacrosWith: status code) .
    ].
    res isNil ifTrue:[
        HGCommandError raiseErrorString: ('hg command failed (no output)' expandMacrosWith: status code) .
    ].
    ^ result

    "Created: / 15-11-2012 / 17:06:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommand::push methodsFor:'queries'!

modifiesRepository
    "Return true if this command may modify the repository,
     such as by adding/removing changesets, changing bookmarks,
     heads and so on, False otherwise."

    ^ false

    "Modified: / 11-10-2015 / 07:30:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommand::remove methodsFor:'accessing'!

force
    ^ force
!

force:something
    force := something.
!

paths
    ^ paths
!

paths:something
    paths := something.
! !

!HGCommand::remove methodsFor:'private'!

argumentsCommandOn:stream
    "Called to get command specific options"

    force == true ifTrue:[
        stream nextPut: '-f'.
    ].

    paths isEmptyOrNil ifTrue:[
        self error: 'No paths given'
    ].
    stream nextPutAll: paths

    "Created: / 15-11-2012 / 00:05:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-10-2013 / 18:27:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseOutput:stream
    "Parses output of 'hg' command, i.e. commit, log, update, checkout,
     etc."

    ^ nil

    "Modified: / 15-11-2012 / 00:38:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommand::remove methodsFor:'queries'!

modifiesRepository
    "Return true if this command may modify the repository,
     such as by adding/removing changesets, changing bookmarks,
     heads and so on, False otherwise."

    ^ false

    "Modified: / 11-10-2015 / 07:30:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommand::resolve class methodsFor:'initialization'!

initialize
    "Invoked at system start or when the class is dynamically loaded."

    "/ please change as required (and remove this comment)


! !

!HGCommand::resolve methodsFor:'accessing'!

files
    ^ files
!

files:something
    files := something.
!

mark
    ^ mark
!

mark:something
    mark := something.
!

tool
    ^ tool
!

tool:something
    tool := something.
!

unmark
    ^ unmark
!

unmark:something
    unmark := something.
! !

!HGCommand::resolve methodsFor:'private'!

argumentsCommandOn:stream
    "Called to get command specific options"

    tool notNil ifTrue:[
        stream nextPut:'--tool'; nextPut: tool
    ].

    mark == true ifTrue:[
        self assert: (unmark isNil or:[unmark not]).
        stream nextPut: '--mark'.
    ].

    unmark == true ifTrue:[
        self assert: (mark isNil or:[mark not]).
        stream nextPut: '--unmark'.
    ].

    files do:[:f|stream nextPut: f].

    "Modified: / 26-06-2013 / 07:45:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseOutput:stream
    "Parses output of 'hg' command, i.e. commit, log, update, checkout,
     etc."

    ^ nil

    "Modified: / 14-01-2013 / 19:27:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

status: status result: result
    "Called when hg command finishes, passing it's status and result from parser"

    status code == 0 ifTrue:[ ^ true ].
    status code == 1 ifTrue:[ ^ false].

    HGCommandError raiseErrorString: ('hg command failed (status %1)' expandMacrosWith: status code).
    ^false

    "Created: / 14-01-2013 / 19:27:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommand::resolve methodsFor:'queries'!

modifiesRepository
    "Return true if this command may modify the repository,
     such as by adding/removing changesets, changing bookmarks,
     heads and so on, False otherwise."

    ^false

    "Modified: / 11-10-2015 / 07:30:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommand::resolve__list methodsFor:'private'!

argumentsCommandOn:stream
    "Called to get command specific options"

    stream nextPut: '--list'

    "Modified: / 14-01-2013 / 16:43:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

command
    ^'resolve'

    "Created: / 14-01-2013 / 16:50:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseOutput:stream
    "Parses output of 'hg' command, i.e. commit, log, update, checkout,
     etc."

    ^ (self parserOn:stream) parseCommandResolveList

    "Modified: / 14-01-2013 / 16:43:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommand::resolve__list methodsFor:'queries'!

modifiesRepository
    "Return true if this command may modify the repository,
     such as by adding/removing changesets, changing bookmarks,
     heads and so on, False otherwise."

    ^ false

    "Modified: / 11-10-2015 / 07:30:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommand::share methodsFor:'accessing'!

destination
    ^ destination
!

destination:aString
    destination := aString.
!

source
    ^ source
!

source:aString
    source := aString.
!

update
    ^ update
!

update:aBoolean
    update := aBoolean.
! !

!HGCommand::share methodsFor:'private'!

argumentsCommandOn:stream
    "Called to get command specific options"
    update == false ifTrue:[
        stream nextPut:'--noupdate'.
    ].
    self class hgVersionIsGreaterOrEqualThan_3_3 ifTrue:[ 
        stream nextPut: '--bookmarks'.
    ].
    stream nextPut: source; nextPut: destination.

    "Created: / 01-10-2012 / 00:04:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-09-2015 / 05:43:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseOutput:stream
    "superclass Command says that I am responsible to implement this method"

    ^ nil

    "Modified: / 14-11-2012 / 22:42:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommand::share methodsFor:'queries'!

modifiesRepository
    "Return true if this command may modify the repository,
     such as by adding/removing changesets, changing bookmarks,
     heads and so on, False otherwise."

    ^ false

    "Modified: / 11-10-2015 / 07:30:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommand::showconfig methodsFor:'accessing'!

argumentsCommandOn:stream
    "Called to get command specific options"

    key notNil ifTrue:[
        stream nextPut: key
    ].

    "Created: / 06-12-2012 / 15:53:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseOutput:stream
    "Parses output of 'hg' command, i.e. commit, log, update, checkout,
     etc."

    ^ (self parserOn:stream) parseCommandShowConfig

    "Created: / 06-12-2012 / 21:45:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommand::showconfig methodsFor:'queries'!

modifiesRepository
    "Return true if this command may modify the repository,
     such as by adding/removing changesets, changing bookmarks,
     heads and so on, False otherwise."

    ^ false

    "Modified: / 11-10-2015 / 07:31:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommand::status methodsFor:'accessing'!

paths
    ^ paths

    "Created: / 23-02-2017 / 14:18:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

paths:aCollection
    paths := aCollection.

    "Created: / 23-02-2017 / 14:18:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommand::status methodsFor:'private'!

argumentsCommandOn:stream
    "Called to get command specific options"

    stream nextPut:'-A'.
    paths notNil ifTrue:[stream nextPutAll: paths]

    "Created: / 23-10-2012 / 11:09:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-02-2017 / 14:18:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseOutput:stream
    ^ (self parserOn:stream) parseCommandStatus

    "Modified: / 23-10-2012 / 11:07:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommand::status methodsFor:'queries'!

modifiesRepository
    "Return true if this command may modify the repository,
     such as by adding/removing changesets, changing bookmarks,
     heads and so on, False otherwise."

    ^ false

    "Modified: / 11-10-2015 / 07:31:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommand::update methodsFor:'accessing'!

revision
    ^ revision
!

revision:something
    revision := something.
! !

!HGCommand::update methodsFor:'private'!

argumentsCommandOn:stream
    "Called to get command specific options"

    revision notNil ifTrue:[
        stream nextPut:'--rev'; nextPut: revision asString.
    ].

    "Modified: / 23-11-2012 / 23:08:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseOutput:stream
    "Parses output of 'hg' command, i.e. commit, log, update, checkout,
     etc."

    ^ (self parserOn:stream) parseCommandUpdate

    "Modified: / 14-01-2013 / 16:00:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommand::update methodsFor:'queries'!

modifiesRepository
    "Return true if this command may modify the repository,
     such as by adding/removing changesets, changing bookmarks,
     heads and so on, False otherwise."

    ^ false

    "Modified: / 11-10-2015 / 07:31:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommand::version methodsFor:'accessing'!

arguments:something
    arguments := something.
!

executable
    ^ executable notNil
        ifTrue:[executable]
        ifFalse:[self class hgExecutable]

    "Modified: / 18-07-2014 / 11:12:35 / jv"
!

executable:aString
    executable := aString.
! !

!HGCommand::version methodsFor:'private'!

arguments

    ^ (Array with: self executable)
      , (arguments notNil ifTrue: [ arguments ] ifFalse: [ HGCommand hgExecutableArguments ])
      , #('--version')

    "Created: / 19-11-2012 / 20:01:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-07-2014 / 15:11:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-07-2014 / 11:18:36 / jv"
!

argumentsCommandOn:stream
    "Called to get command specific options"

    ^ self shouldNotImplement

    "Modified: / 11-10-2015 / 07:31:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseOutput:stream
    "Parses output of 'hg' command, i.e. commit, log, update, checkout,
     etc."

    ^ (self parserOn:stream) parseCommandVersion

    "Created: / 19-11-2012 / 20:02:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommand::version methodsFor:'queries'!

modifiesRepository
    "Return true if this command may modify the repository,
     such as by adding/removing changesets, changing bookmarks,
     heads and so on, False otherwise."

    ^ false

    "Modified: / 11-10-2015 / 07:31:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommand class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libscm/mercurial/HGCommand.st,v 1.4 2014/04/13 15:02:07 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libscm/mercurial/HGCommand.st,v 1.4 2014/04/13 15:02:07 cg Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id: HGCommand.st,v 1.4 2014/04/13 15:02:07 cg Exp $'
! !


HGCommand::resolve initialize!
