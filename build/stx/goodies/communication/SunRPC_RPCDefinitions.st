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

Object subclass:#RPCDefinitions
	instanceVariableNames:''
	classVariableNames:'RPCVERSION'
	poolDictionaries:''
	category:'Net-Communication-SunRPC'
!

Object subclass:#RPCAuth
	instanceVariableNames:'flavor stuff'
	classVariableNames:'AUTH_NULL AUTH_UNIX AUTH_SHORT AUTH_DES'
	poolDictionaries:''
	privateIn:RPCDefinitions
!

RPCDefinitions::RPCAuth subclass:#RPCAuthUnix
	instanceVariableNames:'stamp machineName uid gid gids'
	classVariableNames:''
	poolDictionaries:''
	privateIn:RPCDefinitions
!

Object subclass:#RPCCallHeader
	instanceVariableNames:'xid prog vers proc cred verf'
	classVariableNames:''
	poolDictionaries:''
	privateIn:RPCDefinitions
!

Object subclass:#RPCReplyHeader
	instanceVariableNames:'xid verf replyStatus acceptStatus replyData'
	classVariableNames:''
	poolDictionaries:''
	privateIn:RPCDefinitions
!

!RPCDefinitions class methodsFor:'documentation'!

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

!RPCDefinitions class methodsFor:'initialization'!

initialize
    "self initialize"

    RPCVERSION := 2.
! !

!RPCDefinitions class methodsFor:'accessing'!

AUTH_BADCRED
    "/ bad credentials (seal broken)
    ^ 1
!

AUTH_BADVERF     
    "/ bad verifier (seal broken)
    ^ 3
!

AUTH_DES
    ^ 3
!

AUTH_ERROR
    "/ remote can't authenticate caller
    ^ 1
!

AUTH_FAILED
    "/ reason unknown
    ^ 7
!

AUTH_INVALIDRESP
    "/ bogus response verifier
    ^ 6
!

AUTH_NULL
    ^ 0
!

AUTH_REJECTEDCRED
    "/ client must begin new session
    ^ 2
!

AUTH_REJECTEDVERF
    "/ verifier expired or replayed
    ^ 4
!

AUTH_SHORT
    ^ 2
!

AUTH_TOOWEAK
    "/ rejected for security reasons
    ^ 5
!

AUTH_UNIX
    ^ 1
!

CALL
    ^ 0
!

GARBAGE_ARGS
    "/ procedure can't decode params
    ^ 4
!

MSG_ACCEPTED
    ^ 0
!

MSG_DENIED
    ^ 1
!

PROC_UNAVAIL
    "/ program can't support procedure
    ^ 3
!

PROG_MISMATCH
    "/ remote can't support version #
    ^ 2
!

PROG_UNAVAIL
    "/ remote hasn't exported program
    ^ 1
!

REPLY
    ^ 1
!

RPCVERSION
    ^ RPCVERSION
!

RPC_MISMATCH
    "/ RPC version number !!= 2
    ^ 0
!

SUCCESS
    "/ RPC executed successfully
    ^ 0
!

SYSTEM_ERR
    "/ error during execution
    ^ 5
! !

!RPCDefinitions class methodsFor:'class access'!

rpcAuth
    ^ RPCAuth
!

rpcAuthUnix
    ^ RPCAuthUnix
!

rpcCallHeader
    ^ RPCCallHeader
!

rpcReplyHeader
    ^ RPCReplyHeader
! !

!RPCDefinitions::RPCAuth class methodsFor:'constants'!

auth_DES
    ^ AUTH_DES
!

auth_NULL
    ^ AUTH_NULL
!

auth_SHORT
    ^ AUTH_SHORT
!

auth_UNIX
    ^ AUTH_UNIX
!

initialize
    AUTH_NULL := 0.
    AUTH_UNIX := 1.
    AUTH_SHORT := 2.
    AUTH_DES := 3.

    "
     self initialize
    "
! !

!RPCDefinitions::RPCAuth methodsFor:'accessing'!

flavor
    "return the value of the instance variable 'flavor' (automatically generated)"

    ^ flavor
!

flavor:flavorArg stuff:stuffArg
    flavor := flavorArg.
    stuff := stuffArg.
!

stuff
    "return the value of the instance variable 'stuff' (automatically generated)"

    ^ stuff
!

stuff:something
    "set the value of the instance variable 'stuff' (automatically generated)"

    stuff := something.
! !

!RPCDefinitions::RPCAuthUnix methodsFor:'accessing'!

flavor
    ^ AUTH_UNIX
!

gid
    "return the value of the instance variable 'gid' (automatically generated)"

    ^ gid
!

gid:something
    "set the value of the instance variable 'gid' (automatically generated)"

    gid := something.
!

gids
    "return the value of the instance variable 'gids' (automatically generated)"

    ^ gids
!

gids:something
    "set the value of the instance variable 'gids' (automatically generated)"

    gids := something.
!

machineName
    "return the value of the instance variable 'machineName' (automatically generated)"

    ^ machineName
!

machineName:something
    "set the value of the instance variable 'machineName' (automatically generated)"

    machineName := something.
!

stamp
    "return the value of the instance variable 'stamp' (automatically generated)"

    ^ stamp
!

stamp:something
    "set the value of the instance variable 'stamp' (automatically generated)"

    stamp := something.
!

uid
    "return the value of the instance variable 'uid' (automatically generated)"

    ^ uid
!

uid:something
    "set the value of the instance variable 'uid' (automatically generated)"

    uid := something.
! !

!RPCDefinitions::RPCCallHeader methodsFor:'accessing'!

cred
    "return the value of the instance variable 'cred' (automatically generated)"

    ^ cred
!

proc
    "return the value of the instance variable 'proc' (automatically generated)"

    ^ proc
!

prog
    "return the value of the instance variable 'prog' (automatically generated)"

    ^ prog
!

verf
    "return the value of the instance variable 'verf' (automatically generated)"

    ^ verf
!

vers
    "return the value of the instance variable 'vers' (automatically generated)"

    ^ vers
!

xid
    "return the value of the instance variable 'xid' (automatically generated)"

    ^ xid
!

xid:xidArg prog:progArg vers:versArg proc:procArg cred:credArg verf:verfArg
    xid := xidArg.
    prog := progArg.
    vers := versArg.
    proc := procArg.
    cred := credArg.
    verf := verfArg.
! !

!RPCDefinitions::RPCReplyHeader methodsFor:'accessing'!

acceptStatus
    "return the value of the instance variable 'acceptStatus' (automatically generated)"

    ^ acceptStatus
!

acceptStatus:something
    "set the value of the instance variable 'acceptStatus' (automatically generated)"

    acceptStatus := something.
!

replyData
    "return the value of the instance variable 'replyData' (automatically generated)"

    ^ replyData
!

replyData:something
    "set the value of the instance variable 'replyData' (automatically generated)"

    replyData := something.
!

replyStatus
    ^ replyStatus
!

replyStatus:aSymbol
    replyStatus := aSymbol
!

verf
    "return the value of the instance variable 'verf' (automatically generated)"

    ^ verf
!

xid
    "return the value of the instance variable 'xid' (automatically generated)"

    ^ xid
!

xid:xidArg verf:verfArg
    xid := xidArg.
    verf := verfArg.
! !

!RPCDefinitions class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/SunRPC_RPCDefinitions.st,v 1.12 2017-11-18 09:51:13 cg Exp $'
! !


RPCDefinitions initialize!
RPCDefinitions::RPCAuth initialize!
