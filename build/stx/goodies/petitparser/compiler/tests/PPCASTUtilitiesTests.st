"{ Package: 'stx:goodies/petitparser/compiler/tests' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#PPCASTUtilitiesTests
	instanceVariableNames:''
	classVariableNames:'SomeClassVariable'
	poolDictionaries:''
	category:'PetitCompiler-Tests-Support'
!


!PPCASTUtilitiesTests methodsFor:'methods under test'!

methodSimple1
    ^ 1

    "Created: / 27-07-2015 / 13:27:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

methodWithArguments: arg1
    (arg1 + 4) yourself isOdd ifTrue:[ 
        ^ true
    ].
    ^ false not.

    "Created: / 27-07-2015 / 13:35:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

methodWithClassReference
    ^ PPCASTUtilities new

    "Created: / 27-07-2015 / 13:28:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

methodWithClassVariableReference
    ^ SomeClassVariable

    "Created: / 27-07-2015 / 14:02:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

methodWithInstanceVariableReference
    ^ testSelector

    "Created: / 27-07-2015 / 13:29:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

methodWithSelfSend1
    ^ self methodSimple1

    "Created: / 27-07-2015 / 13:28:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

methodWithSelfSend2
    ^ self methodWithSelfSend1

    "Created: / 27-07-2015 / 13:34:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

methodWithSelfSend3
    ^ self methodWithInstanceVariableReference

    "Created: / 27-07-2015 / 14:01:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

methodWithSuperSend
    ^ super yourself

    "Created: / 27-07-2015 / 14:02:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

methodWithTemporaries
    | tmp1 |

    tmp1 := 3.
    (tmp1 + 4) yourself isOdd ifTrue:[ 
        | tmp2 |

        tmp2 := tmp1 + 1.
        ^ tmp1 + tmp2.
    ].
    ^ tmp1

    "Created: / 27-07-2015 / 13:33:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCASTUtilitiesTests methodsFor:'tests'!

test_checkNodeIsFunctional_1
    self shouldnt: [ PPCASTUtilities new checkNodeIsFunctional: (self class >> #methodSimple1) parseTree inClass: self class ]
            raise: PPCCompilationError.
    self shouldnt: [ PPCASTUtilities new checkNodeIsFunctional: (self class >> #methodWithSelfSend1) parseTree inClass: self class ]
            raise: PPCCompilationError.
    self shouldnt: [ PPCASTUtilities new checkNodeIsFunctional: (self class >> #methodWithSelfSend2) parseTree inClass: self class ]
            raise: PPCCompilationError.
    self shouldnt: [ PPCASTUtilities new checkNodeIsFunctional: (self class >> #methodWithClassReference) parseTree inClass: self class ]
            raise: PPCCompilationError.
    self shouldnt: [ PPCASTUtilities new checkNodeIsFunctional: (self class >> #methodWithTemporaries) parseTree inClass: self class ]
            raise: PPCCompilationError.
    self shouldnt: [ PPCASTUtilities new checkNodeIsFunctional: (self class >> #methodWithArguments:) parseTree inClass: self class ]
            raise: PPCCompilationError.

    "Created: / 27-07-2015 / 14:00:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_checkNodeIsFunctional_2
    self should: [ PPCASTUtilities new checkNodeIsFunctional: (self class >> #methodWithInstanceVariableReference) parseTree inClass: self class ]
         raise: PPCCompilationError.
    self should: [ PPCASTUtilities new checkNodeIsFunctional: (self class >> #methodWithClassVariableReference) parseTree inClass: self class ]
         raise: PPCCompilationError.
    self should: [ PPCASTUtilities new checkNodeIsFunctional: (self class >> #methodWithSelfSend3) parseTree inClass: self class ]
         raise: PPCCompilationError.
    self should: [ PPCASTUtilities new checkNodeIsFunctional: (self class >> #methodWithSuperSend) parseTree inClass: self class ]
         raise: PPCCompilationError.

    "Created: / 27-07-2015 / 14:00:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCASTUtilitiesTests class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

