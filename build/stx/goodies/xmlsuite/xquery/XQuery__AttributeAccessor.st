"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

XDMAccessors subclass:#AttributeAccessor
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Sequence'
!


!AttributeAccessor methodsFor:'xdm accessors - private'!

primDmAttributesFor: xdm
    ^ OrderedCollection new.

    "Created: / 06-10-2009 / 16:51:44 / Jan Kurs <kursj1@fel.cvut.cz>"
!

primDmChildrenFor: xdm
    ^ OrderedCollection new.

    "Created: / 03-10-2009 / 18:22:26 / Jan Kurs <kursj1@fel.cvut.cz>"
!

primDmStringValueFor: xdm
    ^ (self dmTypedValueFor: xdm) value asString.

    "Created: / 06-10-2009 / 18:31:44 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!AttributeAccessor class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
