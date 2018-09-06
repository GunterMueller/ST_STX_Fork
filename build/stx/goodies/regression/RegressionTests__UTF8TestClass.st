"{ Encoding: utf8 }"

"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

Object subclass:#UTF8TestClass
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression'
!


!UTF8TestClass class methodsFor:'others'!

version_CVS
    ^ '$Header$'
! !

!UTF8TestClass methodsFor:'tests'!

someJapaneseButton
    (Button label:'日本') open

    "
     self new someJapaneseButton
    "
!

someJapaneseString
    ^ '日本'
! !

!UTF8TestClass class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

