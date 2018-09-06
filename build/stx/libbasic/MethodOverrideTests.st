'From Smalltalk/X, Version:6.1.1 on 02-07-2010 at 08:40:49 AM'                  !

"{ Package: 'stx:libbasic' }"

TestCase subclass:#MethodOverrideTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Tests'
!


!MethodOverrideTests methodsFor:'initialization & release'!

tearDown

    #(methodToBeOverriden_1) do:
        [:sel|
        (self respondsTo: sel) ifTrue:
            [self class removeSelector: sel]].

    "Created: / 17-06-2009 / 19:36:10 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!MethodOverrideTests methodsFor:'tests'!

test_01

    | oldMethod newMethod |
    '"{ Package: ''stx:libbasic'' }"
    !!
    !!MethodOverridesTest methodsFor:''mock methods''!!

    methodToBeOverriden_1
        ^0
        !! !!' readStream fileIn.
    oldMethod := self class compiledMethodAt:#methodToBeOverriden_1.
    self assert: self methodToBeOverriden_1 = 0.


    '"{ Package: ''stx:goodies/sunit'' }"
    !!
    !!MethodOverridesTest methodsFor:''mock methods''!!

    methodToBeOverriden_1
        ^1
    !! !!' readStream fileIn.

    self assert: self methodToBeOverriden_1 = 1.
    newMethod := self class compiledMethodAt:#methodToBeOverriden_1.

    self assert: newMethod overridenMethod == oldMethod.

    "Created: / 17-06-2009 / 19:27:23 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!MethodOverrideTests class methodsFor:'documentation'!

version
    ^'$Id: MethodOverrideTests.st 10717 2011-10-11 15:53:59Z vranyj1 $'
! !
