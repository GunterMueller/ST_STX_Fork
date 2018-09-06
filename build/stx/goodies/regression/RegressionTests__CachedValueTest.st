"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#CachedValueTest
	instanceVariableNames:'subProcesses'
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression'
!


!CachedValueTest methodsFor:'test'!

test01_validityDuration
        |cv didCompute|

        didCompute := false.
        cv := CachedValue compute:[didCompute := true. Date today dayOfWeek] validityDuration:(0.5 seconds).
        self assert:(cv isValid not).
        self assert:(didCompute not).
        self assert:(cv value = Date today dayOfWeek).
        self assert:(cv isValid).
        self assert:(didCompute).

        Delay waitForSeconds:1.
        didCompute := false.
        self assert:(cv isValid not).
        self assert:(didCompute not).
        self assert:(cv value = Date today dayOfWeek).
        self assert:(cv isValid).
        self assert:(didCompute).
!

test02_expirationTime
        |cv exceptionRaised|

        cv := CachedValue value:123 expirationTime:(Timestamp now + 0.5 seconds).
        self assert:(cv isValid).
        Delay waitForSeconds:1.
        self assert:(cv isValid not).

        exceptionRaised := false.
        CachedValue::ValueExpiredException handle:[:ex |
            exceptionRaised := true.
        ] do:[
            cv value
        ].
        self assert:exceptionRaised.
! !

!CachedValueTest class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

