'From Smalltalk/X, Version:5.1.4 on 17-Nov-2003 at 11:42:10'                    !

"{ Package: 'stx:libdb/liboracle' }"

"{ NameSpace: SQL }"

Database subclass:#OCI8Environment
	instanceVariableNames:'handle modes'
	classVariableNames:'DefaultEnvironment'
	poolDictionaries:''
	category:'DataBase-Oracle-Session'
!

!OCI8Environment class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2003 by eXept Software AG
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
    This class implements an OCI environment and is the parent of all
    oci objects (handles) and cached data. Usually a single environment is sufficient,
    but more environments may be used.

    [author:]
	Stefan Vogel (stefan@zwerg)

    [instance variables:]
	handle      OCIEnvironmentHanlde    the OCI environment handle
	modes       Array of Symbols        the modes for the environment

    [class variables:]
	DefaultEnvironmentHandle            a single, default instance of myself

    [see also:]

"
! !

!OCI8Environment class methodsFor:'initialization'!

initialize
    "I implement all sorts of oracle"

    self registerForUriPrefix:'stdb:oracle:'.
    self registerForUriPrefix:'stdb:oracle8:'.
    self registerForUriPrefix:'stdb:oracle9:'.

    "
     self initialize
    "
! !

!OCI8Environment class methodsFor:'accessing'!

default
    "
     DefaultEnvironment := nil.
    "

    DefaultEnvironment isNil ifTrue:[
	ObjectMemory addDependent:self.
	DefaultEnvironment := self new modes:#(OCI_DEFAULT).
    ].
    ^ DefaultEnvironment.
!

update:anAspect with:parameter from:changedObject
    "Clear default environment when restarted from a snapshot"

    anAspect == #restarted ifTrue:[
	DefaultEnvironment := nil.
	^ self.
    ].

    ^ super update:anAspect with:parameter from:changedObject
! !

!OCI8Environment class methodsFor:'connection'!

newConnectionForUri:uriString user:userString password:passwordString
    "get a connection for a given uri"

    |url i rest|

    i := uriString indexOf:$:.
    i == 0 ifTrue:[
	self error:'bad uri'.
    ].
    rest := uriString copyFrom:i+1.
    url := URL fromString:rest.

self halt.

    "
     Database newConnectionForUri:'stdb:oracle:/test' user:'scott' password:'tiger'
     Database newConnectionForUri:'stdb:oracle:/scott@test' user:nil password:'tiger'
     Database newConnectionForUri:'stdb:oracle:/scott:tiger@test' user:nil password:nil
     Database newConnectionForUri:'stdb:oracle://db.exept.de/test' user:'scott' password:'tiger'
     Database newConnectionForUri:'stdb:oracle://db.exept.de/scott:tiger@test' user:nil password:nil
    "
! !

!OCI8Environment methodsFor:'accessing'!

handle

   handle isNil ifTrue:[
	handle := OCI8Handle newEnvironment:modes
   ].
   ^ handle
!

modes
    "return the value of the instance variable 'modes' (automatically generated)"

    ^ modes
!

modes:something
    "set the value of the instance variable 'modes' (automatically generated)"

    modes := something.
! !

!OCI8Environment methodsFor:'instance creation'!

newSession
    ^ OCI8Session newForEnvironment:self
!

newStatement:statementText
    ^ OCI8Statement newForEnvironment:self text:statementText
! !

!OCI8Environment class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/liboracle/OCI8Environment.st,v 1.5 2010-10-11 12:00:05 cg Exp $'
! !

OCI8Environment initialize!
