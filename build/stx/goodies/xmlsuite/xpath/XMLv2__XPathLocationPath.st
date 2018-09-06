"{ Package: 'stx:goodies/xmlsuite/xpath' }"

"{ NameSpace: XMLv2 }"

Object subclass:#XPathLocationPath
	instanceVariableNames:'steps absolute'
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-XPath'
!


!XPathLocationPath methodsFor:'accessing'!

absolute
    absolute isNil ifTrue:[^false].
    ^ absolute
!

absolute:something
    absolute := something.
!

steps
    steps isNil ifTrue:[ steps := List new ].
    ^ steps.
! !

!XPathLocationPath class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/xpath/XMLv2__XPathLocationPath.st,v 1.1 2006-09-28 16:14:42 vranyj1 Exp $'
! !
