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

Object subclass:#DatabaseReturnValue
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-SQL-Framework'
!

DatabaseReturnValue subclass:#ArgumentError
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:DatabaseReturnValue
!

DatabaseReturnValue subclass:#AttributeError
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:DatabaseReturnValue
!

DatabaseReturnValue subclass:#Continue
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:DatabaseReturnValue
!

DatabaseReturnValue subclass:#Error
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:DatabaseReturnValue
!

DatabaseReturnValue subclass:#InvalidHandle
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:DatabaseReturnValue
!

DatabaseReturnValue subclass:#InvalidType
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:DatabaseReturnValue
!

DatabaseReturnValue subclass:#MallocError
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:DatabaseReturnValue
!

DatabaseReturnValue subclass:#NeedData
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:DatabaseReturnValue
!

DatabaseReturnValue subclass:#NoData
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:DatabaseReturnValue
!

DatabaseReturnValue subclass:#StillExecuting
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:DatabaseReturnValue
!

DatabaseReturnValue subclass:#Success
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:DatabaseReturnValue
!

DatabaseReturnValue subclass:#SuccessWithInfo
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:DatabaseReturnValue
!

DatabaseReturnValue subclass:#Unknown
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:DatabaseReturnValue
!

DatabaseReturnValue subclass:#UnsupportedOperation
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:DatabaseReturnValue
!

!DatabaseReturnValue class methodsFor:'documentation'!

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
! !

!DatabaseReturnValue class methodsFor:'class access'!

argumentError
    ^ ArgumentError
!

attributeError
    ^ AttributeError
!

continue
    ^ Continue
!

error
    ^ Error
!

invalidHandle
    ^ InvalidHandle
!

invalidType
    ^ InvalidType
!

mallocError
    ^ MallocError
!

needData
    ^ NeedData
!

noData
    ^ NoData
!

stillExecuting
    ^ StillExecuting
!

success
    ^ Success
!

successWithInfo
    ^ SuccessWithInfo
!

unknown
    ^ Unknown
!

unsupportedOperation
    ^ UnsupportedOperation
! !

!DatabaseReturnValue class methodsFor:'error raising'!

performErrorHandling 
    self performErrorHandlingFor:nil statement:nil.
!

performErrorHandlingFor:aHandle 
    self performErrorHandlingFor:aHandle statement:nil.
!

performErrorHandlingFor:aHandle statement:statementOrNil
    aHandle notNil ifTrue:[
        ^ aHandle performErrorHandlingFor:statementOrNil
    ].

    (SQLError newException 
        parameter:statementOrNil;
        state:nil nativeErrorCode:nil errorString:'unspecified error') raiseRequest
! !

!DatabaseReturnValue class methodsFor:'testing'!

isContinue
    ^ false
!

isError
    ^ false
!

isInvalidHandle
    ^ false
!

isNeedData
    ^ false
!

isNoData
    ^ false
!

isStillExecuting
    ^ false
!

isSuccess
    ^ false
!

isSuccessOrSuccessWithInfo
    ^ false
!

isSuccessWithInfo
    ^ false
!

isUnknown
    ^ false
! !

!DatabaseReturnValue::ArgumentError class methodsFor:'error raising'!

performErrorHandlingFor:aHandle statement:aStatementOrNil
    Smalltalk::ArgumentError raise.
! !

!DatabaseReturnValue::AttributeError class methodsFor:'error raising'!

performErrorHandlingFor:aHandle statement:aStatementOrNil
    Smalltalk::ArgumentError raiseErrorString:' (invalid attribute)'
! !

!DatabaseReturnValue::Continue class methodsFor:'testing'!

isContinue
    ^ true
! !

!DatabaseReturnValue::Error class methodsFor:'testing'!

isError
    ^ true
! !

!DatabaseReturnValue::InvalidHandle class methodsFor:'error raising'!

performErrorHandlingFor:aHandle statement:aStatementOrNil
    Smalltalk::ArgumentError raiseErrorString:' (invalid handle)'.
! !

!DatabaseReturnValue::InvalidHandle class methodsFor:'testing'!

isInvalidHandle
    ^ true
! !

!DatabaseReturnValue::InvalidType class methodsFor:'error raising'!

performErrorHandlingFor:aHandle statement:aStatementOrNil
    Smalltalk::ArgumentError raiseErrorString:' (invalid type)'.
! !

!DatabaseReturnValue::MallocError class methodsFor:'error raising'!

performErrorHandlingFor:aHandle statement:aStatementOrNil
    Smalltalk::MallocFailure raise
! !

!DatabaseReturnValue::NeedData class methodsFor:'testing'!

isNeedData
    ^ true
! !

!DatabaseReturnValue::NoData class methodsFor:'testing'!

isNoData
    ^ true
! !

!DatabaseReturnValue::StillExecuting class methodsFor:'error raising'!

performErrorHandlingFor:aHandle statement:aStatementOrNil
    Delay waitForMilliseconds:10.
    thisContext sender restart.
! !

!DatabaseReturnValue::StillExecuting class methodsFor:'testing'!

isStillExecuting
    ^ true
! !

!DatabaseReturnValue::Success class methodsFor:'error raising'!

performErrorHandlingFor:aHandle statement:aStatementOrNil
    "success, so this is a no-op"
! !

!DatabaseReturnValue::Success class methodsFor:'testing'!

isSuccess
    ^ true
!

isSuccessOrSuccessWithInfo
    ^ true
! !

!DatabaseReturnValue::SuccessWithInfo class methodsFor:'error raising'!

performErrorHandlingFor:aHandle statement:aStatementOrNil
    "success, so raise a notification with the info value"

    SQLNotification raiseRequestWith:aStatementOrNil errorString:aHandle getInfoText.
! !

!DatabaseReturnValue::SuccessWithInfo class methodsFor:'testing'!

isSuccessOrSuccessWithInfo
    ^ true
!

isSuccessWithInfo
    ^ true
! !

!DatabaseReturnValue::Unknown class methodsFor:'testing'!

isUnknown
    ^ true
! !

!DatabaseReturnValue::UnsupportedOperation class methodsFor:'error handling'!

performErrorHandlingFor:aHandle statement:statementOrNil
    Smalltalk::UnimplementedFunctionalityError raiseRequestIn:thisContext sender.
! !

!DatabaseReturnValue class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/SQL__DatabaseReturnValue.st,v 1.17 2016-02-22 09:46:02 stefan Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/SQL__DatabaseReturnValue.st,v 1.17 2016-02-22 09:46:02 stefan Exp $'
! !

