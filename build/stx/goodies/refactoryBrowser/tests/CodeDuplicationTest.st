"{ Package: 'stx:goodies/refactoryBrowser/tests' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#CodeDuplicationTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Testing'
!

!CodeDuplicationTest class methodsFor:'documentation'!

documentation
"
    documentation to be added.

    [author:]
        cg

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!CodeDuplicationTest methodsFor:'tests'!

test01
     |m1 m2|

     m1 := RBMethod for:(RBClass named:'foo') source:'retFoo ^ foo' selector: #retFoo.
     m2 := RBMethod for:(RBClass named:'foo') source:'retFoo ^ bar' selector: #retFoo.
     self deny:( RBCodeDuplicationRule hasMethod:m1 sameSemanticAs:m2 ).

    "Created: / 05-02-2017 / 01:48:43 / cg"
!

test02
     |m1 m2|

     m1 := RBMethod for:(RBClass named:'foo') source:'retFoo:foo ^ foo' selector: #retFoo.
     m2 := RBMethod for:(RBClass named:'foo') source:'retFoo:bar ^ bar' selector: #retFoo.
     self assert:( RBCodeDuplicationRule hasMethod:m1 sameSemanticAs:m2 ).

    "Created: / 05-02-2017 / 01:51:08 / cg"
!

test02b
     |m1 m2|

     m1 := RBMethod for:(RBClass named:'foo') source:'retFoo:foo ^ foo' selector: #retFoo.
     m2 := RBMethod for:(RBClass named:'foo') source:'retFoo:foo ^ foo' selector: #retFoo.
     self assert:( RBCodeDuplicationRule hasMethod:m1 sameSemanticAs:m2 ).

    "Created: / 05-02-2017 / 02:20:38 / cg"
!

test03
     |m1 m2|

     m1 := RBMethod for:(RBClass named:'foo') source:'retFoo:foo ^ inst1' selector: #retFoo.
     m2 := RBMethod for:(RBClass named:'foo') source:'retFoo:bar ^ inst2' selector: #retFoo.
     self deny:( RBCodeDuplicationRule hasMethod:m1 sameSemanticAs:m2 ).

    "Created: / 05-02-2017 / 01:51:13 / cg"
!

test04
     |m1 m2|

     m1 := RBMethod for:(RBClass named:'foo') source:'retFoo:foo ^ inst1' selector: #retFoo.
     m2 := RBMethod for:(RBClass named:'foo') source:'retFoo:foo ^ inst2' selector: #retFoo.
     self deny:( RBCodeDuplicationRule hasMethod:m1 sameSemanticAs:m2 ).

    "Created: / 05-02-2017 / 01:51:18 / cg"
!

test05
     |m1 m2|

     m1 := RBMethod for:(RBClass named:'foo') source:'retFoo:a _:b ^ a' selector: #retFoo.
     m2 := RBMethod for:(RBClass named:'foo') source:'retFoo:a _:c ^ a' selector: #retFoo.
     self assert:( RBCodeDuplicationRule hasMethod:m1 sameSemanticAs:m2 ).

    "Created: / 05-02-2017 / 01:51:23 / cg"
!

test06
     |m1 m2|

     m1 := RBMethod for:(RBClass named:'foo') source:'retFoo:a _:b ^ a' selector: #retFoo.
     m2 := RBMethod for:(RBClass named:'foo') source:'retFoo:b _:a ^ a' selector: #retFoo.
     self deny:( RBCodeDuplicationRule hasMethod:m1 sameSemanticAs:m2 ).

    "Created: / 05-02-2017 / 01:51:28 / cg"
!

test07
     |m1 m2|

     m1 := RBMethod for:(RBClass named:'foo') source:'retFoo:a _:b ^ a' selector: #retFoo.
     m2 := RBMethod for:(RBClass named:'foo') source:'retFoo:b _:a ^ b' selector: #retFoo.
     self assert:( RBCodeDuplicationRule hasMethod:m1 sameSemanticAs:m2 ).

    "Created: / 05-02-2017 / 01:51:32 / cg"
!

test08
     |m1 m2|

     m1 := RBMethod for:(RBClass named:'foo') source:'retFoo ^ foo' selector: #retFoo.
     m2 := RBMethod for:(RBClass named:'foo') source:'retBar ^ foo' selector: #retBar.
     self assert:( RBCodeDuplicationRule hasMethod:m1 sameSemanticAs:m2 ).

    "Created: / 05-02-2017 / 01:51:36 / cg"
!

test09
     |m1 m2|

     m1 := RBMethod for:(RBClass named:'foo') source:'retFoo ^ [:foo | foo + 1]' selector: #retFoo.
     m2 := RBMethod for:(RBClass named:'foo') source:'retFoo ^ [:bar | bar + 1]' selector: #retBar.
     self assert:( RBCodeDuplicationRule hasMethod:m1 sameSemanticAs:m2 ).

    "Created: / 05-02-2017 / 01:51:42 / cg"
! !

!CodeDuplicationTest class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

