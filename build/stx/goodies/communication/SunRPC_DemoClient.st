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

RPCClient subclass:#DemoClient
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Net-Communication-SunRPC-Demos'
!

!DemoClient class methodsFor:'documentation'!

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
    a simple rpc-demo client;
    supports a few simple procedures: 

        showOnTranscript            - display a message on a remote transcript
        showMultipleOnTranscript    - display a collection of strings on a remote transcript    
        showPerson                  - example for a structured type object being passed
                                      and shown on a remote transcript

    first, start the demoServer (on any machine) with:
          SunRPC::DemoServer start

    then, connect to it, and execute a remote procedure call:

         |hostName client message reply|

         message := 'hello world'.
         hostName := Dialog request:'Host ?' initialAnswer:'localhost'.
         client := SunRPC::DemoClient new host:hostName.
         client showOnTranscript:message.
         client close.

    [author:]
        Claus Gittinger
"
! !

!DemoClient class methodsFor:'spec'!

xdr
    ^ DemoServer xdr
! !

!DemoClient methodsFor:'operations'!

showMultipleOnTranscript:aStringCollection
    |reply|

    reply := self operation:#showMultipleOnTranscript argument:aStringCollection.
    ^ reply

    "
     |client messages reply|

     messages := #( 'line1' 'line2' 'line3' 'line4' ).
     client := SunRPC::DemoClient new host:'localhost'.
     reply := client showMultipleOnTranscript:messages.
     client close.
     reply.
    "
    "
     |client messages reply|

     messages := #( 'line1' 'line2' 'line3' 'line4' ).
     client := SunRPC::DemoClient new host:'localhost' port:44400.
     reply := client showMultipleOnTranscript:messages.
     client close.
     reply.
    "
!

showOnTranscript:aString
    |reply|

    reply := self operation:#showOnTranscript argument:aString.
    ^ reply

    "
     |client message reply|

     message := 'hello world'.
     client := SunRPC::DemoClient new host:'localhost'.
     reply := client showOnTranscript:message.
     client close.
     reply.
    "
!

showPersonOnTranscript:aPerson
    |reply|

    reply := self operation:#showPersonOnTranscript argument:aPerson.
    ^ reply

    "
     |client person reply|

     person := Dictionary new
                    at:'firstName' put:'James';
                    at:'lastName' put:'Miller';
                    yourself.

     client := SunRPC::DemoClient new host:'localhost'.
     reply := client showPersonOnTranscript:person.
     client close.
     reply.
    "

    "if you know the port and protocol, the portMapper is not needed:

     |client person reply|

     person := Dictionary new
                    at:'firstName' put:'James';
                    at:'lastName' put:'Miller';
                    yourself.

     client := SunRPC::DemoClient new host:'localhost' protocol:#tcp port:44400.
     reply := client showPersonOnTranscript:person.
     client close.
     reply.
    "
! !

!DemoClient class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/SunRPC_DemoClient.st,v 1.9 2017-11-18 09:55:11 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/SunRPC_DemoClient.st,v 1.9 2017-11-18 09:55:11 cg Exp $'
! !

