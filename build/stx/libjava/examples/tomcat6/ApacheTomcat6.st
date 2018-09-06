"{ Package: 'stx:libjava/examples/tomcat6' }"

StandaloneStartup subclass:#ApacheTomcat6
	instanceVariableNames:'bootstrap'
	classVariableNames:'OldspaceIncreased'
	poolDictionaries:''
	category:'Apache-Tomcat-6.x'
!

ApacheTomcat6 class instanceVariableNames:'debugging'

"
 The following class instance variables are inherited by this class:

	StandaloneStartup - MutexHandle
	Object - 
"
!


!ApacheTomcat6 class methodsFor:'initialization'!

initialize

    super initialize.
    debugging := Transcript notNil and:[Transcript isView].

    "Created: / 06-11-2011 / 22:07:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ApacheTomcat6 class methodsFor:'debugging'!

dumpProcess: aProcess
    Stderr cr; cr

    "Created: / 27-06-2013 / 23:41:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

dumpProcess: aProcess on: aStream
    | ctx |
    aStream cr; cr.
    aStream nextPutAll: '== ['; nextPutAll: aProcess id printString; nextPutAll:'] '; nextPutAll: aProcess name; nextPutAll: ' =='; cr.
    aStream cr.

    aProcess == Processor activeProcess ifTrue:[ctx := thisContext] ifFalse:[ctx := aProcess suspendedContext].
    [ ctx notNil ] whileTrue:[
        aStream nextPutAll: '  '.
        ctx fullPrintOn: aStream.
        aStream cr.
        ctx := ctx sender.
    ].
    aStream cr.

    "
        self dumpProcess: Processor activeProcess on: Transcript.
    "

    "Created: / 28-06-2013 / 01:00:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

dumpProcesses
    self dumpProcessesOn: Stderr

    "
    self dumpProcessesOn: Transcript.
    "

    "Created: / 27-06-2013 / 23:41:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 28-06-2013 / 01:06:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

dumpProcessesOn: aStream
    Process allInstancesDo:[:process|
        process isDead ifFalse:[
            self dumpProcess: process on: aStream
        ]
    ]

    "Created: / 27-06-2013 / 23:42:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ApacheTomcat6 class methodsFor:'defaults'!

allowDebugOption
    "enable/disable the --debug startup option.
     Can be redefined in subclasses to enable it"

    ^ true

    "Created: / 10-01-2013 / 22:39:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

allowScriptingOption
    "enable/disable the --scripting startup option.
     Can be redefined in subclasses to enable it"

    ^ true

    "Created: / 10-01-2013 / 22:39:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ApacheTomcat6 class methodsFor:'error reporting'!

error: message
    "Report an error and exit, if not debugging."

    ^self error: message cause: nil

    "Created: / 24-04-2013 / 10:50:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

error: message cause: exceptionOrNil
    "Report an error and exit, if not debugging."

    Stderr nextPutAll: message.
    exceptionOrNil notNil ifTrue:[
        Stderr nextPutAll: ': '; nextPutAll: exceptionOrNil description
    ].
    Stderr cr.
    debugging ifTrue:[
        exceptionOrNil notNil ifTrue:[
            exceptionOrNil pass
        ] ifFalse:[
            AbortOperationRequest raiseRequest.
        ]
    ] ifFalse:[
        exceptionOrNil notNil ifTrue:[
            exceptionOrNil suspendedContext fullPrintAllOn: Stderr.
        ].
        Stderr nextPutLine:'Exiting'.
        Smalltalk isStandAloneApp ifTrue:[
            Smalltalk exit:1.
        ].
    ].

    "Created: / 24-04-2013 / 10:49:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-11-2013 / 10:28:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ApacheTomcat6 class methodsFor:'multiple applications support'!

applicationRegistryPath
    "the key under which this application stores its process ID in the registry
     as a collection of path-components.
     i.e. if #('foo' 'bar' 'baz') is returned here, the current applications ID will be stored
     in HKEY_CURRENT_USER\Software\foo\bar\baz\CurrentID.
     (would also be used as a relative path for a temporary lock file under unix).
     Used to detect if another instance of this application is already running."

    ^ self shouldImplement
!

applicationUUID
    "answer an application-specific unique uuid.
     This is used as the name of some exclusive OS-resource, which is used to find out,
     if another instance of this application is already running.
     Under win32, a mutex is used; under unix, an exclusive file in the tempDir could be used.
     If redefined, please return a real UUID (i.e. UUID fromString:'.....') and not a string or
     similar possibly conflicting identifier.
     You can paste a fresh worldwide unique id via the editor's more-misc-paste UUID menuFunction."

    ^ self shouldImplement
! !

!ApacheTomcat6 class methodsFor:'startup'!

handleSIGTERM
    self dumpProcesses.
    debugging ifFalse:[
        Smalltalk exit:127.
    ].

    "Created: / 27-06-2013 / 23:10:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-06-2013 / 01:08:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

handleSIGUSR2
    self dumpProcesses

    "Created: / 27-06-2013 / 23:10:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setupSignalHandlers
    "On UNIX, this sets up a custom signal handler on SIGUSR2 and SIGTERM that
     dumps stacks on all threads"

    | sigusr2 sigterm |

    OperatingSystem isUNIXlike ifTrue:[


        sigterm := Signal new.
        sigterm handlerBlock: [:ex | self handleSIGTERM].
        OperatingSystem operatingSystemSignal:OperatingSystem sigTERM install: sigterm.
        OperatingSystem enableSignal: OperatingSystem sigTERM.

        sigusr2 := Signal new.
        sigusr2 handlerBlock: [:ex | self handleSIGUSR2].
        OperatingSystem operatingSystemSignal:OperatingSystem sigUSR2 install: sigusr2.
        OperatingSystem enableSignal: OperatingSystem sigUSR2.
    ].

    "
    OperatingSystem sendSignal: OperatingSystem sigUSR2 to: OperatingSystem getProcessId
    "

    "Created: / 27-06-2013 / 20:57:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-06-2013 / 01:11:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setupToolsForDebug

    super setupToolsForDebug.
    debugging := true.

    "Created: / 06-11-2011 / 22:06:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

usage

    Stderr nextPutAll:'usage: tomcat6';
           nextPutAll: ' [options] <command> '; cr.

    Stderr nextPutLine:'  --help .................. output this message'.
"/    Stderr nextPutLine:'  --verbose ............... verbose startup'.
"/    Stderr nextPutLine:'  --noBanner .............. no splash screen'.
"/    Stderr nextPutLine:'  --newAppInstance ........ start as its own application process (do not reuse a running instance)'.
    self allowScriptingOption ifTrue:[
        Stderr nextPutLine:'  --scripting portNr ...... enable scripting via port (or stdin/stdOut, if 0)'.
    ].
    self allowDebugOption ifTrue:[
        Stderr nextPutLine:'  --debug ................. enable Debugger'.
    ].

    "/                 '  ......................... '
    Stderr cr.
    Stderr nextPutLine:'  available commands:'.
    Stderr nextPutLine:'  start ................... start server'.
    Stderr nextPutLine:'  stop .................... stop server'.
    

    "
    self usage
    "

    "Created: / 13-01-2012 / 11:48:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 24-04-2013 / 10:38:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ApacheTomcat6 class methodsFor:'startup-to be redefined'!

main:argv
    "Process command line arguments and issue an command"

    | pp wd i p parser startup commands |

    "Search for package path, bit hacky but..."
    (OperatingSystem pathOfSTXExecutable endsWith: 'tomcat6') ifFalse:[
    wd := Filename currentDirectory.
    pp := nil.
    p := wd.
    i := 10."How many super-directories try"
    [i > 0 and:[pp == nil]] whileTrue:[
            p := p / '..'. i := i - 1.
            ((p / 'stx' / 'libbasic') exists and:[(p / 'stx' / 'libcomp') exists])
                   ifTrue:[pp := p]].
      pp
                ifNil:
                        [Stderr nextPutLine: 'ERROR: Cannot find package path'.
                        Smalltalk exit: 16]
                ifNotNil:
                        [Smalltalk packagePath add: pp pathName].
    ].


    self setupSignalHandlers.

    parser := CmdLineParser new.  
    [               
        commands := parser parse: argv for: self.        
    ] on:CmdLineOptionError do:[:ex|
        self error: 'Error when processing options' cause: ex.
        ^self
    ].

    commands isEmptyOrNil ifTrue:[
        self error: 'No command given'.
        ^self
    ].
    commands size > 1 ifTrue:[
        self error: 'Multiple commands given (only one is allowed)'.
        ^self
    ].
    startup := self new.
    (startup respondsTo: commands first asSymbol) ifFalse:[
        self error: 'Unknown command: ', commands first.
        ^self
    ].
    [
        startup perform: commands first asSymbol
    ] on: Error do:[:ex|
        self error: 'Error running command ''',commands first,'''' cause: ex
    ].

    "Modified: / 19-11-2013 / 11:23:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ApacheTomcat6 methodsFor:'accessing - paths'!

catalinaHome
    ^ ((Smalltalk at: #'stx_libjava') packageDirectory / 'examples' / 'tomcat6' 
        / 'apache-tomcat-6.0.35-src' / 'output' 
        / 'build') pathName

    "Created: / 08-12-2011 / 22:17:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-12-2011 / 14:32:49 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 23-08-2012 / 01:58:37 / m"
    "Modified: / 24-04-2013 / 10:31:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

classPath1

    ^ self catalinaHome , '/bin/*.jar'

    "Created: / 08-12-2011 / 22:43:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-01-2013 / 16:47:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

classPath2

    ^ self catalinaHome , '/lib/*.jar'

    "Created: / 08-12-2011 / 22:44:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sourcePath
    | pkgdir  root  path  p |
    pkgdir := Smalltalk getPackageDirectoryForPackage: self class package.
    pkgdir isNil ifTrue: [ ^ #() ].
    root := pkgdir / 'examples' / 'tomcat' / 'apache-tomcat-6.0.35-src'.
    OperatingSystem getLoginName = 'm' ifTrue: [
        root := '/home/m/Projects/stx/libjava/branches/jk_new_structure/src/examples/tomcat/apache-tomcat-6.0.35-src' 
                asFilename
    ].
    OperatingSystem getLoginName = 'jv' ifTrue: [
        root := '/home/jv/Projects/libjava/sources/libjava/branches/jk_new_structure/src/examples/tomcat/apache-tomcat-6.0.35-src/' 
                asFilename
    ].
    root exists ifFalse: [ ^ #() ].
    path := OrderedCollection new.
    (p := root / 'java') exists ifTrue: [ path add: p ].
    (p := root / 'java-extras') exists ifTrue: [ path add: p ].
    ^ path

    "Created: / 08-12-2011 / 23:16:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-12-2011 / 14:33:42 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 30-07-2012 / 15:11:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-08-2012 / 01:58:54 / m"
! !

!ApacheTomcat6 methodsFor:'initialization'!

initializeVM

    | openJDK6 |

    Java release isJava6 ifFalse:[
        openJDK6 := JavaRelease openJDK6.
        openJDK6 isAvailable ifTrue:[
            Java release: openJDK6
        ] ifFalse:[
            self class error: 'OpenJDK6 not available. Tomcat6 does not work on JDK 7 (yet). Try to set STX_LIBJAVA_RELEASE=JDK6'.
        ].
    ].

    Java flushAllJavaResources.
    Java initialize.
    JavaVM initializeVM.

    "Created: / 08-12-2011 / 00:01:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-11-2013 / 10:30:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setup

    | catalinaHome java_lang_System |

    catalinaHome := self catalinaHome.
    catalinaHome asFilename exists ifFalse:[
        self error:'Catalina home does not exist'.
        ^self.
    ].

    Java addToClassPath: self classPath1.
    Java addToClassPath: self classPath2.
    self sourcePath do:[:each|Java addToSourcePath:  each].
    JavaVM booted ifFalse:[self initializeVM].
    java_lang_System := Java classForName:'java.lang.System'.

    {
        'java.util.logging.config.file'.    catalinaHome , '/conf/logging.properties' .
        'java.util.logging.manager'.        'org.apache.juli.ClassLoaderLogManager' .
        'java.endorsed.dirs'.               catalinaHome , '/endorsed' .
        'catalina.base'.                    catalinaHome .
        'catalina.home'.                    catalinaHome .
        'java.io.tmpdir'.                   catalinaHome , '/temp' .
    } pairWiseDo:[:key :value|
        java_lang_System perform: #'setProperty(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;'
            with: (Java as_String: key)
            with: (Java as_String: value)
    ].
    OldspaceIncreased ~~ true ifTrue:[
        ObjectMemory moreOldSpace: 64"MB"*(1024*1024).
        OldspaceIncreased := true.
    ].

    "Created: / 18-04-2012 / 08:08:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ApacheTomcat6 methodsFor:'start/stop'!

start

    | notifier |

    self setup.

    notifier := (Java classForName: 'stx.libjava.tomcat.StartupNotifier').

    [
        (Java classForName: 'org.apache.catalina.startup.Bootstrap')
        perform: #'main([Ljava/lang/String;)V'
        with: ((Java classForName:'java.lang.String') javaArrayClass with:(Java as_String:'start')).
    ] fork.

    notifier waitUntilStarted.

    "/ Create dummy display so Smalltalk won't exit
    "/ after finishing this method. See
    "/ Smalltalk>>mainStartup:, line 153
    Display isNil ifTrue:[
        Display := Object new.  
    ].

    Transcript showCR: '== TomCat ready!! =='

    "Created: / 07-12-2011 / 23:59:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 19-11-2013 / 11:24:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

stop
    self setup.
    (Java classForName: 'org.apache.catalina.startup.Bootstrap')
        perform: #'main([Ljava/lang/String;)V'
        with: ((Java classForName:'java.lang.String') javaArrayClass with:(Java as_String:'stop')).

    "Created: / 08-12-2011 / 00:32:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 10-01-2013 / 22:44:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ApacheTomcat6 class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/examples/tomcat6/ApacheTomcat6.st,v 1.5 2015-03-20 12:08:03 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


ApacheTomcat6 initialize!
