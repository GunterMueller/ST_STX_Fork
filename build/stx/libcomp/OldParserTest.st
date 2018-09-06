"{ Package: 'stx:libcomp' }"

TestCase subclass:#OldParserTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Compiler'
!

!OldParserTest class methodsFor:'documentation'!

documentation
"
    documentation to be added.

    [author:]
        Claus Gittinger (cg@alan)

    [see also:]

    [instance variables:]

    [class variables:]
"
!

history
    "Created: / 15.5.2002 / 14:15:10 / cg"
! !

!OldParserTest methodsFor:'initialize / release'!

setUp
    "common setup - invoked before testing"

    super setUp
!

tearDown
    "common cleanup - invoked after testing"

    super tearDown
! !

!OldParserTest methodsFor:'tests'!

testSqueakExtensions1
     |rslt|

     Compiler allowSqueakExtensions:true.

     rslt := Compiler 
        evaluate:' {  }'.
     self assert:( rslt = #() ).

     rslt := Compiler 
        evaluate:' { 1 }'.
     self assert:( rslt = #(1) ).

     rslt := Compiler 
        evaluate:' { 1 . 2 }'.
     self assert:( rslt = #( 1 2 ) ).

     rslt := Compiler 
        evaluate:' { 1 . 2 . 3 }'.
     self assert:( rslt = #( 1 2 3 ) ).

     rslt := Compiler 
        evaluate:' { 1 . 2 . 3 . 4 }'.
     self assert:( rslt = #( 1 2 3 4) ).

     rslt := Compiler 
        evaluate:' { 1 . 2 . 3 . 4 . 5 }'.
     self assert:( rslt = #( 1 2 3 4 5) ).

     rslt := Compiler 
        evaluate:' { 1 . 2 . 3 . 4 . 5 . 6 }'.
     self assert:( rslt = #( 1 2 3 4 5 6) ).

     rslt := Compiler 
        evaluate:' { 1 . 2 . 3 . 4 . 5 . 6 . 7 }'.
     self assert:( rslt = #( 1 2 3 4 5 6 7) ).

     rslt := Compiler 
        evaluate:' { 1 . 2 . 3 . 4 . 5 . 6 . 7 . 8 }'.
     self assert:( rslt = #( 1 2 3 4 5 6 7 8) ).

     rslt := Compiler 
        evaluate:' { 1 . 2 . 3 . 4 . 5 . 6 . 7 . 8 . 9}'.
     self assert:( rslt = #( 1 2 3 4 5 6 7 8 9) ).

     rslt := Compiler 
        evaluate:' { 1 . 2 . 3 . 4 . 5 . 6 . 7 . 8 . 9 . 10 }'.
     self assert:( rslt = #( 1 2 3 4 5 6 7 8 9 10) ).

     rslt := Compiler 
        evaluate:' { 1 factorial. 
                     2 factorial. 
                     3 factorial. 
                     4 factorial. 
                     5 factorial. 
                     6 factorial. 
                     7 factorial. 
                     8 factorial. 
                     9 factorial. 
                    10 factorial }'.
     self assert:( rslt = (#( 1 2 3 4 5 6 7 8 9 10) collect:[:n | n factorial]) ).

     Compiler allowSqueakExtensions:false.

    "
     self run:#testSqueakExtensions
     self new testSqueakExtensions
    "
!

testSqueakExtensions2
    |rslt|

    Compiler allowSqueakExtensions:true.
    Class withoutUpdatingChangesDo:[
        self class compile:'

__test
    ^ {  
        { 1 factorial }.
        { 2 factorial }.
        { 3 factorial }.
        { 4 factorial }.
        { 5 factorial }.
        { 6 factorial }.
        { 7 factorial }.
        { 8 factorial }.
        { 9 factorial }.
        { 10 factorial }.
      }
'.
    ].

    rslt := self perform:#__test.
    self assert:( rslt = ( (1 to:10) collect:[:n | (Array with:n factorial)] ) asArray).

    Class withoutUpdatingChangesDo:[
        self class removeSelector:#__test
    ].
    Compiler allowSqueakExtensions:false.

    "
     self run:#testSqueakExtensions2
     self new testSqueakExtensions2
    "
! !

!OldParserTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcomp/OldParserTest.st,v 1.2 2002-05-15 10:52:32 cg Exp $'
! !
