"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 2003 by eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:goodies/communication' }"

"{ NameSpace: Smalltalk }"

AbstractTCPSession subclass:#AbstractFTPSession
	instanceVariableNames:'timeOut lastArgument user workingDirectory mode dataSocket
		whiteListedFoldersForReading blackListedFoldersForReading
		whiteListedFoldersForWriting blackListedFoldersForWriting
		exitOnBadCommand inUtf8Mode'
	classVariableNames:''
	poolDictionaries:''
	category:'Net-Communication-FTP'
!

!AbstractFTPSession class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2003 by eXept Software AG
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
    Helper class for the FTPServer.

    Common code for FTP serverSessions - add concrete subclass
    The stuff implemented here realizes the protocol;
    real file operations and authorization must be implemented in subclasses.

    Methods which should be redefined are found in the 'must be redefined' category.

    Be aware, that FTPSessions may allow a client to GET all files
    which are readable by me (except for the white- and blacklists below).

    To limit access to certain folders, you can explicitly whiteList
    allowed folders (by setting whiteListedFolders) and/or exclude individual folders
    via a blackList (setting blackListedFolders).

    Whitelisting is done first, then blacklisting
    i.e. it is possible to allow everything under '/foo/...' by adding '/foo' to the whitelist,
    and still exclude individual subdirectories under it by adding (say) '/foo/bar/baz' to the blacklist.

    [author:]
        Claus Gittinger (extracted code from FTPSession)

    [start with:]
        FTPServer verbose:true
        
        FTPServer start.
        FTPServer startOnPort:portNr.

        (FTPServer forPort:12345)
            sessionClass:SmalltalkFTPSession;
            start

        then, on the command line, try:
            ftp loalhost 12345

    [see also:]
        https://tools.ietf.org/html/draft-ietf-ftpext-utf-8-option-00
"
!

protocol
"
    List of commands supported by this session framework
    (however, subclasses may extend this by (re-)defining listOfSupportedCommands
    and implementing a corresponding method.

    Command         Supported           Notes
    -----------------------------------------
    ABOR                -
    ACCT                -
    ADAT                -
    ALLO                -
    APPE                -
    CCC                 -
    CDUP                Yes
    CONF                -
    CWD                 Yes
    DELE                Yes
    ENC                 -
    EPRT                -
    EPSV                -
    FEAT                Yes
    HELP                Yes
    HOST                -
    LANG                -
    LIST                Yes
    LPRT                -
    LPSV                -
    MDTM                -
    MIC                 -
    MKD                 Yes
    MLSD                -
    MLST                -
    MODE                -
    NLST                Yes
    NOOP                Yes
    OPTS                -
    PASS                Yes
    PASV                -
    PBSZ                -
    PORT                Yes
    PROT                -
    PWD                 Yes
    QUIT                Yes
    REIN                Yes
    REST                -
    RETR                Yes
    RMD                 Yes
    RNFR                -
    RNTO                -
    SITE                Yes
    SIZE                -
    SMNT                -
    STAT                Yes
    STOR                Yes
    STOU                Yes
    STRU                -
    SYST                Yes
    TYPE                Yes
    USER                Yes
    XCUP                -
    XMKD                -
    XPWD                -
    XRMD                -
    XRSQ                -
    XSEM                -
    XSEN                -
"
! !

!AbstractFTPSession class methodsFor:'defaults'!

ftpVersion
    ^ 'Version 1.0 Smalltalk/X'
! !

!AbstractFTPSession class methodsFor:'queries'!

isAbstract
    "Return if this class is an abstract class.
     True is returned here for myself only; false for subclasses.
     Abstract subclasses must redefine this again."

    ^ self == AbstractFTPSession
! !

!AbstractFTPSession methodsFor:'accessing'!

blackListedFoldersForReading
    "if non-nil, folders whose names match any in the given list will
     NOT be visible to clients"

    ^ blackListedFoldersForReading
!

blackListedFoldersForReading:aListOfGlobPatterns
    "if non-nil, folders whose names match any in the given list will
     NOT be visible to clients"

    blackListedFoldersForReading := aListOfGlobPatterns.
!

blackListedFoldersForWriting
    "if non-nil, folders whose names match any in the given list will
     NOT be allowed to be written into by clients"

    ^ blackListedFoldersForWriting
!

blackListedFoldersForWriting:aListOfGlobPatterns
    "if non-nil, folders whose names match any in the given list will
     NOT be allowed to be written into by clients"

    blackListedFoldersForWriting := aListOfGlobPatterns.
!

exitOnBadCommand:aBoolean
    "can be set to enforce connection closing, whenever a bad command arrives"
    
    exitOnBadCommand := aBoolean
!

whiteListedFoldersForReading
    "if non-nil, only folders whose names match any in the given list will
     be visible to clients"

    ^ whiteListedFoldersForReading
!

whiteListedFoldersForReading:aListOfGlobPatterns
    "if non-nil, only folders whose names match any in the given list will
     be visible to clients"
     
    whiteListedFoldersForReading := aListOfGlobPatterns.
!

whiteListedFoldersForWriting
    "if non-nil, only folders whose names match any in the given list will
     NOT be allowed to be written into by clients"

    ^ whiteListedFoldersForWriting
!

whiteListedFoldersForWriting:aListOfGlobPatterns
    "if non-nil, only folders whose names match any in the given list will
     NOT be allowed to be written into by clients"
     
    whiteListedFoldersForWriting := aListOfGlobPatterns.
! !

!AbstractFTPSession methodsFor:'debugging'!

logCommand:aMessage
    self log:aMessage
! !

!AbstractFTPSession methodsFor:'ftp system commands'!

FEAT
    "return list of features"

    lastArgument notNil ifTrue:[
        "/ should not have args
        FTPServerException wrongNumberOfArguments
        "/ ^ socket nextPutLine:('501 FEAT command syntax')
    ].
    socket nextPutLine:('211-Features:').
    self listOfSupportedFeatures do:[:each |
        socket nextPutLine:each.
    ].    
    socket nextPutLine:('211 End').
!

HELP
    "send all commands supported by FTP server
    "
    |commands n|

    commands := self listOfSupportedCommands.

    socket nextPutLine:'214-The following commands are recognized.'.
    n := 0.

    commands copy sort do:[:aCommand |
        socket nextPutAll:'   '.
        socket nextPutAll:(aCommand paddedTo:4).

        (n := n + 1) == 8 ifTrue:[
            socket cr.
            n := 0.
        ].
    ].
    n ~~ 0 ifTrue:[
        socket cr.
    ].
    
    socket nextPutLine:'214 Comments to info@exept.de.'. "was ca@exept.de - does he really want to get spam???"
!

NOOP
    "no instruction command
    "

    socket nextPutLine:'200 Okay'.
!

PASS
    "password from user; already readin from USER command
    "
    user isNil ifTrue:[
	FTPServerException loginIncorrect
    ].
    socket nextPutLine:'230 User ', user, ' logged in'.
!

PASV
    "incoming PASV command.
     Open a listening socket on a random port,
     wait for the session partner to connect to it.
     Timeout after some time, if he does not connect to me.
     (separate data connection)"
     
    |listenSocket "words" ipAddress port ip1 ip2 ip3 ip4 portHi portLo
     addresses addressesInFamily|

    self closeDataConnection.

    "/ remove this, when the code below works.
    true ifTrue:[
        socket nextPutLine:('500 PASV command not supported').
        ^ self.
    ].
    
    lastArgument notNil ifTrue:[
        socket nextPutLine:('501 PASV command syntax').
        ^ self.
    ].

    "/ randomPort
    "/ randomPort := Random nextIntegerBetween:40000 and:55000.
    listenSocket := Socket newTCPserverAtAnonymousPort.
    port := listenSocket port.

    "/ take the first, if there are multiple (that is wrong - I need the one reachable from the partner!!)
    "/ how can I figure this out????
    socket getFullSocketAddress isLocal ifTrue:[
        ipAddress := socket getFullSocketAddress copy.
    ] ifFalse:[
        "/ must ask SV, if there is a better way doing this...
        addresses := SocketAddress allForHostName:(OperatingSystem getHostName).
        addresses := addresses select:[:each | each isIPv4SocketAddress].
        "/ choose one, that the partner might be able to connect to..
        addressesInFamily := addresses select:[:each | each class == socket socketAddressClass].
        addressesInFamily isEmpty ifTrue:[
            "/ ouch - cannot do it.
            socket nextPutLine:('501 Failed to get a socket for you').
            ^ self
        ].
        ipAddress := addressesInFamily first copy.
    ].
    ipAddress isIPv4SocketAddress ifFalse:[
        socket nextPutLine:('501 Failed to get an ipv4 socket for you').
        ^ self
    ].    
    self breakPoint:#cg.
    ip1 := ip2 := ip3 := ip4 := portHi := portLo := nil.
    
    listenSocket close.
    socket nextPutLine:('227 Entering Passive Mode (%1,%2,%3,%4,%5,%6)'
                            bindWith:ip1 with:ip2 with:ip3 with:ip4 with:portHi with:portLo).
    
"/    dataSocket := Socket newTCPclientToAddress:ipAddress port:port withTimeout:5000.
"/
"/    dataSocket isNil ifTrue:[
"/        socket nextPutLine:'421 cannot open connection'.
"/        ^ self.
"/    ].
"/    socket nextPutLine:'200 PORT command successful.'
!

PORT
    "incoming PORT command.
     Connect to the session partner (separate data connection)"
     
    |words ipAddress port|

    self closeDataConnection.

    lastArgument notNil ifTrue:[
        words := lastArgument asCollectionOfSubstringsSeparatedBy:$,.
    ].

    words size ~~ 6 ifTrue:[
        FTPServerException wrongNumberOfArguments
    ].

    ipAddress := ByteArray with:((words at:1) asNumber)
                           with:((words at:2) asNumber)
                           with:((words at:3) asNumber)
                           with:((words at:4) asNumber).

    port := (words at:5) asNumber bitShift:8.
    port := port bitOr:((words at:6) asNumber).

    dataSocket := Socket newTCPclientToAddress:ipAddress port:port withTimeout:5000.

    dataSocket isNil ifTrue:[
        socket nextPutLine:'421 cannot open connection'.
        ^ self.
    ].
    socket nextPutLine:'200 PORT command successful.'
!

QUIT
    "shutdown server
    "
    self doReinitialize.
    
    socket nextPutLine:'221 Goodbye'.
    socket close.
!

REIN
    "reinitialize server
    "
    self doReinitialize.
    socket nextPutLine:'200 Reinitialize'.

!

SITE
    "incoming SITE command.
     sends back some statistic info;
     or allows the idle timeout to be changed (SITE IDLE <seconds>)"

    |words time cmd|

    lastArgument isNil ifTrue:[
        FTPServerException wrongNumberOfArguments
    ].

    words := lastArgument asCollectionOfWords.
    cmd := words first asUppercase.

    cmd = 'IDLE' ifTrue:[
        words size == 2 ifTrue:[
            time := Number fromString:(words at:2) onError:nil.
        ].

        time isNil ifTrue:[
            socket nextPutLine:('200 Current IDLE time limit is %1 seconds; max %2.'
                                    bindWith:timeOut with:7200).
            ^ self.
        ].

        (time >= 10 and:[time <= 7200]) ifTrue:[
            timeOut := time.
            socket nextPutLine:('200 Maximum IDLE time set to %1 seconds.' bindWith:timeOut).
            ^ self.
        ].

        socket nextPutLine:('501 Maximum IDLE time must be between 10 and %1 second.'
                                    bindWith:7200).
        ^ self
    ].

    cmd = 'HELP' ifTrue:[
        socket nextPutLine:'214-The following SITE commands are recognized.'.
        socket nextPutLine:'   HELP   IDLE'.
        socket nextPutLine:'214 Comments to info@exept.de.'.
        ^ self
    ].

    socket nextPutLine:('500 ''SITE %1'': command not understood.' bindWith:cmd).
!

STAT
    "incoming STAT command.
     sends back some statistic info"

    socket nextPutLine:'211- ' , OperatingSystem getHostName , ' FTP server status:'.
    socket nextPutLine:('   ', self class ftpVersion).
    socket nextPutLine:'   Connected to ' , socket getPeerName.

    user notNil ifTrue:[
        socket nextPutLine:'   Logged in as ' , user.
    ].
    socket nextPutLine:'   TYPE: ' , mode asUppercase.
    socket nextPutLine:'211 End of status'.
!

SYST
    "incoming SYST command.
     send back the system type"

    |type|

    type := 'UNIX'.
    OperatingSystem isVMSlike ifTrue:[
        type := 'VMS'
    ] ifFalse:[
        OperatingSystem isMSWINDOWSlike ifTrue:[
            type := 'MSWINDOWS'
        ]
    ].

    socket nextPutLine:('215 %1 Type: L8' bindWith:type).
!

USER
    "incoming USER command.
     login to a new session"

    |newUser|

    self doReinitialize.

    (newUser := lastArgument) isNil ifTrue:[
        FTPServerException wrongNumberOfArguments
    ].

    (self loginUserNeedsPassword:newUser) ifTrue:[
        socket nextPutLine:('331 Password required for ', newUser).

        self nextCommand ~= #PASS ifTrue:[FTPServerException loginIncorrect].
        lastArgument isNil        ifTrue:[FTPServerException wrongNumberOfArguments].

        (self checkPassword:lastArgument for:newUser) ifFalse:[
            FTPServerException loginIncorrect
        ].
    ].
    self doUserLoggedIn:newUser.
    socket nextPutLine:'230 User ', newUser, ' logged in'.
! !

!AbstractFTPSession methodsFor:'ftp user commands'!

CDUP
    "change to parent directory
    "
    |dir|

    dir := self checkAndGetCWD directory.

    (self canChangeWorkingDirectory:dir) ifFalse:[
	FTPServerException permissionDenied
    ].
    workingDirectory := dir.
    socket nextPutLine:'200 CDUP command successful'.
!

CWD
    "change working directory
    "
    |directory|

    directory := self checkAndGetArgFilename.

    (self canChangeWorkingDirectory:directory) ifFalse:[
	FTPServerException permissionDenied:lastArgument
    ].
    workingDirectory := directory.
    socket nextPutLine:'250 CWD command successful'.
!

DELE
    "delete file or (empty) directory
    "
    self doDELETE:false
!

LIST
    "show directory contents; longFormat
    "
    self doLIST:true
!

MKD
    "make directory
    "
    |file|

    file := self checkAndGetArgFilename.

    self doMKD:file.
!

NLST
    "show directory contents; shortFormat
    "
    self doLIST:false
!

PWD
    "get current working directory
    "
    socket nextPutLine:('257 "%1" is current directory.' bindWith:(self checkAndGetCWD pathName)).
!

RETR
    "incoming RETR command.
     retrieve a file (i.e. download as seen from client)"

    |file outStream|

    outStream := self checkAndGetDataConnection.
    file      := self checkAndGetArgFilename.
    self doRETR:file onTo:outStream.

    "Modified: / 13-02-2017 / 22:52:10 / cg"
!

RMD
    "recursive delete directory
    "
    self doDELETE:true
!

STOR
    "incoming STOR command.
     upload as seen from ftp client"

    self doSTORE:false
!

STOU
    "incoming STOU command.
     upload as seen from ftp client"

    self doSTORE:true
!

TYPE
    "set mode:
	bin  (I or i) := #binary
	ascii(A or a) := #ascii
    "
    |arg|

    lastArgument size == 1 ifFalse:[
	^ socket nextPutLine:('500 Type not supported: ', lastArgument, '.')
    ].

    arg := lastArgument first asUppercase.

	     arg == $A ifTrue:[mode := #ascii]
    ifFalse:[arg == $I ifTrue:[mode := #binary]
    ifFalse:[
	^ socket nextPutLine:('500 Type not supported: ', lastArgument, '.')
    ]].

    socket nextPutLine:('200 Type set to ', lastArgument, '.').
! !

!AbstractFTPSession methodsFor:'must be redefined'!

canChangeWorkingDirectory:newDirectory
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

checkPassword:arg1 for:arg2
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

defaultDirectoryForUser:userName
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

doDELETE:recursive
    "raise an error: must be redefined in concrete subclass(es)"

    self log:('not allowed: DELE').

    FTPServerException permissionDenied.
!

doLIST:arg
    "raise an error: must be redefined in concrete subclass(es)"

    self log:('not allowed: LIST').

    FTPServerException permissionDenied.
!

doMKD:arg
    "raise an error: must be redefined in concrete subclass(es)"

    self log:('not allowed: MKD').

    FTPServerException permissionDenied.
!

doRETR:file onTo:outStream
    "raise an error: must be redefined in concrete subclass(es)"

    self closeDataConnection.
    FTPServerException permissionDenied:lastArgument
!

doSTORE:arg
    "raise an error: must be redefined in concrete subclass(es)"

    self log:('not allowed STOR').

    FTPServerException permissionDenied.
!

loginUserNeedsPassword:arg
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
! !

!AbstractFTPSession methodsFor:'private'!

closeDataConnection
    |ds|
    
    (ds := dataSocket) notNil ifTrue:[
        dataSocket := nil.
        ds close.
    ].
!

doReinitialize
    "reinitialize the system; called when:
        - user logged out
        - system before shutdown
        - reinitialize request
        - during startup
    "
    user             := nil.
    workingDirectory := nil.
    mode             := #ascii.
    inUtf8Mode       := false.
    
    self closeDataConnection.
!

doUserLoggedIn:aUser
    "setup user context
    "
    user := aUser.
    workingDirectory := self defaultDirectoryForUser:user.
!

listOfSupportedCommands
    ^ #(CDUP CWD DELE LIST MKD NLST PWD RETR RMD STOR STOU TYPE
        HELP NOOP PASS PORT QUIT REIN SITE STAT SYST USER FEAT PASV)

"/    ^ self class methodDictionary keys 
"/        select:[:name |
"/            name size <= 4
"/            and:[(name contains:[:char | char isLowercase]) not
"/            and:[(name includes:$:) not]]
"/        ].
!

listOfSupportedFeatures
    ^ #(UTF8 SIZE)
!

nextCommand
    "reads the next command from socket; if a timeout occurs nil is returned otherwise
     the command as string and the lastArgument is set to the received argument"

    |line soT eoT cmd|

    lastArgument := nil.

    [socket readWaitWithTimeout:timeOut] whileFalse:[
        line := socket nextLine.
        line isNil ifTrue:[^ nil].

        self logCommand:line.

        (soT := line indexOfNonSeparatorStartingAt:1) ~~ 0 ifTrue:[
            eoT := line indexOfSeparatorStartingAt:soT.

            eoT == 0 ifTrue:[
                cmd := line copyFrom:soT
            ] ifFalse:[
                cmd := line copyFrom:soT to:(eoT - 1).
                
                "/ changed to comply with RFC2640;
                "/ in utf8 mode, exactly one space is to be skipped,
                "/ any more spaces are considered part of the argument
                inUtf8Mode ifTrue:[
                    soT := eoT + 1.
                ] ifFalse:[
                    soT := line indexOfNonSeparatorStartingAt:eoT.
                ].
                
                soT ~~ 0 ifTrue:[
                    lastArgument := line copyFrom:soT.
                    inUtf8Mode ifFalse:[
                        lastArgument last isSeparator ifTrue:[
                            lastArgument := lastArgument withoutSeparators
                        ]
                    ]
                ]
            ].
            ^ cmd asUppercase.
        ]
    ].

    ^ nil
!

serveNextCommandFromSocket
    <resource: #perform (#CDUP #CWD #DELE #LIST #MKD #NLST #PWD #RETR #RMD #STOR #STOU #TYPE
              #HELP #NOOP #PASS #PORT #QUIT #REIN #SITE #STAT #SYST #USER #FEAT #PASV)>

    |cmd cmdSymbol|

    cmd := self nextCommand.
    cmd isNil ifTrue:[
        self log:'Timeout on socket'.
        self QUIT.
        ^ self.
    ].
    
    "make sure that nobody sends funny messages to me or my superclass"
    cmdSymbol := cmd asSymbolIfInterned.
    (self listOfSupportedCommands includes:cmdSymbol) ifFalse:[
        self log:('Command not implemented: ', cmd, ' <', lastArgument printString, '>').
        socket nextPutLine:'502 Command not implemented: ' , cmd.
        (exitOnBadCommand ? false) ifTrue:[
            self closeDataConnection.
            self QUIT.
        ].    
        ^ self.
    ].
    
    FTPServerException handle:[:ex|
        self log:'shutdown due to exception: ', ex description.
        socket nextPutLine:ex description.
        self closeDataConnection.
    ] do:[
        AbortOperationRequest handle:[
            self log:'Command aborted'.
            socket nextPutLine:'502 Internal server error'.
        ] do:[
            self perform:cmdSymbol.
        ]
    ].
!

serveSocket:aSocket
    <resource: #perform (#CDUP #CWD #DELE #LIST #MKD #NLST #PWD #RETR #RMD #STOR #STOU #TYPE
              #HELP #NOOP #PASS #PORT #QUIT #REIN #SITE #STAT #SYST #USER #FEAT)>

    socket  := aSocket.
    timeOut := 900.

    self doReinitialize.

    socket nextPutLine:('220 %1 FTP server (%2) ready'
                         bindWith:(OperatingSystem getHostName)
                             with:(self class ftpVersion)
                       ).

    [socket isOpen] whileTrue:[
        EndOfStreamError handle:[:ex |
            socket close.
            ^ self.
        ] do:[    
            self serveNextCommandFromSocket.
        ].
    ].

    "Modified: / 21-02-2017 / 10:04:49 / cg"
! !

!AbstractFTPSession methodsFor:'private ftp'!

checkAndGetArgFilename
    |file currDir|

    lastArgument isNil ifTrue:[
	FTPServerException wrongNumberOfArguments
    ].
    currDir  := self checkAndGetCWD.

    (file := lastArgument asFilename) isAbsolute ifFalse:[
	file := currDir construct:lastArgument
    ].
    ^ file
!

checkAndGetCWD

    workingDirectory isNil ifTrue:[
	FTPServerException noWorkingDirectory
    ].
    ^ workingDirectory
!

checkAndGetDataConnection

    dataSocket isNil ifTrue:[
        FTPServerException noDataConnection
    ].
    ^ dataSocket

    "Created: / 13-02-2017 / 22:52:46 / cg"
! !

!AbstractFTPSession methodsFor:'protocol testing'!

allowedToSeeDirectory:dir
    whiteListedFoldersForReading notNil ifTrue:[
        (self isPath:dir inList:whiteListedFoldersForReading) ifFalse:[
            ^ false.
        ].
    ].
    blackListedFoldersForReading notNil ifTrue:[
        (self isPath:dir inList:blackListedFoldersForReading) ifTrue:[
            ^ false.
        ].
    ].
    ^ true

    "
     |ftp|
     ftp := FTPSession basicNew.
     ftp whiteListedFoldersForReading:#( '/foo' '/bar*' ).
     ftp blackListedFoldersForReading:#( '/foo/bar' '/bar/baz/').
     self assert:( ftp allowedToSeeDirectory:'/foo' ).
     self assert:( ftp allowedToSeeDirectory:'/fooo' ) not.
     self assert:( ftp allowedToSeeDirectory:'/foo/bar' ) not.
     self assert:( ftp allowedToSeeDirectory:'/foo/baz' ).
    "
!

allowedToWriteIntoDirectory:dir
    whiteListedFoldersForWriting notNil ifTrue:[
        (self isPath:dir inList:whiteListedFoldersForWriting) ifFalse:[
            ^ false.
        ].
    ].
    blackListedFoldersForWriting notNil ifTrue:[
        (self isPath:dir inList:blackListedFoldersForWriting) ifTrue:[
            ^ false.
        ].
    ].
    ^ true

    "
     |ftp|
     ftp := FTPSession basicNew.
     ftp whiteListedFoldersForWriting:#( '/foo' '/bar*' ).
     ftp blackListedFoldersForWriting:#( '/foo/bar' '/bar/baz/').
     self assert:( ftp allowedToWriteIntoDirectory:'/foo' ).
    "
!

isPath:aFilename inList:aWhiteOrBlackList
    |pathName|

    pathName := aFilename asFilename pathName.
    
    ^ aWhiteOrBlackList
        contains:[:pattern | 
            pattern includesMatchCharacters ifTrue:[
                pattern match:pathName
            ] ifFalse:[
                pathName = pattern
                or:[ pathName startsWith:(pattern,Filename separatorString) ]
            ]]
                    
    "
     |ftp|
     ftp := FTPSession basicNew.
     self assert:( ftp isPath:'/foo' inList:#( '/foo' '/bar*' ) ).
     self assert:( ftp isPath:'/barr' inList:#( '/foo' '/bar*' ) ).
     self assert:( ftp isPath:'/bar/bla' inList:#( '/foo' '/bar*' ) ).
     self assert:( ftp isPath:'/baz' inList:#( '/foo' '/bar*' ) ) not.
     self assert:( ftp isPath:'/fooo' inList:#( '/foo' '/bar*' ) ) not.
     self assert:( ftp isPath:'/fooo' inList:#( '/foo*' '/bar*' ) ).
    "
! !

!AbstractFTPSession methodsFor:'queries'!

isBinary
    ^ mode == #binary
! !

!AbstractFTPSession methodsFor:'serving'!

clientOn:aSocket
    "process for new client"

    aSocket isNil ifTrue:[
        ^ nil
    ].

    sessionProcess := 
        [
            [ 
                Exception handle:[:ex|
                    (Object haltSignal handles:ex) ifTrue:[
                        ex reject
                    ].
                    self log:('error caught: ' , ex description).
                    "/ during debugging
                    ex reject.
                ] do:[
                    self serveSocket:aSocket
                ]
            ] ensure:[
                aSocket isOpen ifTrue:[
                    aSocket shutDown
                ].
                self doReinitialize.
                aSocket isOpen ifTrue:[
                    aSocket close.
                ]
            ]
        ] newProcess.

    sessionProcess priority:(Processor userBackgroundPriority).
    sessionProcess resume.
    ^ sessionProcess

    "Modified: / 14-02-2017 / 01:25:57 / cg"
! !

!AbstractFTPSession class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/AbstractFTPSession.st,v 1.22 2018-04-24 08:00:34 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/AbstractFTPSession.st,v 1.22 2018-04-24 08:00:34 cg Exp $'
! !

