"
 COPYRIGHT (c) 2004 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libdb' }"

"{ NameSpace: SQL }"

ExternalAddress subclass:#DatabaseHandle
	instanceVariableNames:'environmentHandle parentHandle childHandleRegistry'
	classVariableNames:'GlobalAccessLock MallocError ArgumentError AttributeError
		InvalidType UnknownReturnCode UnsupportedOperation'
	poolDictionaries:''
	category:'DataBase-SQL-Framework'
!

!DatabaseHandle class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2004 by eXept Software AG
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
    This is an abstract superclass. 
    It was generalized from the OCI8 handle implementation and is now used both
    for Oracle and ODBC interfacing.


    From OCI (ORACLE) documentation:
      Almost all Oracle OCI calls include in their parameter list one or more handles. 
      A handle is an opaque pointer to a storage area allocated by the OCI library. 
      A handle may be used to store context or connection information, (e.g., an environment 
      or service context handle), or it may store information about other OCI functions 
      or data (e.g., an error or describe handle). 
      Handles can make programming easier, because the library, rather than the application, 
      maintains this data. 
      Most DB applications will need to access the information stored in handles.

    The above is valid for most (all?) database interfaces - for now, this is the common
    superclass of both ODBC- and Oracle (OCI) handles.

    [author:]
	 Stefan Vogel
	 Claus Gittinger

    [see also:]

    [instance variables:]
	parentHandle            DatabaseHandle | nil        The parent of this handle.
							    The receiver is implicitly released, when the
							    parent is released.

	environmentHandle       DatabaseHandle | nil        The (top) environment handle
	childHandleRegistry     Registry | nil              Child handles to be implicitly released, when the
							    receiver is released.

    [class variables:]
	MallocError 
	AttributeError 
	InvalidType             DatabaseReturnValues        common return-value singletons.
"
! !

!DatabaseHandle class methodsFor:'initialization'!

initialize
    GlobalAccessLock := Semaphore forMutualExclusion.
    self initializeReturnCodes.

    "
     self initialize
    "
!

initializeReturnCodes
    MallocError             := SQL::DatabaseReturnValue mallocError.
    AttributeError          := SQL::DatabaseReturnValue attributeError.
    ArgumentError           := SQL::DatabaseReturnValue argumentError.
    InvalidType             := SQL::DatabaseReturnValue invalidType.
    UnknownReturnCode       := SQL::DatabaseReturnValue unknown.
    UnsupportedOperation    := SQL::DatabaseReturnValue unsupportedOperation.

    "
     self initializeReturnCodes
    "
! !

!DatabaseHandle class methodsFor:'instance creation'!

newEnvironment:aModeSymbolColl
    "return a new environment handle"

    self subclassResponsibility
! !

!DatabaseHandle class methodsFor:'buffer handling'!

bufferForSize:aBufferSize
    "returns an external buffer of the desired size. The buffer is
     prevented from garbage collection, hence it dosent change its address and
     must be freed by the caller.

     <return: ExternalBytes>"

    ^ ExternalBytes new:aBufferSize
! !

!DatabaseHandle class methodsFor:'constants'!

numericType
    "answer the numeric value of this handle type"

    self isAbstract ifTrue:[
	^ nil.
    ].

    ^ self subclassResponsibility
! !

!DatabaseHandle class methodsFor:'error handling'!

exceptionForErrorStatus:statusSymbol code:errorCode
    "answer the Exception that is responsible for signalling the error
     with the dataBases error code errorCode"

    self subclassResponsibility
! !

!DatabaseHandle class methodsFor:'testing'!

isAbstract
    ^ self == SQL::DatabaseHandle
! !

!DatabaseHandle methodsFor:'accessing'!

environmentHandle
    ^ environmentHandle
!

environmentHandle:eH
    environmentHandle := eH.
!

environmentHandle:eH parentHandle:pH

    environmentHandle := eH.
    parentHandle := pH.
!

handle:anExternalAddress
    "sets the external address which is a oci handle.
    <return: self>"

    self setAddress:anExternalAddress address.
    self registerChange.
!

parentHandle
    "return the value of the instance variable 'parentHandle' (automatically generated)"

    ^ parentHandle
!

parentHandle:something
    "set the value of the instance variable 'parentHandle' (automatically generated)"

    parentHandle := something.
! !

!DatabaseHandle methodsFor:'comparing'!

= anExternalAddressOrDbHandle
    "return true, if two databaseHandles represent the same C pointer"

%{  /* NOCONTEXT */
    if (__isExternalAddressLike(anExternalAddressOrDbHandle)
     && (__externalAddressVal(self) == __externalAddressVal(anExternalAddressOrDbHandle))) {
	RETURN (true);
    }
%}.
    ^ false
! !

!DatabaseHandle methodsFor:'error handling'!

getInfoText
    "get the info text when SUCCES_WITH_INFO is returned"

    ^ self subclassResponsibility
!

handleError:result
    self handleError:result errorHandle:nil
!

handleError:result errorHandle:errorHandle
    self subclassResponsibility
! !

!DatabaseHandle methodsFor:'finalization'!

finalize
    "last reference to the handle is gone. Release it"

    self release.
! !

!DatabaseHandle methodsFor:'handle allocation & release'!

invalidate
    "the handle is no longer valid, e.g. because his parent handle has been released"

    self setAddress:0
!

invalidateAndUnregister
    "the handle is no longer valid, unregister with parent handle"

    self setAddress:0.
    parentHandle notNil ifTrue:[
	parentHandle unregister:self.
    ].
    environmentHandle := nil.
!

invalidateSubhandles
    "once a parentHandle is released, all subHandles are released implicitely.
     Mark them as invalid"

    |reg|

    (reg := childHandleRegistry) notNil ifTrue:[
        childHandleRegistry := nil.
        reg do:[:childHandle|
            childHandle invalidate
        ].
    ].
!

primRelease
    "really free up storage associated with a handle towards the db."

    self subclassResponsibility
!

register:aSubHandle
    "register aSubHandle.
     All subHandles are freed once the receiver is freed"

    GlobalAccessLock critical:[
        childHandleRegistry isNil ifTrue:[
            childHandleRegistry := Registry new.
        ].
        childHandleRegistry register:aSubHandle.
    ].
!

registerChange
    "some of my attributes that are used when finalizing have been changed.
     Re-register with the registry"

    parentHandle isNil ifTrue:[
        self error:'parentHandle should not be nil'
    ] ifFalse:[              
        parentHandle registerChange:self.
    ].
!

registerChange:aSubHandle
    "aSubHandle changed. Inform the registry"

    GlobalAccessLock critical:[
        childHandleRegistry isNil ifTrue:[
            childHandleRegistry := Registry new.
        ].
        childHandleRegistry registerChange:aSubHandle.
    ].
!

release
    "free up storage associated with a handle. 
     All handles may be explicitly deallocated. 
     Some database interfaces will deallocate all child handles when their parent handle 
     is deallocated (but not: ODBC)."

    |result|

    childHandleRegistry notNil ifTrue:[
        self releaseSubhandlesBeforeRelease.
    ].
    result := self primRelease.
    "this is a no-op, if result is success"
    result performErrorHandlingFor:nil statement:nil.

    parentHandle notNil ifTrue:[
        "if we have a parent, unregister from the parent"
        parentHandle unregister:self.
        parentHandle := nil.
    ].
    environmentHandle := nil.
!

releaseSubhandles
    "release all subHandles"

    |reg|

    (reg := childHandleRegistry) notNil ifTrue:[
        reg do:[:childHandle|
            childHandle release
        ].
    ].
!

releaseSubhandlesBeforeRelease
    "db libraries which deallocate all child handles when their parent handle 
     is deallocated should redefine this to invalidate subhandles (OCI).
     Those which do not, should relsease subhandles here (ODBC)."

    self subclassResponsibility
!

unregister:aSubHandle
    "aSubhandle is no longer used. Inform the registry"

    childHandleRegistry isNil ifTrue:[
        self error:'should not happen (should be already registered)'.
    ].
    GlobalAccessLock critical:[
        childHandleRegistry unregister:aSubHandle.
        childHandleRegistry isEmpty ifTrue:[
            childHandleRegistry := nil.
        ]
    ]
! !

!DatabaseHandle methodsFor:'queries'!

isAbstract
    ^ self == SQL::DatabaseHandle
!

isValid
    "a handle is valid when his address is not 0
    <return: Boolean>"

    ^ self address ~~ 0
! !

!DatabaseHandle class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/SQL__DatabaseHandle.st,v 1.26 2012-07-23 11:07:59 stefan Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/SQL__DatabaseHandle.st,v 1.26 2012-07-23 11:07:59 stefan Exp $'
! !

DatabaseHandle initialize!
