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

RPCServer subclass:#PortMapperServer
	instanceVariableNames:''
	classVariableNames:'Mappings Lock'
	poolDictionaries:''
	category:'Net-Communication-SunRPC'
!

Object subclass:#Mapping
	instanceVariableNames:'prog vers prot port'
	classVariableNames:''
	poolDictionaries:''
	privateIn:PortMapperServer
!

!PortMapperServer class methodsFor:'documentation'!

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
    a portmapper implementation for systems which don't have one
    (i.e. Windows); see RFC1057.

    [start with:]
        PortMapperServer start
        PortMapperServer startUDP

    [author:]
        Claus Gittinger

    [see also:]
        RFC1057
"
! !

!PortMapperServer class methodsFor:'class initialization'!

initialize
    Lock := Semaphore forMutualExclusion.
    Mappings isNil ifTrue:[
        Mappings := OrderedCollection new
    ].

    "
     self initialize
    "
! !

!PortMapperServer class methodsFor:'spec'!

xdr
    ^ PortMapperClient xdr

    "Modified: / 30.1.2002 / 15:54:18 / cg"
! !

!PortMapperServer methodsFor:'blocked'!

registerInPortMapper
    "/ its me - myself !!

    "Created: / 1.2.2002 / 13:37:43 / cg"
!

unregisterInPortMapper
    "/ its me - myself !!

    "Created: / 1.2.2002 / 13:37:41 / cg"
! !

!PortMapperServer methodsFor:'operations'!

dump
    ^ Mappings

    "Modified: / 1.2.2002 / 13:21:48 / cg"
!

getport:argList
    |mapping port|

    mapping := argList at:1.

    port := self getPortFor:(Mapping new
                        prog:(mapping at:'prog')
                        vers:(mapping at:'vers')
                        prot:(mapping at:'prot')
                        port:(mapping at:'port')).

    ^ port ? 0

    "Modified: / 18.2.2002 / 11:54:16 / cg"
!

set:argList
    |mapping|

    mapping := argList at:1.

    ^ self addMapping:(Mapping new
                        prog:(mapping at:'prog')
                        vers:(mapping at:'vers')
                        prot:(mapping at:'prot')
                        port:(mapping at:'port')).

    "Modified: / 1.2.2002 / 13:56:21 / cg"
!

unset:argList
    |mapping|

    mapping := argList at:1.

    ^ self removeMapping:(Mapping new
                        prog:(mapping at:'prog')
                        vers:(mapping at:'vers')
                        prot:(mapping at:'prot')
                        port:(mapping at:'port')).

    "Modified: / 1.2.2002 / 13:56:18 / cg"
! !

!PortMapperServer methodsFor:'private'!

addMapping:newMapping
    |result|

    Lock critical:[
        (Mappings contains:[:entry | entry isForSameProgramAs:newMapping]) ifTrue:[
            result := false
        ] ifFalse:[
            result := true.
            Mappings addLast:newMapping.
        ]
    ].

    ^ result

    "Modified: / 1.2.2002 / 13:16:53 / cg"
!

getPortFor:aMapping
    |mapping|

    Lock critical:[
        mapping := Mappings detect:[:entry | entry isForSameProgramAs:aMapping] ifNone:nil.
    ].
    mapping isNil ifTrue:[
        ^ nil
    ].

    ^ mapping port

    "Created: / 1.2.2002 / 13:23:44 / cg"
!

removeMapping:newMapping
    |anyRemove|

    anyRemove := false.
    Lock critical:[
        Mappings := Mappings select:[:entry | 
                                        |removeThis|

                                        removeThis := entry isForSameProgramAs:newMapping.
                                        anyRemove := anyRemove | removeThis.
                                        removeThis not    "/ select condition
                                     ].
    ].
    ^ anyRemove

    "Modified: / 1.2.2002 / 13:21:04 / cg"
! !

!PortMapperServer methodsFor:'queries'!

confirmNewHost:aHostName
    ^ true
!

portNumbers
    ^ #(111)

    "Created: / 1.2.2002 / 14:24:02 / cg"
! !

!PortMapperServer::Mapping methodsFor:'accessing'!

port
    "return the value of the instance variable 'port' (automatically generated)"

    ^ port

    "Created: / 1.2.2002 / 13:08:24 / cg"
!

prog
    "return the value of the instance variable 'prog' (automatically generated)"

    ^ prog

    "Created: / 1.2.2002 / 13:10:00 / cg"
!

prog:progArg vers:versArg prot:protArg port:portArg
    prog := progArg.
    vers := versArg.
    prot := protArg.
    port := portArg

    "Created: / 1.2.2002 / 13:10:42 / cg"
!

prot
    "return the value of the instance variable 'prot' (automatically generated)"

    ^ prot

    "Created: / 1.2.2002 / 13:10:09 / cg"
!

vers
    "return the value of the instance variable 'vers' (automatically generated)"

    ^ vers

    "Created: / 1.2.2002 / 13:10:17 / cg"
! !

!PortMapperServer::Mapping methodsFor:'queries'!

isForSameProgramAs:anotherMapping
    prog = anotherMapping prog ifTrue:[
        vers = anotherMapping vers ifTrue:[
            prot = anotherMapping prot ifTrue:[
                ^ true
            ]
        ]
    ].
    ^ false.

    "Modified: / 1.2.2002 / 13:16:31 / cg"
! !

!PortMapperServer class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/SunRPC_PortMapperServer.st,v 1.11 2017-11-18 09:51:10 cg Exp $'
! !


PortMapperServer initialize!
