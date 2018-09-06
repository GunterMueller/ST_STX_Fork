"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#ClassDescriptionTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression'
!


!ClassDescriptionTests methodsFor:'tests'!

test_removeInstVarName_01
    | pool class |

    [

    pool := SharedPool subclass: #NewSharedPool1
	instanceVariableNames: ''
	classVariableNames: 'PoolVar1 PoolVar2'
	poolDictionaries: ''
	category: 'System-Compiler-Mocks'.

    class := Object subclass: #NewClass
	instanceVariableNames: 'instVar1'
	classVariableNames: ''
	poolDictionaries: 'NewSharedPool1'
	category: 'System-Compiler-Mocks'.

    self assert: (Smalltalk at:#NewClass)  instVarNames asArray = #(instVar1).
    self assert: (Smalltalk at:#NewClass) sharedPoolNames asArray = #(NewSharedPool1).

    class removeInstVarName: #instVar1.

    self assert: (Smalltalk at:#NewClass) instVarNames asArray = #().
    self assert: (Smalltalk at:#NewClass) sharedPoolNames asArray = #(NewSharedPool1).

    ] ensure:[
	Smalltalk removeClass: (Smalltalk at:#NewSharedPool1); removeClass: (Smalltalk at:#NewClass).
    ]

    "Created: / 10-07-2013 / 14:04:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ClassDescriptionTests class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

