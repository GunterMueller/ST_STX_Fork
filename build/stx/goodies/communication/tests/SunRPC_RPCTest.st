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
"{ Package: 'stx:goodies/communication/tests' }"

"{ NameSpace: SunRPC }"

TestCase subclass:#RPCTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Net-Communication-RPC-Tests'
!

!RPCTest class methodsFor:'documentation'!

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
    [author:]
	Claus Gittinger
"
! !

!RPCTest methodsFor:'tests'!

test_rpc_call1
    |client|

    [
	"/ client := SunRPC::PortMapperClient toHost:'exept'.
	client := SunRPC::PortMapperClient toHost:'localhost'.
	client null.
    ] ensure:[
	client close
    ]

    "
     self basicNew test_rpc_call1
     self run:#test_rpc_call1
    "
!

test_rpc_call2
    |client|

    [
	"/ client := SunRPC::PortMapperClient toHost:'exept'.
	client := SunRPC::PortMapperClient toHost:'localhost'.
	client dump.
    ] ensure:[
	client close
    ]

    "
     self basicNew test_rpc_call2
    "
!

test_rpc_call3
    |client port|

    [
	"/ client := SunRPC::PortMapperClient toHost:'exept'.
	client := SunRPC::PortMapperClient toHost:'localhost'.

	"/ portmapper itself
	port := client getportForProgram:100000 version:2 protocol:#tcp.
	self assert:(port == 111).
	port := client getportForProgram:100000 version:2 protocol:#udp.
	self assert:(port == 111).

	"/ mountd
	port := client getportForProgram:100005 version:1 protocol:#tcp.
	self assert:(port > 0).
	port := client getportForProgram:100005 version:3 protocol:#udp.
	self assert:(port > 0).
    ] ensure:[
	client close
    ]

    "
     self basicNew test_rpc_call3
    "
!

test_rpc_xdr1
    |auth bytes u auth2|

    auth := RPCDefinitions rpcAuth new
		flavor:1234
		stuff:'hello' asByteArray.

    bytes :=
       XDRCoder new
	   packAuth:auth;
	   contents.

    u := XDRCoder from:bytes.

    auth2 := u unpackAuth.
    self assert:( (auth2 flavor = auth flavor) ).
    self assert:( (auth2 stuff = auth stuff) ).

    "
      self basicNew test_rpc_xdr1
    "
!

test_rpc_xdr2
    |cred verf header bytes u rslt|

    cred := RPCDefinitions rpcAuth new flavor:1234 stuff:'hello' asByteArray.
    verf := RPCDefinitions rpcAuth new flavor:2345 stuff:'ollah' asByteArray.
    header := RPCDefinitions rpcCallHeader new
		xid:123 prog:2 vers:1 proc:3 cred:cred verf:verf.

    bytes :=
       XDRCoder new
	   packCallHeader:header;
	   contents.

    u := XDRCoder from:bytes.

    rslt := u unpackCallHeader.
    self assert:( (rslt xid = 123) ).
    self assert:( (rslt prog = 2) ).
    self assert:( (rslt vers = 1) ).
    self assert:( (rslt proc = 3) ).
    self assert:( (rslt cred flavor = cred flavor) ).
    self assert:( (rslt cred stuff = cred stuff) ).
    self assert:( (rslt verf flavor = verf flavor) ).
    self assert:( (rslt verf stuff = verf stuff) ).

    "
      self basicNew test_rpc_xdr2
    "
!

test_rpc_xdr3
    | verf header bytes u rslt|

    verf := RPCDefinitions rpcAuth new flavor:2345 stuff:'ollah' asByteArray.
    header := RPCDefinitions rpcReplyHeader new xid:123 verf:verf.
    header replyStatus:(RPCDefinitions MSG_ACCEPTED).
    header acceptStatus:(RPCDefinitions SUCCESS).

    bytes :=
       XDRCoder new
	   packReplyHeader:header;
	   contents.

    u := XDRCoder from:bytes.

    rslt := u unpackReplyHeader.
    self assert:( (rslt xid = 123) ).
    self assert:( (rslt verf flavor = verf flavor) ).
    self assert:( (rslt verf stuff = verf stuff) ).


    "
      self basicNew test_rpc_xdr3
    "
! !

!RPCTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/tests/SunRPC_RPCTest.st,v 1.2 2016-05-02 15:41:09 cg Exp $'
! !
