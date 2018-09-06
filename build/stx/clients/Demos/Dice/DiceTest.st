"{ Package: 'stx:clients/Demos/Dice' }"

"{ NameSpace: CodingExamples_GUI }"

TestCase subclass:#DiceTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'demos-Dice'
!

Object subclass:#TestDependent
	instanceVariableNames:'habeUpdateErhalten'
	classVariableNames:''
	poolDictionaries:''
	privateIn:DiceTest
!

!DiceTest class methodsFor:'documentation'!

documentation
"
    documentation to be added.

    [author:]
         (cg@funkfix)

    [instance variables:]

    [class variables:]

    [see also:]

"
!

history
    "Created: / 4.12.2002 / 16:51:55 / cg"
! !

!DiceTest methodsFor:'initialize / release'!

setUp
    "common setup - invoked before testing"

    super setUp
!

tearDown
    "common cleanup - invoked after testing"

    super tearDown
! !

!DiceTest methodsFor:'tests'!

fairnessTest
    |d bag N delta|

    N := 1000.

    d := Dice new.
    bag := Bag new.

    (N*6) timesRepeat:[
        bag add:(d diceValue).
        d roll.
    ].

    100 timesRepeat:[
        delta := N/10.
        1 to:6 do:[:v |
            self assert:( (bag occurrencesOf:v) between:N-delta and:N+delta).
        ].
    ].
    
    "
     self run:#fairnessTest
    "
!

test1
    |d numbers|

    d := Dice new.
    self assert: ( d diceValue isNumber ).
    self assert: ( d diceValue between:1 and:6 ).
    d roll.
    self assert: ( d diceValue isNumber ).
    self assert: ( d diceValue between:1 and:6 ).

    numbers := OrderedCollection new.
    5 timesRepeat:[
        numbers add:(d diceValue).
        d roll.
    ].
    
    self assert:( (numbers count:[:el | el == (numbers first)]) <= 3 ).

    self fairnessTest.
    
    "
     self run:#test1
    "
!

testDependent1
    |d dep|

    d := Dice new.
    
    d addDependent:(dep := TestDependent new).
    d roll.
    self assert:( dep habeUpdateErhalten == true).
    
    "
     self run:#testDependent1
    "
! !

!DiceTest::TestDependent methodsFor:'accessing'!

habeUpdateErhalten
    "return the value of the instance variable 'habeUpdateErhalten' (automatically generated)"

    ^ habeUpdateErhalten
! !

!DiceTest::TestDependent methodsFor:'change & update'!

update:what with:aParameter from:changedObject
    habeUpdateErhalten := true.
! !

!DiceTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/Dice/DiceTest.st,v 1.1 2002-12-06 10:49:24 cg Exp $'
! !
