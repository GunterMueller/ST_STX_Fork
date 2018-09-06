"{ Package: 'stx:clients/Clock/QlockTwoWatchApplication' }"

StandaloneStartup subclass:#QlockTwoWatchStartup
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'demos-QlockTwoWatch'
!


!QlockTwoWatchStartup class methodsFor:'startup'!

main:argv
    |setup|

    (argv includes:'-help') ifTrue:[
	self usage.
	Smalltalk exit.
    ].

    setup :=
	[:v |
	    |idx nr|

	    (argv includes:'-minutes') ifTrue:[
		v showMinutes:true
	    ].
	    (idx := argv indexOf:'-monitor') ~~ 0 ifTrue:[
		(idx < argv size) ifTrue:[
		    nr := Number readFrom:(argv at:idx+1).
		    v setMonitor:nr.
		].
	    ].
	    (idx := argv indexOf:'-language') ~~ 0 ifTrue:[
		(idx < argv size) ifTrue:[
		    v setLanguage:(argv at:idx+1).
		].
	    ].
	    (idx := argv indexOf:'-scheme') ~~ 0 ifTrue:[
		(idx < argv size) ifTrue:[
		    v setColorScheme:(argv at:idx+1).
		].
	    ].
	].

    self verboseInfo:'starting QlockTwoWatch...'.

    self startStartBlockProcess.
    Smalltalk openDisplay.

    Display exitOnLastClose:true.
    Processor exitWhenNoMoreUserProcesses:true.
    (argv includes:'-full') ifTrue:[
	QlockTwoWatch startFullScreen:setup.
    ] ifFalse:[
	QlockTwoWatch start:setup.
    ].

    "Modified: / 21-12-2011 / 11:14:42 / cg"
!

usage
    "self usage"

    Transcript showCR:'qlocktwo [options]'.
    Transcript showCR:'  options:'.
    Transcript showCR:'     -full .................. fullscreen'.
    Transcript showCR:'     -monitor <n>............ show on monitor'.
    Transcript showCR:'     -minutes ............... show minutes'.
    Transcript show:'     -language <lang> ....... language ('.
    QlockTwoWatch supportedLanguages
	do:[:l | Transcript show:l ]
	separatedBy:[ Transcript show:' ' ].
    Transcript showCR:')'.

    Transcript show:'     -scheme <colorScheme> .. set color scheme ('.
    QlockTwoWatch supportedSchemes
	do:[:l | Transcript show:l ]
	separatedBy:[ Transcript show:' ' ].
    Transcript showCR:')'.
    Transcript showCR:'  keyboard:'.
    Transcript showCR:'     q ... quit'

    "Created: / 20-12-2011 / 19:28:29 / cg"
! !

!QlockTwoWatchStartup class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Clock/QlockTwoWatchApplication/QlockTwoWatchStartup.st,v 1.13 2014-07-01 10:48:49 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/clients/Clock/QlockTwoWatchApplication/QlockTwoWatchStartup.st,v 1.13 2014-07-01 10:48:49 cg Exp $'
! !
