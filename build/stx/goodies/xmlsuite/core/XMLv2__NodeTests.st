"{ Package: 'stx:goodies/xmlsuite/core' }"

"{ NameSpace: XMLv2 }"

AbstractDOM3TestCase subclass:#NodeTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-Tests'
!


!NodeTests methodsFor:'initialize / release'!

setUp
    "common setup - invoked before testing."

    super setUp.
    doc := self class document:#testDocument.
    foo := doc childNodes detect:[:node| node isElement].
    qux := foo attributes detect:[:attr| attr localName = 'qux'].

    "Created: / 05-08-2005 / 14:25:53 / janfrog"
!

tearDown
    "common cleanup - invoked after testing."

    super tearDown

    "Created: / 05-08-2005 / 14:25:53 / janfrog"
! !

!NodeTests methodsFor:'tests'!

test_parent1

    self assert:foo parent == doc.
    self assert:qux parent == nil.

    "Created: / 05-08-2005 / 14:32:15 / janfrog"
! !

!NodeTests class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/XMLv2__NodeTests.st,v 1.1.1.1 2005-11-01 22:05:52 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !

