"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 2005 by eXept Software AG
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

Object subclass:#SftpClient
	instanceVariableNames:'connection hostname port username sourceIpAddress protocolVersion
		requestId packetBuilder'
	classVariableNames:''
	poolDictionaries:'Nfs4Constants SftpConstants'
	category:'Net-Communication-SFTP'
!

Object subclass:#SftpHandle
	instanceVariableNames:'sftpClient handle'
	classVariableNames:''
	poolDictionaries:''
	privateIn:SftpClient
!

Object subclass:#SftpPacketBuilder
	instanceVariableNames:'stream'
	classVariableNames:'RequestCodes ResponseCodes'
	poolDictionaries:''
	privateIn:SftpClient
!

!SftpClient class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2005 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!SftpClient methodsFor:'accessing'!

connection
    ^ connection
!

connection:something
    connection := something.
!

hostname
    ^ hostname
!

hostname:something
    hostname := something.
!

nextRequestId
    "answer the next unused requestId. Wrap around."
    |currentId|

    currentId := requestId.
    requestId := requestId + 1.
    requestId = SmallInteger maxVal ifTrue:[
        requestId := 0.
    ].

    ^ currentId.
!

port
    ^ port
!

port:something
    port := something.
!

sourceIpAddress
    ^ sourceIpAddress
!

sourceIpAddress:something
    sourceIpAddress := something.
!

username
    ^ username
!

username:something
    username := something.
! !

!SftpClient methodsFor:'connecting'!

close
    |conn|

    conn := connection.
    conn notNil ifTrue:[
        connection := nil.
        conn close.
    ].
!

connect

    |connectString|

    connectString := self connectString.
    connection := PipeStream bidirectionalFor:connectString errorDisposition:#stderr inDirectory:nil.
    connection binary.

    packetBuilder := SftpPacketBuilder new.
    requestId := 0.

    self initialHandshake.

    "
      (self new hostname:'exept.exept.de') connect   
      (self new hostname:'nonExistent') connect   
    "
!

connectString

    |commandStream|

    commandStream := '' writeStream.

    commandStream nextPutAll: 'ssh -oClearAllForwardings=yes -s '.
    port notNil ifTrue:[
        commandStream nextPutAll:'-D '.
        port printOn:commandStream.
        commandStream space.
    ].

    username notNil ifTrue:[
        commandStream nextPutAll:username; nextPut:$@.
    ].
    commandStream nextPutAll:hostname.
    commandStream nextPutAll:' sftp'.

    ^ commandStream contents

    "
        (self new hostname:'localhost'; username:'ftp') connectString   
    "
! !

!SftpClient methodsFor:'direct access'!

cd:remotePath
    self sftpCommand:'cd ', remotePath.

    "
        self new hostname:'exeptn.bh.exept.de'; cd:'/tmp' 
    "
!

copyLocal:localFilename to:remoteFilename
    self sftpCommand:'put ', localFilename, ' ', remoteFilename.

    "
        self new hostname:'exept.exept.de'; copyLocal:'/etc/hosts' to:'/tmp'
    "
!

copyRemote:remoteFilename to:localFilename
    self sftpCommand:'get ', remoteFilename, ' ', localFilename.

    "
        self new hostname:'exept.exept.de'; copyRemote:'/etc/hosts' to:'/tmp'
    "
!

directoryContentsOf:remoteFilename
    |outputStream output sz lsCommand|

    lsCommand := OperatingSystem getOSType = #solaris ifTrue:['ls '] ifFalse:['ls -1 '].
    outputStream := self sftpCommand:lsCommand, (remoteFilename ? '').

    output := outputStream contents asStringCollection.
    sz := output size.
    sz >= 1 ifTrue:[
        output removeFirst. "this is the command"
        (sz >= 2 and:[output last startsWith:'sftp>']) ifTrue:[
            output removeLast.  "this is the ssh prompt"
        ].
    ].

    ^ output

    "
        self new hostname:'exeptn'; directoryContentsOf:''
        self new hostname:'exeptn'; directoryContentsOf:'/home/stefan'
        self new hostname:'exeptn'; directoryContentsOf:'/glump'
    "

    "Modified (comment): / 21-02-2017 / 14:33:55 / mawalch"
!

mkdir:remoteFilename
    self sftpCommand:'mkdir ', remoteFilename.

    "
        self new hostname:'exeptn'; mkdir:'/tmp/test' 
    "
!

nlist
   ^ self directoryContentsOf:''

    "
        self new hostname:'exeptn'; nlist 
    "
!

pwd
    |outputStream output|

    outputStream := self sftpCommand:'pwd'.

    output := outputStream contents asStringCollection.
    output removeFirst. "this is the command"
    output removeLast.  "this is the ssh prompt"

    ^ output

    "
        self new hostname:'exept.exept.de'; version
    "

    "Modified (comment): / 21-02-2017 / 14:34:06 / mawalch"
!

remove:remoteFilename
    self sftpCommand:'rm ', remoteFilename.

    "
        self new hostname:'exept.exept.de'; remove:'/tmp/hosts' 
    "
!

rename:existingRemoteFilename to:newRemoteFilename
    self sftpCommand:'rename ', existingRemoteFilename, ' ', newRemoteFilename .

    "
        self new hostname:'exept.exept.de'; rename:'/tmp/hosts' to:'/tmp/h'
    "
!

safeCopyLocal:localFilename to:remoteFilename
    "same as copyLocal, but use an intermediate file"

    |commandStream|

    commandStream := '' writeStream.
    commandStream 
        nextPutAll:'put '; nextPutAll:localFilename; space; nextPutAll:remoteFilename; nextPutAll:'.tmp'; cr;
        nextPutAll:'-rm '; nextPutAll:remoteFilename; cr;
        nextPutAll:'rename '; nextPutAll:remoteFilename; nextPutAll:'.tmp'; space; nextPutAll:remoteFilename.

    self sftpCommand:commandStream contents.

    "
        self new hostname:'exept.exept.de'; saveCopyLocal:'/etc/hosts' to:'/tmp/hosts'
    "
!

sftpCommand:sftpCommand

    |commandStream pipe outputStream|

    commandStream := '' writeStream.
    commandStream nextPutAll:'/usr/bin/sftp -C '.
    port notNil ifTrue:[
        commandStream nextPutAll:'-oPort='.
        port printOn:commandStream.
        commandStream space.
    ].
    sourceIpAddress notNil ifTrue:[
        commandStream nextPutAll:'-oBindAddress='.
        sourceIpAddress printOn:commandStream.
        commandStream space.
    ].

    OperatingSystem getOSType = #solaris ifTrue:[
        "Solaris ssh does not support '-b -' yet (2007-10-16)"
        commandStream nextPutAll:'-b /dev/fd/0 2>&1 '.
    ] ifFalse:[
        commandStream nextPutAll:'-b - 2>&1 '.
    ].

    username notNil ifTrue:[
        commandStream nextPutAll:username; nextPut:$@.
    ].
    commandStream nextPutAll:hostname.
    outputStream := '' writeStream.

    [    
        pipe := PipeStream bidirectionalFor:commandStream contents.

        pipe 
            nextPutAll:sftpCommand; cr; 
            shutDownOutput; copyToEndInto:outputStream.
    ] on: ReadError do:[:ex|
    ].

    pipe close.

    pipe finishedWithSuccess ifFalse:[
        OpenError new raiseRequestWith:pipe errorString:' - sftp command failed: ', sftpCommand, ' (', outputStream contents, ')'.
    ].

    ^ outputStream

    "
        self new hostname:'exept.de'; copyRemote:'/etc/hosts' to:'/tmp'
    "

    "Modified (comment): / 22-05-2018 / 18:26:26 / Stefan Vogel"
!

version
    |outputStream output|

    outputStream := self sftpCommand:'version'.

    output := outputStream contents asStringCollection.
    output removeFirst. "this is the command"
    output size > 1 ifTrue:[
        output removeLast.  "this is the ssh prompt"
    ].

    ^ output

    "
        self new hostname:'exeptn.bh.exept.de'; version
    "

    "Modified (comment): / 21-02-2017 / 14:34:13 / mawalch"
! !

!SftpClient methodsFor:'errors'!

protocolError:description with:sftpPacket
    Error raiseWith:sftpPacket errorString:description 
! !

!SftpClient methodsFor:'protocol'!

directoryContentsFromHandle:sftpHandle

    |answer|

    packetBuilder request:SSH_FXP_READDIR.
    packetBuilder unsignedLong:self nextRequestId.
    packetBuilder string:sftpHandle.

    connection nextPutAll:packetBuilder getPacket.

    answer := self getNextPacket.
    answer type ~~ SSH_FXP_NAME ifTrue:[
        self protocolError:'expect SSH_FXP_NAME' with:answer.
    ].


    "
        |sftpConnection|

        sftpConnection := (self new hostname:'exept.exept.de') connect.
        [
            (sftpConnection openDirectory:'/etc') directoryContents
        ] ensure:[
            sftpConnection close
        ]
    "
!

initialHandshake

    |answer|

    packetBuilder request:SSH_FXP_INIT.
    packetBuilder unsignedLong:3.         "version number"

    connection nextPutAll:packetBuilder getPacket.

    answer := self getNextPacket.
    answer type ~~ SSH_FXP_VERSION ifTrue:[
        self protocolError:'expect SSH_FXP_HANDLE' with:answer.
    ].

    protocolVersion := answer doubleWordAt:2 MSB:true.
!

openDirectory:aFilenameString

    |answer handle|

    packetBuilder request:SSH_FXP_OPENDIR.
    packetBuilder unsignedLong:self nextRequestId.
    packetBuilder string:aFilenameString utf8Encoded.

    connection nextPutAll:packetBuilder getPacket.

    answer := self getNextPacket.
    answer type ~~ SSH_FXP_HANDLE ifTrue:[
        self protocolError:'expect SSH_FXP_HANDLE' with:answer.
    ].

    handle := SftpHandle new sftpClient:self handle:answer handle.

    ^ handle.

    "
        (self new hostname:'exept.exept.de') connect openDirectory:'/etc'  
    "
!

openFile:aFilenameString

    |answer handle|

    packetBuilder request:SSH_FXP_OPEN.
    packetBuilder unsignedLong:self nextRequestId.
    packetBuilder string:aFilenameString utf8Encoded.
    packetBuilder unsignedLong:ACE4_GENERIC_READ.               "desired-access"
    packetBuilder unsignedLong:0.                               "flags"
                                                                "no attributes for now"

    connection nextPutAll:packetBuilder getPacket.

    answer := self getNextPacket.
    answer type ~~ SSH_FXP_HANDLE ifTrue:[
        self protocolError:'expect SSH_FXP_HANDLE' with:answer.
    ].

    handle := SftpHandle new sftpClient:self handle:answer handle.

    ^ handle.

    "
        (self new hostname:'exept.exept.de') connect openFile:'/etc/hosts'  
    "
! !

!SftpClient methodsFor:'reading packets'!

getNextPacket
    "read the next packet and return it without the length field"

    |length buffer|

    length := connection nextInt32MSB:true.
    buffer := SftpPacket new:length.

    connection nextBytes:length into:buffer startingAt:1.

    ^ buffer
! !

!SftpClient methodsFor:'stream access'!

getStreamFor:aFilenameString
    |tmpFilename tmpStream|

    tmpFilename := Filename newTemporary.
    self copyRemote:aFilenameString to:tmpFilename pathName.
    tmpStream := tmpFilename readStream.
    tmpStream removeOnClose:true.

    ^ tmpStream
! !

!SftpClient::SftpHandle methodsFor:'accessing'!

handle
    ^ handle
!

handle:something
    handle := something.
!

sftpClient
    ^ sftpClient
!

sftpClient:something
    sftpClient := something.
!

sftpClient:sftpClientArg handle:handleArg 
    "set instance variables (automatically generated)"

    sftpClient := sftpClientArg.
    handle := handleArg.
! !

!SftpClient::SftpHandle methodsFor:'operations'!

close
    "close the handle"

    sftpClient closeHandle:handle
!

contents
    "return the contents of the file as a StringCollection (read the file)"

    ^ sftpClient contentsFromHandle:handle
!

delete
    "delete the file represented by handle"

    sftpClient deleteHandle:handle
!

directoryContents
    "answer the directoryContents represented by handle"

    ^ sftpClient directoryContentsFromHandle:handle
! !

!SftpClient::SftpPacketBuilder class methodsFor:'initialization'!

initialize
    self initializeRequestCodes
!

initializeRequestCodes
    "
      self initializeRequestCodes
    "

     RequestCodes := IdentityDictionary withKeysAndValues:
         #(SSH_FXP_INIT                1
           SSH_FXP_VERSION             2
           SSH_FXP_OPEN                3
           SSH_FXP_CLOSE               4
           SSH_FXP_READ                5
           SSH_FXP_WRITE               6
           SSH_FXP_LSTAT               7
           SSH_FXP_FSTAT               8
           SSH_FXP_SETSTAT             9
           SSH_FXP_FSETSTAT           10
           SSH_FXP_OPENDIR            11
           SSH_FXP_READDIR            12
           SSH_FXP_REMOVE             13
           SSH_FXP_MKDIR              14
           SSH_FXP_RMDIR              15
           SSH_FXP_REALPATH           16
           SSH_FXP_STAT               17
           SSH_FXP_RENAME             18
           SSH_FXP_READLINK           19
           SSH_FXP_LINK               21
           SSH_FXP_BLOCK              22
           SSH_FXP_UNBLOCK            23

           SSH_FXP_STATUS            101
           SSH_FXP_HANDLE            102
           SSH_FXP_DATA              103
           SSH_FXP_NAME              104
           SSH_FXP_ATTRS             105

           SSH_FXP_EXTENDED          200
           SSH_FXP_EXTENDED_REPLY    201)
! !

!SftpClient::SftpPacketBuilder class methodsFor:'instance creation'!

newRequest:requestSymbol
    "create a new request packet"

    ^ self basicNew request:requestSymbol
! !

!SftpClient::SftpPacketBuilder methodsFor:'accessing'!

getPacket
    |packet|

    packet := stream contents.
    packet doubleWordAt:1 put:packet size - 4 MSB:true.      "packet size excluding length field"

    ^ packet
! !

!SftpClient::SftpPacketBuilder methodsFor:'parameters'!

string:aString
    "represent aString"

    self unsignedLong:aString size.
    stream nextPutAll:aString.
!

unsignedLong:anInteger
    stream nextPutInt32:anInteger MSB:true
! !

!SftpClient::SftpPacketBuilder methodsFor:'setup'!

request:aRequestNumber

    stream := WriteStream on:(ByteArray new:32).
    stream nextPutInt32:5 MSB:true.            "minimum length: 1 byte type / 4 byte request id"
    stream nextPutByte:aRequestNumber.

"/    (aRequestSymbol ~~ #SSH_FXP_INIT and:[aRequestSymbol ~~ #SSH_FXP_VERSION]) ifTrue:[
"/        stream nextPutLongNet:0. "request-id"
"/    ].
! !

!SftpClient class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/SftpClient.st,v 1.15 2018-05-22 16:27:19 stefan Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/SftpClient.st,v 1.15 2018-05-22 16:27:19 stefan Exp $'
! !


SftpClient::SftpPacketBuilder initialize!
