"{ Package: 'stx:goodies/xmlsuite/core' }"

"{ NameSpace: XMLv2 }"

TestCase subclass:#NodeNameTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-Tests'
!


!NodeNameTests methodsFor:'tests'!

test_get_qualifiedName

    | nn |
    nn := NodeName new 
            ns:'namespace'; 
            prefix:'q';
            localName:'n'.

    self assert:(nn qualifiedName = 'q:n').

    nn := NodeName new 
            ns:'namespace'; 
            localName:'n'.

    self assert:(nn qualifiedName = 'n').

    nn := NodeName new 
            ns:'namespace'; 
            prefix:'q'.

    self should:[nn qualifiedName] raise:DOMException

    "Created: / 28-06-2005 / 23:05:27 / janfrog"
!

test_set_qualifiedName

    | nn |
    nn := NodeName new .

    nn qualifiedName:'q:n'.
    self assert:(nn localName = 'n').
    self assert:(nn prefix = 'q').

    nn qualifiedName:'q:q:n'.
    self assert:(nn localName = 'n').
    self assert:(nn prefix = 'q:q').

    self should:[nn qualifiedName:':n'] raise:DOMException.
    self should:[nn qualifiedName:'q:'] raise:DOMException.

    "Created: / 28-06-2005 / 23:10:43 / janfrog"
! !

!NodeNameTests class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/XMLv2__NodeNameTests.st,v 1.1.1.1 2005-11-01 22:05:52 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !

