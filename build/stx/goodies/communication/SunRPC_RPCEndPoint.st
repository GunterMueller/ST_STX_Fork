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

Object subclass:#RPCEndPoint
	instanceVariableNames:'protocol portNumber connection'
	classVariableNames:''
	poolDictionaries:''
	category:'Net-Communication-SunRPC'
!

RPCEndPoint class instanceVariableNames:'Definitions'

"
 No other class instance variables are inherited by this class.
"
!

!RPCEndPoint class methodsFor:'documentation'!

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
    abstract superclass for RPC programs.

    [author:]
        Claus Gittinger
"
! !

!RPCEndPoint class methodsFor:'initialization'!

addSelector:newSelector withMethod:newMethod
    super addSelector:newSelector withMethod:newMethod.
    newSelector == #xdr ifTrue:[
        self flushDefinition.
    ].
!

flushAllDefinitions
    self withAllSubclassesDo:[:eachClass |
        eachClass flushDefinition.
    ].

    "
     self flushAllDefinitions
    "
!

flushDefinition
    Definitions := nil.

    "
     NFSServer flushDefinition
    "
!

initDefinitions
    |xdrSpec|

    xdrSpec := self xdr.
    xdrSpec notNil ifTrue:[
        Definitions := XDRParser parsePrograms:xdrSpec
    ]
! !

!RPCEndPoint class methodsFor:'queries'!

isRPCClientClass
    ^ false
!

isRPCServerClass
    ^ false
! !

!RPCEndPoint class methodsFor:'spec'!

definitions
    Definitions isNil ifTrue:[
        self initDefinitions.
    ].
    ^ Definitions
!

xdr
    self subclassResponsibility
! !

!RPCEndPoint class methodsFor:'startup'!

new
    Definitions isNil ifTrue:[
        "parse definitions (if not already done)"
        self initDefinitions
    ].
    ^ self basicNew initialize
! !

!RPCEndPoint methodsFor:'initialization'!

portNumber:aNumber
    portNumber := aNumber
!

protocol:aSymbol      
    "/ #tcp or #udp
    protocol := aSymbol
! !

!RPCEndPoint methodsFor:'queries'!

portNumber
    ^ portNumber
! !

!RPCEndPoint class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/SunRPC_RPCEndPoint.st,v 1.4 2017-11-18 09:51:34 cg Exp $'
! !

