"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#BinaryTreeTester
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-Collections'
!

!BinaryTreeTester class methodsFor:'documentation'!

documentation
"
    documentation to be added.

    [author:]
        Claus Gittinger (cg@alan)

    [instance variables:]

    [class variables:]

    [see also:]

"
!

history
    "Created: / 9.12.2003 / 19:34:33 / cg"
! !

!BinaryTreeTester class methodsFor:'queries'!

coveredClassNames
    ^ #( BinaryTree )

    "Created: / 06-07-2011 / 21:42:34 / cg"
! !

!BinaryTreeTester methodsFor:'initialize / release'!

setUp
    "common setup - invoked before testing."

    super setUp
!

tearDown
    "common cleanup - invoked after testing."

    super tearDown
! !

!BinaryTreeTester methodsFor:'tests'!

exhaustive_test03_removing
    |bt|

    #(10 9 8 7 6 5 4 3 2 1) permutationsDo:[:sequenceToRemoveElements |
        bt := BinaryTree new.
        bt addAll:#(1 2 3 4 5 6 7 8 9 10).

        
        sequenceToRemoveElements do:[:each |
            bt remove:each.
            self assert: ( bt includes:each ) not.
        ].
        self assert: ( bt size == 0 ).

        sequenceToRemoveElements do:[:each |
            bt add:each.
            self assert: ( bt includes:each ).
        ].
        self assert: ( bt size == 10 ).
    ].

    "
     self run:#exhaustive_test03_removing
     self new exhaustive_test03_removing
    "
!

test01_empty
    |bt|

    bt := BinaryTree new.
    self assert: ( bt size == 0 ).
    self assert: ( bt isEmpty ).
    self assert: ( bt asArray = #() ).

    "
     self run:#test01_empty
     self new test01_empty
    "
!

test02_adding
    |bt|

    bt := BinaryTree new.

    self assert: ( bt includes:1 ) not.
    self assert: ( bt includesIdentical:1 ) not.

    bt add:1.
    self assert: ( bt size == 1 ).
    self assert: ( bt notEmpty ).
    self assert: ( bt asArray = #(1) ).
    self assert: ( bt includes:1 ).
    self assert: ( bt includesIdentical:1 ).

    bt add:2.
    self assert: ( bt size == 2 ).
    self assert: ( bt asArray = #(1 2) ).

    bt addAll:#(3 4 5 6 7 8 9 10).
    self assert: ( bt size == 10 ).
    self assert: ( bt asArray = #(1 2 3 4 5 6 7 8 9 10) ).

    bt add:1.
    self assert: ( bt size == 11 ).
    self assert: ( bt asArray = #(1 1 2 3 4 5 6 7 8 9 10) ).

    "
     self run:#test02_adding
     self new test02_adding
    "

    "Modified: / 06-07-2011 / 21:48:24 / cg"
!

test03_removing
    |bt|

    bt := BinaryTree new.
    self should:[ bt remove:11111 ] raise:Error.
    self should:[ bt removeIdentical:11111 ] raise:Error.

    bt addAll:#(1 2 3 4 5 6 7 8 9 10).

    self assert: ( bt size == 10 ).
    self assert: ( bt asArray = #(1 2 3 4 5 6 7 8 9 10) ).

    self should:[ bt remove:11111 ] raise:Error.
    self should:[ bt removeIdentical:11111 ] raise:Error.

    #(4 2 1 3 5 6) do:[:toRemove |
        |t|

        bt := BinaryTree new.
        bt addAll:#(1 2 3 4 5 6 7 8 9 10).

        bt remove:toRemove.
        self assert: ( bt includes:toRemove ) not.
        self assert: ( bt size == 9 ).

        t := #(1 2 3 4 5 6 7 8 9 10) asOrderedCollection.
        t remove:toRemove.

        self assert:( bt asArray = t asArray ).
    ].

    "
     self run:#test03_removing
     self new test03_removing
    "

    "Modified: / 06-07-2011 / 21:50:16 / cg"
!

test04_addingRemoving
    |allSelectors bt|

    allSelectors := OrderedCollection new.
    Smalltalk allClassesDo:[:cls |
        cls instAndClassSelectorsAndMethodsDo:[:sel :mthd |
            allSelectors add:sel.
        ].
    ].

    bt := BinaryTree new.
    allSelectors do:[:sel |
        bt add:sel
    ].
    self assert:(bt size == allSelectors size).

    allSelectors do:[:sel |
        self assert:(bt includesIdentical:sel)
    ].

    allSelectors do:[:sel |
        bt removeIdentical:sel
    ].
    self assert:(bt isEmpty).

    "
     self run:#test04_addingRemoving
     self new test04_addingRemoving
    "
! !

!BinaryTreeTester class methodsFor:'documentation'!

version_CVS
    ^ '$Header$'
! !

