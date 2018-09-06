"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

XDMAccessors subclass:#DocumentAccessor
	instanceVariableNames:'baseUri'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Sequence'
!


!DocumentAccessor methodsFor:'xdm accessors - private'!

primDmChildrenFor: xdm
    xdm children ifNil:
    [
        ^ OrderedCollection new.
    ]
    ifNotNil:
    [
        ^ xdm children.
    ].

    "Created: / 03-10-2009 / 14:13:35 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!DocumentAccessor methodsFor:'xdm setters - private'!

primDmNodeName: nodeName for: xdm
    " there is no such property"
    ^ self

    "Created: / 03-10-2009 / 13:32:16 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 06-10-2009 / 16:50:03 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!DocumentAccessor class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
