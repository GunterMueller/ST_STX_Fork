"
 COPYRIGHT (c) 1998 by eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:goodies/communication' }"

Object subclass:#TelnetClient
	instanceVariableNames:'connection outputStream state readerProcess sb sbData
		connectionBrokenAction terminalType'
	classVariableNames:'NumberToCommandMapping NumberToOptionMapping Verbose'
	poolDictionaries:''
	category:'Net-Communication-Telnet'
!

!TelnetClient class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1998 by eXept Software AG
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
    Implements the telnet client protocol.
    Provides limited writeStream protocol, allowing
    data to be sent to the partner via #nextPut: like protocol.
    Input arriving from the telnet partner is forwarded to my
    outputStream.
    A concrete application is found in TelnetTool, which connects me
    to a TerminalView.

    [author:]
	Claus Gittinger (cg@exept.de)

    [start with:]
	TelnetTool open

    [see also:]
	TelnetTool
	TerminalView

    [instance variables:]
	connection      <Socket>        the telnet connection

	outputStream    <Stream>        data arriving from the
					telnet connection is forwarded
					to that stream.

	state           <Symbol>        the telnet protocol state.

	sb, sbData                      internal buffer for
					SB..SE data
"
!

examples
"
[exBegin]

    |connection telnetClient stream|

    Verbose := true.

    [
	stream := WriteStream on:''.
	connection := Socket
			newTCPclientToHost:'rainmaker.wunderground.com'
			port:23.
	connection notNil ifTrue: [
	    telnetClient := TelnetClient new.
	    telnetClient connectionBrokenAction:[connection close].
	    telnetClient terminalType:'dumb'.
	    telnetClient outputStream:stream.
	    telnetClient newConnection:connection.
	    telnetClient nextPutLine:'hello'.
	    Delay waitForSeconds:1.
	    telnetClient nextPutLine:''.
	    Delay waitForSeconds:1.
	].
    ] ensure:[
	connection notNil ifTrue:[
	    telnetClient disconnect.
	]
    ].
    stream contents inspect.

[exEnd]

[exBegin]
    |connection telnetClient stream|

    Verbose := true.

    [
	stream := WriteStream on:''.
	connection := Socket
			newTCPclientToHost:'localhost'
			port:23.
	connection notNil ifTrue: [
	    telnetClient := TelnetClient new.
	    telnetClient connectionBrokenAction:[connection close].
	    telnetClient terminalType:'dumb'.
	    telnetClient outputStream:stream.
	    telnetClient newConnection:connection.
	    Delay waitForSeconds:1.
	    telnetClient nextPutLine:''.
	    Delay waitForSeconds:1.
	].
    ] ensure:[
	connection notNil ifTrue:[
	    telnetClient disconnect.
	]
    ].
    stream contents inspect.
[exEnd]
"
! !

!TelnetClient class methodsFor:'initialization'!

initialize
    Verbose := false.
    "/ self initializeMappings     "/ done lazily now
!

initializeMappings
    NumberToCommandMapping := IdentityDictionary new.
    NumberToOptionMapping := IdentityDictionary new.

    #(
	IAC     255             "/* interpret as command: */
	DONT    254             "/* you are not to use option */
	DO      253             "/* please, you use option */
	WONT    252             "/* I won't use option */
	WILL    251             "/* I will use option */
	SB      250             "/* interpret as subnegotiation */
	GA      249             "/* you may reverse the line */
	EL      248             "/* erase the current line */
	EC      247             "/* erase the current character */
	AYT     246             "/* are you there */
	AO      245             "/* abort output--but let prog finish */
	IP      244             "/* interrupt process--permanently */
	BREAK   243             "/* break */
	DM      242             "/* data mark--for connect. cleaning */
	NOP     241             "/* nop */
	SE      240             "/* end sub negotiation */
	EOR     239             "/* end of record (transparent mode) */
	ABORT   238             "/* Abort process */
	SUSP    237             "/* Suspend process */
	xEOF    236             "/* End of file: EOF is already used... */

	SYNCH   242             "/* for telfunc calls */
    ) pairWiseDo:[:s :n |
	NumberToCommandMapping at:n put:s.
	NumberToCommandMapping at:s put:n.
    ].

    #(
	TELOPT_BINARY               0 "/* 8-bit data path */
	TELOPT_ECHO                 1 "/* echo */
	TELOPT_RCP                  2 "/* prepare to reconnect */
	TELOPT_SGA                  3 "/* suppress go ahead */
	TELOPT_NAMS                 4 "/* approximate message size */
	TELOPT_STATUS               5 "/* give status */
	TELOPT_TM                   6 "/* timing mark */
	TELOPT_RCTE                 7 "/* remote controlled transmission and echo */
	TELOPT_NAOL                 8 "/* negotiate about output line width */
	TELOPT_NAOP                 9 "/* negotiate about output page size */
	TELOPT_NAOCRD              10 "/* negotiate about CR disposition */
	TELOPT_NAOHTS              11 "/* negotiate about horizontal tabstops */
	TELOPT_NAOHTD              12 "/* negotiate about horizontal tab disposition */TELOPT_NAOFFD   13      /* negotiate about formfeed disposition */
	TELOPT_NAOVTS              14 "/* negotiate about vertical tab stops */
	TELOPT_NAOVTD              15 "/* negotiate about vertical tab disposition */
	TELOPT_NAOLFD              16 "/* negotiate about output LF disposition */
	TELOPT_XASCII              17 "/* extended ascic character set */
	TELOPT_LOGOUT              18 "/* force logout */
	TELOPT_BM                  19 "/* byte macro */
	TELOPT_DET                 20 "/* data entry terminal */
	TELOPT_SUPDUP              21 "/* supdup protocol */
	TELOPT_SUPDUPOUTPUT        22 "/* supdup output */
	TELOPT_SNDLOC              23 "/* send location */
	TELOPT_TTYPE               24 "/* terminal type */
	TELOPT_EOR                 25 "/* end or record */
	TELOPT_TUID                26 "/* TACACS user identification */
	TELOPT_OUTMRK              27 "/* output marking */
	TELOPT_TTYLOC              28 "/* terminal location number */
	TELOPT_3270REGIME          29 "/* 3270 regime */
	TELOPT_X3PAD               30 "/* X.3 PAD */
	TELOPT_NAWS                31 "/* window size */
	TELOPT_TSPEED              32 "/* terminal speed */
	TELOPT_LFLOW               33 "/* remote flow control */
	TELOPT_LINEMODE            34 "/* Linemode option */
	TELOPT_XDISPLOC            35 "/* X Display Location */
	TELOPT_OLD_ENVIRON         36 "/* Old - Environment variables */
	TELOPT_AUTHENTICATION      37 "/* Authenticate */
	TELOPT_ENCRYPT             38 "/* Encryption option */
	TELOPT_NEW_ENVIRON         39 "/* Environment variables */
	TELOPT_EXOPL              255 "/* extended-options-list */
    ) pairWiseDo:[:s :n |
	NumberToOptionMapping at:n put:s.
	NumberToOptionMapping at:s put:n.
    ].

    "
     self initializeMappings
    "

    "Created: / 27.7.1998 / 14:56:15 / cg"
    "Modified: / 27.7.1998 / 15:55:37 / cg"
! !

!TelnetClient class methodsFor:'instance creation'!

new
    ^ self basicNew initialize

    "Created: / 27.7.1998 / 15:07:23 / cg"
! !

!TelnetClient class methodsFor:'debugging'!

verbose

    ^ Verbose
!

verbose:aBoolean

    Verbose := aBoolean
! !

!TelnetClient methodsFor:'accessing'!

connectionBrokenAction:aBlock
    "set the action which is evaluated when the connection is broken"

    connectionBrokenAction := aBlock

    "Created: / 27.7.1998 / 17:12:35 / cg"
!

disconnect
"/ Transcript showCR:'*** disconnect'.

    self stopReaderProcess.
    connection notNil ifTrue:[
	connection close.
	connection := nil.
    ]

    "Created: / 27.7.1998 / 15:06:27 / cg"
    "Modified: / 27.7.1998 / 18:31:43 / cg"
!

newConnection:aSocket
    self stopReaderProcess.
    connection := aSocket.
    Verbose == true ifTrue:[
	'TelnetClient [info]: connected' infoPrintCR.
    ].
    self startReaderProcess.

    "Created: / 27.7.1998 / 15:05:56 / cg"
    "Modified: / 27.7.1998 / 18:32:32 / cg"
!

outputStream
    "return the value of the instance variable 'outputStream' (automatically generated)"

    ^ outputStream

    "Created: / 27.7.1998 / 15:18:24 / cg"
!

outputStream:something
    "set the value of the instance variable 'outputStream' (automatically generated)"

    outputStream := something.

    "Created: / 27.7.1998 / 15:18:24 / cg"
!

terminalType:something
    "what we tell the partner, what the terminal looks like.
     If never set, it defaults to either 'dumb' or 'vt100', depending on the outStream"

    terminalType := something.
! !

!TelnetClient methodsFor:'initialization'!

initialize
    NumberToCommandMapping isNil ifTrue:[
	self class initializeMappings
    ].

    "/ super initialize.

    state := #DATA.

    "Created: / 27.7.1998 / 15:07:41 / cg"
! !

!TelnetClient methodsFor:'queries'!

isConnected
    ^ connection notNil

    "Created: / 27.7.1998 / 15:04:51 / cg"
! !

!TelnetClient methodsFor:'stream protocol'!

nextPut:aCharacter
    "send that character to my telnet partner"

    connection nextPut:aCharacter.

    Verbose == true ifTrue:[
	('TelnetClient [info]: -> ' , aCharacter codePoint printString) infoPrintCR.
    ].

    "Modified: / 27.7.1998 / 18:33:01 / cg"
!

nextPutAll:aString
    "send some characters to my telnet partner"

"/aString do:[:aChar |
"/    self nextPut:aChar.
"/].
"/^ self.

    Verbose == true ifTrue:[
	('TelnetClient [info]: -> ' , aString) infoPrintCR.
    ].
    connection nextPutAll:aString

    "Created: / 27.7.1998 / 15:23:45 / cg"
    "Modified: / 27.7.1998 / 18:33:11 / cg"
!

nextPutByte:aByte
    "send that character to my telnet partner"

    connection nextPutByte:aByte.

    Verbose == true ifTrue:[
	('TelnetClient [info]: -> ' , aByte printString) infoPrintCR.
    ].

    "Created: / 27.7.1998 / 15:56:21 / cg"
    "Modified: / 27.7.1998 / 18:33:25 / cg"
!

nextPutBytes:count from:anObject startingAt:start
    "write count bytes from an object starting at index start to my telnet partner"

    connection nextPutBytes:count from:anObject startingAt:start.
!

nextPutLine:aString
    self nextPutAll:aString.
    self nextPut:(Character return).
!

sendCommand:aCmdSymbol option:anOptionOrNil
    |bytes count|

    Verbose == true ifTrue:[
	Transcript showCR:('==> IAC  %1  %2'  bindWith: aCmdSymbol with:anOptionOrNil ).
    ].

    bytes := ByteArray new:3.
    bytes at: 1 put:( NumberToCommandMapping at:#IAC ).
    bytes at: 2 put:( NumberToCommandMapping at:aCmdSymbol ).

    anOptionOrNil notNil ifTrue:[
	count := 3.
	bytes at:3 put:( NumberToOptionMapping  at:anOptionOrNil ifAbsent:anOptionOrNil ).
    ] ifFalse:[
	count := 2.
    ].
    self nextPutBytes:count from:bytes startingAt:1
!

sendDO:option
    self sendCommand:#DO option:option.
!

sendDONT:option
    self sendCommand:#DONT option:option.
!

sendSB:option
    self sendCommand:#SB option:option.
!

sendSBCommand:aCmdSymbol option:anOption subOption:subOption
    |bytes|

    Verbose == true ifTrue:[
	Transcript showCR:('==> IAC  SB %1 %2 %3'  bindWith: aCmdSymbol with:anOption with:subOption).
    ].

    bytes := ByteArray new:7.
    bytes at: 1 put:( NumberToCommandMapping at:#IAC ).
    bytes at: 2 put:( NumberToCommandMapping at:#SB ).
    bytes at: 3 put:( NumberToOptionMapping  at:anOption ifAbsent:anOption ).
    bytes at: 4 put:( NumberToCommandMapping at:aCmdSymbol ).
    bytes at: 5 put:subOption.
    bytes at: 6 put:( NumberToCommandMapping at:#IAC ).
    bytes at: 7 put:( NumberToCommandMapping at:#SE ).

    self nextPutBytes:bytes size from:bytes startingAt:1
!

sendSE
    self sendCommand:#SE option:nil.
!

sendWILL:option
    self sendCommand:#WILL option:option.
!

sendWONT:option
    self sendCommand:#WONT option:option.
! !

!TelnetClient methodsFor:'telnet protocol'!

readerProcessForever
    |readBytes buffer inByte index i2 nData s|

    connection text.
    state  := #DATA.
    buffer := ByteArray new:1024.

    [ true ] whileTrue:[
	connection readWait.
	readBytes := connection nextAvailableBytes:1024 into:buffer startingAt:1.

	readBytes <= 0 ifTrue:[
	    connection atEnd ifTrue:[^ self ].

	    Verbose == true ifTrue:[
		'TelnetClient [warn]: readBytes = 0' infoPrintCR.
	    ].
	    Delay waitForMilliseconds:200.  "bug under windows..."
	] ifFalse:[
	    index := 1.

	    [index <= readBytes] whileTrue:[
		state == #DATA ifTrue:[
		    "/ chunk data processing

		    i2 := buffer indexOf:16rFF "IAC" startingAt:index.
		    i2 > readBytes ifTrue:[
			i2 := 0.
		    ].
		    i2 == 0 ifTrue:[
			"/ all data - process fast.
			"/ ...
			nData := readBytes - index + 1.
			s := String new:nData.
			s replaceBytesFrom:1 to:nData with:buffer startingAt:index.

			(outputStream ? Transcript) nextPutAll:s.
			index := readBytes + 1.
		    ] ifFalse:[
			nData := i2 - index.
			nData > 0 ifTrue:[
			    "/ process data part fast
			    "/ ...
			    s := String new:nData.
			    s replaceBytesFrom:1 to:nData with:buffer startingAt:index.

			    (outputStream ? Transcript) nextPutAll:s.
			].
			index := i2.
		    ]
		].
		index <= readBytes ifTrue:[
		    inByte := buffer at:index.
		    index := index + 1.
		    self perform:('state' , state , ':') asSymbol with:inByte.
		]
	    ].
	    outputStream notNil ifTrue:[
		outputStream sync.
	    ].
	].
    ].
!

startReaderProcess

    readerProcess notNil ifTrue:[
	'TelnetClient [warn]: readerProcess started twice' infoPrintCR.
	^ self
    ].

    readerProcess :=
	[
	    [
		connection class errorSignal handle:[:ex1 |
		    Verbose == true ifTrue:[
			('TelnetClient [warn]: error <%1>' bindWith:ex1) infoPrintCR.
		    ].
		] do:[
		    connection class brokenConnectionSignal handle:[:ex2|
			Verbose == true ifTrue:[
			    ('TelnetClient [warn]: broken connection <%1>' bindWith:ex2) infoPrintCR.
			].
		    ] do:[
			self readerProcessForever.
		    ].
		].
	    ] ensure:[
		readerProcess := connection := nil.

		connectionBrokenAction notNil ifTrue:[
		    connectionBrokenAction value.
		].
		self stopReaderProcess.
	    ].
	] fork.

    readerProcess name:'telnet reader'.

    "Created: / 27.7.1998 / 14:57:34 / cg"
    "Modified: / 28.7.1998 / 12:04:01 / cg"
!

stopReaderProcess
    readerProcess notNil ifTrue:[
	readerProcess terminate.
	readerProcess := nil
    ].

    "Created: / 27.7.1998 / 15:04:07 / cg"
    "Modified: / 27.7.1998 / 16:22:59 / cg"
! !

!TelnetClient methodsFor:'telnet protocol - state machine'!

handleSB:sb data:sbData
    |option|

    option := NumberToOptionMapping at:sb ifAbsent:[].

    Verbose ifTrue:[
	Transcript showCR:'<<< SB ' , (option ? sb) printString , ' | ' , sbData storeString.
    ].

    option notNil ifTrue:[
	|selector|
	selector := ('handleSB_' , option , ':') asSymbol.
	(self respondsTo:selector) ifTrue:[
	    self perform:selector with:sbData.
	    ^ self.
	].
    ].
    self sendSBCommand:#WONT option:sb subOption:sbData first

    "Modified: / 5.5.1999 / 18:21:38 / cg"
!

handleSB_TELOPT_TTYPE:sbData
    |ttyType|

    (sbData at:1) == 1 ifTrue:[ "/ TELQUAL_SEND
	"/ - only if outputStream is a terminalView
	ttyType := terminalType.
	ttyType isNil ifTrue:[
	    ttyType := outputStream perform:#terminalType ifNotUnderstood:'vt100'.
	].

	self sendSB:#TELOPT_TTYPE.
	self nextPutByte:0.     "/ TELQUAL_IS
	self nextPutAll:ttyType.
	self sendSE.
	^ self
    ].

    self breakPoint:#cg info:'unhandled TELOPT-TTYPE'.
    self sendSBCommand:#WONT option:#TELOPT_TTYPE subOption:sbData first

    "Created: / 27.7.1998 / 15:59:59 / cg"
    "Modified: / 5.5.1999 / 14:45:19 / cg"
!

stateDATA:inByte
    inByte == 255 ifTrue:[
	state := #IAC.
	^ self.
    ].

    (outputStream ? Transcript) nextPut:(Character value:inByte)

    "Modified: / 27.7.1998 / 16:03:27 / cg"
!

stateDO:inByte
    "please do option"

    |option nCols nLines|

    option := NumberToOptionMapping at:inByte ifAbsent:nil.

    state := #DATA.

    Verbose ifTrue:[
	Transcript showCR:'<<< DO ' , option printString.
    ].

    option == #TELOPT_ECHO ifTrue:[
	"/ do-echo
"/        self sendWILL:option.
	self sendWONT:option.
	^ self.
    ].
    option == #TELOPT_SGA ifTrue:[
	"/ suppress go-ahead
	self sendWILL:option.
	^ self.
    ].
    option == #TELOPT_TTYPE ifTrue:[
	"/ terminal-type
	self sendWILL:option.
	^ self.
    ].

    option == #TELOPT_NAWS ifTrue:[
	|colAndLines|

	"/ window size
	"/ - only if outputStream is a terminalView
	nLines := 24.
	Error catch:[nLines := outputStream numberOfTerminalLines].
	nCols := 80.
	Error catch:[nCols := outputStream numberOfTerminalCols].

	self sendWILL:option.
	self sendSB:option.

	colAndLines := ByteArray
		with:(nCols // 256)
		with:(nCols \\ 256)
		with:(nLines // 256)
		with:(nLines \\ 256).

	self nextPutBytes:4 from:colAndLines startingAt:1.
	self sendSE.
	^ self
    ].

    option == #TELOPT_LINEMODE ifTrue:[
	"/ we pretend to support line mode, but currently not any sub-option of line mode
	self sendWILL:option.
	^ self.
    ].

    Verbose ifTrue:[
	('TelnetClient [info]: ignored: DO ' , option) infoPrintCR.
    ].
    self sendWONT:option.

    "Created: / 27.7.1998 / 15:02:38 / cg"
    "Modified: / 5.5.1999 / 18:20:44 / cg"
!

stateDONT:inByte
    "please do not option"

    |option|

    option := NumberToOptionMapping at:inByte ifAbsent:nil.

    Verbose ifTrue:[
	Transcript showCR:'<<< DONT ' , option printString.
    ].

    state := #DATA.

    option == #TELOPT_ECHO ifTrue:[
	"/ echo := false
	self sendWONT:option.
	^ self.
    ].

    Verbose ifTrue:[
	('TelnetClient [info]: ignored: DONT ' , option) infoPrintCR.
    ].
    self sendWONT:option.

    "Created: / 27.7.1998 / 15:03:01 / cg"
    "Modified: / 5.5.1999 / 18:20:53 / cg"
!

stateIAC:inByte
    |cmd|

    cmd := NumberToCommandMapping at:inByte ifAbsent:nil.
    cmd == #DO ifTrue:[ "/ please use option
	state := #DO.
	^ self.
    ].
    cmd == #DONT ifTrue:[ "/ please do not use option
	state := #DONT.
	^ self.
    ].
    cmd == #WILL ifTrue:[ "/ will use option
	state := #WILL.
	^ self.
    ].
    cmd == #WONT ifTrue:[ "/ will not use option
	state := #WONT.
	^ self.
    ].
    cmd == #SB ifTrue:[ "/ sub
	state := #SB.
	^ self.
    ].
    cmd == #EOR ifTrue:[ "/ end of record
	state := #DATA.
	^ self.
    ].
    cmd == #GA ifTrue:[ "/ go ahead
	state := #DATA.
	^ self.
    ].
    cmd == #IAC ifTrue:[ "/ escaped IAC
	outputStream nextPut:(Character value:inByte).
	state := #DATA.
	^ self.
    ].

    Verbose == true ifTrue:[
	('TelnetClient [info]: ignored: ' , cmd , ' in state ' , state) infoPrintCR.
    ].
    state := #DATA

    "Created: / 27.7.1998 / 15:00:36 / cg"
    "Modified: / 27.7.1998 / 18:34:31 / cg"
!

stateSB:inByte
    "sub"

    |cmd|

    cmd := NumberToCommandMapping at:inByte ifAbsent:nil.
    cmd == #IAC ifTrue:[
	state := #SBIAC.
	^ self.
    ].
    state := #SBDATA.
    sb := inByte.
    sbData := #[]

    "Created: / 27.7.1998 / 15:44:54 / cg"
    "Modified: / 27.7.1998 / 15:50:32 / cg"
!

stateSBDATA:inByte
    "sub-data"

    |cmd|

    cmd := NumberToCommandMapping at:inByte ifAbsent:nil.
    cmd == #IAC ifTrue:[
	state := #SBDATAIAC.
	^ self.
    ].
    sbData := sbData copyWith:inByte

    "Created: / 27.7.1998 / 15:46:13 / cg"
    "Modified: / 27.7.1998 / 15:51:12 / cg"
!

stateSBDATAIAC:inByte
    "sub-data"

    |cmd|

    cmd := NumberToCommandMapping at:inByte ifAbsent:nil.
    cmd == #IAC ifTrue:[
	state := #SBDATA.
	sbData := sbData copyWith:inByte.
	^ self.
    ].
    cmd == #SE ifTrue:[
	self handleSB:sb data:sbData.
	sb := nil.
	sbData := nil.
	state := #DATA.
	^ self.
    ].
    cmd == #SB ifTrue:[
	self handleSB:sb data:sbData.
	sb := nil.
	state := #SB.
	^ self.
    ].

    state := #DATA.
    ^ self.

    "Modified: / 27.7.1998 / 15:52:56 / cg"
!

stateSBIAC:inByte
    "sub-iac"

    |cmd|

    cmd := NumberToCommandMapping at:inByte ifAbsent:nil.
    cmd == #IAC ifTrue:[
	state := #SBDATA.
	sb := inByte.
	sbData := #[].
	^ self.
    ].
    state := #DATA.

    "Created: / 27.7.1998 / 15:45:56 / cg"
    "Modified: / 27.7.1998 / 15:50:20 / cg"
!

stateWILL:inByte
    "please do option"

    |option|

    option := NumberToOptionMapping at:inByte ifAbsent:nil.

    Verbose ifTrue:[
	Transcript showCR:'<<< WILL ' , option printString.
    ].

    state := #DATA.

    option == #TELOPT_ECHO ifTrue:[
	"/ echo := true
	self sendDO:option.
	^ self.
    ].
    option == #TELOPT_SGA ifTrue:[
	self sendDO:option.
	^ self.
    ].

    Verbose ifTrue:[
	('TelnetClient [info]: ignored: WILL ' , option) infoPrintCR.
    ].
    self sendDONT:option.

    "Created: / 27.7.1998 / 15:02:38 / cg"
    "Modified: / 5.5.1999 / 18:21:02 / cg"
!

stateWONT:inByte
    "please dont option"

    |option|

    option := NumberToOptionMapping at:inByte ifAbsent:inByte.

    Verbose ifTrue:[
	Transcript showCR:'<<< WONT ' , option printString.
    ].

    state := #DATA.

    option == #TELOPT_ECHO ifTrue:[
	self sendDONT:#TELOPT_ECHO.
	^ self.
    ].
    option == #TELOPT_SGA ifTrue:[
	self sendDONT:option.
	^ self.
    ].

    Verbose ifTrue:[
	('TelnetClient [info]: ignored: WONT ' , option) infoPrintCR.
    ].
    self sendDONT:option.

    "Created: / 27.7.1998 / 17:10:04 / cg"
    "Modified: / 5.5.1999 / 18:21:10 / cg"
! !

!TelnetClient class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/TelnetClient.st,v 1.37 2016-04-20 21:12:34 mawalch Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/TelnetClient.st,v 1.37 2016-04-20 21:12:34 mawalch Exp $'
! !


TelnetClient initialize!
