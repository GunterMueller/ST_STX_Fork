"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#MeasurementValueTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression'
!

!MeasurementValueTests class methodsFor:'documentation'!

documentation
"
    documentation to be added.

    [author:]
	cg (cg@FUSI)

    [instance variables:]

    [class variables:]

    [see also:]

"
!

history
    "Created: / 04-01-2008 / 14:16:08 / cg"
! !

!MeasurementValueTests methodsFor:'initialize / release'!

setUp
    "common setup - invoked before testing."

    super setUp
!

tearDown
    "common cleanup - invoked after testing."

    super tearDown
! !

!MeasurementValueTests methodsFor:'tests'!

test01_creation
    |m1 m2 v1|

    m1 := MeasurementValue new value:10 error:0.1.
    self assert: ( m1 value = 10 ).
    self assert: ( m1 between:9 and:11 ).
    self assert: ( m1 between:8 and:12 ).
    self assert: ( m1 between:9.5 and:11 ) not.
    self assert: ( m1 > 8 ).
    self assert: ( m1 >= 9 ).
    self assert: ( m1 <= 11 ).
    self assert: ( m1 <= 12 ).

    v1 := m1 * 10.
    self assert: ( v1 between:90 and:110 ).

    m2 := MeasurementValue new value:20 error:0.2.
    self assert: ( m2 value = 20 ).
    self assert: ( m2 between:16 and:24 ).

    "
     self run:#test01_creation
     self new test01_creation
    "
!

test02_arithmetic
    |m1 m2 v2|

    m1 := MeasurementValue new value:10 error:0.1.
    m2 := MeasurementValue new value:20 error:0.2.

    v2 := m1 + 2.
    self assert: ( v2 minValue = (9+2)  ).
    self assert: ( v2 maxValue = (11+2) ).
    self assert: ( v2 between:9+2 and:11+2 ).

    v2 := m1 - 2.
    self assert: ( v2 minValue = (9-2)  ).
    self assert: ( v2 maxValue = (11-2) ).
    self assert: ( v2 between:9-2 and:11-2 ).

    v2 := m1 * 2.
    self assert: ( v2 minValue = (9*2)  ).
    self assert: ( v2 maxValue = (11*2) ).
    self assert: ( v2 between:9*2 and:11*2 ).

    v2 := m1 / 2.
    self assert: ( v2 minValue = (9/2)  ).
    self assert: ( v2 maxValue = (11/2) ).
    self assert: ( v2 between:9/2 and:11/2 ).


    v2 := m1 + m2.
    self assert: ( v2 minValue = (9+16)  ).
    self assert: ( v2 maxValue = (11+24) ).
    self assert: ( v2 between:9+16 and:11+24 ).

    v2 := m1 - m2.
    self assert: ( v2 minValue = (9-24)  ).
    self assert: ( v2 maxValue = (11-16) ).
    self assert: ( v2 between:9-24 and:11-16 ).

    v2 := m1 * m2.
    self assert: ( v2 minValue = (9*16)  ).
    self assert: ( v2 maxValue = (11*24) ).
    self assert: ( v2 between:9*16 and:11*24 ).

    v2 := m1 / m2.
    self assert: ( v2 minValue = (9/24)  ).
    self assert: ( v2 maxValue = (11/16) ).
    self assert: ( v2 between:9/24 and:11/16 ).

    "
     self run:#test02_arithmetic
     self new test02_arithmetic
    "
!

test03_compare
    |m1 m2 m3|

    m1 := MeasurementValue new value:10 error:0.1.
    m2 := MeasurementValue new value:11 error:0.1.
    m3 := MeasurementValue new value:20 error:0.2.

    self assert: ( m1 > 8 ).
    self assert: ( m1 >= 9 ).
    self assert: ( m1 >= 10 ).
    self assert: ( m1 >= 11 ).
    self assert: ( m1 >= 12 ) not.

    self assert: ( m2 >= m1 ).
    self assert: ( m3 >= m2 ).
    self assert: ( m3 >= m1 ).

    self assert: ( m1 <= m2 ).

    "
     self run:#test03_compare
     self new test03_compare
    "
! !

!MeasurementValueTests class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

