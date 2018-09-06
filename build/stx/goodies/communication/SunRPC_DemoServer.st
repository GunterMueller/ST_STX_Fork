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

RPCServer subclass:#DemoServer
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Net-Communication-SunRPC-Demos'
!

!DemoServer class methodsFor:'documentation'!

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
    a simple rpc-demo server;
    supports a few simple procedures: 
    
        showOnTranscript            - display a message on a remote transcript
        showMultipleOnTranscript    - display a collection of strings on a remote transcript    
        showPerson                  - example for a structured type object being passed
                                      and shown on a remote transcript

    startWith:
        SunRPC::DemoServer start

    [author:]
        Claus Gittinger
"
! !

!DemoServer class methodsFor:'spec'!

xdr
    "
     SunRPC::DemoServer initDefinitions
     SunRPC::DemoClient initDefinitions
    "

    ^ '

typedef string stringArg<>;
typedef stringArg stringsArg<>;
typedef struct {
    string firstName<>;
    string lastName<>;
} personRecord;

program DEMO {
        version DEMOVERS {
                void
                    null(void) = 0;

                bool
                    showOnTranscript(stringArg) = 1;
        } = 1;

        version DEMOVERS {
                void
                    null(void) = 0;

                bool
                    showOnTranscript(stringArg) = 1;

                bool
                    showMultipleOnTranscript(stringsArg) = 2;

                bool
                    showPersonOnTranscript(personRecord) = 3;
        } = 2;
} = 200199; 
'
! !

!DemoServer methodsFor:'operations'!

showMultipleOnTranscript:argVector
    |strings|

    strings := argVector at:1.
    strings do:[:each |
        Transcript showCR:each.
    ].
    ^ true.
!

showOnTranscript:argVector
    Transcript showCR:(argVector at:1).
    ^ true.
!

showPersonOnTranscript:argVector
    |person|

    person := argVector at:1.
    Transcript showCR:('firstName: %1 lastName: %2' 
                        bindWith:(person at:'firstName')
                        with:(person at:'lastName')).
    ^ true.
! !

!DemoServer methodsFor:'queries'!

portNumbers
    ^ ( 44400 to: 44499 )
! !

!DemoServer class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/SunRPC_DemoServer.st,v 1.10 2017-11-18 09:55:13 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/SunRPC_DemoServer.st,v 1.10 2017-11-18 09:55:13 cg Exp $'
! !

