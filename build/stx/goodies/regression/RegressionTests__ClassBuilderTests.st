"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

ClassAndMethodCompilingTestCase subclass:#ClassBuilderTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-Compilers'
!


!ClassBuilderTests methodsFor:'tests'!

test_pools_01
    "
    Create a pool and class using that pool.
    Redefine the class __without__ that pool.
    Check, whether the pool's really gone.
    "

    | pool class |

    pool := SharedPool subclass: #MockSharedPool1
	instanceVariableNames: ''
	classVariableNames: 'PoolVar1 PoolVar2'
	poolDictionaries: ''
	category: 'System-Compiler-Mocks'.

    class := Object subclass: #MockClass
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'MockSharedPool1'
	category: 'System-Compiler-Mocks'.

    self assert: class sharedPoolNames asArray = #(MockSharedPool1).

    class := Object subclass: #MockClass
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'System-Compiler-Mocks'.

    self assert: class sharedPoolNames isEmpty.

    "Created: / 07-02-2013 / 18:00:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-05-2014 / 11:06:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_pools_02
    "
    Create a pool MockSharedPool1.
    Create a class MockClassA.
    Create a class MockClassX and its subclass MockClassY which uses pool MockSharedPool1
    Change superclass of MockClassX to MockClassA.
    Check, whether the pool in MockClassY is preserved.
    "

    | pool class |

    pool := SharedPool subclass: #MockSharedPool1
	instanceVariableNames: ''
	classVariableNames: 'PoolVar1 PoolVar2'
	poolDictionaries: ''
	category: '* Mocks *'.

    class := Object subclass: #MockClassA
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: '* Mocks *'.

    class := Object subclass: #MockClassX
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: '* Mocks *'.

    class := (Smalltalk at:#MockClassX) subclass: #MockClassY
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'MockSharedPool1'
	category: '* Mocks *'.

    self assert: (Smalltalk at:#MockClassX) superclass == Object.
    self assert: (Smalltalk at:#MockClassY) sharedPoolNames asArray = #(MockSharedPool1).

    class := (Smalltalk at:#MockClassA) subclass: #MockClassX
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: '* Mocks *'.


    self assert: (Smalltalk at:#MockClassY) superclass == (Smalltalk at:#MockClassX).
    self assert: (Smalltalk at:#MockClassX) superclass == (Smalltalk at:#MockClassA).
    self assert: (Smalltalk at:#MockClassY) sharedPoolNames asArray = #(MockSharedPool1).

    "Created: / 13-05-2014 / 11:26:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ClassBuilderTests class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

