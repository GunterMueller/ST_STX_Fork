"{ Package: 'stx:goodies/xmlsuite/xpath' }"

"{ NameSpace: XMLv2 }"

TestCase subclass:#XPathExpressionOptimizerTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-XPath-Tests'
!


!XPathExpressionOptimizerTests methodsFor:'parsing'!

parseAndOptimize: string

    ^XPathExpressionOptimizer optimize: (XPathParser parse: string).

    "Created: / 21-11-2007 / 10:49:20 / janfrog"
! !

!XPathExpressionOptimizerTests methodsFor:'tests - descendant-or-self'!

test_descendantOrSelf_01

    | xpath |
    xpath := self parseAndOptimize: '//test'.

    self assert: xpath size = 1.
    self assert: xpath first axis class == XPathAxisDescendantOrSelf.
    self assert: xpath first nodeTest class == XPathNameTest.

    "Created: / 21-11-2007 / 10:58:15 / janfrog"
!

test_descendantOrSelf_02

    | xpath |
    xpath := self parseAndOptimize: 'test1//test2'.

    self assert: xpath size = 2.

    self assert: xpath first axis class == XPathAxisChild.
    self assert: xpath first nodeTest class == XPathNameTest.
    self assert: xpath first nodeTest localName = 'test1'.

    self assert: xpath second axis class == XPathAxisDescendantOrSelf.
    self assert: xpath second nodeTest class == XPathNameTest.
    self assert: xpath second nodeTest localName = 'test2'.

    "Created: / 21-11-2007 / 10:59:38 / janfrog"
!

test_descendantOrSelf_03

    | xpath |
    xpath := self parseAndOptimize: '//@test2'.

    self assert: xpath size = 2.

    self assert: xpath first axis class == XPathAxisDescendantOrSelf.
    self assert: xpath first nodeTest class == XPathAnyKindTest.

    self assert: xpath second axis class == XPathAxisAttribute.
    self assert: xpath second nodeTest class == XPathNameTest.
    self assert: xpath second nodeTest localName = 'test2'.

    "Created: / 21-11-2007 / 11:00:55 / janfrog"
! !

!XPathExpressionOptimizerTests class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/xpath/XMLv2__XPathExpressionOptimizerTests.st,v 1.1 2007-11-22 21:46:50 vranyj1 Exp $'
! !
