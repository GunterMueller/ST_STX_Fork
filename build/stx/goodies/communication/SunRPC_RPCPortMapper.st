"
 COPYRIGHT (c) 2002 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:goodies/communication' }"

"{ NameSpace: SunRPC }"

RPCClient subclass:#PortMapperClient
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Net-Communication-SunRPC'
!

!PortMapperClient class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2002 by eXept Software AG
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
    interface to the portmapper; see RFC1057 and examples.

    [author:]
        Claus Gittinger

    [see also:]
        RFC1057
"
!

examples
"
  Notice: windows systems have no portMapper running -
  you must try these on a unix box 
  (or change 'localhost' to the name of a box running a real OS in your network).

  connect test:
                                                                [exBegin]
    |mapper|

    mapper := SunRPC::PortMapperClient toHost:'localhost'.
    mapper close.
                                                                [exEnd]

                                                                [exBegin]
    |mapper|

    mapper := SunRPC::PortMapperClient toHost:'exeptn' protocol:#udp port:111.
    mapper close.
                                                                [exEnd]

  dump the current mapping (same as 'rpcinfo -p' command):
                                                                [exBegin]
    |mapper|

    mapper := SunRPC::PortMapperClient toHost:'exeptn'.
    mapper dumpAndShow.
    mapper close.
                                                                [exEnd]

  dump the current mapping via udp (same as 'rpcinfo -p' command):
                                                                [exBegin]
    |mapper|

    mapper := SunRPC::PortMapperClient toHost:'exeptn' protocol:#udp port:111.
    mapper dumpAndShow.
    mapper close.
                                                                [exEnd]

  dump the current mapping via tcp (same as 'rpcinfo -p' command):
                                                                [exBegin]
    |mapper|

    mapper := SunRPC::PortMapperClient toHost:'exeptn' protocol:#tcp port:111.
    mapper dumpAndShow.
    mapper close.
                                                                [exEnd]

  get a mapping:
                                                                [exBegin]
    |mapper port|

    mapper := SunRPC::PortMapperClient toHost:'localhost'.
    port := mapper getportForProgram:100000 version:2 protocol:#tcp.
    mapper close.
    Transcript showCR:port.
                                                                [exEnd]

  set a port (please validate with 'rpcinfo -p'):
                                                                [exBegin]
    |mapper ok|

    mapper := SunRPC::PortMapperClient toHost:'localhost'.
    ok := mapper setProgram:200000 version:1 protocol:#tcp port:33333.
    mapper close.
    ok ifFalse:[self error]
                                                                [exEnd]

  unset a port (please validate with 'rpcinfo -p'):
                                                                [exBegin]
    |mapper ok|
    mapper := SunRPC::PortMapperClient toHost:'localhost'.
    ok := mapper unsetProgram:200000 version:1 protocol:#tcp.
    mapper close.
    ok ifFalse:[self error]
                                                                [exEnd]
"
! !

!PortMapperClient class methodsFor:'constants'!

PROTO_TCP
    ^ 6
!

PROTO_UDP
    ^ 17
!

knownProgramNumbers
    ^ Dictionary 
        withKeysAndValues:#(
             100000 portmapper
             100003 nfsd
             100005 mountd
             100021 nlockmgr
             100024 status
        )
! !

!PortMapperClient class methodsFor:'spec'!

xdr
    ^'   
//
// from RFC1057
//

const PMAP_PORT = 111;      /* portmapper port number */

const IPPROTO_TCP = 6;      /* protocol number for TCP/IP */
const IPPROTO_UDP = 17;     /* protocol number for UDP/IP */

enum protoNumber {
   tcp = 6,
   udp = 17
};

struct mapping {
   unsigned int prog;
   unsigned int vers;
   protoNumber prot;        /* used to be unsigned int */
   unsigned int port;
};

struct *pmaplist {
   mapping map;
   pmaplist next;
};

struct call_result {
   unsigned int port;
   opaque res<>;
};

struct call_args {
   unsigned int prog;
   unsigned int vers;
   unsigned int proc;
   opaque args<>;
};

program PMAP_PROG {
   version PMAP_VERS {
      void
      null(void)         = 0;

      bool
      set(mapping)       = 1;

      bool
      unset(mapping)     = 2;

      unsigned int
      getport(mapping)   = 3;

      pmaplist
      dump(void)         = 4;

      call_result
      callit(call_args)  = 5;
   } = 2;
} = 100000;
'

    "Modified: / 30.1.2002 / 14:50:04 / cg"
! !

!PortMapperClient methodsFor:'helpers'!

protocolNumberFor:symbolicOrNumericProtocol
    symbolicOrNumericProtocol == #tcp ifTrue:[
        ^ self class PROTO_TCP
    ].
    symbolicOrNumericProtocol == #udp ifTrue:[
        ^ self class PROTO_UDP
    ].
    symbolicOrNumericProtocol isInteger ifTrue:[
        ^ symbolicOrNumericProtocol
    ].
    self error:'bad protocol arg'
! !

!PortMapperClient methodsFor:'operations'!

callit:call_args
    self halt:'not yet implemented'

    "Created: / 30.1.2002 / 15:22:08 / cg"
!

dump
    "return a dump-list of the portmappers state.
     roughly equivalent to 'rpcinfo -p' unix command"

    ^ self operation:#dump arguments:nil.

    "
     |mapper list|

     mapper := self toHost:'localhost'.
     list := mapper dump.
     mapper close.
     list inspect
    "

    "Modified: / 30.1.2002 / 15:21:03 / cg"
!

getport:mapping
    "get the port for a (program version protocol) tuple"

    ^ self operation:#getport arguments:(Array with:mapping).

    "
     |mapperClient port arg|

     mapperClient := self toHost:'alan'. 
     arg := Dictionary new
                at:'prog' put:100000;
                at:'vers' put:2;
                at:'prot' put:#tcp;
                at:'port' put:nil;
                yourself.

     port := mapperClient getport:arg.
     mapperClient close.
     port   
    "

    "Modified: / 30.1.2002 / 16:21:39 / cg"
!

set:mapping
    "register a port for a (program version protocol port) tuple"

    ^ self operation:#set arguments:(Array with:mapping).

    "
     |mapperClient arg ok|

     mapperClient := self toHost:'localhost'. 
     arg := Dictionary new
                at:'prog' put:200000;
                at:'vers' put:1;
                at:'prot' put:#tcp;
                at:'port' put:3333;
                yourself.
     ok := mapperClient set:arg.
     mapperClient close.
     ok        

     (self toHost:'localhost') dump; close
    "

    "Created: / 30.1.2002 / 15:11:38 / cg"
    "Modified: / 30.1.2002 / 15:23:14 / cg"
!

unset:mapping
    "unregister a port for a (program version protocol) tuple"

    ^ self operation:#unset arguments:(Array with:mapping).

    "
     |arg mapperClient ok|

     mapperClient := (self toHost:'localhost'). 
     arg := Dictionary new
                at:'prog' put:200000;
                at:'vers' put:1;
                at:'prot' put:#tcp;
                yourself.
     ok := mapperClient unset:arg.
     mapperClient close.
     ok      

     (self toHost:'localhost') dump; close
    "

    "Created: / 30.1.2002 / 15:15:09 / cg"
    "Modified: / 30.1.2002 / 15:23:32 / cg"
! !

!PortMapperClient methodsFor:'operations - convenient interface'!

dumpAndShow
    "dump the portmapper information.
     roughly equivalent to 'rpcinfo -p' unix command"

    |list|

    list := self dump.

    list do:[:eachMapping |
        |map prog vers prot port protString progName|

        map := eachMapping at:'map'.
        prog := map at:'prog'.
        vers := map at:'vers'.
        prot := map at:'prot'.
        port := map at:'port'.

        prot == self class PROTO_TCP ifTrue:[
            protString := 'tcp'
        ] ifFalse:[
            prot == self class PROTO_UDP ifTrue:[
                protString := 'udp'
            ] ifFalse:[
                protString := 'other'
            ]
        ].
        progName := self class knownProgramNumbers at:prog ifAbsent:''.

        Transcript 
            show:'prog: '; show:prog; 
            show:' vers: '; show:vers;     
            show:' prot: '; show:(prot printString leftPaddedTo:2); space; 
                           show:(('(', protString ,')') leftPaddedTo:6);   
            show:' port: '; show:(port printString leftPaddedTo:5);    
            show:' : '; show:progName; cr    
    ].

    "
     (self toHost:'localhost') dumpAndShow; close
    "

    "Modified: / 30.1.2002 / 14:40:28 / cg"
    "Created: / 30.1.2002 / 15:19:24 / cg"
!

getportForProgram:programNr version:vsnNr protocol:prot
    "get the port for a (program version protocol) tuple.
     prot must be one of #tcp or #udp"

    |arg|

    arg := Dictionary new
               at:'prog' put:programNr;
               at:'vers' put:vsnNr;
               at:'prot' put:prot;
               yourself.

    ^ self getport:arg.

"/    |protNr reply encoder port|
"/
"/    protNr := self protocolNumberFor:prot.
"/
"/    encoder := XDRCoder new.
"/    encoder packUnsignedInt:programNr.
"/    encoder packUnsignedInt:vsnNr.
"/    encoder packUnsignedInt:protNr.
"/    encoder packUnsignedInt:0 "port".
"/
"/    reply := self callOperation:#getport withData:encoder contents.
"/    port := replyDataUnpacker unpackUnsignedInt.
"/
"/    ^ port.

    "
     |mapperClient port|

     mapperClient := self toHost:'alan'. 
     port := mapperClient getportForProgram:100000 version:2 protocol:#tcp.
     mapperClient close.
     port
    "

    "Modified: / 30.1.2002 / 15:23:41 / cg"
!

setProgram:programNr version:vsnNr protocol:prot port:portNr
    "register a port for a (program version protocol) tuple"

    |arg|

    arg := Dictionary new
               at:'prog' put:programNr;
               at:'vers' put:vsnNr;
               at:'prot' put:prot;
               at:'port' put:portNr;
               yourself.
    ^ self set:arg.

"/    |protNr reply encoder ok|
"/
"/    protNr := self protocolNumberFor:prot.
"/
"/    encoder := XDRCoder new.
"/    encoder packUnsignedInt:programNr.
"/    encoder packUnsignedInt:vsnNr.
"/    encoder packUnsignedInt:protNr.
"/    encoder packUnsignedInt:portNr.
"/
"/    reply := self callOperation:#set withData:encoder contents.
"/    ok := replyDataUnpacker unpackBool.
"/
"/    ^ ok.

    "
     |mapperClient ok|

     mapperClient := (self toHost:'localhost'). 
     ok := mapperClient setProgram:200000 version:1 protocol:#tcp port:3333.
     mapperClient close.
     ok

     (self toHost:'localhost') dump; close
    "

    "Modified: / 30.1.2002 / 15:23:47 / cg"
!

unsetProgram:programNr version:vsnNr protocol:prot
    "unregister a port for a (program version protocol) tuple"

    |arg|

    arg := Dictionary new
               at:'prog' put:programNr;
               at:'vers' put:vsnNr;
               at:'prot' put:prot;
               yourself.
    ^ self unset:arg.

"/    |protNr reply encoder ok|
"/
"/    protNr := self protocolNumberFor:prot.
"/
"/    encoder := XDRCoder new.
"/    encoder packUnsignedInt:programNr.
"/    encoder packUnsignedInt:vsnNr.
"/    encoder packUnsignedInt:protNr.
"/    encoder packUnsignedInt:0.
"/
"/    reply := self callOperation:#unset withData:encoder contents.
"/    ok := replyDataUnpacker unpackBool.
"/
"/    ^ ok.

    "
     |mapperClient ok|

     mapperClient := (self toHost:'localhost'). 
     ok := mapperClient unsetProgram:200000 version:1 protocol:#tcp.
     mapperClient close.
     ok      

     (self toHost:'localhost') dump; close
    "

    "Modified: / 30.1.2002 / 15:23:51 / cg"
! !

!PortMapperClient methodsFor:'queries'!

portNumber
    ^ 111
!

protocol
    ^ #tcp
! !

!PortMapperClient class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/SunRPC_RPCPortMapper.st,v 1.19 2017-11-18 09:51:02 cg Exp $'
! !

