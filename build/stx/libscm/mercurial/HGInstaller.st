"
 COPYRIGHT (c) 2012-2013 by Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libscm/mercurial' }"

"{ NameSpace: Smalltalk }"

StandaloneStartup subclass:#HGInstaller
	instanceVariableNames:'version destination archive'
	classVariableNames:'URLs RunningStandalone SeverityError SeverityWarning SeverityInfo'
	poolDictionaries:''
	category:'SCM-Mercurial-StX-Installer'
!

!HGInstaller class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2012-2013 by Jan Vrany
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
    A simple standalone installer for Mercurial support. It downloads
    and installs Mercurial support into Smalltalk/X IDE.

    Usage (command line):
        # install latest stable version
        stx --execute HGInstaller.st 

        # install latest development version                             
        stx --execute HGInstaller.st --version default

        # install Mercurial for manually downloaded archive
        stx --execute HGInstaller.st --archive downloaded-archive.zip

    Usage (workspace)
        # install latest stable version
        HGInstaller install

        # install latest development version                             
        HGInstaller install: #default

   [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!HGInstaller class methodsFor:'initialization'!

initialize
    "Invoked at system start or when the class is dynamically loaded."

    Smalltalk loadPackage:#'stx:goodies/communication'.

    self initializeURLs.

    SeverityError := #error.
    SeverityWarning := #warning.
    SeverityInfo := #info.


    (RunningStandalone := Smalltalk commandName endsWith: (self name , '.st')) ifTrue:[
        self start 
    ]

    "Modified: / 09-07-2013 / 01:22:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initializeURLs
    URLs := Array
                "/ Primary repository
                with: 'https://bitbucket.org/janvrany/stx-libscm/get' asURI     
                "/ Mirros
                with: 'http://swing.fit.cvut.cz/hg/stx.libscm/archive' asURI

    "Created: / 09-07-2013 / 00:27:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGInstaller class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!HGInstaller class methodsFor:'defaults'!

allowCoverageMeasurementOption
    "enable/disable the --measureCoverage startup options.
     The default is false, so standAlone apps do not support coverage measurements by default.
     Can be redefined in subclasses to enable it 
     (but will need the libcomp and possibly the programming/oom packages to be present)"

    ^ false

    "Created: / 11-07-2013 / 01:37:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

allowDebugOption
    "enable/disable the --debug startup option.
     Can be redefined in subclasses to enable it"

    ^ true

    "Created: / 07-07-2013 / 18:46:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

allowScriptingOption
    "enable/disable the --scripting startup option.
     Can be redefined in subclasses to enable it"

    ^ true

    "Created: / 07-07-2013 / 18:46:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

suppressRCFileReading
    "enable/disable the rc-file reading (and also the --rcFileName option).
     If suppressed, there is no chance to interfere with the startup.
     Can be redefined in subclasses to disable it"

    ^ true

    "Created: / 07-07-2013 / 18:46:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGInstaller class methodsFor:'helpers'!

printInfo:msg
    Transcript 
        show:'[INFO]: ';
        showCR:msg

    "Created: / 07-07-2013 / 18:48:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGInstaller class methodsFor:'installer API'!

install
    "Installs latest 'default' version of Mercurial support"

    ^self new install

    "Created: / 07-07-2013 / 10:56:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

install: rev
    "Installs given revision of Mercurial support"

    ^self new install: rev

    "Created: / 07-07-2013 / 10:56:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGInstaller class methodsFor:'startup'!

main:argv
    "superclass StandaloneStartup class says that I am responsible to implement this method"


    ^self new main: argv

    "Modified: / 07-07-2013 / 18:26:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 07-07-2013 / 22:00:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

usage
    Stderr nextPutLine:'stx:libscm installation script'; cr.
    Stderr nextPutLine:'usage: stx --execute HGInstaller.st [options...]'.
    Stderr nextPutLine:'  --version REV ........... specifies which version to install. REV can be'.
    Stderr nextPutLine:'                            branch, tag or commit id.'.
    Stderr nextPutLine:'  --archive FILE .......... specifies an archive file to install. If ommited'.
    Stderr nextPutLine:'                            archive is donwloaded'.
    Stderr nextPutLine:'  --help .................. output this message'.
"/    Stderr nextPutLine:'  --verbose ............... verbose startup'.
"/    Stderr nextPutLine:'  --noBanner .............. no splash screen'.
"/    Stderr nextPutLine:'  --newAppInstance ........ start as its own application process (do not reuse a running instance)'.
"/    self allowScriptingOption ifTrue:[
"/        Stderr nextPutLine:'  --scripting portNr ...... enable scripting via port (or stdin/stdOut, if 0)'.
"/    ].
    self allowDebugOption ifTrue:[
        Stderr nextPutLine:'  --debug ................. enable Debugger'.
    ].
    self allowCoverageMeasurementOption ifTrue:[
        Stderr nextPutLine:'  --coverage .............. turn on coverage measurement'.
        Stderr nextPutLine:'     [+/-]package: pattern ...  - include/exclude packages'.
        Stderr nextPutLine:'     [+/-]class: pattern ...    - include/exclude classes'.
        Stderr nextPutLine:'     [+/-]method: cls#sel ...   - include/exclude methods'.
    ].
    self suppressRCFileReading ifFalse:[
        Stderr nextPutLine:'  --rcFileName file ....... execute code from file on startup (default: ',self startupFilename,')'.
    ].
    Stderr cr.
    Stderr nextPutLine:'For more information see wiki:'.
    Stderr nextPutLine:'  https://bitbucket.org/janvrany/stx-libscm/wiki/Installation'.
    Stderr cr.

    Smalltalk exit: 0

    "Created: / 11-07-2013 / 01:36:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGInstaller class methodsFor:'startup-private'!

applicationRegistryPath
    "the key under which this application stores its process ID in the registry
     as a collection of path-components.
     i.e. if #('foo' 'bar' 'baz') is returned here, the current applications ID will be stored
     in HKEY_CURRENT_USER\Software\foo\bar\baz\CurrentID.
     (would also be used as a relative path for a temporary lock file under unix).
     Used to detect if another instance of this application is already running."

    ^ #(libscm mercurial installer)

    "Modified: / 07-07-2013 / 18:24:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

applicationUUID
    "answer an application-specific unique uuid.
     This is used as the name of some exclusive OS-resource, which is used to find out,
     if another instance of this application is already running.
     Under win32, a mutex is used; under unix, an exclusive file in the tempDir could be used.
     If redefined, please return a real UUID (i.e. UUID fromString:'.....') and not a string or
     similar possibly conflicting identifier.
     You can paste a fresh worldwide unique id via the editor's more-misc-paste UUID menuFunction."

    ^ UUID fromString:'132746c0-e72a-11e2-85f0-606720e43e2c'

    "Modified: / 07-07-2013 / 18:24:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGInstaller methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."

    "/ please change as required (and remove this comment)
    version := 'default'.

    "/ super initialize.   -- commented since inherited method does nothing

    "Modified: / 07-07-2013 / 11:11:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGInstaller methodsFor:'installation'!

install
    self doPrepare.
    self doDownload.
    self doExtract.
    self doCompile.
    self doConfigure.

    "Created: / 07-07-2013 / 11:07:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-07-2013 / 19:06:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

install: ver
    version := ver.
    self install.

    "Created: / 07-07-2013 / 11:08:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGInstaller methodsFor:'installation-private'!

doCompile
    | cmd |
    cmd := OperatingSystem isMSWINDOWSlike ifTrue:[ 'bmake.bat'] ifFalse:['make'].
    ( destination directory / 'stc' ) exists ifTrue:[
        | log |

        log := Filename newTemporaryIn: Filename tempDirectory nameTemplate:'compile-%1-%2.log'.            
        log writingFileDo:[:logs|
            Transcript nextPutAll: 'Compiling...'; cr.
            (OperatingSystem executeCommand: cmd outputTo: logs errorTo: logs inDirectory: destination pathName) ifFalse:[
                self log: 
                        'Compilation failed' 
                     details:
                        'This is not fatal, but the package will be loaded from source
                         instead of from binary class library, which is slower. 

                         You may want to check the compilation log in:
                         ', log pathName
                    severity: SeverityWarning.
            ].
            (OperatingSystem executeCommand: (cmd , ' clean') outputTo: logs errorTo: logs inDirectory: destination pathName) ifFalse:[
                self log: 
                        'Compilation failed' 
                     details:
                        'This is not fatal, but the package will be loaded from source
                         instead of from binary class library, which is slower. 

                         You may want to check the compilation log in:
                         ', log pathName
                    severity: SeverityWarning.    
             ].
        
        ]
    ].

    "Created: / 07-07-2013 / 18:50:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-07-2013 / 01:30:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doConfigure
    | top rcd |

    Transcript nextPutLine: 'Configuring...'.
    top := (Smalltalk getPackageDirectoryForPackage: Object package) directory directory.
    rcd := top / 'stx'/ 'projects' / 'smalltalk' / 'rc.d'.
    rcd isDirectory ifTrue:[
        (rcd / '50_mercurial.rc') writingFileDo:[:s|
            s nextPutLine:'"/ Load Mercurial support'.
            top = destination directory directory ifFalse:[
                s nextPutLine: ('Smalltalk packagePath: (Smalltalk packagePath: %1).' bindWith: destination directory directory pathName).        
            ].
            s nextPutAll:'Smalltalk loadPackage: ''stx:libscm/mercurial''.'.    
        ].            
    ] ifFalse:[
        
    ].

    "Created: / 07-07-2013 / 11:19:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-07-2013 / 01:41:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doDownload
    | urls1 urls2 |

    archive notNil ifTrue:[ ^ self ].

    archive := Filename newTemporary.
    Transcript nextPutAll:'Downloading...'; cr.

    urls1 := URLs select: [:url|url scheme = 'http'].
    urls2 := URLs reject: [:url|url scheme = 'http'].

    (( urls1 , urls2 )  anySatisfy:[:base|
        | downloaded url|

        url := base / (version , '.zip').
        Transcript nextPutAll:'  '; nextPutAll: url asString; nextPutAll: '...'.
        downloaded := self doDownload: url.
        Transcript nextPutAll: (downloaded ifTrue:['OK'] ifFalse:['FAILED']); cr.
        downloaded                        
    ]) ifFalse:[
        self error:'Failed to download archive!!'.
    ].

    (ZipArchive isZipArchive: archive) ifFalse:[
        self error: ('Downloaded file (%1) is not a .zip archive!!' bindWith: archive pathName).
    ].  

    "/    ]

    "Created: / 07-07-2013 / 11:19:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-07-2013 / 01:40:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doDownload: url
    "Download a given file and save it into `archive` 
     Return true, if the file has been downloaded, false otherwise"

    (url scheme = 'http' and:[HTTPInterface notNil]) ifTrue:[
        | client response |
        client := HTTPInterface connectTo: url host port: (url port ? 80).
        client destinationFile: archive.
        response := client requestGET: url asString.
        ^response isErrorResponse not 
            and:[response isFileErrorResponse not 
            and:[response isMovedResponse not]]
                        
    ].
    
    (url scheme = 'https' or:[HTTPInterface isNil]) ifTrue:[    
        | cmd |
        (OperatingSystem canExecuteCommand:'curl') ifTrue:[
            cmd := 'curl -s -o %1 %2' bindWith:archive pathName with:url.
        ] ifFalse:[
            (OperatingSystem canExecuteCommand:'wget') ifTrue:[
                cmd := 'wget -s -o %1 %2' bindWith:archive pathName with:url.
            ] ifFalse:[
                ^false.
            ].
        ].
        ^ OperatingSystem executeCommand:cmd
    ].

    ^false "Unssuported protocol"

    "Created: / 09-07-2013 / 00:23:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doExtract
    | zar |

    Transcript nextPutLine:'Extracting...'.
    [
        destination recursiveMakeDirectory.
    ] on:Error
            do:[:ex | 
        self 
            error:'Cannot make destination directory ' , destination pathName , ': ' 
                    , ex description
    ].
    
    zar := ZipArchive oldFileNamed:archive pathName.
    zar members do:[:zmemb | 
        | i  src  dst  dstd skipIt |

        src := zmemb fileName.
        i := src indexOf:$/.
        i ~~ 0 ifTrue:[
            src := src copyFrom:i + 1.
        ].
        
        skipIt := (src startsWith:'git') 
                        or:[src startsWith: 'mercurial/docs'].

        skipIt ifFalse:[
           dst := OperatingSystem isMSWINDOWSlike 
                   ifTrue:[destination / (src copyReplaceAll:$/ with:Filename separator)]
                   ifFalse:[destination / src].
           (dstd := dst directory) exists ifFalse:[
               dstd recursiveMakeDirectory
           ].
           dst writingFileDo:[:f | 
               Transcript nextPutAll: '  '; nextPutLine: src.
               zar extract:zmemb fileName intoStream:f 
           ].
        ].
    ].

    "Created: / 07-07-2013 / 11:19:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-07-2013 / 19:22:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 07-07-2013 / 20:51:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doPrepare
    | pp |

    pp := Smalltalk getPackageDirectoryForPackage:'stx:libscm'.
    pp isNil ifTrue:[
        pp := Smalltalk getPackageDirectoryForPackage:'stx:libbasic'.
    ].
    destination := pp directory isWritable 
                    ifTrue:[pp directory / 'libscm']
                    ifFalse:[Filename homeDirectory / '.stx' / 'packages' / 'stx' / 'libscm'].

    Transcript nextPutLine: 'Installing version ', version , ' to ', destination pathName.

    "Created: / 07-07-2013 / 19:06:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGInstaller methodsFor:'logging'!

log:message details: details severity:severity 

    | stream |

    (severity == SeverityInfo and:[Verbose not]) ifTrue:[ ^ self ].
    stream := RunningStandalone ifTrue:[Stderr] ifFalse:[Transcript].

    stream
        nextPut:$[;
        nextPutAll:severity asUppercase;
        nextPutAll:']: ';
        nextPutLine:message.
    details notNil ifTrue:[
        details asStringCollection do:[:line | 
            stream
                nextPutAll:'  ';
                nextPutLine:line trimSeparators.
        ]
    ].
    severity == SeverityError ifTrue:[
        RunningStandalone ifTrue:[
            Smalltalk exit:1.
        ] ifFalse:[
            self error:message
        ]
    ].

    "Created: / 07-07-2013 / 23:23:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-07-2013 / 00:27:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

log:message severity:severity 
    self log:message details: nil severity:severity

    "Created: / 07-07-2013 / 23:34:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGInstaller methodsFor:'running'!

main: argv
    "Run the installer. This is called when the installer
     is called from a command line as:

        stx --execute HGInstaller.st
    "

    | i |

    [
        (Smalltalk getPackageDirectoryForPackage: Object package) isNil ifTrue:[
            | cmd root |
            cmd := OperatingSystem pathOfSTXExecutable asFilename asAbsoluteFilename.
            root := cmd directory directory directory directory.
            root infoPrintCR.
            (root / 'stx' / 'libbasic') isDirectory ifFalse:[
                self log: 'Cannot determine package path' severity: SeverityError.
            ].
            Smalltalk packagePath: (Smalltalk packagePath copyWith: root pathName).
        ].

        i := 1.
        [ i <= argv size ] whileTrue:[
            | a |

            a := argv at: i.
            a = '--version' ifTrue:[
                i = argv size ifTrue:[
                    self error: '--version requires an argument!!'
                ].
                version := argv at: i + 1.
                i := i + 2.            
            ] ifFalse:[
            a = '--archive' ifTrue:[
                i = argv size ifTrue:[
                    self log: '--archive requires an argument!!' severity: SeverityError
                ].
                archive := (argv at: i + 1) asFilename.
                archive exists ifFalse:[
                    self log: ('Archive %1 does not exist' bindWith: archive pathName) severity: SeverityError
                ].
                archive isReadable ifFalse:[
                    self log: ('Archive %1 is not readable!!' bindWith: archive pathName) severity: SeverityError
                ].
                (ZipArchive isZipArchive: archive) ifFalse:[
                    self log: ('Archive %1 does not seem to be a valid .zip archive!!' bindWith: archive pathName) severity: SeverityError
                ].
                i := i + 2.            
            ] ifFalse:[
                self log: ('Unknown option ''',a,'''') severity: SeverityError.              
            ]]
        ].
        self install.
        Smalltalk exit: 0.
    ] on: Error do:[:ex|
        self log: 'Unexpected error: ', ex description severity: SeverityError
    ]

    "Created: / 07-07-2013 / 18:30:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-07-2013 / 01:45:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !


HGInstaller initialize!
