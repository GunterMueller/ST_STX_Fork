"
 COPYRIGHT (c) 2005 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"

"{ Package: 'stx:libdb/libodbc/applications' }"

"{ NameSpace: SQL }"

ApplicationModel subclass:#AdaptableApplicationModel
	instanceVariableNames:'functionalityPool'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-ODBC-Application'
!

!AdaptableApplicationModel class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2005 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!AdaptableApplicationModel class methodsFor:'functionalityNamespace'!

functionalityNamespace
    ^ #commonNamespace
! !

!AdaptableApplicationModel methodsFor:'accessing'!

functionalityPool
    ^ functionalityPool
! !

!AdaptableApplicationModel methodsFor:'accessing - functionality pool'!

functionalityPoolAt:aKey
    ^ self functionalityPoolAt:aKey ifAbsent:[^nil]
!

functionalityPoolAt:aKey ifAbsent:aBlock
    ^ functionalityPool at:aKey ifAbsent:aBlock
!

functionalityPoolAt:aKey ifAbsentPut:aBlock
    ^ functionalityPool at:aKey ifAbsentPut:aBlock
!

functionalityPoolAt:aKey put:aBlock
    ^ functionalityPool at:aKey put:aBlock
!

functionalityPoolRemoveKey:aKey 
    ^ functionalityPool removeKey:aKey 
! !

!AdaptableApplicationModel methodsFor:'adaption'!

doesNotUnderstand:aMessage
    (functionalityPool includesKey:aMessage selector) ifFalse:[
        ^ super doesNotUnderstand:aMessage
    ].
    self lazyCreateFunctionalityPoolMethodFor:aMessage.
    ^ aMessage sendTo:self.
!

lazyCreateFunctionalityPoolMethodFor:aMessage
    |s|
    s := WriteStream on:String new.
    s nextPutAll:aMessage selector.
    s cr.
    aMessage arguments size == 0 ifTrue:[
        |method|
        s nextPutAll:'    ^ (self functionalityPoolAt:#', aMessage selector, ') value'.
        method := self class compile:s contents classified:'lazy methods'.

        ^ method
    ].

    self halt.
! !

!AdaptableApplicationModel methodsFor:'initialization'!

declarePublicFunctionality
!

initialize
    masterApplication isNil ifTrue:[
        functionalityPool := Dictionary new.
    ] ifFalse:[
        functionalityPool := masterApplication functionalityPool
    ].

    self declarePublicFunctionality
!

masterApplication:aMasterApplication
    super masterApplication:aMasterApplication.
    self reinitialize.
!

reinitialize
    self undeclarePublicFunctionality.
    self initialize.
!

undeclarePublicFunctionality
! !

!AdaptableApplicationModel class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libodbc/applications/SQL__AdaptableApplicationModel.st,v 1.4 2006-07-07 11:46:52 cg Exp $'
! !
