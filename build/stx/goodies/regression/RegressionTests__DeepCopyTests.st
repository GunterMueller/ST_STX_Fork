"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#DeepCopyTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression'
!

!DeepCopyTests class methodsFor:'documentation'!

documentation
"
    documentation to be added.

    [author:]
	 (james@miraculix)

    [see also:]

    [instance variables:]

    [class variables:]
"
!

history
    "Created: / 25.10.2001 / 11:32:08 / james"
! !

!DeepCopyTests methodsFor:'helpers'!

makeBlock
    "although you cannot copy lock closures in st/x, it should at least not crash the system..."

    ^ self makeBlockHelper:[ 0 ].

    "
     self new makeBlock
    "

    "Created: / 02-08-2013 / 17:30:04 / cg"
!

makeBlockHelper:blockIn
    "although you cannot copy lock closures in st/x, it should at least not crash the system..."

    ^ #(1 2 3) at:4 ifAbsent:[^ blockIn ]

    "Created: / 02-08-2013 / 17:30:28 / cg"
! !

!DeepCopyTests methodsFor:'tests'!

testBlockCopy1
    "although you cannot copy lock closures in st/x, it should at least not crash the system..."

    |original copy|

    original := self makeBlock.
    copy := original deepCopy

    "
     self basicNew testBlockCopy1
    "

    "Created: / 02-08-2013 / 17:29:46 / cg"
!

testCopyTwoLevel
    |original copy elL1 elL2 elL3 copyOfElL1|

    original := Array new:3.
    original at:1 put:1234.
    original at:2 put:'hello'.
    original at:3 put:(elL1 := Array new:3).

    elL1 at:1 put:1234.
    elL1 at:2 put:'hello'.
    elL1 at:3 put:(elL2 := Array new:3).

    elL2 at:1 put:1234.
    elL2 at:2 put:'hello'.
    elL2 at:3 put:(elL3 := Array new:3).

    elL3 at:1 put:1234.
    elL3 at:2 put:'hello'.
    elL3 at:3 put:(Array new:3).

    copy := original copyTwoLevel.
    self assert:( (original at:2) ~~ (copy at:2) ).
    self assert:( (original at:3) ~~ (copy at:3) ).

    copyOfElL1 := copy at:3.
    self assert:( (elL1 at:2) == (copyOfElL1 at:2) ).
    self assert:( (elL1 at:3) == (copyOfElL1 at:3) ).

    "
     self basicNew testCopyTwoLevel
    "
!

testToLevel2
     |original copy elL1 elL2 elL3 copyOfElL1|

     original := Array new:3.
     original at:1 put:1234.
     original at:2 put:'hello'.
     original at:3 put:(elL1 := Array new:3).

     elL1 at:1 put:1234.
     elL1 at:2 put:'hello'.
     elL1 at:3 put:(elL2 := Array new:3).

     elL2 at:1 put:1234.
     elL2 at:2 put:'hello'.
     elL2 at:3 put:(elL3 := Array new:3).

     elL3 at:1 put:1234.
     elL3 at:2 put:'hello'.
     elL3 at:3 put:(Array new:3).

     copy := original copyToLevel:2.
     self assert:( (original at:2) ~~ (copy at:2) ).
     self assert:( (original at:3) ~~ (copy at:3) ).

     copyOfElL1 := copy at:3.
     self assert:( (elL1 at:2) == (copyOfElL1 at:2) ).
     self assert:( (elL1 at:3) == (copyOfElL1 at:3) ).

    "
     self basicNew testToLevel2
    "
!

testToLevel3
     |original copy elL1 elL2 elL3 copyOfElL1 copyOfElL2|

     original := Array new:3.
     original at:1 put:1234.
     original at:2 put:'hello'.
     original at:3 put:(elL1 := Array new:3).

     elL1 at:1 put:1234.
     elL1 at:2 put:'hello'.
     elL1 at:3 put:(elL2 := Array new:3).

     elL2 at:1 put:1234.
     elL2 at:2 put:'hello'.
     elL2 at:3 put:(elL3 := Array new:3).

     elL3 at:1 put:1234.
     elL3 at:2 put:'hello'.
     elL3 at:3 put:(Array new:3).

     copy := original copyToLevel:3.
     self assert:( (original at:2) ~~ (copy at:2) ).
     self assert:( (original at:3) ~~ (copy at:3) ).

     copyOfElL1 := copy at:3.
     self assert:( (elL1 at:2) ~~ (copyOfElL1 at:2) ).
     self assert:( (elL1 at:3) ~~ (copyOfElL1 at:3) ).

     copyOfElL2 := copyOfElL1 at:3.
     self assert:( (elL2 at:2) == (copyOfElL2 at:2) ).
     self assert:( (elL2 at:3) == (copyOfElL2 at:3) ).

    "
     self basicNew testToLevel3
    "
! !

!DeepCopyTests class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

