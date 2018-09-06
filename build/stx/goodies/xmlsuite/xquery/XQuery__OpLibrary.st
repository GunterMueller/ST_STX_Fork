"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

SmalltalkFunctionLibrary subclass:#OpLibrary
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Libraries'
!


!OpLibrary class methodsFor:'function library API'!

namespaceURI
    "Superclass XQuery::FunctionLibrary class says that I am responsible to implement this method"

    ^#OpNsURI.

    "Modified: / 15-10-2009 / 23:21:01 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!OpLibrary methodsFor:'function library API'!

defaultPrefix
    "Superclass XQuery::FunctionLibrary says that I am responsible to implement this method"

    ^'op'

    "Modified: / 15-10-2009 / 23:05:59 / Jan Kurs <kursj1@fel.cvut.cz>"
!

functionLocalNames
    "Superclass XQuery::FunctionLibrary says that I am responsible to implement this method"

    ^#(
        #'numeric-add'
        #'numeric-substract'
        #'numeric-multiply'
        #'numeric-divide'
        #'numeric-integer-divide'
        #'numeric-mod'
    )

    "Modified: / 24-10-2009 / 13:37:43 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!OpLibrary methodsFor:'numeric-operations'!

getNumericType: op
    (op isSubtypeOf: 'xs:float') ifTrue: [ ^ 'xs:float' ].
    (op isSubtypeOf: 'xs:double') ifTrue: [ ^ 'xs:double' ].
    (op isSubtypeOf: 'xs:integer') ifTrue: [ ^ 'xs:integer' ].
    (op isSubtypeOf: 'xs:decimal') ifTrue: [ ^ 'xs:decimal' ].

    TypeError raiseErrorString: 'not numeric type'.

    "Created: / 15-10-2009 / 23:49:44 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 30-12-2009 / 13:05:02 / Jan Kurs <kursj1@fel.cvut.cz>"
!

mapOperator: op1 to: op2
    (op1 isSubtypeOf: op2 type) ifFalse: [
        ^ self promote: op1 toType: op2 type.
    ].

    ^ op1

    "Created: / 15-10-2009 / 23:39:19 / Jan Kurs <kursj1@fel.cvut.cz>"
!

promote: op toType: typeName
    "see http://www.w3.org/TR/xpath20/#promotion"
    "Numeric type promotion:
       1. A value of type xs:float (or any type derived by restriction from xs:float) 
            can be promoted to the type xs:double. The result is the xs:double value 
            that is the same as the original value.

        2.A value of type xs:decimal (or any type derived by restriction from xs:decimal) 
            can be promoted to either of the types xs:float or xs:double. The result of 
            this promotion is created by casting the original value to the required type. 
            This kind of promotion may cause loss of precision.
    "

    (TypeFactory current isNumeric: op typeName) ifFalse: [FunctionError raiseErrorString: 'Only numeric types can be promoted'].

    ((op isSubtypeOf: 'xs:float') and: [ typeName = 'xs:double' ]) ifTrue: [
        ^ AtomicItem withValue: op nodeId asType: typeName.
    ].

    ((op isSubtypeOf: 'xs:decimal') and: [ (typeName = 'xs:double') or: [ typeName = 'xs:float'] ]) ifTrue: [
        ^ AtomicItem withValue: op nodeId asType: typeName.
    ].

    ^ op.

    "Created: / 15-10-2009 / 23:44:03 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 30-12-2009 / 13:59:48 / Jan Kurs <kursj1@fel.cvut.cz>"
!

withArg: op1 and: op2 doNumericOperation: aTwoArgBlock
    | arg1 arg2 retType |
    self assert: op1 isAtomicValue.
    self assert: op2 isAtomicValue.

    arg1 := self mapOperator: op1 to: op2.
    arg2 := self mapOperator: op2 to: op1.


    (arg2 isSubtypeOf: arg1 type) ifTrue: [
        retType := self getNumericType: arg1.
    ] ifFalse: [
        retType := self getNumericType: arg2.
    ].

    self assert: (TypeFactory isType: retType supertypeOf: (self getNumericType: arg2)).

    ^ XQuerySequence with: (AtomicItem withValue: (aTwoArgBlock value: arg1 value value: arg2 value) asType: retType)

    "Created: / 19-10-2009 / 21:39:04 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 30-12-2009 / 14:43:42 / Jan Kurs <kursj1@fel.cvut.cz>"
!

withArg: op1 and: op2 doNumericOperation: aTwoArgBlock andReturnType: retType
    | arg1 arg2 |
    self assert: op1 isAtomicValue.
    self assert: op2 isAtomicValue.

    arg1 := self mapOperator: op1 to: op2.
    arg2 := self mapOperator: op2 to: op1.

    [
        ^ XQuerySequence with: (AtomicItem withValue: 
            (aTwoArgBlock value: arg1 value value: arg2 value) asType: retType)
    ] on: Exception do:
    [
        : ex |
        ^ FunctionError raiseErrorString: ex asString.        
    ]

    "Created: / 24-10-2009 / 13:43:45 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 30-12-2009 / 14:09:33 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!OpLibrary methodsFor:'op:*'!

numericAddInContext: context withParameters: parameters forInterpreter: interpreter
    ^ self withArg: parameters first 
            and: parameters second 
            doNumericOperation: [:arg1 :arg2 | arg1 value + arg2 value ].

    "Created: / 15-10-2009 / 23:10:11 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 09-11-2009 / 16:48:58 / Jan Kurs <kursj1@fel.cvut.cz>"
!

numericDivideInContext:context withParameters:parameters forInterpreter:interpreter 
    "6.2.4 op:numeric-divide
        op:numeric-divide($arg1 as numeric, $arg2 as numeric) as numeric

        Summary: Backs up the 'div' operator and returns the arithmetic quotient of its operands: ($arg1 div $arg2).

        As a special case, if the types of both $arg1 and $arg2 are xs:integer, then the return type is xs:decimal."
    
    ((parameters first isSubtypeOf:'xs:integer') and:[ parameters second isSubtypeOf:'xs:integer' ]) 
            ifTrue:[
                ^ self 
                    withArg:parameters first
                    and:parameters second
                    doNumericOperation:[:arg1 :arg2 | arg1 / arg2 ]
                    andReturnType:'xs:decimal'
            ]
            ifFalse:[
                ^ self 
                    withArg:parameters first
                    and:parameters second
                    doNumericOperation:[:arg1 :arg2 | arg1 / arg2 ]
            ].

    "Created: / 24-10-2009 / 13:38:01 / Jan Kurs <kursj1@fel.cvut.cz>"
!

numericIntegerDivideInContext:context withParameters:parameters forInterpreter:interpreter 
    ^ self 
        withArg:parameters first
        and:parameters second
        doNumericOperation:[:arg1 :arg2 | arg1 // arg2 ]
        andReturnType:'xs:integer'

    "Created: / 24-10-2009 / 13:38:18 / Jan Kurs <kursj1@fel.cvut.cz>"
!

numericModInContext: context withParameters: parameters forInterpreter: interpreter
    ^ self withArg: parameters first 
            and: parameters second 
            doNumericOperation: [:arg1 :arg2 | arg1 \\ arg2].

    "Created: / 24-10-2009 / 13:38:24 / Jan Kurs <kursj1@fel.cvut.cz>"
!

numericMultiplyInContext: context withParameters: parameters forInterpreter: interpreter
    ^ self withArg: parameters first 
            and: parameters second 
            doNumericOperation: [:arg1 :arg2 | arg1 * arg2].

    "Created: / 19-10-2009 / 21:58:42 / Jan Kurs <kursj1@fel.cvut.cz>"
!

numericSubstractInContext: context withParameters: parameters forInterpreter: interpreter
    ^ self withArg: parameters first 
            and: parameters second 
            doNumericOperation: [:arg1 :arg2 | arg1 - arg2].

    "Created: / 19-10-2009 / 22:44:23 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!OpLibrary class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
