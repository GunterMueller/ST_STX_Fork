"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#LiteralsInMethodTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-RuntimeSystem'
!

!LiteralsInMethodTests class methodsFor:'documentation'!

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

!LiteralsInMethodTests methodsFor:'tested methods'!

classCheck:arg
    "only a check-method"

    (arg class == Array) ifTrue:[
	arg yourself
    ].

    "Created: / 08-08-2011 / 20:26:31 / cg"
!

methodWithStringLiteral1
    ^ 'abcd'

    "Created: / 08-08-2011 / 17:14:10 / cg"
!

methodWithStringLiteral2
    ^ 'abc'

    "Created: / 08-08-2011 / 17:14:13 / cg"
! !

!LiteralsInMethodTests methodsFor:'tests'!

test01_methodContainsLiterals
    "old stc/compiler versions did not generate literals for inlined
     sends, which made problems when quick-searching for senders (which filters
     candidate-methods using the literal array"

    |m|

    m := self class compiledMethodAt:#classCheck:.
    self assert:(m literals includes:#'==').
    self assert:(m literals includes:#'class').
    self assert:(m literals includes:#'yourself').

    "
     self run:#test01_methodContainsLiterals
     self new test01_methodContainsLiterals
    "

    "Created: / 08-08-2011 / 16:33:06 / cg"
!

test02_patternStringLiteral
"/ for now, only bytecode contains string literals - skip this.
"/    |m|
"/
"/    m := self class compiledMethodAt:#methodWithStringLiteral.

    "
     self run:#test01_methodContainsLiterals
     self new test01_methodContainsLiterals
    "

    "Created: / 08-08-2011 / 16:54:28 / cg"
! !

!LiteralsInMethodTests class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

