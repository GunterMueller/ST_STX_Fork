"{ Package: 'stx:doc/coding/demoFactorial' }"

"{ NameSpace: Smalltalk }"

StandaloneStartupHeadless subclass:#FactorialProgram
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'demos-standalone'
!

!FactorialProgram class methodsFor:'documentation'!

documentation
"
    this is compiled to a stand-alone, headless command line program.
    Demonstrating a minimum overhead executable.
    
    To build, go to my folder top/stx/doc/coding/demoFactorial,
    and type 'make'.
    
    The resulting 'factorial' program can be executed there with:
        ./factorial <n>
    where <n> is an integer.    
    It will display the result on the standard output.
    
    [author:]
        cg

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!FactorialProgram class methodsFor:'startup'!

main:argv
    "main entry; argv is the array of command arguments 
     (as array of words from space-separated command line).
     Creates an instance of myself and calls the main: method on the instance side."

    "/ to check if another instance is already running (win32 only for now)
    "/     self checkForAndExitIfAnotherApplicationInstanceIsRunning
    "/ (which tells the running app to open a new window on the passed in document file)
    "/ see my superclass for how this works.
    
    ^ self new main:argv
    
    "to try from within the IDE:
        self main:#('-a' 'someArg' '-h')
     when deployed, start at the command line with:
        <nameOfApp> -a someArg -h
    "
!

usage
    "output some command-line usage infos on stderr"
    
    Stderr nextPutLine:'usage: ',self applicationName,' [options...] number'.
    Stderr nextPutLine:'  --noInfoPrint ........ disable diagnostic messages'.
    Stderr nextPutLine:'  -h ................... output this message'.
! !

!FactorialProgram methodsFor:'startup'!

main:argv
    "main entry; argv is the array of command arguments 
     (as array of words from space-separated command line).
     Parse arguments (possibly bailing out to usage-display), 
     and eventually send the factorial to the output"

    |helpOption intArg|

    helpOption := false.

    (GetOpt new)
        at:$h
            put:[:opt | helpOption := true];
        at:$?
            put:[:arg | helpOption := true];
        default:[:arg | ];
        onError:[:msg | Stderr nextPutLine:msg. self class usageAndExitWith:1];
        parse:argv.

    helpOption ifTrue:[
        self class usageAndExitWith:0.
    ].
    
    argv isEmpty ifTrue:[self class usageAndExitWith:1].
    
    intArg := Integer readFrom:argv first onError:[self class usageAndExitWith:2].
    Stdout nextPutLine:(intArg factorial asString).
! !

!FactorialProgram class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/doc/coding/demoFactorial/FactorialProgram.st,v 1.4 2016-10-11 00:04:57 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/doc/coding/demoFactorial/FactorialProgram.st,v 1.4 2016-10-11 00:04:57 cg Exp $'
! !

