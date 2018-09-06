"{ Package: 'stx:goodies/xmlsuite/core' }"

"{ NameSpace: XMLv2 }"

TestCase subclass:#XMLBuilderTests
	instanceVariableNames:'writer outputStream'
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-Tests'
!


!XMLBuilderTests methodsFor:'tests'!

test_01

    self assert:true.

    "Honzo, tohle dopis. Porad se s Filipem, jak
    to udelat nejlepe :-)"

    "Created: / 21-11-2005 / 17:56:03 / janfrog"
    "Modified: / 29-05-2006 / 10:59:44 / janfrog"
! !

!XMLBuilderTests class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/XMLv2__XMLBuilderTests.st,v 1.2 2006-05-29 15:06:54 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !

