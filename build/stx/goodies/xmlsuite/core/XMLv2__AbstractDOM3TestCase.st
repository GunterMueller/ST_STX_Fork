"{ Package: 'stx:goodies/xmlsuite/core' }"

"{ NameSpace: XMLv2 }"

TestCase subclass:#AbstractDOM3TestCase
	instanceVariableNames:'doc foo qux'
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-Tests'
!


!AbstractDOM3TestCase class methodsFor:'accessing'!

document:aSymbol

    ^Parser forDOM3 processDocumentString:(self perform:aSymbol)

    "Created: / 05-08-2005 / 14:18:27 / janfrog"
! !

!AbstractDOM3TestCase class methodsFor:'accessing - documents'!

testDocument
    ^
'<?xml version="1.0" ?>
<!!-- This is test document -->
<?xml-stylesheet href="style.css" ?>
<foo 
    xmlns="http://www.fractal.cz/ns/xmlsuite/test"
    qux="quux">
  <bar:baz 
    xmlns:bar="http://www.fractal.cz/ns/xmlsuite/test/bar">
    quuux
  </bar:baz>
</foo>'

    "Created: / 05-08-2005 / 14:16:37 / janfrog"
! !

!AbstractDOM3TestCase class methodsFor:'testing'!

isAbstract

    ^self == AbstractDOM3TestCase

    "Created: / 05-08-2005 / 14:10:42 / janfrog"
! !

!AbstractDOM3TestCase class methodsFor:'documentation'!

version
    ^ '$Id$'
!

version_SVN
    ^ '$Id$'
! !

