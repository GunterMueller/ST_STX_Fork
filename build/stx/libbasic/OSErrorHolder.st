"
 COPYRIGHT (c) 1997 by eXept Software AG / Claus Gittinger
 COPYRIGHT (c) 2017 Jan Vrany
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

Object subclass:#OSErrorHolder
	instanceVariableNames:'errorSymbol errorCategory parameter'
	classVariableNames:'Signals'
	poolDictionaries:''
	category:'OS-Support'
!

!OSErrorHolder class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997 by eXept Software AG / Claus Gittinger
 COPYRIGHT (c) 2017 Jan Vrany
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
    This class represents low level operating system errors.
    We do not use error numbers, because there may be different errnos
    for the same error on different systems.

    [instance variables:]
	errorSymbol             symbol associated with this error
	errorCategory           symbol defining the error category.
				This is in fact a symbol that returns a
				Signal when sent to myself.

	While the errorSymbol may be different on different platforms,
	the errorCategories (which refer to the Signals that will be raised)
	are identical.
	You can get an OS independent error message for an error by sending
	#errorCategoryString.

    [author:]
	Stefan Vogel

    [see also:]
	OperatingSystem
"
! !

!OSErrorHolder class methodsFor:'instance creation'!

errorSymbol:sym errorCategory:typ
    ^ self new errorSymbol:sym errorCategory:typ
!

unsupportedOperation
    ^ self new errorSymbol:'operation not supported' errorCategory:#unsupportedOperationSignal
! !

!OSErrorHolder class methodsFor:'Signal constants'!

allocRetrySignal
    ^ self signals at:#allocRetrySignal
!

badAccessorSignal
    ^ self signals at:#badAccessorSignal
!

badArgumentsSignal
    ^ self signals at:#badArgumentsSignal
!

classNotRegisteredSignal
    ^ self signals at:#classNotRegisteredSignal
!

coNotInitializedSignal
    ^ self signals at:#coNotInitializedSignal
!

defaultOsErrorSignal
    ^ self signals at:#defaultOsErrorSignal
!

existingReferentSignal
    ^ self signals at:#existingReferentSignal
!

illegalOperationSignal
    ^ self signals at:#illegalOperationSignal
!

inaccessibleSignal
    ^ self signals at:#inaccessibleSignal
!

inappropriateOperationSignal
    ^ self signals at:#inappropriateOperationSignal
!

inappropriateReferentSignal
    ^ self signals at:#inappropriateReferentSignal
!

invalidArgumentsSignal
    "return the signal for invalid arguments (e.g. right class, wrong value)."

    ^ self signals at:#invalidArgumentsSignal
!

needRetrySignal
    ^ self signals at:#needRetrySignal
!

noAggregationSignal
    ^ self signals at:#noAggregationSignal
!

noAssociationSignal
    ^ self signals at:#noAssociationSignal
!

noDataSignal
    ^ self signals at:#noDataSignal
!

noInterfaceSignal
    ^ self signals at:#noInterfaceSignal
!

noMemorySignal
    ^ self signals at:#noMemorySignal
!

noPermissionsSignal
    ^ self signals at:#noPermissionsSignal
!

noResourcesSignal
    ^ self signals at:#noResourcesSignal
!

noVerbsSignal
    ^ self signals at:#noVerbsSignal
!

nonexistentSignal
    "return the signal for non existing referents (i.e. device, file etc.)."

    ^ self signals at:#nonexistentSignal
!

notReadySignal
    ^ self signals at:#notReadySignal
!

peerFaultSignal
    ^ self signals at:#peerFaultSignal
!

rangeErrorSignal
    ^ self signals at:#rangeErrorSignal
!

signalNamed:signalName
    ^ self signals at:signalName
!

signals
    Signals isNil ifTrue:[
	self initializeSignals
    ].
    ^ Signals
!

transferFaultSignal
    ^ self signals at:#transferFaultSignal
!

transientErrorSignal
    ^ self signals at:#transientErrorSignal
!

unavailableReferentSignal
    ^ self signals at:#unavailableReferentSignal
!

underSpecifiedSignal
    ^ self signals at:#underSpecifiedSignal
!

unknownNameSignal
    ^ self signals at:#unknownNameSignal
!

unpreparedOperationSignal
    ^ self signals at:#unpreparedOperationSignal
!

unsupportedOperationSignal
    ^ self signals at:#unsupportedOperationSignal
!

volumeFullSignal
    ^ self signals at:#volumeFullSignal
!

wrongSubtypeForOperationSignal
    ^ self signals at:#wrongSubtypeForOperationSignal
! !

!OSErrorHolder class methodsFor:'accessing'!

errorSignal
    ^ OsError

    "Created: 25.1.1997 / 18:07:55 / cg"
! !

!OSErrorHolder class methodsFor:'class initialization'!

initializeSignals
    "init signals etc."

    |unavailableReferentSignal|

    Signals isNil ifTrue:[
        Signals := Dictionary new:40.

        OsNoResourcesError notifierString:'Not enough resources'.
        Signals at:#noResourcesSignal put:OsNoResourcesError.

        OsIllegalOperation notifierString:'Illegal Operation'.
        Signals at:#illegalOperationSignal put:OsIllegalOperation.

        OsInvalidArgumentsError notifierString:'Invalid Arguments'.
        Signals at:#invalidArgumentsSignal put:OsInvalidArgumentsError.

        OsInaccessibleError notifierString:'Referent inaccessible'.
        Signals at:#inaccessibleSignal put:OsInaccessibleError.

        OsTransferFaultError notifierString:'Transfer fault'.
        Signals at:#transferFaultSignal put:OsTransferFaultError.

        OsNeedRetryError notifierString:'Retry Operation'.
        Signals at:#needRetrySignal put:OsNeedRetryError.

        Signals at:#defaultOsErrorSignal put:OsError.

        "/ Information signals

"/        s := self setupSignal:#informationSignal parent:OSErrorSignal
"/                     notifier:'Information'.
"/        self setupSignal:#operationStartedSignal parent:s
"/                     notifier:'Operation started'.

        "/ Retry signals

        self setupSignal:#notReadySignal parent:OsNeedRetryError
                     notifier:' -- referent not ready'.
        self setupSignal:#transientErrorSignal parent:OsNeedRetryError
                     notifier:' -- transient error'.
        self setupSignal:#allocRetrySignal parent:OsNeedRetryError
                     notifier:' -- allocation failure'.

        "/ Resource signals

        self setupSignal:#noMemorySignal parent:OsNoResourcesError
                     notifier:' -- memory'.

        "/ Transfer faults

        self setupSignal:#noDataSignal parent:OsTransferFaultError
                     notifier:'Data unavailable/EOF reached'.
        self setupSignal:#peerFaultSignal parent:OsTransferFaultError
                     notifier:'Communication with peer failed'.
        self setupSignal:#volumeFullSignal parent:OsTransferFaultError
                     notifier:'Volume full'.

        "/ Inaccesible faults

        self setupSignal:#nonexistentSignal parent:OsInaccessibleError
                     notifier:'File does not exist'.
        unavailableReferentSignal :=
                self setupSignal:#unavailableReferentSignal parent:OsInaccessibleError
                     notifier:' currently'.
        self setupSignal:#noPermissionsSignal parent:OsInaccessibleError
                     notifier:'Permission denied'.
        self setupSignal:#existingReferentSignal parent:OsInaccessibleError
                     notifier:' -- already exists or currently in use'.
        self setupSignal:#inappropriateReferentSignal parent:OsInaccessibleError
                     notifier:' -- operation inappropriate'.

        "/ Illegal operations

        self setupSignal:#inappropriateOperationSignal parent:OsIllegalOperation
                     notifier:'Inappropriate operation'.
        self setupSignal:#wrongSubtypeForOperationSignal parent:OsIllegalOperation
                     notifier:' -- wrong subtype'.
        self setupSignal:#unsupportedOperationSignal parent:OsIllegalOperation
                     notifier:' -- on this platform'.
        self setupSignal:#unpreparedOperationSignal parent:OsIllegalOperation
                     notifier:' -- wrong sequence'.

        "/ Illegal arguments

        self setupSignal:#badArgumentsSignal parent:OsInvalidArgumentsError
                     notifier:' -- wrong class'.
        self setupSignal:#badAccessorSignal parent:OsInvalidArgumentsError
                     notifier:' -- accessor invalid'.
        self setupSignal:#rangeErrorSignal parent:OsInvalidArgumentsError
                     notifier:' -- out of range'.
        self setupSignal:#underSpecifiedSignal parent:OsInvalidArgumentsError
                     notifier:' -- operation not fully specified'.

        "/ COM errors
        self setupSignal:#coNotInitializedSignal parent:OsIllegalOperation
                     notifier:'COM not initialized'.
        self setupSignal:#noInterfaceSignal parent:unavailableReferentSignal
                     notifier:'No such interface'.
        self setupSignal:#classNotRegisteredSignal parent:unavailableReferentSignal
                     notifier:'Class not registered'.
        self setupSignal:#noAggregationSignal parent:OsIllegalOperation
                     notifier:'No Aggregation'.
        self setupSignal:#unknownNameSignal parent:unavailableReferentSignal
                     notifier:'Unknown member name'.
        self setupSignal:#noVerbsSignal parent:OsIllegalOperation
                     notifier:'No verbs for OLE object'.

        "/ Shell errors
        self setupSignal:#noAssociationSignal parent:unavailableReferentSignal
                     notifier:'No association for file extension'.
   ].

   "
    Signals := nil.
    self initializeSignals
   "
!

setupSignal:aSymbol parent:parentSignal notifier:aString
    "setup a signal, which can be retrieved by sending aSymbol to self.
     Return the new signal"

    |s|

    Signals at:aSymbol
	   put:(s := parentSignal newSignal
			notifierString:aString;
			nameClass:self message:aSymbol).
    ^ s
! !

!OSErrorHolder methodsFor:'accessing'!

errorCategory
    ^ errorCategory
!

errorSymbol
    ^ errorSymbol
!

errorSymbol:sym errorCategory:typ
    errorSymbol := sym.
    errorCategory := typ ? #defaultOsErrorSignal.
!

parameter
    ^ parameter
!

parameter:something
    parameter := something.
! !

!OSErrorHolder methodsFor:'error reporting'!

reportError
    "Report an error."
    "Delegate to the receiver's error reporter."

    <resource: #skipInDebuggersWalkBack>

    |signal|

    signal := self class signalNamed:errorCategory.
    signal
        raiseWith:self
        errorString:(parameter isNil ifTrue:[nil] ifFalse:[' - ', parameter printString])
        in:(thisContext "sender").

    "
      (OperatingSystem errorHolderForNumber:22) reportError
    "

    "Modified (format): / 30-05-2017 / 09:05:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

reportError:errorMessage
    "Report an error. Show insert errorMessage into error string."
    "Delegate to the receiver's error reporter."

    |signal|

    signal := self class signalNamed:errorCategory.
    signal
        raiseWith:self
        errorString:(self makeErrorStringFor:errorMessage)
        in:(thisContext "sender").
!

reportProceedableError
    "Report an error."
    "Delegate to the receiver's error reporter."

    |signal|

    signal := self class signalNamed:errorCategory.
    signal
        raiseRequestWith:self
        errorString:(parameter isNil ifTrue:[nil] ifFalse:[' - ', parameter printString])
        in:(thisContext "sender").

"/    ^ self errorReporter reportOn:self
!

reportProceedableError:errorMessage
    "Report an error. Show insert errorMessage into error string."
    "Delegate to the receiver's error reporter."

    |signal|

    signal := self class signalNamed:errorCategory.
    signal
        raiseRequestWith:self
        errorString:(self makeErrorStringFor:errorMessage)
        in:(thisContext "sender").
! !

!OSErrorHolder methodsFor:'others'!

description
    |s|

    s := self errorString.
    parameter notNil ifTrue:[
        ^ s,': ',parameter printString.
    ].
    ^ s

    "Modified: / 12-02-2007 / 12:29:07 / cg"
!

errorString
    ^ OperatingSystem errorStringForSymbol:errorSymbol.
! !

!OSErrorHolder methodsFor:'printing'!

printOn:aStream
    aStream
	nextPutAll:self className;
	nextPut:$(;
	nextPutAll:errorSymbol;
	nextPutAll:', ';
	nextPutAll:errorCategory;
	nextPut:$).
! !

!OSErrorHolder methodsFor:'private'!

makeErrorStringFor:aString
    "Private: compute an errorString from myself and aString"

    |errorString|

    errorString := aString ? ''.
    parameter notNil ifTrue:[
        errorString notEmpty ifTrue:[
            errorString := errorString, ': '.
        ].
        errorString := errorString, parameter printString.
    ].
    errorString notEmptyOrNil ifTrue:[
        errorString := ' - ', errorString.
    ] ifFalse:[
        errorString := nil.
    ].

    ^ errorString.
! !

!OSErrorHolder methodsFor:'testing'!

isOSErrorHolder
    ^ true
! !

!OSErrorHolder class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

