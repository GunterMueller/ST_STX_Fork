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

NVTClient subclass:#FTPClient
	instanceVariableNames:'passiveMode transferMode partnersTransferMode'
	classVariableNames:'FileErrorSignal FileNotFoundErrorSignal
		TransferProgressNotificationSignal TransferInformationSignal'
	poolDictionaries:''
	category:'Net-Communication-FTP'
!

!FTPClient class methodsFor:'documentation'!

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
    Client interface to an ftp server.

    [author:]
        Claus Gittinger

    [instance variables:]
        partnersTransferMode    mode of the connected-to partner
                                (nil initially - could be initialized by parsing some startup message)

        transferMode            wanted mode (can be changed before logging in)

        passiveMode             controls data connection setup - either I connect to the partners data port,
                                or he connects to my data port (req'd for firewalls / outgoing connection blockers)
                                    passiveMode == false        -> I am actively connecting to partners data port
                                    passiveMode == true         -> I am passively awaiting partner to connect to my data port

    [see also:]
        HTTPInterface
        Socket
        FTPTool
"
!

examples
"
  login/pwd/close:
                                                        [exBegin]
     |host ftpClient|

     host := Dialog request:'host:' initialAnswer:'ftp.informatik.uni-stuttgart.de'.

     ftpClient := FTPClient new.
     ftpClient connectToHost:host.
     ftpClient login:'anonymous' password:'foo@bar.com'.
     Transcript showCR:(ftpClient pwd).
     ftpClient close.
                                                        [exEnd]


  getting a list from some other machine:
                                                        [exBegin]
     |host ftp list|

     host := Dialog request:'host:' initialAnswer:'ftp.informatik.uni-stuttgart.de'.

     ftp := FTPClient new.
     ftp connectTo:host user:'anonymous' password:'foo@bar.com'.
     list := ftp list.
     ftp close.
     list do:[:line | Transcript showCR:line].
                                                        [exEnd]


  getting a list from some other machine (passive mode):
                                                        [exBegin]
     |host ftp list|

     host := Dialog request:'host:' initialAnswer:'ftp.informatik.uni-stuttgart.de'.

     ftp := FTPClient new.
     ftp passiveMode:true.   
     ftp connectTo:host user:'anonymous' password:'foo@bar.com'.
     list := ftp list.
     ftp close.
     list do:[:line | Transcript showCR:line].
                                                        [exEnd]


  getting list from some other machine:
                                                        [exBegin]
     |host user passwd fn ftp data|

     host := Dialog request:'host:' initialAnswer:'localhost'.
     user := Dialog request:'user:' initialAnswer:'anonymous'.
     passwd := Dialog requestPassword:'password:'.

     ftp := FTPClient new.
     ftp connectTo:host user:user password:passwd.
     data := ftp list.
     ftp close.
     data inspect.
                                                        [exEnd]


  on a special port:
                                                        [exBegin]
     |host port user passwd fn ftp data|

     FTPClient verbose:true.
     host := Dialog request:'host:' initialAnswer:'localhost'.
     port := Dialog request:'port:' initialAnswer:(Socket portOfService:'ftp') printString.
     port := Integer readFrom:port onError:nil.
     user := Dialog request:'user:' initialAnswer:'anonymous'.
     passwd := Dialog requestPassword:'password:'.

     ftp := FTPClient new.
     ftp connectTo:host port:port user:user password:passwd.
     data := ftp list.
     ftp close.
     data inspect.
                                                        [exEnd]


  getting a (text) file from some other machine:
                                                        [exBegin]
     |host user passwd fn ftp data|

     host := Dialog request:'host:' initialAnswer:'localhost'.
     user := Dialog request:'user:' initialAnswer:'anonymous'.
     passwd := Dialog requestPassword:'password:'.
     fn := Dialog request:'file:'.

     ftp := FTPClient new.
     ftp connectTo:host user:user password:passwd.
     data := ftp get:fn.
     ftp close.
     data asString inspect.
                                                        [exEnd]


  getting a (binary) file from some other machine:
                                                        [exBegin]
     |host user passwd fn ftp data|

     host := Dialog request:'host:' initialAnswer:'localhost'.
     user := Dialog request:'user:' initialAnswer:'anonymous'.
     passwd := Dialog requestPassword:'password:'.
     fn := Dialog request:'file:'.

     ftp := FTPClient new.
     ftp connectTo:host user:user password:passwd.
     ftp binary.   
     data := ftp get:fn.
     ftp close.
     data inspect.
                                                        [exEnd]


  putting some data onto some other machine:
                                                        [exBegin]
     |host user passwd fn ftp data|

     host := Dialog request:'host:' initialAnswer:'localhost'.
     user := Dialog request:'user:' initialAnswer:'anonymous'.
     passwd := Dialog requestPassword:'password:'.
     fn := Dialog request:'local file:'.

     ftp := FTPClient new.
     ftp connectTo:host user:user password:passwd.
     ftp binary.   
     data := ftp put:'hello world' as:'testfile'.
     ftp close.
     data inspect.
                                                        [exEnd]


  putting a (binary) file onto some other machine:
                                                        [exBegin]
     |host user passwd fn ftp data|

     host := Dialog request:'host:' initialAnswer:'localhost'.
     user := Dialog request:'user:' initialAnswer:'anonymous'.
     passwd := Dialog requestPassword:'password:'.
     fn := Dialog request:'local file:'.

     ftp := FTPClient new.
     ftp connectTo:host user:user password:passwd.
     ftp binary.   
     data := ftp putFile:'Makefile' as:'testfile'.
     ftp close.
     data inspect.
                                                        [exEnd]


  handling errors:
                                                        [exBegin]
     |host ftp list|

     host := Dialog request:'host:' initialAnswer:(OperatingSystem getHostName).

     FTPClient ftpErrorSignal handle:[:ex |
         self warn:('ftp error:\\' , ex signal errorString) withCRs
     ] do:[
         ftp := FTPClient new.
         ftp connectTo:host user:'anonymous'.
         list := ftp list.
         ftp close.
         list do:[:line | Transcript showCR:line].
     ]
                                                        [exEnd]


  chdir & get a list from some other machine:
                                                        [exBegin]
     |ftp list|

     FTPClient ftpErrorSignal handle:[:ex |
         self warn:('ftp error:\\' , ex signal errorString) withCRs
     ] do:[
         ftp := FTPClient new.
         ftp connectTo:'aix' user:'anonymous'.
         ftp cd:'/'.
         list := ftp list.
         ftp close.
         list do:[:line | Transcript showCR:line].
     ]
                                                        [exEnd]


  dialog with user & password:
                                                        [exBegin]
     |ftp dlg hostHolder userHolder passHolder list|

     hostHolder := OperatingSystem getHostName asValue.
     userHolder := OperatingSystem getLoginName asValue.
     passHolder := '' asValue.

     dlg := DialogBox new.
     dlg addTextLabel:'host:'.
     dlg addInputFieldOn:hostHolder tabable:true.
     dlg addTextLabel:'user:'.
     dlg addInputFieldOn:userHolder tabable:true.
     dlg addTextLabel:'password:'.
     (dlg addInputFieldOn:passHolder tabable:true) passwordCharacter:$*.
     dlg addAbortButton; addOkButton.
     dlg open.

     dlg accepted ifTrue:[
         FTPClient ftpErrorSignal handle:[:ex |
             self warn:('ftp error:\\' , ex signal errorString) withCRs
         ] do:[
             ftp := FTPClient new.
             ftp connectTo:hostHolder value
                 user:userHolder value
                 password:passHolder value.
             ftp cd:'/'.
             list := ftp list.
             ftp close.
             list do:[:line | Transcript showCR:line].
         ]
     ]
                                                        [exEnd]

                                                        [exBegin]
     |host port user passwd fn ftp data|

     FTPClient verbose:true.

     host := 'data'.
     port := 12345.
     user := 'anonymous'.
     passwd := nil.

     ftp := FTPClient new.
     ftp connectTo:host port:port user:user password:passwd.
     ftp ascii.
     data := ftp list.
     ftp close.
     data inspect.
                                                        [exEnd]

                                                        [exBegin]
     |host port user passwd fn ftp data|

     FTPClient verbose:true.

     host := 'data'.
     port := 12345.
     user := 'anonymous'.
     passwd := nil.

     ftp := FTPClient new.
     ftp connectTo:host port:port user:user password:passwd.
     ftp ascii.
     data := ftp list.
     ftp close.
     data inspect.
                                                        [exEnd]
"
! !

!FTPClient class methodsFor:'Signal constants'!

fileErrorSignal
    "return the signal raised if some file-get or chdir fails"

    ^ FileErrorSignal

    "Created: 25.3.1997 / 12:02:40 / cg"
    "Modified: 27.3.1997 / 14:55:03 / cg"
!

fileNotFoundErrorSignal
    "return the signal raised if some file-get or chdir fails"

    ^ FileNotFoundErrorSignal

    "Created: 25.3.1997 / 12:02:40 / cg"
    "Modified: 27.3.1997 / 14:55:03 / cg"
!

filePutErrorSignal
    "return the signal raised if some file-put fails"

    ^ self fileErrorSignal

    "Created: 25.3.1997 / 12:02:40 / cg"
    "Modified: 27.3.1997 / 14:55:03 / cg"
!

ftpErrorSignal
    "return the parent of all ftp errors"

    ^ NetErrorSignal

    "Created: 25.3.1997 / 10:46:27 / cg"
    "Modified: 25.3.1997 / 10:50:15 / cg"
!

transferInformationSignal
    "return the notification raised to transfer info information (such as speed etc.)
     Currently never raised, but provided for later extension and compatibility with HTTPInterface."

    ^ TransferInformationSignal

    "Created: / 13-06-2007 / 10:35:22 / cg"
!

transferProgressNotificationSignal
    "return the notification raised to provide progress (percentage) information.
     Currently never raised, but provided for later extension and compatibility with HTTPInterface."

    ^ TransferProgressNotificationSignal

    "Created: / 13-06-2007 / 10:16:59 / cg"
! !

!FTPClient class methodsFor:'class initialization'!

initialize
    FileErrorSignal isNil ifTrue:[
        FileErrorSignal := NetErrorSignal newSignalMayProceed:true.
        FileErrorSignal nameClass:self message:#fileErrorSignal.
        FileErrorSignal notifierString:'FTP:'.
    ].
    FileNotFoundErrorSignal isNil ifTrue:[
        FileNotFoundErrorSignal := FileErrorSignal newSignalMayProceed:true.
        FileNotFoundErrorSignal nameClass:self message:#fileNotFoundErrorSignal.
        FileNotFoundErrorSignal notifierString:'FTP:'.
    ].
    TransferInformationSignal isNil ifTrue:[
        TransferInformationSignal := QuerySignal new.
        TransferInformationSignal nameClass:self message:#transferInformationSignal.
    ].
    TransferProgressNotificationSignal isNil ifTrue:[
        TransferProgressNotificationSignal := QuerySignal new.
        TransferProgressNotificationSignal nameClass:self message:#transferProgressNotificationSignal.
    ].

    "
     self initialize.
     Verbose := true
    "

    "Created: / 25-03-1997 / 10:36:55 / cg"
    "Modified: / 13-06-2007 / 10:18:07 / cg"
! !

!FTPClient methodsFor:'compatibility - squeak'!

changeDirectoryTo:dirName
    self cd:dirName

    "Created: / 25-11-2011 / 11:24:13 / cg"
!

getDirectory
    ^ self list asString

    "Created: / 25-11-2011 / 11:24:49 / cg"
!

getFileNamed:fileName
    ^ (self get:fileName) asString

    "Created: / 25-11-2011 / 11:27:17 / cg"
!

loginUser: user password: pw
    "login using userName and password. Squeak compatibility.
     After successful login, set transfer mode"

    userName := user.
    password := pw.
    self login:user password:pw

    "Created: / 25-11-2011 / 11:22:03 / cg"
    "Modified (comment): / 12-06-2017 / 12:30:15 / mawalch"
!

putFileStreamContents:aStream as:remoteFileName
    self put:aStream as:remoteFileName

    "Created: / 01-12-2011 / 21:33:06 / cg"
! !

!FTPClient methodsFor:'defaults'!

defaultPassword
    "the anonymous's default password"

    ^ (OperatingSystem getLoginName , '@' , OperatingSystem getHostName)
!

defaultPort
    ^ 21 "/ Socket portOfService:'ftp'
!

defaultUser
    ^ 'anonymous'
! !

!FTPClient methodsFor:'error handling'!

fileNotFoundError
    ^ self class fileNotFoundErrorSignal raiseErrorString:self errorStringFromResponse

    "Created: 25.3.1997 / 12:01:25 / cg"
    "Modified: 27.3.1997 / 14:55:28 / cg"
!

filePermissionError
    ^ self class filePutErrorSignal raiseErrorString:self errorStringFromResponse

    "Created: 25.3.1997 / 12:32:07 / cg"
    "Modified: 25.3.1997 / 12:34:18 / cg"
!

noPort:errMsg
    ^ ConnectFailedSignal raiseErrorString:' - no data connection (' , errMsg , ')'

    "Created: 25.3.1997 / 10:56:22 / cg"
    "Modified: 25.3.1997 / 12:14:23 / cg"
! !

!FTPClient methodsFor:'initialization'!

initialize
    super initialize.

    transferMode := #binary.
    partnersTransferMode := nil. "/ means: unknown
    passiveMode := true.         "/ Server is passivly awaiting data connections
    "/ passiveMode := false.     "/ Server should activly connect to my data port

    "Created: / 29.3.1997 / 13:12:03 / cg"
    "Modified: / 19.1.2000 / 16:05:27 / cg"
! !

!FTPClient methodsFor:'operations'!

ascii
    "send a 'type a' command (switch to text-mode transfer)."

    self isConnected ifTrue:[
        partnersTransferMode ~~ #ascii ifTrue:[
            self sendCommand:'TYPE A'.
            partnersTransferMode := #ascii
        ].
    ].
    transferMode := #ascii

    "
     |ftp|
     ftp := FTPClient new.
     ftp connectTo:'porty' user:'anonymous'.
     ftp binary.
     ftp ascii.
     ftp close
    "

    "Created: 24.3.1997 / 12:04:48 / cg"
    "Modified: 25.3.1997 / 12:04:11 / cg"
!

binary
    "send a 'type i' command (switch to binary-mode transfer)"

    self isConnected ifTrue:[
        partnersTransferMode ~~ #binary ifTrue:[
            self sendCommand:'TYPE I'.
            partnersTransferMode := #binary
        ].
    ].
    transferMode := #binary

    "
     |ftp|
     ftp := FTPClient new.
     ftp connectTo:'porty' user:'anonymous'.
     ftp binary.
     ftp close
    "

    "Created: 24.3.1997 / 12:04:48 / cg"
    "Modified: 25.3.1997 / 12:04:15 / cg"
!

cd:aDirectoryPath
    "send a changeDirectory command"

    self sendCommand:('CWD ' , aDirectoryPath).

    "
     |ftp|
     ftp := FTPClient new.
     ftp connectTo:'porty' user:'anonymous'.
     ftp cd:'/pub'.
     ftp close
    "

    "Created: 24.3.1997 / 12:04:48 / cg"
    "Modified: 25.3.1997 / 12:04:18 / cg"
!

cdUp
    "send a changeDirectory-up command"

    (CommandErrorSignal catch:[
        self sendCommand:'CDUP'.  "/ not supported on old ftp servers
    ]) ifTrue:[
        self sendCommand:'XCUP'.  "/ deprecated
    ]

    "
     |ftp|
     ftp := FTPClient new.
     ftp connectTo:'porty' user:'anonymous'.
     Transcript showCR:(ftp pwd).
     ftp cdUp.
     Transcript showCR:(ftp pwd).
     ftp close
    "

    "Created: 3.4.1997 / 20:43:45 / cg"
    "Modified: 3.4.1997 / 20:46:04 / cg"
!

delete:aFilePath
    "send a delete file command"

    self sendCommand:('DELE ' , aFilePath).

    "
     |ftp|
     ftp := FTPClient new.
     ftp connectTo:'porty' user:'anonymous'.
     ftp delete:'testfile'.
     ftp close
    "

    "
     |ftp|
     ftp := FTPClient new.
     ftp connectTo:'foo.bar.com' user:'anonymous' password:'fooBarBaz'.
     ftp delete:'testfile'.
     ftp close
    "

    "Created: / 24.3.1997 / 12:04:48 / cg"
    "Modified: / 25.11.1999 / 15:17:18 / cg"
!

get:aFileNameString
    "send a get command; return the result as either a string
     or a byteArray (depending on the transfer mode).
     Raise connectFailedSignal if data connection cannot be established"

    |dataStream data|

    dataStream := self getStreamFor:aFileNameString.
    data := dataStream contents.
    dataStream close.
    (self getResponse ~~ SUCCESS) ifTrue:[
        self halt:'bad FTP response'.
    ].
    ^ data.

    "
     |ftp text|

     ftp := FTPClient new.
     ftp connectTo:'porty' user:'anonymous'.
     ftp ascii.
     text := ftp get:'welcome.msg'.
     ftp close.
     TextView openWith:text.
    "
    "
     |ftp text|

     ftp := FTPClient new.
     ftp connectTo:'porty' user:'anonymous'.
     ftp binary.
     text := ftp get:'welcome.msg'.
     ftp close.
     text inspect.
    "

    "Modified: 25.3.1997 / 13:17:25 / cg"
!

getStreamFor:aFilenameString
    "send a get command; return a stream on the files contents.
     Raise a signal if connection cannot be established"

    ^ self openDataConnectionFor:'RETR ' , aFilenameString asString.

    "
     |ftp s t|

     ftp := FTPClient new.
     ftp connectTo:'porty' user:'anonymous'.
     s := ftp getStreamFor:'welcome.msg'.
     t := s contents.
     TextView openWith:t.
     s close.
     ftp close.
    "

    "
     |ftp s t|

     ftp := FTPClient new.
     ftp connectTo:'porty' user:'anonymous'.
     s := ftp getStreamFor:'fooBar'.
     t := s contents.
     TextView openWith:t.
     s close.
     ftp close.
    "

    "Modified: / 19.1.2000 / 16:05:14 / cg"
!

help
    "send a 'HELP' command to ask about the partners capabilities.
     Return a collection of help lines."

    |rslt|

    CommandErrorSignal catch:[
        responseLines := OrderedCollection new.
        self sendCommand:'HELP'.
    ].
    (lastReplyCode == 214) ifTrue:[
        rslt := responseLines.
        responseLines := nil.
        ^ rslt asStringCollection
    ].
    ^ nil

    "
     |ftp|

     ftp := FTPClient new.
     ftp connectTo:'porty' user:'anonymous'.
     Transcript showCR:(ftp help).
     ftp close
    "

    "Created: 3.4.1997 / 20:50:26 / cg"
    "Modified: 10.4.1997 / 09:02:12 / cg"
!

list
    "send a list command; return the result as a collection of
     strings (containing the listing)"

    ^ self listWithCommand:'LIST'

    "
     |ftp list|

     ftp := FTPClient new.
     ftp connectTo:'porty' user:'anonymous'.
     list := ftp list.
     ftp close.
     list do:[:line | Transcript showCR:line].
    "

    "
     |ftp list|

     ftp := FTPClient new.
     ftp connectTo:'aix' user:'anonymous'.
     ftp cd:'/'.
     list := ftp list.
     ftp close.
     list do:[:line | Transcript showCR:line].
    "

    "
     |ftp list|

     FTPClient ftpErrorSignal handle:[:ex |
         self warn:'ftp failed'
     ] do:[
         ftp := FTPClient new.
         ftp connectTo:'ftp.mozilla.org' user:'anonymous'.
         ftp cd:'/'.
         list := ftp list.
         ftp close.
         list do:[:line | Transcript showCR:line].
     ]
    "

    "Created: / 24.3.1997 / 12:04:44 / cg"
    "Modified: / 19.1.2000 / 16:11:03 / cg"
!

list:aFileName
    "send a list command; return the result as a collection of
     strings (containing the listing)"

    ^ self listWithCommand:'LIST ' , aFileName

    "Created: / 19.1.2000 / 16:11:56 / cg"
!

listStream
    "send a list command; return a stream on the listing"

    ^ self listStream:'LIST'

    "
     |ftp s t|

     ftp := FTPClient new.
     ftp connectTo:'porty' user:'anonymous'.
     s := ftp listStream.
     t := s contents.
     TextView openWith:t.
     s close.
     ftp close.
    "

    "
     |ftp s1 s2 t|

     ftp := FTPClient new.
     ftp connectTo:'porty' user:'anonymous'.
     s1 := ftp listStream.
     ftp cd:'bin'.
     s2 := ftp listStream.
     t := s1 contents.
     TextView openWith:t.
     s1 close.
     t := s2 contents.
     TextView openWith:t.
     s2 close.
     ftp close.
    "

    "Modified: 28.3.1997 / 18:59:41 / cg"
!

listStream:listCommand
    "send a list command; return a stream on the listing"

    ^ self openDataConnection:#ascii for:listCommand.

    "
     |ftp s t|

     ftp := FTPClient new.
     ftp connectTo:'porty' user:'anonymous'.
     s := ftp listStream.
     t := s contents.
     TextView openWith:t.
     s close.
     ftp close.
    "

    "
     |ftp s1 s2 t|

     ftp := FTPClient new.
     ftp connectTo:'porty' user:'anonymous'.
     s1 := ftp listStream.
     ftp cd:'bin'.
     s2 := ftp listStream.
     t := s1 contents.
     TextView openWith:t.
     s1 close.
     t := s2 contents.
     TextView openWith:t.
     s2 close.
     ftp close.
    "

    "Created: / 28.3.1997 / 18:59:30 / cg"
    "Modified: / 19.1.2000 / 16:07:16 / cg"
!

listWithCommand:listCommand
    "send a list command; return the result as a collection of
     strings (containing the listing)"

    |listStream lineList|

    listStream := self listStream:listCommand.
    lineList := listStream contents.
    listStream close.
    (self getResponse ~~ SUCCESS) ifTrue:[
        self halt:'bad FTP response'.
    ].
    Verbose == true ifTrue:[
        lineList do:[:line |
            Transcript showCR:line.
        ]
    ].
    ^ lineList.

    "
     |ftp list|

     ftp := FTPClient new.
     ftp connectTo:'www.exept.de' user:'anonymous'.
     list := ftp list.
     ftp close.
     list do:[:line | Transcript showCR:line].
    "

    "
     |ftp list|

     ftp := FTPClient new.
     ftp connectTo:'aix' user:'anonymous'.
     ftp cd:'/'.
     list := ftp list.
     ftp close.
     list do:[:line | Transcript showCR:line].
    "

    "
     |ftp list|

     FTPClient ftpErrorSignal handle:[:ex |
         self warn:'ftp failed'
     ] do:[
         ftp := FTPClient new.
         ftp connectTo:'aix' user:'anonymous'.
         ftp cd:'/'.
         list := ftp list.
         ftp close.
         list do:[:line | Transcript showCR:line].
     ]
    "

    "Modified: / 25.3.1997 / 11:30:56 / cg"
    "Created: / 19.1.2000 / 16:10:42 / cg"
!

mkdir:aDirectoryNameString
    "send a make Directory command"

    self sendCommand:('MKD ', aDirectoryNameString).

    "
     |ftp|
     ftp := FTPClient new.
     ftp connectTo:'porty' user:'anonymous'.
     ftp cd:'/tmp'.
     ftp mkdir:'test12345'.
     ftp close
    "
!

nlist
    "send an nlist command; return the result as a collection of
     strings (containing the listing)"

    ^ self listWithCommand:'NLST'

    "
     |ftp list|

     ftp := FTPClient new.
     ftp connectTo:'ftp.mozilla.org' user:'anonymous'.
     list := ftp nlist.
     ftp close.
     list do:[:line | Transcript showCR:line].
    "

    "Modified: / 19.1.2000 / 16:11:13 / cg"
!

passiveMode:aBoolean
    "set passiveMode to aBoolean.
     In passive mode, the server instead of the client creates an extra socket to transmit the data.
     Answer the prevoius status of passiveMode"
    
    |prevMode|

    prevMode := passiveMode.
    aBoolean notNil ifTrue:[
        passiveMode := aBoolean.
    ].
    ^ prevMode.
!

put:aStringOrByteArrayOrStream as:remoteFileName
    "send a put command; 
     send aStringOrbyteArray"

    |outStream|

    [
        outStream := self putStreamFor:remoteFileName.
        aStringOrByteArrayOrStream isStream ifTrue:[
            outStream copyToEndFrom:aStringOrByteArrayOrStream.
        ] ifFalse:[
            outStream nextPutAll:aStringOrByteArrayOrStream.
        ].
    ] ensure:[
        outStream notNil ifTrue:[
            outStream close.
        ].
    ].

    "
     |ftp s|

     ftp := FTPClient new.
     ftp connectTo:'porty' user:'anonymous'.
     ftp ascii.
     (ftp put:'hello world' as:'testfile') ifFalse:[
        self warn:'File transfer failed'
     ].
     ftp close.
    "

    "Modified: / 01-12-2011 / 21:34:29 / cg"
!

putFile:localFileName as:remoteFileName
    "send a put command; 
     send a local file"

    |outStream inStream|

    inStream := localFileName asFilename readStream.
    [
        transferMode == #binary ifTrue:[
            inStream binary.
        ].
        outStream := self putStreamFor:remoteFileName.
        inStream copyToEndInto:outStream.
    ] ensure:[
        inStream close.
        outStream notNil ifTrue:[
            outStream close.
        ].
    ].

    "
     |ftp s|

     ftp := FTPClient new.
     ftp connectTo:'porty' user:'anonymous'.
     ftp ascii.
     (ftp putFile:'..\bmake.bat' as:'testfile') ifFalse:[
        self warn:'File transfer failed'
     ].
     ftp close.
    "

    "Modified: / 3.10.1998 / 20:39:31 / cg"
!

putStreamFor:aFilenameString
    "send a put command; return a stream for writing the file"

    ^ self openDataConnectionFor:'STOR ' , aFilenameString asString.

    "
     |ftp s|

     ftp := FTPClient new.
     ftp connectTo:'porty' user:'anonymous'.
     ftp ascii.
     s := ftp putStreamFor:'newfile'.
     s nextPutLine:'line1'.
     s nextPutLine:'line2'.
     s nextPutLine:'line3'.
     s close.
     ftp close.
    "

    "Modified: 28.3.1997 / 22:29:12 / cg"
!

pwd
    "send an XPWD (print current dir) command; return the directory or nil
     if the partner does not support the XPWD command"

    |s|

    (CommandErrorSignal catch:[
        self sendCommand:'PWD'.   "/ not supported on old ftp servers
    ]) ifTrue:[
        self sendCommand:'XPWD'.  "/ deprecated
    ].

    (lastReplyCode == 257) ifTrue:[
        s := (lastResponse copyFrom:4) withoutSeparators.
        (s startsWith:'"') ifTrue:[
            s := s copyFrom:2 to:(s indexOf:$" startingAt:3)-1.
            ^ s
        ].
        (s startsWith:'''') ifTrue:[
            s := s copyFrom:2 to:(s indexOf:$' startingAt:3)-1.
            ^ s
        ].
        ^ s
    ].
    ^ nil

    "
     Verbose := true
     Verbose := false
    "
    "
     |ftp|

     ftp := FTPClient new.
     ftp connectTo:'porty' user:'anonymous'.
     Transcript showCR:(ftp pwd).
     ftp cd:'/pub'.
     Transcript showCR:(ftp pwd).
     ftp close
    "

    "Created: 24.3.1997 / 12:04:48 / cg"
    "Modified: 3.4.1997 / 20:46:30 / cg"
!

recursiveMkDir:aDirectoryNameString
    "recursively create all required directories and change to"

    |currentDir|

    currentDir := self pwd.
    (aDirectoryNameString asCollectionOfSubstringsSeparatedBy: $/) do:[:newDir|
        FTPClient fileNotFoundErrorSignal handle:[:ex |
            self mkdir: newDir.
            self cd: newDir.
        ] do:[
            self cd: newDir.
        ].
    ].
    self cd: currentDir.
!

rename:fromFilename to:toFilename
    "rename a file"

    self sendCommand:('RNFR ' , fromFilename).
    self sendCommand:('RNTO ' , toFilename).

    "
     |ftp|
     ftp := FTPClient new.
     ftp connectTo:'hippo' user:'stefan' password:'pass'.
     ftp rename:'/tmp/bla1' to:'/tmp/bla2'.
     ftp close
    "
!

rmdir:aDirectoryNameString
    "send a make Directory command"

    self sendCommand:('RMD ', aDirectoryNameString).

    "
     |ftp|
     ftp := FTPClient new.
     ftp connectTo:'porty' user:'anonymous'.
     ftp cd:'/tmp'.
     ftp mkdir:'test12345'.
     ftp rmdir:'test12345'.
     ftp close
    "
!

sizeOf:aFileName
    "send an SIZE (print size) command; return the size or nil
     if the partner does not support the SIZE command"

    |s|

    CommandErrorSignal catch:[
        self sendCommand:('SIZE ' , aFileName).
    ].

    (lastReplyCode == 213) ifTrue:[
        s := (lastResponse copyFrom:4) withoutSeparators.
        ^ Integer readFrom:s onError:nil
    ].
    ^ nil

    "
     Verbose := true
     Verbose := false
    "
    "
     |ftp|

     ftp := FTPClient new.
     ftp connectTo:'www.exept.de' user:'anonymous'.
     Transcript showCR:(ftp sizeOf:'download/wartungsvertrag.pdf').
     ftp close
    "

    "Created: 3.4.1997 / 20:48:35 / cg"
    "Modified: 3.4.1997 / 20:52:20 / cg"
!

systemStatus
    "send a 'STAT' command to ask about the partner systems status.
     Return a collection of status lines."

    |rslt|

    CommandErrorSignal catch:[
        responseLines := OrderedCollection new.
        (lastReplyCode == 211) ifTrue:[
            rslt := responseLines.
            responseLines := nil.
            ^ rslt asStringCollection
        ].
    ].
    ^ StringCollection new.

    "
     |ftp|

     ftp := FTPClient new.
     ftp connectTo:'www.exept.de' user:'anonymous'.
     Transcript showCR:(ftp systemStatus).
     ftp close
    "

    "Created: 3.4.1997 / 20:50:26 / cg"
    "Modified: 10.4.1997 / 09:02:12 / cg"
!

systemType
    "send a 'SYST' command to ask about the partner system"

    |s|

    CommandErrorSignal catch:[
        self sendCommand:'SYST'.
    ].
    (lastReplyCode == 215) ifTrue:[
        s := (lastResponse copyFrom:4) withoutSeparators.
        ^ s
    ].
    ^ nil

    "
     |ftp|

     ftp := FTPClient new.
     ftp connectTo:'www.exept.de' user:'anonymous'.
     Transcript showCR:(ftp systemType).
     ftp close
    "

    "Modified: 3.4.1997 / 20:43:23 / cg"
! !

!FTPClient methodsFor:'private - commands & responses'!

getResponseForPORTCommand
    ^ self
        getResponseHandlingReplyCodesWith:[:numericCode | self handleReplyCodeOfPORTCommand:numericCode].
!

handleReplyCode:replyCode
    replyCode == 550 ifTrue:[
        self fileNotFoundError.
        ^ ERROR
    ].
    replyCode == 553 ifTrue:[
        self filePermissionError.
        ^ ERROR
    ].
    ^ super handleReplyCode:replyCode
!

handleReplyCodeOfPORTCommand:replyCode
    (replyCode == 125 or:[replyCode == 150]) ifTrue:[ 
        replyPending := true.    
        ^ SUCCESS
    ].
    ^ self handleReplyCode:replyCode
! !

!FTPClient methodsFor:'private - connection setup'!

close
    super close.
    partnersTransferMode := nil. "/ means: unknown
!

getInitialConnectResponse
    self getResponse
!

login:userName password:passwordOrNil
    "login using userName and password.
     After successful login, set transfer mode"

    self sendCommand:('USER ' , userName).
    lastReplyCode == 331 ifTrue:[
        "/ userName OK - need password
        passwordOrNil isNil ifTrue:[
            LoginFailedSignal raiseErrorString:' - password required'.
            ^ self
        ].
        self sendCommand:('PASS ' , passwordOrNil).
    ].
    transferMode == #binary ifTrue:[
        self binary
    ] ifFalse:[
        self ascii
    ]

    "Modified (comment): / 12-06-2017 / 12:30:07 / mawalch"
!

openActiveDataConnection:mode for:command
    "open & retrieve a data connection.
     Raise connectFailedSignal if data connection can't be established"

    |sock port myAddr dataConnection portCommandStream|

    "create a socket for a new anonymous port and
     bind it to the local ip address we have got for the
     control connection"

    myAddr := connection getFullSocketAddress.

    sock := Socket domain:myAddr domain type:#stream.
    [
        sock bindAnonymouslyToAddress:myAddr.
        sock listenFor:1.
    ] on:OpenError do:[:ex|
        sock close.
        self noPort:ex description.
        ^ nil.
    ].

    port := sock port.

    portCommandStream := '' writeStream.
    myAddr isIPv6SocketAddress ifTrue:[
        portCommandStream nextPutAll:'EPRT |2|'.
        myAddr printAddressOn:portCommandStream.
        portCommandStream nextPut:$|.
        port printOn:portCommandStream.
        portCommandStream nextPut:$|.
    ] ifFalse:[
        "/
        "/ send down info of anon port as
        "/    PORT a,b,c,d,pH,pL
        "/
        portCommandStream nextPutAll:'PORT '.
        myAddr hostAddress do:[:eachAddressByte|
            eachAddressByte printOn:portCommandStream.
            portCommandStream nextPut:$,.
        ].
        ((port bitShift:-8) bitAnd:16rFF) printOn:portCommandStream.
        portCommandStream nextPut:$,.
        (port bitAnd:16rFF) printOn:portCommandStream.
    ].

    UnimplementedOperationErrorSignal handle:[:ex |
        sock shutDown.
        self commandFailed
    ] do:[
        self sendCommand:portCommandStream contents.
    ].
    (lastReplyCode == 200) ifFalse:[
        sock shutDown.
        self commandFailed
    ].

    self sendCommandNoWait:command.
    (self getResponseForPORTCommand ~~ SUCCESS) ifTrue:[
        sock shutDown.
        ^ self noPort:lastResponse.
    ].

    "/ now, let the partner connect to the anon port
    dataConnection := sock waitForNewConnectionWithTimeout:30.

    dataConnection isNil ifTrue:[
        sock shutDown.
        ^ self noPort:'timeout waiting for data connection'.
    ].
    sock shutDown.
    ^ dataConnection

    "
     Note: active data connections do not work well with IPv6 and firewalls.

     |ftp|
     ftp := FTPClient new.
     ftp useIPv4Only.
     ftp passiveMode:false.
     ftp connectTo:'exept.de' user:'anonymous' password:'ftpcClientTest@smalltalk-x.de'.
     ftp list inspect.
     ftp close
    "

    "Created: / 19.1.2000 / 16:06:24 / cg"
    "Modified: / 1.3.2000 / 14:33:10 / cg"
!

openDataConnection:mode for:command
    "open & retrieve a data connection"

    |dataConnection|

    self setModeTo:mode.

    passiveMode == true ifTrue:[
        dataConnection := self openPassiveDataConnection:mode for:command
    ] ifFalse:[
        dataConnection := self openActiveDataConnection:mode for:command.
    ].
    mode == #binary ifTrue:[
        dataConnection binary
    ].
    ^ dataConnection

    "
     |ftp|
     ftp := FTPClient new.
     ftp connectTo:'foo.bar' user:'anonymous' password:'bla@foo.baz'.
     ftp list.
     ftp close
    "
!

openDataConnectionFor:command
    "open & retrieve a data connection"

    ^ self openDataConnection:transferMode for:command

    "
     |ftp|
     ftp := FTPClient new.
     ftp connectTo:'porty' user:'anonymous'.
     ftp list.
     ftp close
    "

    "Created: / 24.3.1997 / 20:39:04 / cg"
    "Modified: / 19.1.2000 / 16:06:46 / cg"
!

openPassiveDataConnection:mode for:command
    "open & retrieve a data connection.
     Raise connectFailedSignal if data connection can't be established"

    |port dataConnection dataHostAndPort hostAddress peerAddress result|

    peerAddress := connection getFullPeerAddress.

    [
        result := self sendCommand:'EPSV'.
    ] on:UnimplementedOperationErrorSignal do:[:ex|
        result := ERROR.
    ].
    result == SUCCESS ifTrue:[
        dataHostAndPort := (lastResponse copyFrom: ((lastResponse indexOf:$() + 1) to: ((lastResponse indexOf:$)) -1)) asCollectionOfSubstringsSeparatedBy:$|.
        "/sometimes servers send another separator - trying it....
        (dataHostAndPort size < 4) ifTrue:[
            dataHostAndPort := (lastResponse copyFrom: ((lastResponse indexOf:$() + 1) to: ((lastResponse indexOf:$)) -1)) asCollectionOfSubstringsSeparatedBy:$!!.
        ].
        port := (dataHostAndPort at: 4) asNumber.
        peerAddress port:port.
        hostAddress := peerAddress.
    ] ifFalse:[
        peerAddress isIPv4SocketAddress ifFalse:[
            ^ self noPort:'Server does not support EPSV for IPv6 connections'.
        ].
        (self sendCommand: 'PASV') ~~ SUCCESS ifTrue:[
            ^ self noPort:'Both EPSV and PASV commands failed'.
        ].
        dataHostAndPort := (lastResponse copyFrom: ((lastResponse indexOf:$() + 1) to: ((lastResponse indexOf:$)) -1)) asCollectionOfSubstringsSeparatedBy:$,.
        hostAddress := ByteArray 
                        with:(dataHostAndPort at: 1) asNumber
                        with:(dataHostAndPort at: 2) asNumber
                        with:(dataHostAndPort at: 3) asNumber
                        with:(dataHostAndPort at: 4) asNumber.

        port := ((dataHostAndPort at: 5) asNumber) bitShift:8.
        port := port bitOr: ((dataHostAndPort at: 6) asNumber).
        hostAddress := IPSocketAddress hostAddress:hostAddress port:port.
    ].


    "/ now, open data connection to the host and port specified within the 
    "/ PASSIVE response

    dataConnection := Socket 
                        newTCPclientToAddress:hostAddress
                        withTimeout:connectionTimeout.

    dataConnection isNil ifTrue:[
        ^ self noPort:'open data connection failed'.
    ].

    self sendCommandNoWait:command.
    (self getResponseForPORTCommand ~~ SUCCESS) ifTrue:[
        ^ self noPort:lastResponse.
    ].

    ^ dataConnection

    "
     |ftp|
     ftp := FTPClient new.
     ftp passiveMode:true.
     ftp connectTo:'ftp.exept.de' user:'anonymous' password:'ftpClientTest@smalltalk-x.de'.
     ftp list inspect.
     ftp close
    "

    "Created: / 19.1.2000 / 16:06:24 / cg"
    "Modified: / 1.3.2000 / 14:33:10 / cg"
!

performLoginSequence
    "login using userName and password iff userName is not nil.
     This is invoked automatically by doConnect.
     If userName is nil, manual login is required."

    userName notNil ifTrue:[
        self login:userName password:password
    ].

    "
     FTPClient connectTo:'ftp.exept.de'
    "
!

sendGoodByeCommand
    self sendCommandNoWait:'QUIT'.
!

setModeTo:mode
    partnersTransferMode ~~ mode ifTrue:[
        mode == #ascii ifTrue:[
            self ascii
        ] ifFalse:[
            self binary
        ].
    ].
! !

!FTPClient class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/FTPClient.st,v 1.66 2017-06-12 10:41:32 mawalch Exp $'
! !


FTPClient initialize!
