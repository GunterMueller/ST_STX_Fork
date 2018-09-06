"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCPassVisitor subclass:#PPCCheckingVisitor
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Visitors'
!

!PPCCheckingVisitor methodsFor:'visiting'!

beforeAccept: node
    | message |

    message := node check.
    message notNil ifTrue:[ self error: message ].       
    ^node

    "Created: / 07-09-2015 / 13:05:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

