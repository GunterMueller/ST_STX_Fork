"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

TestCase subclass:#XPathExpressionOptimizerTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Tests'
!


!XPathExpressionOptimizerTests methodsFor:'parsing'!

parseAndOptimize: string

    ^XPathExpressionOptimizer optimize: (XQueryParser parse: string).

    "Created: / 21-11-2007 / 10:49:20 / janfrog"
! !

!XPathExpressionOptimizerTests methodsFor:'tests - descendant-or-self'!

test_descendantOrSelf_01

    | xpath |
    xpath := self parseAndOptimize: '//test'.
    xpath := xpath queryBody.

    self assert: xpath size = 1.
    self assert: xpath first axis class == XPathAxisDescendantOrSelf.
    self assert: xpath first nodeTest class == XPathNameTest.

    "Created: / 21-11-2007 / 10:58:15 / janfrog"
    "Modified: / 12-03-2012 / 13:15:34 / Adam Senk <senkadam@gmail.com>"
!

test_descendantOrSelf_02

    | xpath |
    xpath := self parseAndOptimize: 'test1//test2'.
    xpath := xpath queryBody.

    self assert: xpath size = 2.

    self assert: xpath first axis class == XPathAxisChild.
    self assert: xpath first nodeTest class == XPathNameTest.
    self assert: xpath first nodeTest localName = 'test1'.

    self assert: xpath second axis class == XPathAxisDescendantOrSelf.
    self assert: xpath second nodeTest class == XPathNameTest.
    self assert: xpath second nodeTest localName = 'test2'.

    "Created: / 21-11-2007 / 10:59:38 / janfrog"
    "Modified: / 12-03-2012 / 13:15:10 / Adam Senk <senkadam@gmail.com>"
!

test_descendantOrSelf_03

    | xpath |
    xpath := self parseAndOptimize: '//@test2'.

     xpath := xpath  queryBody.

    self assert: xpath size = 2.

    self assert: xpath first axis class == XPathAxisDescendantOrSelf.
    self assert: xpath first nodeTest class == XQuery::XPathAnyKindTest.

    self assert: xpath second axis class == XPathAxisAttribute.
    self assert: xpath second nodeTest class == XQuery::XPathNameTest.
    self assert: xpath second nodeTest localName = 'test2'.

    "Created: / 21-11-2007 / 11:00:55 / janfrog"
    "Modified: / 12-03-2012 / 13:14:43 / Adam Senk <senkadam@gmail.com>"
! !

!XPathExpressionOptimizerTests class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
