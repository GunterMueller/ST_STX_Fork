"
 COPYRIGHT (c) 1992 by Claus Gittinger
 COPYRIGHT (c) 2015 Jan Vrany
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic2' }"

"{ NameSpace: Smalltalk }"

NonPositionableExternalStream subclass:#Socket
	instanceVariableNames:'domain socketType protocol port peer peerName listening'
	classVariableNames:''
	poolDictionaries:''
	category:'Streams-External'
!

!Socket primitiveDefinitions!
%{
/* #define DGRAM_DEBUG /* */

#ifdef __MINGW__
# include <stdio.h>
#endif
#include "stxOSDefs.h"

#ifdef __win32__
//#define DEBUG 1
/* this is to catch uses of those - there should be none */
# undef __BEGIN_INTERRUPTABLE__
# undef __END_INTERRUPTABLE__
# ifdef __TCC__
#  define __BEGIN_INTERRUPTABLE__ xxxx
#  define __END_INTERRUPTABLE__ yyyy
# else
#  define __BEGIN_INTERRUPTABLE__ ..
#  define __END_INTERRUPTABLE__ ..
# endif

# define WRAP_STDIO
// The default is linger until all data is sent in background
// so the close on the socket is non-blocking
// linger.onoff=off linger.time= *irrelevant*
//# define SET_LINGER_WHEN_CREATING_SOCKET

# ifdef __xxMINGW__
extern HANDLE _get_osfhandle();
# endif

# if defined(__BORLANDC__)
// not defined in borland headers
typedef unsigned int socklen_t;
# endif

# if 0 && (defined( __BORLANDC__ ) || defined( __MINGW__ ))
#  define SOCKET_FROM_FD(fd)               (SOCKET)(_get_osfhandle(fd))
# else
#  define SOCKET_FROM_FD(fd)               (SOCKET)(fd)
# endif
#else /* not __win32__ */
# define SOCKET_FROM_FD(fd)   (fd)
# define closesocket(sock)    close(sock)
# define SOCKET               int
#endif /* ! __win32__ */

#define SOCKET_FROM_FILE(f)             (SOCKET_FROM_FD(fileno(f)))
#define SOCKET_FROM_FILE_OBJECT(f)      (__INST(handleType) == @symbol(socketHandle) ? SOCKET_FROM_FD(__FILEVal(f)) : SOCKET_FROM_FILE(__FILEVal(f)))

#ifndef __MINGW__
# include <stdio.h>
#endif
#include <errno.h>

#ifdef WANT__TCP_DOT_H
# include <netinet/tcp.h>
#endif

#ifdef WANT__NETDB_DOT_H
# include <netdb.h>
#endif

#if defined(TRY_AGAIN) || defined(HOST_NOT_FOUND)
# define USE_H_ERRNO
#endif

/*
 * on some systems errno is a macro ... check for it here
 */
#ifndef errno
 extern errno;
#endif

#ifdef USE_H_ERRNO
# ifndef h_errno
 extern h_errno;
# endif
#endif

#ifdef DEBUG
# define DBGPRINTF(x)    { if (__debugging__) console_printf x; }
# define DBGFPRINTF(x)   { if (__debugging__) console_fprintf x; }
#else
# define DBGPRINTF(x)    /* as nothing */
# define DBGFPRINTF(x)   /* as nothing */
#endif

#ifndef TRUE
# define TRUE   1
#endif
#ifndef FALSE
# define FALSE  0
#endif
#ifndef __win32__
typedef int BOOL;
#endif

#ifdef __win32__
# undef stdout
# undef stderr
# define stdout __win32_stdout()
# define stderr __win32_stderr()
#endif
%}
! !

!Socket primitiveVariables!
%{
static int __debugging__ = 0;
%}
! !

!Socket primitiveFunctions!
%{

static int
setupBufferParameters(OBJ aDataBuffer, OBJ startIndex, char **p_extPtr, INT *p_offs, size_t *p_objSize)
{
	char *extPtr = 0;
	int sIdx = 0, objSize = 0, offs = 0;

	sIdx = 0;
	if (__isSmallInteger(startIndex)) {
	    sIdx = __intVal(startIndex) - 1;
	}

	if (__isExternalBytesLike(aDataBuffer)) {
	    OBJ sz;

	    extPtr = (char *)(__externalBytesAddress(aDataBuffer));
	    sz = __externalBytesSize(aDataBuffer);
	    if (__isSmallInteger(sz)) {
		objSize = __intVal(sz);
	    } else {
		objSize = 0; /* unknown */
	    }
	    offs = sIdx;
	} else {
	    OBJ oClass;
	    int nInstVars, nInstBytes;

	    extPtr = (char *)0;
	    oClass = __Class(aDataBuffer);
	    switch (__intVal(__ClassInstPtr(oClass)->c_flags) & ARRAYMASK) {
		case BYTEARRAY:
		    offs = sIdx;
		    break;
		case WORDARRAY:
		case SWORDARRAY:
		    offs = sIdx * 2;
		    break;
		case LONGARRAY:
		case SLONGARRAY:
		    offs = sIdx * 4;
		    break;
		case LONGLONGARRAY:
		case SLONGLONGARRAY:
		    offs = sIdx * 8;
# ifdef __NEED_LONGLONG_ALIGN
		    offs += 4;
# endif
		    break;
		case FLOATARRAY:
		    offs = sIdx * sizeof(float);
		    break;
		case DOUBLEARRAY:
		    offs = sIdx * sizeof(double);
# ifdef __NEED_DOUBLE_ALIGN
		    offs += 4;
# endif
		    break;
		default:
		    *p_objSize = -1;
		    return 0;
	    }
	    nInstVars = __intVal(__ClassInstPtr(oClass)->c_ninstvars);
	    nInstBytes = OHDR_SIZE + nInstVars * sizeof(OBJ);
	    offs = offs + nInstBytes;
	    objSize = __Size(aDataBuffer) - offs;
	}
	*p_extPtr = extPtr;
	*p_objSize = objSize;
	*p_offs = offs;
	return 1;
}
%}
! !

!Socket class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1992 by Claus Gittinger
 COPYRIGHT (c) 2015 Jan Vrany
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
    This class provides access to sockets for interprocess communication.

    Currently, only IP and UNIX domain sockets are really fully
    tested and supported.
    Code for appletalk is included, but was never tested ...
    More may be added in the future.
    (the code is prepared for things like SNA or decNet;
     however, right now, this code is empty and needs a little work.
     Implementing those is pretty straightforward, once the address
     data structures are known.)

    Due to historic reasons (I started this class, before I got hold of some
    code using ST-80 Sockets i.e. RemoteInvocation), there is some old interface
    which is still supported.
    This may vanish; use the #family:type: or #newTCPxxx and #newUDPxxx interfaces,
    together with the bind/listen and accept calls,
    which are meant to be compatible to ST-80's UnixSocketAccessor interface.

    TODO: cleanup historic leftovers,
          change to raise more signals on errors.

    [author:]
        Claus Gittinger
"
!

examples
"
    example (get help info from an nntp server):
                                                                        [exBegin]
        |sock|

        sock := Socket newTCPclientToHost:'smtp.exept.de' port:'smtp'.
        sock isNil ifTrue:[
            self warn:'no smtp daemon is running'.
            ^ self
        ].
        Transcript showCR:sock nextLine.

        sock nextPutAll:'HELO STX socket test'; cr.
        Transcript showCR:sock nextLine.
        sock close
                                                                        [exEnd]


    example (connect to finger daemon, get users entry):
                                                                        [exBegin]
        |sock entry|

        sock := Socket newTCPclientToHost:'localhost' port:'finger'.
        sock isNil ifTrue:[
            self warn:'no finger daemon is running'.
            ^ self
        ].
        sock useCRLF:true.
        sock buffered:false.
        sock isNil ifTrue:[
            Transcript showCR:'cannot connect to local finger daemon'
        ] ifFalse:[
            sock nextPutAll:(OperatingSystem getLoginName).
            sock cr.

            entry := sock nextLine.
            Transcript showCR:entry.

            sock close
        ]
                                                                        [exEnd]

    example (connect to an ftp server):
                                                                        [exBegin]
        |sock|

        sock := Socket newTCPclientToHost:'www.exept.de' port:'ftp'.

        sock buffered:false.
        Transcript showCR:sock nextLine.
        sock nextPutAll:('USER ' , 'anonymous'); cr.
        Transcript showCR:sock nextLine.
        sock nextPutAll:('PASS ' , 'fooBar'); cr.
        Transcript showCR:sock nextLine.
        sock nextPutAll:'HELP'; cr.
        [
            |line|
            line := sock nextLine.
            Transcript showCR:line.
            (line at:4) = $-
        ] whileTrue.
        sock close.

        'don't know enough of the ftp protocol to continue here ...'
                                                                        [exEnd]


    example (connect to an snmp server [UDP]):
    Note: this is not a real connection, only the destination address is
          being fixed.
                                                                        [exBegin]
        |sock port|

        sock := Socket newUDP.
        port := Socket portOfService:'snmp'.
        sock connectTo:'localhost' port:port.
        sock buffered:false.
        Transcript showCR:'got it'.
        sock close.
                                                                        [exEnd]


    example (await connection from a client and read some data):
                                                                        [exBegin]
        |connectSock sock|

        connectSock := Socket newTCPserverAtPort:9998.
        connectSock isNil ifTrue:[
            Transcript showCR:'socket setup failed.'.
        ] ifFalse:[
            Transcript showCR:'listen ..'.
            (connectSock listenFor:5) ifFalse:[
                Transcript showCR:'listen failed.'.
            ] ifTrue:[
                Transcript showCR:'wait'.
                connectSock readWait.
                Transcript showCR:'accept'.
                sock := connectSock accept.
                sock isNil ifTrue:[
                    Transcript showCR:'accept failed.'.
                ] ifFalse:[
                    sock buffered:false.
                    Transcript showCR:'server: got it'.
                    'can now do transfer via sock'.
                    Transcript showCR:'read'.
                    Transcript showCR:('got: ' , sock nextLine).

                    Transcript showCR:'close'.
                    sock close
                ].
                connectSock close.
            ]
        ]
                                                                        [exEnd]


    example (connect to above server and send some data):
                                                                        [exBegin]
        |sock|

        sock := Socket newTCPclientToHost:'localhost' port:9998.
        sock isNil ifTrue:[
            Transcript showCR:'nope'
        ] ifFalse:[
            sock buffered:false.
            Transcript showCR:'client: got it'.
            'can now do transfer via sock'.
            Transcript showCR:'sending <hello>'.
            sock nextPutLine:'hello'.
            sock close
        ]
                                                                        [exEnd]

    example: UNIX domain socket (await connection from a client and read some data):

        |connectSock sock|

        '/tmp/ud_socket' asFilename remove.
        connectSock := Socket newUNIXserverAt:'/tmp/ud_socket'.
        connectSock isNil ifTrue:[
            Transcript showCR:'socket setup failed.'.
        ] ifFalse:[
            Transcript showCR:'listen ..'.
            (connectSock listenFor:5) ifFalse:[
                Transcript showCR:'listen failed.'.
            ] ifTrue:[
                Transcript showCR:'wait'.
                connectSock buffered:false.
                connectSock readWait.
                Transcript showCR:'accept'.
                sock := connectSock accept.
                sock isNil ifTrue:[
                    Transcript showCR:'accept failed.'.
                ] ifFalse:[
                    sock buffered:false.
                    Transcript showCR:'server: got it'.
                    'can now do transfer via sock'.
                    Transcript showCR:'read'.
                    Transcript showCR:('got: ' , sock nextLine).

                    Transcript showCR:'close'.
                    sock close
                ].
                connectSock close.
            ]
        ]


    example (connect to above server and send some data;
             Notice, this fails, if above server code is executed in the same ST/X image
                     (at least on LINUX), since the OS does not correctly handle
                     a connect from within an interrupted accept system call
                     On SGI's SVR4, this works ok
                                                                        [exBegin]
        |sock|

        sock := Socket newUNIXclientTo:'/tmp/ud_socket'.
        sock isNil ifTrue:[
            Transcript showCR:'nope'
        ] ifFalse:[
            sock buffered:false.
            Transcript showCR:'client: got it'.
            'can now do transfer via sock'.
            Transcript showCR:'sending <hello>'.
            sock nextPutLine:'hello'.
            sock close
        ]
                                                                        [exEnd]


    example (UDP await packet from a client and read some data):
                                                                        [exBegin]
        |udpSock sock addr n dataBuffer|

        udpSock := Socket newUDPserverAtPort:9999.
        udpSock isNil ifTrue:[
            Transcript showCR:'socket setup failed.'.
        ] ifFalse:[
            Transcript showCR:'wait'.
            udpSock readWait.

            addr := IPSocketAddress new.
            dataBuffer := ByteArray new:1000.
            n := udpSock receiveFrom:addr buffer:dataBuffer start:1 for:dataBuffer size.
            n > 0 ifTrue:[
                Transcript showCR:('got: ' , n printString , 'bytes  from ' , addr printString).
                Transcript showCR:('data: ' , (dataBuffer copyTo:n) printString).
            ] ifFalse:[
                Transcript showCR:'read failed'.
            ].

            Transcript showCR:'close'.
            udpSock close
        ]
                                                                        [exEnd]
    example (connect to above UDP server and send some data;
                                                                        [exBegin]
        |sock|

        sock := Socket newUDP.
        sock isNil ifTrue:[
            Transcript showCR:'nope'
        ] ifFalse:[
            sock sendTo:(IPSocketAddress new hostName:'localhost' port:9999) buffer:'hello world'.
            sock close
        ]
                                                                        [exEnd]

    example: pingWalk (try to ping hosts on the local network)
    Note: it dosen't use ICMP ping, but tries to reache the echo service,
          which is disabled on most OS.
                                                                        [exBegin]
        |myAddress list top hosts walkProcess port|

        myAddress := OperatingSystem getNetworkAddresses
                        keysAndValuesSelect:[:eachIFName :eachAddress|
                            eachAddress isLocal not
                            and:[eachIFName = 'wlan0']
                        ].
        myAddress := myAddress first hostAddress.

        port := Socket portOfService:'echo'.
        port isNil ifTrue:[
            self error:'dont know echo port'.
            ^ self
        ].

        top := StandardSystemView new.
        top label:'PING net walk'.

        list := ScrollableView for:ListView in:top.
        list origin:0.0@0.0 corner:1.0@1.0.

        top openAndWait.

        walkProcess := [
            |l low hi direction tryHostID dottedName hostName conn addr|

            l := SortedCollection new.

            ' only works with type C-net
              the code below could simply do 1 to:254 do:[:hostID }
              but, to probe likely hosts earlier, the probing is done
              ping-pong like around my ip-address (assuming, that other machines
              have numbers around my own)'.

            low := hi := (myAddress at:4).
            direction := 1.

            [low > 0 or:[hi < 255]] whileTrue:[
                direction > 0 ifTrue:[
                    hi := hi + 1.
                    tryHostID := hi.
                    direction := -1.
                ] ifFalse:[
                    low := low - 1.
                    tryHostID := low.
                    direction := 1.
                ].
                (tryHostID between:1 and:254) ifTrue:[
                    dottedName := (myAddress at:1) printString
                                  , '.' , (myAddress at:2) printString
                                  , '.' , (myAddress at:3) printString
                                  , '.' , tryHostID printString.

                    top label:'PING net walk - trying ' , dottedName.

                    top windowGroup withCursor:Cursor wait do:[
                        conn := Socket newTCPclientToHost:dottedName port:port withTimeout:1000.
                        conn notNil ifTrue:[
                            addr := Socket ipAddressOfHost:dottedName.
                            hostName := Socket hostWithIpAddress:addr.
                            hostName isNil ifTrue:[
                                hostName :='?'
                            ].
                            l add:(dottedName paddedTo:15 with:Character space)
                                   , ' '
                                   , (hostName paddedTo:15 with:Character space)
                                   , ' up & reachable'.
                            list list:l.
                            conn close.
                        ]
                    ].
                ].
            ].
            top label:'PING reachable hosts'.
        ] forkAt:(Processor userBackgroundPriority).
        walkProcess name:'ping net walker'.
                                                                        [exEnd]


        This example creates a simple UDP server that accepts
        single packets from anybody and broadcasts them to all
        clients that have connected so far.

                                                                        [exBegin]
        | socket address buffer msgSize clients |
        clients := Set new.
        address := IPSocketAddress new.
        buffer := String new: 1024.

        socket := self newUDPserverAtPort: 6666.

        Transcript showCR: 'server starting'.

        [
            [true] whileTrue: [
                (socket readWaitWithTimeoutMs: 200) ifFalse: [
                    msgSize := socket
                            receiveFrom: address
                            buffer: buffer
                            start: 1
                            for: buffer size.

                    clients add: address copy.
                    clients do: [ :clientAddress |
                            socket
                                    sendTo: clientAddress
                                    buffer: buffer
                                    start: 1
                                    for: msgSize]]
            ]
        ] ensure:[
            Transcript showCR: 'server shutting down'.
            socket close
        ]
                                                                        [exEnd]

   send a datagram to above server:
                                                                        [exBegin]

        | socket address buffer host msg |

        host := Dialog
                request: 'What is the name of the server''s host?'
                initialAnswer: 'localhost'.

        socket := self newUDP.

        address := IPSocketAddress hostName: host port: 6666.

        buffer := ByteArray new: 1000.
        [
            [(msg := Dialog request: 'Say something') isEmpty] whileFalse:[
                | replySize stream |

                socket writeWait.
                stream := buffer writeStream.
                stream nextPutAll: msg.
                socket sendTo:address buffer:buffer start:1 for:stream position.
                socket readWait.

                replySize := socket receiveFrom:address buffer:buffer.
                replySize > 0 ifTrue: [
                    Transcript cr; nextPutAll: 'Server acknowledged: '.
                    Transcript show: ((buffer copyFrom: 1 to: replySize) asString)
                ]
            ]
        ] ensure: [socket close].
        Transcript cr
                                                                        [exEnd]


   loopBack:
                                                                        [exBegin]

        |readerTask readingSocket writingSocket|

        readingSocket := self newTCPserverAtPort:9999.
        readerTask :=
            [
                |connection|

                readingSocket listenFor:1.
                connection := readingSocket accept.
                readingSocket close.
                [connection atEnd] whileFalse:[
                    Transcript showCR:(connection nextLine).
                ].
                connection close.
            ] fork.

        Delay waitForSeconds:1.
        writingSocket := self newTCPclientToHost:'localhost' port:9999.
        writingSocket nextPutLine:'Hello'.
        writingSocket nextPutLine:'World'.
        writingSocket close.
                                                                        [exEnd]
"
! !

!Socket class methodsFor:'instance creation'!

bindTo:aSocketAddress type:aTypeSymbol
    "create a socket for a specific type
     and bind it to aSocketAddress.
     Type must be:
	#stream, #datagram or #raw

     Neither connect nor connect-wait is done."

    |newSock|

    newSock := self domain:aSocketAddress domain type:aTypeSymbol.
    [
	newSock bindTo:aSocketAddress reuseAddress:true.
    ] ifCurtailed:[
	newSock close.
    ].
    ^ newSock


    "
	Socket bindTo:(IPSocketAddress anyHost port:8081) type:#stream.
	Socket bindTo:(IPv6SocketAddress anyHost port:8081) type:#datagram.
    "
!

domain:domainSymbol type:type
    "create a socket for domain and type -
     neither any connect nor binding is done.
     Domain must be one of the symbols:
	#inet, #unix, #appletalk, #decnet, #xns, ...;
     Type must be:
	#stream, #datagram or #raw

     XXX: currently only the #AF_INET and #AF_INET6 and #AF_UNIX domains are supported"

    ^ self new domain:domainSymbol type:type

    "
     Socket domain:#AF_INET type:#stream
     Socket domain:#AF_INET type:#datagram
     Socket domain:#AF_INET6 type:#stream
     Socket domain:#AF_INET6 type:#datagram
     Socket domain:#AF_UNIX type:#stream
    "
!

newTCP
    "create a TCP socket - no binding or other setup is done,
     neither connect nor connect-wait is done."

    ^ self new domain:#'AF_INET' type:#stream

    "
      Socket newTCP
    "
!

newTCP:aServiceOrNil
    "create a TCP socket for a service -
     neither connect nor connect-wait is done."

    |newSock socketAddress socketAddressClass|

    newSock := self newTCP.
    (newSock notNil and:[aServiceOrNil notNil]) ifTrue:[
	[
	    socketAddressClass := newSock socketAddressClass.
	    socketAddress := socketAddressClass hostName:nil serviceName:aServiceOrNil type:#stream.
	    socketAddress hostAddress:socketAddressClass anyAddress.
	    newSock bindTo:socketAddress reuseAddress:true.
	] ifCurtailed:[
	    newSock close.
	]
    ].
    ^ newSock


    "
	Socket newTCP:'http-alt'.
	Socket newTCP:9996.
    "
!

newTCPclientToAddress:aHostAddress port:aService
    "create a new TCP client socket connecting to a service.
     Return a socket instance if ok, nil on failure.
     Block until a connection is established (but only the current thread;
     not the whole smalltalk).
     See also: #newTCPclientToAddress:port:withTimeout:"

    ^ self newTCPclientToAddress:aHostAddress port:aService withTimeout:nil
!

newTCPclientToAddress:aSocketAddressOrByteArray port:aService withTimeout:millis
    "create a new TCP client socket connecting to a service.
     Return a socket instance if ok, nil on failure.
     If the millis arg is nonNil, stop trying to connect after that many milliseconds
     and return nil."

    |port socketAddress|

    aService isString ifTrue:[
	port := self portOfService:aService protocol:#tcp.
    ] ifFalse:[
	port := aService.
    ].
    socketAddress := aSocketAddressOrByteArray isSocketAddress
			ifTrue:[aSocketAddressOrByteArray]
			ifFalse:[
			    "Passing ByteArrays is obsolete and only supported for IPv4"
			    IPSocketAddress hostAddress:aSocketAddressOrByteArray
			].
    port notNil ifTrue:[
	socketAddress port:port.
    ].
    ^ self newTCPclientToAddress:socketAddress withTimeout:millis
!

newTCPclientToAddress:aSocketAddress withTimeout:millis
    "create a new TCP client socket connecting to a service.
     Return a socket instance if ok, nil on failure.
     If the millis arg is nonNil, stop trying to connect after that many milliseconds
     and return nil."

    |socket|

    socket := self domain:aSocketAddress domain type:#stream.
    (socket connectTo:aSocketAddress withTimeout:millis) ifFalse:[
	socket close.
	^ nil
    ].
    ^ socket.

    "
	self newTCPclientToAddress:(IPv6SocketAddress hostName:'www.exept.de' port:80) withTimeout:nil
    "
!

newTCPclientToHost:hostNameOrAddress port:aPortOrServiceName
    "create a new TCP client socket connecting to a service.
     If hostNameOrAddress is a string, try all the resolved addresses regardless
     whether for IPv4 or IPv6.
     Return a socket instance if ok, nil on failure.
     Block until a connection is established (but only the current thread;
     not the whole smalltalk).
     See also: #newTCPclientToHost:port:withTimeout:"

    ^ self
        newTCPclientToHost:hostNameOrAddress
        port:aPortOrServiceName
        domain:self defaultIpDomainForConnect
        withTimeout:nil

    "
      Socket newTCPclientToHost:'www.exept.de' port:'https'
    "

    "Created: 31.10.1995 / 18:54:11 / cg"
!

newTCPclientToHost:hostNameOrAddress port:aPortOrServiceName domain:aDomainSymbolOrNil withTimeout:millis
    "create a new TCP client socket connecting to a service on hostNameOrAddress.
     If hostNameOrAddress is a string, try all the resolved addresses.
     Return a socket instance if ok, nil on failure.
     Set aDomainSymbolOrNil to #AF_INET of #AF_INET6 to connect via a defined protocol.
     Set aDomainSymbolOrNil to nil, to try all protocols.
     If the millis arg is nonNil, stop trying to connect after that many milliseconds
     and return nil."

    |socket addressInfoList|

    hostNameOrAddress isString ifFalse:[
        ^ self newTCPclientToAddress:hostNameOrAddress port:aPortOrServiceName withTimeout:millis.
    ].

    addressInfoList := SocketAddress
                            getAddressInfo:hostNameOrAddress
                            serviceName:aPortOrServiceName
                            domain:aDomainSymbolOrNil
                            type:#stream
                            protocol:nil
                            flags:0.

    addressInfoList do:[:eachAddressInfo|
        |domainSymbol lastDomainSymbol|

        domainSymbol := eachAddressInfo domain.
        domainSymbol ~~ lastDomainSymbol ifTrue:[
            socket notNil ifTrue:[
                socket close.
            ].
            socket := self new domain:domainSymbol type:#stream.
            lastDomainSymbol := domainSymbol.
        ].
        (socket connectTo:eachAddressInfo socketAddress withTimeout:millis) ifTrue:[
            ^ socket.
        ].
    ].
    socket notNil ifTrue:[
        socket close.
    ].
    ^ nil.

    "
      Socket newTCPclientToHost:'www.exept.de' port:80 domain:#'AF_INET' withTimeout:1000.
      Socket newTCPclientToHost:'www.exept.de' port:80 domain:#'AF_INET6' withTimeout:1000.
      Socket newTCPclientToHost:'www.exept.de' port:80 domain:nil withTimeout:1000.
      Socket newTCPclientToHost:'localhost' port:'nntp' withTimeout:1000
    "

    "Modified: / 16.1.1998 / 09:47:06 / stefan"
!

newTCPclientToHost:hostNameOrAddress port:aPortOrServiceName withTimeout:millis
    "create a new TCP client socket connecting to a service on hostNameOrAddress.
     If hostNameOrAddress is a string, try all the resolved addresses regardless
     whether for IPv4 or IPv6.
     Return a socket instance if ok, nil on failure.
     If the millis arg is nonNil, stop trying to connect after that many milliseconds
     and return nil."

    ^ self
        newTCPclientToHost:hostNameOrAddress
        port:aPortOrServiceName
        domain:self defaultIpDomainForConnect
        withTimeout:millis
!

newTCPserverAtAnonymousPort
    "create a new TCP server socket providing service on
     a new anonymous port. The portNr is assigned by the OS."

    ^ self newTCPserverAtPort:0

!

newTCPserverAtPort:aService
    "create a new TCP server socket providing service."

    ^ self newTCP:aService
!

newUDP
    "create a UDP socket - no binding or other setup is done,
     neither connect nor connect-wait is done."

    ^ self new domain:#'AF_INET' type:#datagram

    "Socket newUDP"
!

newUDP:aServiceOrNil
    "create a UDP socket for a service -
     neither connect nor connect-wait is done."

    |newSock socketAddressClass socketAddress|

    newSock := self newUDP.
    (newSock notNil and:[aServiceOrNil notNil]) ifTrue:[
	[
	    socketAddressClass := newSock socketAddressClass.
	    socketAddress := socketAddressClass hostName:nil serviceName:aServiceOrNil type:#stream.
	    socketAddress hostAddress:socketAddressClass anyAddress.
	    newSock bindTo:socketAddress reuseAddress:true.
	] ifCurtailed:[
	    newSock close.
	]
    ].
    ^ newSock

    "
	Socket newUDP:4444.
	Socket newUDP:'activesync'.
    "
!

newUDPserverAtPort:aService
    "create a new UDP server socket providing service."

    ^ self newUDP:aService
!

newUNIX
    "create a UNIX domain socket - no binding or other setup is done,
     neither connect nor connect-wait is done.
     If the system does not support unix domain sockets (i.e. VMS or MSDOS),
     return nil."

    ^ self new domain:#'AF_UNIX' type:#stream

    "
     Socket newUNIX
    "
!

newUNIXclientTo:pathName
    "create a new UNIX client socket connecting to a pathname.
     Return a socket instance if ok, nil on failure.
     Block until a connection is established (but only the current thread;
     not the whole smalltalk).
     If the system does not support unix domain sockets (i.e. VMS or MSDOS),
     return nil.
     See also: #newUNIXclientTo:withTimeout:"

    ^ self newUNIXclientTo:pathName withTimeout:nil

!

newUNIXclientTo:pathName withTimeout:millis
    "create a new UNIX client socket connecting to a pathname.
     Return a socket instance if ok, nil on failure.
     If the millis arg is nonNil, stop trying to connect after that many milliseconds
     and return nil.
     If the system does not support unix domain sockets (i.e. VMS or MSDOS),
     return nil."

    |newSock|

    newSock := self newUNIX.
    newSock notNil ifTrue:[
	(newSock connectTo:(UDSocketAddress name:pathName) withTimeout:millis) ifFalse:[
	    newSock close.
	    ^ nil
	]
    ].
    ^ newSock

    "
	Socket newUNIXclientTo:'/tmp/foo'
    "
!

newUNIXserverAt:pathName
    "create a new UNIX server socket providing service at a pathname.
     If the system does not support unix domain sockets (i.e. VMS or MSDOS),
     return nil."

    ^ self bindTo:(UDSocketAddress name:pathName) type:#stream.

    "
     |s s2|

    '/tmp/foo' asFilename remove.
     s := Socket newUNIXserverAt:'/tmp/foo'.
     s listenFor:5.
     s2 := s accept.
    "
! !

!Socket class methodsFor:'Compatibility-ST80'!

family:domainSymbol type:typeSymbol
    "create a socket for domain and type - ST80 simply uses a different name.
     Domain must be one of the symbols: #inet, #unix, #appletalk or #ns;
     Type must be #stream, #datagram or #raw."

    ^ self domain:domainSymbol type:typeSymbol

    "
     Socket family:#AF_INET type:#stream
     Socket family:#AF_INET type:#datagram
     Socket family:#AF_UNIX type:#stream
    "
!

getHostname
    "return the computer's hostname string"

    ^ OperatingSystem getHostName

    "Created: / 27.2.1998 / 02:32:17 / cg"
!

sockStream
    "return the type code for stream sockets"

    ^ #stream
! !

!Socket class methodsFor:'Compatibility-Squeak'!

deadlineSecs:seconds
    ^ Timestamp now addSeconds:seconds
!

initializeNetwork
    "/ intentionally left blank here
!

standardDeadline
    "a standard timeout in seconds for connection setup;
     not really used in ST/X code (but by some code ported from squeak)"

    ^ 30
!

standardTimeout
    "a standard timeout in seconds for transfers;
     not really used in ST/X code (but by some code ported from squeak)"

    ^ 30
!

wildcardPort
    ^ nil
! !

!Socket class methodsFor:'Compatibility-VW'!

AF_INET
    ^ #AF_INET
!

SOCK_STREAM
    ^ #SOCK_STREAM
! !

!Socket class methodsFor:'Signal constants'!

brokenConnectionSignal
    "return the signal used to tell broken connections.
     Since in unix, this is the same as the broken pipe signal,
     return that one.
     (for other Operatingsystems, this may change ..)"

    ^ PipeStream brokenPipeSignal
!

invalidArgumentsSignal
    "dummy for compatibility"

    ^ self errorSignal
! !

!Socket class methodsFor:'debugging'!

debug:aBoolean
    "turn on/off internal debugprints.
     This method is for ST/X debugging only and
     may  be removed in later versions"

%{  /* NOCONTEXT */

    __debugging__ = (aBoolean == true);
%}
    "
     Socket debug:true
     Socket debug:false
    "
! !

!Socket class methodsFor:'defaults'!

defaultIpDomainForConnect
    "answer the domain used to look up host names for connect:
        #AF_INET    use only IPv4
        #AF_INET6   use only IPv6
        nil         use both IPv4 and IPv6"

    ^ nil
! !

!Socket class methodsFor:'obsolete'!

connectTo:service on:host
    <resource: #obsolete>
    "standard & easy client setup:
	create new client tcp socket, bind and connect;
	return the socket.
     The thread blocks (interruptable), until the connection is established."

    ^ self newTCPclientToHost:host port:(self portOfService:service).

    "
     Socket connectTo:9995 on:'clam'
     Socket connectTo:4711 on:'exept'
     Socket connectTo:'finger' on:'clam'
     Socket connectTo:'ftp' on:'exept'
     Socket connectTo:'nntp' on:(OperatingSystem getEnvironment:'NNTPSERVER')
    "
!

networkLongOrderIsMSB
    "return the well known fact, that network byte order is most significant byte first"

    <resource: #obsolete>

    ^ true
!

networkShortOrderIsMSB
    "return the well known fact, that network byte order is most significant byte first"

    <resource: #obsolete>

    ^ true
!

provide:aService
    "standard & easy server setup:
     create a new TCP server socket providing a service."

    <resource:#obsolete>

    |newSock|

    self obsoleteMethodWarning:'use #newTCPserverAtPort: / #listen'.

    newSock := self newTCPserverAtPort:(self portOfService:aService).
    newSock notNil ifTrue:[
	newSock listenFor:5.
    ].
    ^ newSock

    "
     Socket provide:9995
     (Socket provide:9996) accept
     Socket provide:'nntp'
    "
! !

!Socket class methodsFor:'obsolete host queries'!

appletalkAddressOfHost:aHostName
    <resource: #obsolete>
    "return the APPLETALK address for a hostname as a byteArray,
     where the network bytes come first (no matter what the local byteorder is)
     followed by the node byte.
     If the host is unknown, return nil.
     This is the reverse operation to #hostWithAppletalkAddress:.
     WARNING: untested code - I have no appletalk to test this."

    NameLookupError
	handle:[:ex |
	    ^ nil
	]
	do:[
	    ^ (AppletalkSocketAddress hostName:aHostName) address
	]
!

hostWithAppletalkAddress:addrByteArray
    <resource: #obsolete>
    "return the hostname for an APPLETALK address.
     The address is supposed to be a byteArray consisting of 3 bytes,
     the network bytes come first (no matter what the local byteorder is).
     The last byte is the node number.
     Nil is returned for an unknown host or if its not an appletalk host.
     This is is the reverse operation to #appletalkAddressOfHost:.
     WARNING: untested code - I have no appletalk to test this."

    NameLookupError
	handle:[:ex |
	    ^ nil
	]
	do:[
	    ^ (AppletalkSocketAddress hostAddress:addrByteArray) hostName
	]

    "
     Socket appletalkAddressOfHost:'yourAppleHere'
     Socket hostWithAppletalkAddress:#[1 2 3]
     "
!

hostWithIpAddress:addrByteArray
    <resource: #obsolete>
    "return the hostname for an IP (internet-) address.
     The address is supposed to be a byteArray consisting of 4 bytes,
     the network bytes come first (no matter what the local byteorder is).
     Nil is returned for an unknown host or if its not an internet host.
     This is the reverse operation to #ipAddressOfHost:."

    NameLookupError
	handle:[:ex |
	    ^ nil
	]
	do:[
	    ^ (IPSocketAddress hostAddress:addrByteArray) hostName
	]

    "
     Socket ipAddressOfHost:'clam'
     Socket hostWithIpAddress:(Socket ipAddressOfHost:'clam')
     Socket ipAddressOfHost:'porty'
     Socket hostWithIpAddress:(Socket ipAddressOfHost:'porty')
     Socket hostWithIpAddress:#[1 2 3 4]
     Socket hostWithIpAddress:#[127 0 0 1]
     Socket hostWithIpAddress:(Socket ipAddressOfHost:'1.2.3.4')
     Socket hostWithIpAddress:(Socket ipAddressOfHost:'www.altavista.com')
     "
!

hostWithIpV6Address:addrByteArray
    <resource: #obsolete>
    "return the hostname for an IPv6 (internet-) address.
     The address is supposed to be a byteArray consisting ??? bytes,
     the network bytes come first (no matter what the local byteorder is).
     Nil is returned for an unknown host or if its not an internet host.
     This is the reverse operation to #ipV6AddressOfHost:."

    NameLookupError
	handle:[:ex |
	    ^ nil
	]
	do:[
	    ^ (IPv6SocketAddress hostAddress:addrByteArray) hostName
	]

    "
     Socket ipV6AddressOfHost:'clam'
     Socket hostWithIpV6Address:(Socket ipAddressOfHost:'clam')
     Socket ipV6AddressOfHost:'porty'
     Socket hostWithIpV6Address:(Socket ipAddressOfHost:'porty')
     Socket hostWithIpV6Address:#[1 2 3 4 5 6 7 8 9 10 11 12 13 14]
     Socket ipV6AddressOfHost:'www.exept.de'
     "
!

ipAddressOfHost:aHostName
    <resource: #obsolete>
    "return the IP (internet-) number for a hostname as a byteArray,
     where the network bytes come first (no matter what the cpus byteOrder is).
     If the host is unknown, return nil.
     This is the reverse operation to #hostWithIpAddress:."

    NameLookupError
	handle:[:ex |
	    ^ nil
	]
	do:[
	    ^ (IPSocketAddress hostName:aHostName) address
	]

    "
     Socket ipAddressOfHost:'localhost'
     Socket ipAddressOfHost:'exept'
     Socket ipAddressOfHost:'1.2.3.4'
     Socket ipAddressOfHost:'193.15.16.17'
     Socket ipAddressOfHost:'josef'
     Socket ipAddressOfHost:'styx.com'
     Socket hostWithIpAddress:(Socket ipAddressOfHost:'localhost')
     Socket ipAddressOfHost:(Socket hostWithIpAddress:'127.0.0.1')
    "
!

ipV6AddressOfHost:aHostName
    <resource: #obsolete>
    "return the IPv6 (internet-) number for a hostname as a byteArray,
     where the network bytes come first (no matter what the cpus byteOrder is).
     If the host is unknown, return nil.
     This is the reverse operation to #hostWithIpV6Address:."

    NameLookupError
	handle:[:ex |
	    ^ nil
	]
	do:[
	    ^ (IPv6SocketAddress hostName:aHostName) address
	]

    "
     Socket ipV6AddressOfHost:'localhost'
     Socket ipV6AddressOfHost:'exept'
     Socket ipV6AddressOfHost:'exept.exept.de'
     Socket ipV6AddressOfHost:'www.google.de'
     Socket ipV6AddressOfHost:'1.2.3.4.5.6.7.8.9.10.11.12.13.14.15.16'
     Socket ipV6AddressOfHost:'josef'
     Socket ipV6AddressOfHost:'styx.com'
     Socket hostWithIpV6Address:(Socket ipV6AddressOfHost:'localhost')
     Socket ipV6AddressOfHost:(Socket hostV6WithIpAddress:'127.0.0.1')
    "
! !

!Socket class methodsFor:'queries'!

peerFromDomain:domain name:peerName port:port
    |addrClass|

    addrClass := self socketAddressClassForDomain:domain.
    ^ addrClass hostName:peerName serviceName:port type:nil
!

peerNameFromDomain:domain peer:peer
    |addrClass|

    addrClass := self socketAddressClassForDomain:domain.
    ^ addrClass peerNameFromPeer:peer
!

portOfService:aNameOrNumber
    "returns the port-number for a given IP-service
     or nil if no such service exists;
     - used to convert service names to portNumbers"

    ^ self portOfService:aNameOrNumber protocol:nil

    "
     Socket portOfService:'finger'
     Socket portOfService:'nntp'
     Socket portOfService:'echo'
     Socket portOfService:'snmp'
    "
!

portOfService:aNameOrNumber protocol:aProtocol
    "returns the port-number for a given IP-service
     or nil if no such service exists;
     - used to convert service names to portNumbers"

%{ /* UNLIMITEDSTACK(noWIN32) */
#ifndef NO_SOCKET
    struct servent *servent = NULL;
    char *protocol;
    int tryBoth = 0;
    short portNo;

    if (__isSmallInteger(aNameOrNumber)) {
	RETURN ( aNameOrNumber );
    }

    if (__isStringLike(aProtocol)) {
	protocol = (char *)__stringVal(aProtocol);
    } else {
	protocol = "tcp";
	tryBoth = 1;
    }

    if (__isStringLike(aNameOrNumber)) {
	servent = getservbyname((char *) __stringVal(aNameOrNumber), protocol);
	if (servent != NULL) {
	    RETURN ( __MKSMALLINT(ntohs(servent->s_port)) );
	}
	if (tryBoth) {
	    servent = getservbyname((char *) __stringVal(aNameOrNumber), "udp");
	    if (servent != NULL) {
		RETURN ( __MKSMALLINT(ntohs(servent->s_port)) );
	    }
	}
	RETURN ( nil );
    }
#endif
    RETURN ( nil );
%}
    "
     Socket portOfService:'echo' protocol:'udp'
     Socket portOfService:'echo' protocol:'tcp'
    "
!

protocolOfService:aNameOrNumber
    "returns the protocol (as string) for a given IP-service
     or nil if no such service exists."

%{  /* UNLIMITEDSTACK(noWIN32) */
#ifndef NO_SOCKET
    struct servent *servent = NULL;
    short portNo;

    if (__isSmallInteger(aNameOrNumber)) {
	portNo = __intVal(aNameOrNumber);
	servent = getservbyport(htons(portNo), "tcp") ;
	if (servent == NULL) {
	    servent = getservbyport(htons(portNo), "udp") ;
	    if (servent == NULL) {
		RETURN ( nil );
	    }
	}
    } else {
	if (__isStringLike(aNameOrNumber)) {
	    servent = getservbyname((char *) __stringVal(aNameOrNumber), "tcp");
	    if (servent == NULL) {
		servent = getservbyname((char *) __stringVal(aNameOrNumber), "udp");
		if (servent == NULL) {
		    RETURN ( nil );
		}
	    }
	}
    }
    if (servent) {
	RETURN ( __MKSTRING(servent->s_proto) );
    }
#endif /* !NO_SOCKET */
    RETURN ( nil );
%}
    "
     Socket protocolOfService:'finger'
     Socket protocolOfService:'nntp'
     Socket protocolOfService:'xxx'
     Socket protocolOfService:79
     Socket protocolOfService:'snmp'
    "
!

socketAddressClassForDomain:domain
    ^ SocketAddress knownClassFromCode:domain

    "
     self socketAddressClassForDomain:#AF_INET
     self socketAddressClassForDomain:#AF_UNIX
    "
!

supportedProtocolFamilies
    "return a collection of supported protocol families.
     This list specifies what the Socket class supports -
     socket creation may still fail, if your system was built
     without it."

    ^ OperatingSystem supportedProtocolFamilies

    "
     Socket supportedProtocolFamilies
    "
!

typeOfProtocol:aProtocol
    "given a protocols name (i.e. tcp, udp etc) return the connection type.
     This method needs more ... - or is there a way to get this from the system ?"

    (aProtocol = 'tcp') ifTrue:[^ #stream].
    (aProtocol = 'udp') ifTrue:[^ #datagram].
    (aProtocol = 'ip')  ifTrue:[^ #raw].
    "
     unix domain
    "
    (aProtocol = 'ud')  ifTrue:[^ #stream].
    "
     add x25 stuff (if any) here ...
    "
    "
     add appletalk stuff (if any) here ...
    "
    "
     add other stuff (if any) here ...
    "
    ^ nil

    "
     Socket typeOfProtocol:'tcp'
     Socket typeOfProtocol:'ucp'
     Socket typeOfProtocol:(Socket protocolOfService:'nntp')
     Socket typeOfProtocol:(Socket protocolOfService:'echo')
    "
! !

!Socket methodsFor:'Compatibility-Dolphin'!

setReceiveTimeout: milliseconds
    self receiveTimeout:(milliseconds / 1000)
!

setSendTimeout: milliseconds
    self sendTimeout:(milliseconds / 1000)
! !

!Socket methodsFor:'Compatibility-ST80'!

acceptNonBlock
    ^ self accept
!

ioConnection
    ^ self
!

notReadySignal
    "ST-80 mimicry.
     for now - this is not yet raised"

    ^ Signal new
!

readAppendStream
    "ST-80 mimicry.
     In ST-80, socket is not a stream, but referes to one.
     ST-80 code therefore uses 'Socket readWriteStream' to access
     the actual stream.
     In ST/X, sockets inherit from stream, so
     this method returns the receiver, for transparency"

    ^ self
!

readStream
    "ST-80 mimicry.
     In ST-80, socket is not a stream, but referes to one.
     ST-80 code therefore uses 'Socket readStream' to access
     the actual stream.
     In ST/X, sockets inherit from stream, so
     this method returns the receiver, for transparency"

    ^ self

    "Created: 24.1.1997 / 23:52:57 / cg"
!

writeStream
    "ST-80 mimicry.
     In ST-80, socket is not a stream, but referes to one.
     ST-80 code therefore uses 'Socket writeStream' to access
     the actual stream.
     In ST/X, sockets inherit from stream, so
     this method returns the receiver, for transparency"

    ^ self

    "Created: 24.1.1997 / 10:34:35 / cg"
    "Modified: 24.1.1997 / 23:52:52 / cg"
! !

!Socket methodsFor:'Compatibility-Squeak'!

address
    ^ self getSocketAddress
!

connectToHostNamed:hostName port:portNr
    self connectTo:hostName port:portNr
!

dataAvailable
    ^ self canReadWithoutBlocking
!

destroy
    self close

    "Created: / 04-06-2007 / 21:29:03 / cg"
!

listenOn:aPortNr
    self listenOn:aPortNr backlogSize:5

    "Modified: / 31-05-2007 / 17:59:53 / cg"
!

listenOn:aPortNr backlogSize:aNumber
    self bindTo:aPortNr address:nil.
    self listenFor:aNumber

    "Created: / 31-05-2007 / 17:59:47 / cg"
!

peerName
    "return my peer (i.e. ipAddr + port);
     May return nil if not yet setup completely."

    ^ self getPeer
!

sendData: aStringOrByteArray
    "Send all of the data in the given array, even if it requires multiple calls to send it all.
     Return the number of bytes sent."

    ^ self nextPutBytes:aStringOrByteArray size from:aStringOrByteArray startingAt:1.
!

setOption: optionName value: optionValue
    ^ self setSocketOption:(optionName asSymbol) argument:optionValue argument:nil

    "Modified: / 04-06-2007 / 21:23:19 / cg"
!

waitForConnectionUntil:aTimestamp
    "return true if connected"

    self readWaitWithTimeoutMs: (aTimestamp millisecondDeltaFrom:Timestamp now).
    ^ self isConnected
! !

!Socket methodsFor:'accepting connections'!

accept
    "create a new TCP socket from accepting on the receiver.
     This method will suspend the current process if no connection is waiting.
     For ST-80 compatibility"

    ^ self waitForNewConnectionWithTimeout:nil

    "
     |sock newSock|

     sock := Socket provide:8004.
     sock listenFor:5.
     newSock := sock accept.
    "
!

blockingAccept
    "create a new TCP socket from accepting on the receiver.
     This method will suspend the smalltalk image with all smalltalk processes if no connection is waiting.
     For ST-80 compatibility"

    |newSock|

    newSock := self class new.
    (newSock primAcceptOn:self blocking:true) ifFalse:[
	"should raise an error here"
	^ nil
    ].
    ^ newSock
! !

!Socket methodsFor:'binding'!

bindAnonymously
    "bind to any address. A free port will be allocated.
     Our own socket address will be determined after conection set up.
     This is the default after the socket has been created"

    ^ self bindTo:nil reuseAddress:false

    "
      self newTCP bindAnonymously; listenFor:1; yourself
      self newTCP bindAnonymously; port
    "
!

bindAnonymouslyToAddress:aSocketAddress
    "bind to address addressString.
     A free port will be allocated"

    ^ self
	bindTo:0
	address:aSocketAddress
	reuseAddress:false

    "
      self newTCP bindAnonymouslyToAddress:IPSocketAddress localHost; listenFor:1; yourself
    "
!

bindTo:aSocketAddress
    "ST80 compatible bind, expecting a socketAddress argument.
     The socketAddress object (an instance of SocketAddress)
     is supposed to respond to #portOrName and #address requests."

    ^ self bindTo:aSocketAddress reuseAddress:true
!

bindTo:portNrOrNameString address:addressString
    "Old interface: bind the socket to an address
     - returns true if ok, false otherwise.

     The interpretation of hostOrPathNameOrSocketAddrOrNil portNrOrName depends on the domain:
	Best use a SocketAddress
	For backward compatibility:
	    AF_INET domain can also use (4byte) byteArray like internet numbers,
	    AF_UNIX domain cab use pathname strings."

    ^ self
	bindTo:portNrOrNameString
	address:addressString
	reuseAddress:true
!

bindTo:portNrOrNameOrNil address:hostOrPathNameOrSocketAddrOrNil reuseAddress:reuse
    "Old interface: bind the socket to an address
     - returns true if ok, false otherwise.

     The interpretation of hostOrPathNameOrSocketAddrOrNil portNrOrName depends on the domain:
	Best use a SocketAddress
	For backward compatibility:
	    AF_INET domain can also use (4byte) byteArray like internet numbers,
	    AF_UNIX domain can use pathname strings.

     The reuse boolean argument controls if the SO_REUSEADDR socket option
     is to be set (to avoid the 'bind: address in use' error).
    "

    |socketAddress|

    handle isNil ifTrue:[
	^ self errorNotOpen
    ].

    hostOrPathNameOrSocketAddrOrNil isNil ifTrue:[
	socketAddress := self socketAddressClass anyHost.
    ] ifFalse:[
	(hostOrPathNameOrSocketAddrOrNil isSocketAddress) ifTrue:[
	    socketAddress := hostOrPathNameOrSocketAddrOrNil.
	] ifFalse:[
	    "backward compatibility: support for byteArray and string arg"
	    hostOrPathNameOrSocketAddrOrNil isString ifTrue:[
		socketAddress := self socketAddressClass hostName:hostOrPathNameOrSocketAddrOrNil.
	    ] ifFalse:[
		hostOrPathNameOrSocketAddrOrNil isByteCollection ifFalse:[
		    ^ self error:'bindTo: bad host (socketAddress) argument'
		].
		socketAddress := self socketAddressClass hostAddress:hostOrPathNameOrSocketAddrOrNil.
	    ].
	].
    ].
    portNrOrNameOrNil notNil ifTrue:[
	socketAddress port:portNrOrNameOrNil.
    ].

    ^ self bindTo:socketAddress reuseAddress:reuse.

    "
     (Socket domain:#'AF_INET' type:#stream)
	 bindTo:2144 address:nil; yourself
    "
!

bindTo:aSocketAddress reuseAddress:reuse
    "Bind the socket to aSocketAddress - returns true if ok, false otherwise.

     The reuse boolean argument controls if the SO_REUSEADDR socket option
     is to be set (to avoid the 'bind: address in use' error).

     You can bind to nil to bind to anyHost and assign a random port."

    |ok error socketAddress|

    handle isNil ifTrue:[
        ^ self errorNotOpen
    ].
    socketAddress := aSocketAddress.
    socketAddress isNil ifTrue:[
        "ok, get a all zero socket address, so it is for anyHost
         and the port will be assigned"
        socketAddress := self socketAddressClass new.
    ].
    domain == #'AF_INET6' ifTrue:[
        "accept also IPv4 connections on IPv6 sockets (this is off by default for windows"
        self setSocketOption:#'IPV6_V6ONLY' argument:false argument:nil.
    ].
    ok := false.

%{  /* STACK: 100000 */
#ifndef NO_SOCKET
    OBJ fp = __INST(handle);
    SOCKET sock;
    union sockaddr_u sa;
    int sockaddr_size;
    INT ret;
    int sockAddrOffs;

    if (fp == nil) {
        goto getOutOfHere;
    }

    if (! __isBytes(socketAddress)) {
        error = __mkSmallInteger(-1);
        goto getOutOfHere;
    }
    /* get the socket-address */
    if (__isNonNilObject(socketAddress)){
        int nIndex;
        OBJ cls = __qClass(socketAddress);

        sockAddrOffs = __OBJS2BYTES__(__intVal(__ClassInstPtr(cls)->c_ninstvars));
        nIndex = __qSize(socketAddress) - OHDR_SIZE;
        sockaddr_size = nIndex - sockAddrOffs;
        if (sockaddr_size > sizeof(sa)) {
            error=__mkSmallInteger(-2);
            goto getOutOfHere;
        }
        memcpy(&sa, __byteArrayVal(socketAddress) + sockAddrOffs, sockaddr_size);
    }

    sock = SOCKET_FROM_FILE_OBJECT(fp);

# ifdef SO_REUSEADDR
    if (reuse == true) {
        int on = 1;
        if (setsockopt(sock, SOL_SOCKET, SO_REUSEADDR, (char *) &on, sizeof (on)) < 0) {
            DBGPRINTF(("SOCKET: setsockopt - SO_REUSEADDR failed\n"));
        }
    }
# endif /* SO_REUSEADDR */

# ifdef BIND_BLOCKS
#  ifdef DO_WRAP_CALLS
    do {
        __threadErrno = 0;
        ret = STX_WSA_NOINT_CALL3("bind", bind, sock, &sa, sockaddr_size);
    } while ((ret < 0) && (__threadErrno == EINTR));
    if (ret < 0) {
        errno = __threadErrno;
    }
#  else
    __BEGIN_INTERRUPTABLE__
    do {
        ret = bind(sock, (struct sockaddr *)&sa, sockaddr_size);
    } while ((ret < 0) && (errno == EINTR));
    __END_INTERRUPTABLE__
#  endif
# else
    errno = 0;
    ret = bind(sock, (struct sockaddr *)&sa, sockaddr_size);
# endif
    if (ret < 0) {
# ifdef __win32__
        if (errno == 0) {
            errno = WSAGetLastError();
        }
# endif
        DBGPRINTF(("SOCKET: bind failed errno=%d\n", errno));
        error = __INST(lastErrorNumber) = __MKSMALLINT(errno);
        goto getOutOfHere;
    } else {
        ok = true;
    }
#endif /* NO_SOCKET */

getOutOfHere: ;
%}.
    ok ifFalse:[
        |errorHolder errorString|

        error isInteger ifTrue:[
            errorHolder := OperatingSystem errorHolderForNumber:error.
            errorString := errorHolder errorString.
        ] ifFalse:[
            errorString := error.
        ].
        OpenError newException
            errorString:('cannot bind socket to address: %1 (%2)'
                            bindWith:socketAddress
                            with:errorString);
            errorCode:error;
            osErrorHolder:errorHolder;
            parameter:self;
            raiseRequest.
        "maybe someone catches the error and binds to some other port..."
        ^ true.
    ].

    port := socketAddress port.
    port == 0 ifTrue:[
        "this is a bind to a random port, now we can get the real port"
        port := self getFullSocketAddress port.
    ].
    ^ true

    "
     (Socket domain:#'AF_INET' type:#stream)
        bindTo:(IPSocketAddress anyHost port:445) reuseAddress:false;
        yourself.

     (Socket domain:#'AF_INET' type:#stream)
        bindTo:139 reuseAddress:false;
        yourself.

     (Socket domain:#'AF_INET6' type:#stream)
        bindTo:nil reuseAddress:false;
        yourself.

     (Socket domain:#'AF_INET' type:#stream)
        bindTo:(IPSocketAddress localHost port:2122) reuseAddress:false;
        yourself.

     (Socket domain:#'AF_UNIX' type:#stream)
        bindTo:nil reuseAddress:false;
        yourself.
    "
!

listenFor:aNumber
    "start listening; return true if ok, false on error
     aNumber is the number of connect requests, that may be queued on the socket"

    handle isNil ifTrue:[
	^ self errorNotOpen
    ].
%{
#ifndef NO_SOCKET
    OBJ fp = __INST(handle);
    SOCKET sock;
    int ret;

    if (! __isSmallInteger(aNumber)) {
	DBGPRINTF(("SOCKET: invalid arg\n"));
	RETURN (false);
    }

    sock = SOCKET_FROM_FILE_OBJECT(fp);

#ifdef LISTEN_BLOCKS
# ifdef DO_WRAP_CALLS
    do {
	__threadErrno = 0;
	ret = STX_WSA_NOINT_CALL2("listen", listen, sock, __intVal(aNumber));
    } while ((ret < 0) && (__threadErrno == EINTR));
    if (ret < 0) {
	errno = __threadErrno;
    }
# else
    __BEGIN_INTERRUPTABLE__
    do {
	ret = listen(sock, __intVal(aNumber));
    } while ((ret < 0) && (errno == EINTR));
    __END_INTERRUPTABLE__
# endif
#else
    errno = 0;
    ret = listen(sock, __intVal(aNumber));
#endif

    if (ret < 0) {
# ifdef __win32__
	if (errno == 0) {
	    errno = WSAGetLastError();
	}
# endif
	DBGPRINTF(("SOCKET: listen call failed errno=%d\n", errno));
	__INST(lastErrorNumber) = __MKSMALLINT(errno);
	RETURN (false);
    }
#else
    RETURN (false);
#endif
%}.
    listening := aNumber.
    ^ true
! !

!Socket methodsFor:'closing'!

abortAndClose
    "immediately abort the connection:
        discard buffered data and close the stream"

    self linger:0.     
    self close.         
!

shutDown
    "shutDown (initiate a graceful close) 
     and close (free the filedescriptor) the socket.
     The close will return immediately and buffered data will be sent in the 
     background, unless you set linger"

    self shutdown:2.
    self close
!

shutDownInput
    "shutDown the input side of the socket.
     Any read on the socket will signal end-of-file from now on.
     The other side MAY be informed, that no more data will be accepted
     (e.g. setting the TCP-Windowsize to 0)"

    self shutdown:0.
!

shutDownOutput
    "shutDown the output side of the socket.
     Any write to the socket will signal end-of-file from now on.
     An orderly release (TCP FIN) will be initiated after the last buffered data
     has been sent, so the other side will get a end-of-file condition eventually.
     If you set linger > 0, the operation will wait until buffered data 
     has been delivered to the peer.
     Otherwise the operation returns immediately."

    self shutdown:1.
! !

!Socket methodsFor:'connecting'!

connectTo:aSocketAddress
    ^ self connectTo:aSocketAddress withTimeout:nil
!

connectTo:hostOrPathName port:portNrOrName
    <resource: #obsolete>
    "Backward compatibility connect; connect to port, portNrOrNameOrNil on host, hostOrPathNameOrSocketAddr.
     For backward compatibility, hostOrPathNameOrSocketAddr may be also a string or a byteArray,
     but it is recommended to pass SocketAddress instances.

     Return true if ok, false otherwise.
     The current process will block (but not the whole Smalltalk) until the connection is established.
     See also: #connectTo:port:withTimeout: for a somewhat nicer interface."

    ^ self connectTo:hostOrPathName port:portNrOrName withTimeout:nil
!

connectTo:hostOrPathNameOrSocketAddr port:portNrOrNameOrNil withTimeout:timeout
    <resource: #obsolete>
    "Backward compatibility connect; connect to port, portNrOrNameOrNil on host, hostOrPathNameOrSocketAddr.
     For backward compatibility, hostOrPathNameOrSocketAddr may be also a string or a byteArray,
     but it is recommended to pass SocketAddress instances.

     Return true if ok, false otherwise.
     The current process will block (but not the whole Smalltalk) until the connection is established,
     or timeout milliseconds have passed."

    |domainClass socketAddress|

    (hostOrPathNameOrSocketAddr isSocketAddress) ifTrue:[
        socketAddress := hostOrPathNameOrSocketAddr.
        portNrOrNameOrNil notNil ifTrue:[
            socketAddress port:portNrOrNameOrNil.
        ].
    ] ifFalse:[
        "backward compatibility: support for byteArray and string arg"
        domainClass := self class socketAddressClassForDomain:domain.
        domainClass isNil ifTrue:[
            ^ self error:'invalid (unsupported) domain'.
        ].

        hostOrPathNameOrSocketAddr isString ifTrue:[
            socketAddress := domainClass hostName:hostOrPathNameOrSocketAddr serviceName:portNrOrNameOrNil type:#SOCK_STREAM.
            peerName := hostOrPathNameOrSocketAddr.
        ] ifFalse:[
            hostOrPathNameOrSocketAddr isByteCollection ifFalse:[
                ^ self error:'connectTo: bad host (socketAddress) argument'
            ].
            socketAddress := domainClass hostAddress:hostOrPathNameOrSocketAddr port:portNrOrNameOrNil.
        ].
    ].

    ^ self connectTo:socketAddress withTimeout:timeout.

    "
       |sock|
       sock := Socket newTCP.
       sock connectTo:'localhost' port:21 withTimeout:1000.
       sock

       |sock|
       sock := Socket newTCP.
       sock connectTo:'localhost' port:9876 withTimeout:2000.
       sock
    "
!

connectTo:aSocketAddress withTimeout:timeout
    "Connect to a SocketAddress.

     Return true if ok, false otherwise.
     The current process will block (but not the whole Smalltalk) until the connection is established,
     or timeout milliseconds have passed."

    |isAsync err|

    handle isNil ifTrue:[
        ^ self errorNotOpen
    ].
    isAsync := false.

%{  /* STACK: 100000 */
#ifndef NO_SOCKET
//#define DUMP_ADDRESS 1
    OBJ fp = __INST(handle);
    union sockaddr_u sa;
    SOCKET sock;
    int a;
    INT ret;
    int oldFlags;
# ifdef __MINGW64__
    unsigned long on = 1;
# else
    int on = 1;
#endif
    int sockaddr_size;

    if (!__isNonNilObject(aSocketAddress) || !__isBytes(aSocketAddress)) {
        DBGPRINTF(("SOCKET: invalid socketAddress\n"));
        err = @symbol(argumentError);
        goto out;
    }

    {
        int sockAddrOffs = 0;
        int nIndex =__byteArraySize(aSocketAddress);
        OBJ cls = __qClass(aSocketAddress);

        //if (cls != @global(ByteArray))
        //    sockAddrOffs = __OBJS2BYTES__(__intVal(__ClassInstPtr(cls)->c_ninstvars));
        sockaddr_size = nIndex - sockAddrOffs;
        if (sockaddr_size > sizeof(sa)) {
            DBGPRINTF(("SOCKET: invalid (short) socketAddress\n"));
            err = @symbol(argumentError);
            goto out;
        }
        memcpy(&sa, __byteArrayVal(aSocketAddress) + sockAddrOffs, sockaddr_size);
    }

    sock = SOCKET_FROM_FILE_OBJECT(fp);

#ifdef __win32__
     ioctlsocket(sock, FIONBIO, &on);
#elif defined(O_NONBLOCK)
    /*
     * set to non-blocking and wait later
     */
    oldFlags = fcntl(sock, F_GETFL, 0);
    /* on SUNOS4.x, would use fcntl(osfd, F_SETFL, flags | FNDELAY); */
    fcntl(sock, F_SETFL, oldFlags | O_NONBLOCK);
# endif

    /*
     * connect
     */

// we do not use wrap calls any longer, because they have problems with aborting.
// we use nonblocking accept() instead.
# if 0 && defined(DO_WRAP_CALLS)
    // __setWrapCallDebugging(1,1);


    do {
        DBGFPRINTF((stderr, "SOCKET: (sock=%d) connect...\n", sock));
        ret = STX_WSA_NOINT_CALL3("connect", connect, sock, &sa, (INT)sockaddr_size);
        DBGFPRINTF((stderr, "SOCKET: connect(%d) -> %"_ld_" (%d)\n", sock, (INT)ret, __threadErrno));
    } while ((ret < 0) && (__threadErrno == EINTR));

    if (ret < 0) {
        int optLen = sizeof(errno);
        errno = __threadErrno;
#if 0
        if (getsockopt(sock, SOL_SOCKET, SO_ERROR, &errno, &optLen) == SOCKET_ERROR) {
            DBGFPRINTF((stderr, "SOCKET: getsockopt(SO_ERROR) failed: %d\n", WSAGetLastError()));
        }
#endif // 0
    }

    // __setWrapCallDebugging(1,0);
# else // !DO_WRAP_CALLS

#  if !defined(__win32__) && !defined(O_NONBLOCK)
    __BEGIN_INTERRUPTABLE__
#  endif
    do {
        ret = connect(sock, (struct sockaddr *)&sa, sockaddr_size);
    } while ((ret < 0)
#  ifdef __win32__
             && (errno = WSAGetLastError())
#  endif
             && ((errno == EINTR)
#  ifdef EAGAIN
                 || (errno == EAGAIN)
#  endif
                ));
#  if !defined(__win32__) && !defined(O_NONBLOCK)
    __END_INTERRUPTABLE__
#  endif
#endif

#if defined(__win32__) && !defined(EINPROGRESS)
# define EINPROGRESSS WSAEINPROGRESSS
# define EALREADY WSAEALREADY
#endif

    if (ret < 0) {
# if defined(EINPROGRESS) || defined(EALREADY)
        if (0
#  ifdef __win32__
            || (errno == WSAEWOULDBLOCK)
#  endif
#  ifdef EINPROGRESS
            || (errno == EINPROGRESS)
#  endif
#  ifdef EALREADY
            || (errno == EALREADY)
#  endif
        ) {
            /*
             * This was a nonblocking operation that will take some time.
             * Do a select on read to get informed when the operation is ready.
             */
            DBGFPRINTF((stderr, "SOCKET: isAsync is true\n"));
            isAsync = true;
        } else
# endif /* EINPROGRESS or EALREADY */
        {
            DBGFPRINTF((stderr, "SOCKET: connect failed ret=%"_ld_" errno=%d __threadErrno=%d\n",
                        (INT)ret, errno, __threadErrno ));
# ifdef DUMP_ADDRESS
            {
                unsigned char *cp = (unsigned char *)(&sa);
                int i;

                console_printf("address data:\n");
                for (i=0; i<sockaddr_size; i++) {
                    console_printf(" %02x\n", *cp++);
                }
            }
# endif
            err = __MKSMALLINT(errno);
        }
    }

# ifdef __win32__
    {
        int off = 0;
        ioctlsocket(sock, FIONBIO, &off);
    }
# elif defined(O_NONBLOCK) // Linux / Unix
    fcntl(sock, F_SETFL, oldFlags);
# endif

# else /* NO_SOCKET */
    err = @symbol(notSupported);
# endif /* NO_SOCKET */
out:;
%}.

    err notNil ifTrue:[
        err isSymbol ifTrue:[
            self primitiveFailed:err.
        ].
        lastErrorNumber := err.
        ^ false.
        "/ Once we will raise an exception instead of returning false (and have to change some code above):
"/        (OperatingSystem errorHolderForNumber:err) reportError.
    ].
    isAsync ifTrue:[
        (self writeExceptionWaitWithTimeoutMs:timeout) ifTrue:[
            "/ a timeout occurred
            "/ should I cancel the connect?
            lastErrorNumber := OperatingSystem errorNumberFor:#ETIMEDOUT.
            ^ false.
        ].
        err := self getSocketError.
        err ~~ 0 ifTrue:[
            lastErrorNumber := err.
            ^ false.
        ].
    ].


    peer := aSocketAddress.
    port isNil ifTrue:[
        "socket has not been explicitly bound,
         after connect it has been bound implicitly - fetch the port"
        port := self getFullSocketAddress port.
    ].
    ^ true

    "
       |sock|
       sock := Socket newTCP.
       sock connectTo:(IPSocketAddress localHost port:21) withTimeout:1000.
       sock

       |sock|
       sock := Socket newTCP.
       sock connectTo:(IPSocketAddress localHost port:9876) withTimeout:2000.
       sock
    "
! !

!Socket methodsFor:'datagram transmission'!

receiveBuffer:aDataBuffer start:startIndex for:nBytes
    "receive data
     Return the number of bytes received, or a negative number on error.
     On error, the unix error code is left in the lastErrorNumber
     instance variable.
     The thread blocks until data arrives - you may want to wait before
     receiving, using #readWait or #readWaitWithTimeout:."

    |nReceived error|

%{
#ifndef NO_SOCKET
    OBJ fp = __INST(handle);

    if (fp != nil) {
	SOCKET sock;
	INT objSize, offs;
	INT n;
	char *extPtr;
	unsigned char *buffer;
	unsigned char *allocatedBuffer = NULL;
	INT flags = 0;

	sock = SOCKET_FROM_FILE_OBJECT(fp);

	if (! setupBufferParameters(aDataBuffer, startIndex, &extPtr, &offs, &objSize)) goto bad;
	if (__isSmallInteger(nBytes)) {
	    if (__intVal(nBytes) < objSize) {
		objSize = __intVal(nBytes);
	    }
	}

# ifdef DO_WRAP_CALLS
	if (extPtr) {
	    buffer = extPtr + offs;
	} else {
	    allocatedBuffer = buffer = (char *)malloc(objSize);
	}

	do {
	    __threadErrno = 0;
	    n = (INT)STX_WSA_NOINT_CALL4("recv", recv, sock, buffer, objSize, flags);
	} while ((n < 0) && (__threadErrno == EINTR));
	if (n < 0) {
	    errno = __threadErrno;
	}

	if (allocatedBuffer) {
	    if (n > 0) {
		bcopy(allocatedBuffer, (char *)__InstPtr(aDataBuffer) + offs, n);
	    }
	    free(allocatedBuffer);
	}
# else
	__BEGIN_INTERRUPTABLE__
	do {
	    if (extPtr) {
		n = recv(sock, extPtr + offs, objSize, flags);
	    } else {
		n = recv(sock, (char *)__InstPtr(aDataBuffer) + offs, objSize, flags);
	    }
	} while ((n < 0) && (errno == EINTR));
	__END_INTERRUPTABLE__
# endif

	if (n < 0) {
	    error = __INST(lastErrorNumber) = __MKSMALLINT(errno);
	} else {
	    RETURN(__MKSMALLINT(n));
	}
    }
#endif
bad: ;
%}.
    error notNil ifTrue:[
	^ self readError:error.
    ].
    "
     arrive here if you try to receive into an invalid buffer (i.e. not ByteArray-like)
    "
    self primitiveFailed
!

receiveFrom:anAddressBuffer buffer:aDataBuffer
    "receive datagramm data - put address of originating host into
     anAddressBuffer, data into aBuffer.
     Both must be ByteArray-like. The addressBuffer must
     provide space for a valid address for my domain (i.e. for inet, a 4-byte byteArray).
     Return the number of bytes received, or a negative number on error.
     On error, the unix error code is left in the lastErrorNumber
     instance variable."

    ^ self receiveFrom:anAddressBuffer buffer:aDataBuffer start:1 for:(aDataBuffer size) flags:0
!

receiveFrom:anAddressBuffer buffer:aDataBuffer start:startIndex for:nBytes
    ^ self receiveFrom:anAddressBuffer buffer:aDataBuffer start:startIndex for:nBytes flags:0
!

receiveFrom:anAddressBuffer buffer:aDataBuffer start:startIndex for:nBytes flags:flags
    "receive datagramm data
     - put address of originating host into anAddressBuffer, data into aBuffer.
     For backward compatibility, the addressBuffer may be a non-SocketAddress;
     then, it must be a byteArray with appropriate size for the addressBytes.

     Return the number of bytes received, or a negative number on error.
     On error, the unix error code is left in the lastErrorNumber
     instance variable.
     The thread blocks until data arrives - you may want to wait before
     receiving, using #readWait or #readWaitWithTimeout:."

    |domainClass addr addrLen nReceived error|

    domainClass := self class socketAddressClassForDomain:domain.
    domainClass isNil ifTrue:[
        ^ self error:'invalid (unsupported) domain'.
    ].
    anAddressBuffer isSocketAddress ifTrue:[
        anAddressBuffer class == domainClass ifFalse:[
            ^ self error:'addressBuffer class mismatch (domain)'.
        ].
        addr := anAddressBuffer.
    ] ifFalse:[
        anAddressBuffer notNil ifTrue:[
            addr := domainClass new.
        ].
    ].

%{
#ifndef NO_SOCKET
    OBJ fp = __INST(handle);

    if (fp != nil) {
        SOCKET sock;
        size_t objSize;
        union sockaddr_u sa;
        socklen_t alen = 0;
        INT n, offs;
        int _flags = __longIntVal(flags);
        char *extPtr;
        unsigned char *allocatedBuffer = NULL, *buffer = NULL;

        sock = SOCKET_FROM_FILE_OBJECT(fp);

        if (! setupBufferParameters(aDataBuffer, startIndex, &extPtr, &offs, &objSize)) goto bad;
        if (__isSmallInteger(nBytes)) {
            if (__intVal(nBytes) < objSize) {
                objSize = __intVal(nBytes);
            }
        }
# ifdef DO_WRAP_CALLS
        if (extPtr) {
            buffer = extPtr + offs;
        } else {
            allocatedBuffer = buffer = (char *)malloc(objSize);
        }

        do {
            __threadErrno = 0;
            alen = sizeof(sa);
            n = (INT)STX_WSA_NOINT_CALL6("recvfrom", recvfrom, sock, buffer, objSize, _flags, (struct sockaddr *)&sa, &alen);
        } while ((n < 0) && (__threadErrno == EINTR));
        if (n < 0) {
            errno = __threadErrno;
        }

        if (allocatedBuffer) {
            if (n > 0) {
                memcpy((char *)__InstPtr(aDataBuffer) + offs, allocatedBuffer, n);
            }
            free(allocatedBuffer);
        }
# else
        __BEGIN_INTERRUPTABLE__
        do {
            alen = sizeof(sa);
            if (extPtr) {
                n = recvfrom(sock, extPtr + offs, objSize, _flags, (struct sockaddr *) &sa, &alen);
            } else {
                n = recvfrom(sock, (char *)__InstPtr(aDataBuffer) + offs, objSize, _flags, (struct sockaddr *) &sa, &alen);
            }
        } while ((n < 0) && (errno == EINTR));
        __END_INTERRUPTABLE__
# endif

        if (n >= 0) {
            if (__isNonNilObject(addr)) {
                char *addrPtr;
                OBJ oClass;
                int nInstVars, nInstBytes, objSize;

                oClass = __qClass(addr);
                if (! __isBytes(addr) )
                    goto bad;
                nInstVars = __intVal(__ClassInstPtr(oClass)->c_ninstvars);
                nInstBytes = OHDR_SIZE + (nInstVars * sizeof(OBJ));
                objSize = __qSize(addr) - nInstBytes;
                addrPtr = (char *)__InstPtr(addr) + nInstBytes;
                if (objSize < alen)
                    goto bad;

                /*
                 * extract the datagrams address
                 */
                memcpy(addrPtr, (char *)&sa, alen);
                addrLen = __MKSMALLINT(alen);
            }
        }
        if (n < 0) {
            error = __INST(lastErrorNumber) = __MKSMALLINT(errno);
        }
        nReceived = __MKSMALLINT(n);
    }
#endif
bad: ;
%}.
    error notNil ifTrue:[
        ^ self readError:error.
    ].

    nReceived notNil ifTrue:[
        addrLen notNil ifTrue:[
            (addr == anAddressBuffer) ifFalse:[
                self obsoleteFeatureWarning:'please use a socketAddress argument'.

                "can be a ByteArray for backward compatibility"
                anAddressBuffer replaceFrom:1 to:addrLen with:(addr hostAddress).
            ].
        ].
        ^ nReceived
    ].
    "
     arrive here if you try to receive into an invalid buffer
     (i.e. not ByteArray-like),
     or if the addressBuffer is nonNil AND not a SocketAddress/ByteArray
     or if the addressBuffer is nonNil AND too small.
    "
    self primitiveFailed
!

sendBuffer:aDataBuffer start:startIndex for:nBytes flags:flags
    "send data.
     Both must be ByteArray-like. The bytes in the addressBuffer must
     be a valid address for my domain (i.e. for inet, a 4-byte byteArray).
     Return the number of bytes transmitted, or a negative number on error.
     On error, the unix error code is left in the lastErrorNumber
     instance variable."

    |error|

%{
#ifndef NO_SOCKET
    OBJ fp = __INST(handle);

    if ((fp != nil)
     && __isSmallInteger(startIndex)
     && __isSmallInteger(nBytes)) {
	SOCKET sock;
	INT objSize, n, offs;
	char *extPtr;
	int _flags = __longIntVal(flags);
	unsigned long norder;
	unsigned char *buffer, *allocatedBuffer = NULL;

	sock = SOCKET_FROM_FILE_OBJECT(fp);

	if (! setupBufferParameters(aDataBuffer, startIndex, &extPtr, &offs, &objSize)) goto bad;
	if (__isSmallInteger(nBytes)) {
	    if (__intVal(nBytes) < objSize) {
		objSize = __intVal(nBytes);
	    }
	}

# ifdef DGRAM_DEBUG
	console_printf("sending %d bytes ...\n", nBytes);
# endif

#ifdef DO_WRAP_CALLS
	if (extPtr) {
	    buffer = extPtr + offs;
	} else {
	    allocatedBuffer = buffer = (char *)malloc(objSize);
	    bcopy((char *)__InstPtr(aDataBuffer) + offs, allocatedBuffer, objSize);
	}

	do {
	    __threadErrno = 0;
	    n = (INT)STX_WSA_NOINT_CALL4("send", send, sock, buffer, objSize, _flags);
	} while ((n < 0) && (__threadErrno == EINTR));
	if (n < 0) {
	    errno = __threadErrno;
	}

	if (allocatedBuffer) {
	    free(allocatedBuffer);
	}
#else
	__BEGIN_INTERRUPTABLE__
	do {
	    if (extPtr) {
		n = send(sock, extPtr + offs, objSize, _flags);
	    } else {
		n = send(sock, (char *)__InstPtr(aDataBuffer) + offs, objSize, _flags);
	    }
	} while ((n < 0) && (errno == EINTR));
	__END_INTERRUPTABLE__
#endif

	if (n < 0) {
	    error = __INST(lastErrorNumber) = __MKSMALLINT(errno);
	} else {
	    RETURN (__MKSMALLINT(n));
	}
    }
#endif
bad: ;
%}.
    error notNil ifTrue:[
	self writeError:error.
    ].

    "
     arrive here if you try to send from an invalid buffer (i.e. not ByteArray-like),
    "
    self primitiveFailed
!

sendTo:anAddressBuffer buffer:buffer
    "send datagramm data - fetch address of destination host from
     anAddressBuffer, data from aDataBuffer.
     Both must be ByteArray-like. The bytes in the addressBuffer must
     be a valid address for my domain (i.e. for inet, a 4-byte byteArray).
     Return the number of bytes transmitted, or a negative number on error.
     On error, the unix error code is left in the lastErrorNumber
     instance variable.
     Flags is currently ignored; it is there for ST-80 compatibility."

    ^ self sendTo:anAddressBuffer buffer:buffer start:1 for:buffer size flags:0
!

sendTo:anAddressBuffer buffer:buffer start:startIndex for:count
    "send datagramm data - fetch address of destination host from
     anAddressBuffer, data from aDataBuffer.
     Both must be ByteArray-like. The bytes in the addressBuffer must
     be a valid address for my domain (i.e. for inet, a 4-byte byteArray).
     Return the number of bytes transmitted, or a negative number on error.
     On error, the unix error code is left in the lastErrorNumber
     instance variable.
     Flags is currently ignored; it is there for ST-80 compatibility."

    ^ self sendTo:anAddressBuffer buffer:buffer start:startIndex for:count flags:0
!

sendTo:anAddressBuffer buffer:aDataBuffer start:startIndex for:nBytes flags:flags
    "send datagramm data - fetch address of destination host from
     anAddressBuffer, data from aDataBuffer starting at startIndex,
     sending count bytes.
     Both must be ByteArray-like. The bytes in the addressBuffer must
     be a valid address for my domain (i.e. for inet, a 4-byte byteArray).
     Return the number of bytes transmitted, or a negative number on error.
     On error, the unix error code is left in the lastErrorNumber
     instance variable."

    |domainClass addr error|

    anAddressBuffer isSocketAddress ifTrue:[
        addr := anAddressBuffer.
    ] ifFalse:[
        anAddressBuffer isByteArray ifFalse:[
            ^ self error:'bad socketAddress argument'
        ].
        domainClass := self class socketAddressClassForDomain:domain.
        domainClass isNil ifTrue:[
            ^ self error:'invalid (unsupported) domain'.
        ].
        addr := domainClass hostAddress:anAddressBuffer.
    ].
%{
#ifndef NO_SOCKET
    OBJ fp = __INST(handle);

    if ((fp != nil)
     && __isSmallInteger(startIndex)
     && __isSmallInteger(nBytes)) {
        SOCKET sock;
        INT objSize;
        struct sockaddr *sockaddr_ptr;
        union sockaddr_u sa;
        socklen_t sockaddr_size, alen = 0;
        INT sockAddrOffs;
        INT n, offs;
        char *extPtr;
        int _flags = __longIntVal(flags);
        unsigned long norder;
        unsigned char *buffer;
        unsigned char *allocatedBuffer = NULL;

        sock = SOCKET_FROM_FILE_OBJECT(fp);

        if (! __isBytes(addr)) {
            sockaddr_size = 0;
            sockaddr_ptr = (struct sockaddr *)0;
        } else {
            int nIndex;
            OBJ cls;

            sockAddrOffs = 0;
            if ((cls = __qClass(addr)) != @global(ByteArray))
                sockAddrOffs += __OBJS2BYTES__(__intVal(__ClassInstPtr(cls)->c_ninstvars));
            nIndex = __qSize(addr) - OHDR_SIZE;
            sockaddr_size = nIndex - sockAddrOffs;
            if (sockaddr_size > sizeof(sa)) {
                console_fprintf(stderr, "Socket [warning]: bad socketAddr\n");
                goto bad;
            }
            memcpy(&sa, (__byteArrayVal(addr) + sockAddrOffs), sockaddr_size);
            sockaddr_ptr = (struct sockaddr *)(&sa);
        }

        if (! setupBufferParameters(aDataBuffer, startIndex, &extPtr, &offs, &objSize)) goto bad;
        if (__isSmallInteger(nBytes)) {
            if (__intVal(nBytes) < objSize) {
                objSize = __intVal(nBytes);
            }
        }

#ifdef DO_WRAP_CALLS
        if (extPtr) {
            buffer = extPtr + offs;
        } else {
            allocatedBuffer = buffer = (char *)malloc(objSize);
            bcopy((char *)__InstPtr(aDataBuffer) + offs, allocatedBuffer, objSize);
        }

        do {
            __threadErrno = 0;
            n = (INT)STX_WSA_NOINT_CALL6("sendto", sendto, sock, buffer, objSize, _flags, sockaddr_ptr, sockaddr_size);
        } while ((n < 0) && (__threadErrno == EINTR));
        if (n < 0) {
            errno = __threadErrno;
        }

        if (allocatedBuffer) {
            free(allocatedBuffer);
        }
#else
        __BEGIN_INTERRUPTABLE__
        do {
            if (extPtr) {
                n = sendto(sock, extPtr + offs, objSize, _flags, sockaddr_ptr, sockaddr_size);
            } else {
                n = sendto(sock, (char *)__InstPtr(aDataBuffer) + offs, objSize, _flags, sockaddr_ptr, sockaddr_size);
            }
        } while ((n < 0) && (errno == EINTR));
        __END_INTERRUPTABLE__
#endif

        if (n < 0) {
            error = __INST(lastErrorNumber) = __MKSMALLINT(errno);
        } else {
            RETURN (__MKSMALLINT(n));
        }
    }
#endif
bad: ;
%}.
    error notNil ifTrue:[
        self writeError:error.
    ].

    "
     arrive here if you try to send from an invalid buffer
     (i.e. not ByteArray-like),
     or if the addressBuffer is nonNil AND not a ByteArray/String
     or if the addressBuffer is nonNil AND too small.
    "
    self primitiveFailed
! !

!Socket methodsFor:'finalization'!

finalize
    self linger:0.      "/ do an abortive release - discard buffered data
    self closeFile.     "/ does not wait due to abortive release.
! !

!Socket methodsFor:'initialization'!

initialize
    super initialize.
    "/ transparent
    eolMode := nil.
! !

!Socket methodsFor:'low level'!

getSocketAdress
    "BAD SPELLING, of #getSocketAddress, kept for compatibility with swazoo"

    <resource: #obsolete>

    ^ self getSocketAddress
!

getSocketError
    "get the SO_ERROR form the socket, which indicates the
     result of an asynchronous operation"

%{
#ifndef NO_SOCKET
    OBJ fp;
    int err;

    fp = __INST(handle);
    if (fp == nil) {
	err = EBADF;
    } else {
	unsigned int sz;
	SOCKET sock;

	sock = SOCKET_FROM_FILE_OBJECT(fp);
	sz = sizeof(err);
	if (getsockopt(sock, SOL_SOCKET, SO_ERROR, (char *)(&err), &sz) < 0) {
# ifdef __win32__
	    errno = WSAGetLastError();
# endif
	    err = errno;
	}
    }

    RETURN(__MKSMALLINT(err));
#endif
%}
!

listenWithBacklog:aNumber
    <resource: #obsolete>
    "same as listenFor: - backward compatibility with old ST/X"
    self obsoleteMethodWarning.
    ^ self listenFor:aNumber
!

primAcceptOn:aServerSocket blocking:blocking
    "accept a connection on a server port (created with:'Socket>>newTCP:')
     usage is: (Socket basicNew acceptOn:(Socket newTCP:9999)).
     Return the true if ok; false if not.
     If blocking is true, the accept() syscall (and the whole smalltalk image)
     will block, until a connection is accepted.
     If blocking is false, this call will return immediately, if there is no connection pending."

    |serverSocketHandle addr domainClass newHandle|

    handle notNil ifTrue:[
        ^ self errorAlreadyOpen.
    ].
    serverSocketHandle := aServerSocket fileHandle.
    serverSocketHandle isNil ifTrue:[
        "socket is not open"
        ^ false
    ].

    domain := aServerSocket domain.
    socketType := aServerSocket type.
    handleType := aServerSocket handleType.
    "unix domain sockets do not return a valid peer name on accept"
    domainClass := self class socketAddressClassForDomain:domain.
    domainClass isNil ifTrue:[
        ^ self error:'invalid (unsupported) domain'.
    ].
    addr := domainClass new.
    newHandle := OperatingSystem socketAccessor new.

%{  /* STACK: 100000 */
#ifndef NO_SOCKET
    FILE *fp;
    int flags;
    SOCKET serverSocket, newSock;
    int _fd;
    union sockaddr_u sa;
    unsigned int alen;

# ifdef __win32__
    serverSocket = SOCKET_FROM_FILE_OBJECT(serverSocketHandle);
# else
    serverSocket = __intVal(serverSocketHandle);
# endif

# if defined(O_NONBLOCK) && defined(SET_NDELAY)
    if (blocking == false) {
        flags = fcntl(serverSocket, F_GETFL);
        fcntl(serverSocket, F_SETFL, flags | O_NONBLOCK);
    }
# endif

# ifdef DO_WRAP_CALLS
    do {
        __threadErrno = 0;
        alen = sizeof(sa);
        newSock = (SOCKET)STX_WSA_CALL3("accept", accept, serverSocket, &sa, &alen);
    } while ((newSock < 0) && (__threadErrno == EINTR));
    if (newSock < 0) {
        errno = __threadErrno;
    }
# else
    __BEGIN_INTERRUPTABLE__
    do {
        alen = sizeof(sa);
        newSock = accept(serverSocket, (struct sockaddr *) &sa, &alen);
    } while ((newSock < 0) && (errno == EINTR));
    __END_INTERRUPTABLE__
# endif
    DBGFPRINTF((stderr, "SOCKET: accept newSock=%d\n", newSock));

# if defined(O_NDELAY) && defined(SET_NDELAY)
    if (blocking == false) {
        fcntl(serverSocket, F_SETFL, flags);
    }
# endif

    if (newSock == -1) {
        DBGPRINTF(("SOCKET: accept call failed errno=%d\n", errno));
        __INST(lastErrorNumber) = __MKSMALLINT(errno);
        RETURN (false);
    }

    if (__isNonNilObject(addr)) {
        OBJ oClass = __qClass(addr);
        int nInstVars, nInstBytes, objSize;
        char *addrP;

        if (! __isBytes(addr) ) {
            DBGPRINTF(("SOCKET: bad addr\n"));
            closesocket(newSock);
            RETURN (false);
        }

        nInstVars = __intVal(__ClassInstPtr(oClass)->c_ninstvars);
        nInstBytes = OHDR_SIZE + (nInstVars * sizeof(OBJ));
        objSize = __qSize(addr) - nInstBytes;
        addrP = (char *)__InstPtr(addr) + nInstBytes;
        if (objSize < alen) {
            DBGPRINTF(("SOCKET: bad addr\n"));
            closesocket(newSock);
            RETURN (false);
        }

        /*
         * extract the partners address
         */
        memcpy(addrP, (char *)&sa, alen);
    }

    /*
     * make it a FILE *
     */
# ifdef __win32__
#  if 0 && (defined( __BORLANDC__ ) || defined( __MINGW__ ))
    __stxWrapApiEnterCritical();
    _fd = _open_osfhandle((long)newSock, 0);
    __stxWrapApiLeaveCritical();
    DBGPRINTF(("SOCKET: sock=%d fd=%d\n", newSock, _fd));
#  else
    _fd = (int)newSock;
#  endif
# else // ! __win32__
    fp = fdopen(newSock, "r+");
    if (! fp) {
        DBGPRINTF(("SOCKET: fdopen call failed\n"));
        __INST(lastErrorNumber) = __MKSMALLINT(errno);
        closesocket(newSock);
        DBGFPRINTF((stderr, "SOCKET: close (fdopen failed) (%d)\n", newSock));
        RETURN (false);
    }
# endif // ! __win32__

    if ((@global(FileOpenTrace) == true) || __debugging__) {
# ifdef __win32__
        console_fprintf(stderr, "fdopen [Socket accept] -> fd: %d (H: %"_lx_")\n", _fd, (INT)newSock);
# else
        console_fprintf(stderr, "fdopen [Socket accept] -> %"_lx_" (fd: %d)\n", (INT)fp, newSock);
# endif
    }

# ifdef __win32__
    __externalAddressVal(newHandle) = _fd;
    __INST(handleType) = @symbol(socketHandle);
# else
    __externalAddressVal(newHandle) = fp;
    __INST(handleType) = @symbol(socketFilePointer);
# endif
#endif /* not NO_SOCKET */
%}.

    handle := newHandle.
    buffered := false.
    mode := #readwrite.
    binary := false.
    self registerForFinalization.
    peer := addr.
    port := aServerSocket port.

    ^ true
!

setSocketOption:option argument:arg1 argument:arg2
    |ok error|

    handle isNil ifTrue:[
	^ self errorNotOpen
    ].

%{  /* STACK: 32000 */
#ifndef NO_SOCKET
    OBJ fp = __INST(handle);

    if (fp != nil) {
	SOCKET sock = SOCKET_FROM_FILE_OBJECT(fp);
	int opt = -1;
	int level = -1;
	int usize = -1;
	int ret;
	union u {
	    BOOL        u_bool;
	    int         u_int;
	    struct linger  u_linger;
# ifdef IP_ADD_MEMBERSHIP
	    struct ip_mreq u_ip_mreq;
# endif
# if defined(SO_RCVTIMEO) || defined(SO_SNDTIMEO)
	    struct timeval u_tv;
# endif


	} u;

# ifdef IP_ADD_MEMBERSHIP
	if (option == @symbol(IP_DROP_MEMBERSHIP)) {
	    opt = IP_DROP_MEMBERSHIP;
	    goto dropOrAdd;
	}
	if (option == @symbol(IP_ADD_MEMBERSHIP)) {
	    /* add membership to a multicast group */
	    opt = IP_ADD_MEMBERSHIP;
dropOrAdd:
	    level = IPPROTO_IP;
	    usize = sizeof(u.u_ip_mreq);
	    if (__isByteArrayLike(arg1) && __isByteArrayLike(arg2)) {
		memcpy(&u.u_ip_mreq.imr_multiaddr, __byteArrayVal(arg1), sizeof(u.u_ip_mreq.imr_multiaddr));
		memcpy(&u.u_ip_mreq.imr_interface, __byteArrayVal(arg2), sizeof(u.u_ip_mreq.imr_interface));
	    }
	    else
		goto argError;
	}
# endif /* IP_ADD_MEMBERSHIP */

# ifdef SO_BROADCAST
	if (option == @symbol(SO_BROADCAST)) {
	    /* Enables transmission and receipt of broadcast messages on the socket. */
	    opt = SO_BROADCAST;
	    level = SOL_SOCKET;
	    usize = sizeof(u.u_bool);
	    if (arg1 == true) u.u_bool = TRUE;
	    else if (arg1 == false) u.u_bool = FALSE;
	    else goto argError;
	}
# endif /* SO_BROADCAST */

# ifdef SO_CONDITIONAL
#  if 0
	if (option == @symbol(SO_CONDITIONAL)) {
	    /* Enables sockets to delay the acknowledgment of a connection until after the WSAAccept condition function is called. */
	    opt = SO_CONDITIONAL;
	    level = SOL_SOCKET;
	    usize = sizeof(u.u_bool);
	    if (arg1 == true) u.u_bool = TRUE;
	    else if (arg1 == false) u.u_bool = FALSE;
	    else goto argError;
	}
#  endif
# endif /* SO_CONDITIONAL */

# ifdef SO_DEBUG
	if (option == @symbol(SO_DEBUG)) {
	    /* Records debugging information. */
	    opt = SO_DEBUG;
	    level = SOL_SOCKET;
	    usize = sizeof(u.u_bool);
	    if (arg1 == true) u.u_bool = TRUE;
	    else if (arg1 == false) u.u_bool = FALSE;
	    else goto argError;
	}
# endif /* SO_DEBUG */

# ifdef SO_DONTLINGER
	if (option == @symbol(SO_DONTLINGER)) {
	    /* Does not block close waiting for unsent data to be sent.
	       Setting this option is equivalent to setting SO_LINGER with l_onoff set to zero. */
	    opt = SO_DONTLINGER;
	    level = SOL_SOCKET;
	    usize = sizeof(u.u_bool);
	    if (arg1 == true) u.u_bool = TRUE;
	    else if (arg1 == false) u.u_bool = FALSE;
	    else goto argError;
	}
# endif /* SO_DONTLINGER */

# ifdef SO_DONTROUTE
	if (option == @symbol(SO_DONTROUTE)) {
	    /* Does not route: sends directly to interface.
	       Succeeds but is ignored on AF_INET sockets;
	       fails on AF_INET6 sockets with WSAENOPROTOOPT.
	       Not supported on ATM sockets (results in an error). */
	    opt = SO_DONTROUTE;
	    level = SOL_SOCKET;
	    usize = sizeof(u.u_bool);
	    if (arg1 == true) u.u_bool = TRUE;
	    else if (arg1 == false) u.u_bool = FALSE;
	    else goto argError;
	}
# endif /* SO_DONTROUTE */

#if defined(IPPROTO_TCP) && defined(TCP_NODELAY)
	if (option == @symbol(TCP_NODELAY)) {
	    /* enable/disable TCP_NODELAY (i.e. disable/enable the Nagle algorithm) */
	    opt = TCP_NODELAY;
	    level = IPPROTO_TCP;
	    usize = sizeof(u.u_bool);
	    if (arg1 == true) u.u_bool = TRUE;
	    else if (arg1 == false) u.u_bool = FALSE;
	    else goto argError;
	}
# endif /* TCP_NODELAY */

# ifdef SO_KEEPALIVE
	if (option == @symbol(SO_KEEPALIVE)) {
	    /* Sends keep-alives. Not supported on ATM sockets (results in an error). */
	    opt = SO_KEEPALIVE;
	    level = SOL_SOCKET;
	    usize = sizeof(u.u_bool);
	    if (arg1 == true) u.u_bool = TRUE;
	    else if (arg1 == false) u.u_bool = FALSE;
	    else goto argError;
	}
# endif /* SO_KEEPALIVE */

# ifdef SO_LINGER
	if (option == @symbol(SO_LINGER)) {
	    /* Lingers on close if unsent data is present. */
	    opt = SO_LINGER;
	    level = SOL_SOCKET;
	    usize = sizeof(u.u_linger);
	    if (arg1 == true) u.u_linger.l_onoff = TRUE;
	    else if (arg1 == false) u.u_linger.l_onoff = FALSE;
	    else goto argError;
	    if (arg2 == nil) u.u_linger.l_linger = 0;
	    else if (__isSmallInteger(arg2))u.u_linger.l_linger = __intVal(arg2);
	    else goto argError;
	    DBGPRINTF(("SOCKET: SO_LINGER %d %d\n", u.u_linger.l_onoff, u.u_linger.l_linger));
	}
# endif /* SO_LINGER */

# ifdef SO_OOBINLINE
	if (option == @symbol(SO_OOBINLINE)) {
	    /* Receives OOB data in the normal data stream. */
	    opt = SO_OOBINLINE;
	    level = SOL_SOCKET;
	    usize = sizeof(u.u_bool);
	    if (arg1 == true) u.u_bool = TRUE;
	    else if (arg1 == false) u.u_bool = FALSE;
	    else goto argError;
	}
# endif /* SO_OOBINLINE */

# ifdef SO_RCVBUF
	if (option == @symbol(SO_RCVBUF)) {
	    /* Specifies the total per-socket buffer space reserved for receives.
	       This is unrelated to SO_MAX_MSG_SIZE or the size of a TCP window. */
	    opt = SO_RCVBUF;
	    level = SOL_SOCKET;
	    usize = sizeof(u.u_int);
	    if (__isSmallInteger(arg1))u.u_int = __intVal(arg1);
	    else goto argError;
	}
# endif /* SO_RCVBUF */

# ifdef SO_SNDBUF
	if (option == @symbol(SO_SNDBUF)) {
	    /* Specifies the total per-socket buffer space reserved for sends.
	       This is unrelated to SO_MAX_MSG_SIZE or the size of a TCP window. */
	    opt = SO_SNDBUF;
	    level = SOL_SOCKET;
	    usize = sizeof(u.u_int);
	    if (__isSmallInteger(arg1))u.u_int = __intVal(arg1);
	    else goto argError;
	}
# endif /* SO_SNDBUF */

# ifdef SO_REUSEADDR
	if (option == @symbol(SO_REUSEADDR)) {
	    /* Allows the socket to be bound to an address that is already in use.  */
	    opt = SO_REUSEADDR;
	    level = SOL_SOCKET;
	    usize = sizeof(u.u_bool);
	    if (arg1 == true) u.u_bool = TRUE;
	    else if (arg1 == false) u.u_bool = FALSE;
	    else goto argError;
	}
# endif /* SO_OOBINLINE */

# ifdef SO_EXCLUSIVEADDRUSE
	if (option == @symbol(SO_EXCLUSIVEADDRUSE)) {
	    /* Enables a socket to be bound for exclusive access.
	       Does not require administrative privilege.  */
	    opt = SO_EXCLUSIVEADDRUSE;
	    level = SOL_SOCKET;
	    usize = sizeof(u.u_bool);
	    if (arg1 == true) u.u_bool = TRUE;
	    else if (arg1 == false) u.u_bool = FALSE;
	    else goto argError;
	}
# endif /* SO_OOBINLINE */

# ifdef SO_RCVTIMEO
	if ((option == @symbol(SO_RCVTIMEO))
	 && __isSmallInteger(arg1)
	 && __isSmallInteger(arg2)) {
	    opt = SO_RCVTIMEO;
	    level = SOL_SOCKET;
	    u.u_tv.tv_sec = __intVal(arg1);
	    u.u_tv.tv_usec = __intVal(arg2);
	    usize = sizeof(u.u_tv);
	}
# endif /* SO_RCVTIMEO */

# ifdef SO_SNDTIMEO
	if ((option == @symbol(SO_SNDTIMEO))
	 && __isSmallInteger(arg1)
	 && __isSmallInteger(arg2)) {
	    opt = SO_SNDTIMEO;
	    level = SOL_SOCKET;
	    u.u_tv.tv_sec = __intVal(arg1);
	    u.u_tv.tv_usec = __intVal(arg2);
	    usize = sizeof(u.u_tv);
	}
# endif /* SO_SNDTIMEO */

# if !defined(IPV6_V6ONLY) && defined(__win32__)
#  define IPPROTO_IPV6 41
#  define IPV6_V6ONLY 27
# endif

# if defined(IPV6_V6ONLY)
	if (option == @symbol(IPV6_V6ONLY)) {
	    opt = IPV6_V6ONLY;
	    level = IPPROTO_IPV6;
	    usize = sizeof(u.u_bool);
	    if (arg1 == true) u.u_bool = TRUE;
	    else if (arg1 == false) u.u_bool = FALSE;
	    else goto argError;
#  ifdef __win32__
	    console_fprintf(stderr, "%d %d %d %d\n", level, opt, usize, u.u_int);
#  endif
	}
# endif /* IPV6_V6ONLY */

	if (usize == -1) goto argError;

	ok = (setsockopt(sock, level, opt, (char *)&u, usize) >= 0) ? true : false;
	if (ok == false) {
# ifdef __win32__
	    error = __mkSmallInteger(WSAGetLastError());
# else
	    error = __mkSmallInteger(errno);
# endif
	}

    }
argError: ;
#endif /* NO_SOCKET */
%}.
    ok isNil ifTrue:[
	self primitiveFailed
    ].
    ok ifFalse:[
	'++++ Info: Socket>>#setSocketOption:... failed. error: ' infoPrint. error infoPrintCR.
    ].
!

shutdown:howNum
    "shutDown the socket - inform it that no more I/O will be performed.
	 0 - read side   (no further reads)
	     the tcp receive window is closed, so the peer cannot send more data.
	 1 - write side  (no further writes)
	     first, all queued data will be delivered to the peer.
	     Then, an orderly release (TCP FIN) is sent to signal the peer,
	     that we will not send more data.
	 2 - both read side and write side."

%{
#ifndef NO_SOCKET
    OBJ __handle = __INST(handle);

    if ((__handle != nil) && __isSmallInteger(howNum)) {
	SOCKET sock = SOCKET_FROM_FILE_OBJECT(__handle);
	INT how = __intVal(howNum);
	INT ret;

# ifdef DO_WRAP_CALLS
	do {
	    __threadErrno = 0;
	    DBGFPRINTF((stderr, "SOCKET: shutDown...\n"));
	    ret = (INT)STX_WSA_NOINT_CALL2("shutdown", shutdown, sock, how);
	    DBGFPRINTF((stderr, "SOCKET: shutDown -> %d (%d)\n", ret, __threadErrno));
	} while ((ret < 0) && (__threadErrno == EINTR));
# else
	__BEGIN_INTERRUPTABLE__
	shutdown(sock, how);
	__END_INTERRUPTABLE__
# endif
    }
#endif
%}.
! !

!Socket methodsFor:'printing & storing'!

printOn:aStream
    aStream nextPutAll:self className; nextPutAll:'('.
    domain printOn:aStream.
    aStream nextPutAll:' protocol='.
    protocol printOn:aStream.
    aStream nextPutAll:' port='.
    self port printOn:aStream.
    aStream nextPutAll:' peer='.
    peer printOn:aStream.
    aStream nextPut:$).
! !

!Socket methodsFor:'queries'!

domain
    "return the sockets addressing domain (i.e. #AF_INET, #AF_INET6, #AF_UNIX, ...)"

    ^ domain
!

getFullPeerAddress
    "implemented for swazoo project (primitive code can't be loaded as extension)
     Answer my own address (I am bound to this address).
     Note that this address may change after a connect or accept."

    |error domainClass addr|

    handle isNil ifTrue:[
	^ self errorNotOpen
    ].

    domainClass := self class socketAddressClassForDomain:domain.
    domainClass isNil ifTrue:[
	^ self error:'invalid (unsupported) domain'.
    ].
    addr := domainClass new.

%{
#ifndef NO_SOCKET
    OBJ fp = __INST(handle);
    SOCKET sock;
    int ret;
    union sockaddr_u sa;
    unsigned int alen = sizeof(sa);
    char *addrP;
    int addrObjSize, nAddrInstBytes;
    OBJ addrClass;
    int nAddrInstVars;

    if (!__isNonNilObject(addr) || !__isBytes(addr)) {
	DBGPRINTF(("SOCKET: bad addr\n"));
	error = @symbol(badArgument);
	goto err;
    }

    addrClass = __qClass(addr);
    nAddrInstVars = __intVal(__ClassInstPtr(addrClass)->c_ninstvars);
    nAddrInstBytes = OHDR_SIZE + (nAddrInstVars * sizeof(OBJ));
    addrObjSize = __qSize(addr) - nAddrInstBytes;

    sock = SOCKET_FROM_FILE_OBJECT(fp);
    ret = getpeername(sock, (struct sockaddr *)&sa, &alen);
    if (ret < 0) {
# ifdef __win32__
	errno = WSAGetLastError();
# endif
	DBGPRINTF(("SOCKET: getsocketname failed ret=%d errno=%d\n", ret, errno));
	error = __MKSMALLINT(errno);
	goto err;
    }

    if (addrObjSize < alen) {
	DBGPRINTF(("SOCKET: bad addr\n"));
	error = @symbol(badArgument);
	goto err;
    }

    addrP = (char *)__InstPtr(addr) + nAddrInstBytes;
    memcpy(addrP, (char *)&sa, alen);

err:;
#else /* NO_SOCKET */
    error = @symbol(notImplemented);
#endif /* NO_SOCKET */
%}.
    error notNil ifTrue:[
	^ self errorReporter reportOn:error
    ].
    ^ addr
!

getFullSocketAddress
    "implemented for swazoo project (primitive code can't be loaded as extension)
     Answer my own address (I am bound to this address).
     Note that this address may change after a connect or accept."

    |error domainClass addr|

    handle isNil ifTrue:[
	^ self errorNotOpen
    ].

    domainClass := self class socketAddressClassForDomain:domain.
    domainClass isNil ifTrue:[
	^ self error:'invalid (unsupported) domain'.
    ].
    addr := domainClass new.

%{
#ifndef NO_SOCKET
    OBJ fp = __INST(handle);
    SOCKET sock;
    int ret;
    union sockaddr_u sa;
    unsigned int alen = sizeof(sa);
    char *addrP;
    int addrObjSize, nAddrInstBytes;

    if (!__isNonNilObject(addr) || !__isBytes(addr)) {
	DBGPRINTF(("SOCKET: bad addr\n"));
	error = @symbol(badArgument);
	goto err;
    }

    {
	OBJ addrClass;
	int nAddrInstVars;

	addrClass = __qClass(addr);
	nAddrInstVars = __intVal(__ClassInstPtr(addrClass)->c_ninstvars);
	nAddrInstBytes = OHDR_SIZE + (nAddrInstVars * sizeof(OBJ));
	addrObjSize = __qSize(addr) - nAddrInstBytes;
    }

    sock = SOCKET_FROM_FILE_OBJECT(fp);
    ret = getsockname(sock, (struct sockaddr *)&sa, &alen);
    if (ret < 0) {
# ifdef __win32__
	errno = WSAGetLastError();
# endif
	DBGPRINTF(("SOCKET: getsocketname failed ret=%d errno=%d\n", ret, errno));
	error = __MKSMALLINT(errno);
	goto err;
    }

    if (addrObjSize < alen) {
	DBGPRINTF(("SOCKET: bad addr\n"));
	error = @symbol(badArgument);
	goto err;
    }

    addrP = (char *)__InstPtr(addr) + nAddrInstBytes;
    memcpy(addrP, (char *)&sa, alen);

err:;
#else /* NO_SOCKET */
    error = @symbol(notImplemented);
#endif /* NO_SOCKET */
%}.
    error notNil ifTrue:[
	^ self errorReporter reportOn:error
    ].
    ^ addr
!

getName
    "return the name; here, we return the ports name"

    ^ self port printString
!

getPeer
    "ST-80 compatibility: return an IPSocketAddress instance representing
     my hostname/port combination.
     If you are interested in the hostname, use getPeerName directly."

    ^ peer
!

getPeerName
    "return the peer name; that's the hostname (or dotted name) of the
     partners host after an accept."

    peerName isNil ifTrue:[
        peerName := self class peerNameFromDomain:domain peer:peer.
    ].
    ^ peerName
!

getSocketAddress
    "implemented for swazoo project primitive code cant load as extension
     answer my own address (I am bound to this address).
     Note that this address may change after connect or accept."

    ^ self getFullSocketAddress hostAddress
!

isActive
    "return true, if the receiver has a connection"

    ^ handle notNil
!

isConnected
    "return true, if the receiver has a connection"

    ^ self isActive
	and:[peer notNil]
!

port
    "return the port number (or name for unix-sockets) to which the socket is bound
     - so this is the local port."

"/    port isNil ifTrue:[
"/        port := self getFullSocketAddress port.
"/    ].

    ^ port
!

socketAddressClass
    "get the matching SocketAddress class for this socket"

    |domainClass|

    domainClass := self class socketAddressClassForDomain:domain.
    domainClass isNil ifTrue:[
        ^ self error:'invalid (unsupported) domain'.
    ].
    ^ domainClass.
!

type
    "return the sockets connection type (i.e. #datagram, #stream etc)"

    ^ socketType
! !

!Socket methodsFor:'socket setup'!

domain:domainArg type:typeArg
    "set up socket with domain and type.
     This is a low level entry; no binding, listening or connect
     is done. Both arguments must be symbols from one of
      #AF_INET, #AF_INET6, #AF_UNIX ... and #stream, #datagram, #raw resp."

    ^ self domain:domainArg type:typeArg protocol:nil
!

domain:domainArg type:typeArg protocol:protocolNumber
    "set up socket with domain, type and protocol number.
     This is a low level entry; no binding, listening or connect
     is done. Both arguments must be symbols from one of
     #AF_INET, #AF_INET6, #AF_UNIX ... and #stream, #datagram, #raw resp."

    |domainName domainCode typeCode error newHandle|

    handle notNil ifTrue:[
        ^ self errorAlreadyOpen
    ].
    domainName := SocketAddress domainCodeFromName:domainArg.
    domainCode := OperatingSystem domainCodeOf:domainName.
    typeCode := OperatingSystem socketTypeCodeOf:typeArg.
    newHandle := OperatingSystem socketAccessor new.
%{
#ifndef NO_SOCKET
    FILE *fp;
    int dom, typ, proto = 0;
    int on = 1;
    SOCKET sock;
    int _fd;

# ifdef __win32__
#  ifndef WSA_FLAG_NO_HANDLE_INHERIT
#   define WSA_FLAG_NO_HANDLE_INHERIT 0x80
#  endif
    static int noInheritFlag = WSA_FLAG_NO_HANDLE_INHERIT;
# endif

    if (! __isSmallInteger(domainCode)) {
        error = @symbol(badArgument1);
        goto out;
    }
    if (! __isSmallInteger(typeCode)) {
        error = @symbol(badArgument2);
        goto out;
    }
    if (protocolNumber != nil) {
        if (!__isSmallInteger(protocolNumber)) {
            error = @symbol(badArgument3);
            goto out;
        }
        proto = __intVal(protocolNumber);
    }

    /*
     * get address and protocol-family
     */
    dom = __intVal(domainCode);
    typ = __intVal(typeCode);

# ifdef __win32__
    sock = WSASocket(dom, typ, proto, 0, 0, noInheritFlag);
    if (sock == INVALID_SOCKET && noInheritFlag) {
        // tried to open socket with WSA_FLAG_NO_HANDLE_INHERIT
        // This fails on older windows versions, e.g. Windows XP
        sock = WSASocket(dom, typ, proto, 0, 0, 0);
        if (sock != INVALID_SOCKET) {
            // no error without WSA_FLAG_NO_HANDLE_INHERIT,
            // never use this flag again!
            noInheritFlag = 0;
        }
    }
    if (sock == INVALID_SOCKET) {
        errno = WSAGetLastError();

# else  // !__win32__

    sock = socket(dom, typ, proto);
# if defined(EPROTONOSUPPORT) /* for SGI */
    if ((sock < 0) && (proto != 0) && (errno == EPROTONOSUPPORT)) {
        DBGPRINTF(("SOCKET: retry with UNSPEC protocol\n"));
        proto = 0;
        sock = socket(dom, typ, 0);
    }
# endif
    if (sock < 0) {
# endif // !__win32__

        DBGPRINTF(("SOCKET: socket(dom=%d typ=%d proto=%d) call failed errno=%d\n", dom, typ, proto, errno));
        error = __MKSMALLINT(errno);
    } else {
# if defined(SET_LINGER_WHEN_CREATING_SOCKET) && defined(SO_LINGER)
        {
            struct linger l;

            l.l_onoff = 1;
            l.l_linger = 30;
            setsockopt(sock, SOL_SOCKET, SO_LINGER, &l, sizeof(l));
        }
# endif
# ifdef __win32__
        /*
         * make it blocking
         */
        {
            unsigned long zero = 0;
            ioctlsocket(sock, FIONBIO, &zero);
        }
        {
#  if 0 && (defined( __BORLANDC__ ) || defined( __MINGW__ ))
            /*
             * make it a FILE *
             */
            __stxWrapApiEnterCritical();
            _fd = _open_osfhandle((long)sock, 0);
            __stxWrapApiLeaveCritical();
#  else
            _fd = (int)sock;
#  endif
            DBGPRINTF(("SOCKET: sock=%d fd=%d\n", sock, _fd));
        }
# else  // !__win32__
        fp = fdopen(sock, "r+");
        if (! fp) {
            DBGPRINTF(("SOCKET: fdopen call failed\n"));
            error = __MKSMALLINT(errno);
            __BEGIN_INTERRUPTABLE__
            closesocket(sock);
            DBGFPRINTF((stderr, "SOCKET: fdopen failed (%d)\n", sock));
            __END_INTERRUPTABLE__
            goto out;
        }
# endif // !__win32__

        if (@global(FileOpenTrace) == true) {
# ifdef __win32__
            console_fprintf(stderr, "fdopen [Socket create] -> fd: %d (H: %"_lx_")\n", (INT)_fd, (INT)sock);
# else
            console_fprintf(stderr, "fdopen [Socket] -> %"_lx_" (fd: %d)\n", (INT)fp, sock);
# endif
        }

# ifdef __win32__
        __externalAddressVal(newHandle) = _fd;
        __INST(handleType) = @symbol(socketHandle);
# else
        __externalAddressVal(newHandle) = fp;
        __INST(handleType) = @symbol(socketFilePointer);
# endif
    }
#endif
out:;
%}.

    "all ok?"
    handleType notNil ifTrue:[
        handle := newHandle.
        domain := domainArg.
        socketType := typeArg.
        self registerForFinalization.
        ^ self.
    ].
    error isInteger ifTrue:[
        lastErrorNumber := error.
        ^ self openError:error.
    ].
    ^ self primitiveFailed:error.

    "
     Socket new domain:#AF_INET type:#stream
     Socket new domain:#AF_UNIX type:#stream
    "
! !


!Socket methodsFor:'specials'!

linger:anIntegerOrNil
    "set the linger behavior on close:
      anIntegerOrNil == nil: close returns immediately, socket tries
                             to send buffered data in background.
      anIntegerOrNil == 0:   close returns immediately, bufferd data is discarded.
      anIntegerOrNil > 0:    close waits this many seconds for buffered data
                             to be delivered, after this time buffered data is
                             discarded and close returns with an error"

    ^ self
        setSocketOption:#'SO_LINGER'
        argument:anIntegerOrNil notNil
        argument:anIntegerOrNil.
!

receiveBufferSize
    "get the send buffer size - for special applications only.
     Not all operatingSystems offer this functionality
     (returns nil, if unsupported)"

    handle isNil ifTrue:[
	^ self errorNotOpen
    ].
%{
#if defined(SO_RCVBUF) && defined(SOL_SOCKET)
    {
	OBJ fp = __INST(handle);
	SOCKET sock;
	int opt;
	unsigned int size;

	sock = SOCKET_FROM_FILE_OBJECT(fp);
	if (getsockopt(sock, SOL_SOCKET, SO_RCVBUF, (char *)&opt, &size) >= 0) {
	    RETURN( __MKSMALLINT(opt) );
	}
    }
#endif
%}.
    ^ nil
!

receiveBufferSize:size
    "set the receive buffer size - for special applications only.
     Not all operatingSystems offer this functionality
     (returns false, if unsupported)"

    handle isNil ifTrue:[
	^ self errorNotOpen
    ].
%{
#if defined(SO_RCVBUF) && defined(SOL_SOCKET)
    if (__isSmallInteger(size)) {
	OBJ fp = __INST(handle);
	SOCKET sock;
	int opt;

	sock = SOCKET_FROM_FILE_OBJECT(fp);
	opt = __intVal(size);
	if (setsockopt(sock, SOL_SOCKET, SO_RCVBUF, (char *)&opt, sizeof(int)) >= 0 ) {
	    RETURN(true);
	}
    }
#endif
%}.
    ^ false
!

receiveTimeout
    "get the receive timeout in millis - for special applications only.
     Not all operatingSystems offer this functionality
     (returns nil, if unsupported)"

    |millis|

    handle isNil ifTrue:[
	^ self errorNotOpen
    ].
%{
#if defined(SO_RCVTIMEO) && defined(SOL_SOCKET)
    OBJ fp = __INST(handle);
    SOCKET sock = SOCKET_FROM_FILE_OBJECT(fp);
    int len;
    int __millis;
    struct timeval tv = {0, 0};

    len = sizeof(struct timeval);
    if (getsockopt(sock, SOL_SOCKET, SO_RCVTIMEO, (void *)&tv, &len) == 0) {
	__millis = (tv.tv_sec * 1000) + (tv.tv_usec / 1000);
	millis = __mkSmallInteger(__millis);
# if 0
	console_fprintf(stderr, "getsockopt -> s:%d us:%d -> millis:%d\n", tv.tv_sec, tv.tv_usec, __millis);
# endif
    } else {
	console_fprintf(stderr, "Socket [warning]: getsockopt %d failed; errno=%d\n", sock, errno);
    }
#endif
%}.
    millis notNil ifTrue:[^ millis / 1000 ].
    ^ nil
!

receiveTimeout:seconds
    "set the receive timeout - for special applications only.
     Not all operatingSystems offer this functionality
     (returns false, if unsupported)"

    |millis|

    handle isNil ifTrue:[
	^ self errorNotOpen
    ].
    millis := (seconds * 1000) rounded.
%{
#if defined(SO_RCVTIMEO) && defined(SOL_SOCKET)
    if (__isSmallInteger(millis)) {
	OBJ fp = __INST(handle);
	SOCKET sock = SOCKET_FROM_FILE_OBJECT(fp);
	int __millis = __intVal(millis);
	struct timeval tv = {0, 0};

	tv.tv_sec = __millis / 1000;
	tv.tv_usec = (__millis % 1000) * 1000;
# if 0
	console_fprintf(stderr, "setsockopt -> millis:%d -> s:%d us:%d \n", __millis, tv.tv_sec, tv.tv_usec);
# endif
	if (setsockopt(sock, SOL_SOCKET, SO_RCVTIMEO, (void *)&tv, sizeof(struct timeval)) == 0) {
	    RETURN(true);
	}
	console_fprintf(stderr, "Socket [warning]: setsockopt %d failed; errno=%d\n", sock, errno);
    }
#endif
%}.
    ^ false
!

sendBufferSize
    "get the send buffer size - for special applications only.
     Not all operatingSystems offer this functionality
     (returns nil, if unsupported)"

    handle isNil ifTrue:[
	^ self errorNotOpen
    ].
%{
#if defined(SO_SNDBUF) && defined(SOL_SOCKET)
    {
	OBJ fp = __INST(handle);
	SOCKET sock;
	int opt;
	unsigned int size;

	sock = SOCKET_FROM_FILE_OBJECT(fp);
	if (getsockopt(sock, SOL_SOCKET, SO_SNDBUF, (char *)&opt, &size) >= 0) {
	    RETURN( __MKSMALLINT(opt) );
	}
    }
#endif
%}.
    ^ nil
!

sendBufferSize:size
    "set the send buffer size - for special applications only.
     Not all operatingSystems offer this functionality
     (returns false, if unsupported)"

    handle isNil ifTrue:[
	^ self errorNotOpen
    ].
%{
#if defined(SO_SNDBUF) && defined(SOL_SOCKET)
    if (__isSmallInteger(size)) {
	OBJ fp = __INST(handle);
	SOCKET sock;
	int opt;

	sock = SOCKET_FROM_FILE_OBJECT(fp);
	opt = __intVal(size);
	if (setsockopt(sock, SOL_SOCKET, SO_SNDBUF, (char *)&opt, sizeof(int)) >= 0) {
	    RETURN(true);
	}
    }
#endif
%}.
    ^ false
!

sendTimeout
    "get the send timeout in millis - for special applications only.
     Not all operatingSystems offer this functionality
     (returns nil, if unsupported)"

    |millis|

    handle isNil ifTrue:[
	^ self errorNotOpen
    ].
%{
#if defined(SO_SNDTIMEO) && defined(SOL_SOCKET)
    OBJ fp = __INST(handle);
    SOCKET sock = SOCKET_FROM_FILE_OBJECT(fp);
    int len;
    int __millis;
    struct timeval tv = {0, 0};

    len = sizeof(struct timeval);
    if (getsockopt(sock, SOL_SOCKET, SO_SNDTIMEO, (void *)&tv, &len) == 0) {
	__millis = (tv.tv_sec * 1000) + (tv.tv_usec / 1000);
	millis = __mkSmallInteger(__millis);
# if 0
	console_fprintf(stderr, "getsockopt -> s:%d us:%d -> millis:%d\n", tv.tv_sec, tv.tv_usec, __millis);
# endif
    } else {
	console_fprintf(stderr, "Socket [warning]: getsockopt %d failed; errno=%d\n", sock, errno);
    }
#endif
%}.
    millis notNil ifTrue:[^ millis / 1000 ].
    ^ nil
!

sendTimeout:seconds
    "set the send timeout - for special applications only.
     Not all operatingSystems offer this functionality
     (returns false, if unsupported)"

    |millis|

    handle isNil ifTrue:[
	^ self errorNotOpen
    ].
    millis := (seconds * 1000) rounded.
%{
#if defined(SO_SNDTIMEO) && defined(SOL_SOCKET)
    if (__isSmallInteger(millis)) {
	OBJ fp = __INST(handle);
	SOCKET sock = SOCKET_FROM_FILE_OBJECT(fp);
	int __millis = __intVal(millis);
	struct timeval tv = {0, 0};

	tv.tv_sec = __millis / 1000;
	tv.tv_usec = (__millis % 1000) * 1000;
# if 0
	console_fprintf(stderr, "setsockopt -> millis:%d -> s:%d us:%d \n", __millis, tv.tv_sec, tv.tv_usec);
# endif
	if (setsockopt(sock, SOL_SOCKET, SO_SNDTIMEO, (void *)&tv, sizeof(struct timeval)) == 0) {
	    RETURN(true);
	}
	console_fprintf(stderr, "Socket [warning]: setsockopt %d failed; errno=%d\n", sock, errno);
    }
#endif
%}.
    ^ false
!

setTCPCork:aBoolean
    "enable/disable TCP_CORK (do-not-send-partial-frames)
     For special applications only.
     Not all OperatingSystems offer this functionality
     (returns false, if unsupported)"

    ^ self setSocketOption:#'TCP_CORK' argument:aBoolean argument:nil.
!

setTCPNoDelay:aBoolean
    "enable/disable TCP_NODELAY (i.e. disable/enable the Nagle algorithm)
     For special applications only.
     Not all OperatingSystems offer this functionality
     (returns false, if unsupported)"

    ^ self setSocketOption:#'TCP_NODELAY' argument:aBoolean argument:nil.
! !


!Socket methodsFor:'waiting'!

waitForNewConnectionOrDataOnAny:otherConnections timeout:timeoutSeconds
    "suspend the current process, until either a new connection comes
     in at the receiver, or data arrives on any of the otherConnections.
     For a new connection, an accept is performed and the new socket is returned.
     For an old connection, that socket is returned.
     In any case, the caller gets a socket to operate on as return value,
     or nil, if a timeout occurred.
     This method implements the inner wait-primitive of a multi-connection
     server application."


    |wasBlocked sema|

    "first, a quick check if data is already available"
    self canReadWithoutBlocking ifTrue:[
        ^ self accept.
    ].
    otherConnections do:[:aConnection |
        aConnection canReadWithoutBlocking ifTrue:[
            ^ aConnection
        ]
    ].

    "check again - prevent incoming interrupts from disturbing our setup"
    wasBlocked := OperatingSystem blockInterrupts.
    [
        sema := Semaphore new name:'multiReadWait'.
        otherConnections do:[:aConnection |
            Processor signal:sema onInput:(aConnection fileDescriptor).
        ].
        Processor signal:sema onInput:(self fileDescriptor).
        timeoutSeconds notNil ifTrue:[
            Processor signal:sema afterSeconds:timeoutSeconds
        ].
        Processor activeProcess state:#ioWait.
        sema wait.
    ] ifCurtailed:[
        sema notNil ifTrue:[Processor disableSemaphore:sema].
        wasBlocked ifFalse:[OperatingSystem unblockInterrupts].
    ].
    wasBlocked ifFalse:[OperatingSystem unblockInterrupts].

    "see who it was ..."
    self canReadWithoutBlocking ifTrue:[
        ^ self accept.
    ].
    otherConnections do:[:aConnection |
        aConnection canReadWithoutBlocking ifTrue:[
            ^ aConnection
        ]
    ].

    "none - a timeout"
    ^ nil
!

waitForNewConnectionWithTimeout:timeoutSecondsOrNil
    "suspend the current process, until a new connection comes
     in at the receiver or a timeout occurs.
     For a new connection, an accept is performed and the new socket is returned.
     Returns nil, if a timeout occurred.
     This method implements the inner wait-primitive of a single-connection
     server application."

    |newSock|

    (self readWaitWithTimeout:timeoutSecondsOrNil) ifTrue:[
        "a timeout occurred - no connection within timeout"
        ^ nil
    ].
    self isOpen ifFalse:[
        "socket has been closed while waiting"
        ^ nil.
    ].
    newSock := self class new.
    (newSock primAcceptOn:self blocking:false) ifFalse:[
        "should raise an error here"
        ^ nil
    ].
    ^ newSock
! !

!Socket class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

