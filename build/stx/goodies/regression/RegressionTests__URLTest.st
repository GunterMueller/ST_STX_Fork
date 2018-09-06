"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#URLTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression'
!


!URLTest methodsFor:'testing'!

test01_fromString
    |u|

    u := URL fromString:'foo'.
    self assert:u host isNil.
    self assert:u path = 'foo'.
    self assert:u method isNil.
    self assert:u port isNil.

    u := URL fromString:'fff/'.
    self assert:u host isNil.
    self assert:u path = 'fff/'.
    self assert:u method isNil.
    self assert:u port isNil.

    u := URL fromString:'localhost:8080/'.
    self assert:u host = 'localhost'.
    self assert:u path isEmptyOrNil.
    self assert:u method isNil.
    self assert:u port = 8080.

    u := URL fromString:'http://localhost/'.
    self assert:u host = 'localhost'.
    self assert:u path isEmptyOrNil.
    self assert:u method = 'http'.

    u := URL fromString:'http://www.exept.de/'.
    self assert:u host = 'www.exept.de'.
    self assert:u path isEmptyOrNil.
    self assert:u method = 'http'.

    "
     self new test01_fromString
    "
!

test02_construct
    |u1 u2|

    u1 := URL fromString:'http://localhost/'.

    u2 := u1 construct:'subdir1'.
    self assert:u2 host = 'localhost'.
    self assert:u2 path = '/subdir1'.
    self assert:u2 method = 'http'.
    self assert:u2 port isNil.

    u2 := u1 construct:'/subdir1'.
    self assert:u2 host = 'localhost'.
    self assert:u2 path = '/subdir1'.
    self assert:u2 method = 'http'.
    self assert:u2 port isNil.

    u2 := u1 construct:'http://www.google.de:/top.html'.
    self assert:u2 host = 'www.google.de'.
    self assert:u2 path = '/top.html'.
    self assert:u2 method = 'http'.
    self assert:u2 port isNil.

    "
     self new test02_construct
    "
! !

!URLTest class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

