"
 COPYRIGHT (c) 2012 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic2' }"

Object subclass:#CachedValue
	instanceVariableNames:'value expirationTime computation validityDuration'
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Processes'
!

NotFoundError subclass:#ValueExpiredException
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:CachedValue
!

!CachedValue class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2012 by eXept Software AG
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
    Instances of CachedValue can be used for values which are costly to evaluate,
    but which can be cached for some time. 
    For example, when asking a source code repository for the set of symbolic names,
    this query takes a few seconds (a CVS roundtrip). However, this information can easily
    be cached and remembered for some time (say 30seconds or so), to speed up followup
    repository operations.
    You may find more similar uses of this class.

    [author:]
        Claus Gittinger

    [instance variables:]
        value ..................... the computed (cached value)
        expirationTime ............ timeStamp, when this value becomes obsolete
        validDuration ............. timeDuration, how long a computed value remains valid
        computation ............... a computation block, to recompute the value.

    [class variables:]

    [see also:]

"
!

examples
"
                                                                        [exBegin]
        |cv exceptionRaised didCompute|

        didCompute := false.
        cv := CachedValue compute:[didCompute := true. Date today dayOfWeek] validityDuration:(2 seconds).
        self assert:(cv isValid not).
        self assert:(didCompute not).
        self assert:(cv value = Date today dayOfWeek).
        self assert:(cv isValid).
        self assert:(didCompute).

        Delay waitForSeconds:3.
        didCompute := false.
        self assert:(cv isValid not).
        self assert:(didCompute not).
        self assert:(cv value = Date today dayOfWeek).
        self assert:(cv isValid).
        self assert:(didCompute).
                                                                        [exEnd]
                                                                        [exBegin]
        |cv exceptionRaised|

        cv := CachedValue value:123 expirationTime:(Timestamp now + 2 seconds).
        self assert:(cv isValid).
        Delay waitForSeconds:3.
        self assert:(cv isValid not).

        exceptionRaised := false.
        ValueExpiredException handle:[:ex |
            exceptionRaised := true.
        ] do:[
            cv value
        ].
        self assert:exceptionRaised.
                                                                        [exEnd]
"
! !

!CachedValue class methodsFor:'instance creation'!

compute:actionBlock validityDuration:aTimeduration
    "return a 'self computing' cachedvalue, which ceases to be valid aTimeduration after
     it has computed its value. 
     If asked again for a value, it will automatically recompute the value."

    ^ self new 
        compute:actionBlock validityDuration:aTimeduration
!

value:valueArg expirationTime:aTimestamp
    "return a 'one shot' cachedValue, which ceases to be valid at expirationTime.
     If asked for the value after that, an exception is raised
     (i.e. it does not automatically recompute a value)"

    ^ self new 
        value:valueArg expirationTime:aTimestamp
! !

!CachedValue methodsFor:'accessing'!

compute:computationBlock validityDuration:aTimeduration
    computation := computationBlock.
    validityDuration := aTimeduration
!

expirationTime:something
    expirationTime := something.
!

value
    "return my value. If not yet computed or expired, recompute using the computation block.
     Otherwise return the cacehdValue"

    self isValid ifFalse:[
        validityDuration isNil ifTrue:[
            ValueExpiredException raiseRequestWith:self.
            ^ nil
        ].
        self computeCachedValue.
    ].
    ^ value
!

value:valueArg expirationTime:aTimestamp
    value := valueArg.
    expirationTime := aTimestamp
!

valueOrIfInvalid:exceptionalValue
    "return my value, if valid. Otherwise, return the value from exceptionalValue."

    self isValid ifFalse:[^ exceptionalValue value].
    ^ value
! !

!CachedValue methodsFor:'private'!

computeCachedValue
    expirationTime := Timestamp now + validityDuration.
    value := computation value.
! !

!CachedValue methodsFor:'queries'!

isValid
    "true if the cached value is still valid"

    expirationTime notNil ifTrue:[
        expirationTime > Timestamp now ifTrue:[
            ^ true
        ].
        expirationTime := nil.
    ].
    ^ false
! !

!CachedValue::ValueExpiredException class methodsFor:'documentation'!

documentation
"
    raised when a cachedValue has expired
"
! !

!CachedValue::ValueExpiredException class methodsFor:'initialization'!

initialize
    NotifierString := 'value expired'.
! !

!CachedValue class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic2/CachedValue.st,v 1.3 2012-11-02 17:14:56 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic2/CachedValue.st,v 1.3 2012-11-02 17:14:56 cg Exp $'
! !

CachedValue::ValueExpiredException initialize!
