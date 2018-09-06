"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

Object subclass:#TypeHierarchyNode
	instanceVariableNames:'children parent value'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Types'
!


!TypeHierarchyNode methodsFor:'accessing'!

children
    children ifNil: [
        children := OrderedCollection new.
    ].

    ^ children

    "Modified: / 05-11-2009 / 21:24:59 / Jan Kurs <kursj1@fel.cvut.cz>"
!

children:something
    children := something.
!

parent
    ^ parent
!

parent:something
    parent := something.
!

value
    ^ value
!

value:something
    value := something.
! !

!TypeHierarchyNode class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
