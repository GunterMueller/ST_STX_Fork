"{ Package: 'stx:libjava/examples/chat' }"

StandaloneStartup subclass:#ChatStart
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'stx-libjava-examples-chat'
!

!ChatStart class methodsFor:'constants & defaults'!

applicationRegistryPath
    "the key under which this application stores its process ID in the registry
     as a collection of path-components.
     i.e. if #('foo' 'bar' 'baz') is returned here, the current applications ID will be stored
     in HKEY_CURRENT_USER\Software\foo\bar\baz\CurrentID.
     (would also be used as a relative path for a temporary lock file under unix).
     Used to detect if another instance of this application is already running."

    ^ #('stx' 'ChatStartup')
!

applicationUUID
    "answer an application-specific unique uuid.
     This is used as the name of some exclusive OS-resource, which is used to find out,
     if another instance of this application is already running.
     Under win32, a mutex is used; under unix, an exclusive file in the tempDir could be used.
     If redefined, please return a real UUID (i.e. UUID fromString:'.....') and not a string or 
     similar possibly conflicting identifier.
     You can paste a fresh worldwide unique id via the editor's more-misc-paste UUID menuFunction."

    ^ UUID fromString:'e95f2d30-2496-11e3-9a86-606720e43e2c' 
! !

!ChatStart class methodsFor:'startup'!

main:argv
    "main entry; argv is the array of command arguments (as array of words from space-separated command line).
     Parse arguments, and proceed to the real work function"

    "you may want to put those into instvars, in order to be accessable from the doRealWork function"
    |aArgs bArgs cOption fileArgs helpOption|

    aArgs := OrderedCollection new.
    bArgs := OrderedCollection new.
    fileArgs := OrderedCollection new.
    cOption := helpOption := false.

    (GetOpt new)
        at:$h
            put:[:opt | helpOption := true];
        at:$? 
            put:[:arg | self usage. Smalltalk exit:0];
        default:[:arg | fileArgs add:arg];
        parse:argv.

    helpOption ifTrue:[ 
        self usage. 
    ] ifFalse:[
        self realMain:argv.
    ].
    "/ do not exit here; caller will go into event loop when returning

    "Modified: / 24-09-2013 / 00:10:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

realMain: args 
    "opens the application"

    JavaVM booted ifFalse:[
        Java flushAllJavaResources.
        Java initialize.
        JavaVM initializeVM. 
    ].
    Chat open

    "Modified: / 24-09-2013 / 00:11:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

usage
    Stderr nextPutLine:'usage: ',self applicationName,' [options...]'.
    Stderr nextPutLine:'  -h .................. output this message'.
! !

