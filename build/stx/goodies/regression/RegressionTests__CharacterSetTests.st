"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#CharacterSetTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-Collections'
!


!CharacterSetTests methodsFor:'tests'!

test01_creation
    |s|

    s := CharacterSet new.
    self assert:(s isEmpty).
    self assert:(s size == 0).
    self assert:(s notEmpty) not.

    s := CharacterSet allSingleByteCharacters.
    self assert:(s includesAll:((Character value:0) to:(Character value:255))).
    self assert:(s isEmpty) not.
    self assert:(s size == 256).
    self assert:(s notEmpty).

    s := CharacterSet separators.
    self assert:(s includesAll:(Character separators)).
    self assert:(s size == Character separators size).

    s := CharacterSet nonSeparators.
    self assert:(s includesAny:(Character separators)) not.
    self assert:(s size == (256 - Character separators size)).

    s := CharacterSet separators.
    self assert:(s complement = CharacterSet nonSeparators).
!

test02_addRemove
    |s|

    s := CharacterSet new.
    self assert:(s size == 0).
    self assert:(s includes:(Character value:10)) not.
    self assert:(s includes:(Character value:9)) not.
    self assert:(s includes:(Character value:11)) not.

    self assert:(s includes:(Character value:99)) not.
    self assert:(s includes:(Character value:300)) not.

    s add:(Character value:10).
    self assert:(s size == 1).
    self assert:(s includes:(Character value:10)).
    self assert:(s includes:(Character value:9)) not.
    self assert:(s includes:(Character value:11)) not.

    s remove:(Character value:11) ifAbsent:[].
    self assert:(s size == 1).
    self assert:(s includes:(Character value:10)).
    self assert:(s includes:(Character value:9)) not.
    self assert:(s includes:(Character value:11)) not.

    s remove:(Character value:10).
    self assert:(s size == 0).
    self assert:(s includes:(Character value:10)) not.
    self assert:(s includes:(Character value:9)) not.
    self assert:(s includes:(Character value:11)) not.

    "Created: / 28-01-2011 / 17:41:18 / cg"
!

test03_copy
    |orig copy|

    orig := CharacterSet newFrom:'abc'.
    copy := orig copy.
    copy remove:$a.

    self assert:(orig includes:$a) message:'changing the copy should not change original'.
!

test04_comparing
    |orig copy|

    orig := CharacterSet newFrom:'abc'.
    copy := orig copy.

    self assert:(orig = copy).
    self assert:(orig ~= copy) not.
    self assert:(orig hash = copy hash).

    orig add:$d.
    self assert:(orig = copy) not.
    self assert:(orig ~= copy).
    self assert:(orig hash ~= copy hash).

    orig remove:$d.
    self assert:(orig = copy).
    self assert:(orig ~= copy) not.
    self assert:(orig hash = copy hash).
! !

!CharacterSetTests class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

