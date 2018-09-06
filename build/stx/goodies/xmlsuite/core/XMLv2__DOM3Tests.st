"{ Package: 'stx:goodies/xmlsuite/core' }"

"{ NameSpace: XMLv2 }"

TestCase subclass:#DOM3Tests
	instanceVariableNames:'doc'
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-Tests'
!


!DOM3Tests methodsFor:'setup'!

setUp

    super setUp.

    doc := Document new

    "Created: / 28-06-2005 / 23:24:07 / janfrog"
! !

!DOM3Tests methodsFor:'tests'!

test_createAttr

    | a |
    a := doc createAttribute:'name'.

    self assert:a nodeName = 'name'.
    self assert:a localName == nil.
    self assert:a prefix == nil.
    self assert:a namespaceURI == nil.
    self assert:a nodeValue = ''.

    "Created: / 28-06-2005 / 23:23:38 / janfrog"
!

test_createAttrNS

    | a |
    a := doc createAttribute:'q:name' ns:'ns'.

    self assert:a nodeName = 'q:name'.
    self assert:a localName = 'name'.
    self assert:a prefix = 'q'.
    self assert:a namespaceURI = 'ns'.
    self assert:a nodeValue = ''.
    self assert:a name = 'q:name'.

    "Created: / 28-06-2005 / 23:32:19 / janfrog"
!

test_createAttrNS_2

    | a |
    a := doc createAttribute:'q:name' ns:'ns'.

    self assert:a nodeName = 'name'.
    self assert:a localName = 'name'.
    self assert:a prefix == nil.
    self assert:a namespaceURI = 'ns'.
    self assert:a nodeValue = ''.
    self assert:a name = 'name'.

    "Created: / 28-06-2005 / 23:32:39 / janfrog"
! !

!DOM3Tests class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/XMLv2__DOM3Tests.st,v 1.1.1.1 2005-11-01 22:05:43 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !

